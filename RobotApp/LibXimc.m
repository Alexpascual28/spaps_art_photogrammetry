classdef LibXimc
    methods 
        function self = LibXimc
           self.loadlib;
        end       
    end
    
    methods (Static)
        % Loads libximc library
        function loadlib
            % Display computer OS
            [~,maxArraySize]=computer;
            is64bit = maxArraySize > 2^31;
            if (ispc)
                if (is64bit)
                        disp('Using 64-bit version')
                else
                        disp('Using 32-bit version')
                end
            end

            % If library is not already loaded, load ximc library
            if not(libisloaded('libximc'))
              disp('Loading library')
              if ispc
                addpath(fullfile('libximc-2.13.3-all/ximc/win64/wrappers/matlab/'));
                if (is64bit)
                    addpath(fullfile('libximc-2.13.3-all/ximc/win64/'));
                    try
                        [notfound,warnings] = loadlibrary('libximc.dll', @ximcm);
                        disp('Libximc library loaded');
                    catch
                        disp('Error while loading library. Library not found');
                    end
                else
                    addpath(fullfile('libximc-2.13.3-all/ximc/win32/'));
                    try
                        [notfound, warnings] = loadlibrary('libximc.dll', 'ximcm.h', 'addheader', 'ximc.h');
                        disp('Libximc library loaded');
                    catch
                        disp('Error while loading library. Library not found');
                    end
                end
              end
            else
                disp('Libximc library is already loaded');
            end
        end
        
        % Unloads libximc library
        function unloadlib
            try
                unloadlibrary libximc
                disp('Libximc library unloaded');
            catch
                disp('Error unloading libximc. Could not find library class to unload.');
            end   
        end
        
        % Returns motor settings specified by 
        function [ settingsInfo ] = getsettings(deviceId, settingsRequest, calibration)
            if ~exist('calibration', 'var')
                calibration = 'empty';
            else
                calibrationPtr = libpointer('calibration_t', calibration);
            end

            if isequal(settingsRequest, 'position') || isequal(settingsRequest, 'position_calb')
                command = strcat('get_', settingsRequest);
                settingsStruct = strcat('get_', settingsRequest, '_t');
            else
                command = strcat('get_', settingsRequest);
                settingsStruct = strcat(settingsRequest, '_t');
            end

            dummyStruct = struct();
            pargStruct = libpointer(settingsStruct, dummyStruct);

            if isequal(calibration, 'empty')
                [result, settingsInfo] = calllib('libximc',command, deviceId{2}, pargStruct);
                clear parg_struct
            else
                [result, settingsInfo] = calllib('libximc',command, deviceId{2}, pargStruct, calibrationPtr);
                clear parg_struct
                clear calibrationPtr
            end

            if result ~= 0
                disp(['Command failed with code', num2str(result)]);
                settingsInfo = 0;
            end
            
%             disp(append(deviceId{1}, ' ', settingsRequest, ':'));
%             disp(settingsInfo);
        end
        
        function setsettings(deviceId, settingsRequest, settingsInfo, calibration)
            if ~exist('calibration', 'var')
                calibration = 'empty';
            else
                calibrationPtr = libpointer('calibration_t', calibration);
            end
            
            command = strcat('set_', settingsRequest);
            
            if isequal(calibration, 'empty')
                try
                    result = calllib('libximc', command, deviceId{2}, settingsInfo);
                    disp(append('Success setting command: ', command));
                catch
                    disp(append('Setting request ', command, ' not available'));
                    result = -1;
                end
            else
                try
                    result = calllib('libximc', command, deviceId{2}, settingsInfo, calibrationPtr);
                catch
                    disp(append('Setting request ', command, ' not available'));
                    result = -1;
                end
            end
            
            if result ~= 0
                disp(['Command failed with code', num2str(result)]);
            end
        end
        
        function inputcommand(deviceId, commandRequest, parameter, calibration)
            if ~exist('parameter', 'var')
                parameter = 'empty';
            end
            
            if ~exist('calibration', 'var')
                calibration = 'empty';
            else
                calibrationPtr = libpointer('calibration_t', calibration);
            end
            
            disp(append('Running command ', commandRequest, ' on device ', deviceId{1}, ' with ID: ', num2str(deviceId{2})));
            
            command = strcat('command_', commandRequest);

            if isequal(parameter, 'empty')
                result = calllib('libximc', command, deviceId{2});
            else
                if isequal(calibration, 'empty')
                    if isequal(commandRequest, 'move') || isequal(commandRequest, 'movr')
                        result = calllib('libximc', command, deviceId{2}, parameter(1), parameter(2));
                    else
                        result = calllib('libximc', command, deviceId{2}, parameter);
                    end
                else
                    result = calllib('libximc', command, deviceId{2}, parameter, calibrationPtr);
                    clear calibrationPtr
                end
            end
            
            if result ~= 0
                disp(append('Command ', commandRequest, ' failed with code on device ', deviceId{1}, ' with ID: ', num2str(deviceId{2})));
            else
                disp('Success');
            end
        end
    end
end


