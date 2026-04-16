
%*--------------------------------------------------------------------------------*
 | FCMP:     intersect2d.sas                                                      |
 |                                                                                |
 | PURPOSE:  The subroutine routine calculates the intersection point (if it      |
 |           exists) between two lines in a two-dimensional space. The lines are  |
 |           defined by two points each, and the result is returned in an output  |
 |           array. This routine provides special handling for cases when the     |
 |           lines are parallel or coincident, using special .MISSING values      |
 |           to indicate these situations.                                        |
 |                                                                                |
 | SYNTAX:  call intersect2d(A1, A2, B1, B2, I)                                   |
 |           A1 - Array representing the X-Y coordinates of the point 1 on line A |
 |           A2 - Array representing the X-Y coordinates of the point 2 on line A |
 |           B1 - Array representing the X-Y coordinates of the point 1 on line B |
 |           B2 - Array representing the X-Y coordinates of the point 2 on line B |
 |           I  - Output array that will contain the intersection X=Y coordinates |
 |                                                                                |
 | VERSION:  1.0                                                                  |
 |                                                                                |
 | CATEGORY: Coordinate System Functions                                          |
 |                                                                                |
 | SEE ALSO: CALL INTERSECT2D, CALL INTERSECT3D, 
 |                                                                                |
 | DATE      DESCRIPTION                                            BY            |
 | ========  ===================================================    ============= |
 | 10/17/24  Original program                                       Paul McDonald |
 |                                                                                |
 | Notes:    Special output considerations:                                       |
 |           .m: At least one of the input values is missing and an intersection  |
 |               point cannot be calculated                                       |
 |           .p: The lines are parallel, indicating no intersection point exists  |
 |           .c: The lines are coincident, meaning they overlap completely and    |
 |               thus have infinite intersection points (all points on each line  |
 |               are points of intersection).                                     |
 |                                                                                |
 *--------------------------------------------------------------------------------* ;

libname library '/home/paulmcdonald0/rds/library/cmplib' ;

proc fcmp outlib=library.functions.smd ;
   deletesubr intersect2d ;
run ;

proc fcmp outlib=library.functions.smd ;
    subroutine intersect2d(A1[2], A2[2], B1[2], B2[2], I[2]) ;
        static erflg 0 ntflg 0 ;
        outargs I ;
       
       %*---------------------------------*
        | Extract coordinates from arrays |
        +---------------------------------+------------------------------------------*
        | A1 and A2 represent points on line A, B1 and B2 represent points on line B |
        *----------------------------------------------------------------------------* ;

        a1x = A1[1] ;
        a1y = A1[2] ;
        a2x = A2[1] ;
        a2y = A2[2] ;
        b1x = B1[1] ;
        b1y = B1[2] ;
        b2x = B2[1] ;
        b2y = B2[2] ;
       
       %*-------------*
        | QC routines |
        +-------------+---------------------------------*
        | Check for missing values in input coordinates |
        *-----------------------------------------------* ;

        if nmiss(a1x, a1y, a2x, a2y, b1x, b1y, b2x, b2y) > 0 then do ;
            if ntflg = 0 then do ;
                put 'NOTE: Missing values were generated as a result of performing an operation on missing values in CALL INTERSECT2D.' ;
                ntflg = 1 ;
            end ;
            I[1] = .m ;
            I[2] = .m ;
            return ;
        end ;
       
       %*--------------------------------------------------------*
        | Calculate the denominator for determining intersection |
        *--------------------------------------------------------* ;

        denom = (a1x - a2x) * (b1y - b2y) - (a1y - a2y) * (b1x - b2x) ;
       
       %*----------------------------------------------------*
        | Check if lines are coincident (all points overlap) |
        *----------------------------------------------------* ;

        if denom = 0 then do ;

           %*--------------------------------------------------------------------------------*
            | Check if the lines are coincident by verifying if points lie on the same line  |
            *--------------------------------------------------------------------------------* ;

            if (a1x * (b2y - b1y) + b1x * (a2y - a1y) + b2x * (a1y - b1y)) = 0 then do ;
                if ntflg = 0 then do ;
                    put 'NOTE: The lines are coincident in CALL INTERSECT2D. Infinite intersection points exist.' ;
                    ntflg = 1 ;
                end ;
                I[1] = .c ;
                I[2] = .c ;
                return ;
            end ;

           %*------------------------------------------*
            | If lines are parallel but not coincident |
            *------------------------------------------* ;

            else do ;
                if ntflg = 0 then do ;
                    put 'NOTE: The lines are parallel in CALL INTERSECT2D. No intersection point exists.' ;
                    ntflg = 1 ;
                end ;
                I[1] = .p ;
                I[2] = .p ;
                return ;
            end ;
        end ;
       
       %*-----------------------------------------------*
        | Calculate numerators for parametric equations |
        *-----------------------------------------------* ;

        num1 = (a1x * a2y - a1y * a2x) ;
        num2 = (b1x * b2y - b1y * b2x) ;
       
       %*-------------------------------------------------------*
        | Calculate intersection coordinates using Cramers rule |
        *-------------------------------------------------------* ;

        ix = (num1 * (b1x - b2x) - (a1x - a2x) * num2) / denom ;
        iy = (num1 * (b1y - b2y) - (a1y - a2y) * num2) / denom ;
       
       %*-------------------------------*
        | Assign result to output array |
        *-------------------------------+----------------------------------------------*
        | I[1] and I[2] will contain the x and y coordinates of the intersection point |
        *------------------------------------------------------------------------------* ;

        I[1] = ix ;
        I[2] = iy ;
    endsub ;
run ;

/**DEMO:
libname library '/az/sas/public/library' ;
options cmplib=(library.functions) ;

data _null_ ;
    * Define arrays representing points on lines A and B ;
    array A1[2] (1, 1) ;
    array A2[2] (4, 4) ;
    array B1[2] (1, 5) ;
    array B2[2] (5, 1) ;
    array I[2] ;
   
    * Call the intersect2d subroutine to calculate the intersection point ;
    call intersect2d(A1, A2, B1, B2, I) ;
   
    * Output the intersection point to the log ;
    put "Intersection Point: (" I[1] ", " I[2] ")" ;
run ;
*/