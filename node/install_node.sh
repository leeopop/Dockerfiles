curl https://get.volta.sh | bash
source ~/.profile
volta install node
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc
export PATH="$HOME/.bun/bin:$PATH"

echo "=== Version Check ==="
volta --version
node --version
npm --version
bun --version
