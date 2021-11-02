#!/bin/bash

mkdir -p .ssh/

cat >> ~/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAh4fXtTmMiWLDT0x0HtcLXCteVhqWbTW3aTbQCxsnIkRwgAq4611qFCpH2uFG9TGPFnRYDLzW4aYx+vXi4U9WIdLGMl6adsQ37l58OzIQSrcQBBradTDxrphew5eoNhujdUfAY88GwywHIjvXStqhalN0XN8SUhD4MM2iG+HVY8RVWIoG3ry35LK0o359/2q49d7a5/IyXFFOW5a6lcCC/avKItLTNpt8I3o5q97I1oP9KZvVnG3zMTMjG3VLMcBDjOAwkkIP01co5t2j7wOPCIPsAO5zoVmCOALMIeX2CvlGdwkspwwsL1gm8gKqCgoIPDdM17ZhzJw8BPLBcJaaQ6Tzsm5nmXmKCnXJd+X6eUUdW0gHPPO8tG0wzi//b8/n/t6bqu0tO48rEX2Tk1ME4NMWD2vhhrBT3AReYSTj5aqvZwqOfjQthXYKNYFl+cROqV9Khxji6lmwT/yy7yv9SxkR71mt3ERdwVd0eHgSZHycWlvFQ59n4sLnpQzsKKsgtcQuCfxFWjbmWzpl3Mw7klx2tc2ASlvUfIgLA278/JB0fTiwn3gopZQOKls5z7tXXwkpCAv0TXqM/ibGuDt6P4CcCUOb4lUycXqczTMWJt0qpdGZqDmTVq5eF+psCHhyc+qFIV99A72CpmDZxPgu+anLK4QIfoaJrmp/UvwYitk= leeopop-2013
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

chmod u+x ~/.bin/git-token.sh
GIT_PASSWORD=`cat /shared/GIT_PASSWORD`
echo "export GIT_PASSWORD=$GIT_PASSWORD" >> ~/.profile
echo "export GIT_ASKPASS=$HOME/.bin/git-token.sh" >> ~/.profile

git config --global user.name "Keunhong Lee"
git config --global user.email dlrmsghd@gmail.com
git config --global pull.ff only

if [ -d "/workspace" ] ; then
  ln -sfn /workspace "$HOME/workspace"
fi
