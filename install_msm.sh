UPDATE_URL="https://raw.githubusercontent.com/msmhq/msm/master"
wget -q ${UPDATE_URL}/installers/common.sh -O /tmp/msmcommon.sh
source /tmp/msmcommon.sh && rm -f /tmp/msmcommon.sh

function update_system_packages() {
  install_log "Updating sources"
  sudo apt-get update || install_error "Couldn't update package list"
  sudo apt-get upgrade || install_error "Couldn't upgrade packages"
}

function install_dependencies() {
  install_log "Installing required packages"
  sudo apt-get install screen rsync zip || install_error "Couldn't install dependencies"
}

function enable_init() {
  install_log "Enabling automatic startup and shutdown"
  hash insserv 2>/dev/null
  if [[ $? == 0 ]]; then
    sudo insserv msm
  else
    sudo update-rc.d msm defaults 99 10
  fi
}


function config_installation() {
  install_log "Configure installation"
  msm_dir="/data"
  echo -n "Install directory [${msm_dir}]: "
  echo -n "New server user to be created [${msm_user}]: "
}

install_msm
