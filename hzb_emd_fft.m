

%% FFT analysis

% zhapu verify with the T5 


zeta05_08_32310_neap=zeta05_{1}(32310,:);
for i = 2:840
zeta05_08_32310_neap=[zeta05_08_32310_neap,zeta05_{i}(32310,:)];
end 

zhapu3 = spectf(zeta05_08_32310_neap,0.042);
plot(zhapu2(:,1),zhapu2(:,2))
%% EMD analysis
zhapu_emd = eemd(zeta05_08_32310_neap,0,10);


zhapu_emd01_spec = spectf(zhapu_emd(:,2),0.0042);
zhapu_emd02_spec = spectf(zhapu_emd(:,3),0.0042);

figure
plot(zhapu_emd01_spec(:,1),zhapu_emd01_spec(:,2),'k-.')
hold on 
plot(zhapu_emd02_spec(:,1),zhapu_emd02_spec(:,2),'r-.')


