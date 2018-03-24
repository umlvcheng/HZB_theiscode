% plot salinity and currents on a z-surface
% Jamie Pringle, University of New Hampshire

%%  

clf
clear all

%location of data files
filedir = '/Volumes/SHAOMING/ZJU/HZB/DATA_result/mshao_chj/output2005/netcdf/'
% path(path,'/Volumes/SHAOMING/ZJU/HZB/DATA_result/mshao_chj/output2005/netcdf/');
filename ='chj_0685.nc';

zplot=-5;   %depth to plot
nt=1;       %time to plot (in records of output in file) 
dnt=1;      %number of output records to average over 
% ax=1e5*[0.8302 5.4016 0 1.9548];     %domain to plot, km. An empty matrix plots he entire domain
ax=1e5*[0 6.2 31 38];	   

cax=[29 30.04]; %color range of plot

dts=8.64e4*6.0; %the number of seconds so that the length of the current arrows = dts*U 

min_plot=0.01;  %do not plot arrows where current is less than min_plot
		
scale_arrow_len = 0.1; %length of scale current arrow in m/s		

%% load grid data
load chjmesh20052005

%attach netcdf files to variables
nchist=netcdf([filedir filename],'nowrite');
t=nchist{'temp'};
s=nchist{'salinity'};
u=nchist{'u'};
v=nchist{'v'};
el=nchist{'zeta'};
thour=nchist{'time'};

%get data

tchunk=squeeze(t(nt:(nt+dnt-1),:,:));
schunk=squeeze(s(nt:(nt+dnt-1),:,:));
uchunk=squeeze(u(nt:(nt+dnt-1),:,:));
vchunk=squeeze(v(nt:(nt+dnt-1),:,:));
time=thour(nt:(nt+dnt-1));

%take time mean from nt:(nt+dnt-1)

if (dnt~=1)
  time=squeeze(mean(time));
  tchunk=squeeze(mean(tchunk,1));
  schunk=squeeze(mean(schunk,1));
  uchunk=squeeze(mean(uchunk,1));
  vchunk=squeeze(mean(vchunk,1));
end

%% interp salinity to depth surface
 tic;
 sdepth=nan*ones(size(squeeze(schunk(1,:))));
 for m=1:M
   %if (rem(m,1000)==0)
   %  m
   %end
   mesh2005.nodez(:,m) = abs(mesh2005.nodez(:,m))*(-1);% will make trouble!!
   sdepth(m)=interp1_fast(mesh2005.nodez(2:11,m),schunk(:,m),zplot);
 end
 toc
 
%interp u and v to depth, but only on points to be ploted. 
load minspace1000  %this is a file of points to be ploted from trim_uv.m
gp=goodpts;
u=zeros(length(gp),1);
v=zeros(length(gp),1);

tic
for g=1:length(gp)
  %if (rem(g,1000)==0)
  %  g
  %end
  u(g)=interp1_fast(mesh2005.zuv(1:10,gp(g)),uchunk(:,gp(g)),zplot);
  v(g)=interp1_fast(mesh2005.zuv(1:10,gp(g)),vchunk(:,gp(g)),zplot);
end
toc

%%  draw coastlines
figure
   col=0.7*[1 1 1];
   hot = [1 1 1];
   jnk=patch('Vertices',mesh2005.nodexy,'Faces', ...
       mesh2005.trinodes,'FaceColor',hot,'EdgeColor',hot);
% jnk=patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'EdgeColor',hot);

%% plot salinity
patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata',schunk(1,:),'edgecolor','interp','facecolor','interp')

suptitle(sprintf('U and S at z=%2.0f for file %s at time %4.1f hours',zplot,filename,time))

% if ~isempty(ax)
%    axis(ax)
%  end  
%  caxis(cax)
%  axis equal
%% plot temperature
patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata',sdepth,'edgecolor','interp','facecolor','interp')


%% plot HZB bathymetry 

   figure
    
   patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata',mesh2005.depth,'edgecolor','interp','facecolor','interp')

   axis([0.5*10^5 6.45*10^5 3.14*10^6 3.79*10^6 ])% total area

   %  title('Bathymetry ','Margin',2,'FontSize',24,'FontName','Cambria')
   ylabel('Y coordinate(m)','Margin',2,'FontSize',22,'FontName','Cambria')
   xlabel('X coordinate(m)','Margin',2,'FontSize',22,'FontName','Cambria')
   box;   set(gca,'TickDir','out');
   set(gca,'FontSize',22,'FontName','Cambria')
   hbar = colorbar;title(hbar,'Depth:m')

