
%*--------------------------------------------------------------------------------*
 | CALL:     vectorrefl.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine performs a vector reflection operation when given an |
 |           original vector to reflect across an incident vector.  Both vectors  |
 |           must be of the same dimensions.                                      |
 |                                                                                |
 | SYNTAX:    CALL VECTORROT (original, incident, reflection)                     |
 |             original   = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the original vector.  The arrays   |
 |                          for original, incident, and reflection must be the    |
 |                          same dimension.                                       |
 |             incident   = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the incident vector.  The arrays   |
 |                          for original, incident, and reflection must be the    |
 |                          same dimension.                                       |
 |             reflection = numeric-SAS-array [required] A numeric SAS variable   |
 |                          array representing the reflection vector.  The arrays |
 |                          for original, incident, and reflection must be the    |
 |                          same dimension.                                       |
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
   deletesubr vectorrefl ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectorrefl(original[*], incident[*], reflection[*]) ;
      outargs reflection ;
      static err 0 ;
      length denominator dotproduct 8 ;

      if vectormiss(original) > 0 or vectormiss(incident) > 0 then do ;
         if err = 0 then do ;
            put 'NOTE: Missing values were generated as a result of performing a vector reflection operation on missing values in CALL VECTORREFL.' ;
            err = 1 ;
         end ;
         call vectorinitn(reflection, .) ;
      end ;
      else if not(dim(original) = dim(incident) = dim(reflection)) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL VECTORREFL, vectors (arrays) must have the same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit(reflection, .) ;
      end ;
      else do ;
         denominator = dotprod(incident, incident) ;
         if denominator = 0 then do ;
            if err = 0 then do ;
               put 'NOTE: Division by zero detected in CALL VECTORREFL.' ;
               put 'NOTE: Mathematical operations could not be performed in CALL VECTORREFL routine.  The results of the operation have been set to missing values.' ;
               err = 1 ;
            end ;
            call vectorinitn(reflection, .) ;
         end ;
         else do ;
            dotproduct = dotprod(original, incident) ;
            do i = 1 to dim(original) ;
               reflection[i] = (2 * dotproduct / denominator * incident[i]) - original[i] ;
            end ;
         end ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a (5) a1-a5 ;
   array b (5) b1-b5 ;
   array c (5) c1-c5 ;

   a1 = 1 ;
   a2 = 2 ;
   a3 = 3 ;
   a4 = 4 ;
   a5 = 5 ;
   b1 = 5 ;
   b2 = 4 ;
   b3 = 3 ;
   b4 = 2 ;
   b5 = 1 ;

   call vectorrefl(a, b, c) ;
   put c1= c2= c3= c4= c5= ;
run ;
*/
