#!/bin/bash -x
STAKE=100
LOSS=0
WON_COUNT=0
LOSE_COUNT=0
M=0
N=0
PT=0
GT=0
echo "stake per day =100$"
echo "per bet=1$"

function gamblingLimit(){
echo "enter at what percentage of win/lose should you stop gambling"
read limit
limitValue=$(echo "scale=2;$limit / 100"|bc);echo
b=$(echo "$limitValue * 100"|bc);
int=${b%\.*}
upperLimit=$(( $STAKE + $int ))
lowerLimit=$(( $STAKE - $int ))
}
function gambling(){
gamblingLimit
while [[ $STAKE -le $upperLimit && $LOSS -le $lowerLimit ]]
do
        c=$((RANDOM%2))
if [ $c -eq 0 ]
then
        echo "winner"
        STAKE=$(($STAKE + 1))
        u=$(($STAKE - 100))
        array[((M++))]=$u
        ((WON_COUNT++))
else
        echo "you lose"
        LOSS=$(($LOSS + 1))
        array1[((N++))]=$LOSS
        ((LOSE_COUNT++))
fi
done
gain=$(IFS=+; echo "$((${array[*]}))")
loss=$(IFS=+; echo "$((${array1[*]}))")
array3[((PT++))]=$gain
array4[((GT++))]=$loss
M=0
N=0
unset array
unset array1
}
function gamble20Days(){
for((i=1;i<=20;i++))
do
        gambling
done
echo "he won" $WON_COUNT "times"
echo "he lost" $LOSE_COUNT "times"
}
function luckyUnlucky(){
gamble20Days
for((j=1;j<=20;j++))
do
if [ ${array3[$j]} -le ${array3[$(($j-1))]} ]
then
        array3[$j]=${array3[$(($j-1))]}
fi
if [ ${array4[$j] -le ${array4[$(($j-1))]} ]
then
        array4[$j]=${array4[$(($j-1))]}
fi
done
echo "luckiest day earning is" ${array3[-1]}
echo "unluckiest day loss is" ${array4[-1]}
}
function continueGamblingOrNot(){
luckyUnlucky
totalGain=$(IFS=+; echo "$((${array3[*]}))")
totalLoss=$(IFS=+; echo "$((${array4[*]}))")
lossGainMargin=$(($totalGain - $totalLoss))
if [ $lossGainMargin -gt 0]
then
        echo "continue gambling"
else
        echo "stop gambling"
fi
}
continueGamblingOrNot
