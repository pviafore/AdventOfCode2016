#!/bin/bash
target=$(<"../day18.txt")

getChar() {
    sequence=$1
    index=$2
    if [ "$index" == "-1" ]; then
        char="."
    elif [ "$index" == "${#sequence}" ]; then
        char="."
    else
        char=${sequence:$index:1}
    fi
}
getNextChar() {
    getChar $1 $(($2-1))
    char1=$char
    getChar $1 $2
    char2=$char
    getChar $1 $(($2+1))
    char3=$char
    if [[ "$char1" = "^" && "$char2" = "^" && "$char3" = "." ]]; then
        nextChar="^";
    elif [[ "$char1" = "." && "$char2" = "^" && "$char3" = "^" ]]; then
        nextChar="^";
    elif [[ "$char2" = "." && "$char1" = "." && "$char3" = "^" ]]; then
        nextChar="^";
    elif [[ "$char2" = "." && "$char3" = "." && "$char1" = "^" ]]; then
        nextChar="^";
    else   
         nextChar=".";
    fi
}

getNextSequence() {
    sequence=$1
    target=""
    for (( i=0; i<${#sequence}; i++)) 
    do
        getNextChar $sequence $i
        target=$target$nextChar
    done
}

rows=400000
fullString=""
count=0
for (( j=0; j<${rows}; j++))
do
    safe="${target//[^.]}"
    count=$(($count+${#safe}))
    getNextSequence $target
done
echo $count
