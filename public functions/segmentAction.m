function [struct] = segmentAction(filename)
% segmentAction --- takes in input the complete stream of an action and 
%                   separates it into instances. The user can use this 
%                   function to segment Scene files.
%
%              Input: 
%                   - filename: path of the mat structure of the action
%              
%              This function will
%                   - take the 3d streams of all markers of the action and 
%                       segment it into instances following the cut indices 
%                       stored in the 'index' field
%                   - save a structure array containing all the instances 
%                       in temporal order, for every marker
%              
%              Output:
%                   - a file named *action*_instances.mat will be saved.
%                   
% Example of use:
% action = '../cooking dataset/data/training/carrot_tr.mat';
% segmentAction(action);
%
% The MatFile object saved will have one variable for each single instance
% of the action, in every variable the user can find MoCap data for all the
% markers.
% 
    [filepath,nome,ext] = fileparts(filename);
    file = load(filename);
    ind = file.index;
    
    nameStruct = strcat(nome, '_instances', '.mat');
    action = matfile(nameStruct, 'Writable', true);
    
    num = 1;
    for i = 2:length(ind)
        instance.IND = file.IND(ind(i-1):ind(i), :);
        instance.PALM = file.PALM(ind(i-1):ind(i), :);
        instance.LIT = file.LIT(ind(i-1):ind(i), :);
        instance.WRIST = file.WRIST(ind(i-1):ind(i), :);
        instance.ELBOW = file.ELBOW(ind(i-1):ind(i), :);
        instance.SHOULDER = file.SHOULDER(ind(i-1):ind(i), :);
        
        if(num < 10)
            action.(strcat(nome,'_0',int2str(num))) = instance;
        else
            action.(strcat(nome,'_',int2str(num))) = instance;
        end
        num = num+1;
    end
   
    struct = load(nameStruct);
    fprintf('File %s saved.\n', nameStruct);
end