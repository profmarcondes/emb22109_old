# Lab 01

O objetivo deste laboratório é prepararmos o seu computador para a realização das práticas que realizaremos ao longo do curso.

Recomendamos o uso de uma distribuição atual de Linux para o desenvolvimento das atividades práticas, o que pode ser realizado através de uma instalação nativa em seu computador, ou através do uso de um sistema de virtualização como VirtualBox ou VMWare. Também é possível utilizar o Windows Subsystem for Linux (WSL). Algumas instruções para configuração do WSL no Windows são fornecidas nesta [página](wsl/README.md).

## Passos Iniciais

Inicialmente, vamos garantir que o nosso sistema Ubuntu esteja atualizado, executando os seguintes comandos:

```
sudo apt update
sudo apt dist-upgrade
```

Adicionalmente, recomendamos a instalação das seguintes ferramentas adicionais:

```
sudo apt install git vim nano 
```

Instalar as seguintes dependências para uso do Buildroot

```
sudo apt install sed make binutils gcc g++ bash patch \
gzip bzip2 perl tar cpio python unzip rsync wget libncurses-dev
```

Clonar o repositório com o comando

```
git clone --recurse-submodules https://github.com/profmarcondes/emb22109.git
```

O último comando irá fazer o clone deste repositório, que contém além destes laboratórios, outras pastas que serão utilizadas em laboratórios futuros, além do próprio repositório do Buildroot já configurado para a versão que iremos utilizar durante o curso.

Agora entraremos na pasta buildroot, dentro do repositório para iniciar a configuração do mesmo. Utilize o comando abaixo para isto:

```
cd emb22109/buildroot
```

## Configurando o Buildroot

Se você olhar no diretório configs/, verá que existe um arquivo chamado beaglebone_defconfig, que é um arquivo de configuração Buildroot pronto para uso para construir um sistema para a plataforma BeagleBone Black. No entanto, como queremos aprender sobre o Buildroot, iniciaremos nossa própria configuração do princípio!

Inicie o utilitário de configuração Buildroot:

```
make menuconfig
```

Realize as seguintes configurações na ferramenta:

#### Target Options

Neste menu iremos configurar a arquitetura alvo de nosso sistema embarcado. A plataforma Beagle Bone Black é baseada na arquitetura ARM, e de acordo com a documentação disponível em https://beagleboard.org/BLACK, a mesma utiliza o SoC da Texas Instruments AM335x, que é baseado em um ARM Cortex-A8. Desta forma, realize as seguintes configurações:

  1. Selecione ARM (little endian) como  target architecture
  2. Selecione cortex-A8 como Target Architecture Variant

#### Build options

Por hora não necessitamos modificar nenhum configuração do menu Build Options. De qualquer forma, aproveita para visitar esse menu e observar as opções de configuração que temos disponível. A ferramenta KConfig possui uma opção de ajuda para descrever mais informações sobre cada item de configuração. 

<!--
## Toolchain


 - External toolchain as the Toolchain type
 - Select Arm ARM 2021.07 as the Toolchain
 
System
 - Set root password
 
Kinux Kernel
 - 5.15.35 - version
 - defconfig - omap2plus
 - zImage format
 - enable Build a Device Tree Blob (DTB) 
 - am335x-boneblack as the In-tree Device Tree Source file names
 - Needs host OpenSSL option.
 
Target Packages

Filesystem

Uboot
 - Select Kconfig as the Build system.
 - custom version of U-Boot 2022.04
 - use am335x_evm as Board defconfig
 - U-Boot needs OpenSSL
 - select u-boot.img as the U-Boot binary format
 - enable Install U-Boot SPL binary image 
 - use MLO as the U-Boot SPL binary image name
 - DEVICE_TREE=am335x-boneblack as Custom make options
   -- U-Boot needs dtc ??

# build 
 make 2>&1 | tee build.log
-->
