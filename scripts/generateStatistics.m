% This scripts generates all figures related to statistical analyses
% It directly generates .pdf files, show the output on screen, and 
% also produce macros containing relevant stats for our latex paper

% colors from https://www.thisprogrammingthing.com/2014/optimal-colors-for-graphsin-rgb-hex/
linecolor = [114 147 203]/255;
circcolor = [57 106 177]/255;
colors = [57 106 177; 218 124 48; 62 150 81; 204 37 41; 83 81 84; 107 76 154; 146 36 40]/255;
lightcolors = [114 147 203; 225 151 76; 132 186 91; 211 94 96; 128 133 133; 144 103 167; 171 104 87]/255;

alpha = 0.05;

% read data
s = jsondecode(fileread('../website/consolidatedData.json'));

% we had blank lines at some point
N=0;
papermax = length(s);
for i=1:papermax
    if (length(strtrim(s{i}.Title))==0)
       continue;
    end;
    N=N+1;
end

% format the data we want in matlab vectors instead.
sourcecode = zeros(N,1);
repro = zeros(N, 1);
hascode = zeros(N, 1);
year = zeros(N, 1);
authors = zeros(N, 1);
citations = zeros(N, 1);
topics = string(missing);
titles = string(missing);
reviewer = zeros(N, 1);
fixbugs = zeros(N, 1);
time = zeros(N, 1);
deep = zeros(N, 1);
isarxiv = zeros(N, 1);
openaccess = zeros(N, 1);
completetest = zeros(N, 1);
missinghardware = zeros(N, 1);
sofwareissues = zeros(N, 1);
altmetric = zeros(N, 1);
haslicence = zeros(N, 1);
hasdoc = zeros(N, 1);
idx = 0;
haspython = zeros(N, 1);
hasmatlab = zeros(N, 1);
hasc = zeros(N, 1);
docscorezero = zeros(N, 1);
hasdata  = zeros(N, 1);

for i=1:papermax
   if (length(strtrim(s{i}.Title))==0)
       continue;
   end;
   idx=idx+1;
   if (s{i}.DoesTheCodeNeedData_otherThanExamples_inputs__== "Yes")
       hasdata(idx)=1;
   else
       hasdata(idx)=0;
   end
       
   if (contains(s{i}.MainLanguages,"C/C++",'IgnoreCase',true))
       hasc(idx) = 1;
   else
       hasc(idx) = 0;
   end;
   if (contains(s{i}.MainLanguages,"Matlab",'IgnoreCase',true))
       hasmatlab(idx) = 1;
   else
       hasmatlab(idx) = 0;
   end;
   if (contains(s{i}.MainLanguages,"Python",'IgnoreCase',true))
       haspython(idx) = 1;
   else
       haspython(idx) = 0;
   end;
   if (s{i}.DocumentationScore == 0)
       docscorezero(idx) = 1;
   else
       docscorezero(idx) = 0;
   end
       
   titles(idx) = s{i}.Title;
   if (contains(s{i}.IsTheCodeOrSoftwarePubliclyAvailable_,"Yes",'IgnoreCase',true))
        hascode(idx)=1;
   end;
   if (length(s{i}.Feedbacks_easyToFixBugs_5_easyN_AIfNoBug__)==0)
       fixbugs(idx) = 100000;
   else
    if (s{i}.Feedbacks_easyToFixBugs_5_easyN_AIfNoBug__(1)=='N')
           fixbugs(idx) = 100000;
    else
     fixbugs(idx) = s{i}.Feedbacks_easyToFixBugs_5_easyN_AIfNoBug__;
    end;
   end
   isarxiv(idx) = contains(s{i}.arXiv_pageURL_, 'arxiv');
   
   if (s{i}.DeepLearning(1)=='N' || s{i}.DeepLearning(1)=='F')
       deep(idx) = 0;
   else
       deep(idx) = 1;
   end
   altmetric(idx)=s{i}.AltmetricScore;
   if (s{i}.LicenseType == "unspecified")
       haslicence(idx) = 0;
   else
       haslicence(idx) = 1;
   end
   if (s{i}.BuildInfo_Instructions == "None")
       hasdoc(idx) = 0;
   else
       hasdoc(idx) = 1;
   end
   
   if (s{i}.DidIManageToPerformACompleteTest_deps_build__ == "Yes") 
       completetest(idx) = 1;
   end
   if (s{i}.DidIManageToPerformACompleteTest_deps_build__ == "No due to technical issue") 
       sofwareissues(idx) = 1;
   end
    if (s{i}.DidIManageToPerformACompleteTest_deps_build__ == "No due to missing specific hardware") 
        missinghardware(idx) = 1;
   end  
   if (length(s{i}.SoftwareType)==0 || s{i}.SoftwareType=="Binary")
       sourcecode(idx) = 0;
   else
       sourcecode(idx) = 1;
   end;
   
   r = s{i}.Feedbacks_couldReproduceResults_5_highlyConfident__;
   if (length(r)==0)
       repro(idx) = 0;
   else
       if (r(1)=='N')
          repro(idx)=0;
       else
          repro(idx) = r ;
       end;
   end;
   
   if (length(s{i}.Year)==0)
       year(idx) = 2018;
   else
       year(idx) = s{i}.Year;
   end;
   
   if (length(s{i}.HowLongDidTakeForYouToEvaluateTheCodeThisPaper_ifAny__)==0)
       time(idx)=-1;
   else
       time(idx) = s{i}.HowLongDidTakeForYouToEvaluateTheCodeThisPaper_ifAny__;
   end
   citations(idx) = s{i}.CitationCount_googleScholar_;
   
   authors(idx) = contains(s{i}.Authors,"Private Companies",'IgnoreCase',true);
   reviewer(idx) = s{i}.Reviewer;

   topics(idx) = strtrim(s{i}.Topic);
   openaccess(idx) = s{i}.OpenAccess;
