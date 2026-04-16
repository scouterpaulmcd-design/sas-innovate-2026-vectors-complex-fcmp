
%*--------------------------------------------------------------------------------*
 | CALL:     complexdiv.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine performs the division operation on two complex       |
 |           numbers stored in SAS numeric arrays of two dimensions for a         |
 |           Cartesian complex number in the form C = a + bi.                     |
 |                                                                                |
 | SYNTAX:   CALL COMPLEXDIV (numerator, denominator, quotient)                   |
 |            numerator   = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the two-dimensional array for a    |
 |                          Cartesian complex number in the form C = a + bi for   |
 |                          the numerator of the division operation.              |
 |            denominator = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the two-dimensional array for a    |
 |                          Cartesian complex number in the form C = a + bi for   |
 |                          the denominator of the division operation.            |
 |            quotient    = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the two-dimensional array for a    |
 |                          Cartesian complex number in the form C = a + bi for   |
 |                          the quotient of the division operation.  This         |
 |                          argument is the output complex number where the       |
 |                          subroutine writes the result.                         |
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
   deletesubr complexdiv ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine complexdiv(numerator[2], denominator[2], quotient[2]) ;
      outargs quotient ;
      length denomoninator 8 ;
      static err ;
      err = 0 ;

      if not (dim(numerator)=dim(denominator)=2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL COMPLEXDIV, vectors (arrays) must have the two dimensions.' ;
            err = 1 ;
         end ;
         call vectorinitn(quotient, .) ;
      end ;
      else if vectormiss(numerator) > 0 or vectormiss(denominator) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a vector division operation on missing values in CALL COMPLEXDIV.' ;
            err = 1 ;
         end ;
         quotient[1] = . ;
         quotient[2] = . ;
      end ;
      else do ;
         denom = denominator[1]**2 + denominator[2]**2 ;
         if denom = 0 then do ;
            if err = 0 then do ;
               put 'NOTE: Division by zero detected in CALL COMPLEXDIV.' ;
               put 'NOTE: Mathematical operations could not be performed in CALL COMPLEXDIV routine. The results of the operations have been set to missing values.' ;
               err = 1 ;
            end ;
            put denominator[1]= denominator[2]= ;
            quotient[1] = . ;
            quotient[2] = . ;
         end ;
         else do ;
            quotient[1] = (numerator[1] * denominator[1] + numerator[2] * denominator[2]) / denom ;
            quotient[2] = (numerator[2] * denominator[1] - numerator[1] * denominator[2]) / denom ;
         end ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array numerator[2] (1, 2) ;
   array denominator[2] (3, 4) ;
   array quotient[2] (. , .) ;

   call complexdiv(numerator, denominator, quotient) ;
   put quotient[1]= quotient[2]= ;
run ;
*/
