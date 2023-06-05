
clc; clear; close all;

addpath('quaternion_library');	% include quaternion library.	计算是按照JPL格式的！注意！（但乘法是对的……）
addpath('utility');				% 自行定义的一些函数
G = 9.81;

filename = "../data/imu1.csv"; % format: ts,wx,wy,wz(rad/s),ax,ay,az(m/s2),q,t

start_time = 12000;
imu = IMU(filename, start_time);
filter = MadgwickAHRS('SamplePeriod', 1/100, 'Beta', 0.3);

euler_est_history = [];
euler_gt_history = [];
while (imu.index < imu.data_length)
	
	[am, wm] = imu.generate_next_imu();
	
	% IMU filter
	filter.UpdateIMU(wm, am/G);
	q_est = filter.Quaternion;
	euler_est = quat2eul(q_est);
	
	% get GT 
	q_gt = imu.getCurTrueQuaternion();
	euler_gt = quat2eul(q_gt);
	
	% save for plot.
	euler_est_history = [euler_est_history; euler_est*180/pi];
	euler_gt_history  = [euler_gt_history;euler_gt*180/pi];
end

%% plot
figure('Name','IMU estimation');
subplot(1,2,1);
plot(euler_est_history(:,1), 'r-'); hold on;
plot(euler_est_history(:,2), 'g-');
plot(euler_est_history(:,3), 'b-'); hold off;
title("Estimate Euler");
legend('Z','Y','X');
xlabel('index');
ylabel('deg');

subplot(1,2,2);
plot(euler_gt_history(:,1), 'r-'); hold on;
plot(euler_gt_history(:,2), 'g-');
plot(euler_gt_history(:,3), 'b-'); hold off;
title("GT Euler");
legend('Z','Y','X');
xlabel('index');
ylabel('deg');

