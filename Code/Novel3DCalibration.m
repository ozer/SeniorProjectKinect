fclose all; clear all; close all; clc; format short g;

sample_size = 5;
% ms_tolerance = 5;

meta_data_1 = readtable('metaData1.csv', 'Delimiter', ';',...
    'ReadVariableNames', false);
meta_data_2 = readtable('metaData2.csv', 'Delimiter', ';',...
    'ReadVariableNames', false);

time_1 = meta_data_1.Var1(2:end-1);
time_2 = meta_data_2.Var1(2:end-1);
time_1 = str2double(time_1(:));
time_2 = str2double(time_2(:));

head_1 = meta_data_1.Var2(2:end-1);
head_2 = meta_data_2.Var2(2:end-1);
head_1 = str2double(split(head_1));
head_2 = str2double(split(head_2));

neck_1 = meta_data_1.Var3(2:end-1);
neck_2 = meta_data_2.Var3(2:end-1);
neck_1 = str2double(split(neck_1));
neck_2 = str2double(split(neck_2));

spine_shoulder_1 = meta_data_1.Var4(2:end-1);
spine_shoulder_2 = meta_data_2.Var4(2:end-1);
spine_shoulder_1 = str2double(split(spine_shoulder_1));
spine_shoulder_2 = str2double(split(spine_shoulder_2));

spine_mid_1 = meta_data_1.Var5(2:end-1);
spine_mid_2 = meta_data_2.Var5(2:end-1);
spine_mid_1 = str2double(split(spine_mid_1));
spine_mid_2 = str2double(split(spine_mid_2));

spine_base_1 = meta_data_1.Var6(2:end-1);
spine_base_2 = meta_data_2.Var6(2:end-1);
spine_base_1 = str2double(split(spine_base_1));
spine_base_2 = str2double(split(spine_base_2));

R_shoulder_1 = meta_data_1.Var7(2:end-1);
R_shoulder_2 = meta_data_2.Var7(2:end-1);
R_shoulder_1 = str2double(split(R_shoulder_1));
R_shoulder_2 = str2double(split(R_shoulder_2));

L_shoulder_1 = meta_data_1.Var8(2:end-1);
L_shoulder_2 = meta_data_2.Var8(2:end-1);
L_shoulder_1 = str2double(split(L_shoulder_1));
L_shoulder_2 = str2double(split(L_shoulder_2));

R_elbow_1 = meta_data_1.Var9(2:end-1);
R_elbow_2 = meta_data_2.Var9(2:end-1);
R_elbow_1 = str2double(split(R_elbow_1));
R_elbow_2 = str2double(split(R_elbow_2));

L_elbow_1 = meta_data_1.Var10(2:end-1);
L_elbow_2 = meta_data_2.Var10(2:end-1);
L_elbow_1 = str2double(split(L_elbow_1));
L_elbow_2 = str2double(split(L_elbow_2));

R_wrist_1 = meta_data_1.Var11(2:end-1);
R_wrist_2 = meta_data_2.Var11(2:end-1);
R_wrist_1 = str2double(split(R_wrist_1));
R_wrist_2 = str2double(split(R_wrist_2));

L_wrist_1 = meta_data_1.Var12(2:end-1);
L_wrist_2 = meta_data_2.Var12(2:end-1);
L_wrist_1 = str2double(split(L_wrist_1));
L_wrist_2 = str2double(split(L_wrist_2));

R_hand_1 = meta_data_1.Var13(2:end-1);
R_hand_2 = meta_data_2.Var13(2:end-1);
R_hand_1 = str2double(split(R_hand_1));
R_hand_2 = str2double(split(R_hand_2));

L_hand_1 = meta_data_1.Var14(2:end-1);
L_hand_2 = meta_data_2.Var14(2:end-1);
L_hand_1 = str2double(split(L_hand_1));
L_hand_2 = str2double(split(L_hand_2));

% R_foot_1 = meta_data_1.Var15(2:end-1);
% R_foot_2 = meta_data_2.Var15(2:end-1);
% R_foot_1 = str2double(split(R_foot_1));
% R_foot_2 = str2double(split(R_foot_2));
% 
% L_foot_1 = meta_data_1.Var16(2:end-1);
% L_foot_2 = meta_data_2.Var16(2:end-1);
% L_foot_1 = str2double(split(L_foot_1));
% L_foot_2 = str2double(split(L_foot_2));

