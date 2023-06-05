% my own function.
function axis = myQuatern2rotAxis(q)
	qw = q(1);
	qx = q(2);
	qy = q(3);
	qz = q(4);
	angle = 2 * acos(qw);
	
	s = sqrt(1-qw*qw);
	if (s < 0.001)		% avoid devided by 0
		x = qx;
		y = qy;
		z = qz;
	else
		x = qx / s;
		y = qy / s;
		z = qz / s;
	end
	axis = [x,y,z]'*angle;
end
