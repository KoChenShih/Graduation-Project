
clear;

data = multibandread('D:\畢專檔案2\20210812_BlackA_4.0f_6.5ms_reflectance.raw',[333,400,150],'float32=>float32',0,'bsq','ieee-le');
data = double(data);
data2 = multibandread('D:\畢專檔案2\20210812_GreenA_4.0f_6.5ms_reflectance.raw',[333,400,150],'float32=>float32',0,'bsq','ieee-le');
data2 = double(data2);

I = cat(2,data,data2); %合併成608*1936*298
[r,c,b] = size(I);     %把I的row,column,band存到r,c,b

%總共有1177088個點，也就是會有1177088 rows，每一row是每一個點的298個頻譜特徵
dat = reshape(I,r*c,b); %每一行以column major存I的資料到dat,會有298行
nonzero = any(dat>0.2,2); %看每一row有無全部小於等於0.2

%每一row是每一個點的頻譜特徵
%執行kmeans將 n*p矩陣(dat)的觀測值劃分為k群
%idx:N*1的向量，儲存的是每個點的分群標號
[idx,Ctrs] = kmeans(dat,3,'Distance','cosine');    

temp = zeros(r*c,1);
temp = idx;
x1 = reshape(temp,r,c); %把temp變成r*c

figure,imagesc(label2rgb(x1,'parula','k')),axis off, axis image;

%畫出聚類為n的點。dat(Idx==1,1),為第一類的樣本的第一個座標；X(Idx==1,2)為第二類的樣本的第二個座標...
% plot(combine(idx==1,1),combine(idx==1,2),'r.','MarkerSize',14)
% hold on
% plot(combine(idx==2,1),combine(idx==2,2),'b.','MarkerSize',14)
% hold on
% plot(dat(idx==3,1),dat(idx==3,2),'g.','MarkerSize',14)
% hold on
% plot(dat(idx==4,1),dat(idx==4,2),'y.','MarkerSize',14)  

% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)

%legend('Cluster 1','Cluster 2','Centroids','Location','NW')
