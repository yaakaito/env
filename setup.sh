#!/bin/zsh

sudo apt update && sudo apt install peco

cp ./dotfiles/.gitconfig ~/.gitconfig
mkdir -p ~/.config/git
cp ./dotfiles/.config/git/ignore ~/.config/git/ignore
cp -r ./dotfiles/.claude ~/.claude
cp -r ./dotfiles/.codex ~/.codex
cp -r ./dotfiles/.claude/skills/adr-writer ~/.codex/skills/adr-writer

mkdir -p ~/.zsh

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZSOTDIR:-$HOME}/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

cp ./dotfiles/zsh/peco.zsh ~/.zsh/peco.zsh
echo "source ~/.zsh/peco.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
cp ./dotfiles/zsh/git-worktree.zsh ~/.zsh/git-worktree.zsh
echo "source ~/.zsh/git-worktree.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
cp ./dotfiles/zsh/vscode-extensions.zsh ~/.zsh/vscode-extensions.zsh
echo "source ~/.zsh/vscode-extensions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
mkdir -p ~/.zsh/bin
cp ./dotfiles/zsh/bin/git-worktree-add ~/.zsh/bin/git-worktree-add
mkdir -p ~/.cache

curl -fsSL https://claude.ai/install.sh | bash

claude plugin marketplace add yaakaito/env
claude plugin install dev-plan@yaakaito-env
claude plugin install base@yaakaito-env
claude plugin install typescript-lsp@claude-plugins-official
npm install -g typescript-language-server typescript
claude plugin install code-simplifier@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official

npm install -g @openai/codex
