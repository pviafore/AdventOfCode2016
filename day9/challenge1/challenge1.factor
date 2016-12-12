USE: accessors
USE: io
USE: io.encodings.utf8
USE: io.files
USE: kernel
USE: math
USE: math.parser
USE: pairs
USE: prettyprint
USE: regexp
USE: sequences
USE: splitting
USE: strings


IN: challenge1

: get-match ( str -- match ) R/ \((\d+)x(\d+)\)/ first-match ;
: extract-first-number ( str -- x ) dup R/ \d+x/ first-match [ from>> ] [ to>> 1 - ] bi pick subseq nip string>number ;
: extract-second-number ( str -- x ) dup R/ x\d+/ first-match [ from>> 1 + ] [ to>> ] bi pick subseq nip string>number ;
: extract-numbers ( str -- sel rep ) [ extract-first-number ] [ extract-second-number ] bi ;

: split-on-match ( match -- a b c match ) [ [ 0 ] 
                                    [ from>> ] 
                                    [ seq>> ] 
                                    tri subseq ] 
                                  [ [ from>> ] 
                                    [ to>> ] 
                                    [ seq>> ] 
                                    tri subseq extract-numbers * 48 <string> ] 
                                  [ [ [ to>> ]
                                      [   
                                        [ from>> ] 
                                        [ to>> ] 
                                        [ seq>> ] 
                                        tri subseq extract-numbers  drop ]
                                      bi 
                                       + ] 
                                    [ seq>> length ] 
                                    [ seq>> ] 
                                    tri subseq  ] 
                                 tri  ;
: decompress ( str -- str ) dup get-match dup f eq? [ drop ] [ nip split-on-match decompress append append nip ] if ;
: read-file ( file-path encoding -- file-contents ) file-contents ;

"../day9.txt" utf8 read-file decompress dup . length .