
%*--------------------------------------------------------------------------------*
 | CALL:     vectorinitc.sas                                                      |
 |                                                                                |
 | PURPOSE:  This subroutine initializes all values of a given character array in |
 |           the first argument to the character value or string supplied in the  |
 |           second argument.  Although this call does not apply to the use of    |
 |           vectors and complex numbers, we added it for completeness as a       |
 |           character version of the CALL VECTORINITN routine.                   |
 |                                                                                |
 | SYNTAX:   CALL VECTORINITC (vector, string)                                    |
 |            vector = character-vector-array [required] A character SAS variable |
 |                     array where every value in the array will be assigned the  |
 |                     value of the declared initialization value.                |
 |            string = character-string [required] specifies a SAS character      |
 |                     constant, variable, or expression.                         |
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
 | 01/23/24  Original program                                       Paul McDonald |
 | 06/27/24  Improved error reporting                               Paul McDonald |
 |                                                                                |
 | Notes:    All arrays must be pre-defined in your data step, must be character, |
 |           and must be of the same dimension.  The call subroutine has been     |
 |           tested up to arrays of 1,000 dimensions.  If all vectors supplied    |
 |           are not of the same dimensions, then the result array values will be |
 |           set to the null string.  This call subroutine is included among the  |
 |           Vector operations and complex numbers category as a logical          |
 |           companion to the tools.                                              |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletesubr vectorinitc ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectorinitc (vector[*] $, string $) ;
      outargs vector ;
      do i = 1 to dim(vector) ;
         vector[i] = string ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array stooges (3) $ larry moe curly ;
   call vectorinitc (stooges, 'stooge') ;
   put larry= moe= curly= ;
run ;
*/
