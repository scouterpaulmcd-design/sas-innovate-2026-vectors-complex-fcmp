
%*--------------------------------------------------------------------------------*
 | CALL:     complexexp.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine performs an exponential operation on two complex     |
 |           numbers, C(result) = C(base) ** C(exponent)                          |
 |                                                                                |
 | SYNTAX:   CALL COMPLEXEXP (base, exponent, result)                             |
 |            base     = numeric-SAS-array [required] A numeric SAS variable      |
 |                       array representing the two-dimensional array for a       |
 |                       Cartesian complex number in the form C = a + bi for the  |
 |                       base of the exponential operation.                       |
 |            exponent = numeric-SAS-array [required] A numeric SAS variable      |
 |                       array representing the two-dimensional array for a       |
 |                       Cartesian complex number in the form C = a + bi for the  |
 |                       exponent of the exponential operation.                   |
 |            result   = numeric-SAS-array [required] A numeric SAS variable      |
 |                       array representing the two-dimensional array for a       |
 |                       Cartesian complex number in the form C = a + bi for the  |
 |                       result of the exponential operation.  This argument is   |
 |                       the output complex number where the subroutine writes    |
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
   deletesubr complexexp ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine complexexp(base[2], exponent[2], result[2]) ;
      length r_1 theta_1 a1 b1 a2 b2 ln_r1 R phi 8 ;
      outargs result ;
      static err ;

      if not (dim(base)=dim(exponent)=dim(result)=2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL COMPLEXEXP, complex numbers (arrays) must have the two dimensions.' ;
            err = 1 ;
         end ;
         result[1] = . ;
         result[2] = . ;
      end ;
      else if vectormiss(base) > 0 or vectormiss(exponent) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a vector division operation on missing values in CALL COMPLEXEXP.' ;
            err = 1 ;
         end ;
         result[1] = . ;
         result[2] = . ;
      end ;
      else do ;
         a1 = base[1] ;
         b1 = base[2] ;
         a2 = exponent[1] ;
         b2 = exponent[2] ;

         r_1 = sqrt(a1*a1 + b1*b1) ;
         theta_1 = atan2(b1, a1) ;

         ln_r1 = log(r_1) ;
         R = exp(a2 * ln_r1 - b2 * theta_1) ;
         phi = b2 * ln_r1 + a2 * theta_1 ;

         result[1] = R * cos(phi) ;
         result[2] = R * sin(phi) ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array b[2] (1, 1) ; 
   array e[2] (2, 3) ; 
   array r[2] ;

   call complexexp(b, e, r) ;
   put r[1]= r[2]= ;
run ;
*/
