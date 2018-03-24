
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%by lvcheng 6/13/2015
%%% plot zeta05_
%be careful with the difference between uv and zeta05_
%uv in the central of grid
%zeta05_t w in the node
% time05_ match other vars


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% from the OBC to the river to see how the computation transported
close all
clear all
clc

%% read zeta05_ loop

% addpath('/Users/lvcheng/Desktop/HZB/DATA_result/hzb');

addpath('/Volumes/SHAOMING/ZJU/HZB/DATA_result/mshao_chj/netcdf');

for i = 1:9
    chncname=sprintf('chj_000%d.nc',i);
    file=chncname;
     zeta05_{i}  = ncread(file,'zeta');
    time05_{i}  = ncread(file,'time');
end 

for i = 10:79
    chncname=sprintf('chj_00%d.nc',i);
    file=chncname;
    zeta05_{i}  = ncread(file,'zeta'); 
    time05_{i}  = ncread(file,'time');
end


for i = 700:749
    chncname=sprintf('chj_0%d.nc',i);
    file=chncname;
    zeta05_{i}  = ncread(file,'zeta');
    time05_{i}  = ncread(file,'time');
    
end


%% zhapu verify with the T5 

figure(1)

zeta05_08_32310_neap=zeta05_{705}(32310,:);
for i = 706:741
zeta05_08_32310_neap=[zeta05_08_32310_neap,zeta05_{i}(32310,:)];
end 

figure
plot(zeta05_08_32310_neap(1:10:end),'k-*','LineWidth',2);
hold on 
plot(HZB_0508_neap_t5_zhapu(:,2),'ro','MarkerSize',10)
hold off

title('T5 Zhapu neap','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('Augest 2005','FontSize',24,'FontWeight','bold','Color','k')

set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[28.25 28.50 28.75 29.00 29.25 29.50 29.75 ],'FontSize',22)
grid
legend('Model','Measurement') 
set(gca,'FontSize',22,'FontName','Cambira')


%% jinshan

zeta05_08_31828_neap=zeta05_{705}(31828,:);
for i = 706:741
zeta05_08_31828_neap=[zeta05_08_31828_neap,zeta05_{i}(31828,:)];
end 

figure
plot(zeta05_08_31828_neap(1:10:end),'k-*','LineWidth',2);
hold on 
plot(HZB_0508_neap_t6_jinshan(:,2),'ro','MarkerSize',10)
hold off

title('T6 Jinshan neap','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('Augest 2005','FontSize',24,'FontWeight','bold','Color','k')
set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[28.25 28.50 28.75 29.00 29.25 29.50 29.75 ],'FontSize',22)
grid
legend('Model','Measurement') 
set(gca,'FontSize',22,'FontName','Cambira')


%% T4 ganpu

zeta05_08_32478_neap=zeta05_{705}(32478,:);
for i = 706:741
zeta05_08_32478_neap=[zeta05_08_32478_neap,zeta05_{i}(32478,:)];
end 

figure

plot(zeta05_08_32478_neap(1:10:end),'k-*','LineWidth',2);
hold on 
plot(HZB_0508_neap_t4_ganpu(:,2),'ro','MarkerSize',10)
hold off
title('T4 Ganpu neap','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('Augest 2005','FontSize',24,'FontWeight','bold','Color','k')
set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[28.25 28.50 28.75 29.00 29.25 29.50 29.75 ],'FontSize',22)
grid
legend('Model','Measurement') 
set(gca,'FontSize',22,'FontName','Cambira')


%% T3  Caoejiang

zeta05_08_32556_neap=zeta05_{707}(32556,:);

for i = 708:743
   
    zeta05_08_32556_neap=[zeta05_08_32556_neap,zeta05_{i}(32556,:)];
    
end 

figure

plot(zeta05_08_32556_neap(1:10:end),'k-*','LineWidth',2);
hold on 
plot(HZB_0508_neap_t3_caoejiang(:,2),'ro','MarkerSize',10)
hold off

title('T3 Caoejiang neap','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('Augest 2005','FontSize',24,'FontWeight','bold','Color','k')
set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[28.25 28.50 28.75 29.00 29.25 29.50 29.75 ],'FontSize',22)
grid
legend('Model','Measurement') 
set(gca,'FontSize',22,'FontName','Cambira')


%% Yanguan

zeta05_08_32568_neap=zeta05_{705}(32568,:);
for i = 706:741
zeta05_08_32568_neap=[zeta05_08_32568_neap,zeta05_{i}(32568,:)];
end 

figure

plot(zeta05_08_32568_neap(1:10:end),'k-*','LineWidth',2);
hold on 
plot(HZB_0508_neap_t2_caoejiang(:,2),'ro','MarkerSize',10)
hold off
title('T2 Yanguan neap','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('Augest 2005','FontSize',24,'FontWeight','bold','Color','k')
set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[28.25 28.50 28.75 29.00 29.25 29.50 29.75 ],'FontSize',22)
grid
legend('Model','Measurement') 
set(gca,'FontSize',22,'FontName','Cambira')

%% put together
 plot(zeta05_08_32478_neap(1:10:end),'r-o','LineWidth',2)
hold  on 
plot(zeta05_08_31828_neap(1:10:end),'m-o','LineWidth',2);
plot(zeta05_08_32310_neap(1:10:end),'k-o','LineWidth',2);
plot(zeta05_08_32556_neap(1:10:end),'b-o','LineWidth',2);
plot(zeta05_08_32568_neap(1:9:end),'g-o','LineWidth',2)
hold off

title('ALL~~CHJ0508--01','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
set(gca,'FontSize',16,'FontName','Cambira')
grid
legend('Zhapu','Jinshan','Ganpu','Caoejiang','Yanguan')