R_hand_tip_1 = meta_data_1.Var15(2:end-1);
R_hand_tip_2 = meta_data_2.Var15(2:end-1);
R_hand_tip_1 = str2double(split(R_hand_tip_1));
R_hand_tip_2 = str2double(split(R_hand_tip_2));

L_hand_tip_1 = meta_data_1.Var16(2:end-1);
L_hand_tip_2 = meta_data_2.Var16(2:end-1);
L_hand_tip_1 = str2double(split(L_hand_tip_1));
L_hand_tip_2 = str2double(split(L_hand_tip_2));

R_thumb_1 = meta_data_1.Var17(2:end-1);
R_thumb_2 = meta_data_2.Var17(2:end-1);
R_thumb_1 = str2double(split(R_thumb_1));
R_thumb_2 = str2double(split(R_thumb_2));

L_thumb_1 = meta_data_1.Var18(2:end-1);
L_thumb_2 = meta_data_2.Var18(2:end-1);
L_thumb_1 = str2double(split(L_thumb_1));
L_thumb_2 = str2double(split(L_thumb_2));

R_hip_1 = meta_data_1.Var19(2:end-1);
R_hip_2 = meta_data_2.Var19(2:end-1);
R_hip_1 = str2double(split(R_hip_1));
R_hip_2 = str2double(split(R_hip_2));

L_hip_1 = meta_data_1.Var20(2:end-1);
L_hip_2 = meta_data_2.Var20(2:end-1);
L_hip_1 = str2double(split(L_hip_1));
L_hip_2 = str2double(split(L_hip_2));

R_knee_1 = meta_data_1.Var21(2:end-1);
R_knee_2 = meta_data_2.Var21(2:end-1);
R_knee_1 = str2double(split(R_knee_1));
R_knee_2 = str2double(split(R_knee_2));

L_knee_1 = meta_data_1.Var22(2:end-1);
L_knee_2 = meta_data_2.Var22(2:end-1);
L_knee_1 = str2double(split(L_knee_1));
L_knee_2 = str2double(split(L_knee_2));

R_ankle_1 = meta_data_1.Var23(2:end-1);
R_ankle_2 = meta_data_2.Var23(2:end-1);
R_ankle_1 = str2double(split(R_ankle_1));
R_ankle_2 = str2double(split(R_ankle_2));

L_ankle_1 = meta_data_1.Var24(2:end-1);
L_ankle_2 = meta_data_2.Var24(2:end-1);
L_ankle_1 = str2double(split(L_ankle_1));
L_ankle_2 = str2double(split(L_ankle_2));

R_foot_1 = meta_data_1.Var25(2:end-1);
R_foot_2 = meta_data_2.Var25(2:end-1);
R_foot_1 = str2double(split(R_foot_1));
R_foot_2 = str2double(split(R_foot_2));

L_foot_1 = meta_data_1.Var26(2:end-1);
L_foot_2 = meta_data_2.Var26(2:end-1);
L_foot_1 = str2double(split(L_foot_1));
L_foot_2 = str2double(split(L_foot_2));


time_init_min = [time_1(1), time_2(1)];
[~,time_init_ind]  = min(time_init_min);

