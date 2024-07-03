function [Srepmaj]=SrepmajSelection(trainMajority,trainMinority,K1)
[sizeMaj,sizeD2]=size(trainMajority);
sizeMin=size(trainMinority,1);
trainSample=[trainMajority;trainMinority];
sizeMajMin=size(trainSample,1);      

trainMajorityRepmat=repmat(trainMajority,1,sizeMajMin);
trainMajorityRepmat2DTo1D=reshape(trainMajorityRepmat',sizeMaj*sizeMajMin*sizeD2,1);
trainMajorityRepmat1DTo2D=reshape(trainMajorityRepmat2DTo1D,sizeD2,sizeMaj*sizeMajMin);
trainMajorityRepmat1DTo2D=trainMajorityRepmat1DTo2D';
trainMajorityRepmat2DTo3D=reshape(trainMajorityRepmat1DTo2D,sizeMajMin,sizeMaj,sizeD2);
trainMajorityRepmat2DTo3D=permute(trainMajorityRepmat2DTo3D, [2 1 3]);

trainSampleRepmat=repmat(trainSample,sizeMaj,1);
trainSampleRepmat2DTo3D=reshape(trainSampleRepmat,sizeMajMin,sizeMaj,sizeD2);
trainSampleRepmat2DTo3D=permute(trainSampleRepmat2DTo3D, [2 1 3]);
ditanceTMajToTS=sqrt(sum((trainMajorityRepmat2DTo3D-trainSampleRepmat2DTo3D).^2,3));
[~,I]=sort(ditanceTMajToTS,2);
KIDX=I(:,1:K1+1);

%% % % %step 1: Construct the safe majority set Ssafemaj
KIDXSubtraction=sizeMaj-KIDX+1;
KIDXSuit=KIDXSubtraction;
KIDXSuit(KIDXSubtraction>0)=1;
KIDXSuit(KIDXSubtraction<=0)=0;
sameMinKNN=sum(KIDXSuit,2)-1;
appMinIndex=find(sameMinKNN==K1);
Ssafemaj=trainMajority(appMinIndex,:);
SsafemajSize=size(Ssafemaj,1);
%% % % step 2: From Ssafemaj, pick up the representative majority as Srepmaj
% majority samples that near enough to the  minority samples own the priority to be selected
majSizeVector=zeros(SsafemajSize,1);
% % % % % % % 
for i=1:sizeMin
    [index,~]=knnsearch(Ssafemaj,trainMinority(i,:),'K',1);
    majSizeVector(index,1)=index;
end
k1NearestMajorityIndex=find(majSizeVector~=0);
Srepmaj=Ssafemaj(k1NearestMajorityIndex,:);

end