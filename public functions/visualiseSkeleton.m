function visualiseSkeleton(filename)
% VISUALISESKELETON --- simulates the arm movement in time.
%                     Input:
%                       - filename: path of the mat structure of the action
%                      
%                     Output:
%                       Simulation of the arm executing the complete action 
%                       (multiple instances)
% 
% Example of use:
% filename = '../cooking dataset/data/training/carrot_tr.mat';
% VISUALISESKELETON(filename);
%
    
    file = load(filename);
    nameFile = strsplit(filename,'/');
    nameAction = strsplit(char(nameFile(end)),'_');
    
    palm = double(file.PALM(:,:));
    lit = double(file.LIT(:,:));
    wrist = double(file.WRIST(:,:));
    elb = double(file.ELBOW(:,:));
    sho = double(file.SHOULDER(:,:));
    ind = double(file.IND(:,:));
    start = double(file.index(1,1));
    
    figure
    for j = start:10:size(palm,1)
        scatter3(ind(j,1), ind(j,2), ind(j,3), 'o', 'filled', 'b');
        ylim([-400 600]);
        xlim([-500 600]);
        zlim([-100 500]);
        xlabel('x');
        ylabel('y');
        zlabel('z');
        view(3);
        hold on

        scatter3(palm(j,1), palm(j,2), palm(j,3), 'o','filled', 'g');
        hold on

        scatter3(lit(j,1), lit(j,2), lit(j,3), 'o', 'filled', 'r');
        hold on

        scatter3(wrist(j,1), wrist(j,2), wrist(j,3),'o','filled', 'c');
        hold on

        scatter3(elb(j,1), elb(j,2), elb(j,3),'o', 'filled', 'y');
        hold on

        scatter3(sho(j,1), sho(j,2), sho(j,3), 'o', 'filled', 'm');
        legend('INDEX FINGER', 'PALM', 'LITTLE FINGER', 'WRIST', 'ELBOW', 'SHOULDER', 'Location', 'eastoutside');
        hold on

        plot3([sho(j,1) elb(j,1)], [sho(j,2) elb(j,2)], [sho(j,3) elb(j,3)], 'k');
        hold on
        plot3([elb(j,1) wrist(j,1)], [elb(j,2) wrist(j,2)], [elb(j,3) wrist(j,3)], 'k');
        hold on
        plot3([wrist(j,1) palm(j,1)], [wrist(j,2) palm(j,2)], [wrist(j,3) palm(j,3)], 'k');
        hold on
        plot3([palm(j,1) ind(j,1)], [palm(j,2) ind(j,2)], [palm(j,3) ind(j,3)], 'k');
        hold on
        plot3([palm(j,1) lit(j,1)], [palm(j,2) lit(j,2)], [palm(j,3) lit(j,3)], 'k');
        grid on
        
        title(strcat('Action: ',char(nameAction(1))));
        pause(0.01)
        clf;

        end

end