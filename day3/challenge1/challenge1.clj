(defn read-file [] (slurp "../day3.txt"))
(defn split-lines [str] (clojure.string/split str #"\n"))


(defn make-triangle [string] (->>
                            (clojure.string/split string #" ")
                            (remove #(= % "" ))
                            (map read-string)
                            (sort)
                            )
)

(defn make-triangles [strings] (map make-triangle strings))

(defn is-valid-triangle? [[a b c]] (> (+ a b) c))
(defn get-valid-triangles [triangles] (filter is-valid-triangle? triangles))

(defn main [] (->
               (read-file)
               (split-lines)
               (make-triangles)
               (get-valid-triangles)
               (count)
              )
)

(main)
               