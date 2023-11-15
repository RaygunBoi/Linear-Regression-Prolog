%Main Rules
load_data_column(FileName, Header, C, List) :- %First version of load_data_column that checks for the CSV file header
    Header = true, %If there is a header, perform the following statements
    read_file_to_string(FileName, FileLine, []), %Goes through each file line and turns it into a string
    split_string(FileLine, "\n", trim, Lines), %Splits the string into separate values and puts them into the Lines list
    get_column(Lines, C, RemoveList), %Helper rule that gets the values of C from Lines and puts them into RemoveList
    remove_first(RemoveList, TempList), %Removes the first element from RemoveList and puts the remaining values in TempList
    maplist(atom_number, TempList, List). %Turns every element in TempList into a number and stores it in List

load_data_column(FileName, Header, C, List) :- %Second version of load_data_column that checks for no CSV file header
    Header = false, %If there is no header, perform the following statements
    read_file_to_string(FileName, FileLine, []), %Goes through each file line and turns it into a string
    split_string(FileLine, "\n", trim, Lines), %Splits the string into separate values and puts them into the Lines list
    get_column(Lines, C, TempList), %Helper rule that gets the values of C from Lines and puts them into RemoveList
    maplist(atom_number, TempList, List). %Turns every element in TempList into a number and stores it in List

regressiona(X, Y, A) :-
    length(X, L), %Gets the length of one of the lists and stores it in L
    sum_xy(X, Y, SumXY), %Helper rule that returns the sum of lists X and Y and stores it in SumXY
    sum_list(X, SumX), %Calculates the sum of list X and stores it in SumX
    sum_list(Y, SumY), %Calculates the sum of list Y and stores it in SumY
    sum_squared(X, SumXSquared), %Helper rule that returns the squared sum of list X and stores it in SumXSquared
    SquareSumX is SumX * SumX, %Squares SumX and stores it in SquareSumX
    AR is (L * SumXY - SumX * SumY) / (L * SumXSquared - SquareSumX), %Calculates a and stores it in AR
    round_decimal(AR, 4, A). %Helper rule that rounds AR to 4 decimal places and stores it in A

regressionb(X, Y, B) :-
    length(X, L), %Gets the length of one of the lists and stores it in L
    sum_xy(X, Y, SumXY), %Helper rule that returns the sum of lists X and Y and stores it in SumXY
    sum_list(X, SumX), %Calculates the sum of list X and stores it in SumX
    sum_list(Y, SumY), %Calculates the sum of list Y and stores it in SumY
    sum_squared(X, SumXSquared), %Helper rule that returns the squared sum of list X and stores it in SumXSquared
    SquareSumX is SumX * SumX, %Squares SumX and stores it in SquareSumX
    A is (L * SumXY - SumX * SumY) / (L * SumXSquared - SquareSumX), %Calculates a and stores it in A
    sum_list(Y, SumY), %Calculates the sum of list Y and stores it in SumY
    sum_list(X, SumX), %Calculates the sum of list X and stores it in SumX
    BR is (SumY - A * SumX) / L, %Calculates b and stores it in BR
    round_decimal(BR, 4, B). %Helper rule that rounds BR to 4 decimal places and stores it in B

correlation(X, Y, R) :-
    length(X, L), %Gets the length of one of the lists and stores it in L
    sum_xy(X, Y, SumXY), %Helper rule that returns the sum of lists X and Y and stores it in SumXY
    sum_list(X, SumX), %Helper rule that returns the sum of list X and stores it in SumX
    sum_list(Y, SumY), %Helper rule that returns the sum of list Y and stores it in SumY
    sum_squared(X, SumXSquared), %Helper rule that returns the squared sum of list X and stores it in SumXSquared
    sum_squared(Y, SumYSquared), %Helper rule that returns the squared sum of list Y and stores it in SumYSquared
    SquareSumX is SumX * SumX, %Squares SumX and stores it in SquareSumX
    SquareSumY is SumY * SumY, %Squares SumY and stores it in SquareSumY
    RR is (L * SumXY - SumX * SumY) / sqrt((L * SumXSquared - SquareSumX) * (L * SumYSquared - SquareSumY)), %Calculates correlation and stores it in RR
    round_decimal(RR, 4, R). %Helper rule that rounds RR to 4 decimal places and stores it in R

mean(L, M) :-
    length(L, Length), %Gets the length of L and stores it in Length
    sum_list(L, Sum), %Adds all the values in L and stores it in Sum
    M is Sum / Length. %Calculates the mean and stores it in M

