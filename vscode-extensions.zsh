code_exists() {
  code -v "$1" &> /dev/null
}

if code_exists code; then
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
fi

cursor_exists() {
  cursor -v "$1" &> /dev/null
}

if cursor_exists cursor; then
  if [ ! -f ~/.zsh/.cursor-extensions ]; then
    echo "Cursor拡張機能のインストールを開始します..."
    cursor --install-extension mhutchie.git-graph
    cursor --install-extension eamodio.gitlens
    cursor --install-extension quick-lint.quick-lint-js
    cursor --install-extension RooVeterinaryInc.roo-cline
    touch ~/.zsh/.cursor-extensions
  fi
fi
