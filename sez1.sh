#!/bin/bash
arr=(0 5 12 18 28)
function sum {
eval a=\$$3$1
eval $3$1=$(echo $(python -c "print($a+$2)"))
}
#cd /mnt/d/GSTR1
#for value in /mnt/d/GSTR1/*.zip; do 7z x $value; done
#clear
for value in $1/*.json
do
for val in ${arr[@]}
do
txval=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWP") | .itms[].itm_det | select(.rt==$a) | .txval // 0] | add // 0 else 0 end' $value )
sum $val $txval "tsewp"
iamt=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWP") | .itms[].itm_det | select(.rt==$a) | .iamt // 0] | add // 0 else 0 end' $value )
sum $val $iamt "tsewpiamt"
camt=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWP") | .itms[].itm_det | select(.rt==$a) | .camt // 0] | add // 0 else 0 end' $value )
sum $val $camt "tsewpcamt"
sewop=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWOP") | .itms[].itm_det | select(.rt==$a) | .txval // 0] | add // 0 else 0 end' $value )
sum $val $sewop "tsewop"
sewopiamt=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWOP") | .itms[].itm_det | select(.rt==$a) | .iamt // 0] | add // 0 else 0 end' $value )
sum $val $sewopiamt "tsewopiamt"
sewopcamt=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWOP") | .itms[].itm_det | select(.rt==$a) | .camt // 0] | add // 0 else 0 end' $value )
sum $val $sewopcamt "tsewopcamt"
demexp=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="DE") | .itms[].itm_det | select(.rt==$a) | .txval // 0] | add // 0 else 0 end' $value )
sum $val $demexp "tdemexp"
demexpiamt=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="DE") | .itms[].itm_det | select(.rt==$a) | .iamt // 0] | add // 0 else 0 end' $value )
sum $val $demexpiamt "tdemexpiamt"
demexpcamt=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="DE") | .itms[].itm_det | select(.rt==$a) | .camt // 0] | add // 0 else 0 end' $value )
sum $val $demexpcamt "tdemexpcamt"
done
done
count=0
names='tsewp tsewpcamt tsewpcamt tsewpiamt tsewop tsewopcamt tsewopcamt tsewopiamt tdemexp tdemexpcamt tdemexpcamt tdemexpiamt'
function print {
echo -e "$(tput setaf 1)$(tput setab 7)$(tput bold)Description | Taxable Value (₹) | Central Tax (₹) | State Tax(₹) | Integrated Tax(₹)$(tput sgr 0) "
#echo ___________________________________________________________________________________________________________________________________________________________
for value in ${arr[@]}
do
#eval tax=\$$value; eval iamnt=\$iamt$value;eval camnt=\$camt$value
#ttax=$(echo $(python -c "print($ttax+$tax)"))
#tiamt=$(echo $(python -c "print($tiamt+$iamnt)"))
#tcamt=$(echo $(python -c "print($tcamt+$camnt)"))		
for val in $names
do
eval a=\$$val$value
if ! (($count % 4)); then echo ""; echo -n "$val$value"; fi
echo -ne " | $a"
let count+=1
done
echo ""
done
#echo ___________________________________________________________________________________________________________________________________________________________
echo "ztotal | $ttax | $tcamt | $tcamt | $tiamt"
}

echo ___________________________________________________________________________________________________________________________________________________________
echo "$(tput setaf1)$(tput bold)SEZ with and without payment, deemed export(tput sgr 0)"
echo $(tput bold)___________________________________________________________________________________________________________________________________________________________$(tput sgr 0)
echo 
print > out.txt
column out.txt -t -s "|" > /root/temp.txt
head -n 1 /root/temp.txt && tail -n +2 /root/temp.txt | sort -V
echo "Note:- B2B contains the above, to get net b2b which is Regular negate the above with b2b total"
echo ===========================================================================================================================================================
