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

DEFER: decompress
: split-on-match ( match -- a b c match ) 
                                  [ ! before the match - a
                                    [ 0 ] 
                                    [ from>> ] 
                                    [ seq>> ] 
                                    tri subseq length ] 
                                  [ ! length of the matched segment - b
                                    [ 
                                       ! selection number
                                       [ from>> ] 
                                       [ to>> ] 
                                       [ seq>> ] 
                                       tri subseq extract-numbers nip 
                                    ]
                                    
                                    [  ! repetition number
                                        [ from>> ] 
                                        [ to>> ] 
                                        [ seq>> ] 
                                        tri subseq extract-numbers drop 
                                    ] 
                                    [ ! everything after the (AxB) (up to x characters)
                                      [ to>> ]
                                      [ [ to>> ]
                                        [ [ from>> ] 
                                          [ to>> ] 
                                          [ seq>> ] 
                                          tri subseq extract-numbers drop  
                                        ]
                                        bi
                                        + 
                                      ] 
                                      [ seq>> ] 
                                      tri subseq  
                                    ]
                                    ! decompress the sequence
                                     tri decompress nip  * 
                                  ] 
                                  [ ! sequence of characters to start with again
                                    [ [ to>> ]
                                      [   
                                        [ from>> ] 
                                        [ to>> ] 
                                        [ seq>> ] 
                                        tri subseq extract-numbers  drop 
                                      ]
                                      bi 
                                       + 
                                    ] 
                                    [ seq>> length ] 
                                    [ seq>> ] 
                                    tri subseq  
                                  ] 
                                 tri  ;
: decompress ( str -- len ) dup get-match dup f eq? [ drop length ] [ nip split-on-match decompress dup fixnum? [  ] [ length ] if + + nip ] if ;
: read-file ( file-path encoding -- file-contents ) file-contents ;

"../day9.txt" utf8 read-file decompress .