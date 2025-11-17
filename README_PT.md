# SVXLinkBuilder — Guia em Português (PT-PT)

Este documento fornece instruções completas em Português de Portugal para instalação e configuração do **SVXLinkBuilder** num Raspberry Pi, criando um nó **Hotspot** ou **Repetidor** com suporte para **SvxReflector**, **EchoLink**, **MetarInfo** e outras opções.

---
## 📌 Introdução
O SVXLinkBuilder instala automaticamente um sistema SVXLink totalmente funcional baseado em Debian 12 (Bookworm). A compilação atual liga-se apenas ao **svxportal-uk (SvxReflector)**. A ligação permite comunicação com outros nós e repetidores através de *pseudo-talkgroups*.

Para informações adicionais: <http://portal.svxlink.uk:81>

Esta compilação inclui um **timeout automático de 3 minutos** para utilizadores RF, emitindo tons de aviso quando o tempo é excedido.

---
## 📡 Compatibilidade com SA818, uSvxCard, uDraCard e RF-Guru
Durante a instalação é possível programar módulos SA818. Para utilizadores de:
- **uSvxCard + uDraCard (F8ASB)**
- **Guru-RF Hotspot**

… existem passos adicionais descritos abaixo.

---
## 🧰 Requisitos
- Raspberry Pi (qualquer modelo)
- Placa de som USB (CM108 recomendada)
- Interface GPIO ou USB modificada
- 1 ou 2 transceivers
- Raspberry Pi OS **Bookworm Lite 32-bit**
- A experiência com shell ajuda, mas não é obrigatória

> ⚠️ O utilizador **deve** ser `pi` — obrigatório para evitar falhas.

---
## 📥 Preparação do Cartão SD
1. Usar Raspberry Pi Imager
2. Selecionar **Raspberry Pi OS (32-bit) Lite – Bookworm**
3. Configurar:
   - Username: **pi** (obrigatório)
   - Password à escolha
   - SSH ativado
   - Wi-Fi opcional

Depois de arrancar:
```bash\sudo apt update && sudo apt upgrade -y
sudo apt install -y git
```

### 🔧 Passos adicionais obrigatórios para uSvxCard / uDraCard / RF-Guru
Ativar porta série:
```bash
sudo raspi-config
```
Editar config:
```bash
sudo nano /boot/firmware/config.txt

dtoverlay=pi3-miniuart-bt
enable_uart=1
```
Instalar drivers:
```bash
sudo git clone https://github.com/f5vmr/seeed-voicecard
cd seeed-voicecard
sudo ./install.sh
```

---
## 🏗️ Instalação do SVXLinkBuilder
### Passo 1 — Clonar repositório
```bash
sudo apt install -y git
git clone https://github.com/f5vmr/svxlinkbuilder.git
```
### Passo 2 — Pré-instalação
```bash
./svxlinkbuilder/preinstall.sh
```
(O Raspberry Pi irá reiniciar.)

### Passo 3 — Instalação principal
```bash
./svxlinkbuilder/install.sh
```
Responde às perguntas do menu. Serão configurados:
- GPIOs
- PTT/COS
- Placa de som
- Indicativo
- EchoLink (opcional)
- MetarInfo (opcional)

No final será mostrado o **IP do nó** — guarda-o para aceder ao Dashboard.

---
## 🌐 Aceder ao Dashboard
Num navegador (Chrome/Firefox):
```
http://<ip_do_teu_no>
```
Se a placa de som USB estiver a piscar, o sistema está operacional.

---
## 🛠️ Resolução de Problemas
### Comandos úteis
```bash
sudo systemctl stop svxlink.service
sudo systemctl restart svxlink.service
```

### Ficheiros importantes
- `/etc/svxlink/svxlink.conf`
- `/etc/svxlink/node_info.json`
- Backups: `/var/www/html/backups/`

### Editar node_info.json
Criar ficheiro em:
<http://portal.svxlink.uk:81> → Register → My Stations

Copiar conteúdo para:
```bash
cd /etc/svxlink
sudo nano node_info.json
```

---
## 🔊 Configuração de Áudio (amixer)
Definições recomendadas:
- **Loudspeaker**: ~75
- **Mic**: 0
- **Mic with Capture**: 19–38
- **Autogain**: OFF

---
## 📻 Programação SA818 (F8ASB / RF-Guru)
Instalar ferramenta:
```bash
git clone https://github.com/0x9900/sa818
cd sa818
sudo python3 setup.py install
```
Exemplo:
```bash
sa818 --port /dev/ttyS0 radio --frequency 430.125 --squelch 2 --bw 0
```
Substituir frequência conforme necessário.

---
## 👥 Créditos
- **Core Software:** SVXLink / SvxReflector — Tobias Blömberg SM0SVX
- **Dashboard Framework:** SP2ONG & SP0DZ
- **Contribuições adicionais:** Adi DL1HRC & comunidade SVXLink
- **Modernização & integração:** Chris G4NAB

---
## 📎 Addendum
- Talkgroups adicionados via *ReflectorLogic* no Configurator
- MetarInfo configurável no *MetarInfo Configurator*
- EchoLink pode ser ativado depois, adicionando `ModuleEchoLink` a MODULES=

---
## ✋ Notas finais
Este ficheiro README_PT é uma tradução adaptada para utilização em GitHub, baseado no guia original em inglês do autor.

Se encontrares erros de tradução ou quiseres melhorar este ficheiro, envia um Pull Request!

**CR7BUI 73 — Equipa de Tradução PT**
