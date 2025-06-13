if [ ! -f ~/.zsh/.vscode-extensions ]; then
  echo "VSCode拡張機能のインストールを開始します..."
  code --install-extension github.copilot
  code --install-extension github.copilot-chat
  code --install-extension mhutchie.git-graph
  code --install-extension eamodio.gitlens
  code --install-extension quick-lint.quick-lint-js
  code --install-extension RooVeterinaryInc.roo-cline
  touch ~/.zsh/.vscode-extensions
fi
