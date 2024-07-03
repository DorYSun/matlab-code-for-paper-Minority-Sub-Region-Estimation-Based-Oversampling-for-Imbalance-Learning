function [condition]=SameDirection_p_to_i(nearestMinorityCluster,noisePoint,majorityReferencePoint)
% % % % % % % % % % % % % % % % % % % %    r    
% % % % % % % % % % % % % % % % %               
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         
[majorityReferencePointSize,SizeD2]=size(majorityReferencePoint);
nearestMinorityClusterSize=size(nearestMinorityCluster,1);
% % % % % % % % % % % % % % % % % % % % % % % % % %         
nearestMinorityClusterRepmat=repmat(nearestMinorityCluster,1,majorityReferencePointSize);
nearestMinorityClusterRepmat2DTo1D=reshape(nearestMinorityClusterRepmat',nearestMinorityClusterSize*majorityReferencePointSize*SizeD2,1);
nearestMinorityClusterRepmat1DTo2D=reshape(nearestMinorityClusterRepmat2DTo1D,SizeD2,nearestMinorityClusterSize*majorityReferencePointSize);
nearestMinorityClusterRepmat1DTo2D=nearestMinorityClusterRepmat1DTo2D';
nearestMinorityClusterRepmat2DTo3D=reshape(nearestMinorityClusterRepmat1DTo2D,majorityReferencePointSize,nearestMinorityClusterSize,SizeD2);
nearestMinorityClusterRepmat2DTo3D=permute(nearestMinorityClusterRepmat2DTo3D, [2 1 3]);
% % % % % % % % % % % % % % % % % % % % % % % % % % % 
majorityReferencePointRepmat=repmat(majorityReferencePoint,nearestMinorityClusterSize,1);
majorityReferencePointRepmat2DTo3D=reshape(majorityReferencePointRepmat,majorityReferencePointSize,nearestMinorityClusterSize,SizeD2);
majorityReferencePointRepmat2DTo3D=permute(majorityReferencePointRepmat2DTo3D, [2 1 3]);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %                 
NoisePoint1DTo2D=repmat(noisePoint,majorityReferencePointSize,1);
NoisePoint2DTo2D=repmat(NoisePoint1DTo2D,nearestMinorityClusterSize,1);
NoisePoint2DTo3D=reshape(NoisePoint2DTo2D,majorityReferencePointSize,nearestMinorityClusterSize,SizeD2);
NoisePoint2DTo3D=permute(NoisePoint2DTo3D, [2 1 3]);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % 
drectionP1ToMajRP=NoisePoint2DTo3D-majorityReferencePointRepmat2DTo3D ;       
drectionP2ToMajRP=nearestMinorityClusterRepmat2DTo3D-majorityReferencePointRepmat2DTo3D;
drectionMultiplication=sum(drectionP1ToMajRP.*drectionP2ToMajRP,3);
diffirentDirectionMajR=drectionMultiplication;
diffirentDirectionMajR(drectionMultiplication<0)=1;
diffirentDirectionMajR(drectionMultiplication>=0)=0;
diffirentDirectionSum=sum(diffirentDirectionMajR,2);
diffirentDirectionNMinC=diffirentDirectionSum;
diffirentDirectionNMinC(diffirentDirectionSum<=0)=0;
diffirentDirectionNMinC(diffirentDirectionSum>0)=1;
diffirentDirectionNMinCNumber=sum(diffirentDirectionNMinC,1);
if(diffirentDirectionNMinCNumber<=nearestMinorityClusterSize/2)
    condition=true;
else
    condition=false;
end 