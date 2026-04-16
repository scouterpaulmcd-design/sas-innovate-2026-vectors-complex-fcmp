
%*--------------------------------------------------------------------------------*
 | CALL:     vectorrot.sas                                                        |
 |                                                                                |
 | PURPOSE:  This subroutine performs a vector rotation operation on a given two  |
 |           dimensional cartesian vector defined in a SAS array.                 |
 |                                                                                |
 | SYNTAX:    CALL VECTORROT (source, theta, result)                              |
 |             source = numeric-SAS-array [required] A numeric SAS variable array |
 |                      of two dimensions representing the original vector to     |
 |                      rotate.                                                   |
 |             theta  = numeric [required] the angle of rotation in radians to    |
 |                      rotate the vector declared in source.                     |
 |             result = numeric-SAS-array [required] A numeric SAS variable array |
 |                      of two dimensions representing the resulting vector after |
 |                      it has been rotated by the angle declared in theta.       |
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
 | 01/21/24  Original program                                       Paul McDonald |
 | 06/27/24  Improved error reporting                               Paul McDonald |
 |                                                                                |
 | Notes:    All vectors must be pre-defined in your data step, must be numeric,  |
 |           and must be of the same dimension.  The call subroutine has been     |
 |           tested up to vectors of 1,000 dimensions.  If all vectors supplied   |
 |           are not of the same dimensions, then the result vector values will   |
 |           be set to the missing value.                                         |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletesubr vectorrot ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectorrot(source[*], theta, result[*]) ;
      outargs result ;
      static err 0 ;
      length cos_theta sin_theta 8 ;

      if vectormiss(source) > 0 or theta = . then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a vector rotation operation on missing values in CALL VECTORROT.' ;
            err = 1 ;
         end ;
         call vectorinitn(result, .) ;
      end ;
      else if not (dim(source) = dim(result) = 2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL VECTORROT, vectors (arrays) must be 2 dimensions.' ;
            err = 1 ;
         end ;
         call vectorinitn(result, .) ;
      end ;
      else do ;
         cos_theta = cos(theta) ;
         sin_theta = sin(theta) ;
         
         result[1] = source[1] * cos_theta - source[2] * sin_theta ;
         result[2] = source[1] * sin_theta + source[2] * cos_theta ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a (2) a1-a2 ;
   array b (2) b1-b2 ;
   theta_deg = 45 ; 
   theta_rad = theta_deg * constant('pi') / 180 ;

   a1 = 1 ;
   a2 = 1 ;

   call vectorrot(a, theta_rad, b) ;
   put b1= b2= ;
run ;
*/
