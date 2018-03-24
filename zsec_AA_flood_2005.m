% plot vertical cross-section of U/T/S
% Jamie Pringle, University of New Hampshire
% clear all

%% location of data files
filedir='J:\ZJU\output2005\netcdf\';
%filehist='chj_0300.nc'; %flooding
filehist='chj_0294.nc';% ebbing

zplot=-5; %depth to make (x,y) plot
nt=1;      %time to plot (in records of output in file) 
dnt=1;     %number of output records to average over 
% ax=1e6*[0.8302 5.4016 0 1.9548];     %domain to plot in (x,y),
	       %km. An empty matrix plots 
	       %the entire domain
	   
cax_s=[20 32]; %color range of salt
cax_t=[10 30]; %color range of temp
cax_u=[-3:0.1:3]; %contour intervals of velocity in CM/S!
dsec=1e2; %this code intepolates the data onto a line in x,y
          %space.dsec is the spacing between points on the line,
          %and should be much less than the node spacing for most
          %accurate results. 
%% load grid data
load chjmesh20052005
%attach netcdf files to variables
nchist=netcdf([filedir filehist],'nowrite');
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

%% interp salinity to depth in order to plot horizontal map
% mistake in using interp1_fast
%  tic;
 sdepth=nan*ones(size(squeeze(schunk(1,:))));
%  for m=1:M
%    sdepth(m)=interp1_fast(mesh2005.nodez(1:10,m),schunk(:,m),zplot);
%  end
%  toc

%% plot map with salinity
figure(4)
%subplot(1,3,2)
%plot vertices
 col=0.7*[1 1 1];
 jnk=patch('Vertices',mesh2005.nodexy/1,'Faces',mesh2005.trinodes,...
	   'FaceColor',col,'EdgeColor',col);
%  
%  hold on
 patch('Vertices',mesh2005.nodexy/1,'Faces',mesh2005.trinodes,'Cdata',sdepth,...
     'edgecolor','interp','facecolor','interp')
%  hold off
%  caxis(cax_s);
 title('Transection line')
 
%add depth to plot
 if (1==2)
   load depthgrd
   hold on
   contour(depthgrd.xvec/1,depthgrd.yvec/1,...
	   depthgrd.dpth,[0:10:100],'k-')
   hold off
 end
%  colorbar
%  axis equal
%  if ~isempty(ax)
%    axis(ax)
%  end
%save axis
%  map=gca;

%% get two points to define end points of section
% [xp,yp]=ginput(2);
%load paa
%load pbb
load pdd
 % xp=[0.8720    1.0112]*1e6
 % yp=[3.9117   -9.8075]*1e4
 
%define section to calculate along
 dg=dsec/sqrt((xp(2)-xp(1)).^2+(yp(2)-yp(1)).^2);
 gvec=(0:dg:1)';
 xvec=(xp(2)-xp(1))*gvec+xp(1);
 yvec=(yp(2)-yp(1))*gvec+yp(1);
 distvec=sqrt((xvec-xp(1)).^2+(yvec-yp(1)).^2);

 %compute angle of line, and angle perpendicular to line
 theta=atan2(yp(2)-yp(1),xp(2)-xp(1));
 cross_theta=theta-pi/2;
 
 hold on
 plot(xvec/1,yvec/1,'k.',xvec/1,yvec/1,'m-')
 hold off
 
%interpolate T,S, U and V and Z onto section on k level.
 tic;
 echo on
 tsec=griddata_vect(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),...
     tchunk,xvec,yvec);
 ssec=griddata_vect(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),...
     schunk,xvec,yvec);
 zsec=griddata_vect(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),...
     mesh2005.nodez,xvec,yvec);
 usec=griddata_vect(mesh2005.uvnode(:,1),mesh2005.uvnode(:,2),...
     uchunk,xvec,yvec);
 vsec=griddata_vect(mesh2005.uvnode(:,1),mesh2005.uvnode(:,2),...
     vchunk,xvec,yvec);
 echo off
 toc 

 %% make matrix of horizontal distances for use in makeing plots
 distsec=[];
 for k=1:10
   distsec(k,:)=distvec';
 end
 %make cross section velocity.
 cross_vel=sin(cross_theta)*vsec+cos(cross_theta)*usec;
 

 %% 
 figure
%  subplot(1,3,2)
%  figure
 pcolor(distsec(1:10,:)/1,zsec(1:10,:),cross_vel);
 shading interp
  hold on; 
%  figure
% [clab,hlab]=contour(distsec(1:10,:)/1,zsec(2:11,:),cross_vel,10,'Linecolor','k');
[clab,hlab]=contour(distsec(1:10,:)/1,zsec(1:10,:),cross_vel,'Linecolor','k');
% clabel(clab)
set(hlab,'LineWidth',0.1)
clabel(clab,hlab,'Fontsize',9,'Fontname','Cambia','Color','k','Rotation',45,'LabelSpacing',450);
hold off 
shading flat

% text(.15e4,-6.75,'Current Transect AA`,Ebbing, 2005', 'Margin',2,'Fontsize',14,...
%      'Fontname','Cambia','FontWeight','Bold');

% text(.15e4,-6.75,'Current Transect AA`,Flooding, 2005', 'Margin',2,'Fontsize',14,...
%      'Fontname','Cambia','FontWeight','Bold');

%  text(1e4,-14.5,'Current Transect BB`,Flooding, 2005', 'Margin',2,'Fontsize',14,...
%      'Fontname','Cambia','FontWeight','Bold');

