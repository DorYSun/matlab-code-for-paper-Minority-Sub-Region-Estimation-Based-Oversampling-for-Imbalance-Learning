function [Sgroup]=AreaCluster(trainMinority,trainMajority,majorityReferencePoint)
%% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % r
[numData,sizeD2]=size(trainMinority);
trainSample=[trainMinority;trainMajority];
sizeMajMin=size(trainSample,1);
% % % % % % % % % % % % % % % %      

trainMinorityRepmat=repmat(trainMinority,1,sizeMajMin);
trainMinorityRepmat2DTo1D=reshape(trainMinorityRepmat',numData*sizeMajMin*sizeD2,1);
trainMinorityRepmat1DTo2D=reshape(trainMinorityRepmat2DTo1D,sizeD2,numData*sizeMajMin);
trainMinorityRepmat1DTo2D=trainMinorityRepmat1DTo2D';
trainMinorityRepmat2DTo3D=reshape(trainMinorityRepmat1DTo2D,sizeMajMin,numData,sizeD2);
trainMinorityRepmat2DTo3D=permute(trainMinorityRepmat2DTo3D, [2 1 3]);

trainSampleRepmat=repmat(trainSample,numData,1);
trainSampleRepmat2DTo3D=reshape(trainSampleRepmat,sizeMajMin,numData,sizeD2);
trainSampleRepmat2DTo3D=permute(trainSampleRepmat2DTo3D, [2 1 3]);
ditanceTMinToTS=sqrt(sum((trainMinorityRepmat2DTo3D-trainSampleRepmat2DTo3D).^2,3));
[D,I]=sort(ditanceTMinToTS,2);

%% % % step 3: Construct safe and unsafe minority sets Ssafemin and SunSafemin
IsSurrounded=zeros(numData,1);
whoseKnn=zeros(numData,1);
whoseKnnDistance=10000*ones(numData,1);
for i=1:numData
    IDXTemp=I(i,:);
    MajIndex=find(IDXTemp>numData);
    firstMajIndex=MajIndex(1);
    
% % % % Compute the first partition of nearest neighbours being minority 
% % % % Record them as Syinn and corresponding distances as Dyi nn
    IDX=I(i,1:firstMajIndex-1);
    Dist=D(i,1:firstMajIndex-1);
    sameMinKNN=size(IDX,2);
    if(sameMinKNN>1)
        IsSurrounded(i,1)=1;
        savedDistance=whoseKnnDistance(IDX);
        DistThere=Dist;
        DistanceSubtraction=DistThere-savedDistance';
        replaceIndexTemp=find(DistanceSubtraction<0);
        replaceIndex=IDX(replaceIndexTemp);
        replaceIndexNoni=find(replaceIndex~=i);
        whoseKnnDistance(replaceIndex(replaceIndexNoni))=DistThere(replaceIndexTemp(replaceIndexNoni));
        whoseKnn(replaceIndex(replaceIndexNoni))=i;
    end
end

SsafeminIndex=find(IsSurrounded==1);
Ssafemin=trainMinority(SsafeminIndex,:);
SsafeminNumber=size(Ssafemin,1);


% % % % % % % % 
%% % % % %step 4:for yi in Ssafemin and visited(yi)== 0 do
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
visited=zeros(SsafeminNumber,1);
cluster=1;
clusterResult=zeros(SsafeminNumber,1);
for i=1:SsafeminNumber
    if(visited(i)==0)
        visited(i)=1;
        clusterResult(i)=cluster;
        pointi=Ssafemin(i,:);
        visited0Index=find(visited==0);
        SsafeminVisited0=Ssafemin(visited0Index,:);
        sizeKPV0=size(SsafeminVisited0,1);
        distanceP1ToKPV0=sum((SsafeminVisited0-repmat(pointi,size(SsafeminVisited0,1),1) ).^2,2);
        [sortDist,sortIndex]=sort(distanceP1ToKPV0);
        for j=1:sizeKPV0
            CiIndex=find(clusterResult==cluster);
            Ci=Ssafemin(CiIndex,:);
            jIndex=visited0Index(sortIndex(j));
            pointj=Ssafemin(jIndex,:);
%             fprintf('(%f,%f) \n',i,j)
           
            condition=SameDirection_p_to_i(Ci,pointj,majorityReferencePoint);
            if(condition)
                clusterResult(jIndex)=cluster;
                visited(jIndex)=1;
            end
        end
        cluster=cluster+1;
    end
end
Sgroup=zeros(numData,1);
Sgroup(SsafeminIndex)=clusterResult;

%% % % %step 5: for yi in Sunsafemin do 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
unSafeminIndex=find(Sgroup==0);
noiseNumber=size(unSafeminIndex,1);
for i=1:noiseNumber
    whoseNeighboorIndex=whoseKnn(unSafeminIndex(i));
    if(whoseNeighboorIndex~=0)
        Sgroup(unSafeminIndex(i))=Sgroup(whoseNeighboorIndex);
    end
end
%% % % % 
% % % % % % compute the center points of each clusters
minorityClusterNum=max(Sgroup);
minorityClusterCenter=zeros(minorityClusterNum,sizeD2);
for i=1:minorityClusterNum
   indexCi=find(Sgroup==i); 
   Ci=trainMinority(indexCi,:);
   minorityClusterCenter(i,:)=mean(Ci,1);
end
%% % step 6: for yi as the second type of unsafe minority samples do % 
SecondUnSafeminIndex=find(Sgroup==0);
noiseNumber=size(SecondUnSafeminIndex,1);
for i=1:noiseNumber
    noiseSample=trainMinority(SecondUnSafeminIndex(i),:);
    distanceNPToMinCC= sum((minorityClusterCenter-repmat(noiseSample,size(minorityClusterCenter,1),1) ).^2,2);
    [sortDist,sortIndex]=sort(distanceNPToMinCC);
    found=0;
    j=1;
    while(j<=minorityClusterNum && found==0)
         cluster=sortIndex(j);
         CiIndex=find(Sgroup==cluster);
         Ci=trainMinority(CiIndex,:);    
         condition=SameDirection_p_to_i(Ci,noiseSample,majorityReferencePoint);
         j=j+1;
        if(condition)
            Sgroup(SecondUnSafeminIndex(i))=cluster;
            found=1;
        end
    end
end

%% % %step 7: for Si group in Sgroup do
minorityClusterNum=max(Sgroup);
clusterIndex=1;
for i=1:minorityClusterNum
    index_i=find(Sgroup==i);
    if(size(index_i,1)>1)
        Sgroup(Sgroup==i)=clusterIndex;
        clusterIndex=clusterIndex+1;
    else
        if(whoseKnn(index_i)==0)
            Sgroup(index_i)=0;
        else
            Sgroup(index_i)=Sgroup(whoseKnn(index_i));
        end
    end
    
end

end