# Neovim Config by romanpotapov05

# Удаляем конфиги
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

# Удаляем все временные файлы
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
rm -rf ~/.local/share/nvim/shada

Персональный конфиг Neovim с:

- Telescope (поиск файлов, содержимого, файловый менеджер)  
- Tree-sitter для подсветки Java, Lua, Bash, JSON, Vim, Regex  
- FZF + автоматическая сборка fzf-native  
- nvim-web-devicons для красивых иконок  
- Тема: TokyoNight  
- Номера строк + относительная нумерация  
- Мягкая подсветка текущей строки  

---

## 🔹 Требования

- Kubuntu / Ubuntu (Linux)  
- Git  
- Curl  
- Терминал с поддержкой UTF-8  
- Настройка шрифта Nerd Font в терминале  

---

## 🔹 Установка «всё одной командой»

Скопируйте и вставьте в терминал:

```bash
sudo apt update && sudo apt install -y neovim git curl ripgrep unzip && \
# Бэкап старого конфига
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim_backup_$(date +%s) || true && \
mkdir -p ~/.config && \
git clone https://github.com/romanpotapov05/nvimConfig.git ~/.config/nvim && \
# lazy.nvim
[ -d ~/.local/share/nvim/lazy/lazy.nvim ] || git clone --filter=blob:none https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim && \
# Установка FiraCode Nerd Font
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts && \
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip && unzip -o FiraCode.zip && fc-cache -fv && \
# Сборка плагинов через lazy.nvim
nvim --headless +"Lazy! sync" +qa && \
# Сборка fzf-native
nvim --headless -c 'Lazy! build telescope-fzf-native.nvim' -c qa && \
# Обновление Tree-sitter языков
nvim --headless -c 'TSUpdate java lua bash json vim regex' -c qa && \
echo "=== Установка завершена ===" && \
echo "Запуск Neovim: nvim" && \
echo "Горячие клавиши:" && \
echo "  <Space>ff - поиск файлов" && \
echo "  <Space>fg - поиск по содержимому" && \
echo "  <Space>ft - файловый менеджер" && \
echo "" && \
echo "⚠️ Чтобы иконки отображались корректно, откройте настройки вашего терминала и выберите шрифт 'FiraCode Nerd Font Mono' или любой Nerd Font."
