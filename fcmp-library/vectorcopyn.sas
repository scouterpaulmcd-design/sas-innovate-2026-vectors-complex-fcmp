
%*--------------------------------------------------------------------------------*
 | CALL:     vectorcopyn.sas                                                      |
 |                                                                                |
 | PURPOSE:  This subroutine copies all members of a numeric SAS array (or        |
 |           vector) from one array to another.                                   |
 |                                                                                |
 | SYNTAX:   CALL VECTORCOPYN (from, to)                                          |
 |            from = numeric-SAS-array [required] A numeric SAS variable array    |
 |                   representing the source vector or array to copy.  Arrays     |
 |                   from and to must be the same dimension.                      |
 |            to   = numeric-SAS-array [required] A numeric SAS variable array    |
 |                   representing the destination vector or array that is to be   |
 |                   copied.  Arrays from and to must be the same dimension.      |
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

libname library '/az/sas/public/library' ;
options cmplib=(library.functions) ;

proc fcmp outlib=library.functions.smd ;
   deletesubr vectorcopyn ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine vectorcopyn(from[*], to[*]) ;
      outargs to ;
      static err 0 ;
      length i 8 ;

      if dim(from) = dim(to) then do ;
         do i = 1 to dim(from) ;
            to[i] = from [i] ;
         end ;
      end ;
      else do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL VECTORCOPY, vectors (arrays) must have the same dimensions.' ;
            err = 1 ;
         end ;
         call vectorinitn(to, .) ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/az/sas/public/library' ;
options cmplib=(library.functions) ;

data _null_ ;
   array a (3) a1-a3 ;
   array b (3) b1-b3 ;

   call vectorinitn (a, 1) ;

   call vectorcopyn(a, b) ;
   put b1= b2= b3= ;
run ;
*/
