%*--------------------------------------------------------------------------------*
 | CALL:     swapcarray.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine swaps the component values of two given character    |
 |           variable arrays of the same dimension.  If the arrays are not of the |
 |           same dimension, the values will remain as originally presented.      |
 |                                                                                |
 | SYNTAX:   CALL SWAPCARRAY (array1, array2)                                     |
 |            array1 = character-SAS-array [required] A character SAS variable    |
 |                     array to swap.                                             |
 |            array1 = character-SAS-array [required] A character SAS variable    |
 |                     array to swap.                                             |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Array Operations                                                     |
 |                                                                                |
 | SEE ALSO: CALL SWAPC, CALL SWAPCARRAY, CALL SWAPN, CALL SWAPNARRAY             |
 |                                                                                |
 | DATE      DESCRIPTION                                            BY            |
 | ========  ===================================================    ============= |
 | 08/05/24  Original program                                       Paul McDonald |
 |                                                                                |
 | Notes:    Swapping character variable arrays of different lengths can lead to  |
 |           truncation of the values just as with character variables that are   |
 |           of different lengths.                                                |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;

proc fcmp outlib=library.functions.smd ;
   deletesubr swapcarray ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine swapcarray (array1[*] $, array2[*] $) ;
      static err warn 0 ;
      outargs array1, array2 ;

      if dim(array1) ne dim(array2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL SWAPCARRAY, arrays must be of same dimension.' ;
            put 'NOTE: The values of the arrays will not be modified.' ;
            err = 1 ;
         end ;
      end ;
      else do ;
         do i = 1 to dim(array1) ;
            tempswap = array1[i] ;
            array1[i] = array2[i] ;
            array2[i] = tempswap ;
         end ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   array x [5] $ x1-x5 ('A', 'B', 'C', 'D', 'E') ;
   array y [5] $ y1-y5 ('F', 'G', 'H', 'I', 'J') ;

   call swapcarray (x, y) ;
   do i = 1 to 5 ;
      put x[i]= y[i]= ;
   end ;
run ;
*/



