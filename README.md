# Neovim Config by romanpotapov05

Персональный конфиг Neovim с:

- Telescope (поиск файлов, содержимого, файловый менеджер)  
- Tree-sitter для подсветки Java, Lua, Bash, JSON, Vim, Regex  
- FZF + автоматическая сборка fzf-native  
- nvim-web-devicons для красивых иконок  
- Тема: TokyoNight  
- Номера строк + относительная нумерация  
- Мягкая подсветка текущей строки  

## 🔹 Требования

- Kubuntu / Ubuntu (Linux)  
- Git  
- Curl  
- Ripgrep  

## 🔹 Установка «одной командой» (без потери старого конфига)

```bash
# Установка Neovim, git, curl и ripgrep
sudo apt update && sudo apt install -y neovim git curl ripgrep

# Бэкап старого конфига, если есть
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim_backup_$(date +%s)

# Создаём конфигурацию и клонируем репозиторий
mkdir -p ~/.config
git clone https://github.com/romanpotapov05/nvimConfig.git ~/.config/nvim

# Устанавливаем lazy.nvim, если ещё не установлен
[ -d ~/.local/share/nvim/lazy/lazy.nvim ] || \
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim

# Сборка плагинов и установка через lazy.nvim
nvim --headless +"Lazy! sync" +qa

# Обновление Tree-sitter языков для подсветки
nvim --headless -c 'TSUpdate java lua bash json vim regex' -c qa

echo "=== Установка завершена ==="
echo "Запуск Neovim: nvim"
echo "Горячие клавиши:"
echo "  <Space>ff - поиск файлов"
echo "  <Space>fg - поиск по содержимому"
echo "  <Space>ft - файловый менеджер"
