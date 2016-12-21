package main


import "crypto/md5"
import "encoding/hex"
import "fmt"
import "regexp"
import "strconv"

type Hash struct { 
    hash string
    triplets string
    quintuplets []string
}

var md5s map[int]Hash = make(map[int]Hash)
var salt = "zpqevtbw"
var re3 = regexp.MustCompile(`(aaa|bbb|ccc|ddd|eee|fff|000|111|222|333|444|555|666|777|888|999)`)
var re5 = regexp.MustCompile(`(aaaaa|bbbbb|ccccc|ddddd|eeeee|fffff|00000|11111|22222|33333|44444|55555|66666|77777|88888|99999)`)
   
 

func getHash(x int) Hash {
    if val, ok := md5s[x]; ok{
        return val
    }
    hasher := md5.New()
    hasher.Write([]byte(salt+strconv.Itoa(x)))

    hash := hex.EncodeToString(hasher.Sum(nil))

    triplet := re3.FindString(hash)
    t := ""
    if triplet != "" {
        t = string(triplet[0])
    }
    
    
    q := make([]string, 0)
    quintuplets := re5.FindAllString(hash, -1)
    for i := range quintuplets {
       q = append(q, string(quintuplets[i][0]))
        
    }

    md5s[x] = Hash{hash, t, q}
    return md5s[x]
}

func hasQuintuplet(x int, triplet string) bool {
    for i:= x+1; i <= x+1000; i++ {
        hash := getHash(i)
        for j:= range hash.quintuplets {
            if triplet == hash.quintuplets[j] {
                return true
            }
        }
    }
    return false
}

func main() {
    counter := 1
    for numberOfPads := 0; numberOfPads < 64;  {
        hash := getHash(counter)
        if hasQuintuplet(counter, hash.triplets) {
            numberOfPads += 1
        }
       
        counter+=1
    }
    fmt.Println(counter-1)
   
}
