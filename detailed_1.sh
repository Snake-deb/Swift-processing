#!/bin/bash
arr=(0 5 12 18 28)
function sum {
eval a=\$$3$1
eval $3$1=$(echo $(python -c "print($a+$2)"))
}
function sum_ret {
eval b=\$$3$1
eval $3$1=$(echo $(python -c "print($b+$2)"))
}

cd /mnt/d/GSTR1
#for value in /mnt/d/GSTR1/*.zip; do 7z x $value; done
#clear
for value in $1/*.json
do
for val in ${arr[@]}
do
    date=$(jq .fp $value)
    txvrt=$( jq --argjson a "$val" 'if .b2b !=null then [.b2b[].inv[].itms[].itm_det | select(.rt==$a) | .txval // 0] | add // 0 else 0 end' $value)
    sum $val $txvrt "tb2b"
    iamtrt=$(jq --argjson a "$val" 'if .b2b !=null then [.b2b[].inv[].itms[].itm_det | select(.rt==$a) | .iamt // 0] | add // 0 else 0 end' $value)
    sum $val $iamtrt "tb2biamt"
    camtrt=$(jq --argjson a "$val" 'if .b2b !=null then [.b2b[].inv[].itms[].itm_det | select(.rt==$a) | .camt // 0] | add // 0 else 0 end' $value)
    sum $val $camtrt "tb2bcamt"
    b2cltv=$( jq --argjson a "$val" 'if .b2cl != null then [.b2cl[].inv[].itms[].itm_det | select(.rt==$a) | .txval // 0] | add // 0 else 0 end' $value)
    sum $val $b2cltv "tb2cl"
    b2cliamt=$( jq --argjson a "$val" 'if .b2cl != null then [.b2cl[].inv[].itms[].itm_det | select(.rt==$a) | .iamt // 0] | add // 0 else 0 end' $value)
    sum $val $b2cliamt "tb2cliamt"
    b2clcamt=$( jq --argjson a "$val" 'if .b2cl != null then [.b2cl[].inv[].itms[].itm_det | select(.rt==$a) | .camt // 0] | add // 0 else 0 end' $value)
    sum $val $b2clcamt "tb2clcamt"
    b2cstv=$(jq --argjson a "$val" 'if .b2cs != null then [.b2cs[] | select(.rt==$a) | .txval // 0] | add // 0 else 0 end' $value)
    sum $val $b2cstv "tb2cs"
    b2csiamt=$(jq --argjson a "$val" 'if .b2cs != null then [.b2cs[] | select(.rt==$a) | .iamt // 0] | add // 0 else 0 end' $value)
    sum $val $b2csiamt "tb2csiamt"
    b2cscamt=$(jq --argjson a "$val" 'if .b2cs != null then [.b2cs[] | select(.rt==$a) | .camt // 0] | add // 0 else 0 end' $value)
    sum $val $b2cscamt "tb2cscamt"
    exptv=$(jq --argjson a "$val" 'if .exp != null then [.exp[].inv[].itms[] | select(.rt==$a) | .txval // 0] | add //0 else 0 end' $value)
    sum $val $exptv "texp"
    expiamt=$(jq --argjson a "$val" 'if .exp != null then [.exp[].inv[].itms[] | select(.rt==$a) | .iamt // 0] | add //0 else 0 end' $value)
    sum $val $expiamt "texpiamt"
    expcamt=$(jq --argjson a "$val" 'if .exp != null then [.exp[].inv[].itms[] | select(.rt==$a) | .camt // 0] | add //0 else 0 end' $value)
    sum $val $expcamt "texpcamt"
    if [ $val -eq 0 ]
    then	    
    ngsup=$(jq --argjson a "$val" 'if .nil != null then [.nil.inv[].ngsup_amt] | add //0 else 0 end' $value)
    #echo "ngsup $date $ngsup"
    sum 0 $ngsup "tngsup"
    nil=$(jq --argjson a "$val" 'if .nil != null then [.nil.inv[].nil_amt] | add //0 else 0 end' $value)
    #echo "nil $date $nil"
    sum 0 $nil "tnil"
    expt=$(jq --argjson a "$val" 'if .nil != null then [.nil.inv[].expt_amt] | add //0 else 0 end' $value)
    #echo "expt $date $expt"
    sum 0 $expt "texpt"
    fi
    cnrtv=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="C") | .itms[].itm_det | select(.rt==$a) | .txval] | add // 0 else 0 end' $value)
    sum_ret $val $cnrtv "tcnr"
    cnriamt=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="C") | .itms[].itm_det | select(.rt==$a) | .iamt] | add // 0 else 0 end' $value)
    sum_ret $val $cnriamt "tcnriamt"
    cnrcamt=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="C") | .itms[].itm_det | select(.rt==$a) | .camt] | add // 0 else 0 end' $value)
    sum_ret $val $cnrcamt "tcnrcamt"
    dnrtv=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="D") | .itms[].itm_det | select(.rt==$a) | .txval] | add // 0 else 0 end' $value)
    sum_ret $val $dnrtv "tdnr"
    dnriamt=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="D") | .itms[].itm_det | select(.rt==$a) | .iamt] | add // 0 else 0 end' $value)
    sum_ret $val $dnriamt "tdnriamt"
    dnrcamt=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="D") | .itms[].itm_det | select(.rt==$a) | .camt] | add // 0 else 0 end' $value)
    sum_ret $val $dnrcamt "tdnrcamt"
    rvrtv=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="R") | .itms[].itm_det | select(.rt==$a) | .txval] | add // 0 else 0 end' $value)
    sum_ret $val $rvrtv "trvr"
    rvriamt=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="R") | .itms[].itm_det | select(.rt==$a) | .iamt] | add // 0 else 0 end' $value)
    sum_ret $val $rvriamt "trvriamt"
    rvrcamt=$(jq --argjson a "$val" 'if .cdnr != null then [.cdnr[].nt[] | select(.ntty=="R") | .itms[].itm_det | select(.rt==$a) | .camt] | add // 0 else 0 end' $value)
    sum_ret $val $rvrcamt "trvrcamt"
    cnurtv=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="C") | .itms[].itm_det | select(.rt==$a) | .txval] | add //0 else 0 end' $value)
    sum_ret $val $cnurtv "tcnur"
    cnuriamt=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="C") | .itms[].itm_det | select(.rt==$a) | .iamt] | add //0 else 0 end' $value)
    sum_ret $val $cnuriamt "tcnuriamt"
    cnurcamt=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="C") | .itms[].itm_det | select(.rt==$a) | .camt] | add //0 else 0 end' $value)
    sum_ret $val $cnurcamt "tcnurcamt"
    dnurtv=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="D") | .itms[].itm_det | select(.rt==$a) | .txval] | add //0 else 0 end' $value)
    sum_ret $val $dnurtv "tdnur"
    dnuriamt=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="D") | .itms[].itm_det | select(.rt==$a) | .iamt] | add //0 else 0 end' $value)
    sum_ret $val $dnuriamt "tdnuriamt"
    dnurcamt=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="D") | .itms[].itm_det | select(.rt==$a) | .camt] | add //0 else 0 end' $value)
    sum_ret $val $dnurcamt "tdnurcamt"
    rvurtv=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="R") | .itms[].itm_det | select(.rt==$a) | .txval] | add //0 else 0 end' $value)
    sum_ret $val $rvurtv "trvur"
    rvuriamt=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="R") | .itms[].itm_det | select(.rt==$a) | .iamt] | add //0 else 0 end' $value)
    sum_ret $val $rvuriamt "trvuriamt"
    rvurcamt=$(jq --argjson a "$val" 'if .cdnur != null then [.cdnur[] | select(.ntty=="R") | .itms[].itm_det | select(.rt==$a) | .camt] | add //0 else 0 end' $value)
    sum_ret $val $rvurcamt "trvurcamt"
done
done

#echo $txv5 $txvret5
count=0
names='tb2b tb2bcamt tb2bcamt tb2biamt tb2cl tb2clcamt tb2clcamt tb2cliamt tb2cs tb2cscamt tb2cscamt tb2csiamt texp texpcamt texpcamt texpiamt tcnr tcnrcamt tcnrcamt tcnriamt tdnr tdnrcamt tdnrcamt tdnriamt trvr trvrcamt trvrcamt trvriamt tcnur tcnurcamt tcnurcamt tcnuriamt tdnur tdnurcamt tdnurcamt tdnuriamt trvur trvurcamt trvurcamt trvuriamt'
tab='\t\t\t'
ret='ret'
function print {
echo 
echo -e "$(tput setaf 1)$(tput setab 7)$(tput bold)Description | Taxable Value (₹) | Central Tax (₹) | State Tax(₹) | Integrated Tax(₹)$(tput sgr 0) "
echo
for value in ${arr[@]}
do
#eval tax=\$txv$value; eval iamnt=\$iamt$value;eval camnt=\$camt$value;eval tax_ret=\$txvret$value; eval iamntret=\$iamtret$value; eval camntret=\$camtret$value
#ttax=$(echo $(python -c "print($ttax+($tax-$tax_ret))"))
#tiamt=$(echo $(python -c "print($tiamt+($iamnt-$iamntret))"))
#tcamt=$(echo $(python -c "print($tcamt+($camnt-$camntret))"))
#echo "$value | $tax | $camnt | $camnt | $iamnt"
#echo "$value | $tax_ret | $camntret | $camntret | $iamnt"
for val in $names
do
eval a=\$$val$value
#eval b=\$$val$ret$value
#a2=$(echo $(python -c "print($a)"))
if ! (($count % 4)); then echo "" ; fi
if ! (($count % 4)); then echo -n "$val$value"; fi
echo -ne " | $a"
let count+=1

done
echo ""
done
echo "tngsup | $tngsup0 | 0 | 0 | 0 "
echo "tnil | $tnil0 | 0 | 0 | 0 "
echo "texpt | $texpt0 | 0 | 0 | 0 "
echo "ztotal | $ttax | $tcamt | $tcamt | $tiamt"
}
echo ___________________________________________________________________________________________________________________________________________________________
echo "b2b to export detailed"
echo ___________________________________________________________________________________________________________________________________________________________
print > out.txt
column out.txt -t -s "|" > /root/temp.txt
head -n 1 /root/temp.txt && tail -n +2 /root/temp.txt | sort -V
echo ===========================================================================================================================================================
echo ""
echo "SEZ AND DEEMED EXPORT VALUES LOADING"
echo ""
cd /root
./sez1.sh $1


