function func = LearningVectorQuantization(K, learningRate, t_max)

x = importdata('data_lvq.mat');
%x = importdata('w6_1y.mat');
%x = importdata('w6_1z.mat');

plotClusters = 1; %enable plotting of data and prototypes

dim = size(x);
N = dim(2);
P = dim(1);

index = randperm(P);

for n=1:K
    prototypes(n,:)=x(index(n),:);
end

close all
numError = zeros(t_max,1);

for t=1:t_max
  
    if plotClusters
      hold off
      scatter(x(1:50,1),x(1:50,2),'o');  
      hold on;
      scatter(x(51:100,1),x(51:100,2),'d');  
      legend('Class 1', 'Class 2');
      scatter(prototypes(:,1),prototypes(:,2),'+');
      title(['Epoch:' num2str(t)]);
    end
    
%     %Calculate the quantization error
%     tempErr = 0;
%     for n=1:P
%         minDist = EuclideanDistance(x(index(n)), prototypes(1));
%         minK = 1;
%         for m=2:K
%             dist = EuclideanDistance(x(index(n)), prototypes(m));
%             if dist < minDist
%                 minDist = dist;
%                 minK = m;
%             end
%         end
%         tempErr = tempErr + minDist;
%     end
%     qErr(t) = tempErr;
    
    %adjust prototype location
    for n=1:P
        minDist = EuclideanDistance(x(index(n),:), prototypes(1,:));
        minK = 1;
        for m=2:K
            dist = EuclideanDistance(x(index(n),:), prototypes(m,:));
            if dist < minDist
                minDist = dist;
                minK = m;
            end
        end
        %if ((minK==1 || minK==2) && index(n) <= 50) || ((minK==3 || minK==4) && index(n) > 50)
        if (minK==1 && index(n) <= 50) || (minK==2 && index(n) > 50)
            %same class
            psi = 1;
        else
            psi = -1;
            numError(t) = numError(t) + 1;
        end
        prototypes(minK,:) = prototypes(minK,:) + learningRate * psi *(x(index(n),:) - prototypes(minK,:));
        %scatter(prototypes(minK,1),prototypes(minK,2),'+');
        %EuclideanDistance(x(index(n),),prototypes(minK,:));

    end
    pause(0.01); 
    index = randperm(P);
end

% %plot quantization error
% figure(2);
% plot(qErr);
% title(sprintf('Quantization error for learningRate = %d, K = %d', learningRate, K ));
% xlabel('Epoch');
% ylabel('Quantization error');
figure();
plot(numError);
