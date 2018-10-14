#!/bin/bash
#set -vx
#========================================================================================
# $B%9%/%j%W%HL>!'(BTLS-ParmitPass.sh
# $B35(B $BMW(B $B!!!!!!!'HkL)80$r;HMQ$7$?(Bopenssl$B%3%^%s%I$K$F!"%Q%9%o!<%I$N0E9f5Z$SI|9f$r9T$&!#$^$?(B
#$B!!!!!!(B $B!!!!!!!'HkL)80$N:n@.$b9T$&(B
# -h$B%*%W%7%g%s!'(Busage
# -g$B%*%W%7%g%s!'<B9T$7$?%f!<%6!<%[!<%`%G%#%l%/%H%j0J2<$N(B.ssh$B$KHkL)80$r:n@.$9$k(B
# -k$B%*%W%7%g%s!'%U%!%$%k$N0E9f2=$r<B;\$9$k(B
# -d$B%*%W%7%g%s!'%U%!%$%k$NI|9f2=$r<B;\$9$k(B
# $BBhFs0z?t!!!!!'(B-g$B%*%W%7%g%s!'HkL)80$NL>A0(B($BL$F~NO$N>l9g$O%G%U%)%k%H$N(Bid-rsa$B$K$J$k(B)
#$B!!!!!!!!!!!!(B $B!'(B-k$B%*%W%7%g%s!'0E9f2=$9$k%Q%9%o!<%I(B
# $B!!!!!!!!!!!!!'(B-d$B%*%W%7%g%s!'I|9f2=$9$k%U%!%$%k(B
# $BHw9M!!!!!!!!!'0E9f2=$9$k:]$O!"0E9f2=8e$NJ8;zNs$r=PNO$9$k$N$G%U%!%$%k$K%j%@%$%l%/%H$7$F(B
#  $B!!!!!!!!!!(B $B!'5-O?$7$F$/$@$5$$(B
#========================================================================================

#========================================================================================
# $BJQ?t(B/$BDj?tEy(B
#========================================================================================

#========================================================================================
# $B3F%*%W%7%g%s$N=hM}5-=R9`L\(B
#========================================================================================

function key_generate() {
   # $BHkL)80$NL>A0$r3JG<(B
   sec_key_name=$(echo $2)

   echo '$BHkL)80(B'"$sec_key_name"'$B$r:n@.$7$^$9(B'
   # $BHkL)80$r:n@.(B
   ssh-keygen -t rsa -f "$sec_key_name"

   ls ~/.ssh/"$sec_key_name" >& /dev/null
   

   if [ $? -eq 0 ] ; then

      echo '$BHkL)80$N:n@.$,40N;$7$^$7$?!#HkL)80$O0J2<$N%Q%9$KB8:_$7$^$9(B'
      find `pwd`/.ssh -maxdepth 1 -mindepth 1  | grep "$sec_key_name"

   fi   

}
#========================================================================================
# $B;vA0=hM}(B
#========================================================================================

#========================================================================================
# $BK\=hM}(B
#========================================================================================

#========================================================================================
# $B;v8e=hM}(B
#========================================================================================

