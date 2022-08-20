python3 -m venv ~/.venv
source ~/.venv/bin/activate
pip install --upgrade pip setuptools wheel

cat <<EOF >> ~/.profile
source "${HOME}/.venv/bin/activate"
EOF
