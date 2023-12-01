## Description
The Prolog rules created in this program are listed below:

| Rule | Description |
| ---- | ----------- |
|`load_data_column('file.csv', Header, C, List)` |Loads the column `C` from a CSV file `file.csv`. `Header`: (`true` or `false`) indicates whether the file has headers or not. The values of the column are placed on list `List`. |
|`regressiona(X, Y, A)` | Calculates the $\alpha$ parameter of the linear regression using list `X` and list `Y`. Places the $\alpha$ parameter in variable `A`. |
|`regressionb(X, Y, B)` | Calculates the $\beta$ parameter of the linear regression using list `X` and list `Y`. Places the $\beta$ parameter in variable `B`.|
|`correlation(X, Y, R)` | Calculates the Pearson Correlation Coefficient of the linear regression using lists `X` and `Y`. Places the value of coefficient r in variable `R`. |
|`mean(L, M)` | Calculates the mean of the values in list `L`. Places the mean in variable `M`  |
|`stddev(L, S)` | Calculates the standard deviation of the values in list `L`. Places the standard deviation in variable `S`|