end


% counting values
ncodes = numel(find(hascode==1));
npapers = numel(hascode);
narxiv = numel(find(isarxiv==1));
nopenaccess = numel(find(openaccess==1));
nunspeclicence = numel(intersect(find(hascode==1), find(haslicence==0)));
nodoc = numel(intersect(find(hascode==1),find(hasdoc==0)));

nsoftissues = numel(find(sofwareissues==1));
nhardissues = numel(find(missinghardware==1));

nsourcecode = numel(intersect(find(hascode==1), find(sourcecode==1)));
nbinary = numel(intersect(find(hascode==1), find(sourcecode==0)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Stats about code frequency per year         %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
npapers2014=numel(find(year==2014));
npapers2016=numel(find(year==2016));
npapers2018=numel(find(year==2018));
ncodes2014=sum(hascode(find(year==2014)));
ncodes2016=sum(hascode(find(year==2016)));
ncodes2018=sum(hascode(find(year==2018)));
fcodes2014 = ncodes2014 / npapers2014 *100;
fcodes2016 = ncodes2016 / npapers2016 *100;
fcodes2018 = ncodes2018 / npapers2018 *100;
ncodesdeep=sum(hascode(find(deep==1)));
ncodesnodeep=sum(hascode(find(deep==0)));
npapersdeep=numel(find(deep==1));
npapersnotdeep=numel(find(deep==0));
fcodesdeep=sum(hascode(find(deep==1)))/npapersdeep*100.;
fcodesnodeep=sum(hascode(find(deep==0)))/npapersnotdeep*100.;

% chi squared tests to check if the proportions are significantly different
pcodes1416 = chi2test(ncodes2014, npapers2014, ncodes2016, npapers2016);
pcodes1618 = chi2test(ncodes2016, npapers2016, ncodes2018, npapers2018);
pcodes1418 = chi2test(ncodes2014, npapers2014, ncodes2018, npapers2018);

% binofit fits a binomial model to these binary datas to get confidence intervals
[centercodesYear, CIcodesYear] = binofit([ncodes2018, ncodes2016, ncodes2014], [npapers2018 npapers2016 npapers2014], alpha)

% plot figure 
figure(1);
hold on;
line([CIcodesYear(1, 1) CIcodesYear(1, 2)]*100, [3 3], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesYear(2, 1) CIcodesYear(2, 2)]*100, [2 2], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesYear(3, 1) CIcodesYear(3, 2)]*100, [1 1], 'LineWidth', 3, 'Color', linecolor);
plot(centercodesYear*100, [3 2 1], '.', 'MarkerSize',30,'Color', circcolor);
plot(centercodesYear*100, [3 2 1], '-','LineWidth', 1, 'Color', circcolor);
line([CIcodesYear(1, 1) CIcodesYear(1, 1)]*100, [3-0.1 3+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesYear(1, 2) CIcodesYear(1, 2)]*100, [3-0.1 3+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesYear(2, 1) CIcodesYear(2, 1)]*100, [2-0.1 2+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesYear(2, 2) CIcodesYear(2, 2)]*100, [2-0.1 2+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesYear(3, 1) CIcodesYear(3, 1)]*100, [1-0.1 1+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesYear(3, 2) CIcodesYear(3, 2)]*100, [1-0.1 1+0.1], 'LineWidth', 3, 'Color', linecolor);

