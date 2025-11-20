# Neovim Config для Kubuntu / Ubuntu (v0.10.4)

Конфиг без LSP/jdtls, с:

- Telescope (`<Space>ff/fg/ft`)  
- Tree-sitter (Java, Lua, Bash, JSON, Vim, Regex)  
- TokyoNight  
- Номера строк + относительные номера  
- Мягкая подсветка строки  
- Буферное автодополнение (`<C-Space>`)  
- Иконки через nvim-web-devicons  

---

## 🔹 Требования

- Kubuntu / Ubuntu  
- Git, curl, unzip, ripgrep  
- Терминал с поддержкой UTF-8 и шрифтом Nerd Font (например FiraCode Nerd Font)  

---

## 🔹 Установка одной командой

```bash
#!/bin/bash

# 1️⃣ Полное удаление старого конфига и плагинов
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.local/share/nvim/site

# 2️⃣ Установка необходимых пакетов
sudo apt update && sudo apt install -y neovim git curl ripgrep unzip

# 3️⃣ Клонируем конфиг
mkdir -p ~/.config
git clone https://github.com/romanpotapov05/nvimConfig.git ~/.config/nvim

# 4️⃣ lazy.nvim
[ -d ~/.local/share/nvim/lazy/lazy.nvim ] || \
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim

# 5️⃣ FiraCode Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip
unzip -o FiraCode.zip
fc-cache -fv
echo "⚠️ Настройте терминал на FiraCode Nerd Font Mono для правильных иконок"

# 6️⃣ Установка плагинов через lazy.nvim
nvim --headless +"Lazy! sync" +qa

# 7️⃣ Сборка fzf-native
nvim --headless -c 'Lazy! build telescope-fzf-native.nvim' -c qa

# 8️⃣ Обновление Tree-sitter языков
nvim --headless -c 'TSUpdate java lua bash json vim regex' -c qa

echo "=== Установка завершена ==="
echo "Запуск Neovim: nvim"
echo "Горячие клавиши:"
echo "  <Space>ff - поиск файлов"
echo "  <Space>fg - поиск по содержимому"
echo "  <Space>ft - файловый менеджер"
echo "  <C-Space> - автодополнение слов из буфера"
