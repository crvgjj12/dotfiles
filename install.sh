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

# 4. Configurar as variáveis de ambiente do MCC com as chaves dos Secrets
echo "🔑 Configurando chaves da API no MCC..."
mkdir -p ~/.mcc
touch ~/.mcc/.env

if [ -n "${MCC_ANTHROPIC_AUTH_TOKEN:-}" ] && ! grep -q "ANTHROPIC_AUTH_TOKEN" ~/.mcc/.env; then
    echo "ANTHROPIC_AUTH_TOKEN=\"$MCC_ANTHROPIC_AUTH_TOKEN\"" >> ~/.mcc/.env
fi
if [ -n "${NVIDIA_NIM_API_KEY:-}" ] && ! grep -q "NVIDIA_NIM_API_KEY" ~/.mcc/.env; then
    echo "NVIDIA_NIM_API_KEY=\"$NVIDIA_NIM_API_KEY\"" >> ~/.mcc/.env
fi
if [ -n "${OPENCODE_API_KEY:-}" ] && ! grep -q "OPENCODE_API_KEY" ~/.mcc/.env; then
    echo "OPENCODE_API_KEY=\"$OPENCODE_API_KEY\"" >> ~/.mcc/.env
fi
if [ -n "${COMMANDCODE_API_KEY:-}" ] && ! grep -q "COMMANDCODE_API_KEY" ~/.mcc/.env; then
    echo "COMMANDCODE_API_KEY=\"$COMMANDCODE_API_KEY\"" >> ~/.mcc/.env
fi

# 5. Configurar o terminal (CLI) para usar o MCC e habilitar a descoberta de modelos
echo "⚙️ Configurando variáveis de ambiente do shell..."
if ! grep -q "ANTHROPIC_BASE_URL" ~/.bashrc; then
  echo "export ANTHROPIC_BASE_URL=\"http://localhost:8082\"" >> ~/.bashrc
  echo "export ANTHROPIC_AUTH_TOKEN=\"${MCC_ANTHROPIC_AUTH_TOKEN:-mcc-proxy-key}\"" >> ~/.bashrc
  echo "export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1" >> ~/.bashrc
fi
source ~/.bashrc || true

# 6. Instalar e ATIVAR os Plugins do Claude
echo "🧩 Instalando e ativando plugins..."
claude plugin marketplace add obra/superpowers || true
claude plugin marketplace add NoobyGains/godmode || true
claude plugin marketplace add DietrichGebert/ponytail || true
claude plugin marketplace add mksglu/claude-context-mode || true
claude plugin marketplace add anthropics/claude-plugins-official || true
claude plugin marketplace add headroomlabs-ai/headroom || true

claude plugin install superpowers@superpowers && claude plugin enable superpowers@superpowers || true
claude plugin install godmode@godmode && claude plugin enable godmode@godmode || true
claude plugin install ponytail@ponytail && claude plugin enable ponytail@ponytail || true
claude plugin install context-mode@context-mode && claude plugin enable context-mode@context-mode || true
claude plugin install headroom-skill@headroom-marketplace && claude plugin enable headroom-skill@headroom-marketplace || true
claude plugin install frontend-design@claude-plugins-official || true
claude plugin install pr-review-expert@claude-plugins-official || true
claude plugin install commit-commands@claude-plugins-official || true

# 7. Instalar Claude-Mem
echo "🧠 Instalando Claude-Mem..."
npx claude-mem install || true

echo "✅ Configuração concluída com sucesso!"
