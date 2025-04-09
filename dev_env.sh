#!/bin/bash
## License: MIT
## It can reinstall debian to stable version !.
## Written By https://github.com/ehebe

function __log() { local _date=$(date +"%Y-%m-%d %H:%M:%S"); echo -e "\e[0;32m[${_date}]\e[0m $@" >&2; }
function __fatal() { __log "$@"; __log "\tExiting."; exit 1; }
function __command_exists() { command -v "$1" >/dev/null 2>&1; }

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

[[ "$(uname -a)" =~ "inux" && "$(uname -a)" =~ "entos" ]] && __fatal "requires debian or ubuntu"
[[ "$(id -u)" -ne 0 ]] && __fatal "Error:This script must be run as root!"

need_commands=(wget curl sudo)
for cmd in "${need_commands[@]}"; do
  if ! __command_exists "$cmd"; then
    __fatal "\tError: Missing command '$cmd'.You need to install it first.\n\t\t\tapt install -y wget gzip openssl";
  fi
done

function __install_lazygit(){
	__log 'Install lazygit ...'
	local LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	curl -L "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | sudo tar xz -C /tmp
	__log 'Copy lazygit to  /usr/local/bin ...'
	sudo mv /tmp/lazygit /usr/local/bin
	__log 'Install lazygit done...'
}

function __install_fonts(){
	__log 'Install hack font...'
	curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip -o /tmp/Hack.zip
	unzip -qo /tmp/Hack.zip -d ~/.fonts
	rm -rf /tmp/Hack.zip
	__log 'Refresh system fonts ...'
	fc-cache -fv > /dev/null 2>&1
	__log 'Install hack font done...'
}

function __install_nodejs(){
	__log 'Install nodejs...'
	curl -fsSL https://fnm.vercel.app/install | sudo bash -s -- --install-dir /opt/fnm
	source ~/.bashrc
	fnm install v22.14.0
	__log 'Install nodejs done...'
}


function __install_nginx(){
	__log 'Install nginx...'
	sudo DEBIAN_FRONTEND=noninteractive apt install -y nginx-full certbot python3-certbot-dns-cloudflare
	cat >  /etc/nginx/nginx.conf  <<"EOF"
user  www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
include /etc/nginx/modules-enabled/*.conf;
events {
    use epoll;
    worker_connections  4096; 
}
include /etc/nginx/stream-enabled/*;
http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 4096;
    server_tokens off;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    ssl_protocols  TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    access_log /var/log/nginx/access.log;
    gzip on;
    limit_req_zone $binary_remote_addr zone=ip_limit:10m rate=5r/s;
    limit_conn_zone $binary_remote_addr zone=addr_limit:10m;
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

mkdir -p /srv/apps/default
cat > /srv/apps/default/index.html <<"EOF"
<!DOCTYPE html><html lang='en' class=''><head><meta charset='UTF-8'><title>Forbidden 403</title><style class="INLINE_PEN_STYLESHEET_ID">    @import url("https://fonts.googleapis.com/css?family=Press+Start+2P");html, body {  width: 100%;  height: 100%;  margin: 0;}* {  font-family: "Press Start 2P", cursive;  box-sizing: border-box;}#app {  padding: 1rem;  background: black;  display: flex;  height: 100%;  justify-content: center;  align-items: center;  color: #54FE55;  text-shadow: 0px 0px 10px;  font-size: 6rem;  flex-direction: column;}#app .txt {  font-size: 1.8rem;}@keyframes blink {  0% {    opacity: 0;  }  49% {    opacity: 0;  }  50% {    opacity: 1;  }  100% {    opacity: 1;  }}.blink {  animation-name: blink;  animation-duration: 1s;  animation-iteration-count: infinite;}</style></head><body><div id="app"><div>403</div><div class="txt">      Sorry, your IP is not supported for access.<span class="blink">_</span></div></div></body></html>
EOF

chown -R www-data:www-data /srv/apps/default

mkdir -p /etc/nginx/sites-enabled
cat > /etc/nginx/sites-enabled/default <<"EOF"
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  root /srv/apps/default;
  index index.html;
  #limit_req zone=ip_limit burst=12 delay=8;
  #limit_conn addr_limit 2;
  #limit_rate_after 3m;
  #limit_rate 5m;
  server_name _;
  location / {
    try_files $uri $uri/ =404;
  }
}
EOF

mkdir -p /etc/nginx/stream-enabled
systemctl enable  nginx && systemctl restart nginx
history -c

}

function __install_nvim(){
	__log 'Install neovim ...'
	curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | sudo tar xz -C /opt
	__log 'Link neovim to  /usr/local/bin ...'
	ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
	__log 'Install neovim done...'
}

function __install_desktop_xrdp(){
	__log 'Install i3wm...'
	sudo DEBIAN_FRONTEND=noninteractive apt install -y xrdp xorg xorgxrdp xclip i3 xinit  ttf-wqy-microhei kitty feh xauth
	echo 'Xft.dpi: 120' > ~/.Xresources #set dpi
  __log 'Enable xrdp tls'
  sudo sed -i 's/^security_layer=.*$/security_layer=tls/' /etc/xrdp/xrdp.ini
  sudo sed -i 's|^certificate=.*$|certificate=/etc/xrdp/cert.pem|' /etc/xrdp/xrdp.ini
  sudo sed -i 's|^key_file=.*$|key_file=/etc/xrdp/key.pem|' /etc/xrdp/xrdp.ini
	adduser xrdp ssl-cert
	chmod 644 /etc/xrdp/*.pem
	sudo systemctl enable  xrdp  && sudo systemctl  restart  xrdp
	## set neovim .config
	## sudo git clone https://github.com/ehebe/scripts.git  /opt/scripts
	rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
	rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/i3"
	sudo ln -sf /opt/scripts/dotfiles/kitty "${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
	sudo ln -sf /opt/scripts/dotfiles/i3  "${XDG_CONFIG_HOME:-$HOME/.config}/i3"
}

_env='base'

while [[ $# -ge 1 ]]; do
  case $1 in
    -env)
      shift
      _env="$1"
      shift
      ;;
    *)
     if [[ "$1" != 'error' ]]; then echo -ne "\nInvaild option: '$1'\n\n"; fi
      echo "eg: sudo bash dev_env.sh -p  , will auto install env !";
      echo ''
      __fatal
      ;;
    esac
done


function __install_base(){
    __install_nvim
    __install_nodejs
    __install_nginx
	  rm -rf "${XDG_CONFIG_HOME:-$HOME/}.tmux.conf"
    sudo ln -sf /opt/scripts/dotfiles/.tmux.conf ~/.tmux.conf
}

function __install_dev(){
    __install_lazygit
	  rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
	  sudo ln -sf /opt/scripts/dotfiles/nvim "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
}

if [ "$_env" == "base" ]; then
	  __log "Install environment is base"
    __install_base

elif [ "$_env" == "dev" ]; then
	  __log "Install environment is dev"
    __install_base
    __install_dev

elif [ "$_env" == "full" ]; then
    __log "Install environment is full"
    __install_base
    __install_dev
    __install_fonts
    __install_desktop_xrdp
else
    __fatal "Install environment is neither (base|dev|full)"
fi


