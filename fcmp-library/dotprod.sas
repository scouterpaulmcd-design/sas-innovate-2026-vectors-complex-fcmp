
%*--------------------------------------------------------------------------------*
 | FCMP:     dotprod.sas                                                          |
 |                                                                                |
 | PURPOSE:  This data step function performs a dot product operation on two      |
 |           given vectors expressed as SAS arrays.  The result is a scalar value |
 |           expressed as a SAS numeric value.  The value that is returned is     |
 |           specified in radians.                                                |
 |                                                                                |
 | SYNTAX:   DOTPROD (vector1, vector2)                                           |
 |            vector1 = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the first vector. Arrays vector1 and         |
 |                      vector2 must be the same dimension.                       |
 |            vector2 = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the second vector.  Arrays vector1 and       |
 |                      vector2 must be the same dimension.                       |
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
 | 06/27/24  Improved error reporting                               Paul McDonald |
 |                                                                                |
 | Notes:    All vectors must be pre-defined in your data step, must be numeric,  |
 |           and must be of the same dimension.  The call subroutine has been     |
 |           tested up to vectors of 1,000 dimensions.  If all vectors supplied   |
 |           are not of the same dimensions, then the function will return the    |
 |           missing value.                                                       |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;

proc fcmp outlib=library.functions.smd ;
   deletefunc dotprod ;
run ;

proc fcmp outlib=library.functions.smd ;
   function dotprod (vector1[*], vector2[*]) ;
      static err 0 ;
      if dim(vector1) ne dim(vector2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in function DOTPROD, vectors (arrays) must be of same dimensions.' ;
            err = 1 ;
         end ;
         dotprod = . ;
      end ;
      else do i = 1 to dim(vector1) ;
         dotprod = sum(dotprod, vector1[i] * vector2[i]) ;
      end ;

      return (dotprod) ;
   endsub ;
run ;


/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a (5) a1 a2 a3 a4 a5 ;
   array b (5) b1 b2 b3 b4 b5 ;

   do i = 1 to 5 ;
      a(i) = 10*ranuni(0) ;
      b(i) = 10*ranuni(0) ;
   end ;


   dotprod = dotprod (a, b) ;
   put dotprod= ;
run ;
*/

