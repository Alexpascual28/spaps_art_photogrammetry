classdef PhotogrammetryRobot < handle
    properties (Access = public)
        motorFlag;
        cameraFlag;
        lightFlag;
        autoSystemFlag;
    end
    
    properties (Access = private)
        ximc; % Motor control library class
        vid; % Video capturing device
        joy; % Joystick control class
        a; % Arduino device (to control lights)
        
        axisId; % 3 axis motor control
        relayPin; % Array to hold relay pins in arduino
        ledWavelength; % Array to hold wavelengths of each light
        rPrevious; % Track previous relay
        calibrationSettings; % Calibration settings
    end

    methods (Access = public)
        % Class initialization function
        function self = PhotogrammetryRobot
            disp('Initializing Photogrammetry Robot');
            self.initializeproperties;
        end
        
        % Initialization of properties
        function initializeproperties(self)
            self.connectmotors;
            self.connectarduino;
            self.connectcamera;
            self.connectjoystick;
            
            self.relayPin = ["D12" "D11" "D9" "D10" "D8" "D7" "D6" "D5"];
            self.ledWavelength = [470, 528, 590, 617, 623, 640, 690, 740];
            self.rPrevious = 1;
            self.autoSystemFlag = true;
            
            self.calibrationSettings = struct();
            self.calibrationSettings.A = 0.025; % total distance in mm divided by number of steps 
            self.calibrationSettings.MicrostepMode = 9; % == MICROSTEP_MODE_FRAC_256
        end
        
        % Connect to motors by calling their respective COM ports
        function connectmotors(self)
            self.ximc = LibXimc;
            try
                self.axisId.x = {'X Axis', calllib('libximc','open_device', 'xi-com:\\.\COM5')};
                self.axisId.y = {'Y Axis', calllib('libximc','open_device', 'xi-com:\\.\COM6')};
                self.axisId.z = {'Z Axis', calllib('libximc','open_device', 'xi-com:\\.\COM4')};
                if self.axisId.x{2} == -1 || self.axisId.y{2} == -1 || self.axisId.z{2} == -1
                    disp('Problem setting Axis IDs. Please try reconnect motors again.');
                    disp(self.axisId);
                    self.motorFlag = 0;
                else
                    disp('Setting of Axis IDs succesful.');
                    disp(self.axisId);
                    self.motorFlag = 1;
                end
            catch
                disp('Error connecting to motors. Check if libximc is loaded');
                self.motorFlag = 0;
            end
        end
        
        % Initialize camera class
        function connectcamera(self)
            try
%                 self.vid = videoinput('tisimaq_r2013_64', 1, 'RGB32 (1280x1024)');
                self.vid = videoinput('tisimaq_r2013_64', 2, 'Y800 (1280x960)');
                self.vid.FramesPerTrigger = 1;
                disp('Video device initialized');
                self.cameraFlag = 1;
            catch
                disp('Error communicating with Video Device');
                self.cameraFlag = 0;
            end
        end
        
        % Initialize arduino class
        function connectarduino(self)
            try 
                self.a = arduino();
                disp('Arduino hardware connected');
                self.lightFlag = 1;
