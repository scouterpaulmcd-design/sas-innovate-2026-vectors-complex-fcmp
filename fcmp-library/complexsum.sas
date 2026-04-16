
%*--------------------------------------------------------------------------------*
 | CALL:     complexsum.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine performs the addition operation on two complex       |
 |           numbers stored in SAS numeric arrays of two dimensions for a         |
 |           Cartesian complex number in the form C = a + bi.                     |
 |                                                                                |
 | SYNTAX:  CALL COMPLEXSUM (augend, addend, sum)                                 |
 |             augend = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the two-dimensional array for a Cartesian    |
 |                      complex number in the form C = a + bi.                    |
 |             addend = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the two-dimensional array for a Cartesian    |
 |                      complex number in the form C = a + bi.                    |
 |             sum    = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the two-dimensional array for a Cartesian    |
 |                      complex number in the form C = a + bi.                    |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Vector operations and complex numbers                                |
 |                                                                                |
 | SEE ALSO: CALL COMPLEXSUM, CALL COMPLEXCONJ, CALL COMPLEXDIFF,                 |
 |           CALL COMPLEXDIV, CALL COMPLEXEXP, CALL COMPLEXSQRT, CALL CROSSPROD,  |
 |           CALL HADAMARD, CALL SCALARPROD, CALL SQRTNEG, CALL VECTORADD,        |
 |           CALL VECTORCOPYC, CALL VECTORCOPYN, CALL VECTORDIFF, CALL VECTORDIV, |
 |           CALL VECTORINITC, CALL VECTORINITN, CALL VECTORNEG, CALL VECTORNORM, |
 |           CALL VECTORPROJ, CALL VECTORREFL, CALL VECTORROT, COMPLEX2CHAR,      |
 |           DOTPROD, VECTORANG, VECTORMAG, VECTORMISS                            |
 |                                                                                |
 | DATE      DESCRIPTION                                            BY            |
 | ========  ===================================================    ============= |
 | 06/27/24  Original program                                       Paul McDonald |
 |                                                                                |
 | Notes:    Complex numbers are stored in a 2-dimensional numeric array with the |
 |           first element representing the real part (a) and the second element  |
 |           representing the imaginary part (b) of the complex number.  All      |
 |           complex numbers are stored using cartesian format (C = a + bi) using |
 |           these tools.                                                         |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletesubr complexsum ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine complexsum(augend[2], addend[2], sum[2]) ;
      outargs sum ;
      static err ;
      err = 0 ;

      if not (dim(augend)=dim(addend)=dim(sum)=2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL COMPLEXSUM, complex numbers (arrays) must have the two dimensions.' ;
            err = 1 ;
         end ;
         sum[1] = . ;
         sum[2] = . ;
      end ;
      else if vectormiss(augend) > 0 or vectormiss(addend) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a complex number addition operation on missing values in CALL COMPLEXSUM.' ;
            err = 1 ;
         end ;
         sum[1] = . ;
         sum[2] = . ;
      end ;
      else do ;
         sum[1] = sum(augend[1], addend[1]) ;
         sum[2] = sum(augend[2], addend[2]) ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a [2] (1, 2) ;
   array b [2] (3, 4) ;
   array c [2] ;

   call complexsum(a, b, c) ;
   put c[1]= c[2]= ;
run ;
*/