%  text(2.3*10^5,3.36*10^6,'Hangzhou','Margin',2,'FontSize',22,'FontName','Cambria');
   
%%  plot East china sea

    figure

    m_proj('albers equal-area','lat',[41 22],'lon',[132 117],'rect','on');
    m_gshhs_i('patch',[.7 .7 .7],'edgecolor','k');
    % m_grid('linestyle','none.','linewidth',0.02,'tickdir','out','yaxisloc','right','fontsize',20);
    m_grid('linestyle','none.','tickdir','out','yaxisloc','right','fontsize',20);

    text(119,33,'CHINA','FontSize',22,'FontName','Cambria');
 % plot contour


%% plot sea surface elevation at spring peak    
   
    tight_subplot(2,2,[.02 .02],[.1 .02],[.1 .02])

    hp_bar = get(tight_subplot(2,2,4),'Position');
    hb=colorbar('Position',[hp_bar{1}(1)+0.08 hp_bar{2}(2)+0.19 0.02 0.5*hp_bar{1}(4)]);
    caxis([-2 5])
    title(hb,'(m)');
% [2.5 3.5 4.5 5.5]            [120.4248 121.4405  122.475252  123.5298]
% [3.25 3.35 3.45 3.55]        [ 29.3543  30.2724  31.18298      32.085]

%%  high tide
    figure
 zeta_291_2005 = zeta2005{288}(:,:);
 zeta_291_2005 = zeta_291_2005(:,1);
patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata', ...
     zeta_291_2005,'edgecolor','interp','facecolor','interp')  
%    axis([2*10^5 6*10^5 3.2*10^6 3.7*10^6 ])% main area

%    axis([2.3*10^5 5.8*10^5 3.25*10^6 3.6*10^6 ])
    axis([2.1*10^5 4.6*10^5 3.25*10^6 3.55*10^6 ])
   box;   set(gca,'TickDir','out');
   set(gca,'FontSize',22,'FontName','Cambria')
   colorbar
   colormap(gca,'jet');   caxis([-4 5]) 
  
    set(gca,'xtick',[2.5*10^5 3.5*10^5 4.5*10^5 5.5*10^5],'xticklabel', ...
        [120.4 121.4 122.5 123.5],'FontSize',22)
    set(gca,'ytick',[3.25*10^6 3.35*10^6 3.45*10^6 3.55*10^6],'yticklabel', ...
        [ 29.4 30.3 31.2 32.1],'FontSize',22)
    
    title('zeta-291-2005')
 %% to get the subtraction 2005-1962 = ?????
 
 zeta_291_1962 
 
for i  = 1: 1000;
    
    dd(i) = (mesh2005.nodexy(i,) - mesh2005.nodexy()) 
 
 
 
 
  
 %%  at high ebbing   

 zeta_570 = zeta2005{570}(:,:); zeta_570 = zeta_570(:,1);
 
 patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata', ...
     zeta_570,'edgecolor','interp','facecolor','interp')  
    axis([2.3*10^5 5.8*10^5 3.25*10^6 3.6*10^6 ])
    box;   set(gca,'TickDir','out');
   set(gca,'FontSize',22,'FontName','Cambria')
   colormap(gca,'jet');caxis([-2 5])   
   
%   low tide at spring 

 zeta_574 = zeta2005{574}(:,:); zeta_574 = zeta_574(:,1);

     patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata', ...
     zeta_574,'edgecolor','interp','facecolor','interp')  
    axis([2.3*10^5 5.8*10^5 3.25*10^6 3.6*10^6])
   box;   set(gca,'TickDir','out');
   set(gca,'FontSize',22,'FontName','Cambria');caxis([-2 5]) 
     set(gca,'xtick',[2.5*10^5 3.5*10^5 4.5*10^5 5.5*10^5],'xticklabel', ...
        [120.4 121.4 122.5 123.5],'FontSize',22) 
    
% flooding   
  zeta_577 = zeta2005{577}(:,:); zeta_577 = zeta_577(:,1);
 
 patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata', ...
     zeta_577,'edgecolor','interp','facecolor','interp')  
   axis([2.3*10^5 5.8*10^5 3.25*10^6 3.6*10^6 ])
   box;   set(gca,'TickDir','out');caxis([-2 5]) 
   
   set(gca,'FontSize',22,'FontName','Cambria')
   
   set(gca,'xtick',[2.5*10^5 3.5*10^5 4.5*10^5 5.5*10^5],'xticklabel', ...
        [120.4 121.4 122.5 123.5],'FontSize',22)

   
  %% homornical analysis

  
  for kk = 100:840;
      for jj = 1:32657
          
          zetakkjj(jj,kk) = zeta2005{kk}(jj,1);
      end 
