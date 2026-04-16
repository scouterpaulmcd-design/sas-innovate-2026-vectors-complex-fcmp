
%*--------------------------------------------------------------------------------*
 | CALL:     scalarprod.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine performs a vector scalar product normalization       |
 |           routine on one vector and returns the result to a second vector.     |
 |           The two vectors must be numeric and of the same number of dimensions |
 |           and the multiplier must be a numeric value.                          |
 |                                                                                |
 | SYNTAX:    CALL SCALARPROD (multiplier, multiplicand, product)                 |
 |            multiplier   = numeric-value [required] A SAS numeric constant,     |
 |                           variable, or expression representing the scalar      |
 |                           value                                                |
 |            multiplicand = numeric-SAS-array [required] A numeric SAS variable  |
 |                           array representing the vector to be multiplied to    |
 |                           the given multiplier.  Must be the same dimensions   |
 |                           of the product vector.                               |
 |            product      = numeric-SAS-array [required] A numeric SAS variable  |
 |                           array representing the product result vector.  Must  |
 |                           be the same dimensions of the multiplicand vector.   |
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
 | 01/22/24  Original program                                       Paul McDonald |
 | 06/27/24  Improved error reporting                               Paul McDonald |
 |                                                                                |
 | Notes:    All vectors must be pre-defined in your data step, must be numeric,  |
 |           and must be of the same dimension.  The call subroutine has been     |
 |           tested up to vectors of 1,000 dimensions.  If all vectors supplied   |
 |           are not of the same dimensions, then the result vector component     |
 |           values will be set to the missing value.                             |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletesubr scalarprod ;
run ;

proc fcmp outlib=library.functions.smd ;
  subroutine scalarprod (multiplier, multiplicand[*], product[*]) ;
      static err 0 ;
      outargs product ;
      if dim(multiplicand) ne dim(product) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL SCALARPROD, vectors (arrays) must be of same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit (product, .) ;
      end ;
      else do i = 1 to dim(multiplicand) ;
         product[i] = multiplier * multiplicand[i] ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array v1 (2) x1 y1 ;
   array v2 (2) x2 y2 ;

   x1 = 4 ; 
   y1 = 6 ;

   call scalarprod (7, v1, v2) ;
   put x1= x2= y1= y2= ;
run ;
*/
