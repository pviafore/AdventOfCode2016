const fs = require('fs')

function isABA(substring) {
   
    return substring[0] === substring[2] && substring[1] !== substring[0]
}
function getABA(str){
    var abas = []
    for(let i = 0; i < str.length; i++){
        const substring = str.substring(i, i+3);
        if (substring.length == 3 && isABA(substring)) {
            abas.push(substring);
        } 
    }
    return abas;
}

function splitOutSections(str){
    return str.split(/\[.*?\]/)
}

function getHypertext(str){
    return str.match(/\[(.*?)\]/g)
}

function flip(str){
    return str[1] + str[0] + str[1];
}

function isValid(str){
    var abas = splitOutSections(str).map(getABA)
                                .filter((x) => {return x;})
                                .reduce((a,b) => { return a.concat(b)}, []);
    var babs = getHypertext(str).map(getABA)
                            .filter((x) => {return x;})
                            .reduce((a,b) => { return a.concat(b)}, []);

    return abas.some((aba) => {return babs.includes(flip(aba));});
}

lines = fs.readFileSync("../day7.txt", "utf8").split("\n");
console.log(lines.filter(isValid).length);