ax=gca; ax.XGrid = 'on';
xlabel('Percentage of papers with code');
yticks([1 2 3]);
yticklabels(['2014'; '2016'; '2018']);
ylim([0.5, 3.5])
set(gca, 'FontSize', 20)
fig = gcf;
set(fig,'PaperSize',[5.6 4]);
set(fig, 'PaperPosition', [0 0 6 4.2]);
print('codesYear.pdf','-dpdf');


% number of codes we had to modify, time we took, etc.
nmodifiedcodes=sum(hascode(find(fixbugs<=5)));
nhardmodifiedcodes=sum(hascode(find(fixbugs<=2)));
nlongcodes=sum(hascode(find(time>=10)));

% are codes more available for deep learning papers ?
pcodesdeepn = chi2test(ncodesdeep, npapersdeep, ncodesnodeep, npapersnotdeep);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Stats about code frequency per topic        %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

npapersGeometry=numel(find(topics=='Geometry'));
npapersImage=numel(find(topics=='Image'));
npapersRendering=numel(find(topics=='Rendering'));
npapersAnimation=numel(find(topics=='Animation'));
npapersVirtualReality=numel(find(topics=='Virtual Reality'));
npapersFabrication=numel(find(topics=='Fabrication'));


ncodesGeometry=sum(hascode(find(topics=='Geometry')));
ncodesImage=sum(hascode(find(topics=='Image')));
ncodesRendering=sum(hascode(find(topics=='Rendering')));
ncodesAnimation=sum(hascode(find(topics=='Animation')));
ncodesVirtualReality=sum(hascode(find(topics=='Virtual Reality')));
ncodesFabrication=sum(hascode(find(topics=='Fabrication')));


fcodesGeometry = ncodesGeometry / npapersGeometry * 100
fcodesImage = ncodesImage / npapersImage * 100
fcodesRendering = ncodesRendering / npapersRendering * 100
fcodesAnimation = ncodesAnimation / npapersAnimation * 100
fcodesFabrication = ncodesFabrication / npapersFabrication * 100
fcodesVirtualReality = ncodesVirtualReality / npapersVirtualReality * 100

% binofit fits a binomial model to these binary datas to get confidence intervals
[centercodesTopic, CIcodesTopic] = binofit([ ncodesImage, ncodesGeometry, ncodesRendering, ...
     ncodesVirtualReality, ncodesAnimation, ncodesFabrication], ...
    [ npapersImage npapersGeometry npapersRendering  ...
    npapersVirtualReality npapersAnimation npapersFabrication ], alpha)

