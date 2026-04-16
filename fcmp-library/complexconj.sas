
%*--------------------------------------------------------------------------------*
 | CALL:    complexconj.sas                                                       |
 |                                                                                |
 | PURPOSE: This subroutine computes the complex conjugate of a given complex     |
 |          number.  The first argument is the input complex number to compute    |
 |          the complex conjugation upon and the second argument is the output    |
 |          complex number where the subroutine writes the result.                |
 |                                                                                |
 | SYNTAX:  CALL COMPLEXCONJ (complex, conjugate)                                 |
 |           complex   = numeric-SAS-array [required] A numeric SAS variable      |
 |                       array representing the two-dimensional array for a       |
 |                       Cartesian complex number in the form C = a + bi.  This   |
 |                       argument is the input complex number to perform the      |
 |                       conjugation upon.                                        |
 |           conjugate = numeric-SAS-array [required] A numeric SAS variable      |
 |                       array representing the two-dimensional array for a       |
 |                       Cartesian complex number in the form C = a + bi.  This   |
 |                       argument is the output complex number where the          |
 |                       subroutine writes the result.                            |
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
   deletesubr complexconj ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine complexconj(complex[*], conjugate[*]) ;
      outargs conjugate ;
      static err ;
      if vectormiss(complex) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Complex number (array) declared in CALL COMPLEXCONJ contains missing values.' ;
            put 'NOTE: Missing values were generated as a result of performing a Complex Conjucation operation on missing values.' ;
            err = 1 ;
         end ;
         call vectorinitn(conjugate, .) ;
      end ;
      else if dim(complex) = dim(conjugate) = 2 then do ;
         conjugate[1] = complex[1] ;
         conjugate[2] = -complex[2] ;
      end ;
      else do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL COMPLEXCONJ, vectors (arrays) must have the two dimensions.' ;
            err = 1 ;
         end ;
         call vectorinitn(conjugate, .) ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array comp [2] real imaginary ;
   array conj [2] conj_real conj_imaginary ;

   real = 1 ;
   imaginary = 3 ;

   call complexconj(comp, conj) ;
   put conj_real=  conj_imaginary= ;
run ;
*/
