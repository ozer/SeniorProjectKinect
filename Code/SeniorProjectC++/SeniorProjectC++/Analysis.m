fclose all; clear all; close all; clc;

meta_data = readtable('metaData.csv', 'Delimiter', ';',...
    'ReadVariableNames', false);

% Reading each and every body joint locations from the acquired dataset,
% with exception of the first and the last frame to overcome the writing
% disorders.

time = meta_data.Var1(2:end-1);
% time = str2double(time(:));
body_joints = struct;
body_joints.head = meta_data.Var2(2:end-1);
body_joints.head = str2double(split(body_joints.head));

body_joints.neck = meta_data.Var3(2:end-1);
body_joints.neck = str2double(split(body_joints.neck));

body_joints.spine_shoulder = meta_data.Var4(2:end-1);
body_joints.spine_shoulder = str2double(split(body_joints.spine_shoulder));

body_joints.spine_mid = meta_data.Var5(2:end-1);
body_joints.spine_mid = str2double(split(body_joints.spine_mid));

body_joints.spine_base = meta_data.Var6(2:end-1);
body_joints.spine_base = str2double(split(body_joints.spine_base));

body_joints.R_shoulder = meta_data.Var7(2:end-1);
body_joints.R_shoulder = str2double(split(body_joints.R_shoulder));

body_joints.L_shoulder = meta_data.Var8(2:end-1);
body_joints.L_shoulder = str2double(split(body_joints.L_shoulder));

body_joints.R_elbow = meta_data.Var9(2:end-1);
body_joints.R_elbow = str2double(split(body_joints.R_elbow));

body_joints.L_elbow = meta_data.Var10(2:end-1);
body_joints.L_elbow = str2double(split(body_joints.L_elbow));

body_joints.R_wrist = meta_data.Var11(2:end-1);
body_joints.R_wrist = str2double(split(body_joints.R_wrist));

body_joints.L_wrist = meta_data.Var12(2:end-1);
body_joints.L_wrist = str2double(split(body_joints.L_wrist));

body_joints.R_hand = meta_data.Var13(2:end-1);
body_joints.R_hand = str2double(split(body_joints.R_hand));

body_joints.L_hand = meta_data.Var14(2:end-1);
body_joints.L_hand = str2double(split(body_joints.L_hand));

body_joints.R_hand_tip = meta_data.Var15(2:end-1);
body_joints.R_hand_tip = str2double(split(body_joints.R_hand_tip));

body_joints.L_hand_tip = meta_data.Var16(2:end-1);
body_joints.L_hand_tip = str2double(split(body_joints.L_hand_tip));

body_joints.R_thumb = meta_data.Var17(2:end-1);
body_joints.R_thumb = str2double(split(body_joints.R_thumb));

body_joints.L_thumb = meta_data.Var18(2:end-1);
body_joints.L_thumb = str2double(split(body_joints.L_thumb));

body_joints.R_hip = meta_data.Var19(2:end-1);
body_joints.R_hip = str2double(split(body_joints.R_hip));

body_joints.L_hip = meta_data.Var20(2:end-1);
body_joints.L_hip = str2double(split(body_joints.L_hip));

body_joints.R_knee = meta_data.Var21(2:end-1);
body_joints.R_knee = str2double(split(body_joints.R_knee));

body_joints.L_knee = meta_data.Var22(2:end-1);
body_joints.L_knee = str2double(split(body_joints.L_knee));

body_joints.R_ankle = meta_data.Var23(2:end-1);
body_joints.R_ankle = str2double(split(body_joints.R_ankle));

body_joints.L_ankle = meta_data.Var24(2:end-1);
body_joints.L_ankle = str2double(split(body_joints.L_ankle));

body_joints.R_foot = meta_data.Var25(2:end-1);
body_joints.R_foot = str2double(split(body_joints.R_foot));

body_joints.L_foot = meta_data.Var26(2:end-1);
body_joints.L_foot = str2double(split(body_joints.L_foot));