% display the result
figure(2);
hold on;
line([CIcodesTopic(1, 1) CIcodesTopic(1, 2)]*100, [6 6], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(2, 1) CIcodesTopic(2, 2)]*100, [5 5], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(3, 1) CIcodesTopic(3, 2)]*100, [4 4], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(4, 1) CIcodesTopic(4, 2)]*100, [3 3], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(5, 1) CIcodesTopic(5, 2)]*100, [2 2], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(6, 1) CIcodesTopic(6, 2)]*100, [1 1], 'LineWidth', 3, 'Color', linecolor);
plot(centercodesTopic*100, [6:-1:1], '.', 'MarkerSize',30,'Color', circcolor);
line([CIcodesTopic(1, 1) CIcodesTopic(1, 1)]*100, [6-0.1 6+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(1, 2) CIcodesTopic(1, 2)]*100, [6-0.1 6+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(2, 1) CIcodesTopic(2, 1)]*100, [5-0.1 5+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(2, 2) CIcodesTopic(2, 2)]*100, [5-0.1 5+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(3, 1) CIcodesTopic(3, 1)]*100, [4-0.1 4+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(3, 2) CIcodesTopic(3, 2)]*100, [4-0.1 4+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(4, 1) CIcodesTopic(4, 1)]*100, [3-0.1 3+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(4, 2) CIcodesTopic(4, 2)]*100, [3-0.1 3+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(5, 1) CIcodesTopic(5, 1)]*100, [2-0.1 2+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(5, 2) CIcodesTopic(5, 2)]*100, [2-0.1 2+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(6, 1) CIcodesTopic(6, 1)]*100, [1-0.1 1+0.1], 'LineWidth', 3, 'Color', linecolor);
line([CIcodesTopic(6, 2) CIcodesTopic(6, 2)]*100, [1-0.1 1+0.1], 'LineWidth', 3, 'Color', linecolor);
ax=gca; ax.XGrid = 'on';
xlabel('Percentage of papers with code');
yticks(1:6);
yticklabels(["Fabrication" ;   "Animation" ; "Virtual Reality"; "Rendering"  ; "Geometry"; "Image"]);
ylim([0.5, 6.5])
set(gca, 'FontSize', 20)
fig = gcf;
set(fig,'PaperSize',[5.8 4]);
set(fig, 'PaperPosition', [0 0 6 4.2]);
print('codesTopic.pdf','-dpdf');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Stats about citations w.r.t code sharing    %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% t-scores to get confidence intervals where the true mean lies
[citcode2014 cicitcode2014] = tscore(citations(intersect(find(hascode==1),find(year==2014))));
[citnocode2014 cicitnocode2014] = tscore(citations(intersect(find(hascode==0),find(year==2014))));
[citcode2016 cicitcode2016] = tscore(citations(intersect(find(hascode==1),find(year==2016))));
[citnocode2016 cicitnocode2016] = tscore(citations(intersect(find(hascode==0),find(year==2016))));
[citcode2018 cicitcode2018] = tscore(citations(intersect(find(hascode==1),find(year==2018))));
[citnocode2018 cicitnocode2018] = tscore(citations(intersect(find(hascode==0),find(year==2018))));

% Mann Whitney U test to check if citation medians are different
pcitcodenocode2014 = ranksum(citations(intersect(find(hascode==1), find(year==2014))), citations(intersect(find(hascode==0), find(year==2014))));


