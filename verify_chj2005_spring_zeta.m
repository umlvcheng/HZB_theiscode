
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%by lvcheng 6/13/2015
%%% plot zeta2005
%be careful with the difference between uv and zeta2005
%uv in the central of grid
%zeta2005t w in the node
% time05_ match other vars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% from the OBC to the river to see how the computation transported
close all
clear all
clc

%% read zeta2005 loop

% addpath('/Users/lvcheng/Desktop/HZB/DATA_result/hzb');

%addpath('/Volumes/SHAOMING/ZJU/HZB/DATA_result/mshao_chj/output2005/netcdf');

addpath('I:\ZJU\output2005\netcdf');


for i = 1:9
    chncname=sprintf('chj_000%d.nc',i);
    file=chncname;
     zeta2005{i}  = ncread(file,'zeta');
    time05_{i}  = ncread(file,'time');
end 

for i = 10:99
    chncname=sprintf('chj_00%d.nc',i);
    file=chncname;
    zeta2005{i}  = ncread(file,'zeta'); 
    time05_{i}  = ncread(file,'time');
end


for i = 290:300
  
    chncname=sprintf('chj_0%d.nc',i);
    file=chncname;
    zeta2005{i}  = ncread(file,'zeta');
    time05_{i}  = ncread(file,'time');
    
end

%% jinshan

   zeta200508_611=zeta2005{280}(611,:);

for i = 281:330
    zeta200508_611 = [zeta200508_611,zeta2005{i}(611,:)];    
end 

subplot 221

plot(zeta200508_611(145:505),'k-','LineWidth',2);
hold on 
plot(1:10:361,HZB_0508_T6_spring(:,2),'ro','MarkerSize',10)
hold off

title('Jinshan','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('August 2005','FontSize',24,'FontWeight','bold','Color','k')
set(gca,'xtick',[10 70 130 190 250 310 370],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25 22.50 22.75 ],'FontSize',22)
grid
legend('Mod','Obs') 
set(gca,'FontSize',22,'FontName','Cambira')


%% zhapu verify with the T5 

figure(1)

subplot 222

zeta200508_459=zeta2005{280}(459,:);
for i = 281:330
zeta200508_459=[zeta200508_459,zeta2005{i}(459,:)];
end 

plot(zeta200508_459(145:505),'k-','LineWidth',2);
hold on 
plot(1:10:361,HZB_0508_T5_spring(:,2),'ro','MarkerSize',10)
hold off

title('Zhapu','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('August 2005','FontSize',24,'FontWeight','bold','Color','k')

set(gca,'xtick',[10 70 130 190 250 310 370],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25 22.50 22.75 ],'FontSize',22)
grid
legend('Mod','Obs') 
set(gca,'FontSize',22,'FontName','Cambira')




%% T4 ganpu

zeta200508_276=zeta2005{280}(276,:);
for i = 281:330
zeta200508_276=[zeta200508_276,zeta2005{i}(276,:)];
end 

subplot 223
% figure

plot(zeta200508_276(150:510)-0.2,'k-','LineWidth',2);
hold on 
plot(1:10:361,HZB_0508_T4_spring(:,2),'ro','MarkerSize',10)
hold off

title('Ganpu','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('August 2005','FontSize',24,'FontWeight','bold','Color','k')
set(gca,'xtick',[10 70 130 190 250 310 370],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25 22.50 22.75 ],'FontSize',22)
grid
legend('Mod','Obs') 
set(gca,'FontSize',22,'FontName','Cambira')


%%  Caoejiang


% zeta200508_191=zeta2005{280}(191,:);
% for i = 281:330
% zeta200508_191=[zeta200508_191,zeta2005{i}(191,:)];
% end 
% 
% % figure
% 
% plot(zeta200508_191(1:10:end),'k-*','LineWidth',2);
% hold on 
% plot(Data003(:,2),'ro','MarkerSize',10)
% hold off
% title('T3 Caoejiang','FontSize',24,'FontWeight','bold','Color','k')
% ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
% xlabel('August 2005','FontSize',24,'FontWeight','bold','Color','k')
% set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[21.25 21.50 21.75 22.00 22.25 22.50 22.75 ],'FontSize',22)
% grid
% legend('Mod','Obs') 
% set(gca,'FontSize',22,'FontName','Cambira')


%% Yanguan



zeta200508_88=zeta2005{280}(88,:);
for i = 281:330 
zeta200508_88=[zeta200508_88,zeta2005{i}(88,:)];
end 

subplot 224
plot(zeta200508_88(150:510)+2.9,'k-','LineWidth',2);
hold on 
plot(1:10:361,HZB_0508_T2_spring(:,2),'ro','MarkerSize',10)
hold off
title('Yanguan','FontSize',24,'FontWeight','bold','Color','k')
ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
xlabel('August 2005','FontSize',24,'FontWeight','bold','Color','k')
set(gca,'xtick',[10 70 130 190 250 310 370],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25 22.50 22.75 ],'FontSize',22)
grid
legend('Mod','Obs') 
set(gca,'FontSize',22,'FontName','Cambira')

%% put together
%  plot(zeta200508_276(1:10:end),'r-o','LineWidth',2)
% hold  on 
% plot(zeta200508_611(1:10:end),'m-o','LineWidth',2);
% plot(zeta200508_459(1:10:end),'k-o','LineWidth',2);
% plot(zeta200508_191(1:10:end),'b-o','LineWidth',2);
% plot(zeta200508_88(1:9:end),'g-o','LineWidth',2)
% hold off
% 
% title('ALL~~CHJ0508--01','FontSize',24,'FontWeight','bold','Color','k')
% ylabel('Water level [ m]','FontSize',24,'FontWeight','bold','Color','k')
% set(gca,'FontSize',16,'FontName','Cambira')
% grid
% legend('Zhapu','Jinshan','Ganpu','Caoejiang','Yanguan')

