 clearvars -except a b res_all data_num path res_acc res_gmean req_final_kernel req_final_gm req_final_acc req_final_sv req_final_std req_final_all req_final_std_all REQ_ALL REQ_STD_ALL REQ_KERNEL REQ_ACC REQ_GM REQ_SV REQ_STD; 
 if data_num==1
    
    dname = 'iris';
    dnames = [path dname];
end

if data_num==2
     
    dname = 'iono';
    dnames = [path dname];
end

if data_num==3
     
    dname = 'pima';
    dnames = [path dname];
end

if data_num==4
     
    dname = 'bupa';
    dnames = [path dname];
end

if data_num==5
     
    dname = 'spam';
    dnames = [path dname];
end    
if data_num==6
     
    dname = 'bana';
    dnames = [path dname];    
end
if data_num==7
     
    dname = 'wdbc';
    dnames = [path dname];    
end

if data_num==8
     
    dname = 'germ';
    dnames = [path dname];    
end
if data_num==9
     
    dname = 'aust';
    dnames = [path dname];    
end

if data_num==10
     
    dname = 'japa';
    dnames = [path dname];    
end
if data_num==11
     
    dname = 'heart';
    dnames = [path dname];    
end
if data_num==12
     
    dname = 'park';
    dnames = [path dname];    
end
if data_num==13
     
    dname = 'abal';
    dnames = [path dname];    
end
if data_num==14
     
    dname = 'spam';
    dnames = [path dname];    
end
if data_num==15
     
    dname = 'wave';
    dnames = [path dname];    
end
if data_num==16
     
    dname = 'space_ga';
    dnames = [path dname];    
end
