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
- Porte 1704, 1780, 6600 accessibili
- mDNS/Bonjour funzionante (porta 5353 UDP)

## Fase 1: Deployment del Server (snapMULTI)

### Step 1: Preparare l'Host

```bash
# Installa Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Installa Avahi (per mDNS)
sudo apt update
sudo apt install -y avahi-daemon avahi-utils

# Verifica che Avahi sia attivo
systemctl status avahi-daemon
```

### Step 2: Clona e Configura

```bash
# Clona il repository
git clone https://github.com/lollonet/snapMULTI.git
cd snapMULTI

# Copia il template dell'environment
cp .env.example .env
```

### Step 3: Modifica la Configurazione

Modifica `.env` con le tue impostazioni:

```bash
# Percorsi libreria musicale sull'host
MUSIC_LOSSLESS_PATH=/home/utente/Musica/FLAC
MUSIC_LOSSY_PATH=/home/utente/Musica/MP3

# IP del server (per la connessione dei client)
SERVER_IP=192.168.1.100

# Fuso orario
TZ=Europe/Rome
```

### Step 4: Avvia i Servizi

```bash
# Avvia lo stack
docker compose up -d

# Verifica che i servizi siano attivi
docker ps

# Controlla i log
docker logs snapserver
docker logs mpd
```

### Step 5: Verifica il Server

```bash
# Testa l'advertisement mDNS
avahi-browse -r _snapcast._tcp --terminate

# Testa l'API JSON-RPC
curl -s http://localhost:1780/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq

# Testa MPD
mpc status
```

### Step 6: Aggiorna il Database Musicale

```bash
# Avvia l'aggiornamento del database MPD
printf 'update\n' | nc localhost 6600

# Monitora il progresso
watch -n1 'printf "status\n" | nc localhost 6600 | grep updating'
```

## Fase 2: Deployment dei Client (rpi-snapclient-usb)

### Opzione A: Setup Automatizzato (Raccomandato)

```bash
# Sul Raspberry Pi
git clone https://github.com/lollonet/rpi-snapclient-usb.git
cd rpi-snapclient-usb

# Esegui il setup interattivo
./scripts/setup.sh

# Segui i prompt per:
# 1. Selezionare il tuo HAT audio
# 2. Configurare la connessione al server
# 3. Impostare il nome del client
```

### Opzione B: Setup con Docker

```bash
# Su Raspberry Pi con Docker installato
docker run -d \
  --name snapclient \
  --device /dev/snd \
  --network host \
  -e SNAPSERVER=192.168.1.100 \
  lollonet/snapclient:latest
```

### Opzione C: Installazione Nativa

```bash
# Installa snapclient
sudo apt update
sudo apt install -y snapclient

# Configura
sudo nano /etc/default/snapclient

# Imposta: SNAPCLIENT_OPTS="--host 192.168.1.100 --hostID soggiorno"

# Abilita e avvia
sudo systemctl enable snapclient
sudo systemctl start snapclient
```

### Configurazione HAT Audio

Per gli HAT audio I2S, aggiungi a `/boot/config.txt`:

```ini
# HiFiBerry DAC+
dtoverlay=hifiberry-dacplus

# HiFiBerry Digi+
dtoverlay=hifiberry-digi

# IQaudio DAC+
dtoverlay=iqaudio-dacplus

# Allo Boss
dtoverlay=allo-boss-dac-pcm512x-audio

# JustBoom DAC
dtoverlay=justboom-dac
```

Poi riavvia:

```bash
sudo reboot
```

### Verifica la Connessione del Client

```bash
# Controlla se è connesso al server
journalctl -u snapclient -f

# Sul server, verifica che il client appaia
curl -s http://localhost:1780/jsonrpc \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq '.result.server.groups[].clients'
```

## Fase 3: Setup del Controller (SnapCTRL)

### Installazione

```bash
# Clona il repository
git clone https://github.com/lollonet/snapctrl.git
cd snapctrl

# Installa con uv (raccomandato)
uv pip install -e .

# Oppure con pip
pip install -e .
```

### Esecuzione

```bash
# Avvia la GUI
python -m snapctrl

# Oppure se installato globalmente
snapctrl
```

### Configurazione

Al primo avvio:
1. Inserisci l'IP del server (es. `192.168.1.100`)
2. Inserisci la porta (default: `1780`)
3. Clicca Connetti

## Checklist di Verifica

### Server

- [ ] Container Docker attivi (`docker ps`)
- [ ] Snapserver in ascolto su 1704, 1780 (`ss -tlnp | grep -E "1704|1780"`)
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
