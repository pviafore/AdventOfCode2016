class Floor implements Cloneable 
{
    def microchips;
    def generators;

    def Floor(String floorInfo)
    {
        this.microchips = getEquipmentOnFloor floorInfo, "microchip"
        this.generators = getEquipmentOnFloor floorInfo, "generator"
        this.microchips = this.microchips.collect { new String(it.charAt(0))+"m" }
        this.generators = this.generators.collect { new String(it.charAt(0))+"g" }
    }

    private Floor() { }

    def clone()
    {
        def c = new Floor()
        c.microchips = this.microchips.collect { new String(it) }
        c.generators = this.generators.collect { new String(it) }
        c
    }

    def print()
    {
        this.microchips.each { println "Microchip $it" }
        this.generators.each { println "Generator $it" }
    }

    def isEmpty()
    {
        return this.microchips.isEmpty() && this.generators.isEmpty()
    }

    def remove(option)
    {
        option.each{ op ->
            if (op.charAt(1) == 'm') {
                this.microchips.remove(this.microchips.indexOf(op))
            }
            else if (op.charAt(1) == 'g')
            {
                this.generators.remove(this.generators.indexOf(op))
            }
        }
    }

    def add(option)
    {
        option.each {
            op ->
              if (op.charAt(1) =='m'){
                  this.microchips.add(op)
              }
              else
              {
                  this.generators.add(op)
              }
        }
    }

    def get_safely_removable_combos()
    {
        def safely_removable = []
        def combos = this.microchips.clone()
        combos.addAll(this.generators)
        combos.each { c1 ->
             combos.each { c2 ->
                if(!c1.equals(c2) &&  this.isSafeToLeave(this.microchips.grep {!it.equals(c1) && !it.equals(c2)}, this.generators.grep {!it.equals(c1) && !it.equals(c2)} ))
                {
                    if(c1.charAt(1) == c2.charAt(1) || c1.charAt(0) == c2.charAt(0))
                    {
                        safely_removable << [c1, c2].sort()
                    }
                }
            }
             if (this.isSafeToLeave(this.microchips.grep { !it.equals(c1)}, this.generators) ){
                safely_removable << [c1]
             } 
             if (this.isSafeToLeave(this.microchips, this.generators.grep { !it.equals(c1)}) ){
                safely_removable << [c1]
             }

        }
        safely_removable.unique()
    }

    def isSafeToLeave(microchips, generators)
    {
        return microchips.isEmpty() || microchips.every {mc ->  generators.isEmpty() || generators.any {gen -> mc.charAt(0) == gen.charAt(0)} }
    }

    def isSafe()
    {
        return isSafeToLeave(this.microchips, this.generators)
    }


    def getEquipmentOnFloor(String floorInfo, String type)
    {
        def words = floorInfo.split(" ");
        def output = []
        for(int i =0; i < words.length; ++i)
        {
            if(words[i].startsWith(type))
            {
                output << (words[i-1]);
            }
        }
        output;
    }
}

class Building implements Cloneable
{
    def floors;
    def elevator;
    def lastBuilding = null

    Building(String[] buildingInfo)
    {
        this.floors = buildingInfo.collect {it -> new Floor(it)}
        this.elevator = 0;       
    }

    private Building()
    { }

    def clone() {
        def blding = new Building()
        blding.floors = this.floors.collect { it.clone() }
        blding.elevator = this.elevator
        blding.lastBuilding = this
        return blding
    }

    def equals(Building bldg) {
        return this.getPairs() == bldg.getPairs()
    }

    def getPairs()
    {
        def pairs = [:]
        (0..3).each {
            this.floors[it].microchips.every {mc ->
                 if (pairs[mc.charAt(0)] == null) {
                     pairs[mc.charAt(0)] = [-1, -1]
                 } 
                  pairs[mc.charAt(0)][0] = it
            }
            this.floors[it].generators.every {gen ->
                 if (pairs[gen.charAt(0)] == null) {
                     pairs[gen.charAt(0)] = [-1, -1]
                 } 
                  pairs[gen.charAt(0)][1] = it
            }
        }
        pairs.values().sort()
    }

    def print(){
        this.floors.eachWithIndex { it, index->
            print "Floor -> "
            println index
            it.print();
            
        }
        println ""
    }

    def get_possible_things_to_remove()
    {
        this.floors[elevator].get_safely_removable_combos()
    }

    def makeMove(new_floor, option)
    {
        this.floors[this.elevator].remove(option)
        this.elevator = new_floor
        this.floors[this.elevator].add(option)
    }

    def isFinished()
    {
        return this.floors[0].isEmpty() && this.floors[1].isEmpty() && this.floors[2].isEmpty()
    }

    def isGood(lastFloor) {
        return this.floors[this.elevator].isSafe() && this.floors[lastFloor].isSafe()
    }

    def areFloorsBelowEmpty()
    {
        (0..(this.elevator-1)).every { this.floors[it].isEmpty()}
    }
}


def find_solution(building)
{
    def buildings = [building]
    def time
    def seenBuildings = [0:[building], 1:[], 2:[], 3:[]]
    for(time = 0; buildings.size()!=0 && !buildings.any { it.isFinished() }; ++time)
    {
        def newBuildings = []
        buildings.each { 
             bldg ->
                getBuildingCandidates(bldg).each 
                    { candidate ->
                    if(seenBuildings[candidate.elevator].every { !it.equals(candidate) } )
                        newBuildings << candidate
                        
                        seenBuildings[candidate.elevator] << candidate
                }
         }   
        buildings = newBuildings
        println buildings.size()
    }
    time
}

def getBuildingCandidates(bldg)
{
    def candidates = []
    def options = bldg.get_possible_things_to_remove()
    if (bldg.elevator < 3)
    {
        two_candidates = getCandidatesOnNewFloor(bldg, bldg.elevator+1, options.grep { it.size() == 2 })
        if (two_candidates.size() == 0){
            candidates.addAll(getCandidatesOnNewFloor(bldg, bldg.elevator+1, options.grep { it.size() == 1 }))
        }
        candidates.addAll(two_candidates)
    }
    if (bldg.elevator > 0 && !bldg.areFloorsBelowEmpty())
    {
        candidates.addAll(getCandidatesOnNewFloor(bldg, bldg.elevator-1, options.grep{it.size() == 1}))
    }
    candidates
}
def getCandidatesOnNewFloor(bldg, newFloor, options)
{
    def candidates = []

    options.each { option ->
        candidate = apply_move(newFloor, option, bldg)
        if(candidate.isGood(bldg.elevator)) {
            candidates << candidate                            
        }
    }
    candidates
}

def apply_move(floor, option, building)
{
    clonedBuilding = building.clone()
    clonedBuilding.makeMove(floor, option)
    clonedBuilding
}



def fileContents = new File("../day11.txt").text.split("\n")
def building = new Building(fileContents)


println find_solution(building)