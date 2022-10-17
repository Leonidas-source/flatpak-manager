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
  read -r answr
  [ "$answr" == "" ] && menu
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
  flatpak run --user "$answr" &
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
repo() {
  clear
  echo "Set name for your new repository"
  read answr
  [ "$answr" == "" ] && menu
  echo "Set location of your repository"
  read location
  [ "$location" == "" ] && menu
  flatpak --user remote-add --if-not-exists $answr $location
  menu
}
repo_list() {
  clear
  flatpak --user remotes
  echo "Press enter to contitue"
  read answr
  menu
}
repo_delete() {
  clear
  flatpak --user remotes
  echo "Set repository to remove"
  read answr
  [ "$answr" == "" ] && menu
  flatpak --user remote-delete $answr
  menu
}
menu() {
  clear
  check_repos
  echo "$for_user"
  flatpak --user list
  echo -e "
  ${red}${bold}1) install flatpak
  2) run flatpak
  3) update flatpaks
  4) add flatpaks to your desktop menu
  5) remove flatpak
  6) remove orphans
  7) list all the added repositories
  8) add a remote flatpak repository
  9) delete a remote flatpak repository
  10) exit${reset}"
  read -r answr
  [ "$answr" == "1" ] && install
  [ "$answr" == "2" ] && run
  [ "$answr" == "3" ] && update
  [ "$answr" == "4" ] && add
  [ "$answr" == "5" ] && remove
  [ "$answr" == "6" ] && orphans
  [ "$answr" == "7" ] && repo_list
  [ "$answr" == "8" ] && repo
  [ "$answr" == "9" ] && repo_delete
  [ "$answr" == "10" ] && quit
  [ "$answr" == "" ] && quit
}
menu
