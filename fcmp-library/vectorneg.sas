
%*--------------------------------------------------------------------------------*
 | CALL:     vectorneg.sas                                                        |
 |                                                                                |
 | PURPOSE:  This subroutine performs a vector negation routine.                  |
 |                                                                                |
 | SYNTAX:   CALL VECTORNEG (vector, result)                                      |
 |            vector = numeric-SAS-array [required] A numeric SAS variable array  |
 |                     representing the vector to negate.  Arrays vector and      |
 |                     result must be the same dimension.                         |
 |            result = numeric-SAS-array [required] A numeric SAS variable array  |
 |                     representing the negated result vector. Arrays vector and  |
 |                     result must be the same dimension.                         |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Vector operations                                                    |
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
 | 07/02/24  Improved error reporting                               Paul McDonald |
 |                                                                                |
 | Notes:    All vectors must be pre-defined in your data step, must be numeric,  |
 |           and must be of the same dimension.  The call subroutine has been     |
 |           tested up to vectors of 1,000 dimenions.  If all vectors supplied    |
 |           are not of the same dimenions, then the result vector values will be |
 |           set to the missing value.                                            |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletesubr vectorneg ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectorneg (vector[*], result[*]) ;
      static err 0 ;
      outargs result ;
      if dim(vector) ne dim(result) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL VECTORNEG, vectors (arrays) must be of same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit (result, .) ;
      end ;
      else if vectormiss(vector) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a vector reflection operation on missing values in CALL VECTORNEG.' ;
            err = 1 ;
         end ;
         call vectorinitn(result, .) ;
      end ;
      else do i = 1 to dim(vector) ;
         result[i] = -vector[i] ;
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

   call vectorneg (v1, v2) ;
   put x1= x2= y1= y2= ;
run ;
*/
