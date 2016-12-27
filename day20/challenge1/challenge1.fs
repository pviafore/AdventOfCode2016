open System

let readlines  = System.IO.File.ReadAllLines("../day20.txt")
let toInts arr =  Seq.map uint32 arr
let getFilterFunction range =  (fun x -> x < (Seq.head range) || x > (Seq.last range))
let uintRange = seq { System.UInt32.MinValue..System.UInt32.MaxValue} 
let allFiltersPass (filters:seq<(UInt32->bool)>) (num:UInt32) = Seq.forall (fun f -> (f num)) filters
let skipIfOutOfRange filterFuncs = uintRange |> Seq.skipWhile (fun x -> (not (allFiltersPass filterFuncs x)) )

[<EntryPoint>]
let main argv = 
        Seq.toArray readlines 
        |> Seq.map (fun x -> x.Split[|'-'|])
        |> Seq.map toInts
        |> Seq.map getFilterFunction
        |> skipIfOutOfRange
        |> Seq.head
        |> printfn "%d"
        0

