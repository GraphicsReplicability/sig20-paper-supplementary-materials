Paper statistics
================
The matlab script `generateStatistics.m` produces statistic related figures in the paper, as well a p-values, numbers, and Table 1 data as latex macros. This script depends on `chi2test.m`, `fdr_bh.m` and `tscore.m`

Figure 2: ACM keywords repartition
==================================

The matlab script `generate_topics_clouds.m` loads the file `topics.json` and outputs pdf files of the word clouds.
The file `topics.cloud` has been extracted from the dataset file by loading the content of the columns `[row[‘ACM X’]]` with `X` ranging from 1 to 10.
