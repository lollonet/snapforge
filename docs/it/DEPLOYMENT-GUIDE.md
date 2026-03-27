<p align="center">
  <img src="../../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Guida al Deployment di SnapForge

Guida completa per il deployment di un sistema audio multiroom SnapForge.

## Prerequisiti

### Requisiti Server

| Componente | Minimo | Raccomandato |
|------------|--------|--------------|
| CPU | 2 core | 4 core |
| RAM | 1 GB | 2 GB |
| Storage | 1 GB + musica | SSD raccomandato |
| Rete | 100 Mbps | Gigabit |
| OS | Linux (Docker) | Ubuntu 22.04+ / Debian 12+ |

### Requisiti Client (Raspberry Pi)

| Componente | Minimo | Raccomandato |
|------------|--------|--------------|
| Modello | RPi 3B | RPi 4 (2GB+) |
| Storage | 8 GB SD | 16 GB+ SD |
| Rete | WiFi | Ethernet (più stabile) |
| Audio | DAC USB | HAT I2S (qualità migliore) |

### Requisiti di Rete

- Tutti i dispositivi sulla stessa subnet (o routing con multicast)
- Porte 1704, 1705, 1780, 6600 accessibili
- mDNS/Bonjour funzionante (porta 5353 UDP)

## Fase 1: Deployment del Server (snapMULTI)

Segui la **[guida all'installazione di snapMULTI](https://github.com/lollonet/snapMULTI#quick-start)** — plug-and-play per Raspberry Pi, oppure setup manuale Docker su qualsiasi macchina Linux.

### Verifica il Server

Dopo il deployment, conferma che il server funziona:

```bash
# Servizi attivi
docker ps

# Advertisement mDNS
avahi-browse -r _snapcast._tcp --terminate

# API JSON-RPC risponde
curl -s http://localhost:1780/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq

# MPD accessibile
mpc status
```

## Fase 2: Deployment dei Client (rpi-snapclient-usb)

Segui la **[guida al setup di rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb#zero-touch-auto-install-recommended)** — auto-installazione zero-touch (raccomandata) o script interattivo. Supporta 11 HAT audio e DAC USB.

### Verifica la Connessione del Client

```bash
# Controlla se connesso al server
docker ps   # snapclient dovrebbe essere attivo

# Sul server, verifica che il client appaia
curl -s http://localhost:1780/jsonrpc \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq '.result.server.groups[].clients'
```

## Fase 3: Controlla il tuo Sistema

### Interfaccia Web Integrata (disponibile ora)

Apri `http://<ip-server>:1780` in qualsiasi browser per gestire diffusori, cambiare sorgente e regolare il volume.

### App Native (disponibili presto)

**SnapCTRL** (controller desktop) e **SnapClient iOS/Android** (mobile) sono disponibili presto — vedi [App Native](../README.it.md#app-native--disponibili-presto).

## Checklist di Verifica

### Server

- [ ] Container Docker attivi (`docker ps`)
- [ ] Snapserver in ascolto su 1704, 1705, 1780 (`ss -tlnp | grep -E "1704|1705|1780"`)
- [ ] MPD in ascolto su 6600 (`ss -tlnp | grep 6600`)
- [ ] Servizi mDNS pubblicati (`avahi-browse -r _snapcast._tcp`)
- [ ] Database musicale indicizzato (`mpc stats`)

### Client

- [ ] Servizio snapclient attivo (`systemctl status snapclient`)
- [ ] Connesso al server (controlla i log del server)
- [ ] Output audio funzionante (`speaker-test -t wav -c 2`)
- [ ] Dispositivo audio corretto selezionato (`aplay -l`)

### Controller

- [ ] Può connettersi al server
- [ ] Mostra tutti i gruppi e client
- [ ] Controllo volume funzionante
- [ ] Controllo mute funzionante

## Test dell'Audio

### Riproduci un Tono di Test

```bash
# Sul server, via MPD
mpc add http://www.hochmuth.com/mp3/Haydn_Cello_Concerto_D-1.mp3
mpc play
```

### Stream via Input TCP

```bash
# Stream radio internet
ffmpeg -i http://stream.radioparadise.com/flac \
  -f s16le -ar 48000 -ac 2 \
  tcp://192.168.1.100:4953
```

### Test AirPlay

1. Su iPhone/iPad, apri il Centro di Controllo
2. Tocca l'icona AirPlay
3. Seleziona "Snapcast"
4. Riproduci musica da qualsiasi app

## Troubleshooting

### Nessun Audio sul Client

```bash
# Controlla i dispositivi ALSA
aplay -l

# Testa la riproduzione diretta
speaker-test -t wav -c 2 -D hw:0,0

# Controlla il dispositivo di output di snapclient
snapclient --list
```

### Il Client Non Trova il Server

```bash
# Testa la connessione diretta
snapclient --host 192.168.1.100

# Controlla il firewall sul server
sudo ufw status
sudo ufw allow 1704/tcp
sudo ufw allow 1780/tcp
```

### mDNS Non Funziona

```bash
# Sul server
avahi-browse -a --terminate

# Controlla il daemon Avahi
systemctl status avahi-daemon

# Riavvia se necessario
sudo systemctl restart avahi-daemon
```

### Audio che Salta

1. Aumenta il buffer: Modifica `snapserver.conf`, imposta `buffer = 1500`
2. Usa Ethernet cablato invece del WiFi
3. Controlla la congestione di rete
4. Riduci il numero di client simultanei

## Raccomandazioni per la Produzione

### Sicurezza

```bash
# Limita solo alla rete locale
sudo ufw default deny incoming
sudo ufw allow from 192.168.1.0/24 to any port 1704
sudo ufw allow from 192.168.1.0/24 to any port 1705
sudo ufw allow from 192.168.1.0/24 to any port 1780
sudo ufw allow from 192.168.1.0/24 to any port 6600
sudo ufw enable
```

### Monitoraggio

```bash
# Aggiungi al crontab per health check
*/5 * * * * curl -sf http://localhost:1780/jsonrpc -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' || systemctl restart snapserver
```

### Backup della Configurazione

```bash
# Script di backup
tar -czf snapforge-backup-$(date +%Y%m%d).tar.gz \
  /percorso/snapMULTI/.env \
  /percorso/snapMULTI/snapserver.conf \
  /percorso/snapMULTI/mpd/
```

### Auto-Start all'Avvio

I container del server sono configurati con `restart: unless-stopped` in docker-compose.

Per i client:

```bash
sudo systemctl enable snapclient
```

## Prossimi Passi

1. [Aggiungi altri client](#fase-2-deployment-dei-client-rpi-snapclient-usb)
2. [Configura i gruppi via SnapCTRL](#fase-3-setup-del-controller-snapctrl)
3. [Configura il controllo mobile con app MPD](https://github.com/lollonet/snapMULTI#control-mpd)
4. [Esplora configurazioni avanzate](ARCHITECTURE.md)
