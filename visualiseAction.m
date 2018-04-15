function visualiseAction(action, instance)
% visualiseAction --- plots the trajectories of all the joints.
%                     Input:
%                       - action: name of the mat file obtained by the segmentAction function
%                       - instance: 'all' if you want to plot the entire
%                       action, a number if you want to plot a specific instance of the action
%                      
%                     Output:
%                       One plot per joint (different colors are associated with
%                       different instances)
% 
% Example of use:
% action = 'data/training_set/carrot_tr.mat';
% segmentAction(action);
% carrot = 'carrot_tr_segm.mat'; 
% visualiseAction(carrot, 'all');
%
    file = load(action);
    actions = file.actions;
    joints = {'INDEX FINGER', 'PALM', 'LITTLE FINGER', 'WRIST', 'ELBOW', 'SHOULDER'};

    if strcmp(instance, 'all')
        instance = size(actions,1);
        for i = 1:6
            figure
            for j = 1:instance
                track = cell2mat(actions(j, i));
                plot3(track(:,1), track(:,2), track(:,3));
                hold all
            end
            grid on
            xlabel('x');
            ylabel('y');
            zlabel('z');
            title(joints(i));
        end
    elseif isnumeric(instance)
        if instance<=0 || instance>size(actions,1)
            fprintf('You need to enter a number between 1 and %i.\n', size(actions,1));
            return;
        end
        for i = 1:6
            figure
            track = cell2mat(actions(instance, i));
            plot3(track(:,1), track(:,2), track(:,3));
            hold on
            grid on
            xlabel('x');
            ylabel('y');
            zlabel('z');
            title(joints(i));
        end
    end
    
end