
%% uv compare
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%by lvcheng 6/13/2015
% verify current data


%% date 050731--050902   

addpath('/Volumes/SHAOMING/ZJU/HZB/DATA_result/mshao_chj/output2005/netcdf');

for i = 1:9
    chncname=sprintf('chj_000%d.nc',i);
    file=chncname;
    vv_0508{i}  = ncread(file,'v');     
    uu_0508{i}  = ncread(file,'u');  
end

for i = 10:99
    chncname=sprintf('chj_00%d.nc',i);
    file=chncname;
    vv_0508{i}  = ncread(file,'v');     
    uu_0508{i}  = ncread(file,'u');  
end

for i = 351:551
    chncname=sprintf('chj_0%d.nc',i);
    file=chncname;
     vv_0508{i} = ncread(file,'v');     
     uu_0508{i} = ncread(file,'u');  
end

disp('## read complete ##')

 
%% verify plot differert stataion velcoity  

% H1  depth average

% get V
  vv0508_H1_587_01 = mean(vv_0508{280}(587,1:6,1:10));
    
for i = 281:350
    vv0508_H1_587_01 = [vv0508_H1_587_01,mean(vv_0508{i}(587,1:6,1:10))];
end 
    vv0508_H1_587_01 = squeeze(vv0508_H1_587_01); 
    vv0508_H1_587_01_full = reshape(vv0508_H1_587_01',1,710);
    
% get U
    uu0508_H1_587_01 = mean(uu_0508{280}(587,1:6,1:10));
for i = 281:350
    uu0508_H1_587_01 = [uu0508_H1_587_01,mean(uu_0508{i}(587,1:6,1:10))];
end 
    uu0508_H1_587_01 = squeeze(uu0508_H1_587_01);
    uu0508_H1_587_01_full = reshape(uu0508_H1_587_01',1,710);
% get UV
    uv0508_H1_587_01 = sqrt(vv0508_H1_587_01.^2+uu0508_H1_587_01.^2);
    uv0508_H1_587_01_full = vv0508_H1_587_01_full.^2 + uu0508_H1_587_01_full.^2 ;
    
   uv0508_H1_587_01_full_nptive = uv0508_H1_587_01_full(150:450);
   uv0508_H1_587_01_full_nptive(41:91)=uv0508_H1_587_01_full_nptive(41:91)*(-1);
   uv0508_H1_587_01_full_nptive(162:213)=uv0508_H1_587_01_full_nptive(162:213)*(-1);
   uv0508_H1_587_01_full_nptive(286:end)=uv0508_H1_587_01_full_nptive(286:end)*(-1);
%    plot(tryh2(150:450),'k.');
figure
subplot 221
   plot(uv0508_H1_587_01_full_nptive,'k-');
   hold on
   plot(1:10:281, Data002(:,2),'mo','MarkerSize',15);
   hold off
   
   legend('Mod','Obs')
   grid
   title('H1 depth-average','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('Current Velocity [ m/s]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
%    set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[21.25 21.50 21.75 22.00 22.25 22.50 22.75 ],'FontSize',22)
      set(gca,'xtick',[10 70 130 190 250],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22) 
set(gca,'FontSize',30,'FontName','Cambria')
  
%%%%%%% get current direction 

 [a , ~] = size(vv0508_H1_587_01); 
for i =  1:a;
    if       vv0508_H1_587_01(i,1) >= 0 && uu0508_H1_587_01(i,1) >= 0 %1st 
              theta_0508_H1_587_01(i,1) = 90-atan(vv0508_H1_587_01(i,1)/uu0508_H1_587_01(i,1))*180/pi;
     elseif  vv0508_H1_587_01(i,1) < 0 && uu0508_H1_587_01(i,1) >= 0  %4th
            theta_0508_H1_587_01(i,1) = -atan(vv0508_H1_587_01(i,1)/uu0508_H1_587_01(i,1))*180/pi+90; 
     elseif  vv0508_H1_587_01(i,1) < 0 && uu0508_H1_587_01(i,1) < 0   % 3rd
            theta_0508_H1_587_01(i,1) = atan(vv0508_H1_587_01(i,1)/uu0508_H1_587_01(i,1))*180/pi+180; 
     elseif  vv0508_H1_587_01(i,1) >= 0 && uu0508_H1_587_01(i,1) < 0  %2nd
            theta_0508_H1_587_01(i,1) = -atan(vv0508_H1_587_01(i,1)/uu0508_H1_587_01(i,1))*180/pi+270; 
    end
end

 figure
%   plot(theta_0508_H1_587_01,'ko-','MarkerSize',12,'MarkerFaceColor','m')
subplot 221
    plot(theta_0508_H1_587_01(5:35),'k-','MarkerSize',12,'MarkerFaceColor','m')
    hold on 
    plot(HZB_0508_h1_dir(:,2),'mo','MarkerSize',12,'MarkerFaceColor','m');
    hold off
    
    title('H1 station','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('Current Dir [ degree]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
   axis([1 38 0 360 ])
      set(gca,'xtick',[1 7 13 19 25],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)
   grid
   set(gca,'FontSize',30,'FontName','Cambria')
   
%% H2 depth average

%  get V
    vv0508_H2_516_2005 = mean(vv_0508{280}(516,1:6,1:10));
for i = 281:350
    vv0508_H2_516_2005 = [vv0508_H2_516_2005,mean(vv_0508{i}(516,1:6,1:10))];
end 
    vv0508_H2_516_2005 = squeeze(vv0508_H2_516_2005);
    vv0508_H2_516_01_2005_full = reshape(vv0508_H2_516_2005',1,710);
% get U
    uu0508_H2_516_2005 = mean(uu_0508{280}(516,1:6,1:10));
for i = 281:350
    uu0508_H2_516_2005 = [uu0508_H2_516_2005,mean(uu_0508{i}(516,1:6,1:10))];
end 

uu0508_H2_516_2005 = squeeze(uu0508_H2_516_2005);
uu0508_H2_516_2005_full = reshape(uu0508_H2_516_2005',1,710);
%  get UV
% uv0508_H2_516_full = sqrt(vv0508_H2_516_01_2005_full);

uu0508_H2_516_2005 = squeeze(uu0508_H2_516_2005);
uu0508_H2_516_2005_full = reshape(uu0508_H2_516_2005',1,710);
%  get UV
uv0508_H2_516_full = sqrt(vv0508_H2_516_01_2005_full.^2+uu0508_H2_516_2005_full.^2);

   uv0508_H2_516_full_nptive = uv0508_H2_516_full(157:450);
   uv0508_H2_516_full_nptive(36:85)=uv0508_H2_516_full_nptive(36:85)*(-1);
   uv0508_H2_516_full_nptive(157:207)=uv0508_H2_516_full_nptive(157:207)*(-1);
   uv0508_H2_516_full_nptive(281:end)=uv0508_H2_516_full_nptive(281:end)*(-1);
   grid
% plot
  
figure

% subplot 222
   plot(uv0508_H2_516_full_nptive,'K-')
   hold on
   plot(1:10:261,Data003(:,2),'mo','MarkerSize',25);
   hold off
   
   legend('Mod','Obs')

   title('H2 depth-average','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('Current Velocity [ m/s]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
   
%    set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[21.25 21.50 21.75 22.00 22.25 22.50 22.75 ],'FontSize',22)
   set(gca,'xtick',[10 70 130 190 250],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)
   set(gca,'FontSize',30,'FontName','Cambria')
  
% get current direction 

 [a b] = size(vv0508_H2_516_2005); 
for i =  1:a;
    if       vv0508_H2_516_2005(i,1) >= 0 && uu0508_H2_516_2005(i,1) >= 0 %1st 
              theta_0508_H2_516_01(i,1) = 90-atan(vv0508_H2_516_2005(i,1)/uu0508_H2_516_2005(i,1))*180/pi;
     elseif  vv0508_H2_516_2005(i,1) < 0 && uu0508_H2_516_2005(i,1) >= 0  %4th
            theta_0508_H2_516_01(i,1) = -atan(vv0508_H2_516_2005(i,1)/uu0508_H2_516_2005(i,1))*180/pi+90; 
     elseif  vv0508_H2_516_2005(i,1) < 0 && uu0508_H2_516_2005(i,1) < 0   % 3rd
            theta_0508_H2_516_01(i,1) = atan(vv0508_H2_516_2005(i,1)/uu0508_H2_516_2005(i,1))*180/pi+180; 
     elseif  vv0508_H2_516_2005(i,1) >= 0 && uu0508_H2_516_2005(i,1) < 0  %2nd
            theta_0508_H2_516_01(i,1) = -atan(vv0508_H2_516_2005(i,1)/uu0508_H2_516_2005(i,1))*180/pi+270; 
    end
end

 figure
  subplot 222
  plot(theta_0508_H2_516_01(3:35),'k-')
  hold on 
  plot(dir_spring_h2_HZB_0508(:,2),'mo','MarkerSize',12,'MarkerFaceColor','m');
   hold off
   
    title('H2 station','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('Current Dir [ degree]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
   axis([1 38 0 360 ])
      set(gca,'xtick',[1 7 13 19 25],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)
   grid
   set(gca,'FontSize',30,'FontName','Cambria')


%% H3 depth average
%  get V
    vv0508_H3_444 = mean(vv_0508{280}(444,1:6,1:10));
for i = 281:350
    vv0508_H3_444 = [vv0508_H3_444,mean(vv_0508{i}(444,1:6,1:10))];
end 
    vv0508_H3_444 = squeeze(vv0508_H3_444);
    vv0508_H3_444_full =reshape(vv0508_H3_444',1,710);
    
% get U
    uu0508_H3_444 = mean(uu_0508{280}(444,1:6,1:10));
for i = 281:350
    uu0508_H3_444 = [uu0508_H3_444,mean(uu_0508{i}(444,1:6,1:10))];
end 
uu0508_H3_444 = squeeze(uu0508_H3_444);
uu0508_H3_444_full = reshape(uu0508_H3_444',1,710);

%  get UV
uv0508_H3_444 = sqrt(vv0508_H3_444(:,1).^2+uu0508_H3_444(:,1).^2);
uv0508_H3_444_full = sqrt(vv0508_H3_444_full.^2+uu0508_H3_444_full.^2);


%  get negetive and positive

   uv0508_H3_444_full_nptive = uv0508_H3_444_full(163:450);
   uv0508_H3_444_full_nptive(34:80)=uv0508_H3_444_full_nptive(34:80)*(-1);
   uv0508_H3_444_full_nptive(155:203)=uv0508_H3_444_full_nptive(155:203)*(-1);
   uv0508_H3_444_full_nptive(278:end)=uv0508_H3_444_full_nptive(278:end)*(-1);
%  plot
   figure
   
   subplot 223
   plot(uv0508_H3_444_full_nptive,'K-')
   hold on
   plot(1:10:281,Data004(:,2),'mo','MarkerSize',15);
   hold off
   
   legend('Mod','Obs')
   grid
   title('H3 depth average','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('Current Velocity [ m/s]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
%  set(gca,'xtick',[1 7 13 19 25 31 37],'xticklabel',[21.25 21.50 21.75 22.00 22.25 22.50 22.75 ],'FontSize',22)
      set(gca,'xtick',[10 70 130 190 250],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)

    set(gca,'FontSize',30,'FontName','Cambria')
  
% get current direction 

 [a b] = size(vv0508_H3_444); 
for i =  1:a;
    if       vv0508_H3_444(i,1) >= 0 && uu0508_H3_444(i,1) >= 0 %1st 
              theta_0508_H3_444_01(i,1) = 90-atan(vv0508_H3_444(i,1)/uu0508_H3_444(i,1))*180/pi;
     elseif  vv0508_H3_444(i,1) < 0 && uu0508_H3_444(i,1) >= 0  %4th
            theta_0508_H3_444_01(i,1) = -atan(vv0508_H3_444(i,1)/uu0508_H3_444(i,1))*180/pi+90; 
     elseif  vv0508_H3_444(i,1) < 0 && uu0508_H3_444(i,1) < 0   % 3rd
            theta_0508_H3_444_01(i,1) = atan(vv0508_H3_444(i,1)/uu0508_H3_444(i,1))*180/pi+180; 
     elseif  vv0508_H3_444(i,1) >= 0 && uu0508_H3_444(i,1) < 0  %2nd
            theta_0508_H3_444_01(i,1) = -atan(vv0508_H3_444(i,1)/uu0508_H3_444(i,1))*180/pi+270; 
    end
end

 figure
    subplot 223
  plot(theta_0508_H3_444_01(3:35),'k-')
  hold on 
  plot(dir_spring_h3_HZB_0508(:,2),'mo','MarkerSize',12,'MarkerFaceColor','m');
  hold off 
    title('H3 station','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('Current Dir [ degree]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
   axis([1 38 0 360 ])
      set(gca,'xtick',[1 7 13 19 25],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)
   grid
   set(gca,'FontSize',30,'FontName','Cambria')
   
 
   


%%  H4
  vv0508_H4_402 = mean(vv_0508{280}(402,1:6,1:10));
for i = 281:350
    vv0508_H4_402 = [vv0508_H4_402,mean(vv_0508{i}(402,1:6,1:10))];
end 
    vv0508_H4_402 = squeeze(vv0508_H4_402);
    vv0508_H4_402_full =reshape(vv0508_H4_402',1,710);
    
% get U
    uu0508_H4_402 = mean(uu_0508{280}(402,1:6,1:10));
for i = 281:350
    uu0508_H4_402 = [uu0508_H4_402,mean(uu_0508{i}(402,1:6,1:10))];
end 
uu0508_H4_402 = squeeze(uu0508_H4_402);
uu0508_H3_402_full = reshape(uu0508_H4_402',1,710);

%  get UV
uv0508_H4_402 = sqrt(vv0508_H4_402(:,1).^2+uu0508_H4_402(:,1).^2);
uv0508_H4_402_full = sqrt(vv0508_H4_402_full.^2+uu0508_H3_402_full.^2);


%  get negetive and positive

   uv0508_H4_402_full_nptive = uv0508_H4_402_full(167:450);
   uv0508_H4_402_full_nptive(37:80)=uv0508_H4_402_full_nptive(37:80)*(-1);
   uv0508_H4_402_full_nptive(158:203)=uv0508_H4_402_full_nptive(158:203)*(-1);
   uv0508_H4_402_full_nptive(282:end)=uv0508_H4_402_full_nptive(282:end)*(-1);
   
%  plot
   figure
   
   subplot 224
   plot(uv0508_H4_402_full_nptive,'K-')
   hold on
   plot(1:10:281,Data005(1:29,2),'mo','MarkerSize',15);
   hold off
   legend('Mod','Obs')
   grid
   
   title('H4 depth average','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('Current Velocity [ m/s]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
   set(gca,'xtick',[10 70 130 190 250],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)
   set(gca,'FontSize',30,'FontName','Cambria')
  
% get current direction 

 [a b] = size(vv0508_H4_402); 
for i =  1:a;
    if       vv0508_H4_402(i,1) >= 0 & uu0508_H4_402(i,1) >= 0 %1st 
              theta_0508_H4_402(i,1) = 90-atan(vv0508_H4_402(i,1)/uu0508_H4_402(i,1))*180/pi;
     elseif  vv0508_H4_402(i,1) < 0 & uu0508_H4_402(i,1) >= 0  %4th
            theta_0508_H4_402(i,1) = -atan(vv0508_H4_402(i,1)/uu0508_H4_402(i,1))*180/pi+90; 
     elseif  vv0508_H4_402(i,1) < 0 && uu0508_H4_402(i,1) < 0   % 3rd
            theta_0508_H4_402(i,1) = atan(vv0508_H4_402(i,1)/uu0508_H4_402(i,1))*180/pi+180; 
     elseif  vv0508_H4_402(i,1) >= 0 & uu0508_H4_402(i,1) < 0  %2nd
            theta_0508_H4_402(i,1) = -atan(vv0508_H4_402(i,1)/uu0508_H4_402(i,1))*180/pi+270; 
    end
end

  figure
    subplot 224
  plot(theta_0508_H4_402(5:32),'k-')
  hold on
  plot(dir_spring_h4_HZB_0508(:,2),'mo','MarkerSize',12,'MarkerFaceColor','m');
  hold off 
  
    title('H4 station','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('Current Dir [ degree]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
   axis([1 38 0 360 ])
      set(gca,'xtick',[1 7 13 19 25],'xticklabel', ...
    [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)
 
   grid
   set(gca,'FontSize',30,'FontName','Cambria')

%%  %    %% H4
% % %    
% % %    %  get V
% % %   vv0508_H4_266 = mean(vv_0508{280}(266,1:6,1:10));
% % % for i = 281:350
% % %     vv0508_H4_266 = [vv0508_H4_266,mean(vv_0508{i}(266,1:6,1:10))];
% % % end 
% % %     vv0508_H4_266 = squeeze(vv0508_H4_266);
% % %     vv0508_H4_266_full =reshape(vv0508_H4_266',1,710);
% % %     
% % % % get U
% % %     uu0508_H4_266 = mean(uu_0508{280}(266,1:6,1:10));
% % % for i = 281:350
% % %     uu0508_H4_266 = [uu0508_H4_266,mean(uu_0508{i}(266,1:6,1:10))];
% % % end 
% % % uu0508_H4_266 = squeeze(uu0508_H4_266);
% % % uu0508_H3_266_full = reshape(uu0508_H4_266',1,710);
% % % 
% % % %  get UV
% % % uv0508_H4_266 = sqrt(vv0508_H4_266(:,1).^2+uu0508_H4_266(:,1).^2);
% % % uv0508_H4_266_full = sqrt(vv0508_H4_266_full.^2+uu0508_H3_266_full.^2);
% % % 
% % % 
% % % %  get negetive and positive
% % % 
% % %    uv0508_H4_266_full_nptive = uv0508_H4_266_full(167:450);
% % %    uv0508_H4_266_full_nptive(37:80)=uv0508_H4_266_full_nptive(37:80)*(-1);
% % %    uv0508_H4_266_full_nptive(158:203)=uv0508_H4_266_full_nptive(158:203)*(-1);
% % %    uv0508_H4_266_full_nptive(282:end)=uv0508_H4_266_full_nptive(282:end)*(-1);
% % %    
% % % %  plot
% % %    figure
% % %    
% % %    subplot 224
% % %    plot(uv0508_H4_266_full_nptive,'K-')
% % %    hold on
% % %    plot(1:10:281,Data005(1:29,2),'mo','MarkerSize',15);
% % %    hold off
% % %    legend('Mod','Obs')
% % %    grid
% % %    
% % %    title('H4 depth average','Margin',2,'FontSize',30,'FontName','Cambria')
% % %    ylabel('Current Velocity [ m/s]','Margin',2,'FontSize',30,'FontName','Cambria')
% % %    xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
% % %    set(gca,'xtick',[10 70 130 190 250],'xticklabel', ...
% % %     [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)
% % %    set(gca,'FontSize',30,'FontName','Cambria')
% % %   
% % % % get current direction 
% % % 
% % %  [a b] = size(vv0508_H4_266); 
% % % for i =  1:a;
% % %     if       vv0508_H4_266(i,1) >= 0 & uu0508_H4_266(i,1) >= 0 %1st 
% % %               theta_0508_H4_266(i,1) = 90-atan(vv0508_H4_266(i,1)/uu0508_H4_266(i,1))*180/pi;
% % %      elseif  vv0508_H4_266(i,1) < 0 & uu0508_H4_266(i,1) >= 0  %4th
% % %             theta_0508_H4_266(i,1) = -atan(vv0508_H4_266(i,1)/uu0508_H4_266(i,1))*180/pi+90; 
% % %      elseif  vv0508_H4_266(i,1) < 0 && uu0508_H4_266(i,1) < 0   % 3rd
% % %             theta_0508_H4_266(i,1) = atan(vv0508_H4_266(i,1)/uu0508_H4_266(i,1))*180/pi+180; 
% % %      elseif  vv0508_H4_266(i,1) >= 0 & uu0508_H4_266(i,1) < 0  %2nd
% % %             theta_0508_H4_266(i,1) = -atan(vv0508_H4_266(i,1)/uu0508_H4_266(i,1))*180/pi+270; 
% % %     end
% % % end
% % % 
% % %   figure
% % %   plot(theta_0508_H4_266(6:39),'ko-')
% % %   hold on
% % %   plot(dir_spring_h4_HZB_0508(:,2),'mo','MarkerSize',12,'MarkerFaceColor','m');
% % %   hold off 
% % % 
% % %     title('H4 (sigma = 1)','Margin',2,'FontSize',30,'FontName','Cambria')
% % %    ylabel('Dir [ degree]','Margin',2,'FontSize',30,'FontName','Cambria')
% % %    xlabel('August 2005','Margin',2,'FontSize',30,'FontName','Cambria')
% % %    set(gca,'xtick',[1 7 13 19 25],'xticklabel', ...
% % %       [21.25 21.50 21.75 22.00 22.25  ],'FontSize',22)  
% % %    set(gca,'FontSize',30,'FontName','Cambria')




