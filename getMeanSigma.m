
% Reference
%   Paper: Localized Multiple Kernel Support Vector Data Description (LMSVDD)
%   Author= Chandan Gautam and Aruna Tiwari
%   Published in IEEE International Conference on Data Mining Workshops (ICDMW),
%   year=2018


% Chandan Gautam (chandangautam31@gmail.com or phd1501101001@iiti.ac.in)
% Discipline of Computer Science and Engineering, IIT Indore


function [sigma] = getMeanSigma(M_train)

N = size(M_train,2);  %%% Number of samples/training data

Dtrain = ((sum(M_train'.^2,2)*ones(1,N))+(sum(M_train'.^2,2)*ones(1,N))'-(2*(M_train'*M_train)));

sigma = sqrt(mean(mean(Dtrain)));

end

