
% Reference
%   Paper: Localized Multiple Kernel Support Vector Data Description (LMSVDD)
%   Author= Chandan Gautam and Aruna Tiwari
%   Published in IEEE International Conference on Data Mining Workshops (ICDMW),
%   year=2018

% Summary
%   trains LMSVDD on training data with given parameters

% Input(s)
%   tra: training data
%   par: parameters

% Output(s)
%   mod: LMSVDD model

% Chandan Gautam (chandangautam31@gmail.com or phd1501101001@iiti.ac.in)
% Discipline of Computer Science and Engineering, IIT Indore

function [mod,model2] = lmksvm_train(tra, par)
    rand('twister', par.see); %#ok<RAND>
    P = length(tra) - 1;
    for m = 1:P
        mod.nor.dat{m} = mean_and_std(tra{m}.X, par.nor.dat{m});
        tra{m}.X = normalize_data(tra{m}.X, mod.nor.dat{m});
    end
    mod.loc = locality(tra{P + 1}.X, par.loc.typ);
    mod.nor.loc = mean_and_std(mod.loc, par.nor.loc);
    mod.loc = normalize_data(mod.loc, mod.nor.loc);
    mod.gat = gating_initial(mod.loc, P, par.gat.typ);
    eta = etas(mod.loc, mod.gat, par.eps, par.gat.typ);
    N = size(tra{1}.X, 1);
    yyKm = zeros(N, N, P);
    for m = 1:P
        yyKm(:, :, m) = (tra{m}.y * tra{m}.y') .* kernel(tra{m}, tra{m}, par.ker{m}, par.nor.ker{m});
    end
    yyKeta = kernel_eta(yyKm, eta);
    alp = zeros(N, 1);
    [alp, obj, model2] = solve_svm(tra{1}, par, yyKeta, alp);
    %display(sprintf('obj1:%10.6f', obj));
    mod.obj = obj;
    mod.sol = 1;
    while 1 && P > 1
        oldObj = obj;
        [alp, eta, mod, obj, yyKeta,model2] = learn_eta(tra, par, yyKm, alp, eta, mod, obj, yyKeta,model2);
        %display(sprintf('obj: %10.6f', obj));
        mod.obj = [mod.obj, obj];
        if abs(obj - oldObj) <= par.eps * abs(oldObj)
            break;
        end
    end
    mod = rmfield(mod, 'loc');
    for m = 1:P
        sup = find(alp .* eta(:, m) ~= 0);
        mod.sup{m}.ind = tra{m}.ind(sup);
        mod.sup{m}.X = tra{m}.X(sup, :);
        mod.sup{m}.y = tra{m}.y(sup);
        mod.sup{m}.alp = alp(sup);
        mod.sup{m}.eta = eta(sup, m);
    end
    sup = find(alp ~= 0);
    act = find(alp ~= 0 & alp < par.C);
%     act = sup;
    
   if isempty(act) == 0
            
     %%%% SVDD
    %%%% Calculate center b and radius r.
    
                          %%%%% Center b
                          
    %%%  Note that b is [1x1] Squared norm of the center equal to Alpha'*K*Alpha.
%{     
Actually, Center=alpha * x, but need b = Center^2 = alpha * x * x * alpha.
So, x * x can be treated as kernel in non-linear feature space.
So, we replace k = x * x, and now, Center^2 = alpha * k * alpha.
%}     

        mod.b = alp(act)' * yyKeta(act, sup) * alp(sup);
      
                          %%%%% Radius r
    %%%  Note that r is [1x1] squared radius of the minimal enclosing ball. i.e. R^2                     
%{
||x_i-Center||^2 = (x_i * x_i) + Center^2 - 2 * x_i * Center
                = k_ii + b -  2 * x_i * x_j * alpha
                = k_ii + b -  2 * k * alpha
Here, x_i denotes i^th sample and k_ii = diag(k) = diagonal element of kernel.
%}                          

        x2 = diag(yyKeta(act, act));  
        r = x2 + mod.b * ones(size(act,1),1) - 2 * yyKeta(act, sup) * alp(sup); 
        %%%m1        
%         mod.rad = mean(r);
        %%%m2
		mod.rad = max(r);
    else
         
                           %%%% Center b     

            %%% Only possibility     
        mod.b = alp(sup)' * yyKeta(sup, sup) * alp(sup);

      
                     %%%% Radius r
                         
            %%% Only possibility    
        x2 = diag(yyKeta(sup, sup));        
        r = x2 + mod.b * ones(size(sup,1),1) - 2 * yyKeta(sup, sup) * alp(sup);
        %%%m1        
%         mod.rad = mean(r);
        %%%m2
		mod.rad = max(r);
     end
    mod.par = par;
end

