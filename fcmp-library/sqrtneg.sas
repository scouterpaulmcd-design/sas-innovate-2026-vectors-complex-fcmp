
%*--------------------------------------------------------------------------------*
 | CALL:     sqrtneg.sas                                                          |
 |                                                                                |
 | PURPOSE:  This subroutine performs a square root calculation on a real number  |
 |           and returns the value as a complex number in a two-dimensional       |
 |           array.  Since the square root of any value other than zero has two   |
 |           answers (a positive result and a negative results), this call        |
 |           routine will return only the positive result, the same as the        |
 |           standard SAS function SQRT().                                        |
 |                                                                                |
 | SYNTAX:   CALL SQRTNEG (real, complex-array)                                   |
 |            real          = real-number [required] any real number expressed as |
 |                            a constant, variable, or expression                 |
 |            complex-array = numeric-SAS-array [required] A numeric SAS variable |
 |                            array representing the two-dimensional array for a  |
 |                            cartesian complex number in the form C = a + bi.    |
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
 |           CALL VECTORPROJ, CALL VECTORREFL, CALL VECTORROT, COMPLEX, DOTPROD,  |
 |           VECTORANG, VECTORMAG, VECTORMISS                                     |
 |                                                                                |
 | DATE      DESCRIPTION                                            BY            |
 | ========  ===================================================    ============= |
 | 01/22/24  Original program                                       Paul McDonald |
 | 06/27/24  Improved error reporting                               Paul McDonald |
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
   deletesubr sqrtneg ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine sqrtneg (real, complex[*]) ;
      static err 0 ;
      outargs complex ;
      if dim(complex) = 2 then do ;
         if real = . then do ;
            complex [1] = . ;
            complex [2] = . ;
         end ;
         else if real < 0 then do ;
            complex [1] = 0 ;
            complex [2] = sqrt(abs(real)) ;
         end ;
         else if real = 0 then do ;
            complex [1] = 0 ;
            complex [2] = 0 ;
         end ;
         else do ;
            complex [1] = sqrt(real) ;
            complex [2] = 0 ;
         end ;
      end ;
      else do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL NEGSQRT routine, complex numbers (arrays) must be two (2) dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit (complex, .) ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array complex (2) r i ;
   
   call sqrtneg (-4, complex) ;
   put r= i= ;

   call sqrtneg (4, complex) ;
   put r= i= ;

   call sqrtneg (0, complex) ;
   put r= i= ;
run ;

data _null_ ;
   array complex (4) r i j k ;
   call sqrtneg (-10, complex) ;
   put r= i= ;
run ;
*/
