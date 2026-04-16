
%*--------------------------------------------------------------------------------*
 | FCMP:     vectormag.sas                                                        |
 |                                                                                |
 | PURPOSE:  This data step function determines the magnitude of a given vector   |
 |           expressed as a SAS array.  The result is a numerical or scalar value |
 |           expressed as a SAS numeric value.                                    |
 |                                                                                |
 | SYNTAX:   VECTORMAG (vector)                                                   |
 |            vector = numeric-SAS-array [required] A numeric SAS variable array  |
 |                      representing the first vector.                            |
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
 | Notes:    The vector supplied to the function must be pre-defined in your data |
 |           step and must be numeric.  The function has been tested on vectors   |
 |           up 1,000 dimensions.                                                 |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

proc fcmp outlib=library.functions.smd ;
   deletefunc vectormag ;
run ;

proc fcmp outlib=library.functions.smd ;
   function vectormag (vector[*]) ;
      radicand = 0 ;
      do i = 1 to dim(vector) ;
         radicand = radicand + vector[i]**2 ;
      end ;
      root = sqrt(radicand) ;
      return (root) ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array vector (100) v1-v100 ;
   do i = 1 to 100 ;
      vector(i) = 100*ranuni(0) ;
   end ;   

   magnitude = vectormag(vector) ;
   put magnitude= ;
run ;
*/