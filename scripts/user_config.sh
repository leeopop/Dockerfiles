#!/bin/bash

mkdir -p .ssh/

cat >> ~/.ssh/authorized_keys <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxvZegjiiszjygq0ZdMjpsNMLapikBzgv7MVS9ArBeh openpgp:0xD22EAB0F
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmw11dvaEsDWGgak3IXs2jqvO1AtqPa03kW8fDy42OG leeopop-2021
EOF

cat >> ~/.vimrc <<EOF
syntax on
set mouse=""
set bg=dark
EOF

cat >> ~/.bashrc <<EOF
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
EOF

mkdir -p ~/.bin
cat >> ~/.bin/git-token.sh <<EOF
#!/bin/bash
echo "\$GIT_PASSWORD"
EOF

PATH=`cat /shared/PATH`
echo "PATH=$PATH" >> ~/.profile

chmod u+x ~/.bin/git-token.sh
GIT_PASSWORD=`cat /shared/GIT_PASSWORD`
echo "GIT_PASSWORD=$GIT_PASSWORD" >> ~/.profile
echo "GIT_ASKPASS=\$HOME/.bin/git-token.sh" >> ~/.profile

git config --global user.name "Keunhong Lee"
git config --global user.email dlrmsghd@gmail.com
git config --global pull.ff only