figure(3);
hold on;
line([cicitcode2018(1, 1) cicitcode2018(1, 2)], [3.05 3.05], 'LineWidth', 3, 'Color', lightcolors(1,:));
line([cicitnocode2018(1, 1) cicitnocode2018(1, 2)], [2.95 2.95], 'LineWidth', 3, 'Color', lightcolors(2,:));
line([cicitcode2016(1, 1) cicitcode2016(1, 2)], [2.05 2.05], 'LineWidth', 3, 'Color', lightcolors(1,:));
line([cicitnocode2016(1, 1) cicitnocode2016(1, 2)], [1.95 1.95], 'LineWidth', 3, 'Color', lightcolors(2,:));
line([cicitcode2014(1, 1) cicitcode2014(1, 2)], [1.05 1.05], 'LineWidth', 3, 'Color', lightcolors(1,:));
line([cicitnocode2014(1, 1) cicitnocode2014(1, 2)], [0.95 0.95], 'LineWidth', 3, 'Color', lightcolors(2,:));
yticklabels(['2014'; '2016'; '2018']);
yticks([1 2 3]);
ylabel('');
xlabel('Number of citations')
plot([ citcode2014 citcode2016 citcode2018], [1.05 2.05 3.05], '.', 'MarkerSize',30,'Color', colors(1,:));
plot([ citnocode2014 citnocode2016 citnocode2018], [0.95 1.95 2.95], '.','MarkerSize', 30, 'Color', colors(2,:));
legend(["Code or executable available"; "Code and executable unavailable"], 'Location', 'northeast', 'FontSize',11);

