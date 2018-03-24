
% Compare Delft3D simulation with observations from the 10-day 
% intensive field effort at Hobie Beach, Miami, June 1-11, 2010
% model results are in UTC
% obsrevation dataset include: 
% Tide at Viginia Key (Mean Sea Level, 6-min)
% Tide at Hobie Beach
clear all
close all
clc
cd 'D:\Model_simulations\delft3d\Biscayne\Hobie201006nest'

% % knee-deep and waist-deep enterococci level
% load '10-day ENT level.txt'
% ENT=X10_day_ENT_level;
% time_ENT=datenum(2010,ENT(:,1),ENT(:,2),ENT(:,3)+4,0,0); % local time to UTC
% load '10-day waist-deep ENT level.txt'
% waist=X10_day_waist_deep_ENT_level;
% time_waist=datenum(2010,6,waist(:,3),waist(:,4)+4,0,0);
% 
% % ENT in the sand CFU/g
% load '10-day ENT sand.txt'
% ENTS=X10_day_ENT_sand;
% time_ENTS=datenum(2010,ENTS(:,1),ENTS(:,2),ENTS(:,3)+4,0,0);
% ENT_sand=round(ENTS(:,4));

% tide 
load '10-day VK tide.txt';  % NOAA Virginia Key station
tide=X10_day_VK_tide;
time_tide_NOAA = datenum(tide(:,2),tide(:,3),tide(:,4),tide(:,5),tide(:,6),0); % UTC
tide_NOAA = tide(:,8);

load '10-day tide.txt';  % TWR pressure sensor
tid = X10_day_tide;    
time_tide_TWR = datenum(2010,6,tid(:,3),tid(:,4)+4,tid(:,5),tid(:,6));
tide_TWR = tid(:,9) - 2.25;

% load model result
load 'NOAA_VK_tide_10_day.mat'
time_model_NOAA = data.Time;
tide_model_NOAA = data.Val;

load 'beach_tide_10_day.mat'
time_model_TWR = data.Time;
tide_model_TWR = data.Val;


%% calculate cross correlation coefficients
tide_model_NOAA_interp = interp1(time_model_NOAA,tide_model_NOAA,time_tide_NOAA);
tide_model_TWR_interp = interp1(time_model_TWR,tide_model_TWR,time_tide_TWR);

[R1,P1,RLO1,RUP1] = corrcoef(tide_NOAA(1:2400),tide_model_NOAA_interp(1:2400))
[R2,P2,RLO2,RUP2] = corrcoef(tide_TWR(1:25000),tide_model_TWR_interp(1:25000))


%% Tidal analysis (T_tide)

time_ttide = datenum(2010,6,1,0,0,0): 6/60/24 : datenum(2010,6,11,22,0,0);  % choose a unit time for all time series and interplation
model_start = datenum(2010,6,1);

[tidestruc0,pout0] = t_tide(interp1(time_model_NOAA,tide_model_NOAA,time_ttide),...
                    'interval' , 1/60, ...
                    'start' , model_start, ...
                    'latitude' , 25.73,  ...
                    'error' , 'wboot', ...
                    'rayleigh' , 0.5, ...
                    'synthesis' , 2);
                
[tidestruc1,pout1] = t_tide(interp1(time_tide_NOAA,tide_NOAA,time_ttide),...
                    'interval' , 1/60, ...
                    'start' , model_start, ...
                    'latitude' , 25.73,  ...
                    'error' , 'wboot', ...
                    'rayleigh' , 0.5, ...
                    'synthesis' , 2); 
                
[tidestruc2,pout2] = t_tide(interp1(time_model_TWR,tide_model_TWR,time_ttide),...
                    'interval' , 1/60, ...
                    'start' , model_start, ...
                    'latitude' , 25.73,  ...
                    'error' , 'wboot', ...
                    'rayleigh' , 0.5, ...
                    'synthesis' , 2);     
                
[tidestruc3,pout3] = t_tide(interp1(time_tide_TWR,tide_TWR,time_ttide),...
                    'interval' , 1/60, ...
                    'start' , model_start, ...
                    'latitude' , 25.73,  ...
                    'error' , 'wboot', ...
                    'rayleigh' , 0.5, ...
                    'synthesis' , 2);
                
%%
figure(1)
subplot(2,1,1)
 plot(time_tide_NOAA,tide_NOAA,'lineWidth',2);
 hold on
 plot(time_model_NOAA,tide_model_NOAA,'r--','lineWidth',2)
 set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
     datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
     datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)],'fontsize',12);
 set(gca,'Ytick',[-0.5,-0.25,0,0.25,0.5],'fontsize',12);
 datetick('x',6,'keepticks');
 axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),-0.6,0.6])
 title('Tide at NOAA Virginia Key station','FontSize',14)
 legend('observation','model')
 ylabel('tide level (m)','FontSize',12)
 grid on
 
 
 
 
subplot(2,1,2)
 plot(time_tide_TWR,tide_TWR,'lineWidth',2);
 hold on
 plot(time_model_TWR,tide_model_TWR,'r--','lineWidth',2)

 
 set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
     datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
     datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)],'fontsize',12);
 set(gca,'Ytick',[-0.04,-0.02,0,0.02,0.04],'fontsize',12);
 datetick('x',6,'keepticks');
