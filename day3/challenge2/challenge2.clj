(defn read-file [] (slurp "../day3.txt"))
(defn split-lines [str] (clojure.string/split str #"\n"))


(defn get-numbers [string] (->>
                            (clojure.string/split string #" ")
                            (remove #(= % "" ))
                            (map read-string)
                            )
)

(defn make-numbers [strings] (map get-numbers strings))

(defn make-triangles [[[a1 b1 c1] [a2 b2 c2] [a3 b3 c3] & triangles]] 
    (let [new-triangles [[a1 a2 a3] [b1 b2 b3] [c1 c2 c3]]]
       (if (empty? triangles)
        new-triangles
        (concat new-triangles (make-triangles triangles))
       )
    )
)

(defn is-valid-triangle [t] (let [[a b c] (sort t)] (> (+ a b) c)))
(defn get-valid-triangles [triangles] (filter is-valid-triangle triangles))

(defn main [] (->
               (read-file)
               (split-lines)
               (make-numbers)
               (make-triangles)
               (get-valid-triangles)
               (count)
              )
)

(main)
 