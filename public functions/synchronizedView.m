function synchronizedView(vid, mocap, startMocap, startVid, pov)
% SYNCHRONIZEDVIEW --- function that visualize an action in synch from video and from skeleton data
%                       Input:
%                           - vid: a VideoReader object
%                           - mocap: the stream of motion capture data
%                           - startMocap: starting instant for the MoCap
%                               stream
%                           - startVid: starting frame
%                           
% Example of use:
% mocap_folder = '../mocap/training';
% video_folder = '../video/training';
% [vid, mocap, startMocap, startVid] = 
%           INITSYNCH('carrot', 'tr', 0, mocap_folder, video_folder);
% SYNCHRONIZEDVIEW(vid, mocap, startMocap, startVid);
%    
    
    palm = double(mocap.PALM(:,:));
    lit = double(mocap.LIT(:,:));
    wri = double(mocap.WRIST(:,:));
    elb = double(mocap.ELBOW(:,:));
    sho = double(mocap.SHOULDER(:,:));
    ind = double(mocap.IND(:,:));
    
    % Adjust the point of view of the skeleton plot with the video
    az = 0;
    el = 0;
    switch(pov)
        case 0 
            az = -40;
            el = 18;
        case 1
            az = -180;
            el = 90;
        case 2
            az = 0;
            el = 50;
    end
    
    frame = 1;
    
    if(startVid == 0)
        frame = 1;
    else
        start = startVid;
        frame = start;
    end
    if(startMocap == 0)
        i=1;
    else
        i= startMocap;
    end


    while(hasFrame(vid))
       newTime = (frame - 1)/30;
       if(newTime < vid.Duration)
            vid.CurrentTime = newTime;
       else
           break;
       end
		
	   % video
       subplot(1,2,1)
       image(readFrame(vid));
       title(['Frame: ', num2str(frame)]);

	   % skeleton
       subplot(1,2,2)
       scatter3(ind(i,1), ind(i,2), ind(i,3), 'o', 'filled');
       ylim([-400 600]);
       xlim([-500 600]);
       zlim([-100 500]);
       xlabel('x');
       ylabel('y');
       zlabel('z');
       view(az,el);
       hold on
       scatter3(palm(i,1), palm(i,2), palm(i,3), 'o','filled');
       hold on
       scatter3(lit(i,1), lit(i,2), lit(i,3), 'o', 'filled');
       hold on
       scatter3(wri(i,1), wri(i,2), wri(i,3),'o','filled');
       hold on
       scatter3(elb(i,1), elb(i,2), elb(i,3),'o', 'filled');
       hold on
       scatter3(sho(i,1), sho(i,2), sho(i,3), 'o', 'filled');
       hold on

       plot3([sho(i,1) elb(i,1)], [sho(i,2) elb(i,2)], [sho(i,3) elb(i,3)]);
       hold on
       plot3([elb(i,1) wri(i,1)], [elb(i,2) wri(i,2)], [elb(i,3) wri(i,3)]);
       hold on
       plot3([wri(i,1) palm(i,1)], [wri(i,2) palm(i,2)], [wri(i,3) palm(i,3)]);
       hold on
       plot3([palm(i,1) ind(i,1)], [palm(i,2) ind(i,2)], [palm(i,3) ind(i,3)]);
       hold on
       plot3([palm(i,1) lit(i,1)], [palm(i,2) lit(i,2)], [palm(i,3) lit(i,3)]);

       grid on
       view(az,el);
       title(['Frame: ',num2str(i)])

       % related to the STEP (30fps -> 3 frames every 0.1 sec)
       pause(0.5)
       clf;

       if(i>size(mocap.PALM(:,:)))
           break;
       end
       
       % STEP: 3 video frames corresponds to 10 MoCap points in space
       frame = frame+15;
       i = i+50;
       if(i>size(mocap.PALM,1))
           break;
       end

    end
end