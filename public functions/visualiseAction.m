function visualiseAction(segmentedfile, instance)
% visualiseAction --- plots the trajectories of all the joints.
%                     
%                    Input:
%                       - segmentedfile: path of the struct obtained by the 
%                           segmentAction function
%                       - instance: 'all' if you want to plot the entire 
%                           action a number if you want to plot a specific 
%                           instance of the action
%                      
%                     Output:
%                       One plot per marker.
% 
% Example of use:
% action = '../cooking dataset/data/training/carrot_tr.mat';
% segmentAction(action);
% carrot = 'carrot_tr_instances.mat'; 
% visualiseAction(carrot, 'all');
%
    file = load(segmentedfile);
    variables = fields(file);
    joints = {'INDEX FINGER', 'PALM', 'LITTLE FINGER', 'WRIST', 'ELBOW', 'SHOULDER'};
    colours = {'b', 'g', 'r', 'c', 'y', 'm'};

    if strcmp(instance, 'all')
        figure
        for i = 1:6
            subplot(2,3,i)
            for j = 1:size(variables,1)
                mocap = file.(variables{j});
                markers = fields(mocap);
                act = mocap.(cell2mat(markers(i)));
                plot3(act(:,1), act(:,2), act(:,3), colours{i});
                hold all
            end
            grid on
            xlabel('x');
            ylabel('y');
            zlabel('z');
            view(3);
            title(joints(i));
        end     
        
    elseif isnumeric(instance)
        if instance<=0 || instance>size(variables,1)
            fprintf('You need to enter a number between 1 and %i.\n', size(actions,1));
            return;
        end
        mocap = file.(variables{instance});
        markers = fields(mocap);
        figure
        for i = 1:6
            subplot(2,3,i)
            act = mocap.(cell2mat(markers(i)));
            plot3(act(:,1), act(:,2), act(:,3), colours{i});
            hold on
            grid on
            xlabel('x');
            ylabel('y');
            zlabel('z');
            view(3);
            title(joints(i));
        end
    end
    
end