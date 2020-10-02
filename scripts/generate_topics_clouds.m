fname = 'topics.json';
rawjson = jsondecode(fileread(fname));

names = fieldnames(rawjson) ;

for i=1:length(names)
   figure
   cat = categorical(rawjson.(names{i}))
   cat = [cat;cat] %avoid very small fonts for under-represented topics
   
   wc = wordcloud(cat, 'HighlightColor', [0 0.4470 0.7410], 'SizePower', 0.001);
      
   set(gcf,'Units','inches');
   screenposition = get(gcf,'Position');
   set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);

   saveas(gcf,names{i}+".pdf")
end