% Rotation
neck_bone = struct;
neck_bone.direction = body_joints.head - body_joints.neck;
neck_bone.norm = sqrt(sum(neck_bone.direction.^2,2));
neck_bone.rotation = [acosd(neck_bone.direction(:,1)./neck_bone.norm(:)),...
    acosd(neck_bone.direction(:,2)./neck_bone.norm(:)), acosd(neck_bone.direction(:,3)./neck_bone.norm(:))];

sternum_bone = struct;
sternum_bone.direction = body_joints.spine_shoulder - body_joints.spine_mid;
sternum_bone.norm = sqrt(sum(sternum_bone.direction.^2,2));
sternum_bone.rotation = [acosd(sternum_bone.direction(:,1)./sternum_bone.norm(:)),...
    acosd(sternum_bone.direction(:,2)./sternum_bone.norm(:)), acosd(sternum_bone.direction(:,3)./sternum_bone.norm(:))];

R_upper_arm_bone = struct;
R_upper_arm_bone.direction = body_joints.R_elbow - body_joints.R_shoulder;
R_upper_arm_bone.norm = sqrt(sum(R_upper_arm_bone.direction.^2,2));
R_upper_arm_bone.rotation = [acosd(R_upper_arm_bone.direction(:,1)./R_upper_arm_bone.norm(:)),...
    acosd(R_upper_arm_bone.direction(:,2)./R_upper_arm_bone.norm(:)), acosd(R_upper_arm_bone.direction(:,3)./R_upper_arm_bone.norm(:))];

L_upper_arm_bone = struct;
L_upper_arm_bone.direction = body_joints.L_elbow - body_joints.L_shoulder;
L_upper_arm_bone.norm = sqrt(sum(L_upper_arm_bone.direction.^2,2));
L_upper_arm_bone.rotation = [acosd(L_upper_arm_bone.direction(:,1)./L_upper_arm_bone.norm(:)),...
    acosd(L_upper_arm_bone.direction(:,2)./L_upper_arm_bone.norm(:)), acosd(L_upper_arm_bone.direction(:,3)./L_upper_arm_bone.norm(:))];

R_lower_arm_bone = struct;
R_lower_arm_bone.direction = body_joints.R_wrist - body_joints.R_elbow;
R_lower_arm_bone.norm = sqrt(sum(R_lower_arm_bone.direction.^2,2));
R_lower_arm_bone.rotation = [acosd(R_lower_arm_bone.direction(:,1)./R_lower_arm_bone.norm(:)),...
    acosd(R_lower_arm_bone.direction(:,2)./R_lower_arm_bone.norm(:)), acosd(R_lower_arm_bone.direction(:,3)./R_lower_arm_bone.norm(:))];

L_lower_arm_bone = struct;
L_lower_arm_bone.direction = body_joints.L_wrist - body_joints.L_elbow;
L_lower_arm_bone.norm = sqrt(sum(L_lower_arm_bone.direction.^2,2));
L_lower_arm_bone.rotation = [acosd(L_lower_arm_bone.direction(:,1)./L_lower_arm_bone.norm(:)),...
    acosd(L_lower_arm_bone.direction(:,2)./L_lower_arm_bone.norm(:)), acosd(L_lower_arm_bone.direction(:,3)./L_lower_arm_bone.norm(:))];

R_hand_bone = struct;
R_hand_bone.direction = body_joints.R_hand - body_joints.R_wrist;
R_hand_bone.norm = sqrt(sum(R_hand_bone.direction.^2,2));
R_hand_bone.rotation = [acosd(R_hand_bone.direction(:,1)./R_hand_bone.norm(:)),...
    acosd(R_hand_bone.direction(:,2)./R_hand_bone.norm(:)), acosd(R_hand_bone.direction(:,3)./R_hand_bone.norm(:))];

