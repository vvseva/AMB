extensions [table cf]

turtles-own [ wealth
  cards
  cube
  attractions
  pidor
  ;
  hand
  me
  n
  lost
  SM
]

globals[
  task
  x
  desk
]

to setup
  clear-all
  create-turtles players [
    set wealth 3
    set shape "circle 2"
    set color one-of [white white white]
    set size 1
    set cards 2
    set cube 5
    set attractions 4
    set me self
    set n 0
    set lost 0
    set SM 1
    ;;
    ;;
    set hand table:make
    table:put hand "bread" 1
    table:put hand "field" 1
    table:put hand "coffe" 0
    table:put hand "cheese" 0
    table:put hand "shop" 0
    table:put hand "forest" 0
    ;; visualize the turtles from left to right in ascending order of wealth
    setxy cards - 2 1
  ]
  set desk table:make
  table:put desk "bread" 6
  table:put desk "field" 6
  table:put desk "coffe" 5
  table:put desk "cheese" 6
  table:put desk "shop" 6
  table:put desk "forest" 6
  reset-ticks
end






to go
  if any? turtles with [ size = 5 ] [
    ask turtles with [size = 5] [
    print hand]
    stop ]
  ;if max (table:values desk) = 0 [ stop ]
  ask turtles [act colour]
  ask turtles with [wealth <= 0] [set wealth 0]
  ;; transact and then update your location
  ;; prevent wealthy turtles from moving too far to the right
  ask turtles [ if cards <= max-pxcor [ set xcor cards ]
  ]
  ask turtles [ if wealth <= max-pycor [ set ycor wealth ]
  ]
  ;;;
  tick
end

to act
  set cube one-of [1 2 3 4 5 6]
  pay
  earn
  win
  buy
  print cube
end

to buy
  set x random 120
    if (wealth >= 5) [
    ifelse x < 20 [ buy-field ]
    [ ifelse x < 40 [ buy-cheese ]
      [ ifelse x < 60 [ buy-bread ]
        [ ifelse x < 80 [ buy-coffe ]
          [ ifelse x < 100 [ buy-forest ]
            [ buy-shop ]
          ]
        ]
      ]
    ] stop
  ]
  ;;;;;
  if (wealth >= 4) [
    ifelse x < 24 [ buy-field ]
    [ ifelse x < 48 [ buy-cheese ]
      [ ifelse x < 72 [ buy-bread ]
        [ ifelse x < 96 [ buy-coffe ]
          [ buy-shop ]
        ]
      ]
    ] stop
  ]
  ;;;;;;;;;;
  if (wealth >= 2) [
    ifelse x < 30 [ buy-field ]
    [ifelse x < 60 [ buy-cheese ]
      [ifelse x < 90 [ buy-bread ]
        [ buy-coffe ]
      ]
    ] stop
  ]
  if (wealth >= 1) [
    ifelse x < 40 [ buy-field ]
    [ ifelse x < 80 [ buy-cheese ]
      [ buy-bread ]
    ]
  ]

end


to earn
  if (cube = 1) [
    ask turtles with [(table:get hand "field") >= 1 ] [
    set wealth wealth + 1 * (table:get hand "field")]
  ]
  if (cube = 2)[
    ask turtles with [(table:get hand "cheese") >= 1 ] [
    set wealth wealth + 1 * (table:get hand "cheese")
    ]
  ]
  if (cube = 4 and (table:get hand "shop") >= 1) [
  set wealth wealth + 4 * (table:get hand "shop")
  ]

  if((cube = 2 or cube = 3) and (table:get hand "bread") >= 1)[
  set wealth wealth + 1 * (table:get hand "bread")
  ]

  if (cube = 5) [
    ask turtles with [(table:get hand "forest") >= 1 ] [
      set wealth wealth + 1 * (table:get hand "forest")
    ]
  ]
end


to pay
  if any? other turtles with [(table:get hand "coffe") >= 1] [ ; check for coffe owners
    if (cube = 3) [ ; check for roll
 ; check for money
      set n (count (turtles with [(table:get hand "coffe") >= 1]))
      while [n > 0] [
        set pidor one-of other turtles with [(table:get hand "coffe") >= 1] ; set receiver
        ifelse (wealth <= [(table:get hand "coffe")] of pidor)
        [ ask pidor[
          set wealth wealth + [wealth] of me
          ]
          set lost lost + wealth
          set wealth 0
        ]
        [ set wealth wealth - 1 * SM * [(table:get hand "coffe")] of pidor ; pay to this agent
          ask pidor [
            set wealth wealth + 1 * SM * (table:get hand "coffe")
            set lost lost + (table:get hand "coffe")
          ]
        ]
        set n n - 1
      ]
    ]
  ]
end

to buy-shop
  if (table:get desk "shop" >= 1) [
    set wealth wealth - 4
    set cards cards + 1
    table:put hand "shop" ( table:get hand "shop" + 1)
    table:put desk "shop" ( table:get desk "shop" - 1 )
  ]
end

