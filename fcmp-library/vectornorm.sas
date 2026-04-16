
%*--------------------------------------------------------------------------------*
 | CALL:     vectornorm.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine performs a vector normalization routine on the given |
 |           input vector and returns the result to the named unit-vector.        |
 |                                                                                |
 | SYNTAX:   CALL VECTORNORM (input, unit)                                        |
 |            input = numeric-SAS-array [required] A numeric SAS variable array   |
 |                    representing the vector to normalize.  Arrays input and     |
 |                    unit must be the same dimension.                            |
 |            unit  = numeric-SAS-array [required] A numeric SAS variable array   |
 |                    representing the resulting unit vector that has been        |
 |                    normalized.  Arrays input and unit must be the same         |
 |                    dimension.                                                  |
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
   deletesubr vectornorm ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectornorm (vector[*], unitvector[*]) ;
      static err 0 ;
      outargs unitvector ;
      if dim(vector) ne dim(unitvector) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL VECTORNORM, vectors (arrays) must be of same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit (unitvector, .) ;
      end ;
      else if vectormiss(vector) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a vector reflection operation on missing values in CALL VECTORNORM.' ;
            err = 1 ;
         end ;
         call vectorinitn(unitvector, .) ;
      end ;
      else do ;
         magnitude = vectormag(vector) ;
         do i = 1 to dim(vector) ;
            unitvector[i] = vector[i] / magnitude ;
         end ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   format v1-v5 u1-u5 comma8.3 ;
   array v (5) v1-v5 ;
   array u (5) u1-u5 ;

   do i = 1 to 5 ;
      v(i) = floor(10*ranuni(0)) ;
   end ;

   call vectornorm (v, u) ;

   put v1= v2= v3= v4= v5= ;
   put u1= u2= u3= u4= u5= ;
run ;
*/
