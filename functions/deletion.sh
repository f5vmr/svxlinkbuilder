#!/bin/bash
function delete {
#### Test for Simplex or Repeater ####

# Define the section name to be removed
if [[ "$NODE_OPTION" == "1" ]] || [[ "$NODE_OPTION" == "2" ]]; then
section_name="SimplexLogic"
elif [[ "$NODE_OPTION" == "3" ]] || [[ "$NODE_OPTION" == "4" ]]; then
section_name="RepeaterLogic"

fi

# Use sed to delete lines between [SimplexLogic] and the next section name
sudo sed -i "/^\[$section_name\]/,/^ *\[/ {/^\[$section_name\]/b; /^\[/b; d}" "$svxconf_file"
echo "Section $section_name deleted from $svxconf_file" | sudo tee -a /var/log/install.log







}