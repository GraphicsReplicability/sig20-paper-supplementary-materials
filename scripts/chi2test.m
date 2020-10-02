%% https://fr.mathworks.com/matlabcentral/answers/96572-how-can-i-perform-a-chi-square-test-to-determine-how-statistically-different-two-proportions-are-in
function [p] = chi2test(n1, N1, n2, N2)
       % Pooled estimate of proportion
       p0 = (n1+n2) / (N1+N2);
       % Expected counts under H0 (null hypothesis)
       n10 = N1 * p0;
       n20 = N2 * p0;
       % Chi-square test, by hand
       observed = [n1 N1-n1 n2 N2-n2];
       expected = [n10 N1-n10 n20 N2-n20];
       chi2stat = sum((observed-expected).^2 ./ expected);
       p = 1 - chi2cdf(chi2stat,1);
