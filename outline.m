

%% find oop boundary coordinate 
 
[a b] = size(ob2);

for i = 1:a;
    coord_ob2(i,:) = mesh2005.nodexy(ob2(i),:);
end

hold on 
plot(coord_ob2(:,1),coord_ob2(:,2))
shg

%%  put Outline01 together

Outline01 = [coord_ob1 coord_ob2 coord_lb01 coord_lb02 coord_lb03 ...
    coord_lb04 coord_lb05 coord_lb06 coord_lb07 coord_lb08 ]
