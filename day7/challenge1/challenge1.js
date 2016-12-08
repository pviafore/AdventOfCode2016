const fs = require('fs')

function hasABBA(str){
    return str.match(/(\S)((?!\1).)\2\1/);
}

function splitOutSections(str){
    return str.split(/\[.*?\]/)
}

function getHypertext(str){
    return str.match(/\[(.*?)\]/g)
}

function isValid(str){
    return splitOutSections(str).some(hasABBA) &&
           getHypertext(str).every((str) => !hasABBA(str));

}

lines = fs.readFileSync("../day7.txt", "utf8").split("\n");
console.log(lines.filter(isValid).length);