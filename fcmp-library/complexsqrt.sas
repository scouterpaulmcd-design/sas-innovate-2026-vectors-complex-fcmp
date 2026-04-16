
%*--------------------------------------------------------------------------------*
 | CALL:     complexsqrt.sas                                                      |
 |                                                                                |
 | PURPOSE:  This subroutine calculates the square root of a complex number       |
 |           stored in SAS numeric arrays of two dimensions for a Cartesian       |
 |           number in the form C = a + bi.                                       |
 |                                                                                |
 | SYNTAX:   CALL COMPLEXSQRT (complex, root)                                     |
 |            complex = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the two-dimensional array for a Cartesian    |
 |                      complex number in the form C = a + bi.  This is the       |
 |                      complex number to perform the square root upon.           |
 |            root    = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the two-dimensional array for a Cartesian    |
 |                      complex number in the form C = a + bi.  This is the       |
 |                      result of the square root of the complex number.          |
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

proc fcmp outlib=library.functions.math ;
   deletesubr complexsqrt ;
run ;

proc fcmp outlib=library.functions.math ;
   subroutine complexsqrt(complex[2], root[2]) ;
      outargs root ;
      static err ;
      err = 0 ;

      if not (dim(complex)=dim(root)=2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL COMPLEXSQRT, complex numbers (arrays) must have the two dimensions.' ;
            err = 1 ;
         end ;
         root[1] = . ;
         root[2] = . ;
      end ;
      else if vectormiss(complex) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a complex number addition operation on missing values in CALL COMPLEXSQRT.' ;
            err = 1 ;
         end ;
         root[1] = . ;
         root[2] = . ;
      end ;
      else do ;
         root[1] = sqrt(sqrt(complex[1]**2 + complex[2]**2)) * cos(atan2(complex[2], complex[1])/2) ;
         root[2] = sqrt(sqrt(complex[1]**2 + complex[2]**2)) * sin(atan2(complex[2], complex[1])/2) ;
      end ;
   endsub ;
run ;

/** DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a [2] (3, 4) ;
   array b [2] (-5, 12) ;
   array c [2] (7, -24) ;
   array r [2] ;

   call complexsqrt(a, r) ;
   put r[1]= r[2]= ;
   call complexsqrt(b, r) ;
   put r[1]= r[2]= ;
   call complexsqrt(c, r) ;
   put r[1]= r[2]= ;
run ;
*/