%       harmo_k = t_tide(zetakkjj)
  end
  
for ii = 1:5

%     zetakkjj =[zetakkjj,zeta2005{i}(32310,:)];
    
    harmo_kkjj.sturcture(ii,:) = t_tide(zetakkjj(ii,:));
       
    
end 

%    




 
%% get the tidal energy flux



% compute one point:zhapu!!

 pho = 1.27*10^3;% kg/m^3
 g = 9.8;

% % get Zhapu zeta
% zeta200508_32310=zeta2005{559}(32310,:);
% for i = 560:595
%     zeta200508_32310=[zeta200508_32310,zeta2005{i}(32310,:)];
% end 
% 
% % get Zhapu U
% zeta_zhapu = zeta200508_32310(1:10:end);
% U_zhapu = uv0508_H1_62128_01(1:38);
% dep = mesh2005.depth;% Zhapu water depth
% tidal_eneg_flux_288 = pho*g*dep*abs(zeta_zhapu(1:12))*U_zhapu(1:12)/12;

% get the total region tidal energy 




%  compute the distance between each node and each element center point
dis_node_elem = zeros(N,M);
for ii = 1:M;
for jj = 1:N;
      
      dis_node_elem (jj,ii) = sqrt((mesh2005.nodexy(ii,1)-mesh2005.uvnode(jj,1))^2+(mesh2005.nodexy(ii,2)-mesh2005.uvnode(jj,2))^2);
      
end
end
  
% [ROW,COL] = find(c == MAX); fine the min distance to take the velocity as
% the UV at the node.
for iii = 1:M;
    min_dis = min(dis_node_elem (:,iii)); 
    ROW_dis(iii) = find(min_dis == dis_node_elem (:,iii));
end

% compute the energy flux

%  Jinshan zeta at high tide t= 288;

zeta_291_2005 = zeta2005{288}(:,:);
zeta_291_2005 = zeta_291_2005(:,1);
% uv at t = 555;
for i = 288:288
     chncname=sprintf('chj_0%d.nc',i);
     file=chncname;
     vv_0508{i} = ncread(file,'v');     
     uu_0508{i} = ncread(file,'u');  
end

vv_288 =  vv_0508{288}(:,:,:);      uu_288 =  uu_0508{288}(:,:,:);
vv_288 =mean(vv_288(:,1:10,1),2);   uu_288 =mean(uu_288(:,1:10,1),2);

uv_288 = sqrt(vv_288.^2 + uu_288.^2);

for kk = 1:M;    
    tidal_eneg_flux_288(kk) = pho*g*dep(kk).*abs(zeta_291_2005(kk)).*uv_288(ROW_dis(kk));
end


%  Jinshan zeta at high tide t= 570;

zeta_570 = zeta2005{570}(:,:);
zeta_570 = zeta_570(:,1);
% uv at t = 555;
for i = 570:570
     chncname=sprintf('chj_0%d.nc',i);
     file=chncname;
     vv_0508{i} = ncread(file,'v');     
     uu_0508{i} = ncread(file,'u');  
end

vv_570 =  vv_0508{570}(:,:,:);      uu_570 =  uu_0508{570}(:,:,:);
vv_570 =mean(vv_570(:,1:10,1),2);   uu_570 =mean(uu_570(:,1:10,1),2);

uv_570 = sqrt(vv_570.^2 + uu_570.^2);

for kk = 1:M;    
    tidal_eneg_flux_570(kk) = pho*g*dep(kk).*abs(zeta_570(kk)).*uv_570(ROW_dis(kk));
end


%%  Jinshan zeta at high tide t= 574;

zeta_574 = zeta2005{574}(:,:);
zeta_574 = zeta_574(:,1);
% uv at t = 555;
for i = 574:574
     chncname=sprintf('chj_0%d.nc',i);
     file=chncname;
     vv_0508{i} = ncread(file,'v');     
     uu_0508{i} = ncread(file,'u');  
end

vv_574 =  vv_0508{574}(:,:,:);      uu_574 =  uu_0508{574}(:,:,:);
vv_574 =mean(vv_574(:,1:10,1),2);   uu_574 =mean(uu_574(:,1:10,1),2);

uv_574 = sqrt(vv_574.^2 + uu_574.^2);

for kk = 1:M;    
    tidal_eneg_flux_574_abs(kk) = pho*g*dep(kk).*abs(zeta_574(kk)).*uv_574(ROW_dis(kk));
