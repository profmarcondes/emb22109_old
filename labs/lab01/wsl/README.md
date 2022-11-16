# Configuração do Windows Subsystem for Linux (WSL) para uso do Buildroot

## Instalando o WSL no Windows

Inicialmente o WSL deve ser instalado, para isso, abra um terminal PoweShell em modo Administrador e execute o comando

`wsl --install -d Ubuntu`

O processo de instalação deve demorar um pouco, realizando o download de todos os componentes necessários. Ao final será solicitado um nome de usuário e senha. Pode escolher livremente esses dados, mas use um senha que não irá se esquecer, pois precisaremos dela sempre que executarmos comandos com o sudo.

Maiores detalhes sobre a instalação do WSL podem ser consultados neste [site](https://learn.microsoft.com/pt-br/windows/wsl/install).

## Evitando a integração o WSL com o caminho de executáveis do Windows

O WSL no Windows possui uma integração que permite a execução de comandos nativos do Windows, dentro do ambiente do WSL. Apesar se ser uma integração interessante, a mesma gera um conflito para o uso do Buildroot, relacionado a variável de ambiente $PATH. Por este motivo, iremos desativar essa integração.

Para isso, iremos editar dentro do Ubuntu instalado no WSL o arquivo /etc/wsl.conf. Crie o arquivo, caso o mesmo não existe. Dentre deste arquivo, garanta que as seguintes configurações estejam ativas:

```
[interop]
enabled = false
appendWindowsPath = false
```


# Arquivo old

## Notes para uso do Buildroot - WSL 

-> Para conectar devices USB - instalar usbipd
https://docs.microsoft.com/pt-br/windows/wsl/connect-usb

-> Compilar o kernel do wsl com suporte para usb-storage
https://microhobby.com.br/blog/2019/09/21/compiling-your-own-linux-kernel-for-windows-wsl2/
   - sudo apt install git bc build-essential flex bison libssl-dev libelf-dev dwarves
   - git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
  - interessante support usb-serial / prolific usbserial
  - Config -> config-usb_storage (copiar para /WSL2-Linux-Kernel/Microsoft/)
  - Compilar o kernel 
     - make KCONFIG_CONFIG=Microsoft/config-usb_storage -j8
  - Copiar o vmlinux para o seu home(Windows), junto com o 
    .wslconfig (atualizar path no arquivo)

## Para conectar o dispositivo usb

Pshell$ usbipd wsl list
Pshell$ usbipd wsl attach --busid <busid>

bash$ lsusb

## 
Pshell$ usbipd wsl detach --busid <busid>


# no wsl

Uso da serial :-> sudo picocom -b 115200 /dev/ttyUSB0

Network:
Config sem DHCP na BeagleBone
 sudo ifconfig eth1 192.168.0.3 netmask 255.255.255.0

Config com DHCP
 sudo dhclient eth1
