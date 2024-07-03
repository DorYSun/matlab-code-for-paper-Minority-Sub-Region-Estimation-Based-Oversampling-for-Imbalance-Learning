% % % % % % % % % % % % % % % % % % % hierarchical clustering process
function[clusterResult]=hierarchicalClustering(Smin,Th)
hierarchicalTree=linkage(Smin,'average');
% dendrogram(hierarchicalTree,0);
minoritySize=size(Smin,1);
hierarchicalTree3=hierarchicalTree(:,3);
indexLoc=find(hierarchicalTree3>Th);
if(size(indexLoc,1)==0)
    beginLoc=size(hierarchicalTree3,1);
else
    beginLoc=indexLoc(1)-1;
end

visited=zeros(beginLoc,1);
cluster=1;
clusterResult=zeros(minoritySize,1);
for i=beginLoc:-1:1
    if(visited(i)==0)
        visited(i)=1;
        stackIndex=hierarchicalTree(i,1:2);
        sizeStack=size(stackIndex,2);
        while(sizeStack~=0)
            topStack=stackIndex(sizeStack);
            if(topStack>minoritySize)
                visited(topStack-minoritySize)=1;
                stackIndex(sizeStack:sizeStack+1)=hierarchicalTree(topStack-minoritySize,1:2);
            else
                clusterResult(topStack)=cluster;
                stackIndexTemp=stackIndex(1:sizeStack-1);
                stackIndex=stackIndexTemp;
            end
            sizeStack=size(stackIndex,2);
        end
        cluster=cluster+1;
    end
end
end