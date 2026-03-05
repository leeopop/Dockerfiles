# Beginning of npm user config
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
cat >> ~/.profile <<'EOF'
export PATH=~/.npm-global/bin:$PATH
EOF
source ~/.profile
# End of npm user config
