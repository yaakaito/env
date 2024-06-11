#!/bin/zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install peco

cp ./.gitconfig ~/.gitconfig

mkdir -p ~/.zsh

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZSOTDIR:-$HOME}/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

cp ./peco.zsh ~/.zsh/peco.zsh
echo "source ~/.zsh/peco.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
cp ./vscode-extensions.zsh ~/.zsh/vscode-extensions.zsh
echo "source ~/.zsh/vscode-extensions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
mkdir -p ~/.cache

cursor_exists() {
  cursor -v "$1" &> /dev/null
}

if cursor_exists cursor; then
  echo '[core]' >> ~/.gitconfig.local
  echo '\teditor = cursor --wait' >> ~/.gitconfig.local
fi
