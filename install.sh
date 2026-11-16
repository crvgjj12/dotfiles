#!/bin/bash
set -euo pipefail

echo "🚀 Iniciando configuração do ambiente..."

# 1. Instalar Node.js 22 (Se não existir)
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

# 4. Adicionar os Marketplaces
echo "🗂️ Adicionando Marketplaces..."
claude plugin marketplace add obra/superpowers || true
claude plugin marketplace add NoobyGains/godmode || true
claude plugin marketplace add DietrichGebert/ponytail || true
claude plugin marketplace add mksglu/claude-context-mode || true
claude plugin marketplace add anthropics/claude-plugins-official || true
claude plugin marketplace add headroomlabs-ai/headroom || true

# 5. Instalar e ATIVAR os Plugins
echo "🧩 Instalando e ativando plugins..."
claude plugin install superpowers@superpowers || true
claude plugin enable superpowers@superpowers || true

claude plugin install godmode@godmode || true
claude plugin enable godmode@godmode || true

claude plugin install ponytail@ponytail || true
claude plugin enable ponytail@ponytail || true

claude plugin install context-mode@context-mode || true
claude plugin enable context-mode@context-mode || true

claude plugin install headroom-skill@headroom-marketplace || true
claude plugin enable headroom-skill@headroom-marketplace || true

claude plugin install frontend-design@claude-plugins-official || true
claude plugin install pr-review-expert@claude-plugins-official || true
claude plugin install commit-commands@claude-plugins-official || true

# 6. Instalar Claude-Mem
echo "🧠 Instalando Claude-Mem..."
npx claude-mem install || true

# 7. Configurar Tokens do MCC (Apenas o MCC, pois o Claude puxa do ambiente)
if [ -n "${MCC_ANTHROPIC_AUTH_TOKEN:-}" ]; then
  echo "🔑 Configurando MCC Token..."
  mkdir -p ~/.mcc
  if ! grep -q "ANTHROPIC_AUTH_TOKEN" ~/.mcc/.env 2>/dev/null; then
    echo "ANTHROPIC_AUTH_TOKEN=\"$MCC_ANTHROPIC_AUTH_TOKEN\"" >> ~/.mcc/.env
  fi
fi

echo "✅ Configuração concluída com sucesso!"