if time_init_ind == 1
    
    time_init_d = sort(abs(time_1 - time_2(1)));
    time_init_d_ind = find(abs(time_1 - time_2(1)) == time_init_d(1));
    
    time_1 = time_1(time_init_d_ind:end,:);
    
    
    time_end_min = [numel(time_1), numel(time_2)];
    [time_end, time_end_ind]  = min(time_end_min);
    
    time_1 = time_1(1:time_end,:);
    head_1 = head_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    neck_1 = neck_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    spine_shoulder_1 = spine_shoulder_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    spine_mid_1 = spine_mid_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    spine_base_1 = spine_base_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_shoulder_1 = R_shoulder_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_shoulder_1 = L_shoulder_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_elbow_1 = R_elbow_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_elbow_1 = L_elbow_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_wrist_1 = R_wrist_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_wrist_1 = L_wrist_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_hand_1 = R_hand_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_hand_1 = L_hand_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_hand_tip_1 = R_hand_tip_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_hand_tip_1 = L_hand_tip_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_thumb_1 = R_thumb_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_thumb_1 = L_thumb_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_hip_1 = R_hip_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_hip_1 = L_hip_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_knee_1 = R_knee_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_knee_1 = L_knee_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_ankle_1 = R_ankle_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_ankle_1 = L_ankle_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_foot_1 = R_foot_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_foot_1 = L_foot_1(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    
    time_2 = time_2(1:time_end,:);
    head_2 = head_2(1:time_end,:);
    neck_2 = neck_2(1:time_end,:);
    spine_shoulder_2 = spine_shoulder_2(1:time_end,:);
    spine_mid_2 = spine_mid_2(1:time_end,:);
    spine_base_2 = spine_base_2(1:time_end,:);
    R_shoulder_2 = R_shoulder_2(1:time_end,:);
    L_shoulder_2 = L_shoulder_2(1:time_end,:);
    R_elbow_2 = R_elbow_2(1:time_end,:);
    L_elbow_2 = L_elbow_2(1:time_end,:);
    R_wrist_2 = R_wrist_2(1:time_end,:);
    L_wrist_2 = L_wrist_2(1:time_end,:);
    R_hand_2 = R_hand_2(1:time_end,:);
    L_hand_2 = L_hand_2(1:time_end,:);
    R_hand_tip_2 = R_hand_tip_2(1:time_end,:);
    L_hand_tip_2 = L_hand_tip_2(1:time_end,:);
    R_thumb_2 = R_thumb_2(1:time_end,:);
    L_thumb_2 = L_thumb_2(1:time_end,:);
    R_hip_2 = R_hip_2(1:time_end,:);
    L_hip_2 = L_hip_2(1:time_end,:);
    R_knee_2 = R_knee_2(1:time_end,:);
    L_knee_2 = L_knee_2(1:time_end,:);
    R_ankle_2 = R_ankle_2(1:time_end,:);
    L_ankle_2 = L_ankle_2(1:time_end,:);
    R_foot_2 = R_foot_2(1:time_end,:);
    L_foot_2 = L_foot_2(1:time_end,:);
    
else
    
    time_init_d = sort(abs(time_2 - time_1(1)));
    time_init_d_ind = find(abs(time_2 - time_1(1)) == time_init_d(1));
    
    time_2 = time_2(time_init_d_ind:end,:);
    
    time_end_min = [numel(time_1), numel(time_2)];
    [time_end, time_end_ind]  = min(time_end_min);
    
    time_1 = time_1(1:time_end,:);
    head_1 = head_1(1:time_end,:);
    neck_1 = neck_1(1:time_end,:);
    spine_shoulder_1 = spine_shoulder_1(1:time_end,:);
    spine_mid_1 = spine_mid_1(1:time_end,:);
    spine_base_1 = spine_base_1(1:time_end,:);
    R_shoulder_1 = R_shoulder_1(1:time_end,:);
    L_shoulder_1 = L_shoulder_1(1:time_end,:);
    R_elbow_1 = R_elbow_1(1:time_end,:);
    L_elbow_1 = L_elbow_1(1:time_end,:);
    R_wrist_1 = R_wrist_1(1:time_end,:);
    L_wrist_1 = L_wrist_1(1:time_end,:);
    R_hand_1 = R_hand_1(1:time_end,:);
    L_hand_1 = L_hand_1(1:time_end,:);
    R_hand_tip_1 = R_hand_tip_1(1:time_end,:);
    L_hand_tip_1 = L_hand_tip_1(1:time_end,:);
    R_thumb_1 = R_thumb_1(1:time_end,:);
    L_thumb_1 = L_thumb_1(1:time_end,:);
    R_hip_1 = R_hip_1(1:time_end,:);
    L_hip_1 = L_hip_1(1:time_end,:);
    R_knee_1 = R_knee_1(1:time_end,:);
    L_knee_1 = L_knee_1(1:time_end,:);
    R_ankle_1 = R_ankle_1(1:time_end,:);
    L_ankle_1 = L_ankle_1(1:time_end,:);
    R_foot_1 = R_foot_1(1:time_end,:);
    L_foot_1 = L_foot_1(1:time_end,:);
    
    time_2 = time_2(1:time_end,:);
    head_2 = head_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    neck_2 = neck_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    spine_shoulder_2 = spine_shoulder_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    spine_mid_2 = spine_mid_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    spine_base_2 = spine_base_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_shoulder_2 = R_shoulder_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_shoulder_2 = L_shoulder_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_elbow_2 = R_elbow_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_elbow_2 = L_elbow_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_wrist_2 = R_wrist_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_wrist_2 = L_wrist_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_hand_2 = R_hand_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_hand_2 = L_hand_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_hand_tip_2 = R_hand_tip_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_hand_tip_2 = L_hand_tip_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_thumb_2 = R_thumb_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_thumb_2 = L_thumb_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_hip_2 = R_hip_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_hip_2 = L_hip_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_knee_2 = R_knee_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_knee_2 = L_knee_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_ankle_2 = R_ankle_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_ankle_2 = L_ankle_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    R_foot_2 = R_foot_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    L_foot_2 = L_foot_2(time_init_d_ind:time_init_d_ind + time_end - 1,:);
    
end

head_1_avg = transpose(sum(head_1(1:sample_size,:),1)/sample_size);
neck_1_avg = transpose(sum(neck_1(1:sample_size,:),1)/sample_size);
spine_shoulder_1_avg = transpose(sum(spine_shoulder_1(1:sample_size,:),1)/sample_size);
spine_mid_1_avg = transpose(sum(spine_mid_1(1:sample_size,:),1)/sample_size);
spine_base_1_avg = transpose(sum(spine_base_1(1:sample_size,:),1)/sample_size);
R_shoulder_1_avg = transpose(sum(R_shoulder_1(1:sample_size,:),1)/sample_size);
L_shoulder_1_avg = transpose(sum(L_shoulder_1(1:sample_size,:),1)/sample_size);
R_elbow_1_avg = transpose(sum(R_elbow_1(1:sample_size,:),1)/sample_size);
L_elbow_1_avg = transpose(sum(L_elbow_1(1:sample_size,:),1)/sample_size);
R_wrist_1_avg = transpose(sum(R_wrist_1(1:sample_size,:),1)/sample_size);
L_wrist_1_avg = transpose(sum(L_wrist_1(1:sample_size,:),1)/sample_size);
R_hand_1_avg = transpose(sum(R_hand_1(1:sample_size,:),1)/sample_size);
L_hand_1_avg = transpose(sum(L_hand_1(1:sample_size,:),1)/sample_size);
R_hand_tip_1_avg = transpose(sum(R_hand_tip_1(1:sample_size,:),1)/sample_size);
L_hand_tip_1_avg = transpose(sum(L_hand_tip_1(1:sample_size,:),1)/sample_size);
R_thumb_1_avg = transpose(sum(R_thumb_1(1:sample_size,:),1)/sample_size);
L_thumb_1_avg = transpose(sum(L_thumb_1(1:sample_size,:),1)/sample_size);
R_hip_1_avg = transpose(sum(R_hip_1(1:sample_size,:),1)/sample_size);
L_hip_1_avg = transpose(sum(L_hip_1(1:sample_size,:),1)/sample_size);
R_knee_1_avg = transpose(sum(R_knee_1(1:sample_size,:),1)/sample_size);
L_knee_1_avg = transpose(sum(L_knee_1(1:sample_size,:),1)/sample_size);
R_ankle_1_avg = transpose(sum(R_ankle_1(1:sample_size,:),1)/sample_size);
L_ankle_1_avg = transpose(sum(L_ankle_1(1:sample_size,:),1)/sample_size);
R_foot_1_avg = transpose(sum(R_foot_1(1:sample_size,:),1)/sample_size);
L_foot_1_avg = transpose(sum(L_foot_1(1:sample_size,:),1)/sample_size);

head_2_avg = transpose(sum(head_2(1:sample_size,:),1)/sample_size);
neck_2_avg = transpose(sum(neck_2(1:sample_size,:),1)/sample_size);
spine_shoulder_2_avg = transpose(sum(spine_shoulder_2(1:sample_size,:),1)/sample_size);
spine_mid_2_avg = transpose(sum(spine_mid_2(1:sample_size,:),1)/sample_size);
spine_base_2_avg = transpose(sum(spine_base_2(1:sample_size,:),1)/sample_size);
R_shoulder_2_avg = transpose(sum(R_shoulder_2(1:sample_size,:),1)/sample_size);
L_shoulder_2_avg = transpose(sum(L_shoulder_2(1:sample_size,:),1)/sample_size);
R_elbow_2_avg = transpose(sum(R_elbow_2(1:sample_size,:),1)/sample_size);
L_elbow_2_avg = transpose(sum(L_elbow_2(1:sample_size,:),1)/sample_size);
R_wrist_2_avg = transpose(sum(R_wrist_2(1:sample_size,:),1)/sample_size);
L_wrist_2_avg = transpose(sum(L_wrist_2(1:sample_size,:),1)/sample_size);
R_hand_2_avg = transpose(sum(R_hand_2(1:sample_size,:),1)/sample_size);
L_hand_2_avg = transpose(sum(L_hand_2(1:sample_size,:),1)/sample_size);
R_hand_tip_2_avg = transpose(sum(R_hand_tip_2(1:sample_size,:),1)/sample_size);
L_hand_tip_2_avg = transpose(sum(L_hand_tip_2(1:sample_size,:),1)/sample_size);
R_thumb_2_avg = transpose(sum(R_thumb_2(1:sample_size,:),1)/sample_size);
L_thumb_2_avg = transpose(sum(L_thumb_2(1:sample_size,:),1)/sample_size);
R_hip_2_avg = transpose(sum(R_hip_2(1:sample_size,:),1)/sample_size);
L_hip_2_avg = transpose(sum(L_hip_2(1:sample_size,:),1)/sample_size);
R_knee_2_avg = transpose(sum(R_knee_2(1:sample_size,:),1)/sample_size);
L_knee_2_avg = transpose(sum(L_knee_2(1:sample_size,:),1)/sample_size);
R_ankle_2_avg = transpose(sum(R_ankle_2(1:sample_size,:),1)/sample_size);
L_ankle_2_avg = transpose(sum(L_ankle_2(1:sample_size,:),1)/sample_size);
R_foot_2_avg = transpose(sum(R_foot_2(1:sample_size,:),1)/sample_size);
L_foot_2_avg = transpose(sum(L_foot_2(1:sample_size,:),1)/sample_size);

% data_1 = cat(2, head_1_avg, neck_1_avg, spine_shoulder_1_avg, spine_mid_1_avg, spine_base_1_avg,...
%     R_shoulder_1_avg, L_shoulder_1_avg, R_elbow_1_avg, L_elbow_1_avg, R_wrist_1_avg, L_wrist_1_avg,...
%     R_hand_1_avg, L_hand_1_avg, R_foot_1_avg, L_foot_1_avg);
% data_1 = cat(1, data_1, ones(1, size(data_1, 2)));
% 
% data_2 = cat(2, head_2_avg, neck_2_avg, spine_shoulder_2_avg, spine_mid_2_avg, spine_base_2_avg,...
%     R_shoulder_2_avg, L_shoulder_2_avg, R_elbow_2_avg, L_elbow_2_avg, R_wrist_2_avg, L_wrist_2_avg,...
%     R_hand_2_avg, L_hand_2_avg, R_foot_2_avg, L_foot_2_avg);

data_1 = cat(2, head_1_avg, neck_1_avg, spine_shoulder_1_avg, spine_mid_1_avg, spine_base_1_avg,...
    R_shoulder_1_avg, L_shoulder_1_avg, R_elbow_1_avg, L_elbow_1_avg, R_wrist_1_avg, L_wrist_1_avg,...
    R_hand_1_avg, L_hand_1_avg, R_hand_tip_1_avg, L_hand_tip_1_avg, R_thumb_1_avg, L_thumb_1_avg, ...
    R_hip_1_avg, L_hip_1_avg, R_knee_1_avg, L_knee_1_avg, R_ankle_1_avg, L_ankle_1_avg, R_foot_1_avg, ...
    L_foot_1_avg);
data_1 = cat(1, data_1, ones(1, size(data_1, 2)));

data_2 = cat(2, head_2_avg, neck_2_avg, spine_shoulder_2_avg, spine_mid_2_avg, spine_base_2_avg,...
    R_shoulder_2_avg, L_shoulder_2_avg, R_elbow_2_avg, L_elbow_2_avg, R_wrist_2_avg, L_wrist_2_avg,...
    R_hand_2_avg, L_hand_2_avg, R_hand_tip_2_avg, L_hand_tip_2_avg, R_thumb_2_avg, L_thumb_2_avg, ...
    R_hip_2_avg, L_hip_2_avg, R_knee_2_avg, L_knee_2_avg, R_ankle_2_avg, L_ankle_2_avg, R_foot_2_avg, ...
    L_foot_2_avg);

data_2 = cat(1, data_2, ones(1, size(data_2, 2)));

H = (data_1*transpose(data_2))*(inv(data_2*transpose(data_2)));

y_head_1 = [transpose(head_1(1,:)); 1];
y_head_2 = [transpose(head_2(1,:)); 1];
y_head_1_pred = H * y_head_2;