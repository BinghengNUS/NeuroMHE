%This m-file is used to compute the residual force and show the effect of the mass value on the computation results
clear
load('bemnn20210223225417seg1.mat')
m                = 0.752; %as used in the NeuroBEM paper
m_updated        = 0.772; %as updated in the NeuroBEM's website https://rpg.ifi.uzh.ch/neuro_bem/Readme.html
J                = diag([0.0025,0.0021,0.0043]);
[r,c]            = size(bemnn20210223225417seg1);
resi_f           = zeros(r,3);
e_resi_f         = zeros(r,3); % difference between the computed and provided residual force
resi_f_updated   = zeros(r,3);
e_resi_f_updated = zeros(r,3); % difference between the updated and provided residual force
for i=1:1:r
    acc_p                 = bemnn20210223225417seg1(i,12:14).';
    acc_w                 = bemnn20210223225417seg1(i,2:4).';
    w                     = bemnn20210223225417seg1(i,5:7).';
    [f,tau]               = ground_truth(w,acc_p,acc_w,m,J);
    [f_updated,tau]       = ground_truth(w,acc_p,acc_w,m_updated,J);
    f_bemnn               = bemnn20210223225417seg1(i,30:32);
    resi_f(i,:)           = f.'- f_bemnn;
    resi_f_updated(i,:)   = f_updated.' - f_bemnn;
    resi_f_bemnn          = bemnn20210223225417seg1(i,36:38);
    e_resi_f(i,:)         = resi_f(i,:) - resi_f_bemnn;
    e_resi_f_updated(i,:) = resi_f_updated(i,:) - resi_f_bemnn;
end
%Root-mean-square-error (RMSE) of NeuroBEM for total force prediction (vector error)
rmse_bemnn         = round(sqrt(mean(vecnorm(resi_f,2,2).^2)),3); % computed using m=0.752
rmse_bemnn_updated = round(sqrt(mean(vecnorm(resi_f_updated,2,2).^2)),3); % computed using m=0.772
