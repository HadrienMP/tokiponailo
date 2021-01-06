module Dictionary exposing (..)


import Day exposing (Day(..))
type Language
    = French
    | English


type alias Meanings =
    List String


type alias Word =
    { tokiPona : String
    , meanings : List ( Language, Meanings )
    }


all : List ( Day, List Word )
all =
    [ ( One, day1 )
    , ( Two, day2 )
    , ( Three, day3 )
    , ( Four, day4 )
    , ( Five, day5 )
    ]


day1 =
    [ { tokiPona = "mi"
      , meanings = [ ( French, [ "je" ] ), ( English, [ "I" ] ) ]
      }
    , { tokiPona = "sina"
      , meanings = [ ( French, [ "tu", "vous" ] ), ( English, [ "you" ] ) ]
      }
    , { tokiPona = "ona"
      , meanings = [ ( French, [ "il", "elle", "ils", "elles" ] ), ( English, [ "he", "she", "it", "they" ] ) ]
      }
    , { tokiPona = "ijo"
      , meanings = [ ( French, [ "chose" ] ), ( English, [ "thing" ] ) ]
      }
    , { tokiPona = "jan"
      , meanings = [ ( French, [ "personne" ] ), ( English, [ "person" ] ) ]
      }
    , { tokiPona = "pona"
      , meanings = [ ( French, [ "bien", "bon", "fixe" ] ), ( English, [ "good", "fix" ] ) ]
      }
    , { tokiPona = "ike"
      , meanings = [ ( French, [ "mauvais" ] ), ( English, [ "bad" ] ) ]
      }
    , { tokiPona = "moku"
      , meanings = [ ( French, [ "manger", "nourriture" ] ), ( English, [ "to eat", "food" ] ) ]
      }
    , { tokiPona = "suli"
      , meanings = [ ( French, [ "grand", "important" ] ), ( English, [ "big", "important" ] ) ]
      }
    , { tokiPona = "toki"
      , meanings = [ ( French, [ "langage", "parler", "salut" ] ), ( English, [ "language", "to speak", "hello" ] ) ]
      }
    ]


day2 =
    [ { tokiPona = "lili"
      , meanings = [ ( French, [ "petit" ] ), ( English, [ "small" ] ) ]
      }
    , { tokiPona = "telo"
      , meanings = [ ( French, [ "eau", "liquide" ] ), ( English, [ "water", "liquide" ] ) ]
      }
    , { tokiPona = "suno"
      , meanings = [ ( French, [ "soleil" ] ), ( English, [ "sun" ] ) ]
      }
    , { tokiPona = "ilo"
      , meanings = [ ( French, [ "outil" ] ), ( English, [ "tool" ] ) ]
      }
    , { tokiPona = "kili"
      , meanings = [ ( French, [ "fruit", "légume" ] ), ( English, [ "fruit", "vegetable" ] ) ]
      }
    , { tokiPona = "ni"
      , meanings = [ ( French, [ "ça" ] ), ( English, [ "this", "that" ] ) ]
      }
    , { tokiPona = "pipi"
      , meanings = [ ( French, [ "insecte", "vermine" ] ), ( English, [ "pest", "insect" ] ) ]
      }
    , { tokiPona = "ma"
      , meanings = [ ( French, [ "endroit" ] ), ( English, [ "place" ] ) ]
      }
    , { tokiPona = "pakala"
      , meanings = [ ( French, [ "erreur" ] ), ( English, [ "mistake" ] ) ]
      }
    ]


day3 =
    [ { tokiPona = "esun"
      , meanings = [ ( French, [ "boutique", "acheter" ] ), ( English, [ "shop", "buy" ] ) ]
      }
    , { tokiPona = "lukin"
      , meanings = [ ( French, [ "oeil", "voir" ] ), ( English, [ "eye", "see" ] ) ]
      }
    , { tokiPona = "jo"
      , meanings = [ ( French, [ "avoir" ] ), ( English, [ "have" ] ) ]
      }
    , { tokiPona = "pana"
      , meanings = [ ( French, [ "donner" ] ), ( English, [ "give" ] ) ]
      }
    , { tokiPona = "pali"
      , meanings = [ ( French, [ "faire", "travailler", "fabriquer" ] ), ( English, [ "do", "work", "make" ] ) ]
      }
    , { tokiPona = "wile"
      , meanings = [ ( French, [ "vouloir", "nécessiter" ] ), ( English, [ "want", "need" ] ) ]
      }
    , { tokiPona = "kute"
      , meanings = [ ( French, [ "oreille", "entendre" ] ), ( English, [ "ear", "listen" ] ) ]
      }
    , { tokiPona = "kalama"
      , meanings = [ ( French, [ "son" ] ), ( English, [ "sound" ] ) ]
      }
    , { tokiPona = "nasa"
      , meanings = [ ( French, [ "étrange" ] ), ( English, [ "strange" ] ) ]
      }
    ]


day4 =
    [ { tokiPona = "lipu"
      , meanings = [ ( French, [ "livre", "document", "enregistrement" ] ), ( English, [ "book", "document", "record" ] ) ]
      }
    , { tokiPona = "kulupu"
      , meanings = [ ( French, [ "groupe", "communauté" ] ), ( English, [ "group", "community" ] ) ]
      }
    , { tokiPona = "tenpo"
      , meanings = [ ( French, [ "temps", "durée", "événement" ] ), ( English, [ "time", "duration", "event" ] ) ]
      }
    , { tokiPona = "jaki"
      , meanings = [ ( French, [ "sale", "dégoutant" ] ), ( English, [ "dirty", "disgusting" ] ) ]
      }
    , { tokiPona = "linja"
      , meanings = [ ( French, [ "cheveux", "corde" ] ), ( English, [ "hair", "rope" ] ) ]
      }
    , { tokiPona = "luka"
      , meanings = [ ( French, [ "main", "bras" ] ), ( English, [ "hand", "arm" ] ) ]
      }
    , { tokiPona = "noka"
      , meanings = [ ( French, [ "pied", "jambe" ] ), ( English, [ "foot", "leg" ] ) ]
      }
    , { tokiPona = "lawa"
      , meanings = [ ( French, [ "tête", "controler" ] ), ( English, [ "head", "control" ] ) ]
      }
    , { tokiPona = "mama"
      , meanings = [ ( French, [ "parent", "ancêtre", "créateur" ] ), ( English, [ "parent", "ancestor", "creator" ] ) ]
      }
    ]


day5 =
    [ { tokiPona = "ken"
      , meanings = [ ( French, [ "pouvoir", "possibilité", "capacité" ] )]
      }
    , { tokiPona = "lape"
      , meanings = [ ( French, [ "sommeil", "repos" ] )]
      }
    , { tokiPona = "tomo"
      , meanings = [ ( French, [ "structure" ] )]
      }
    , { tokiPona = "sona"
      , meanings = [ ( French, [ "connaissance", "sagesse", "compétence", "science"] )]
      }
    , { tokiPona = "kala"
      , meanings = [ ( French, [ "poisson", "animal aquatique" ] )]
      }
    , { tokiPona = "sijelo"
      , meanings = [ ( French, [ "corps", "torse", "existence" ] )]
      }
    , { tokiPona = "kasi"
      , meanings = [ ( French, [ "plante" ] )]
      }
    , { tokiPona = "pini"
      , meanings = [ ( French, [ "fin", "terminé" ] )]
      }
    , { tokiPona = "kama"
      , meanings = [ ( French, [ "arriver", "démarrer", "devenir", "réussir" ] )]
      }
    ]
