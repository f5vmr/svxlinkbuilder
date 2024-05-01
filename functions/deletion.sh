#!/bin/bash
function delete {
#### Test for Simplex or Repeater ####

# Define the section name to be removed
if [ "$NODE_OPTION" -eq "1" ] || [ "$NODE_OPTION" -eq "2" ]; then
section_name="SimplexLogic"
elif [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then
section_name="RepeaterLogic"

fi

# Use sed to delete lines between [SimplexLogic] and the next section name
sed -i "/^\[$section_name\]/,/^ *\[/ {/^\[$section_name\]/b; /^\[/b; d}" "$svxconf_file"
echo "Section $section_name deleted from $svxconf_file" | tee -a /var/log/install.log







}