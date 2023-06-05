
function eulers = myQuatern2Eulers(quats, type)
	% 四元数（N*4）转欧拉角（N*3）
	[N, col] = size(quats);
	assert(col==4);
	
	eulers = zeros(N,3);
	for i=1:N
		q = quats(i,:);
		e = quat2eul(q);
		eulers(i,:) = e;
	end
	if(nargin==1)
		type = "rad";
	end
	if(type == "deg")
		eulers = eulers * 180/pi;
	end
end

