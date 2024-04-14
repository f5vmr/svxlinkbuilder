NODE_OPTION="4"
echo -e "$(date)" "${GREEN} #### Setting up Node #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/node_setup.sh"
nodeset