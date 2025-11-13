#!/bin/bash
# This script runs as user to initialize user configuration
cd ~/
source ~/.profile

if [ ! -f ~/.vimrc ]; then
cat >> ~/.vimrc <<EOF
syntax on
set mouse=""
set bg=dark
EOF
fi

if [ ! -f ~/.bashrc ]; then
cat >> ~/.bashrc <<EOF
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
EOF
fi

if [ -f /shared_env/GIT_PASSWORD ]; then
    GIT_PASSWORD=`cat /shared_env/GIT_PASSWORD`
    if [ ! -z "$GIT_PASSWORD" ]; then
        mkdir -p ~/.bin
        cat >> ~/.bin/git-token.sh <<EOF
#!/bin/bash
echo "\$GIT_PASSWORD"
EOF
        chmod u+x ~/.bin/git-token.sh
        cat >> ~/.profile <<EOF
GIT_PASSWORD=$GIT_PASSWORD
GIT_ASKPASS=\$HOME/.bin/git-token.sh
EOF
    fi
fi

cd ~/
source ~/.profile
