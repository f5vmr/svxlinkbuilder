source "${BASH_SOURCE%/*}/functions/sound_card.sh"
soundcard
echo $HID $GPIOD $card
sleep 4
source "${BASH_SOURCE%/*}/functions/node_type.sh"
nodeoption
echo -e "$(date)" "${GREEN} #### Setting up Node #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/node_setup.sh"
nodeset