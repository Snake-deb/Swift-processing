#!/bin/bash
arr=(0 5 12 18 28)
function sum {
eval a=\$$3$1
eval $3$1=$(echo $(python -c "print($a+$2)"))
}
cd /mnt/d/GSTR1
for value in /mnt/d/GSTR1/*.zip; do 7z x $value; done
clear
for value in $1/*.json
do
for val in ${arr[@]}
do
txval=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWP") | .itms[].itm_det | select(.rt==$a) | .txval // 0] | add // 0 else 0 end' $value )
sum $val $txval "txv"
iamt=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWP") | .itms[].itm_det | select(.rt==$a) | .iamt // 0] | add // 0 else 0 end' $value )
sum $val $iamt "iamt"
camt=$( jq --argjson a "$val" 'if .b2b!=null then [.b2b[].inv[] | select(.inv_typ=="SEWP") | .itms[].itm_det | select(.rt==$a) | .camt // 0] | add // 0 else 0 end' $value )
sum $val $camt "camt"
done
done

echo 5 "$txv5"
echo 5 "$camt5"
echo 5 "$iamt5"

count=0
names='txv camt camt iamt'
echo ___________________________________________________________________________________________________________________________________________________________
echo 
echo -e "$(tput setaf 1)$(tput setab 7)$(tput bold)Description\t\tTaxable Value (₹)\t\tCentral Tax (₹)\t\t\tState Tax(₹)\t\tIntegrated Tax(₹)$(tput sgr 0) "
echo
for value in ${arr[@]}
do
for val in $names
do
eval a=\$$val$value
#eval b=\$$val$ret$value
#a2=$(echo $(python -c "print($a-$b)"))
if ! (($count % 4)); then echo -n "$value"; fi
if (( $(echo "$a > 0" | bc -l) )); then	echo -ne "\t\t\t$a" ; fi
let count+=1
done
echo ""
done
echo ===========================================================================================================================================================
