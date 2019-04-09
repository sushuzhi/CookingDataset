function [vid, mocap, startMocap, startVid, pov] = initSynch(action, mode, pov, mocap_folder, video_folder)
% INITSYNCH --- function that fetch video and mocap and the respective points of synchronization
%                       Input:
%                           - action: name of the action
%                           - mode: indicates if the action belongs to the
%                             training set ('tr') or the test set ('te'),
%                             or if it is a test scene ('scene')
%                           - PoV: indicates which point of view we want to
%                             visualize along with the MoCap data, 
%                                   0 (from the right)
%                                   1 (actor PoV)
%                                   2 (from the front)
%                           - mocap_folder: path of the folder containing
%                             the MoCap data
%                           - video_folder: path of the folder containing
%                             the video
%
%                       Output:
%                           - vid, a VideoReader object
%                           - mocap, the stream of motion capture data
%                           - startMocap/startVid starting frames for the
%                             synchronization
%                           - pov, one of the three point of views
%                           
% Example of use:
% mocap_folder = '../cooking dataset/data/mocap/training';
% video_folder = '../cooking dataset/data/video/training';
% [vid, mocap, startMocap, startVid, pov] = 
%           INITSYNCH('carrot', 'tr', 0, mocap_folder, video_folder);
%
% Use the output as input for the function synchronizedView to visualize
% video and skeleton in parallel.
% SYNCHRONIZEDVIEW(vid, mocap, startMocap, startVide, pov);


    table = readtable('synch_index.csv');
    synch = table2cell(table);
    
    % check if the folder paths ends in '/' or not
    % if it does, comment line 41 and 42
    mocap_folder = strcat(mocap_folder,'/');
    video_folder = strcat(video_folder,'/');
        
    file = dir(strcat(mocap_folder, action, '*.*'));
    mocap = load(strcat(mocap_folder,file.name));
    action_name = strsplit(file.name,'.');
    find_vid = dir(strcat(video_folder, upper(cell2mat(action_name(1))), '*_', num2str(pov), '.*'));
    vid = VideoReader(strcat(video_folder,find_vid.name));
    
    row = find(strcmp(synch, action));
    
    if(strcmp(mode,'tr'))
        startMocap = cell2mat(synch(row,2));
        startVid = cell2mat(synch(row,3));
    elseif(strcmp(mode,'te'))
        startMocap = cell2mat(synch(row,4));
        startVid = cell2mat(synch(row,5));
    elseif(strcmp(mode,'scene'))
        startMocap = cell2mat(synch(row,2));
        startVid = cell2mat(synch(row,3));
    end
    
    fprintf('Initialization done.\nUse the output of this function as input for synchronizedView.\n');
end