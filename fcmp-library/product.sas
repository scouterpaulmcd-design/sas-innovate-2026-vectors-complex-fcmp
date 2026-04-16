
%*--------------------------------------------------------------------------------*
 | FCMP:     product.sas                                                          |
 |                                                                                |
 | PURPOSE:  The function product() is used to compute the product across all the |
 |           variables contained in an array.                                     |
 |                                                                                |
 | SYNTAX:  product(data-array)                                                   |
 |            data-array - numeric-SAS-array [required]  A numeric SAS variable   |
 |                                                array                           |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Mathematical functions                                               |
 |                                                                                |
 | SEE ALSO: INVERSE, PRODUCT                                                     |
 |                                                                                |
 | DATE      DESCRIPTION                                            BY            |
 | ========  ===================================================    ============= |
 | ??/??/??  Original program from sas.com                          Rick Wicklin  |
 | 01/21/24  added to AutoZone function library                     Paul McDonald |
 |                                                                                |
 | Notes:    Array values that are missing are ignored. If all variables in the   |
 |           array have missing values, then the function returns the missing     |
 |           value.                                                               |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;

proc fcmp outlib=library.functions.smd ;
   deletefunc product ;
run ;


proc fcmp outlib=library.functions.smd ;
   function product(x[*])  ;
      prod = 1 ; 
      n = 0 ; 
      do i = 1 to dim(x) ;
         if ^missing(x[i]) then do ;
            n + 1 ;
            prod = prod * x[i] ;
         end ;
      end ;
      if n=0 then prod = . ;
      return(prod) ;
   endsub ;
quit ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;
** Create sample data. See https://blogs.sas.com/content/iml/2021/03/10/pi-and-products.html ;
** Source:  https://blogs.sas.com/content/iml/2021/05/19/implement-product-function-sas.html ;

data WallisLong (drop=n) ;
   do n = 1 to 1000 ;
      term = (2*n/(2*n-1)) * (2*n/(2*n+1)) ;
      output ;                     
   end ;
run ;
 
data WallisWide (drop=n) ;
   array term[1000] term1-term1000 ;

   class = 'All missing values' ;
   output ;

   do n = 1 to 1000 ;
      term[n] = (2*n/(2*n-1)) * (2*n/(2*n+1)) ;
   end ;
   class = 'No missing values' ;
   output ;                     

   class = 'Some missing values' ;
   term(5) = . ;
   term(17) = . ;
   term(102) = . ;   
   output ;
run ;
 
data _null_ ;
   array vars[1000] term1-term1000 ;
   set WallisWide ;
   prod = product(vars) ;
   put class= prod= ;
run ;
*/
