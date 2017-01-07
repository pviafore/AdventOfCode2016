<?php

$head = 0;
$arr = array("a", "b", "c", "d", "e", "f", "g", "h");

function convertIndex($index){
    global $arr, $head;
    $newIndex = $index+$head;
    while($newIndex < 0){
        $newIndex += sizeof($arr);
    }
    return  $newIndex%sizeof($arr);
}
function getCharAt($index)
{
    global $arr, $head;
    $newIndex =convertIndex($index);
    return $arr[$newIndex];
}

function setCharAt($index, $value)
{
    global $arr, $head;
    $arr[convertIndex($index)] = $value;
}

function swapPos($pos1, $pos2) {
    $tmp1 = getCharAt($pos1);
    $tmp2 = getCharAt($pos2);
    setCharAt($pos1, $tmp2);
    setCharAt($pos2, $tmp1);
}

function swapLetters($letter1, $letter2) {
    global $arr;
    $index1 = array_search($letter1, $arr);
    $index2 = array_search($letter2, $arr);
    $arr[$index2] = $letter1;
    $arr[$index1] = $letter2;
}

function reverse($pos1, $pos2) {
    for ($i = $pos1, $j=$pos2; $i < $j; $i++, $j--){
        swapPos($i, $j);
    }
}

function printArray() {
    global $arr;
    for ($i = 0; $i < sizeof($arr); $i++){
        echo getCharAt($i);
    }
    echo "\n";
}

function rotateLeft($steps)
{
    global $head;
    $head += $steps;
}

function rotateRight($steps)
{
    global $head;
    $head -= $steps;
}

function move($from, $to) {
    global $arr;
    
    if ($to < $from) {
        $char = getCharAt($from);
        for ($i = $from-1; $i>=$to; $i--){ 
            $newChar = getCharAt($i);
            setCharAt($i, $char);
            setCharAt($i+1, $newChar);
        }
    }
    else {
        $char = getCharAt($from);
        for ($i = $from+1; $i<=$to; $i++){ 
            $newChar = getCharAt($i);
            setCharAt($i, $char);
            setCharAt($i-1, $newChar);
        }
    }
}

function rotatePos($letter) {
    global $arr, $head;
    $index = 0;
    for ($i = 0; $i < sizeof($arr); $i++){
        if (getCharAt($i) == $letter) {
            $index = $i;
            break;
        }
    }
    if ($index >= 4) {
        $index += 1;
    }
    rotateRight($index+1);
}

function getLines() {
    $f = fopen("../day21.txt", "r");
    $lines = array();
    while (($buffer = fgets($f)) !== false) {
        $lines[] = trim($buffer);
    }
    fclose($f);
    return $lines;
}

function processLine($line) {
    $words = explode(" ", $line);
    if($words[0] == "swap" && $words[1] =="position"){
        swapPos($words[2], $words[5]);
    }
    if($words[0] == "swap" && $words[1] =="letter"){
        swapLetters($words[2], $words[5]);
    }
    if($words[0] == "rotate" && $words[1] =="left"){
        rotateLeft($words[2]);
    }
    if($words[0] == "rotate" && $words[1] =="right"){
        rotateRight($words[2]);
    }
    if($words[0] == "rotate" && $words[1] =="based"){
        rotatePos($words[6]);
    }
    if($words[0] == "reverse"){
        reverse($words[2], $words[4]);
    }
    if($words[0] == "move"){
        move($words[2], $words[5]);
    }
}


$lines = getLines();
foreach($lines as $line){   
    processLine($line);
}
printArray();
?>