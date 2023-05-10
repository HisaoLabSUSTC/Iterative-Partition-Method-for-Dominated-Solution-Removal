% problems = ["NSGAIII_WFG1_M5", "NSGAIII_WFG1_M10","NSGAIII_WFG2_M5", "NSGAIII_WFG2_M10", "NSGAIII_WFG3_M5",...
%          "NSGAIII_WFG3_M10","NSGAIII_WFG4_M5", "NSGAIII_WFG4_M10", "NSGAIII_WFG5_M5", "NSGAIII_WFG5_M10", "NSGAIII_WFG6_M5", "NSGAIII_WFG6_M10",...
%          "NSGAIII_WFG7_M5","NSGAIII_WFG7_M10","NSGAIII_WFG8_M5","NSGAIII_WFG8_M10","NSGAIII_WFG9_M5","NSGAIII_WFG9_M10",...
%          "NSGAIII_WFG1_M3","NSGAIII_WFG2_M3","NSGAIII_WFG3_M3","NSGAIII_WFG4_M3","NSGAIII_WFG5_M3","NSGAIII_WFG6_M3",...
%     "NSGAIII_WFG7_M3","NSGAIII_WFG8_M3","NSGAIII_WFG9_M3", "NSGAIII_DTLZ1_M3", "NSGAIII_DTLZ2_M3", "NSGAIII_DTLZ3_M3",...
%     "NSGAIII_DTLZ4_M3","NSGAIII_DTLZ1_M10", "NSGAIII_DTLZ1_M5","NSGAIII_DTLZ2_M5","NSGAIII_DTLZ2_M10","NSGAIII_DTLZ3_M5","NSGAIII_DTLZ3_M10",...
%     "NSGAIII_DTLZ4_M5","NSGAIII_DTLZ4_M10","RE31", "RE32","RE33","RE34","RE35","RE36","RE37","RE41","RE42", "RE61","RE91"];
problems = ["RE31"];
for i=1:length(problems)
    P = load(sprintf("CandidateSet/%s.mat",problems(i))).candidate;
    problems(i)
    for num_subset =[50] %[20,100,200,500,1000,2000]
    for k=[1,2,3,5,6] 
        parfor r=1:10
            methods = getMethods(k,r,size(P,2));
            [index, recorder]=IterativePartition(P, num_subset, methods);
            num = recorder.num(end);
            if exist(sprintf("Results/IterativePartition_S%d_N%d",k,num_subset),"dir")~=7
                mkdir(sprintf("Results/IterativePartition_S%d_N%d",k,num_subset));
            end
            parSave(sprintf("Results/IterativePartition_S%d_N%d/%s_%d.mat",k,num_subset,problems(i),r), recorder, index);
        end
    end
    end
end
function parSave(path, recorder, index)
    save(path,"index","recorder");
end

