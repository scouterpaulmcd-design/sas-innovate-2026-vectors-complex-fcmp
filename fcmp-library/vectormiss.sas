
%*--------------------------------------------------------------------------------*
 | FCMP:     vectormiss.sas                                                       |
 |                                                                                |
 | PURPOSE:  This data step function accepts a numeric array and checks the       |
 |           values of the array for missing values.  If no values of the array   |
 |           are missing, the function returns a zero.  If any of the values of   |
 |           the array are missing, the function returns the number of the first  |
 |           value to contain missing values.                                     | 
 |                                                                                |
 | SYNTAX:   VECTORMISS(array)                                                    |
 |            array = numeric-SAS-array [required] A numeric SAS variable array   |
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
 | 06/20/24  Original program                                       Paul McDonald |
 | 06/27/24  Improved error reporting                               Paul McDonald |
 |                                                                                |
 | Notes:    All vectors must be pre-defined in your data step, must be numeric,  |
 |           and must be of the same dimension.  The function has been tested up  |
 |           to vectors of 1,000 dimensions.                                      |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;

proc fcmp outlib=library.functions.smd ;
   deletefunc vectormiss ;
run ;

proc fcmp outlib=library.functions.smd ;
   function vectormiss (vector[*]) ;
      vectormiss = 0 ;
      do i = 1 to dim(vector) ;
         if missing(vector[i]) then do ;
            vectormiss = i ;
            i = dim(vector) ;
         end ;
      end ;

      return (vectormiss) ;
   endsub ;
run ;


/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a (5) a1 a2 a3 a4 a5 ;
   array b (6) b1 b2 b3 b4 b5 b6 ;
   array c (8) c1 c2 c3 c4 c5 c6 c7 c8 ;

   do i = 1 to 5 ;
      a(i) = 10*ranuni(0) ;
      b(i) = 10*ranuni(0) ;
      c(i) = 10*ranuni(0) ;
   end ;


   vectormiss_a = vectormiss (a) ;
   vectormiss_b = vectormiss (b) ;
   vectormiss_c = vectormiss (c) ;

   put vectormiss_a= vectormiss_b= vectormiss_c= ;
run ;
*/

