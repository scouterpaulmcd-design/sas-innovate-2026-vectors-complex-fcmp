
%*--------------------------------------------------------------------------------*
 | CALL:     complexprod.sas                                                      |
 |                                                                                |
 | PURPOSE:  This subroutine performs the multiplicaiton operation on two complex |
 |           numbers stored in SAS numeric arrays of two dimensions for a         |
 |           Cartesian complex number in the form C = a + bi.                     |
 |                                                                                |
 | SYNTAX:   CALL COMPLEXDIV (factor-1, factor-2, product)                        |
 |            factor-1 = numeric-SAS-array [required] A numeric SAS variable      |
 |                       array representing the two-dimensional array for a       |
 |                       Cartesian complex number in the form C = a + bi as the   |
 |                       first factor of the multiplication operation.            | 
 |            factor-2 = numeric-SAS-array [required] A numeric SAS variable      |
 |                       array representing the two-dimensional array for a       |
 |                       Cartesian complex number in the form C = a + bi as the   |
 |                       second factor of the multiplication operation.           | 
 |            product  = numeric-SAS-array [required] A numeric SAS variable      |
 |                       array representing the two-dimensional array for a       |
 |                       Cartesian complex number in the form C = a + bi as the   |
 |                       product of the multiplication operation.  This argument  |
 |                       is the output complex number where the subroutine writes |
 |                       the result.                                              |
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
   deletesubr complexprod ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine complexprod(factor1[2], factor2[2], product[2]) ;
      outargs product ;
      static err ;
      err = 0 ;

      if not (dim(factor1)=dim(factor2)=dim(product)=2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL COMPLEXPROD, complex numbers (arrays) must have the two dimensions.' ;
            err = 1 ;
         end ;
         product[1] = . ;
         product[2] = . ;
      end ;
      else if vectormiss(factor1) > 0 or vectormiss(factor2) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a complex number addition operation on missing values in CALL COMPLEXPROD.' ;
            err = 1 ;
         end ;
         product[1] = . ;
         product[2] = . ;
      end ;
      else do ;
         product[1] = factor1[1] * factor2[1] ;
         product[2] = factor1[2] * factor2[2] ;
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

   call complexprod(a, b, c) ;
   put c[1]= c[2]= ;
run ;
*/
