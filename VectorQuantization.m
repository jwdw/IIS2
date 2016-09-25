function func = VectorQuantization(K, learningRate, t_max)

x = importdata('w6_1x.mat');
%x = importdata('w6_1y.mat');
%x = importdata('w6_1z.mat');

plotClusters = 0; %enable plotting of data and prototypes

dim = size(x);
N = dim(2);
P = dim(1);

index = randperm(P);

for n=1:K
    prototypes(n,:)=x(index(n),:);
end

close all

for t=1:t_max
  
    if plotClusters
      hold off
      scatter(x(:,1),x(:,2));  
      hold on
      scatter(prototypes(:,1),prototypes(:,2), 'r');
      title(['Epoch:' num2str(t)]);
      pause(0.5); 
    end
    
    %Calculate the quantization error
    tempErr = 0;
    for n=1:P
        minDist = EuclideanDistance(x(index(n)), prototypes(1));
        minK = 1;
        for m=2:K
            dist = EuclideanDistance(x(index(n)), prototypes(m));
            if dist < minDist
                minDist = dist;
                minK = m;
            end
        end
        tempErr = tempErr + minDist;
    end
    qErr(t) = tempErr;
    
    %adjust prototype location
    for n=1:P
        minDist = EuclideanDistance(x(index(n)), prototypes(1));
        minK = 1;
        for m=2:K
            dist = EuclideanDistance(x(index(n)), prototypes(m));
            if dist < minDist
                minDist = dist;
                minK = m;
            end
        end
        prototypes(minK,:) = prototypes(minK,:) + learningRate * (x(index(n),:) - prototypes(minK,:));
    end
    
    index = randperm(P);
end

%plot quantization error
figure(2);
plot(qErr);
xlabel('Epoch');
ylabel('Quantization error');
