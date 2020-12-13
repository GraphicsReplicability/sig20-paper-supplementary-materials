# Code Replicability in Computer Graphics

Supplementary material website for the paper:

```
 Code Replicability in Computer Graphics, Nicolas Bonneel, David
 Coeurjolly, Julie Digne, Nicolas Mellado, ACM Transactions on
 Graphics (Proceeding of SIGGRAPH 2020, 39:4)
```
* Nicolas Bonneel (CNRS, LIRIS, Lyon, France)
* David Coeurjolly (CNRS, LIRIS, Lyon, France)
* Julie Digne (CNRS, LIRIS, Lyon, France)
* Nicolas Mellado (CNRS, IRIT, Toulouse, France)

More details: https://replicability.graphics
```
@article{replicGraph2020,
  author  =    {Nicolas Bonneel, David Coeurjolly, Julie Digne and Nicolas Mellado},
  title   =    {Code replicabiltiy in computer graphics},
  journal =    {ACM Transactions on Graphics (Proceedings of SIGGRAPH 2020)},
  year    =    {2020},
  volume  =    {39},
  number  =    {4},
}
```

This folder contains the data exploration website (*website/* folder) and the matlab scripts (*scripts/* folder) that generate the statistics from the consolidated data, available [here](website/consolidatedData.json).


Paper statistics (Figures 4 and 5)
================
The matlab script `generateStatistics.m` available in the *scripts/* folder produces statistic related figures in the paper (Figures 4 and 5), as well a p-values, numbers, and Table 1 data as latex macros saved in a file `stats.txt`. This script depends on `chi2test.m`, `fdr_bh.m` and `tscore.m`

ACM keywords repartition (Figure 2)
==================================

The matlab script `generate_topics_clouds.m` available in the *scripts/* folder  loads the file `topics.json` and outputs pdf files of the word clouds.
The file `topics.cloud` has been extracted from the dataset file by loading the content of the columns `[row[‘ACM X’]]` with `X` ranging from 1 to 10.

Website (Figure 3)
==================================
The website can be launched using the file `index.html` available in the *website/* folder. It has been tested with Chrome, IE, Edge and Firefox.

License
==================================
The scripts and data follow the (BSD like) [CeCILL-B](https://cecill.info/licences/Licence_CeCILL-B_V1-en.html) license.
