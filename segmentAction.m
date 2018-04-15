function segmentAction(filename)
% segmentAction --- takes in input the complete stream of an action and separates it into instances.
%              Input: 
%                   - filename: path of the mat structure of the action
%              
%              This function will
%                   - take the 3d streams of all markers of the action and segment it 
%                       into instances following the cut indices stored in the
%                       'index' field
%                   - save a cell array containing all the instances in temporal order, for every marker
%              
%              Output:
%                   - a file named *action*_segm.mat will be saved.
%                   
% Example of use:
% action = 'data/training_set/carrot_tr.mat';
% segmentAction(action);
%
% The mat file saved will have dimensions {instances x markers} where:
%   - the first index refers to the instances of the action in temporal order
%   - the second index refers to the markers saved, is a number between 1 and 6, 
%       respectively INDEX FINGER, PALM, LITTLE FINGER, WRIST, ELBOW and SHOULDER.
%
% If we want to get the fifth instance of the PALM of the output produced:
% carrot = load('carrot_tr_segm.mat'); 
% palm_5 = carrot.actions(5,2);
% 
% Use cell2mat function to simplify access to the data (example cell2mat(palm_5).
% 
    [filepath,nome,ext] = fileparts(filename);
    file = load(filename);
    ind = file.index;
    
    actions = {};

    for i = 2:length(ind)
        actions(i-1,1) = {file.IND(ind(i-1):ind(i), :)};
        actions(i-1,2) = {file.PALM(ind(i-1):ind(i), :)};
        actions(i-1,3) = {file.LIT(ind(i-1):ind(i), :)};
        actions(i-1,4) = {file.WRIST(ind(i-1):ind(i), :)};
        actions(i-1,5) = {file.ELBOW(ind(i-1):ind(i), :)};
        actions(i-1,6) = {file.SHOULDER(ind(i-1):ind(i), :)};      
    end
   
    str = strcat(nome, '_segm', '.mat');
    save(str, 'actions');
    fprintf('%s file saved.\n',str);
end