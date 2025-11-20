# Neovim Config by romanpotapov05

Персональный конфиг Neovim с:

- Telescope (поиск файлов, содержимого, файловый менеджер)  
- Tree-sitter для подсветки Java, Lua, Bash, JSON, Vim, Regex  
- FZF + автоматическая сборка fzf-native  
- nvim-web-devicons для красивых иконок  
- Тема: TokyoNight  
- Номера строк + относительная нумерация  
- Мягкая подсветка текущей строки  
- Автодополнение через nvim-cmp + LSP + LuaSnip  

---

## 🔹 Требования

- Kubuntu / Ubuntu (Linux)  
- Git  
- Curl  
- Терминал с поддержкой UTF-8  
- Java JDK 17+ для LSP Java (`jdtls`)  

---

## 🔹 Установка «одной командой»

Скопируйте и вставьте в терминал:

```bash
#!/bin/bash

# 1️⃣ Установка Neovim, git, curl, ripgrep, unzip, OpenJDK
sudo apt update && sudo apt install -y neovim git curl ripgrep unzip openjdk-17-jdk

# 2️⃣ Бэкап старого конфига
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim_backup_$(date +%s) || true

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

echo "⚠️ Настройте ваш терминал на шрифт 'FiraCode Nerd Font Mono' для корректного отображения иконок."

# 6️⃣ Установка плагинов через lazy.nvim
nvim --headless +"Lazy! sync" +qa

# 7️⃣ Сборка fzf-native
nvim --headless -c 'Lazy! build telescope-fzf-native.nvim' -c qa

# 8️⃣ Обновление Tree-sitter
nvim --headless -c 'TSUpdate java lua bash json vim regex' -c qa

# 9️⃣ Завершение
echo "=== Установка завершена ==="
echo "Запуск Neovim: nvim"
echo "Горячие клавиши:"
echo "  <Space>ff - поиск файлов"
echo "  <Space>fg - поиск по содержимому"
echo "  <Space>ft - файловый менеджер"
echo "  <Tab>/<S-Tab> - навигация по автодополнению"
echo "  <CR> - подтверждение автодополнения"
