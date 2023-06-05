function euler_zyx = myQuatern2Euler(q)

	qw = q(1);
	qx = q(2);
	qy = q(3);
	qz = q(4);

	phi = atan2(2*(qw*qx + qy*qz), 1-2*(qx^2 + qy^2));
	theta = -pi/2 + 2*atan2(sqrt(1+2*(qw*qy-qx*qz)), sqrt(1-2*(qw*qy-qx*qz)));
	psai = atan2(2*(qw*qz + qx*qy), 1-2*(qy^2+qz^2));

	euler_zyx = [phi, theta, psai];

end

