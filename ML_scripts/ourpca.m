function [dimension] = ourpca(file)
     [COEFF,~,e]=pca(file)
     sortede = sort(e);
     biggest = sortede(155); 
     indices = find(e >= biggest);
     dimension = file(:,indices);
end