to buy-coffe
  if (table:get desk "coffe" >= 1) [
    set wealth wealth - 2
    set cards cards + 1
    table:put hand "coffe" ( table:get hand "coffe" + 1 )
    table:put desk "coffe" ( table:get desk "coffe" - 1 )
  ]
end

to buy-field
  if (table:get desk "field" >= 1) [
    set wealth wealth - 1
    set cards cards + 1
    table:put hand "field" ( table:get hand "field" + 1 )
    table:put desk "field" ( table:get desk "field" - 1 )
  ]
end

to buy-cheese
  if (table:get desk "cheese" >= 1) [
    set wealth wealth - 1
    set cards cards + 1
    table:put hand "cheese" ( table:get hand "cheese" + 1 )
    table:put desk "cheese" ( table:get desk "cheese" - 1 )
  ]
end

to buy-bread
  if (table:get desk "bread" >= 1) [
    set wealth wealth - 1
    set cards cards + 1
    table:put hand "bread" ( table:get hand "bread" + 1)
    table:put desk "bread" ( table:get desk "bread" - 1 )
  ]
end

to buy-forest
  if (table:get desk "forest" >= 1) [
    set wealth wealth - 3
    set cards cards + 1
    table:put hand "forest" ( table:get hand "forest" + 1)
    table:put desk "forest" ( table:get desk "forest" - 1 )
  ]
end

to win
  if wealth >= attractions [
    set wealth wealth - attractions
    set attractions attractions + 8
    set size size + 1
    if attractions >= 12 [set SM 2]
  ]
end

to colour
  if (table:get hand "bread" = max (table:values hand) )
  [set color brown]
  if (table:get hand "field" = max (table:values hand) )
  [set color yellow]
  if (table:get hand "shop" = max (table:values hand) )
  [set color green]
  if (table:get hand "cheese" = max (table:values hand) )
  [set color blue]
  if (table:get hand "coffe" = max (table:values hand) )
  [set color red]
  if (table:get hand "forest" = max (table:values hand) )
  [set color turquoise]

end

to-report top-10-pct-wealth
  report sum [ wealth ] of max-n-of (count turtles * 0.20) turtles [ wealth ]
end

to-report bottom-50-pct-wealth
  report sum [ wealth ] of min-n-of (count turtles * 0.50) turtles [ wealth ]
end


; Copyright 2011 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
213
23
431
342
-1
-1
10.0
1
10
1
1
1
0
0
0
1
0
20
0
30
1
1
1
ticks
30.0

BUTTON
7
46
96
79
NIL
setup
NIL
1
T
OBSERVER
NIL
1
NIL
NIL
1

BUTTON
112
46
197
79
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
451
22
962
179
wealth distribution
wealth
turtles
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"current" 5.0 1 -10899396 true "" "set-plot-y-range 0 40\nhistogram [ wealth ] of turtles"

MONITOR
813
276
958
321
wealth of bottom 50%
bottom-50-pct-wealth
1
1
11

MONITOR
812
218
958
263
wealth of top 20%
top-10-pct-wealth
1
1
11

PLOT
454
183
788
333
wealth by percent
NIL
NIL
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"top 10%" 1.0 0 -2674135 true "" "plot top-10-pct-wealth"
"bottom 50%" 1.0 0 -13345367 true "" "plot bottom-50-pct-wealth"

SLIDER
18
102
190
135
players
players
2
5
5.0
1
1
NIL
HORIZONTAL

BUTTON
30
167
105
200
NIL
go
NIL
1
T
OBSERVER
NIL
2
NIL
NIL
1

@#$#@#$#@
## ACKNOWLEDGMENT

Thanks to Japan

## WHAT IS IT?

This model is a very simple model of machi coro. Random based game, where paul is dominating

## HOW IT WORKS

The SETUP for the model creates 2-5 agents, and then gives them each 3 coins.  At each tick, they made a whole round, build somethig, 

## HOW TO USE IT

Press SETUP to setup the model, then press GO to watch the model develop.

## THINGS TO NOTICE

color is strategy. x is number of cards, y is amount of coins.

## THINGS TO TRY

2 fk yourself

## EXTENDING THE MODEL

add cards

## NETLOGO FEATURES

NetLogo plots have an auto scaling feature that allows a plot's x range and y range to grow automatically, but not to shrink. We do, however, want the y range of the WEALTH DISTRIBUTION histogram to shrink since we start with all 500 turtles having the same wealth (producing a single high bar in the histogram), but the distribution of wealth eventually flattens to a point where no particular bin has more than 40 turtles in it.

To get NetLogo to correctly adjust the histogram's y range, we use [`set-plot-y-range 0 40`](http://ccl.northwestern.edu/netlogo/docs/dictionary.html#set-plot-y-range) in the histogram's pen update commands and let auto scaling set the maximum higher if needed.

## RELATED MODELS

Wealth Distribution. Simple economy

## CREDITS AND REFERENCES

Models of this kind are described in:

Seva

## HOW TO CITE


## COPYRIGHT AND LICENSE

No
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
resize-world 0 500 0 500 setup ask turtles [ set size 5 ] repeat 150 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