%  legend('observation','model')
 axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),-0.04,0.04])
 
 title('Tide measured by TWR sensor','FontSize',14)
 xlabel('Time (UTC)','FontSize',14)
 ylabel('tide level (m)','FontSize',12)
 grid on

% %% plot all figures together
% figure(1)
% subplot(5,1,1)
%  semilogy(time_ENT,ENT(:,4),'*-','lineWidth',2)
%  hold on
%  semilogy(time_waist,waist(:,5),'r--^','lineWidth',2)
%  hold off
%  legend('knee-deep','waist-deep','Location','Southeast');
%  set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
%      datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
%      datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
%  set(gca,'Ytick',[0,1,10,100,1000,10000]);
%  datetick('x',6,'keepticks');
%  axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),1,10000])
%  title('Enterococci level in the sea water at Hobie Beach','FontSize',14)
%  ylabel('ENT (CFU/100 mL)','FontSize',12)
%  grid on
% subplot(5,1,2)
%  semilogy(time_ENT,ENT_sand,'*-','lineWidth',2)
%  set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
%      datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
%      datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
%  set(gca,'Ytick',[0,1,10,100,300]);
%  datetick('x',6,'keepticks');
%  axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),1,1000])
%  title('Enterococci level in the sand at Hobie Beach','FontSize',14)
%  ylabel('ENT (CFU/g)','FontSize',12)
%  grid on 
% subplot(5,1,3)
%  plot(time_tide,tide(:,8),'lineWidth',2);
%  set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
%      datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
%      datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
%  set(gca,'Ytick',[-0.5,-0.25,0,0.25,0.5]);
%  datetick('x',6,'keepticks');
%  axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),-0.5,0.5])
%  title('Tide at NOAA Virginia Key station','FontSize',14)
%  ylabel('tide level (m)','FontSize',12)
%  grid on
% subplot(5,1,4)
%  plot(time_wave,wave(:,9),'lineWidth',2);
%  set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
%      datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
%      datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
%  set(gca,'Ytick',[0,0.1,0.2,0.3]);
%  datetick('x',6,'keepticks');
%  axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),0,0.3])
%  title('Significant wave height','FontSize',14)
%  ylabel('Wave Height (m)')
%  grid on
% subplot(5,1,5)
%  plot(time_weather,rad,'lineWidth',1);
%  set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
%      datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
%      datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
%  set(gca,'Ytick',[0,400,800,1200]);
%  datetick('x',6,'keepticks');
%  axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),0,1210])
%  title('Solar radiation','FontSize',14)
%  ylabel('radiation (W/m^2)','FontSize',12)
%  grid on
% %subplot(5,1,5)
% % plot(time_weather,rain,'lineWidth',1);
% % set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
% %     datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
% %     datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
% % set(gca,'Ytick',[0,10,20,30,40]);
% % datetick('x',6,'keepticks');
% % axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),0,40])
% % title('Rain rate','FontSize',14)
% % ylabel('Rain rate (mm/h)','FontSize',12) 
%  xlabel('Time/UTC','FontSize',14) 
% % grid on


% %% plot ENT level in sand, distance, and tide
% subplot(3,1,1)
%  semilogy(time_ENT,ENT_sand,'*-','lineWidth',2)
%  set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
%      datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
%      datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
%  set(gca,'Ytick',[0,1,10,100,200,300]);
%  datetick('x',6,'keepticks');
%  axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),1,300])
%  title('Enterococci level in the sand at Hobie Beach','FontSize',14)
%  ylabel('ENT (CFU/g)','FontSize',12)
%  grid on 
% subplot(3,1,2)
%  plot(time_dis,Dist,'o-','lineWidth',2)
%  set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
%      datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
%      datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
%  set(gca,'Ytick',[0,10,20,30,40,50,60]);
%  datetick('x',6,'keepticks');
%  axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),1,60])
%  title('Distance from knee-deep site to poles','FontSize',14)
%  ylabel('m','FontSize',12)
%  grid on 
% subplot(3,1,3)
%  plot(time_tide,tide(:,8),'lineWidth',2);
%  set(gca,'Xtick',[datenum(2010,6,1),datenum(2010,6,2),datenum(2010,6,3),...
%      datenum(2010,6,4),datenum(2010,6,5),datenum(2010,6,6),datenum(2010,6,7),...
%      datenum(2010,6,8),datenum(2010,6,9),datenum(2010,6,10),datenum(2010,6,11)]);
%  set(gca,'Ytick',[-0.5,-0.25,0,0.25,0.5]);
%  datetick('x',6,'keepticks');
%  axis([datenum(2010,6,1,0,0,0),datenum(2010,6,11,23,0,0),-0.5,0.5])
%  title('Tide at NOAA Virginia Key station','FontSize',14)
%  ylabel('tide level (m)','FontSize',12)
%  xlabel('Time/UTC','FontSize',14) 
%  grid on
 



 