L_hand_bone = struct;
L_hand_bone.direction = body_joints.L_hand - body_joints.L_wrist;
L_hand_bone.norm = sqrt(sum(L_hand_bone.direction.^2,2));
L_hand_bone.rotation = [acosd(L_hand_bone.direction(:,1)./L_hand_bone.norm(:)),...
    acosd(L_hand_bone.direction(:,2)./L_hand_bone.norm(:)), acosd(L_hand_bone.direction(:,3)./L_hand_bone.norm(:))];

R_hand_tip_bone = struct;
R_hand_tip_bone.direction = body_joints.R_hand_tip - body_joints.R_hand;
R_hand_tip_bone.norm = sqrt(sum(R_hand_tip_bone.direction.^2,2));
R_hand_tip_bone.rotation = [acosd(R_hand_tip_bone.direction(:,1)./R_hand_tip_bone.norm(:)),...
    acosd(R_hand_tip_bone.direction(:,2)./R_hand_tip_bone.norm(:)), acosd(R_hand_tip_bone.direction(:,3)./R_hand_tip_bone.norm(:))];

L_hand_tip_bone = struct;
L_hand_tip_bone.direction = body_joints.L_hand_tip - body_joints.L_hand;
L_hand_tip_bone.norm = sqrt(sum(L_hand_tip_bone.direction.^2,2));
L_hand_tip_bone.rotation = [acosd(L_hand_tip_bone.direction(:,1)./L_hand_tip_bone.norm(:)),...
    acosd(L_hand_tip_bone.direction(:,2)./L_hand_tip_bone.norm(:)), acosd(L_hand_tip_bone.direction(:,3)./L_hand_tip_bone.norm(:))];

% Attributes
attributes = struct;

attributes.R_hand_dis = time(1:end-1);
attributes.R_hand_vel = time(1:end-1);
attributes.R_hand_acl = time(1:end-2);

attributes.L_hand_dis = time(1:end-1);
attributes.L_hand_vel = time(1:end-1);
attributes.L_hand_acl = time(1:end-2);

attributes.spine_mid_dis = time(1:end-1);
attributes.spine_mid_vel = time(1:end-1);
attributes.spine_mid_acl = time(1:end-2);

% displacement and velocity
for ind=1:size(time,1)-1

        t_dif = time(ind+1)-time(ind);
        
        attributes.R_hand_dis(ind) = norm(abs(body_joints.R_hand(ind+1,:)-body_joints.R_hand(ind,:)));
        attributes.R_hand_vel(ind) = attributes.R_hand_dis(ind)/(t_dif/1000);
        
        attributes.L_hand_dis(ind) = norm(abs(body_joints.L_hand(ind+1,:)-body_joints.L_hand(ind,:)));
        attributes.L_hand_vel(ind) = attributes.L_hand_dis(ind)/(t_dif/1000); 
        
        attributes.spine_mid_dis(ind) = norm(abs(body_joints.spine_mid(ind+1,:)-body_joints.spine_mid(ind,:)));
        attributes.spine_mid_vel(ind) = attributes.spine_mid_dis(ind)/(t_dif/1000); 
end

% acceleration
for ind=1:size(time,1)-2

        t_dif = time(ind+1)-time(ind);
        
        attributes.R_hand_acl(ind) = abs(attributes.R_hand_vel(ind+1)-attributes.R_hand_vel(ind))/(t_dif/1000);
        attributes.L_hand_acl(ind) = abs(attributes.L_hand_vel(ind+1)-attributes.L_hand_vel(ind))/(t_dif/1000);
        attributes.spine_mid_acl(ind) = abs(attributes.spine_mid_vel(ind+1)-attributes.spine_mid_vel(ind))/(t_dif/1000);
end

attributes.lean = sternum_bone.rotation(:,2);

