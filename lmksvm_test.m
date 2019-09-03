% Localized Multiple Kernel Support Vector Data Description (LMSVDD)

% Summary
%   tests LMSVDD on test data with given model

% Input(s)
%   tes: test data
%   mod: LMSVDD model

% Output(s)
%   out: classification outputs

% Modified the code provided by Mehmet Gonen (gonen@boun.edu.tr)

%to strive to seek to fight and not to yield
function [out,K] = lmksvm_test(tes, mod, model2)
    P = length(tes) - 1;
    for m = 1:P
        tes{m}.X = normalize_data(tes{m}.X, mod.nor.dat{m});
    end
    loc = locality(tes{P + 1}.X, mod.par.loc.typ);
    loc = normalize_data(loc, mod.nor.loc);
    out.eta = etas(loc, mod.gat, mod.par.eps, mod.par.gat.typ);
%     out.dis = (mod.b-mod.rad) * ones(size(tes{1}.X, 1), 1);
%     out.dis = 0; out.diff = (mod.b-mod.rad);
%%%d1
     out.dis = (mod.b-mod.rad);
%%%d2      
%       out.dis = out.eta(:, 1) .* (mod.b-mod.rad);

    for m = 1:P
        K = kernel(tes{m}, mod.sup{m}, mod.par.ker{m}, mod.par.nor.ker{m}); %%% test vs train
        Ktest = kernel(tes{m}, tes{m}, mod.par.ker{m}, mod.par.nor.ker{m}); %%% %%% test vs test
        test_keta = kernel_eta(Ktest, out.eta);
        out.dis = out.dis + diag(test_keta) - 2 * sum((out.eta(:, m) * (mod.sup{m}.alp .* mod.sup{m}.y .* mod.sup{m}.eta)') .* K, 2);   
    end
%      out.dis = out.dis/P;
end
