interface Disc {
   totalPositions: number,
   initialPosition: number,
}

function* infiniteSequence(){
  var index = 0;
  while(true)
    yield index++;
}

function* filter(iterable:IterableIterator<number>, f:(number)=>boolean){
    for(let item of iterable){
        if(f(item)){
            yield item
        }
    }
    
}
//console.log(isTimeAllowed(6, {initialPosition:4, totalPositions:5}));

function toDisc(str:string): Disc {
    const regex:RegExp = /Disc #\d has (\d+) positions; at time=0, it is at position (\d+)./
    const matches = str.match(regex);
    return {totalPositions: parseInt(matches[1], 10), initialPosition: parseInt(matches[2], 10)}
}

function isTimeAllowed(num: number, disc:Disc)
{
    return ((num + disc.initialPosition) % disc.totalPositions) == 0;
}

function getAllowedPositions(iterable:IterableIterator<number>, disc:Disc, discNumber:number ){
    return filter(iterable, num => isTimeAllowed(num + discNumber + 1, disc));
}

declare function require(name:string);
const fs = require("fs");
const lines = fs.readFileSync("day15.txt", "utf8").split("\n");
const discs = lines.filter(s => s !== "").map(toDisc);
const allowedNumbers = discs.reduce(getAllowedPositions, infiniteSequence());
console.log(allowedNumbers.next().value);