end


% plot

    tight_subplot(2,2,[.02 .02],[.1 .02],[.1 .02])

    hp_bar = get(tight_subplot(2,2,4),'Position');
    hb=colorbar('Position',[hp_bar{1}(1)+0.08 hp_bar{2}(2)+0.23 0.02 0.5*hp_bar{1}(4)]);
    caxis([-2 5])
    title(hb,'W/m');

figure
% subplot 321
   patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata',tidal_eneg_flux_288,'edgecolor','interp','facecolor','interp')
   axis([2.3*10^5 5.8*10^5 3.25*10^6 3.6*10^6 ])% main area
   set(gca,'FontSize',22,'FontName','Cambria')
   box
   set(gca,'TickDir','out');
   caxis([0 1000000])
   colormap(gca,'jet'); 

% tight_subplot 322
   patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata',tidal_eneg_flux_570,'edgecolor','interp','facecolor','interp')
     
% subplot 323
   patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata',tidal_eneg_flux_574,'edgecolor','interp','facecolor','interp')

   %    tidal_eneg_flux_574_dif=tidal_eneg_flux_574_abs-tidal_eneg_flux_574;
% subplot 224
   patch('Vertices',mesh2005.nodexy,'Faces',mesh2005.trinodes,'Cdata',tidal_eneg_flux_577,'edgecolor','interp','facecolor','interp')

   
    set(gca,'xtick',[2.5*10^5 3.5*10^5 4.5*10^5 5.5*10^5],'xticklabel', ...
        [],'FontSize',22)

 set(get(hb,'title'),'string','W/m');
 locate = get(hb,'title');
 pos = get(locate,'position'); %it gives a position of 0.0500 2.900 1.0001
 pos(1,1) = pos(1,1)+0.08; 
 set(get(hb,'title'),'position',pos);

    ylabel('Latitude(^?N)','Margin',2,'FontSize',22,'FontName','Cambria')
   xlabel('Longtitude(^?E)','Margin',2,'FontSize',22,'FontName','Cambria')  
    
%%  tidal energy flux --- mean value 
   



   
%% tidal prism 









%% draw arrows(use tecplot!!!!!)

 %load what points to draw arrows on
 %load allspace
 
 figure 
 gp=goodpts;

 dx=dts*u'; dy=dts*v';
 offset=[dx;dy]';

 %don't plot arrows where their are no currents, or where they are less
 %than min_plot
 if ~isempty(ax)
   plotscale=1;
   bp=find((~isnan(u)).*(min_plot<sqrt(u.^2+v.^2)).*(mesh2005.uvnode(gp,1)>ax(1)*plotscale).*...
	   (mesh2005.uvnode(gp,1)<ax(2)*plotscale).*...
	   (mesh2005.uvnode(gp,2)>ax(3)*plotscale).*...
	   (mesh2005.uvnode(gp,2)<ax(4)*plotscale));
 else
   bp=find((~isnan(u)).*(min_plot<sqrt(u.^2+v.^2)));
 end
 
 if ~isempty(ax)
   axis(ax)
 end
 
 arrow(mesh2005.uvnode(gp(bp),:),(mesh2005.uvnode(gp(bp),:)+offset(bp,:)),'length',4,'tipangle',20,'width',0.5);
 
 %plot a scale arrow.
 ax_now=axis;
 xa=ax_now(1)+0.1*(ax_now(2)-ax_now(1));
 ya=ax_now(3)+0.9*(ax_now(4)-ax_now(3));
 ya_txt=ax_now(3)+0.93*(ax_now(4)-ax_now(3));
 
 arrow([xa ya],[xa+dts*scale_arrow_len ya],'length',4,'tipangle',20,'width',0.5);
 
 text(xa,ya_txt,sprintf('%4.2f cm/s',scale_arrow_len*100)) 
 
 title(sprintf(['Arrow is distance traveled in %2.1f days,''min arrow speed=%4.3fm/s'],dts/8.64e4,min_plot))

 if ~isempty(ax)
   axis(ax)
 end
 
 %% draw depth contours if the test below is true
 if (1==2)
   load depthgrd
   hold on
   contour(depthgrd.xvec,depthgrd.yvec,depthgrd.dpth,[0:5:100],'k-')
   hold off
   if ~isempty(ax)
     axis(ax)
   end
 end
 
%You need this for some buggy versions of matlab, with some buggy
%OpenGL drivers.  
 set(gcf,'renderer','painters')
colorbar

%clean up
close(nchist)

