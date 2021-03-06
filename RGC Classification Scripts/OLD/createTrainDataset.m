function createTrainDataset
load('/media/areca_raid/LabPapers/SCRouter/rgcdata/Sumbul/arborDensities.mat')
aD = arborDensities';

[a, b] = size(aD);
ADresult = [];
area2 = [];
zProfile2 = [];
n=1;
for i = 1:a
    temp = reshape(aD(i,:),[120, 20 ,20]);
    
    temp = permute(temp, [3,2,1]);
    
    ny=29;nx=29;nz=120; %% desired output dimensions
    [y x z]=...
        ndgrid(linspace(1,size(temp,1),ny),...
        linspace(1,size(temp,2),nx),...
        linspace(1,size(temp,3),nz));
    aOut=interp3(double(temp),x,y,z);
    temp = permute(aOut, [3,2,1]);
    temp = mat2gray(temp);
    zProfile2(:,n) = sum(sum(temp,2),3)/sum(temp(:));
    n = n+1;
   aOut = temp(:)';
   area2 = [area2; trapz(aOut)];
  % ADresult = [ADresult; aOut];
end
zProfile2 = zProfile2./repmat(max(zProfile2')',1,size(zProfile2,2));
%[dData,~] = pca(ADresult', 'Algorithm','svd','NumComponents', 25);

for i = 1:size(zProfile2,2)
     zMean_train(i,:) = mean(zProfile2(:,i)); %mean
     zVariance_train(i,:) = var(zProfile2(:,i)); %variance
     [peak, loc, w, p] = findpeaks(zProfile2(:,i)); %peak location
     
     %% first max 
     [mpeak, midx] = max(peak);
     mwidth = w(midx);
     zWidth_train1(i,:) = mwidth;
     zLocation_train1(i,:) = loc(midx);
     
     peak(midx) = []; %% delete that max
     w(midx) = [];
     loc(midx) = [];
     
     %% second max 
     [mpeak2, midx2] = max(peak); %%get second max peak
     mwidth2 = w(midx2);
     zWidth_train2(i,:) = mwidth2;
     zLocation_train2(i,:) = loc(midx2);
     
     peak(midx2) = [];
     w(midx2) = [];
     loc(midx2) = [];
     
     %%third max
     [mpeak3, midx3] = max(peak);
     mwidth3 = w(midx3);
     zWidth_train3(i,:) = mwidth3;
     zLocation_train3(i,:) = loc(midx3);
     
     peak(midx3) = [];
     w(midx3) = [];
     loc(midx3) = [];
     
     %%fourth max
     [mpeak4, midx4] = max(peak);
     mwidth4 = w(midx4);
     zWidth_train4(i,:) = mwidth4;
     zLocation_train4(i,:) = loc(midx4);
     
     peak(midx4) = [];
     w(midx4) = [];
     loc(midx4) = [];
     
     %%fifth max
     [mpeak5, midx5] = max(peak);
     mwidth5 = w(midx5);
     zWidth_train5(i,:) = mwidth5;
     zLocation_train5(i,:) = loc(midx5);
end

path1='/media/areca_raid/LabPapers/SCRouter/Katja';

cd(path1)

labels = getSumbulLabels_corrected;

cd('/media/areca_raid/Classification Scripts/Data');
traindata = [zLocation_train1, zWidth_train1, zLocation_train2, zWidth_train2, zLocation_train3, zWidth_train3, zLocation_train4, zWidth_train4,zLocation_train5, zWidth_train5,zMean_train, zVariance_train,area2, labels];
dlmwrite('traindata.txt',traindata);   
end
