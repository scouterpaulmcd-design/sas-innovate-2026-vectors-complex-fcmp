
%*--------------------------------------------------------------------------------*
 | CALL:     vectordiv.sas                                                        |
 |                                                                                |
 | PURPOSE:  This subroutine performs the division operation on two vectors of    |
 |           the same dimension.                                                  |
 |                                                                                |
 | SYNTAX:   CALL VECTORDIV (numerator, denominator, quotient)                    |
 |            numerator   = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the numerator.  Arrays numerator,  |
 |                          denominator, and quotient must all be the same        |
 |                          dimension.                                            |
 |            denominator = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the denominator.  The arrays       |
 |                          numerator, denominator, and quotient must all be the  |
 |                          same dimension.                                       |
 |            quotient    = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the quotient.  Arrays numerator,   |
 |                          denominator, and quotient must all be the same        |
 |                          dimension.                                            |
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

libname library '/az/sas/public/library' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletesubr vectordiv ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectordiv(numerator[*], denominator[*], quotient[*]) ;
      outargs quotient ;
      static err 0 ;
      length i 8 ;

      if vectormiss(numerator) > 0 or vectormiss(denominator) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a vector division operation on missing values in CALL VECTORDIV.' ;
            err = 1 ;
         end ;
         call vectorinit(quotient, .) ;
      end ;
      else if not dim(numerator) = dim(denominator) = dim(quotient) then do ;
            if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL VECTORDIV, vectors (arrays) must have the same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit(quotient, .) ;
      end ;
      else do ;
         do i = 1 to dim(denominator) ;
            if denominator[i] = 0 then do ;
               if err =0 then do ;
                  put 'NOTE: Division by zero detected in CALL VECTORDIV.' ;
                  put 'NOTE: Mathematical operations could not be performed in CALL VECTORDIV routine.  The results of the operation have been set to missing values.' ;
                  err = 1 ;
               end ;
               put denominator[i]= ;
               quotient[i] = . ;
            end ;
            else do ;
               quotient[i] = numerator[i] / denominator[i] ;
            end ;
         end ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/az/sas/public/library' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a (3) a1-a3 (1, 2, 3) ;
   array b (3) b1-b3 (4, 5, 6) ;
   array c (3) c1-c3 ;

   call vectordiv(a, b, c) ;
   put c1= c2= c3= ;
run ;
*/
