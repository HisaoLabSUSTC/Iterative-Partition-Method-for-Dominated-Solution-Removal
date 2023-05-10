function sets=mini_batch_kmeans(candidate, n, b)%b: batch size
    sets = {};
    [N, M]=size(candidate);
    index=1:N;
    norm_candidate = normalize(candidate, candidate);
    % Normalzie points to a unit sphere. Thus, distance equals to sqrt(2-cosine).
    norm_candidate = norm_candidate./repmat(sqrt(sum(norm_candidate.^2,2)),1,M);
    iter =100;
    C = norm_candidate(randperm(N,n),:);
    cnt = ones(n,1);
    for t=1:iter
       S = norm_candidate(randperm(N,b),:);
       [~, I] = min(pdist2(C,S),[],1);
       for i=1:n
           C(i,:)=(cnt(i)*C(i,:)+sum(S(I==i,:),1))/(cnt(i)+sum(I==i));
           cnt(i) = cnt(i)+sum(I==i);
       end

    end
    if n*N<=1000*1000000
        [~,I] = min(pdist2(C, norm_candidate), [], 1);
        for i=1:n
            sets{i}=index(I==i);
        end
    else % cannot allocte the memory for the distance matric
         for i=1:n
            sets{i}=[];
         end
         batch = floor(1000*1000000/n);
         for k=1:ceil(N/batch)
             subset=(k-1)*batch+1:min(k*batch,N);
             [~,I] = min(pdist2(C, norm_candidate(subset,:)), [], 1);
             for i=1:n
                 sets{i}=[sets{i};index(subset(I==i))];
             end
         end
    end
end

function r = sample(N, x)
    r = randperm(N);
    r = r(1:x);
end
function res = normalize(val, PF) % nomrmalize the obecjtive values by PF
    N = size(val,1);
    fmin   = min(PF, [], 1);
    fmax   = max(PF,[],1);
    res = (val-repmat(fmin,N,1))./repmat(fmax-fmin,N,1);
end