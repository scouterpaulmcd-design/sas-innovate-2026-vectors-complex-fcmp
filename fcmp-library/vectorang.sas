
%*--------------------------------------------------------------------------------*
 | FCMP:     vectorang.sas                                                        |
 |                                                                                |
 | PURPOSE:  This data step function determines the vector angle of two given     |
 |           vectors expressed as a SAS array.  The result is a numerical or      |
 |           scalar value expressed as a SAS numeric value.   The value that is   |
 |           returned is specified in radians.                                    |
 |                                                                                |
 | SYNTAX:   VECTORANG (vector1[*], vector2[*])                                   |
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
 |           are not of the same dimensions, then the result vector component     |
 |           values will be set to the missing value.                             |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletefunc vectorang ;
run ;

proc fcmp outlib=library.functions.smd ;
   function vectorang (vector1[*], vector2[*]) ;
      static err 0 ;
      if dim(vector1) ne dim(vector2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in VECTORANG, vectors (arrays) must be of same dimensions.' ;
            err = 1 ;
         end ;
         angle = . ;
      end ;
      else angle = arcos (dotprod(vector1, vector2) / (vectormag(vector1) * vectormag(vector2))) ;

      return (angle) ;
   endsub ;
run ;

/**DEMO: 
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;

   ** calculating the angle between two 5-dimensional vectors ;
   array a (5) a1 a2 a3 a4 a5 ;
   array b (5) b1 b2 b3 b4 b5 ;

   do i = 1 to 5 ;
      a(i) = 10*ranuni(0) ;
      b(i) = 10*ranuni(0) ;
   end ;

   theta = vectorang (a, b) ;
   put theta= ;

   ** calculating the angle of a single complex number ;
   array complex (2) real imaginary (1 1) ;
   array xaxis   (2) x y (1 0) ;

   theta_c = vectorang (complex, xaxis) ;
   put theta_c= ;
run ;
*/ 
