#!/bin/bash
if [ "$NODE_OPTION" -eq 3 ] || [ "$NODE_OPTION" -eq 4 ]; then
RepeaterLogic="RepeaterLogic.tcl"
logicfile="$LOGIC_DIR/$RepeaterLogic"
    # Code to execute if NODE_OPTION is equal to 3 or 4
    echo "NODE_OPTION is 3 or 4. Executing code..."
    # Add your code here
## options are Bell - Chime - Pip - Silence.
## The default is Bell. Do nothing if you do not want to change the default.
## The second is Chime. Change the values in RepeaterLogic.tcl
sed -i's/playTone 1100/playTone 1180/g' "$logicfile"
## The third is pip. Hash out the playTone Lines in RepeaterLogic.tcl and add CW::play "E"
sed -i's/playTone 1100/\#playTone 1100/g' "$logicfile"
sed -i's/playTone 1200/\#playTone 1200/g' "$logicfile"
sed -i '/#playTone 1200 \[expr {round(pow(\$base, \$i) \* 150 \/ \$max)}\] 100;/a\with CW::play "E";' "$logicfile"

## Fourth Hashout the playTone Lines in RepeaterLogic.tcl
sed -i's/playTone 1100/\#playTone 1100/g' "$logicfile"
sed -i's/playTone 1200/\#playTone 1200/g' "$logicfile"
####
#### how long to play the IdleTones IDLE_TIMEOUT=10 
IDLE_TIMEOUT=10
#### Add "-" "...-.-" to CW.tcl
CWLogic="CW.tcl"
cwfile="$LOGIC_DIR/$CWLogic"
# Adding the VA Bar code to CW.tcl
sed -i '/\"=\" \"-\.\.\.-\"/a \"-\" \"...-.-\"' "$cwfile"
sed -i "s/playTone 400 900/\#playTone 400 900/g" "$logicfile"
sed -i "s/playTone 360 900/\#playTone 360 900/g" "$logicfile"
sed -i '/#playTone 360 900 /a CW::play "-";' "$logicfile"





#### 


else
    # Code to execute if NODE_OPTION is not equal to 3 or 4
    echo "NODE_OPTION is not 3 or 4. Skipping code..."
    # Add optional alternative code here
fi