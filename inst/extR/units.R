

rm(list = ls(all.names = TRUE))

# name clash 
# ?stats::tsp

teaspoon = c(
  Cup = 48, 
  '\u00beCup' = 48*3/4, '\u2154Cup' = 48*2/3, '\u00bdCup' = 48/2,
  '\u2153Cup' = 48/3, '\u00bcCup' = 48/4, 
  Tbsp = 3, '2tsp' = 2, '1\u00bdtsp' = 1.5, 'tsp' = 1,
  '\u00bdtsp' = .5, '\u00bctsp' = 1/4, '\u215btsp' = 1/8)

teaspoon2 = c(
  'Brick' = 3*16, 'Stick' = 3*8, 
  Tbsp = 3, '2tsp' = 2, '1\u00bdtsp' = 1.5, 'tsp' = 1,
  '\u00bdtsp' = .5, '\u00bctsp' = 1/4, '\u215btsp' = 1/8)

floz = c(29.5735 * c(
  'gal' = 128, # liquid gallon
  'qt' = 32, # liquid quart
  'pt' = 16, # liquid pint
  'fl.oz.' = 1 # fluid ounce
), ml = 1)

# base::`units<-.difftime`
day = c(
  year = (365*4+1)/4,
  month = (365*4+1)/4/12,
  week = 7,
  day = 1
)


minute = c(
  day = 60*24, 
  hr = 60, 
  min = 1, 
  sec = 1/60)

save(list = c(
  'teaspoon', 'teaspoon2', 'floz', 'day', 'minute'
), file = './data/units.rda', compress = 'xz')

rm(list = ls(all.names = TRUE))