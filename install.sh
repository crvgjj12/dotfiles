#!/bin/bash
set -euo pipefail

echo "🚀 Iniciando configuração do ambiente..."

# 1. Instalar Node.js 22 (Necessário para Claude Code e MCC)
if ! command -v node &> /dev/null; then
  echo "📦 Instalando Node.js..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

# 2. Instalar Claude Code CLI
if ! command -v claude &> /dev/null; then
  echo "🤖 Instalando Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
fi

# 3. Instalar o MCC (My Claude Code)
if ! command -v mcc-server &> /dev/null; then
  echo "🌐 Instalando MCC..."
  curl -fsSL "https://raw.githubusercontent.com/FiredMosquito831/my-claude-code/main/scripts/install.sh" | sh
fi

# 4. Instalar Plugins do Claude
echo "🧩 Instalando plugins do Claude..."
claude plugin marketplace add obra/superpowers || true
claude plugin install superpowers@superpowers || true

claude plugin marketplace add NoobyGains/godmode || true
claude plugin install godmode@godmode || true

claude plugin marketplace add DietrichGebert/ponytail || true
claude plugin install ponytail@ponytail || true

# 5. Configurar Tokens (Puxando dos Codespaces Secrets)
if [ -n "${CLAUDE_CODE_OAUTH_TOKEN:-}" ]; then
  echo "🔑 Configurando Claude OAuth Token..."
  mkdir -p ~/.claude
  echo "{\"oauthToken\": \"$CLAUDE_CODE_OAUTH_TOKEN\"}" > ~/.claude/settings.json
fi

if [ -n "${MCC_ANTHROPIC_AUTH_TOKEN:-}" ]; then
  echo "🔑 Configurando MCC Token..."
  mkdir -p ~/.mcc
  # Adiciona a variável ao .env do MCC se não existir
  if ! grep -q "ANTHROPIC_AUTH_TOKEN" ~/.mcc/.env 2>/dev/null; then
    echo "ANTHROPIC_AUTH_TOKEN=\"$MCC_ANTHROPIC_AUTH_TOKEN\"" >> ~/.mcc/.env
  fi
fi

echo "✅ Configuração concluída com sucesso!"
