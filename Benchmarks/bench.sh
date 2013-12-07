export COMMONOPTS='-DDEBUG -O2 -threaded '
export RTSOPTS='-N4'

ghc --make -cpp $COMMONOPTS -fforce-recomp -i:../../../ -DSHF  -o mainshf Main -rtsopts
#ghc --make -cpp $COMMONOPTS -fforce-recomp -i:../../../ -o main Main -rtsopts
#for i in 10 100; do for j in 10 100; do for k in 10 100; do for l in 10 100; do ./main $i $j $k $l +RTS $RTSOPTS -sout.main.$i.$j.$k.$l && ./Parse out.main.$i.$j.$k.$l main\;$i\;$j\;$k\;$l >> out.csv; done; done; done; done

#for i in 10 ; do for j in 10 ; do for k in 10 ; do for l in 10 ; do ./mainshf $i $j $k $l +RTS $RTSOPTS -sout.mainshf.$i.$j.$k.$l && ./Parse out.mainshf.$i.$j.$k.$l mainshf\;$i\;$j\;$k\;$l >> out.csv ; done; done; done; done

#./mainshf 10 10 10 1 +RTS -N4
