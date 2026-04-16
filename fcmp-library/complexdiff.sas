
%*--------------------------------------------------------------------------------*
 | CALL:     complexdiff.sas                                                      |
 |                                                                                |
 | PURPOSE:  This subroutine performs the subtraction operation on two complex    |
 |           numbers stored in SAS numeric arrays of two dimensions for a         |
 |           Cartesian complex number in the form C = a + bi.                     |
 |                                                                                |
 | SYNTAX:   CALL COMPLEXDIFF (minuend, subtrahend, difference)                   |
 |            minuend    = numeric-SAS-array [required] A numeric SAS variable    |
 |                         array representing the two-dimensional array for a     |
 |                         Cartesian complex number in the form C = a + bi.       |
 |            subtrahend = numeric-SAS-array [required] A numeric SAS variable    |
 |                         array representing the two-dimensional array for a     |
 |                         Cartesian complex number in the form C = a + bi.       |
 |            difference = numeric-SAS-array [required] A numeric SAS variable    |
 |                         array representing the two-dimensional array for a     |
 |                         Cartesian complex number in the form C = a + bi.       |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Vector operations and complex numbers                                |
 |                                                                                |
 | SEE ALSO: CALL COMPLEXADD, CALL COMPLEXCONJ, CALL COMPLEXDIFF,                 |
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
   deletesubr complexdiff ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine complexdiff(minuend[2], subtrahend[2], difference[2]) ;
      outargs difference ;
      static err ;
      err = 0 ;

      if not (dim(minuend)=dim(subtrahend)=dim(difference)=2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL COMPLEXDIFF, complex numbers (arrays) must have the two dimensions.' ;
            err = 1 ;
         end ;
         difference[1] = . ;
         difference[2] = . ;
      end ;
      else if vectormiss(minuend) > 0 or vectormiss(subtrahend) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a complex number addition operation on missing values in CALL COMPLEXDIFF.' ;
            err = 1 ;
         end ;
         difference[1] = . ;
         difference[2] = . ;
      end ;
      else do ;
         difference[1] = minuend[1] - subtrahend[1] ;
         difference[2] = minuend[2] - subtrahend[2] ;
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

   call complexdiff(a, b, c) ;
   put c[1]= c[2]= ;
run ;
*/
