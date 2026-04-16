
%*--------------------------------------------------------------------------------*
 | CALL:     crossprod.sas                                                        |
 |                                                                                |
 | PURPOSE:  This subroutine performs a cross product operation on two vectors    |
 |           and returns the result to a third vector.  All three vectors must be |
 |           numeric and of three (3) dimensions.                                 |
 |                                                                                |
 | SYNTAX:   CALL CROSSPROD (multiplier, multiplicand, product)                   |
 |            multiplier   = numeric-SAS-array [required] A numeric SAS variable  |
 |                           array representing the vector multiplier.  Must be   |
 |                           a vector of three (3) dimensions.                    |
 |            multiplicand = numeric-SAS-array [required] A numeric SAS variable  |
 |                           array representing the vector to be multiplied to    |
 |                           the given multiplier.  Must be a vector of three (3) |
 |                           dimensions.                                          |
 |            product      = numeric-SAS-array [required] A numeric SAS variable  |
 |                           array representing the product result vector.  Must  |
 |                           be a vector of three (3) dimensions.                 |
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
 | 06/27/24  Improved QC screening and error reporting              Paul McDonald |
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
   deletesubr crossprod ;
run ;

proc fcmp outlib=library.functions.smd ;
  subroutine crossprod (a[*], b[*], c[*]) ;
      outargs c ;
      static err 0 ;
      if dim(a)=dim(b)=dim(c)=3 then do ;
         c[1] = a[2]*b[3] - a[3]*b[2] ;
         c[2] = a[3]*b[1] - a[1]*b[3] ;
         c[3] = a[1]*b[2] - a[2]*b[1] ;
      end ;
      else do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL CROSSPROD, vectors (arrays) must be 3 dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit (c, .) ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a (3) a1-a3 ;
   array b (3) b1-b3 ;
   array c (3) c1-c3 ;

   do i = 1 to 3 ;
      a(i) = ranuni(0) ;
      b(i) = ranuni(0) ;
   end ;

   call crossprod (a, b, c) ;
   put c1= c2= c3= ;
run ;
*/
