
%*--------------------------------------------------------------------------------*
 | CALL:     vectordiff.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine performs a vector subraction operation (difference)  |
 |           on two vectors as defined in a SAS array.                            |
 |                                                                                |
 | SYNTAX:    CALL VECTORDIFF (minuend-array, subtrahend-array, difference-array) |
 |            minuend-array    = numeric-SAS-array [required] A numeric SAS       |
 |                               variable array representing the vector from      |
 |                               which the subtrahend is subtracted.  Arrays      |
 |                               minuend, subtrahend, and difference must be the  |
 |                               same dimension.                                  |
 |            subtrahend-array = numeric-SAS-array [required] A numeric SAS       |
 |                               variable array representing the vector to be     |
 |                               subtracted from the minuend.  Arrays minuend,    |
 |                               subtrahend, and difference must be the same      |
 |                               dimension.                                       |
 |            difference-array = numeric-SAS-array [required] A numeric SAS       |
 |                               variable array representing the result vector of |
 |                               subtracting the subtrahend from the minuend.     |
 |                               Arrays minuend, subtrahend, and difference must  |
 |                               be the same dimension.                           |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Vector operations                                                    |
 |                                                                                |
 | SEE ALSO: CALL CROSSPROD, CALL SCALARPROD, CALL SQRTNEG, CALL VECTORADD,       |
 |           CALL VECTORNEG, CALL VECTORDIFF, CALL VECTORINIT, CALL VECTORINITC,  |
 |           CALL VECTORNORM, COMPLEX, DOTPROD, VECTORANG, VECTORMAG              |
 |                                                                                |
 | DATE      DESCRIPTION                                            BY            |
 | ========  ===================================================    ============= |
 | 01/21/24  Original program                                       Paul McDonald |
 |                                                                                |
 | Notes:    All vectors must be pre-defined in your data step, must be numeric,  |
 |           and must be of the same dimension.  The call subroutine has been     |
 |           tested up to vectors of 1,000 dimenions.  If all vectors supplied    |
 |           are not of the same dimenions, then the result vector values will be |
 |           set to the missing value.                                            |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/az/sas/public/library' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletesubr vectordiff ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectordiff (minuend[*], subtrahend[*], difference[*]) ;
      static err 0 ;
      outargs difference ;
      if dim(minuend)=dim(subtrahend)=dim(difference) then do i = 1 to dim(minuend) ;
         difference[i] = minuend[i] - subtrahend[i] ;
      end ;
      else do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL VECTORDIFF, vectors (arrays) must be of same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit (difference, .) ;
      end ;

   endsub ;
run ;

/**DEMO:
libname library '/az/sas/public/library' ;
options cmplib=(library.functions) ;

data _null_ ;
   array minuend    (5) minuend1-minuend5 ;
   array subtrahend (5) subtrahend1-subtrahend5 ;
   array difference (5) difference1-difference5 ;

   do i = 1 to 5 ;
      minuend(i) = ranuni(0) ;
      subtrahend(i) = ranuni(0) ;
   end ;

   call vectoradd (minuend, subtrahend, difference) ;

   put difference1= difference2= difference3= difference4= difference5= ;
run ;
*/
