
%*--------------------------------------------------------------------------------*
 | FCMP:     complex2char.sas                                                     |
 |                                                                                |
 | PURPOSE:  This data step function accepts a two-dimensional array representing |
 |           a complex number and returns a text string in cartesian convention   |
 |           for the value.  For example, if the array values are (2,5) then the  |
 |           function returns the string 2 + 5i.                                  |
 |                                                                                |
 | SYNTAX:   COMPLEX2CHAR(complex, style)                                         |
 |            complex = numeric-SAS-array [required] A numeric SAS variable array |
 |                      representing the two-dimensional array for a Cartesian    |
 |                      complex number in the form C = a + bi.                    |
 |            style   = C|D|O|R|E [required] A character string declaring the     |
 |                      style for displaying the complex number.  Valid values    |
 |                      are C (Cartesian), D (degrees), O (ordered pair),         |
 |                      R (radians), and E (exponential).                         |
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
 | 07/10/24  Added ordered pair style output                        Paul McDonald |
 |                                                                                |
 | Notes:    Complex numbers are stored in a 2-dimensional numeric array with the |
 |           first element representing the real part (a) and the second element  |
 |           representing the imaginary part (b) of the complex number.  All      |
 |           complex numbers are stored using cartesian format (C = a + bi) using |
 |           these tools.  The result of this function is a character string      |
 |           of the given complex number displayed in the requested format.       |                                                        |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;

proc fcmp outlib=library.functions.smd ;
   deletefunc complex2char ;
run ;

proc fcmp outlib=library.functions.smd ;
   function complex2char (complex[2], format $) $32 ;
      static err 0 ;
      length fmt $1 ;
      fmt = upcase(substr(strip(format), 1, 1)) ;

      if dim(complex) ne 2 then do ;
         if err = 0 then do ;
            put 'NOTE: Invalid first argument to function COMPLEX2CHAR, vector must be two dimensions.' ;
            put 'NOTE: The function COMPLEX2CHAR will return the null string.' ;
            err = 1 ;
         end ;
         return('') ;
      end ;
      else if fmt not in ('C','D','O','R','E') then do ;
         if err = 0 then do ;
            put 'NOTE: Invalid second argument to function COMPLEX2CHAR, format must be C (Cartesian), D (Degrees), or R (Radians).' ;
            put 'NOTE: The function COMPLEX2CHAR will return the null string.' ;
            err = 1 ;
         end ;
         return('') ;
      end ;
      else if fmt = 'C' then do ;
         if complex[2] ge 0 then return(strip(put(complex[1], best.))||' +'||strip(put(complex[2], best.))||'i') ; 
         else return(strip(put(complex[1], best.))||sign||strip(put(complex[2], best.))||'i') ; 
      end ;
      else if fmt = 'D' then do ;
         if complex[1] = 0 then return(strip(put(sqrt(sum(complex[1]**2, complex[2]**2)), best.))||', 90 deg') ; 
         else return(strip(put(sqrt(sum(complex[1]**2, complex[2]**2)), best.))||', '||strip(put(atan(complex[2]/complex[1])*180/constant('pi'), best.))||' deg') ; 
      end ;
      else if fmt = 'R' then do ;
         if complex[1] = 0 then return(strip(put(sqrt(sum(complex[1]**2, complex[2]**2)), best.))||', pi/2 rad') ; 
         else return(strip(put(sqrt(sum(complex[1]**2, complex[2]**2)), best.))||', '||strip(put(atan(complex[2]/complex[1]), best.))||' rad') ; 
      end ;
      else if fmt = 'E' then do ;
         if complex[1] = 0 then return(strip(put(sqrt(sum(complex[1]**2, complex[2]**2)), best.))||'e^(i'||',*pi/2)') ; 
         else return (strip(put(sqrt(sum(complex[1]**2, complex[2]**2)), best.))||'e^(i'||strip(put(atan(complex[2]/complex[1]), best.))||')') ;
      end ;
      else if fmt = 'O' then do ;
         return ('('||strip(put(complex[1], best.))||', '||strip(put(complex[2], best.))||')') ;
      end ;
      else do ;
         if err = 0 then do ;
            put 'ERROR: Unknown issue encountered in function COMPLEX2CHAR.' ;
            put 'NOTE: The function COMPLEX2CHAR will return the null string.' ;
            err = 1 ;
         end ;
         return('') ;
      end ;
   endsub ;
run ;

/**DEMO:
libname library '/home/paulmcdonald0/rds/library/cmplib' ;
options cmplib=(library.functions) ;

data _null_ ;
   length cartesian degrees radians exponent $32 ;
   array c (2) r i ;

   r = 10*ranuni(0) ;
   i = 10*ranuni(0) ;

   cartesian   = complex2char (c, 'c') ;
   degrees     = complex2char (c, 'd') ;
   radians     = complex2char (c, 'r') ;
   orderedpair = complex2char (c, 'o') ;
   exponent    = complex2char (c, 'e') ;
   put cartesian= ;
   put degrees= ; 
   put radians= ;
   put orderedpair= ;
   put exponent= ;
run ;
*/