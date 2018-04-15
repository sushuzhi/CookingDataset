function [data] = loadData(folder, mode)
% loadData --- loads and saves the cooking dataset as a cell array.
%              Input: 
%                   - folder: path of the folder in which mat structures are stored.
%                   - mode: 'tr' if you want to load the training set
%                           'te' if you want to load the test set.
%              
%              This function will:
%                   - take the 3d streams of all markers of an action and segment it 
%                       into instances of the same action, following the cut indices stored in the
%                       'index' field
%                   - save instances in temporal order, for every marker,
%                       for every action in a cell array
%              
%               Output:
%                   [data] = cell array of dimensions {instances x markers x actions} 
%                           saved and loaded in workspace.
%
% Example of use:
% folder = 'data/training_set';
% mode = 'tr';
% training = loadData(folder, mode);
%
% The output is a cell array of dimensions {instances x markers x actions} where
%   - the first index refers to the instances of the action in temporal order, 
%       the number of instances depends on the length of the 'index' field in the mat structure. 
%       Final number of rows depends on the action with the maximum number of instances {66 x 6 x 20}.
%   - the second index refers to the markers saved, is a number between 1 and 6, 
%       respectively INDEX FINGER, PALM, LITTLE FINGER, WRIST, ELBOW and SHOULDER.
%   - the third index refers to the different actions (in alphabetical order)
% 
% If we want to get the fifth instance of the PALM of the first action (carrot): 
% palm_5 = training(5, 2, 1);
% 
% Use cell2mat function to simplify access to the data (example cell2mat(palm_5).
% 
    data = {};
    
    if strcmp(mode, 'tr')
       name = 'cooking_training_set';
       action_labels = {'carrot_tr', 'cut_tr', 'dish_tr', 'eat_tr', 'eggs_tr', 'lemon_tr', 'mezzaluna_tr', 'mixing_tr', 'openbottle_tr', 'pan_tr', 'pestare_tr', 'pour_tr', 'pouring2_tr', 'reaching2_tr', 'rolling_tr', 'salad_tr', 'salt_tr', 'spread_tr', 'table_tr', 'transport2_tr'}; 
    end
    
    if strcmp(mode, 'te')
        name = 'cooking_test_set';
        action_labels = {'carrot_test', 'cut_test', 'dish_test', 'eat_test', 'eggs_test', 'lemon_test', 'mezzaluna_test', 'mixing_test', 'openbottle_test', 'pan_test', 'pestare_test', 'pour_test', 'pouring2_test', 'reaching2_test', 'rolling_test', 'salad_test', 'salt_test', 'spread_test', 'table_test', 'transport2_test'}; 
    end
    
    for i = 1:size(action_labels,2)
        filename = strcat(action_labels(i),'.mat');
        path = strcat(folder, filename);
        
        action = load(char(path));
        ind = action.index;

        c = cell(length(ind), 6);

        % for each action we create a cell with 
        %   - a row for each instance of the action within the stream
        %   - a column for each joint
        for j = 2:length(ind)
            c(j-1,1) = {action.IND(ind(j-1):ind(j), :)};
            c(j-1,2) = {action.PALM(ind(j-1):ind(j), :)};
            c(j-1,3) = {action.LIT(ind(j-1):ind(j), :)};
            c(j-1,4) = {action.WRIST(ind(j-1):ind(j), :)};
            c(j-1,5) = {action.ELBOW(ind(j-1):ind(j), :)};
            c(j-1,6) = {action.SHOULDER(ind(j-1):ind(j), :)};       
        end

        data(1:size(c,1), 1:size(c,2), i) = c;   
    end
    
    loadname = strcat(name, '.mat');
    save(loadname, 'data');
    fprintf('%s file saved.\n',loadname);
end