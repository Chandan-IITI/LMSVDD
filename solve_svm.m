

%   Paper: Localized Multiple Kernel Support Vector Data Description (LMSVDD)
%   Author= Chandan Gautam and Aruna Tiwari
%   Published in IEEE International Conference on Data Mining Workshops (ICDMW),
%   year=2018

function [alp, obj, model] = solve_svm(tra, par, yyK, alp)
    N = size(tra.X, 1);
    switch lower(par.opt)
        case 'libsvm'
            alp = zeros(N, 1);
            %model = svmtrain(tra.y,tra.X,sprintf('-s 2 -n 0.05 -t 2 -g %f -e 0.001',1/(6.2054^2)));
            %%% OCSVM            
            % model = svmtrain(tra.y, [(1:1:N)' (tra.y * tra.y') .* yyK], sprintf('-q -s 2 -t 4  -e %g -n 0.05', par.tau));
            %%% SVDD   
            model = svmtrain(tra.y, [(1:1:N)' (tra.y * tra.y') .* yyK], sprintf('-q -s 5 -t 4  -e %g -n 0.05', par.tau));
            alp(model.SVs) = abs(model.sv_coef);
            
        case 'monqp'     
            %%%%% It consumes more time compared to 'libsvm' solver
run ./monqp/cvx-w64/cvx/cvx_startup.m
addpath ./monqp/SVM-KM/
addpath ./monqp/models/
addpath ./monqp/utils/
    [model.R,model.c,model.cNorm,model.alph1,model.Io,model.I1,model.I2,model.I3]=SVDD_MONQP(yyK,tra.X,par.C,-1);
    alp = abs(model.alph1);
rmpath ./monqp/SVM-KM/
rmpath ./monqp/models/
rmpath ./monqp/utils/  

        case 'svc'                 
        error('need to write the code for this');    
            
    end
    alp(alp < par.C * par.eps) = 0;
    alp(alp > par.C * (1 - par.eps)) = par.C;
    %obj = sum(alp) - 0.5 * alp' * yyK * alp;
    %obj = - 0.5 * alp' * yyK * alp; %%% For OCSVM
    obj = alp' * diag(yyK) - alp' * yyK * alp; %%% For SVDD
%     pause(2)
    %obj = obj * (obj >= 0);%if obj<o then obj=0
end