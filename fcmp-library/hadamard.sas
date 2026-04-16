
%*--------------------------------------------------------------------------------*
 | CALL:     hadamard.sas                                                         |
 |                                                                                |
 | PURPOSE:  This subroutine performs the Hadamard product operation, which is an |
 |           element-wise multiplication of two vectors of the same dimension.    |
 |                                                                                |
 | SYNTAX:   CALL HADAMARD (multiplier, multiplicand, product)                    |
 |            multiplier   = numeric-SAS-array [required] A numeric SAS variable  |
 |                           array representing the vector multiplier.            |
 |            multiplicand = numeric-SAS-array [required] A numeric SAS variable  |
 |                           array representing the vector to be multiplied to    |
 |                           the given multiplier.                                |
 |            product      = numeric-SAS-array [required] A numeric SAS variable  |
 |                           array representing the product result vector.        |
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
   deletesubr hadamard ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine hadamard(factora[*], factorb[*], product[*]) ;
      outargs product ;
      static err 0 ;
      length i 8 ;

      if dim(factora) = dim(factorb) = dim(product) then do ;
         do i = 1 to dim(product) ;
            product[i] = factora[i] * factorb[i] ;
         end ;
      end ;
      else do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL HADAMARD, vectors (arrays) must have the same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinitn(product, .) ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a (5) a1-a5 ;
   array b (5) b1-b5 ;
   array c (5) c1-c5 ;

   a1 = 1 ;
   a2 = 2 ;
   a3 = 3 ;
   a4 = 4 ;
   a5 = 5 ;
   b1 = 5 ;
   b2 = 4 ;
   b3 = 3 ;
   b4 = 2 ;
   b5 = 1 ;

   call hadamard(a, b, c) ;
   put c1= c2= c3= c4= c5= ;
run ;
*/
