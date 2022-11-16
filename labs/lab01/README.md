# Lab 01

O objetivo deste laboratório é prepararmos o seu computador para a realização das práticas que realizaremos ao longo do curso.

Recomendamos o uso de uma distribuição atual de Linux para o desenvolvimento das atividades práticas, o que pode ser realizado através de uma instalação nativa em seu computador, ou através do uso de um sistema de virtualização como VirtualBox ou VMWare. Também é possível utilizar o Windows Subsystem for Linux (WSL). Algumas instruções para configuração do WSL no Windows são fornecidas nesta [página](wsl/README.md).

## Passos


```
$ sudo apt update
$ sudo apt dist-upgrade
```

Install git, vim, nano, extra packages

Instalar dependencias

```
sudo apt install sed make binutils gcc g++ bash patch \
gzip bzip2 perl tar cpio python unzip rsync wget libncurses-dev
```

```
git clone https://git.buildroot.net/buildroot
```

```
git checkout -b emb22109 2022.02
```


