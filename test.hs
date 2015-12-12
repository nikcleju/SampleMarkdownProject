doubleMe x = x + x

doubleUs x y = x*2 + y*2   

boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]   


