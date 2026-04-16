
%*--------------------------------------------------------------------------------*
 | CALL:     vectorsum.sas                                                        |
 |                                                                                |
 | PURPOSE:  This subroutine performs a vector addition operation on two vectors  |
 |           as defined in a SAS array.                                           |
 |                                                                                |
 | SYNTAX:    CALL VECTORSUM (augend, addend, sum)                                |
 |             augend = numeric-SAS-array [required] A numeric SAS variable array |
 |                      array representing the vector augend.  The arrays for the |
 |                      augend, addend, and sum must be the same dimension.       |
 |             addend = numeric-SAS-array [required] A numeric SAS variable array |
 |                      array representing the vector addend.  The arrays for the |
 |                      augend, addend, and sum must be the same dimension.       |
 |             sum    = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the sum result vector of the augend added to |
 |                      the addend.  The arrays for the augend, addend, and sum   |
 |                      must be the same dimension.                               |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Vector operations and complex numbers                                |
 |                                                                                |
 | SEE ALSO: CALL COMPLEXADD, CALL COMPLEXCONJ, CALL COMPLEXDIFF,                 |
 |           CALL COMPLEXDIV, CALL COMPLEXEXP, CALL COMPLEXSQRT, CALL CROSSPROD,  |
 |           CALL HADAMARD, CALL SCALARPROD, CALL SQRTNEG, CALL VECTORSUM,        |
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
   deletesubr vectorsum ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectorsum (augend[*], addend[*], sum[*]) ;
      static err 0 ;
      outargs sum ;
      if dim(augend)=dim(addend)=dim(sum) then do i = 1 to dim(sum) ;
         sum[i] = augend[i] + addend[i] ;
      end ;
      else do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL VECTORSUM, vectors (arrays) must be of same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinit (sum, .) ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;


data _null_ ;
   array augend (5) augend1-augend5 ;
   array addend (5) addend1-addend5 ;
   array vsum   (5) vsum1-vsum5 ;

   do i = 1 to 5 ;
      augend(i) = ranuni(0) ;
      addend(i) = ranuni(0) ;
   end ;

   call vectorsum (augend, addend, vsum) ;

   put vsum1= vsum2= vsum3= vsum4= vsum5= ;
run ;

data VeryLargeArray ;
   array v1 (1000) a1-a1000 ;
   array v2 (1000) b1-b1000 ;
   array v3 (1000) c1-c1000 ;
   array vs (1000) s1-s1000 ;
 
   do i = 1 to 1000 ;
      v1(i) = ceil(ranuni(0)*10) ;
      v2(i) = ceil(ranuni(0)*10) ;
      vs(i) = sum(v1(i), v2(i)) ;
   end ;

   call vectorsum (v1, v2, v3) ;

   flag = 0 ;
   do i = 1 to 1000 ;
      if vs(i) ne v3(i) then do ;
         flag = 1 ;
         sum=vs(i) ;
         call=v3(i) ;         
         put 'Very Large Array failure: ' i= sum= call= ;
      end ;
   end ;
   if flag = 0 then put 'Very Large Array SUCCESS!' ;
run ;
*/