% Trajectory
figure(1);
scatter3(body_joints.R_hand(:,1), body_joints.R_hand(:,3), body_joints.R_hand(:,2), 40, [1:1:size(time,1)], '.');
title('Trajectory in Metres wrt. Frame (time)'); xlabel('x (m)'); ylabel('z (m)'); zlabel('y (m)');
xlim([-1.2, 1.2]);  ylim([0 4]); zlim([-1.5, 1.5]);
colormap('winter'); colorbar;
hold on;
scatter3(body_joints.head(:,1), body_joints.head(:,3), body_joints.head(:,2), 26, [1:1:size(time,1)], '^');
hold on;
scatter3(body_joints.R_foot(:,1), body_joints.R_foot(:,3), body_joints.R_foot(:,2), 26, [1:1:size(time,1)], '<');
hold on;
scatter3(body_joints.L_foot(:,1), body_joints.L_foot(:,3), body_joints.L_foot(:,2), 26, [1:1:size(time,1)], '>');
hold on;
scatter3(zeros(size(time,1),1), zeros(size(time,1),1), zeros(size(time,1),1), 150, [1:1:size(time,1)], 's', 'red');
hold on;
scatter3(zeros(size(time,1),1), 0.025*ones(size(time,1),1), zeros(size(time,1),1),  400, [1:1:size(time,1)], 's', 'red');
legend('Right Hand', 'Head', 'Right Foot', 'Left Foot', 'Kinect');

avg_lean = mean(attributes.lean(:));
avg_dis = mean(attributes.R_hand_dis(:));
avg_vel = mean(attributes.R_hand_vel(:));
avg_acl = mean(attributes.R_hand_acl(:));
avg_x_rot = mean(R_upper_arm_bone.rotation(:,1));
avg_y_rot = mean(R_upper_arm_bone.rotation(:,2));
avg_z_rot = mean(R_upper_arm_bone.rotation(:,3));

% %%
% t_frame =[find(time == 1527186610682), find(time == 1527186610915), find(time == 1527186611149), find(time == 1527186611347),...
%     find(time == 1527186611549), find(time == 1527186611751), find(time == 1527186611983), find(time == 1527186612183)...
%     find(time == 1527186612416), find(time == 1527186612616), find(time == 1527186612815)];
% t_frame = t_frame + 4;
% 
% avg_lean_t = mean(attributes.lean(t_frame))
% avg_dis_t = mean(attributes.R_hand_dis(t_frame))
% avg_vel_t = mean(attributes.R_hand_vel(t_frame))
% avg_acl_t = mean(attributes.R_hand_acl(t_frame))
% rot_t = R_upper_arm_bone.rotation(t_frame, :)
% 
% % Trajectory
% figure(1);
% scatter3(body_joints.R_hand(t_frame,1), body_joints.R_hand(t_frame,3),...
%     body_joints.R_hand(t_frame,2), 40, [1:1:size(time(t_frame),1)], '.');
% title('Trajectory in Metres wrt. Frame (time)'); xlabel('x (m)'); ylabel('z (m)'); zlabel('y (m)');
% xlim([-1.2, 1.2]);  ylim([0 4]); zlim([-1.5, 1.5]);
% colormap('winter'); colorbar;
% hold on;
% scatter3(body_joints.head(t_frame,1), body_joints.head(t_frame,3), body_joints.head(t_frame,2), 26, [1:1:size(time(t_frame),1)], '^');
% hold on;
% scatter3(body_joints.R_foot(t_frame,1), body_joints.R_foot(t_frame,3), body_joints.R_foot(t_frame,2), 26, [1:1:size(time(t_frame),1)], '<');
% hold on;
% scatter3(body_joints.L_foot(t_frame,1), body_joints.L_foot(t_frame,3), body_joints.L_foot(t_frame,2), 26, [1:1:size(time(t_frame),1)], '>');
% hold on;
% scatter3(zeros(size(time(t_frame),1),1), zeros(size(time(t_frame),1),1), zeros(size(time(t_frame),1),1), 150, [1:1:size(time(t_frame),1)], 's', 'red');
% hold on;
% scatter3(zeros(size(time(t_frame),1),1), 0.025*ones(size(time(t_frame),1),1), zeros(size(time(t_frame),1),1),  400, [1:1:size(time(t_frame),1)], 's', 'red');
% legend('Right Hand', 'Head', 'Right Foot', 'Left Foot', 'Kinect');