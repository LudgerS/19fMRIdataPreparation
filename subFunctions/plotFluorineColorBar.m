function [] = plotFluorineColorBar(cMap, figFile, Max, yLabel)
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin
%
% License: GNU GPLv3 

set(0,'DefaultFigureVisible','off');

fig1=figure;

colormap(cMap)
axis off

c = colorbar('Units','Normalized','Position',[0.65 0.1 0.28 0.8]);

set(c, 'YAxisLocation','left','FontSize',60,'TickDir','out','LineWidth',6)
yl = ylabel(c,yLabel,'FontWeight','normal');


yTicksIm = autoTickMarks(0,Max);

yTicksReal = yTicksIm*1/Max;

set(c,'Ticks',yTicksReal)
yTickCells = cellfun(@(str) num2str(str, '%.1f'), num2cell(yTicksIm), 'uniformOutput', false);


set(c,'TickLabels',yTickCells)
set(c,'TickLength',0.03)

set(yl,'Units','Normalized')
position = get(yl,'position');
set(yl,'position',position-[0.4,0,0])

set(fig1,'position',[0 0, 440 1100]) 
set(fig1,'PaperPositionMode','Auto') 


print([figFile, '.png'],'-dpng')


set(0,'DefaultFigureVisible','on');

close(fig1)