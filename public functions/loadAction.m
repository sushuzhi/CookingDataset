function [data] = loadAction(folder, action, varargin)
% LOADACTION --- loads the MoCap streams of an action specified by the user.
%              
%              Input: 
%                   - folder: path of the folder in which mat structures 
%                       are stored.
%                   - action: name of the action that needs to be loaded.
%                   - marker (optional): a single string between 'SHOULDER',
%                       'ELBOW', 'WRIST', 'PALM', 'IND' and 'LIT'.
%                       'ALL' to retrieve MoCap data from each marker.
%                   - instance (optional): a number identifying a single
%                       instance of the action.
%              
%              This function will give you the possibility to load only
%              part of the Cooking Dataset by specifying and action, a
%              marker, or an instance.
%              
%              Output:
%                   [data] = structure containing the subset of data
%                       requested by the user.
%
% Example of use:
% folder = '../cooking dataset/data/training/';
% action = 'dish';
%  - LOADACTION(folder, action) and loadAction(folder, action, 'ALL') 
% return a struct containing data of all markers for the action specified.
%  - LOADACTION(folder, action, marker) returns a struct containing data of
% the marker specified for the action in 'action'.
%  - LOADACTION(folder, action, 'ALL', instance) returns a struct 
% containing data of all markers at the specified instance of  the action.
%  - LOADACTION(folder, action, marker, instance) returns a struct 
% containing data of a single marker at the specifies instance of the
% action.
%
    folder = strcat(folder,'/');
    mode = strsplit(folder, '/');
    % check if the folder path ends in '/' or not
    % if it does, comment line 35
    
    if(~strcmp(mode(end-1),'training') || ~strcmp(mode(end-1), 'test'))
        mode = '';
    else
        mode = strcat('_',char(mode(end-1)));
    end
    
    % Load the complete action
    if(isempty(varargin) || (size(varargin,2) == 1 && strcmp(char(upper(varargin{1})), 'ALL')))
        filename = dir(strcat(folder,'*',lower(action),'*.mat'));
        file = load(strcat(folder,filename.name));
        
        nameStruct = strcat(lower(action),mode, '.mat');
        actionStruct = matfile(nameStruct, 'Writable', true);
        
        % Annotation of the scene files
        if isfield(file, 'labels')
            actionStruct.labels = file.labels;
            actionStruct.index = file.index;
        end

        actionStruct.IND = file.IND(:,:);
        actionStruct.PALM = file.PALM(:,:);
        actionStruct.LIT = file.LIT(:, :);
        actionStruct.WRIST = file.WRIST(:,:);
        actionStruct.ELBOW = file.ELBOW(:,:);
        actionStruct.SHOULDER = file.SHOULDER(:,:);
        
        data = load(nameStruct);
        fprintf('File %s saved.\n',nameStruct);
    
    elseif(~isempty(varargin))
        filename = dir(strcat(folder,'*',lower(action),'*.mat'));
        file = load(strcat(folder,filename.name));
        marker = upper(char(varargin{1}));
        
        % Load a specific marker of the action
        if(size(varargin,2)==1)
            nameStruct = strcat(lower(action),'_', lower(marker), mode, '.mat');
            actionStruct = matfile(nameStruct, 'Writable', true);

            actionStruct.(marker) = file.(marker);
            % Annotation of the scene files
            if isfield(file, 'labels')
                actionStruct.labels = file.labels;
                actionStruct.index = file.index;
            end
        
        % Load a specific instance of the action
        elseif(size(varargin,2)==2)
            i = varargin{2};
            ind = file.index;
                    
            if(i < (size(ind,2)-1))
                if(strcmp(marker,'ALL'))
                    nameStruct = strcat(lower(action),'_instance',int2str(i),'.mat');
                    actionStruct = matfile(nameStruct, 'Writable', true);
                    
                    % Annotation of the scene files
                    if isfield(file, 'labels')
                        labels = file.labels;
                        actionStruct.labels = char(labels(i));
                    end
            
                    actionStruct.IND = file.IND(ind(i):ind(i+1), :);
                    actionStruct.PALM = file.PALM(ind(i):ind(i+1), :);
                    actionStruct.LIT = file.LIT(ind(i):ind(i+1), :);
                    actionStruct.WRIST = file.WRIST(ind(i):ind(i+1), :);
                    actionStruct.ELBOW = file.ELBOW(ind(i):ind(i+1), :);
                    actionStruct.SHOULDER = file.SHOULDER(ind(i):ind(i+1), :);
                else
                    nameStruct = strcat(lower(action),'_',lower(marker),'_instance',int2str(i), mode, '.mat');
                    actionStruct = matfile(nameStruct, 'Writable', true);
                    actionStruct.(marker) = file.(marker)(ind(i):ind(i+1),:);
                    % Annotation of the scene files
                    if isfield(file, 'labels')
                        labels = file.labels;
                        actionStruct.labels = char(labels(i));
                    end
            
                end
            end
        end
        data = load(nameStruct);
        fprintf('File %s saved.\n', nameStruct);
    end
end