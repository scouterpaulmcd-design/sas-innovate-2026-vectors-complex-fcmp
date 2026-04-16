
%*--------------------------------------------------------------------------------*
 | CALL:     swapnarray.sas                                                       |
 |                                                                                |
 | PURPOSE:  This subroutine swaps the component values of two given numeric      |
 |           variable arrays of the same dimension.  If the arrays are not of the |
 |           same dimension, the values will remain as originally presented.      |
 |                                                                                |
 | SYNTAX:   CALL SWAPNARRAY (array1, array2)                                     |
 |            array1 = numeric-SAS-array [required] A numeric SAS variable array  |
 |                     representing the first array .                             |
 |            array2 = numeric-SAS-array [required] A numeric SAS variable array  |
 |                     representing the second array .                            |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Array Operations                                                     |
 |                                                                                |
 | SEE ALSO: CALL SWAPC, CALL SWAPCARRAY, CALL SWAPN, CALL SWAPNARRAY             |
 |                                                                                |
 | DATE      DESCRIPTION                                            BY            |
 | ========  ===================================================    ============= |
 | 08/09/24  Original program                                       Paul McDonald |
 |                                                                                |
 | Notes:                                                                         |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;

proc fcmp outlib=library.functions.smd ;
   deletesubr swapnarray ;
run ;

proc fcmp outlib=library.functions.smd ;
   subroutine swapnarray (array1[*], array2[*]) ;
      static err 0 ;
      outargs array1, array2 ;

      if dim(array1) ne dim(array2) then do ;
         if err = 0 then do ;
            put 'NOTE: Array subscript out of range in CALL SWAPNARRAY, arrays must be of same dimension.' ;
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
   array x [5] x1-x5 (1, 2, 3, 4, 5) ;
   array y [5] y1-y5 (5, 4, 3, 2, 1) ;

   call swapnarray (x, y) ;
   do i = 1 to 5 ;
      put x[i]= y[i]= ;
   end ;
run ;
*/
