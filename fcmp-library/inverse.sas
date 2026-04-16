
%*--------------------------------------------------------------------------------*
 | FCMP:     inverse.sas                                                          |
 |                                                                                |
 | PURPOSE:  This data step function returns the inverse of a given number.       |
 |           If the inverse is undefined (zero or missing input), the function    |
 |           returns a missing value without generating log messages.             |
 |                                                                                |
 | SYNTAX:   inverse (number)                                                     |
 |              number - numeric [required] Any real number                       |
 |                                                                                |
 | VERSION:  1.1                                                                  |
 |                                                                                |
 | CATEGORY: Mathematical functions                                               |
 |                                                                                |
 | SEE ALSO: MOVINGAVERAGE, PRODUCT, SUMDIGITS, WEIGHTEDAVERAGE                   |
 |                                                                                |
 | DATE      DESCRIPTION                                            BY            |
 | ========  ===================================================    ============= |
 | 01/12/23  Original program                                       Paul McDonald |
 | 01/04/26  Explicit silent handling of zero and missing inputs    Paul McDonald |
 |                                                                                |
 | Notes:                                                                         |
 | - Zero and missing inputs return a missing value without logging.              |
 | - This function intentionally suppresses diagnostic messages.                  |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;

proc fcmp outlib=library.functions.smd ;
   deletefunc inverse ;
run ;

proc fcmp outlib=library.functions.smd ;
   function inverse(in) ;
      if missing(in) or in = 0 then inv = . ;
      else inv = 1/in ;
      return(inv) ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   var1 = 10 ;
   var2 = -10 ;
   var3 = 0 ;

   inv1 = inverse(var1) ;
   inv2 = inverse(var2) ;
   inv3 = inverse(var3) ;

   put inv1= inv2= inv3= ;
run ;
*/
