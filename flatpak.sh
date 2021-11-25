#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
reset="\e[0m"
notify_user() {
  flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  clear
  for_user="flathub repo was added
  please procced to use flatpaks"
}
remove() {
  clear
  flatpak list
  echo -e "${red}${bold}set flatpak to remove${reset}"
  [ "$answr" == "" ] && menu
  read -r answr
  flatpak uninstall --user --delete-data -y "$answr"
  menu
}
install() {
  clear
  echo -e "${red}${bold}set flatpak to search${reset}"
  read -r answr
  [ "$answr" == "" ] && menu
  flatpak search "$answr"
  echo -e "${red}${bold}set flatpak to install${reset}"
  read -r answr
  [ "$answr" == "" ] && menu
  flatpak install --user -y "$answr"
  menu
}
orphans() {
  clear
  flatpak uninstall --user -y --delete-data --unused
  menu
}
quit() {
  clear
  exit
}
update() {
  clear
  flatpak --user -y update
  menu
}
run() {
  clear
  flatpak --user list
  echo -e "${red}${bold}set flatpak to run${reset}"
  read -r answr
  [ "$answr" == "" ] && menu
  flatpak run --user "$answr"
  menu
}
add() {
  clear
  bash /etc/profile.d/flatpak.sh
  clear
  echo "Please reboot your system"
  exit
}
check_repos() {
  command=$(flatpak --user remotes)
  [ "$command" == "" ] && notify_user
}
menu() {
  clear
  check_repos
  echo "$for_user"
  flatpak --user list
  echo -e "
  ${red}${bold}1) install flatpak
  2) remove flatpak
  3) run flatpak
  4) update flatpaks
  5) add flatpaks to your desktop menu
  6) remove orphans
  7) exit${reset}"
  read -r answr
  [ "$answr" == "1" ] && install
  [ "$answr" == "2" ] && remove
  [ "$answr" == "3" ] && run
  [ "$answr" == "4" ] && update
  [ "$answr" == "5" ] && add
  [ "$answr" == "6" ] && orphans
  [ "$answr" == "7" ] && quit
  [ "$answr" == "" ] && quit
}
menu
