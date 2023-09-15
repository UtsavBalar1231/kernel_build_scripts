# Vicharak Kernel building scripts

Kernel building scripts for Vicharak's ARM64 and X86 devices.

## Installation

1. Using Git submodule

```bash
git submodule add -b main https://github.com/vicharak-in/kernel_build_scripts vicharak
```

2. Downloading the scripts

```bash
wget -qO vicharak.tar.gz https://github.com/vicharak-in/kernel_build_scripts/archive/refs/heads/main.tar.gz
tar -xf vicharak.tar.gz
mv kernel_build_scripts-main vicharak
rm -f vicharak.tar.gz
```

## Usage

```bash
./vicharak/build.sh -h
```

## License
[MIT](./LICENSE.MIT)