%  text(1e4,-14.5,'Current Transect BB`,Ebbing, 2005', 'Margin',2,'Fontsize',14,...
%      'Fontname','Cambia','FontWeight','Bold');

%   text(1e4,-12,'Current Transect DD`,Flooding, 2005', 'Margin',2,'Fontsize',14,...
%      'Fontname','Cambia','FontWeight','Bold');

 text(1e4,-12,'Current Transect DD`,Ebbing, 2005', 'Margin',2,'Fontsize',14,...
     'Fontname','Cambia','FontWeight','Bold');


%
xlabel('Distance [ m]','Margin',2,'Fontsize',14,'Fontname','Cambia')
ylabel('Depth [ m]','Margin',2,'Fontsize',14,'Fontname','Cambia')

%  colorbar;
%  title('Current Transect AA`,Flooding, 2005', 'Margin',2,'Fontsize',14,'Fontname','Cambia');
 title(colorbar,'(m/s)'); colorbar;caxis([-2.5  2.5]);
 title(colorbar,'(m/s)')
set(gcf,'Position',[100,100,800,600])



%%
 
 %  saveas(hh,sprintf('transe1.png'))
%  hhh=figure(3);
%  iptsetpref('ImshowBorder','tight');
%  set(hhh,'Color','white')
%  print(hhh,'-depsc2','-painters','line02.eps');
 

 
% add box to string
%set(hc1,'BackgroundColor',[1 1 1],'Edgecolor',[0 0 0],'Linestyle','-')
%  hh=clabel(clab,hlab,'labelspacing',200);
% how to set the size on the contorline??
%  w=hlab.LineWidth;
%  hlab.LineWidth =3;
%  set(hh,'string','Fontsize',14);
%  set(hh,'string',sprintf('%3.1f',get(hh),'userdata'));
% for kk=1:length(hh)
%     set(hh(kk),'string',sprintf('%3.1f',get(hh,'userdata')));
% end
% negpick(clab,hlab,'r','w','k');
 



% %% plot transect2
%  
%   [xp,yp]=ginput(2);
% 
% %define section to calculate along
%  dg=dsec/sqrt((xp(2)-xp(1)).^2+(yp(2)-yp(1)).^2);
%  gvec=(0:dg:1)';
%  xvec=(xp(2)-xp(1))*gvec+xp(1);
%  yvec=(yp(2)-yp(1))*gvec+yp(1);
%  distvec=sqrt((xvec-xp(1)).^2+(yvec-yp(1)).^2);
% 
%  %compute angle of line, and angle perpendicular to line
%  theta=atan2(yp(2)-yp(1),xp(2)-xp(1));
%  cross_theta=theta-pi/2;
%  
%  hold on
%  plot(xvec/1,yvec/1,'k*',xvec/1,yvec/1,'m-')
%  hold off
%  
% %interpolate T,S, U and V and Z onto section on k level.
%  tic;
%  echo on
%  tsec=griddata_vect(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),...
%      tchunk,xvec,yvec);
%  ssec=griddata_vect(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),...
%      schunk,xvec,yvec);
%  zsec=griddata_vect(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),...
%      mesh2005.nodez,xvec,yvec);
%  usec=griddata_vect(mesh2005.uvnode(:,1),mesh2005.uvnode(:,2),...
%      uchunk,xvec,yvec);
%  vsec=griddata_vect(mesh2005.uvnode(:,1),mesh2005.uvnode(:,2),...
%      vchunk,xvec,yvec);
%  echo off
%  toc 
% 
%  %make matrix of horizontal distances for use in makeing plots
%  distsec=[];
%  for k=1:KBM1
%    distsec(k,:)=distvec';
%  end
% 
%  %make cross section velocity.
%  %positive velocity is out of section
%  cross_vel=sin(cross_theta)*vsec+cos(cross_theta)*usec;
%  hh=figure(3);
%  pcolor(distsec(1:10,:)/1,zsec(1:10,:),cross_vel);
%  shading interp
%   hold on; 
% %  figure
% [clab,hlab]=contour(distsec(1:10,:)/1,zsec(1:10,:),cross_vel,10,'Linecolor','k');
% set(hlab,'LineWidth',0.5)
% hc1=clabel(clab,hlab,'Fontsize',10,'Color','k','FontWeight','bold','Rotation',90);
% 
%  hold off
%  shading flat
%  
%  xlabel('distance(m)','Fontsize',14)
%  ylabel('depth(m)','Fontsize',14)
%  colorbar
%  %shading interp
%  title('contours are velocity, positive is out of page',...
%      'Fontsize',16,'FontWeight','bold','Color','k');
%  saveas(hh,sprintf('transe1.png'))
%  hhh=figure(7);
%  iptsetpref('ImshowBorder','tight');
%  set(hhh,'Color','white')
%  print(hhhh,'-depsc2','-painters','line1.eps');
%  
 %% plot salinity and depth
% figure(3)
%  pcolor(distsec/1,zsec,ssec);
%  shading flat
%  hold on; 
%  [clab,hlab]=contour(distsec/1,zsec,cross_vel*100,[cax_u],'w-');
%  clabel(clab,hlab);
%  negpick(clab,hlab,'r','w','k');
%  hold off
%  xlabel('salinity')
%  ylabel('depth')
%  caxis(cax_s)
%  colorbar
%  shading interp
% 
%  title('contours are velocity, positive is out of page');
%  suptitle(sprintf(...
%      'tidal mean values for run %s at time %4.1f hours',...
%      filehist,time))
%  orient landscape
%  %You need this for some buggy versions of matlab, with some buggy
%  %OpenGL drivers.  
%  set(gcf,'renderer','painters')

 