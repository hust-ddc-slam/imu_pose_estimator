classdef IMU < handle
	properties
		ts
		accs
		gyros
		data_length
		
		gt_p				% position in world (gt)
		gt_q				% rotation in world (gt)
		gt_euler

		index
	end
	
	methods
		function obj = IMU(filename, begin_ts_ms)
			fprintf("--> Load IMU data from: %s \n", filename);
			data = readmatrix(filename);
			ts = data(1:end, 1);
			if(nargin == 1)
				begin_ts_ms = 0;
			end
			line0 = sum(ts<begin_ts_ms) + 1;			% 从第 line0 行开始读取，保证相同时间戳；
			obj.ts = data(line0:end, 1);
			obj.accs = data(line0:end, 5:7);		% unit: m/s2
			obj.gyros = data(line0:end, 2:4);		% unit: rad/s
			obj.gt_p = data(line0:end, 8:10);		% unit: m
			obj.gt_q = data(line0:end, 11:14);		% unit quaternion
			obj.gt_euler = myQuatern2Eulers(obj.gt_q);
			obj.data_length = length(obj.ts);
			obj.index = line0;
			fprintf("<-- Loaded IMU data: %d \n", length(obj.accs));
		end
		
		function [a, w] = generate_next_imu(obj)
			obj.index = obj.index + 1;
			a = obj.accs(obj.index,:)';
			w = obj.gyros(obj.index,:)';
		end
		
		function resetIndex(obj)
			obj.index = 0;
		end


		% 获取当前index的position和quaternion
		function p = getCurTruePosition(obj)
			p = obj.gt_p(obj.index, :);
		end
		function q = getCurTrueQuaternion(obj)
			q = obj.gt_q(obj.index, :);
		end

		function poses = getAllPoses(obj, type)
			if (type == "euler")
				poses = [obj.gt_p, obj.gt_euler];
			elseif (type == "quart")
				fprintf("Not support QUATERNION! gt_q not implemented. \n");
			else
				fprintf("Error. Not a valid type: %s \n", type);
			end
		end

	end
end

