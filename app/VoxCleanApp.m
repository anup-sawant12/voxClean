classdef VoxCleanApp < matlab.apps.AppBase
    % VoxCleanApp Programmatic GUI for Speech Enhancement
    
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        SelectButton  matlab.ui.control.Button
        FileLabel     matlab.ui.control.Label
        PlayOrigBtn   matlab.ui.control.Button
        EnhanceBtn    matlab.ui.control.Button
        PlayEnhBtn    matlab.ui.control.Button
        SaveBtn       matlab.ui.control.Button
        StopAudioBtn  matlab.ui.control.Button
        StatusLabel   matlab.ui.control.Label
        
        SelectedFile
        OriginalAudio
        EnhancedAudio
        Fs = 16000
    end
    
    methods (Access = private)
        function selectAudio(app, ~, ~)
            [file, path] = uigetfile('*.wav', 'Select Noisy Audio');
            if isequal(file, 0)
                return;
            end
            app.SelectedFile = fullfile(path, file);
            app.FileLabel.Text = ['File: ', file];
            app.StatusLabel.Text = 'Audio loaded. Ready to enhance.';
            
            [app.OriginalAudio, ~] = audioread(app.SelectedFile);
        end
        
        function playOriginal(app, ~, ~)
            if ~isempty(app.OriginalAudio)
                sound(app.OriginalAudio, app.Fs);
                app.StatusLabel.Text = 'Playing original audio...';
            end
        end
        
        function runEnhancement(app, ~, ~)
            if isempty(app.SelectedFile)
                app.StatusLabel.Text = 'Please select a file first.';
                return;
            end
            
            app.StatusLabel.Text = 'Enhancing speech... Please wait.';
            drawnow;
            
            try
                % Add src to path
                addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'src'));
                app.EnhancedAudio = enhanceSpeech(app.SelectedFile, '');
                app.StatusLabel.Text = 'Enhancement complete!';
            catch ME
                app.StatusLabel.Text = ['Error: ', ME.message];
            end
        end
        
        function playEnhanced(app, ~, ~)
            if ~isempty(app.EnhancedAudio)
                sound(app.EnhancedAudio, app.Fs);
                app.StatusLabel.Text = 'Playing enhanced audio...';
            end
        end
        
        function stopAudio(app, ~, ~)
            clear sound;
            app.StatusLabel.Text = 'Audio stopped.';
        end
        
        function saveEnhanced(app, ~, ~)
            if isempty(app.EnhancedAudio)
                app.StatusLabel.Text = 'No enhanced audio to save.';
                return;
            end
            [file, path] = uiputfile('*.wav', 'Save Enhanced Audio');
            if isequal(file, 0)
                return;
            end
            audiowrite(fullfile(path, file), app.EnhancedAudio, app.Fs);
            app.StatusLabel.Text = 'File saved successfully!';
        end
    end
    
    methods (Access = public)
        function app = VoxCleanApp()
            app.UIFigure = uifigure('Name', 'VoxClean AI', 'Position', [100 100 400 300]);
            
            app.SelectButton = uibutton(app.UIFigure, 'push', 'Text', 'Select Audio', 'Position', [20 250 100 30], 'ButtonPushedFcn', @app.selectAudio);
            app.FileLabel = uilabel(app.UIFigure, 'Text', 'File: None', 'Position', [130 250 250 30]);
            
            app.PlayOrigBtn = uibutton(app.UIFigure, 'push', 'Text', 'Play Original', 'Position', [20 200 100 30], 'ButtonPushedFcn', @app.playOriginal);
            app.StopAudioBtn = uibutton(app.UIFigure, 'push', 'Text', 'Stop Audio', 'Position', [130 200 100 30], 'ButtonPushedFcn', @app.stopAudio);
            app.EnhanceBtn = uibutton(app.UIFigure, 'push', 'Text', 'Run Enhancement', 'Position', [20 150 150 30], 'ButtonPushedFcn', @app.runEnhancement);
            
            app.PlayEnhBtn = uibutton(app.UIFigure, 'push', 'Text', 'Play Enhanced', 'Position', [20 100 100 30], 'ButtonPushedFcn', @app.playEnhanced);
            app.SaveBtn = uibutton(app.UIFigure, 'push', 'Text', 'Save Enhanced', 'Position', [130 100 100 30], 'ButtonPushedFcn', @app.saveEnhanced);
            
            app.StatusLabel = uilabel(app.UIFigure, 'Text', 'Status: Ready', 'Position', [20 20 350 30]);
        end
    end
end
