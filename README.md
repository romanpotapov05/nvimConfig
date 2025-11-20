# Neovim Config Installer

Этот репозиторий содержит готовый конфиг для Neovim и удобный установочный скрипт,  
который можно просто скопировать из этого файла и вставить в терминал.

Конфиг подтягивается по ссылке:

- `init.lua`:  
  `https://github.com/romanpotapov05/nvimConfig/blob/8fa3e4bccea3d234aab61891eef3f09ef9795af3/init.lua`

Скрипт:

- проверяет наличие необходимых инструментов;
- пытается их доустановить (если возможно);
- делает бэкап старого `init.lua` (если он уже есть);
- скачивает новый `init.lua` по указанной ссылке.

---

## Что делает установочный скрипт

Скрипт:

1. Проверяет, установлены ли:
   - `nvim`
   - `git`
   - `curl`
   - `rg` (ripgrep, нужен для Telescope)
2. Пытается установить недостающие пакеты через один из менеджеров:
   - `apt` (Debian/Ubuntu)
   - `dnf` (Fedora)
   - `pacman` (Arch)
   - `zypper` (openSUSE)
   - `brew` (macOS)
3. Проверяет наличие `lua` (не критично, но полезно).
4. Создаёт директорию `~/.config/nvim`, если её нет.
5. Делает бэкап старого `~/.config/nvim/init.lua`, если он существует.
6. Скачивает `init.lua` из репозитория.
7. Сообщает, куда положен конфиг и предлагает запустить `nvim`.

---

## Как установить конфиг

### Вариант: скопировать скрипт и вставить в терминал

Открой терминал, вставь **весь** скрипт ниже и нажми Enter:

```bash
#!/usr/bin/env bash

set -u

CONFIG_URL="https://raw.githubusercontent.com/romanpotapov05/nvimConfig/8fa3e4bccea3d234aab61891eef3f09ef9795af3/init.lua"
NVIM_CONFIG_DIR="${HOME}/.config/nvim"
NVIM_INIT="${NVIM_CONFIG_DIR}/init.lua"

echo ">>> Neovim config installer запущен"
echo

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

detect_package_manager() {
  if command_exists apt-get; then
    echo "apt"
  elif command_exists dnf; then
    echo "dnf"
  elif command_exists pacman; then
    echo "pacman"
  elif command_exists zypper; then
    echo "zypper"
  elif command_exists brew; then
    echo "brew"
  else
    echo ""
  fi
}

install_packages() {
  local pm="$1"
  shift
  local pkgs=("$@")

  if [ "${#pkgs[@]}" -eq 0 ]; then
    return 0
  fi

  echo ">>> Устанавливаю пакеты: ${pkgs[*]} (через ${pm})"

  case "$pm" in
    apt)
      sudo apt-get update
      sudo apt-get install -y "${pkgs[@]}"
      ;;
    dnf)
      sudo dnf install -y "${pkgs[@]}"
      ;;
    pacman)
      sudo pacman -Syu --noconfirm "${pkgs[@]}"
      ;;
    zypper)
      sudo zypper install -y "${pkgs[@]}"
      ;;
    brew)
      brew update
      brew install "${pkgs[@]}"
      ;;
    *)
      echo "!!! Не удалось определить пакетный менеджер. Установи пакеты вручную: ${pkgs[*]}"
      ;;
  esac
}

echo ">>> Проверяю наличие необходимых команд..."

NEED_INSTALL=()

# обязательно нужные
for cmd in nvim git curl rg; do
  if ! command_exists "$cmd"; then
    NEED_INSTALL+=("$cmd")
  fi
done

PM=$(detect_package_manager)

if [ -n "$PM" ] && [ "${#NEED_INSTALL[@]}" -gt 0 ]; then
  install_packages "$PM" "${NEED_INSTALL[@]}"
else
  if [ -z "$PM" ] && [ "${#NEED_INSTALL[@]}" -gt 0 ]; then
    echo "!!! Пакетный менеджер не найден, установи вручную: ${NEED_INSTALL[*]}"
  fi
fi

# финальная проверка критичных команд
MISSING_CRITICAL=0
for cmd in nvim git curl; do
  if ! command_exists "$cmd"; then
    echo "!!! Критичная команда не найдена даже после попытки установки: $cmd"
    MISSING_CRITICAL=1
  fi
done

if [ "$MISSING_CRITICAL" -eq 1 ]; then
  echo "!!! Без nvim, git и curl конфиг установить не получится."
  exit 1
fi

# lua не критично, но проверим
if command_exists lua; then
  echo ">>> Lua найдена: $(lua -v 2>&1 | head -n1)"
else
  echo ">>> Внимание: команда 'lua' не найдена."
  echo "    Для Lua-конфига Neovim это не обязательно, но можно доустановить при желании."
fi

echo
echo ">>> Готовлю папку для конфига: ${NVIM_CONFIG_DIR}"

mkdir -p "${NVIM_CONFIG_DIR}"

# бэкап старого init.lua, если есть
if [ -f "${NVIM_INIT}" ]; then
  TS="$(date +%Y%m%d-%H%M%S)"
  BACKUP="${NVIM_INIT}.bak-${TS}"
  echo ">>> Найден существующий init.lua — делаю бэкап: ${BACKUP}"
  cp "${NVIM_INIT}" "${BACKUP}"
fi

echo ">>> Скачиваю init.lua из репозитория..."
echo "    URL: ${CONFIG_URL}"

if ! curl -fsSL "${CONFIG_URL}" -o "${NVIM_INIT}"; then
  echo "!!! Не удалось скачать init.lua. Проверь URL или подключение к интернету."
  exit 1
fi

echo
echo ">>> Конфиг сохранён в: ${NVIM_INIT}"
echo ">>> Теперь можно запускать Neovim командой:"
echo "    nvim"
echo
echo "Первый запуск может занять время — будут устанавливаться плагины."
