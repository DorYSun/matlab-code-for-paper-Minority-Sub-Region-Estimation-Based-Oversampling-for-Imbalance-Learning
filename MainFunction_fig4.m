%% % % % % % % % % % % % % % % % % % % 
% This is the code for Fig. 4.
% % % % % % % % % % % % % % % % % % 
clc;
clear;
close all;
abcdef=['(a) ';'(b) ';'(c) ';'(d) ';'(e) ';'(f) ';'(g) ';'(h) ';'(i) ';'(j) ';'(k) ';'(l) ';'(m) ';'(n) ';];
% % % % % % % % % % % % % % % % % % % % % % % % % % 
blockSize=1000;
load Square.mat;
data=Square;
T=size(data,1)/blockSize;
%% the area estimation and expanding algorithm
% begin=[1,163,324,486];
begin=[1,350,700,1000];
TB=2;   
BT=begin(TB);
dataset=data((BT-1)*1000+1:BT*1000,:);
[~,size2D]=size(dataset);
trainSet=dataset;
% % % % % dividing train set into majority and minority    
trainMinorityIndex=find(trainSet(:,size2D)==1);
trainMajorityIndex=find(trainSet(:,size2D)==0);
trainMinority=trainSet(trainMinorityIndex,1:size2D-1);
trainMajority=trainSet(trainMajorityIndex,1:size2D-1);
%% % % % % % % % % % % % % % % % % Algorithm 1. DDMSE Algorithm
majorityReferencePoint=MajorityreferencePointSelection(trainMajority,trainMinority,5);
clusterResultDDMSE=AreaCluster(trainMinority,trainMajority,majorityReferencePoint);
%% % % % % % % % % % % % % % % % % % % % 
axisX1=0;
axisX2=1;
axisY1=0;
axisY2=1;
FontSizeSet=8;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
subplot(3,4,1);
h1=plot(trainMajority(:,1),trainMajority(:,2),'k.','MarkerSize',4);
hold on;
h2=plot(trainMinority(:,1),trainMinority(:,2),'rs','MarkerSize',8);
xlabel('(a) Square dataset','FontSize',18,'FontWeight','bold');
lgd1=legend([h1,h2],'minority points','majority points','Orientation','horizontal');
lgd1.FontSize = 18;
lgd1.FontWeight = 'bold';
% axis equal;
axis([axisX1 axisX2 axisY1 axisY2]);
hold off;
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
% % % % % % % % % % % % % % % % % % % % % 
clusterResultkmeans1 = kmeans(trainMinority,3);
clusterResultkmeans2 = kmeans(trainMinority,4);
clusterResultkmeans3 = kmeans(trainMinority,5);
% % % % % % % % % % % % % % % % % % % 
subplot(3,4,2);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultkmeans1);
xlabel('(b) kmeans:k=3','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
subplot(3,4,3);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultkmeans2);
xlabel('(c) kmeans:k=4','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')

subplot(3,4,4);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultkmeans3);
xlabel('(d) kmeans:k=5','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
% % % % % % % % % % % % % % % % % % % % % % % % 
epsilon=0.2;
MinPts=2;
% % % % revised in 220214, change 0.05, 0.1, 0.2 to 0.1, 0.2, 0.4
[clusterResultDBSCAN1, isnoise1]=DBSCAN(trainMinority,0.1,MinPts);
[clusterResultDBSCAN2, isnoise2]=DBSCAN(trainMinority,0.2,MinPts);
[clusterResultDBSCAN3, isnoise4]=DBSCAN(trainMinority,0.4,MinPts);
subplot(3,4,5);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultDBSCAN1);
xlabel('(e) DBSCAN:eps=0.05','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
subplot(3,4,6);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultDBSCAN2);
xlabel('(f) DBSCAN:eps=0.1','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
subplot(3,4,7);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultDBSCAN3);
xlabel('(g) DBSCAN:eps=0.2','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
aaa=1;
% % % % % % % % % % % % % % % % % % % % % 
[clusterResultHierarchical1]=hierarchicalClustering(trainMinority,0.2);
[clusterResultHierarchical2]=hierarchicalClustering(trainMinority,0.4);
[clusterResultHierarchical3]=hierarchicalClustering(trainMinority,0.8);
% % % % % % % % % % % % % % % % % % % % % 
subplot(3,4,8);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultHierarchical1);
xlabel('(h) HAC:Dt=0.2 ','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
subplot(3,4,9);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultHierarchical2);
xlabel('(i) HAC:Dt=0.4 ','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
subplot(3,4,10);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultHierarchical3);
xlabel('(j) HAC:Dt=0.8 ','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
% % % % % % % % % % % % % % % % % % % % % % % % % % % 
subplot(3,4,11);
PlotClusterinResult([trainMinority(:,1),trainMinority(:,2)], clusterResultDDMSE);
xlabel('(k) DDMSE','FontSize',18,'FontWeight','bold');
axis([axisX1 axisX2 axisY1 axisY2]);
%set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
% legend(Legends);
% legend('Location', 'NorthEastOutside');
% legend([h1,h2],'少数类','多数类',[],'噪音点','类簇1','类簇2','类簇3','类簇4','Orientation','horizontal');
hold on
lgd=legend('noise','cluster1','cluster2','cluster3','cluster4');
lgd.FontSize = 18;
lgd.FontWeight = 'bold';
% figure(1)
% legend('噪音点','类簇1','类簇2','类簇3','类簇4','Orientation','horizontal');

aaa=1;