%                 error('MATLAB:eyeTrackAPP:abort','User aborted execution.');
            catch
                disp('Cannot detect Arduino hardware. Make sure Arduino hardware is properly plugged in');
                self.lightFlag = 0;
            end
        end
        
        % Initialize joystick class
        function connectjoystick(self)
            try
                self.joy = vrjoystick(1);
                disp('Joystick hardware connected');
            catch
                disp('Error connecting to joystick. Joystick not connected.');
            end
        end
        
        % Capture picture with video device
        function capture(self, name)
            try
                start(self.vid);
                imwrite(getdata(self.vid), name);
            catch
                disp('Error communicating with Video Device');
                self.cameraFlag = 0;
            end
        end
        
        % Preview video device
        function previewstart(self)
            try
                preview(self.vid);
            catch
                disp('Error communicating with Video Device');
                self.cameraFlag = 0;
            end
        end

        % Stop preview on video device
        function previewstop(self)
            try
                stoppreview(self.vid);
            catch
                disp('Error communicating with Video Device');
                self.cameraFlag = 0;
            end
        end
        
        % Inputs string calling axis (using setdeviceid function) and desired position,
            % moves motor to desired location by using libximc library
        function movemotor(self, deviceStr, position)
            deviceId = self.setdeviceid(deviceStr);
            self.ximc.inputcommand(deviceId, 'move_calb', position, self.calibrationSettings);
            self.ximc.inputcommand(deviceId, 'wait_for_stop', 100);
        end

        % Moves efector to the right for the specified 'wait' time
        function rightmotor(self, deviceStr, wait)
            deviceId = self.setdeviceid(deviceStr);
            self.ximc.inputcommand(deviceId, 'right');
            pause(wait);
            self.ximc.inputcommand(deviceId, 'sstp');
        end
        
        % Moves efector to the left for the specified 'wait' time
        function leftmotor(self, deviceStr, wait)
            deviceId = self.setdeviceid(deviceStr);
            self.ximc.inputcommand(deviceId, 'left');
            pause(wait);
            self.ximc.inputcommand(deviceId, 'sstp');
        end
        
        % Inputs string calling axis (using setdeviceid function) and desired shift amount,
            % shifts motor to desired location by using libximc library
        function shiftmotor(self, deviceStr, shift)
            deviceId = self.setdeviceid(deviceStr);
            self.ximc.inputcommand(deviceId, 'movr_calb', shift, self.calibrationSettings);
            self.ximc.inputcommand(deviceId, 'wait_for_stop', 100);
        end

        % Inputs position array for three axis [x, y, z], moves the three 
            % motors at the same time to specified location
        function moveefector(self, positionArray)
            fn = fieldnames(self.axisId);
            for iAxis = 1:3 % Loop through the three axis, move to specified position for each
                if positionArray(iAxis) >= 0 && positionArray(iAxis) <= 712
                    disp(append('Moving ', self.axisId.(fn{iAxis}){1}));
                    self.ximc.inputcommand(self.axisId.(fn{iAxis}), 'move_calb',...
                        positionArray(iAxis), self.calibrationSettings);
                end
            end
            for iAxis = 1:3 % Loop through the three axis, send wait for stop command for each
                if positionArray(iAxis) >= 0 && positionArray(iAxis) <= 712
                    disp(append('Waiting for stop ', self.axisId.(fn{iAxis}){1}));
                    self.ximc.inputcommand(self.axisId.(fn{iAxis}), 'wait_for_stop', 100);
                end
            end
        end
        
        % Inputs axis call string, returns current calibrated status of motor,
            % which includes current position, speed, etc...
        function [calibratedStatus] = getcalibratedstatus(self, deviceStr)
            deviceId = self.setdeviceid(deviceStr);
            calibratedStatus = self.ximc.getsettings(deviceId, 'status_calb', self.calibrationSettings);
            if deviceStr == 'Z'
                try
                    calibratedStatus.CurPosition = abs(calibratedStatus.CurPosition - 712);
                catch
                    disp('Skipping inversion of Z values.')
                end
            end
        end
        
        % Returns wavelength array for leds
        function [wavelengthArray] = getledwavelength(self)
            wavelengthArray = self.ledWavelength;
        end
        
        % Input: number from 0 to 8. If 0, lights turns off, else, turns
            % respective led light and turns off previous one
        function ledlight(self, ledNumber)
            if ledNumber == 0
                writeDigitalPin(self.a, self.relayPin(self.rPrevious), 1);
            else
                writeDigitalPin(self.a, self.relayPin(self.rPrevious), 1);
                writeDigitalPin(self.a, self.relayPin(ledNumber), 0);
                self.rPrevious = ledNumber;
            end
        end
        
        % Sequences through led lights, in a single for loop
        function ledsequence(self, wait)
            for r = 1:8
                writeDigitalPin(self.a, self.relayPin(self.rPrevious), 1);
                writeDigitalPin(self.a, self.relayPin(r), 0);
                self.rPrevious = r;
                pause(wait);
            end
        end

        % Read joystick output
        function [position] = joystickread(self)
            position = read(self.joy);
        end
        
        % Move to position read from joystick for each axis, using
            % private joycontrolaxis function
        function joystickmotorcontrol(self, components, updatecomponentsFunc)
            startbutton = components{1};
            pausebutton = components{2};
            
            while true
                self.checkpausestopstatus(startbutton, pausebutton);
                position = read(self.joy);
                
                self.joycontrolaxis(-position(2), 'X');
                self.joycontrolaxis(position(1), 'Y');
                self.joycontrolaxis(position(3), 'Z');
                
                updatecomponentsFunc();
                
                pause(0.2);
            end
        end
        
        % Read joystick output and plot joystick position on an axes figure
        function joystickplot(self, dimStr)
            % Set up the figure, axes and plot handles
            figureHandle = figure('NumberTitle','off', 'Name',...
                'Voltage Characteristics', 'Color',[1 1 1],'Visible','off');
            axesHandle = axes('Parent',figureHandle);
            if isequal(dimStr, '3D') | dimStr == 3
                plotHandle = plot3(axesHandle,0,0,0,'Marker','O','LineWidth',10,'Color','red');
            elseif isequal(dimStr, '2D') | dimStr == 2
                plotHandle = plot(axesHandle,0,0,'Marker','.','MarkerSize', 10,'LineWidth',10,'Color','red');
            else
                disp('Only 2 and 3 dimensional graphs are allowed. Input correct number of dimensions.');
                return
            end
            axis([-1 1  -1 1 -1 1]);

            % Create XY labels and title
            xlabel('Time','FontWeight','bold','FontSize',14,'Color',[1 1 0]);
            ylabel('Voltage in V','FontWeight','bold','FontSize',14,'Color',[1 1 0]);
            title('Real Time Data','FontSize',15,'Color',[1 1 0]);

            for f=1:1000
                %%Serial data accessing 
                position = read(self.joy);
                disp(position);

                try
                    set(plotHandle,'XData',-position(2),'YData',position(1),'ZData',position(3));
                    set(figureHandle,'Visible','on');
                catch
                    disp('Invalid or deleted object. No figure detected. Closing program.');
                    return
                end

                pause(0.2);
            end
        end
        
        % Executes automatic system. First, efector moves to initial position
            % specified by 'initPosition' array, then motors will move
            % orthogonally in a 3D grid the number of steps specified for each
            % axis in the 'nStep' array, the amount of distance specified for
            % each axis step in 'stepDistance' array. If 'multispectral' switch is on,
            % one picture will be taken for each led light.
        function startautosystem(self, data, components, updatecomponentsFunc)
            sessionPath = data{1};
            initPosition = data{2};
            nStep = data{3};
            stepDistance = data{4};
            if length(data) ~= 5
                multispectral = 'Off';
            else
                multispectral = data{5};
            end
            
            xStep = nStep(1);
            yStep = nStep(2);
            zStep = nStep(3);
            
            xDir = stepDistance(1);
            yDir = stepDistance(2);
            zDir = -stepDistance(3);
            
            stopbutton = components{1};
            startbutton = components{2};
            progresseditfield = components{3};
            ledlightstatelamp = components{4};
            ledlightslider = components{5};
            
            totalPictureNumber = xStep*yStep*zStep;
            pictureCounter = 0;
            
            self.checkpausestopstatus(stopbutton, startbutton);
            updatecomponentsFunc();
            
            self.moveefector(initPosition);

            for pz = zStep:-1:1
               for py = yStep:-1:1
                   for px = xStep:-1:1
                       if multispectral == "On"
                           for r = 1:3 % Loop three times, IR, VL & UV
                               if r == 2 % If r = 2, turn leds off (VL)
                                   self.ledlight(0);
                                   wavelengthStr = '0';
                                   ledlightslider.Value = 0;
                                   ledlightstatelamp.Color = 'r';
                               else
                                   self.ledlight(r);
                                   wavelengthStr = num2str(self.ledWavelength(r));
                                   ledlightslider.Value = r;
                                   ledlightstatelamp.Color = 'g';
                               end
                               self.checkpausestopstatus(stopbutton, startbutton);
                               updatecomponentsFunc();
                               name = strcat('L', wavelengthStr, 'P', num2str(abs(pz-zStep)), ...
                                   num2str(abs(py-yStep),'%02.f'), num2str(abs(px-xStep), '%02.f')); % Format: L000PZYYXX
                               pictureCounter = pictureCounter + 1;
                               
                               disp(append('Name: ', name)); % Name file: prefix + number
                               self.capture(append(sessionPath,'\',name,'.jpg'));
                               progresseditfield.Value = append('Foto ', num2str(pictureCounter),' de ', num2str(totalPictureNumber*3));
                               self.ledlight(0);
                               pause(0.3);
                               self.checkpausestopstatus(stopbutton, startbutton);
                           end
                       else % If multispectral == "Off"
                           self.checkpausestopstatus(stopbutton, startbutton);
                           updatecomponentsFunc();
                           name = strcat('P', num2str(abs(pz-zStep)), num2str(abs(py-yStep),...
                               '%02.f'), num2str(abs(px-xStep), '%02.f')); % Format: PZYYXX
                           pictureCounter = pictureCounter + 1;
                            
                           disp(append('Name: ',name)); % Name file: prefix + number
                           self.capture(append(sessionPath,'\',name,'.jpg'));
                           progresseditfield.Value = append('Foto ', num2str(pictureCounter),' de ', num2str(totalPictureNumber*3));
                           pause(0.3);
                           self.checkpausestopstatus(stopbutton, startbutton);
                       end    
                       if px > 1 % If px is 1 or less, dont move in that direction
                           disp("Moving X");
                           self.shiftmotor('X', xDir);
                       end
                   end
                   if py > 1 % If py is 1 or less, dont move in that direction
                       disp("Moving Y");
                       self.shiftmotor('Y', yDir);
                       xDir = -xDir;
                   end
               end
               if pz > 1 % If pz is 1 or less, dont move in that direction
                   disp("Moving Z");
                   self.shiftmotor('Z', zDir);
                   xDir = -xDir;
                   yDir = -yDir;
               end
            end
            updatecomponentsFunc();
            
            stopbutton.Enable = 'off';
            stopbutton.Text = 'Terminar';
            startbutton.Text = 'Empezar';
            startbutton.BackgroundColor = 'green';
            startbutton.Value = true;
        end
        
        % Destructor function. Closes motors, unloads libximc library and
            % clears class properties.
        function closerobot(self)
            disp('Closing motors');
            try
                xAxisIdPtr = libpointer('int32Ptr', self.axisId.x{2});
                yAxisIdPtr = libpointer('int32Ptr', self.axisId.y{2});
                zAxisIdPtr = libpointer('int32Ptr', self.axisId.z{2});

                calllib('libximc','close_device', xAxisIdPtr);
                calllib('libximc','close_device', yAxisIdPtr);
                calllib('libximc','close_device', zAxisIdPtr);
                disp('Success');
            catch
                disp('Error closing devices. Motors may be disconnected.');
            end
            
            self.ximc.unloadlib;
            clear self.ximc self.a self.vid;
        end
    end
    
    methods (Access = private)
        % Takes string calling one of the three axis XYZ, returns
            % device ID to control each of the motors, saving memory space
        function [deviceId] = setdeviceid(self, deviceStr)
            switch deviceStr
                case 'X'
                    deviceId = self.axisId.x;
                case 'Y'
                    deviceId = self.axisId.y;
                case 'Z'
                    deviceId = self.axisId.z;
                otherwise
                    deviceId = {'Error', 0};
            end
        end
        
        % Takes string calling one of the three axis XYZ, returns
            % device settings to setup each of the motors, saving memory space
        function [deviceSettings] = setdevicesettings(self, deviceStr)
            switch deviceStr
                case 'X'
                    deviceSettings = self.xAxisCalibratedSettings;
                case 'Y'
                    deviceSettings = self.yAxisCalibratedSettings;
                case 'Z'
                    deviceSettings = self.zAxisCalibratedSettings;
                otherwise
                    deviceSettings = -1;
            end
        end
        
        % To control one linear motor with one joystick axis
            % if joystick input (joyPosition) is between -0.1 and 0.1, stop
            % else move left or right
        function joycontrolaxis(self, joyPosition, deviceStr)
            deviceId = self.setdeviceid(deviceStr);
            if joyPosition > 0.1
                self.ximc.inputcommand(deviceId, 'right');
            elseif joyPosition < -0.1
                self.ximc.inputcommand(deviceId, 'left');
            else
                self.ximc.inputcommand(deviceId, 'sstp');
            end
        end
    end
    
    methods(Static)
        function checkpausestopstatus(stopbutton, pausebutton)
            if ~stopbutton.Value
                error('MATLAB:eyeTrackAPP:abort','User aborted execution.')
            end
            if pausebutton.Value
                waitfor(pausebutton,'Value',false)
            end
        end

        % To test if properties work as expected
        function test(input)
            disp(input);
        end

        % To ignore functions and skip them
        function ignore
            disp('Ignore Function');
        end
    end
end