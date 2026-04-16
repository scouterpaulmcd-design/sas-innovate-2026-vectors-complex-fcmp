
%*--------------------------------------------------------------------------------*
 | CALL:     vectorinitn.sas                                                      |
 |                                                                                |
 | PURPOSE:  This subroutine initializes all values of a given numeric array in   |
 |           the first argument to the numeric constant, variable, or expression  |
 |           supplied in the second argument.  To initialize all values of a      |
 |           character array, see the CALL VECTORINITC routine.                   |
 |                                                                                |
 | SYNTAX:   CALL VECTORINITN (vector, value)                                     |
 |            vector = numeric-SAS-array [required] A numeric SAS variable array  |
 |                     where every value in the array will be assigned the value  |
 |                     of the declared initialization value.                      |
 |            value  = number [required] any real number expressed as a constant, |
 |                     variable, or expression                                    |
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
   deletesubr vectorinitn vectorinit ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectorinitn (vector[*], value) ;
      outargs vector ;
      do i = 1 to dim(vector) ;
         vector[i] = value ;
      end ;
   endsub ;

run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array v (10) v1-v10 ;
   call vectorinitn (v, 5.63) ;
   put v1= v2= v3= v4= v5= v6= v7= v8= v9= v10= ;
run ;
*/
