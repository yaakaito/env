if [ ! -f ~/.zsh/.vscode-extensions ]; then
  code --install-extension github.copilot
  code --install-extension github.copilot-chat
  code --install-extension mhutchie.git-graph
  code --install-extension eamodio.gitlens
  code --install-extension quick-lint.quick-lint-js
  touch ~/.zsh/.vscode-extensions
fi
