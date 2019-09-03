

%   Paper: Localized Multiple Kernel Support Vector Data Description (LMSVDD)
%   Author= Chandan Gautam and Aruna Tiwari
%   Published in IEEE International Conference on Data Mining Workshops (ICDMW),
%   year=2018


function gra = eta_gradient_lmk(alp, Km, eta, loc, gat, typ)
    N = size(loc, 1);
    DG = size(loc, 2) - 1;
    P = size(Km, 3);
    gra = zeros(P, DG + 1);
    gra2 = zeros(P, DG + 1);
        
    switch typ
%         case {'constant_sigmoid'}
%             for m = 1:P
%                 first = ((alp .* eta(:, m)) * (alp .* eta(:, m))') .* Km(:, :, m);
%                 temp = repmat((1 - eta(:, m)) .* loc(:, 1), 1, N);
%                 gra(m, 1) = gra(m, 1) - 0.5 * sum(sum(first .* (temp + temp')));
%             end
%         case {'constant_softmax'}
%             for h = 1:P
%                 first = ((alp .* eta(:, h)) * (alp .* eta(:, h))') .* Km(:, :, h);
%                 for m = 1:P
%                     del = (m == h);
%                     temp = repmat((del - eta(:, m)) .* loc(:, 1), 1, N);
%                     gra(m, 1) = gra(m, 1) - 0.5 * sum(sum(first .* (temp + temp')));
%                 end
%             end  
        case {'linear_sigmoid', 'sigmoid'}
            %%% Second Term
            for m = 1:P
                first = ((alp .* eta(:, m)) * (alp .* eta(:, m))') .* Km(:, :, m);
                for f = 1:DG + 1
                    temp = repmat((1 - eta(:, m)) .* loc(:, f), 1, N);
                    gra(m, f) = gra(m, f) - sum(sum(first .* (temp + temp')));
                end
            end
			%%%% First Term            
            for m = 1:P
                first2 = alp .* eta(:, m) .* eta(:, m) .* diag(Km(:, :, m));
                for f = 1:DG + 1
                    temp2 = repmat((1 - eta(:, m)) .* loc(:, f), 1, N);
                    gra2(m, f) = gra2(m, f) + sum(sum(first2 .* diag(temp2 + temp2')));
                end
            end            

gra = gra2 + gra;            
            
                                        
        case {'linear_softmax', 'softmax'}            
            %%% Second Term
            for h = 1:P
                first = ((alp .* eta(:, h)) * (alp .* eta(:, h))') .* Km(:, :, h);
                for m = 1:P
                    del = (m == h);
                    for f = 1:DG + 1
                        temp = repmat((del - eta(:, m)) .* loc(:, f), 1, N);
                        gra(m, f) = gra(m, f) - sum(sum(first .* (temp + temp')));
                    end
                end
            end
			%%%% First Term
            for h = 1:P
                first2 = alp .* eta(:, h) .* eta(:, h) .* diag(Km(:, :, h));
                for m = 1:P
                    del2 = (m == h);
                    for f = 1:DG + 1
                        temp2 = repmat((del2 - eta(:, m)) .* loc(:, f), 1, N);
%                         gra2(m, f) = sum(first2 .* diag(temp2 + temp2'));
                        gra2(m, f) = gra2(m, f) + sum(first2 .* diag(temp2 + temp2'));
                    end
                end
            end

gra = gra2 + gra;
                                   
        case {'rbf_softmax', 'rbf'}
            %%% Second Term            
            for h = 1:P
                first = ((alp .* eta(:, h)) * (alp .* eta(:, h))') .* Km(:, :, h);
                for m = 1:P
                    del = (m == h);
%%% w.r.t spread (sigma)
                    temp = repmat((del - eta(:, m)) .* sum(bsxfun(@minus, loc(:, 2:end), gat(m, 2:end)).^2, 2) / gat(m, 1)^3, 1, N);
                    gra(m, 1) = gra(m, 1) - 2 * sum(sum(first .* (temp + temp')));
%%% w.r.t mean (mu)
                    for f = 2:DG + 1
                        temp = repmat((del - eta(:, m)) .* (loc(:, f) - gat(m, f)) / gat(m, 1)^2, 1, N);
                        gra(m, f) = gra(m, f) - 2 * sum(sum(first .* (temp + temp')));
                    end
                end
            end  
			%%%% First Term            
            for h = 1:P
                first2 = alp .* eta(:, h) .* eta(:, h) .* diag(Km(:, :, h));
                for m = 1:P
                    del2 = (m == h);
%%% w.r.t spread (sigma)
                    temp2 = repmat((del2 - eta(:, m)) .* sum(bsxfun(@minus, loc(:, 2:end), gat(m, 2:end)).^2, 2) / gat(m, 1)^3, 1, N);
                    gra2(m, 1) = gra2(m, 1) + 2 * sum(sum(first2 .* diag(temp2 + temp2')));
%%% w.r.t mean (mu)
                    for f = 2:DG + 1
                        temp3 = repmat((del2 - eta(:, m)) .* (loc(:, f) - gat(m, f)) / gat(m, 1)^2, 1, N);
                        gra2(m, f) = gra2(m, f) + 2 * sum(sum(first2 .* diag(temp3 + temp3')));
                    end
                end
            end     
gra = gra2 + gra;
            
    end    
end