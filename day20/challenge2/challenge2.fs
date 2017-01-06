open System

let readlines  = System.IO.File.ReadAllLines("../day20.txt")
let toInts arr =  Seq.map uint32 arr
let getFilterFunction range =  (fun x -> x >= (Seq.head range) && x <= (Seq.last range))
let doesFilterMatch num range = (getFilterFunction range) num
let getFiltersMatching num ranges = Seq.filter (fun f -> doesFilterMatch num f) ranges

let getFirstInvalidNumber ranges =
         ranges
         |> Seq.map (fun r -> (Seq.head r))
         |> Seq.min

let getNextStartingNumber num ranges = 
        getFiltersMatching num ranges
        |> Seq.map (fun r -> (Seq.last r))
        |> Seq.filter (fun x -> x >= num)
        |> Seq.min

let isNumBeforeRange num range =
        num < (Seq.head range)

let getRemainingRanges ranges num =
        ranges
        |> Seq.filter (fun r -> (isNumBeforeRange num r) )

let getLastValidNumber ranges =
         match (Seq.isEmpty ranges) with
         | false ->
                ranges
                |> Seq.map (fun r -> (Seq.last r))
                |> Seq.max
         | true -> System.UInt32.MaxValue

let rec solve num accum  ranges = 
        let matching = (getFiltersMatching num ranges)
        let remainingRanges = (getRemainingRanges ranges num)
        match Seq.isEmpty matching with
        | true ->
            match (Seq.isEmpty remainingRanges) with
            | true -> accum + (System.UInt32.MaxValue - num) + 1u
            | false -> 
                let invalidNumber = (getFirstInvalidNumber remainingRanges)
                let diff = invalidNumber - num
                solve (getNextStartingNumber (invalidNumber+1u) remainingRanges) (accum + diff) remainingRanges
        | false ->     
            let lastValid = (getLastValidNumber matching)
            match lastValid with
            | System.UInt32.MaxValue -> accum
            | otherwise -> solve (lastValid+1u) accum remainingRanges
       

[<EntryPoint>]
let main argv = 
        Seq.toArray readlines 
        |> Seq.map (fun x -> x.Split[|'-'|])
        |> Seq.map toInts
        |> solve 0u 0u
        |> printfn "%d"
        0