stddev(L, S) :-
    length(L, Length), %Gets the length of L and stores it in Length
    mean(L, M), %Calculates the mean and stores it in M
    maplist(square_difference(M), L, SquaredDifferences), %Uses helper rule square_difference to calculate the squared difference of M using L and stores it in the SquaredDifferences list
    sum_list(SquaredDifferences, SumSquaredDifferences), %Calculates the sum of the SquaredDifferences list and stores it in SumSquaredDifferences
    V is SumSquaredDifferences / Length, %Calculates variance and stores it in V
    SR is sqrt(V), %Calculates standard deviation and stores it in SR
    round_decimal(SR, 4, S). %Helper rule that rounds SR to 4 decimal places and stores it in S

%Helper Rules
remove_first([_|Tail], Tail). %Removes the first element in a list and stores it in Tail

get_column([], _, []). %First version of get_column that checks for an empty list
get_column([Line|RestLines], C, [CellValue|RestColumnValues]) :- %Second version of get_column that performs the following statements for a list
    split_string(Line, ",", "", SplitLine), %Splits Line into separate values using commas and stores the values in the SplitLine list
    nth0(C, SplitLine, CellValue), %Grabs the C value in SplitLine and stores it in CellValue
    get_column(RestLines, C, RestColumnValues). %Recursion to go through the statements again

square_difference(M, X, DiffSquared) :-
    Diff is X - M, %Calculates the difference of X minus the mean and stores it in Diff
    DiffSquared is Diff * Diff. %Squares Diff and stores it in DiffSquared

round_decimal(Number, DecimalPlaces, RoundedResult) :-
    Power is 10 ** DecimalPlaces, %Stores the number of decimal places to round to in Power
    RoundedResult is round(Number * Power) / Power. %Calculates the rounded version of Number and stores it in RoundedResult

sum_xy([], [], 0). %First version of sum_xy that checks for an empty list
sum_xy([X|Xs], [Y|Ys], Sum) :- %Second version of sum_xy that performs the following statements for a list
    sum_xy(Xs, Ys, RestSum), %Recursion to go through lists X and Y again
    Sum is RestSum + X * Y. %Calculates the sum of the product of each value between X and Y and stores it in Sum

sum_squared(List, Sum) :-
    maplist(square, List, Squares), %Uses the helper rule square to square every element in List and store it in the Squares list
    sum_list(Squares, Sum). %Calculates the sum of every value in Squares and stores it in Sum

square(X, Result) :- Result is X * X. %Squares X and stores it in Result
/*
    Test File for Prolog Assignment
    
*/

/* Data Definitions */

sat([1714,1664,1760,1685,1693,1764,1764,1792,1850,1735]).
gpa([2.4,2.52,2.54,2.74,2.83,3,3,3.01,3.01,3.02]).
/*
{{2.4,1714},{2.52,1664},{2.54,1760},{2.74,1685},{2.83,1693},{3,1764},{3,1764},{3.01,1792},{3.01,1850},{3.02,1735}}
data1([10,11,12,14,9]).
*/

writeln(T) :- write(T), nl.

main :-
        gpa(Gpa), /* Get GPA List */
        sat(Sat), /* Get SAT List */
        mean(Gpa, MeanG), /* Get Mean GPA */
        mean(Sat, MeanS), /* Get Mean SAT */
        stddev(Gpa, SDG), /* Get Standard Deviation of GPA */
        stddev(Sat, SDS), /* Get Standard Deviation of SAT */
        regressiona(Sat, Gpa, A), /* Get Regression alpha parameter */
        regressionb(Sat, Gpa, B), /* Get Regression beta parameter */
        correlation(Sat, Gpa, R), /* Get Pearson Correlation Coefficient */
        /* [10,11,12,14,9] */
        load_data_column('data1.csv', false, 0, ListOne), /* Load Data from CSV */
        /* [10,11,12,14,9] */
        load_data_column('data2.csv', true, 0, ListTwo), /* Load Data from CSV */
        /* [1714,1664,1760,1685,1693,1764,1764,1792,1850,1735] */
        load_data_column('sat-gpa.csv', true, 1, ListThree), /* Load Data from CSV */

        /* 2.8070 */
        writeln(MeanG),     
        /* 1742.1 */
        writeln(MeanS),
        /* 0.2295 */     
        writeln(SDG),       
        /* 52.9367 */
        writeln(SDS),       
        /* 0.0025 Wolfram Alpha: 0.00252447 */
        writeln(A),         
        /* -1.5909 Wolrfram Alpha: -1.59088*/
        writeln(B),         
        /* 0.5823 Wolfram Alpha: 0.582348 */
        writeln(R),        
        /* [10,11,12,14,9] */ 
        writeln(ListOne),   
        /* [10,11,12,14,9] */
        writeln(ListTwo),   
        /* [1714,1664,1760,1685,1693,1764,1764,1792,1850,1735] */
        writeln(ListThree). 
