function [data] = loadDataset(folder, mode)
% LOADDATASET --- loads and saves (training or test set) of the cooking 
%              dataset in a structure.
%              Input: 
%                   - folder: path of the folder in which mat structures 
%                     are stored.
%                   - mode: 'training' or 'test' 
%              
%              This function will group MoCap data of all actions for the
%              set indicated into one single structure.
%
%              Output:
%                   [data] = structure containing the MoCap streams of all 
%                   the actions for the set indicated by the user.
%
% Example of use:
% folder_tr = '../cooking dataset/data/training/';
% training = LOADDATASET(folder_tr, 'training');
% folder_te = '../cooking dataset/data/test/';
% test = LOADDATASET(folder_te, 'test');
%
% The MatFile object saved will have one field for each action contained in
% the dataset and in each one of them the user can find MoCap streams for all the
% markers.
%

    nameStruct = strcat('cooking_dataset_', mode, '.mat');
    dataset = matfile(nameStruct, 'Writable', true);
    
    % this is where the function read the files in 'folder'
    % check if the folder path ends in '/' or not
    % if it does, comment line 33
    folder = strcat(folder,'/');
    f = dir(strcat(folder,'*.mat'));
    
    for file = f'
        path = strcat(folder, file.name);
        single_action = load(path);
        
        filename = strsplit(file.name, '_');
       
        action.IND = single_action.IND(:,:);
        action.PALM = single_action.PALM(:,:);
        action.LIT = single_action.LIT(:, :);
        action.WRIST = single_action.WRIST(:,:);
        action.ELBOW = single_action.ELBOW(:,:);
        action.SHOULDER = single_action.SHOULDER(:,:);
        
        dataset.(char(filename(1))) = action;
    end
    
    data = load(nameStruct);
    fprintf('File %s saved.\n',nameStruct);
end