set(gca, 'FontSize', 11);
ax=gca; ax.XGrid = 'on';
fig = gcf;
set(fig,'PaperSize',[5.3 4]);
set(fig, 'PaperPosition', [-0.35 0 6 4.2]);
print('citesCode.pdf','-dpdf');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametric ANOVA to check influence of year          %  
% and reviewers only for papers with code we ran       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[previeweryear,t,stats] = anovan(repro(intersect(find(completetest==1), find(hascode==1))),{year(intersect(find(completetest==1), find(hascode==1))),reviewer(intersect(find(completetest==1), find(hascode==1)))},'varnames',{'Year','Reviewer'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametric ANOVA to check influence of year          %  
% topics and indus for all papers                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[panova,t,stats] = anovan(repro,{year, topics, authors},'varnames',{'Year', 'Topics','AuthorIndus'})


%%%%   Post-hoc stats about Industrial vs academic codes    
%%%%   because this is apparently a significant factor

npapersIndus=numel(find(authors==1));
ncodesIndus=sum(hascode(find(authors==1)));
fcodesIndus = ncodesIndus/npapersIndus*100;
npapersAcad=numel(find(authors==0));
ncodesAcad=sum(hascode(find(authors==0)));
fcodesAcad = ncodesAcad/npapersAcad*100;

% chi squared tests to check if the proportions are significantly different
pcodesIndus = chi2test(ncodesIndus, npapersIndus, ncodesAcad, npapersAcad);


% Benjamini & Hochberg false discovery rate correction for all p-values
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh([pcodes1416 pcodes1418 pcodes1618 pcodesIndus pcodesdeepn pcitcodenocode2014 previeweryear(1) previeweryear(2)]);

pcodes1416 = adj_p(1);
pcodes1418 = adj_p(2);
pcodes1618 = adj_p(3);
pcodesIndus = adj_p(4);
pcodesdeepn = adj_p(5);
pcitcodenocode2014 = adj_p(6);
previeweryear(1) = adj_p(7);
previeweryear(2) = adj_p(8);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

digits(2);
f = fopen('stats.txt','w');
fprintf(f, '\\newcommand{\\npapers}{%u}\n', npapers);
fprintf(f, '\\newcommand{\\ncodes}{%u}\n', ncodes);
fprintf(f, '\\newcommand{\\npapersIV}{%u}\n', npapers2014);
fprintf(f, '\\newcommand{\\npapersVI}{%u}\n', npapers2016);
fprintf(f, '\\newcommand{\\npapersVIII}{%u}\n', npapers2018);
fprintf(f, '\\newcommand{\\ncodesIV}{%u}\n', ncodes2014);
fprintf(f, '\\newcommand{\\ncodesVI}{%u}\n', ncodes2016);
fprintf(f, '\\newcommand{\\ncodesVIII}{%u}\n', ncodes2018);
fprintf(f, '\\newcommand{\\pccodesIV}{%.1f}\n', fcodes2014);
fprintf(f, '\\newcommand{\\pccodesVI}{%.1f}\n', fcodes2016);
fprintf(f, '\\newcommand{\\pccodesVIII}{%.1f}\n', fcodes2018);
fprintf(f, '\\newcommand{\\pcodesIVVI}{%s}\n', latex(sym(vpa(pcodes1416))));  % p values
fprintf(f, '\\newcommand{\\pcodesVIVIII}{%s}\n', latex(sym(vpa(pcodes1618))));
fprintf(f, '\\newcommand{\\pcodesIVVIII}{%s}\n', latex(sym(vpa(pcodes1418))));
fprintf(f, '\\newcommand{\\npapersacad}{%u}\n', npapersAcad);
fprintf(f, '\\newcommand{\\ncodesacad}{%u}\n', ncodesAcad);
fprintf(f, '\\newcommand{\\npapersindus}{%u}\n', npapersIndus);
fprintf(f, '\\newcommand{\\ncodesindus}{%u}\n', ncodesIndus);
fprintf(f, '\\newcommand{\\pccodesacad}{%.1f}\n', fcodesAcad);
fprintf(f, '\\newcommand{\\pccodesindus}{%.1f}\n', fcodesIndus);
fprintf(f, '\\newcommand{\\pcodesindus}{%.3f}\n', pcodesIndus);
fprintf(f, '\\newcommand{\\preplyear}{%.2f}\n', previeweryear(1));
fprintf(f, '\\newcommand{\\preplreviewer}{%.2f}\n', previeweryear(2));

fprintf(f, '\\newcommand{\\nmodifiedcodes}{%u}\n', nmodifiedcodes);
fprintf(f, '\\newcommand{\\nhardmodifiedcodes}{%u}\n', nhardmodifiedcodes);
fprintf(f, '\\newcommand{\\nlongcodes}{%u}\n', nlongcodes);

fprintf(f, '\\newcommand{\\ncodesdeep}{%u}\n', ncodesdeep);
fprintf(f, '\\newcommand{\\npapersdeep}{%u}\n', npapersdeep);
fprintf(f, '\\newcommand{\\ncodesnodeep}{%u}\n', ncodesnodeep);
fprintf(f, '\\newcommand{\\npapersnotdeep}{%u}\n', npapersnotdeep);
fprintf(f, '\\newcommand{\\fcodesdeep}{%.1f}\n', fcodesdeep);
fprintf(f, '\\newcommand{\\fcodesnodeep}{%.1f}\n', fcodesnodeep);
fprintf(f, '\\newcommand{\\pcodesdeepn}{%.2f}\n', pcodesdeepn);

fprintf(f, '\\newcommand{\\narxiv}{%u}\n', narxiv);
fprintf(f, '\\newcommand{\\nopenaccess}{%u}\n', nopenaccess);
fprintf(f, '\\newcommand{\\nsourcecode}{%u}\n', nsourcecode);
fprintf(f, '\\newcommand{\\nbinaries}{%u}\n', nbinary);

fprintf(f, '\\newcommand{\\citcodeIV}{%.2f}\n', citcode2014);
fprintf(f, '\\newcommand{\\citnocodeIV}{%.2f}\n', citnocode2014);
fprintf(f, '\\newcommand{\\pcitcodenocodeIV}{%s}\n', latex(sym(vpa(pcitcodenocode2014))));

fprintf(f, '\\newcommand{\\nhardissues}{%u}\n', nhardissues);
fprintf(f, '\\newcommand{\\nsoftissues}{%u}\n', nsoftissues);
fprintf(f, '\\newcommand{\\nunspeclicence}{%u}\n', nunspeclicence);
fprintf(f, '\\newcommand{\\nodoc}{%u}\n', nodoc);

%%%% For Table 1
fprintf(f, '\\newcommand{\\pythonIV}{%u}\n', numel(intersect(find(haspython==1), find(year==2014))));
fprintf(f, '\\newcommand{\\pythonVI}{%u}\n', numel(intersect(find(haspython==1), find(year==2016))));
fprintf(f, '\\newcommand{\\pythonVIII}{%u}\n', numel(intersect(find(haspython==1), find(year==2018))));
fprintf(f, '\\newcommand{\\pythonTot}{%u}\n', numel(find(haspython==1)));

fprintf(f, '\\newcommand{\\matlabIV}{%u}\n', numel(intersect(find(hasmatlab==1), find(year==2014))));
fprintf(f, '\\newcommand{\\matlabVI}{%u}\n', numel(intersect(find(hasmatlab==1), find(year==2016))));
fprintf(f, '\\newcommand{\\matlabVIII}{%u}\n', numel(intersect(find(hasmatlab==1), find(year==2018))));
fprintf(f, '\\newcommand{\\matlabTot}{%u}\n', numel(find(hasmatlab==1)));

fprintf(f, '\\newcommand{\\cIV}{%u}\n', numel(intersect(find(hasc==1), find(year==2014))));
fprintf(f, '\\newcommand{\\cVI}{%u}\n', numel(intersect(find(hasc==1), find(year==2016))));
fprintf(f, '\\newcommand{\\cVIII}{%u}\n', numel(intersect(find(hasc==1), find(year==2018))));
fprintf(f, '\\newcommand{\\cTot}{%u}\n', numel(find(hasc==1)));

fprintf(f, '\\newcommand{\\doczeroIV}{%u}\n', numel(intersect(find(hascode==1),intersect(find(docscorezero==1), find(year==2014)))));
fprintf(f, '\\newcommand{\\doczeroVI}{%u}\n', numel(intersect(find(hascode==1),intersect(find(docscorezero==1), find(year==2016)))));
fprintf(f, '\\newcommand{\\doczeroVIII}{%u}\n', numel(intersect(find(hascode==1),intersect(find(docscorezero==1), find(year==2018)))));
fprintf(f, '\\newcommand{\\doczeroTot}{%u}\n', numel(intersect(find(hascode==1), find(docscorezero==1))));

fprintf(f, '\\newcommand{\\deepIV}{%u}\n', numel(intersect(find(hascode==1),intersect(find(deep==1), find(year==2014)))));
fprintf(f, '\\newcommand{\\deepVI}{%u}\n', numel(intersect(find(hascode==1),intersect(find(deep==1), find(year==2016)))));
fprintf(f, '\\newcommand{\\deepVIII}{%u}\n', numel(intersect(find(hascode==1),intersect(find(deep==1), find(year==2018)))));
fprintf(f, '\\newcommand{\\deepTot}{%u}\n', numel(intersect(find(hascode==1),find(deep==1))));

fprintf(f, '\\newcommand{\\nolicIV}{%u}\n', numel(intersect(find(hascode==1),intersect(find(haslicence==0), find(year==2014)))));
fprintf(f, '\\newcommand{\\nolicVI}{%u}\n', numel(intersect(find(hascode==1),intersect(find(haslicence==0), find(year==2016)))));
fprintf(f, '\\newcommand{\\nolicVIII}{%u}\n', numel(intersect(find(hascode==1),intersect(find(haslicence==0), find(year==2018)))));
fprintf(f, '\\newcommand{\\nolicTot}{%u}\n', numel(intersect(find(hascode==1),find(haslicence==0))));


fprintf(f, '\\newcommand{\\dataIV}{%u}\n', numel(intersect(find(hascode==1),intersect(find(hasdata==1), find(year==2014)))));
fprintf(f, '\\newcommand{\\dataVI}{%u}\n', numel(intersect(find(hascode==1),intersect(find(hasdata==1), find(year==2016)))));
fprintf(f, '\\newcommand{\\dataVIII}{%u}\n', numel(intersect(find(hascode==1),intersect(find(hasdata==1), find(year==2018)))));
fprintf(f, '\\newcommand{\\dataTot}{%u}\n', numel(intersect(find(hascode==1),find(hasdata==1))));
fclose(f);

