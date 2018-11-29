function [] = HOOK_2_KRL_Cartesian_LIN()

clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUT PARAMETERS %%%
%%%%%%%%%%%%%%%%%%%%%%%%

xmin = -200;    % Min X [mm]
xmax = 200;     % Max X [mm]

ymin = -200;    % Min Y [mm]
ymax = 200;     % Max Y [mm]

zmin = -200;    % Min Z [mm]
zmax = 200;     % Max Z [mm]

amin = -45;     % Min A [degrees]
amax = 45;      % Max A [degrees]

bmin = -45;      % Min B [degrees]
bmax = 45;     % Max B [degrees]

cmin = -45;     % Min C [degrees]
cmax = 45;      % Max C [degrees]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CREATION OF GRAPHICAL USER INTERFACE (GUI) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = [];

H.startPos = [572.81 0 447.81 0 90 0];
A=deg2rad(H.startPos(4));sinA=sin(A);cosA=cos(A);
B=deg2rad(H.startPos(5));sinB=sin(B);cosB=cos(B);
C=deg2rad(H.startPos(6));sinC=sin(C);cosC=cos(C);

RA=[cosA  -sinA   0;
    sinA  cosA    0;
    0     0       1];

RB=[cosB  0   sinB;
    0  1  0;
    -sinB  0  cosB];

RC=[1  0   0;
    0  cosC  -sinC;
    0  sinC  cosC];

H.R=(RA*RB*RC);

H.waitbar = waitbar(0,'Please wait ...');
set(H.waitbar,'visible','off');

H.fhandle = figure('unit','normalized','outerposition',[0 0 1 1],'MenuBar','none','ToolBar','none');
H.ax(1) = subplot(2,2,1);plot3(nan,nan,nan);grid on; box on; hold on;%axis equal;
view(0,90);xlabel('X');ylabel('Z');xlim([xmin xmax]);ylim([zmin zmax]);title('X - Z   PLANE');
plot([xmin xmax],[0 0],'k--'); plot([0 0],[xmin xmax],'k--');
H.point(1) = plot(0,0,'+r','markersize',20,'linewidth',3);
H.ax(2) = subplot(2,2,2);plot3(nan,nan,nan); grid on; box on; hold on;%axis equal;
plot([ymin ymax],[0 0],'k--'); plot([0 0],[xmin xmax],'k--');
view(0,90);xlabel('Y');ylabel('Z');xlim([ymin ymax]);ylim([zmin zmax]);title('Y - Z   PLANE');
H.point(2) = plot(0,0,'+r','markersize',20,'linewidth',3);
H.ax(3) = subplot(2,2,3);plot3(nan,nan,nan);grid on; box on; hold on;%axis equal;
view(0,90);xlabel('A');ylabel('C');xlim([amin amax]);ylim([cmin cmax]);title('A - C   wrist rotation');
plot([amin amax],[0 0],'k--'); plot([0 0],[amin amax],'k--');
H.point(3) = plot(0,0,'+r','markersize',20,'linewidth',3);
H.ax(4) = subplot(2,2,4);plot3(nan,nan,nan); grid on; box on; hold on;%axis equal;
plot([bmin bmax],[0 0],'k--'); plot([0 0],[cmin cmax],'k--');
view(0,90);xlabel('B');ylabel('C');xlim([bmin bmax]);ylim([cmin cmax]);title('B - C   wrist rotation');
H.point(4) = plot(0,0,'+r','markersize',20,'linewidth',3);
set(H.ax(1),'Position',[0.2250 0.5600 0.3500 0.4000]);
set(H.ax(2),'Position',[0.6250 0.5600 0.3500 0.4000]);
set(H.ax(3),'Position',[0.2250 0.0600 0.3500 0.4000]);
set(H.ax(4),'Position',[0.6250 0.0600 0.3500 0.4000]);

H.tx(1) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.01 0.10 0.1 0.45],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string',{'x = 0.00';'y = 0.00';'z = 0.00';'a = 0.00';'b = 0.00';'c = 0.00';...
              ' ';'A1 = NaN';'A2 = NaN';'A3 = NaN';'A4 = NaN';'A5 = NaN';'A6 = NaN'},'HorizontalAlignment','left');
H.tx(4) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.01 0.55 0.1 0.08],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string',{'Current';'command';'coordinates'},...
    'HorizontalAlignment','left');
H.tx(5) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.11 0.10 0.06 0.45],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string',{'x = NaN';'y = NaN';'z = NaN';'a = NaN';'b = NaN';'c = NaN';...
              ' '; 'A1 = NaN';'A2 = NaN';'A3 = NaN';'A4 = NaN';'A5 = NaN';'A6 = NaN'},...
    'HorizontalAlignment','left');
H.tx(6) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.11 0.55 0.06 0.08],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string',{'Current';'feedback';'coordinates'},...
    'HorizontalAlignment','left');
H.tx(10) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.01 0.03 0.10 0.27],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Update frequency:',...
    'HorizontalAlignment','left');
H.tx(11) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.11 0.03 0.08 0.27],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','NaN',...
    'HorizontalAlignment','left');
H.tx(2) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.01 0.74 0.10 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Speed [mm/s]',...
    'HorizontalAlignment','left');
H.ed(1) = uicontrol('style','edit',...
    'unit','normalized',...
    'posit',[0.14 0.74 0.04 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','1000');
H.tx(3) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.01 0.7 0.14 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Acceleration [mm/s^2]',...
    'HorizontalAlignment','left');
H.ed(2) = uicontrol('style','edit',...
    'unit','normalized',...
    'posit',[0.14 0.7 0.04 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','2000');
H.tx(7) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.01 0.94 0.09 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Computer IP:',...
    'HorizontalAlignment','left');
H.ed(3) = uicontrol('style','edit',...
    'unit','normalized',...
    'posit',[0.10 0.945 0.08 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','10.1.1.1');
H.tx(8) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.01 0.9 0.09 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Robot IP:',...
    'HorizontalAlignment','left');
H.ed(4) = uicontrol('style','edit',...
    'unit','normalized',...
    'posit',[0.10 0.905 0.08 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','10.1.1.99');
H.tx(9) = uicontrol('style','tex',...
    'unit','normalized',...
    'posit',[0.01 0.86 0.09 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Socket port:',...
    'HorizontalAlignment','left');
H.ed(5) = uicontrol('style','edit',...
    'unit','normalized',...
    'posit',[0.10 0.865 0.08 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','49152');
H.ckbox(1) = uicontrol('style','checkbox',...
    'unit','normalized',...
    'posit',[0.01 0.815 0.2 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Append command packets');
H.ckbox(2) = uicontrol('style','checkbox',...
    'unit','normalized',...
    'posit',[0.01 0.785 0.2 0.03],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Send feedback packets to file');
H.button(1) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.01 0.64 0.08 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Start');
H.button(2) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.1 0.64 0.08 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Stop','enable','off');
H.button(3) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.07 0.22 0.05 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Up');
H.button(4) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.07 0.12 0.05 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Down');
H.button(5) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.02 0.17 0.05 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Left');
H.button(6) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.12 0.17 0.05 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Right');
H.button(7) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.01 0.07 0.08 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Anti-Clockwise');
H.button(8) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.1 0.07 0.08 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Clockwise');
H.button(9) = uicontrol('style','pushbutton',...
    'unit','normalized',...
    'posit',[0.03 0.02 0.12 0.04],...
    'backg',get(H.fhandle,'color'),...
    'fontsize',12,'fontweight','bold',...
    'string','Hook!');

drawnow;
FigurejFrame = get(handle(H.fhandle),'JavaFrame');
FigurejFrame.setMaximized(true);

opts = struct('WindowStyle','modal','Interpreter','tex');
warndlg({'\fontsize{11}This GUI is designed to work with the KUKA KRL module';...
         'for KRL-based real-time Cartesian control.';...
         ' ';'         Make sure to use the correct KRL module.';...
         ' '},'Warning - KRL-based real-time Cartesian control', opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SETTING CALLBACK FUNCTUIONS FOR INTERACTIVE BEHAVIOUR %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(H.button(1),'Callback', {@F_button_start,H});
set(H.button(2),'Callback', {@F_button_stop,H});
set(H.button(3),'Callback', {@F_button_Up,H});
set(H.button(4),'Callback', {@F_button_Down,H});
set(H.button(5),'Callback', {@F_button_Left,H});
set(H.button(6),'Callback', {@F_button_Right,H});
set(H.button(7),'Callback', {@F_button_Anti_Clockwise,H});
set(H.button(8),'Callback', {@F_button_Clockwise,H});
set(H.button(9),'Callback', {@F_button_Hook,H});


set(H.fhandle,'windowbuttonmotionfcn',{@F_mouseMove,H});
set(H.fhandle,'windowbuttondownfcn',{@F_mouseDown,H});
set(H.fhandle,'windowbuttonupfcn',{@F_mouseUp,H});
end

function [] = F_button_start(varargin)      % This function is activated when the start button is pushed
S = varargin{3};  % Get the structure.

set(S.button(1),'enable','off');
set(S.button(2),'enable','on');
set(S.ed(3:5),'enable','off');

set(S.waitbar,'visible','on');
set(S.waitbar,'WindowStyle','modal');

% Load DLL Library
waitbar(0,S.waitbar,'Loading library ...');
loadlibrary('robotComms.dll','robotComms.h');

% Display available DLL functions
libfunctions('robotComms')

% Setting DLL parameters
waitbar(0.1,S.waitbar,'Setting parameters ...');
calllib('robotComms','setNumRob',1);                        % Number of robots to connect to
calllib('robotComms','setRobIP',0,get(S.ed(4),'string'));   % Robot IP address
calllib('robotComms','setRobConnType',0,0);                 % Type of connection (send and receive)
calllib('robotComms','setOutputDir',pwd);                   % Feedback directory
calllib('robotComms','setRobFeedbackOutput',0,0);           % Setting feedback mode
S.savefeedback = 0;

% Opening connection
waitbar(0.2,S.waitbar,'Opening connection ...');
ComputerIP = get(S.ed(3),'string');
ConnectionPort = str2double(get(S.ed(5),'string'));
calllib('robotComms','openConn',ComputerIP,ConnectionPort);

% Wait to data to become available on the UDP socket
dataAvailable = 0;
tstart = tic;
oldElTime = toc(tstart);
while (dataAvailable == 0)
    newElTime = toc(tstart);
    w = (newElTime - oldElTime)/10;
    if w>1
        oldElTime = toc(tstart);
        newElTime = oldElTime;
        w = (newElTime - oldElTime)/10;
    end
    waitbar(w,S.waitbar,'Waiting for robot connection ...');
    dataAvailable = calllib('robotComms','isDataAvailable');
end

% Start RSI manager
waitbar(w,S.waitbar,'Starting RSI manager ...');
calllib('robotComms','startRSIManager');

% Wait for RSI to become running
tstart = tic;
oldElTime = toc(tstart);
while (calllib('robotComms','isRSIRunning',0)==0)
    newElTime = toc(tstart);
    w = (newElTime - oldElTime)/10;
    if w>1
        oldElTime = toc(tstart);
        newElTime = oldElTime;
        w = (newElTime - oldElTime)/10;
    end
    waitbar(w,S.waitbar,'Waiting for RSI ...');
end

% Allow the robot to start the task
waitbar(w,S.waitbar,'Allowing robot to start the task ...');
calllib('robotComms','allowRobotStart',0);

% Wait for the robot task to become active
tstart = tic;
oldElTime = toc(tstart);
while (calllib('robotComms','isRobotTaskActive',0) == 0)
    newElTime = toc(tstart);
    w = (newElTime - oldElTime)/10;
    if w>1
        oldElTime = toc(tstart);
        newElTime = oldElTime;
        w = (newElTime - oldElTime)/10;
    end
    waitbar(w,S.waitbar,'Waiting for the robot task to become active ...');
end

set(S.waitbar,'visible','off');
set(S.waitbar,'WindowStyle','normal');

pause(1);
tstart = tic;
oldElTime = toc(tstart);
newElTime = oldElTime;
oldElTime_refreshButton = toc(tstart);
int_cycle = 0.004;
updateRate = nan;

try
    while (calllib('robotComms','isRobotTaskActive',0) == 1)
        speed = str2double(get(S.ed(1),'string'));      % Read desired speed from GUI
        acc = str2double(get(S.ed(2),'string'));        % Read desired acceleration from GUI
        
        targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData') get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];
        
        % Refresh GUI with commanded coordinates
        set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
            ['y = ' num2str(targetPos(2),'%.2f')];...
            ['z = ' num2str(targetPos(3),'%.2f')];...
            ['a = ' num2str(targetPos(4),'%.2f')];...
            ['b = ' num2str(targetPos(5),'%.2f')];...
            ['c = ' num2str(targetPos(6),'%.2f')];...
            ' ';...
            'A1 = NaN';...
            'A2 = NaN';...
            'A3 = NaN';...
            'A4 = NaN';...
            'A5 = NaN';...
            'A6 = NaN'});
        
        A=deg2rad(targetPos(4));sinA=sin(A);cosA=cos(A);
        B=deg2rad(targetPos(5));sinB=sin(B);cosB=cos(B);
        C=deg2rad(targetPos(6));sinC=sin(C);cosC=cos(C);
        
        RA=[cosA  -sinA   0;
            sinA  cosA    0;
            0     0       1];
        
        RB=[cosB  0   sinB;
            0  1  0;
            -sinB  0  cosB];
        
        RC=[1  0   0;
            0  cosC  -sinC;
            0  sinC  cosC];
        
        RC=(RA*RB*RC);
        R=RC*S.R;
        
        targetPos(5)=rad2deg(atan2(-R(3,1),sqrt((R(1,1)^2)+(R(2,1)^2))));
        if abs(targetPos(5))==90
            targetPos(4)=0;
        else
            targetPos(4)=rad2deg(atan2(R(2,1),(R(1,1))));
        end
        
        if abs(targetPos(5))==90
            targetPos(6)=rad2deg((deg2rad(targetPos(5))/abs(deg2rad(targetPos(5))))*atan2(R(1,2),R(2,2)));
        else
            targetPos(6)=rad2deg(atan2(R(3,2),(R(3,3))));
        end
        
        if get(S.ckbox(1),'value')==1       % Check the queueing mode for command packets
            mode = 0;   % Mode 0 -> the command queue is cleared, putting the new packets to the front
        else
            mode = 1;   % Mode 1 -> the new packets are appended to the bottom of the queue
        end
        
        pause(int_cycle/10);
        
        % Sent command packet to robot
        calllib('robotComms','setCartPos', 0, targetPos(1),targetPos(2),targetPos(3), targetPos(4),targetPos(5),targetPos(6), speed, acc, mode);
        
        % Get robot current feedback coordinates
        feedbackPos = calllib('robotComms','getCurrPos',0,zeros(15,1));
        
        A=deg2rad(feedbackPos(4));sinA=sin(A);cosA=cos(A);
        B=deg2rad(feedbackPos(5));sinB=sin(B);cosB=cos(B);
        C=deg2rad(feedbackPos(6));sinC=sin(C);cosC=cos(C);
        
        RA=[cosA  -sinA   0;
            sinA  cosA    0;
            0     0       1];
        
        RB=[cosB  0   sinB;
            0  1  0;
            -sinB  0  cosB];
        
        RC=[1  0   0;
            0  cosC  -sinC;
            0  sinC  cosC];
        
        RC=(RA*RB*RC);
        R=RC/S.R;
        
        feedbackPos(5)=rad2deg(atan2(-R(3,1),sqrt((R(1,1)^2)+(R(2,1)^2))));
        
        if abs(feedbackPos(5))==90
            feedbackPos(4)=0;
        else
            feedbackPos(4)=rad2deg(atan2(R(2,1),(R(1,1))));
        end
        
        if abs(feedbackPos(5))==90
            feedbackPos(6)=rad2deg((deg2rad(feedbackPos(5))/abs(deg2rad(feedbackPos(5))))*atan2(R(1,2),R(2,2)));
        else
            feedbackPos(6)=rad2deg(atan2(R(3,2),(R(3,3))));
        end
        
        % Refresh GUI with feedback coordinates
        set(S.tx(5),'str',{['x = ' num2str(feedbackPos(1),'%.2f')];...
            ['y = ' num2str(feedbackPos(2),'%.2f')];...
            ['z = ' num2str(feedbackPos(3),'%.2f')];...
            ['a = ' num2str(feedbackPos(4),'%.2f')];...
            ['b = ' num2str(feedbackPos(5),'%.2f')];...
            ['c = ' num2str(feedbackPos(6),'%.2f')];...
            ' ';...
            ['A1 = ' num2str(feedbackPos(7),'%.2f')];...
            ['A2 = ' num2str(feedbackPos(8),'%.2f')];...
            ['A3 = ' num2str(feedbackPos(9),'%.2f')];...
            ['A4 = ' num2str(feedbackPos(10),'%.2f')];...
            ['A5 = ' num2str(feedbackPos(11),'%.2f')];...
            ['A6 = ' num2str(feedbackPos(12),'%.2f')]});
        
        if (S.savefeedback ~= get(S.ckbox(2),'value'))  % Check if the saving preference has changed
            if get(S.ckbox(2),'value')==1               % Check if the feedback saving is required
                calllib('robotComms','setRobFeedbackOutput',0,3); % Save timestamped Cartesian and Axial feedback coordinates
                S.savefeedback = 1;
            else
                calllib('robotComms','setRobFeedbackOutput',0,0); % Do not sent feedback packets to file
                S.savefeedback = 0;
            end
        end
        
        % Make the stop buttom flash to inform the user real-time control is live
        newElTime_refreshButton = toc(tstart);
        if (newElTime_refreshButton-oldElTime_refreshButton) >= 0.5
            if isequal(get(S.button(2),'backg'), [0 1 0])
                set(S.button(2),'backg',get(S.fhandle,'color'));
            else
                set(S.button(2),'backg',[0 1 0]);
            end
            set(S.tx(11),'string',[num2str(updateRate,'%.1f'),' Hz']);  % Refresh update rate in GUI
            oldElTime_refreshButton = newElTime_refreshButton;
        end
        
        % Pause while the loop elapsed time is shorter than the robot interpolation cycle
        while (newElTime-oldElTime) <= int_cycle
            newElTime = toc(tstart);
        end
        updateRate = 1/(newElTime-oldElTime);
        oldElTime = newElTime;
    end
catch
    set(S.button(2),'backg',get(S.fhandle,'color'));
end
set(S.button(2),'backg',get(S.fhandle,'color'));
set(S.tx(1),'string',{'x = 0.00';'y = 0.00';'z = 0.00';'a = 0.00';'b = 0.00';'c = 0.00';...
            ' ';'A1 = NaN';'A2 = NaN';'A3 = NaN';'A4 = NaN';'A5 = NaN';'A6 = NaN'});
set(S.tx(5),'string',{'x = NaN';'y = NaN';'z = NaN';'a = NaN';'b = NaN';'c = NaN';...
            ' '; 'A1 = NaN';'A2 = NaN';'A3 = NaN';'A4 = NaN';'A5 = NaN';'A6 = NaN'});
end

function [] = F_button_stop(varargin)   % This function is activated when the stop button is pushed
S = varargin{3};  % Get the structure.

set(S.button(1),'enable','on');
drawnow;
set(S.button(2),'backg',get(S.fhandle,'color'));
set(S.button(2),'enable','off');

set(S.waitbar,'visible','on');
set(S.waitbar,'WindowStyle','modal');

% Request stop of RSI_MOVECORR function in KRL module 
waitbar(0.3,S.waitbar,'Terminating real-time control ...');
calllib('robotComms','requRobTaskEnd',0);

% Wait for the robot task to become inactive
tstart = tic;
oldElTime = toc(tstart);
while (calllib('robotComms','isRobotTaskActive',0) == 1)
    newElTime = toc(tstart);
    w = (newElTime - oldElTime)/10;
    if w>1
        oldElTime = toc(tstart);
        newElTime = oldElTime;
        w = (newElTime - oldElTime)/10;
    end
    waitbar(w,S.waitbar,'Waiting for the robot task to become inactive ...');
end

% Allow robot to exit the task and return home
waitbar(0.3,S.waitbar,'Allowing the robot to return home ...');
calllib('robotComms','allowRobotFinish',0);

% Wait for RSI to become inactive
tstart = tic;
oldElTime = toc(tstart);
while (calllib('robotComms','isRSIRunning',0)==1)
    newElTime = toc(tstart);
    w = (newElTime - oldElTime)/10;
    if w>1
        oldElTime = toc(tstart);
        newElTime = oldElTime;
        w = (newElTime - oldElTime)/10;
    end
    waitbar(w,S.waitbar,'Waiting for RSI to turn off ...');
end

% Terminate RSI manager
waitbar(0.4,S.waitbar,'Terminating RSI manager ...');
calllib('robotComms','terminateRSIManager');

% Close connection
waitbar(0.6,S.waitbar,'Closing connection ...');
calllib('robotComms','closeConn');

% Uniload library
waitbar(0.9,S.waitbar,'Unloading library ...');
unloadlibrary('robotComms');

set(S.point(1),'XData',0);
set(S.point(1),'YData',0);
set(S.point(2),'XData',0);
set(S.point(2),'YData',0);
set(S.point(3),'XData',0);
set(S.point(3),'YData',0);
set(S.point(4),'XData',0);
set(S.point(4),'YData',0);

set(S.tx(1),'string',{'x = 0.00';'y = 0.00';'z = 0.00';'a = 0.00';'b = 0.00';'c = 0.00';...
            ' ';'A1 = NaN';'A2 = NaN';'A3 = NaN';'A4 = NaN';'A5 = NaN';'A6 = NaN'});
set(S.tx(5),'string',{'x = NaN';'y = NaN';'z = NaN';'a = NaN';'b = NaN';'c = NaN';...
            ' '; 'A1 = NaN';'A2 = NaN';'A3 = NaN';'A4 = NaN';'A5 = NaN';'A6 = NaN'});

set(S.waitbar,'visible','off');
set(S.waitbar,'WindowStyle','normal');
set(S.ed(3:5),'enable','on');
set(S.tx(11),'string','NaN');
end


function [] = F_mouseMove(varargin)

k = 0;

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

for ii = 1:4
    AXP = get(S.ax(ii),'position');
    tf1 = (AXP(1) <= F(1)) && (F(1) <= AXP(1) + AXP(3));
    tf2 = (AXP(2) <= F(2)) && (F(2) <= AXP(2) + AXP(4));
    
    if (tf1 && tf2)
        k = ii;
        break
    end
end

if k
    set(gcf,'Pointer','fleur');
else
    set(gcf,'Pointer','arrow');
end

end

function [] = F_mouseDown(varargin)

k = 0;

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

for ii = 1:4
    AXP = get(S.ax(ii),'position');
    tf1 = (AXP(1) <= F(1)) && (F(1) <= AXP(1) + AXP(3));
    tf2 = (AXP(2) <= F(2)) && (F(2) <= AXP(2) + AXP(4));
    
    if (tf1 && tf2)
        k = ii;
        break
    end
end

if k
    set(gcf,'Pointer','fleur');
    set(S.fhandle,'windowbuttonmotionfcn',{@F_mouseMoveDown,S});
else
    set(gcf,'Pointer','arrow');
    set(S.fhandle,'windowbuttonmotionfcn',{@F_mouseMove,S});
end
end

function [] = F_mouseMoveDown(varargin)

k = 0;

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

for ii = 1:4
    AXP = get(S.ax(ii),'position');
    tf1 = (AXP(1) <= F(1)) && (F(1) <= AXP(1) + AXP(3));
    tf2 = (AXP(2) <= F(2)) && (F(2) <= AXP(2) + AXP(4));
    
    if (tf1 && tf2)
        k = ii;
        break
    end
end

if k
    if (S.ax(ii) == gca)
        set(gcf,'Pointer','fleur');
        axes(S.ax(ii));
        P = get(gca,'currentpoint');
        if ii==1
            set(S.point(1),'XData',P(1,1));
            set(S.point(1),'YData',P(1,2));
            set(S.point(2),'YData',P(1,2));
        elseif ii==2
            set(S.point(2),'XData',P(1,1));
            set(S.point(2),'YData',P(1,2));
            set(S.point(1),'YData',P(1,2));
        elseif ii==3
            set(S.point(3),'XData',P(1,1));
            set(S.point(3),'YData',P(1,2));
            set(S.point(4),'YData',P(1,2));
        elseif ii==4
            set(S.point(4),'XData',P(1,1));
            set(S.point(4),'YData',P(1,2));
            set(S.point(3),'YData',P(1,2));
        end
        
        if strcmp(get(S.button(1),'enable'),'on')
            targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData')  get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];
            
            % Refresh GUI with commanded coordinates
            set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
                ['y = ' num2str(targetPos(2),'%.2f')];...
                ['z = ' num2str(targetPos(3),'%.2f')];...
                ['a = ' num2str(targetPos(4),'%.2f')];...
                ['b = ' num2str(targetPos(5),'%.2f')];...
                ['c = ' num2str(targetPos(6),'%.2f')];...
                ' ';...
                'A1 = NaN';...
                'A2 = NaN';...
                'A3 = NaN';...
                'A4 = NaN';...
                'A5 = NaN';...
                'A6 = NaN'});
        end
    end
    
    if strcmp(get(S.button(1),'enable'),'on')
        if isequal(get(S.button(1),'backg'), [1 0 0])
            set(S.button(1),'backg',get(S.fhandle,'color'));
        else
            set(S.button(1),'backg',[1 0 0]);
        end
    end
else
    set(gcf,'Pointer','arrow');
    set(S.button(1),'backg',get(S.fhandle,'color'));
    set(S.fhandle,'windowbuttonmotionfcn',{@F_mouseMove,S});
end
end

function [] = F_mouseUp(varargin)

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
set(S.button(1),'backg',get(S.fhandle,'color'));

set(S.fhandle,'windowbuttonmotionfcn',{@F_mouseMove,S});
set(S.fhandle,'windowbuttondownfcn',{@F_mouseDown,S});
set(gcf,'Pointer','arrow');
end

function [] = F_button_Up(varargin)

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

P = [get(S.point(1),'XData');   %X
     get(S.point(2),'XData');   %Y
     get(S.point(1),'YData');   %Z
     get(S.point(3),'XData');   %A
     get(S.point(4),'XData');   %B
     get(S.point(3),'YData')];  %C
    
P(2) = P(2) + 25;

set(S.point(2),'XData',P(2));

targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData')  get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];

% Refresh GUI with commanded coordinates
set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
    ['y = ' num2str(targetPos(2),'%.2f')];...
    ['z = ' num2str(targetPos(3),'%.2f')];...
    ['a = ' num2str(targetPos(4),'%.2f')];...
    ['b = ' num2str(targetPos(5),'%.2f')];...
    ['c = ' num2str(targetPos(6),'%.2f')];...
    ' ';...
    'A1 = NaN';...
    'A2 = NaN';...
    'A3 = NaN';...
    'A4 = NaN';...
    'A5 = NaN';...
    'A6 = NaN'});
            
if strcmp(get(S.button(1),'enable'),'on')
    if isequal(get(S.button(1),'backg'), [1 0 0])
        set(S.button(1),'backg',get(S.fhandle,'color'));
    else
        set(S.button(1),'backg',[1 0 0]);
    end
end

end

function [] = F_button_Down(varargin)

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

P = [get(S.point(1),'XData');
     get(S.point(2),'XData');
     get(S.point(1),'YData');
     get(S.point(3),'XData');
     get(S.point(4),'XData');
     get(S.point(3),'YData')];
    
P(2) = P(2) - 25;

set(S.point(2),'XData',P(2));

targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData')  get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];

% Refresh GUI with commanded coordinates
set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
    ['y = ' num2str(targetPos(2),'%.2f')];...
    ['z = ' num2str(targetPos(3),'%.2f')];...
    ['a = ' num2str(targetPos(4),'%.2f')];...
    ['b = ' num2str(targetPos(5),'%.2f')];...
    ['c = ' num2str(targetPos(6),'%.2f')];...
    ' ';...
    'A1 = NaN';...
    'A2 = NaN';...
    'A3 = NaN';...
    'A4 = NaN';...
    'A5 = NaN';...
    'A6 = NaN'});
            
if strcmp(get(S.button(1),'enable'),'on')
    if isequal(get(S.button(1),'backg'), [1 0 0])
        set(S.button(1),'backg',get(S.fhandle,'color'));
    else
        set(S.button(1),'backg',[1 0 0]);
    end
end

end

function [] = F_button_Left(varargin)

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

P = [get(S.point(1),'XData');
     get(S.point(2),'XData');
     get(S.point(1),'YData');
     get(S.point(3),'XData');
     get(S.point(4),'XData');
     get(S.point(3),'YData')];
    
P(1) = P(1) - 25;

set(S.point(1),'XData',P(1));

targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData')  get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];

% Refresh GUI with commanded coordinates
set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
    ['y = ' num2str(targetPos(2),'%.2f')];...
    ['z = ' num2str(targetPos(3),'%.2f')];...
    ['a = ' num2str(targetPos(4),'%.2f')];...
    ['b = ' num2str(targetPos(5),'%.2f')];...
    ['c = ' num2str(targetPos(6),'%.2f')];...
    ' ';...
    'A1 = NaN';...
    'A2 = NaN';...
    'A3 = NaN';...
    'A4 = NaN';...
    'A5 = NaN';...
    'A6 = NaN'});
            
if strcmp(get(S.button(1),'enable'),'on')
    if isequal(get(S.button(1),'backg'), [1 0 0])
        set(S.button(1),'backg',get(S.fhandle,'color'));
    else
        set(S.button(1),'backg',[1 0 0]);
    end
end

end

function [] = F_button_Right(varargin)

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

P = [get(S.point(1),'XData');
     get(S.point(2),'XData');
     get(S.point(1),'YData');
     get(S.point(3),'XData');
     get(S.point(4),'XData');
     get(S.point(3),'YData')];
    
P(1) = P(1) + 25;

set(S.point(1),'XData',P(1));

targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData')  get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];

% Refresh GUI with commanded coordinates
set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
    ['y = ' num2str(targetPos(2),'%.2f')];...
    ['z = ' num2str(targetPos(3),'%.2f')];...
    ['a = ' num2str(targetPos(4),'%.2f')];...
    ['b = ' num2str(targetPos(5),'%.2f')];...
    ['c = ' num2str(targetPos(6),'%.2f')];...
    ' ';...
    'A1 = NaN';...
    'A2 = NaN';...
    'A3 = NaN';...
    'A4 = NaN';...
    'A5 = NaN';...
    'A6 = NaN'});
            
if strcmp(get(S.button(1),'enable'),'on')
    if isequal(get(S.button(1),'backg'), [1 0 0])
        set(S.button(1),'backg',get(S.fhandle,'color'));
    else
        set(S.button(1),'backg',[1 0 0]);
    end
end

end

function [] = F_button_Anti_Clockwise(varargin)

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

P = [get(S.point(1),'XData');
     get(S.point(2),'XData');
     get(S.point(1),'YData');
     get(S.point(3),'XData');
     get(S.point(4),'XData');
     get(S.point(3),'YData')];
    
P(6) = P(6) - 10;

set(S.point(3),'YData',P(6));
set(S.point(4),'YData',P(6));

targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData')  get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];

% Refresh GUI with commanded coordinates
set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
    ['y = ' num2str(targetPos(2),'%.2f')];...
    ['z = ' num2str(targetPos(3),'%.2f')];...
    ['a = ' num2str(targetPos(4),'%.2f')];...
    ['b = ' num2str(targetPos(5),'%.2f')];...
    ['c = ' num2str(targetPos(6),'%.2f')];...
    ' ';...
    'A1 = NaN';...
    'A2 = NaN';...
    'A3 = NaN';...
    'A4 = NaN';...
    'A5 = NaN';...
    'A6 = NaN'});
            
if strcmp(get(S.button(1),'enable'),'on')
    if isequal(get(S.button(1),'backg'), [1 0 0])
        set(S.button(1),'backg',get(S.fhandle,'color'));
    else
        set(S.button(1),'backg',[1 0 0]);
    end
end

end

function [] = F_button_Clockwise(varargin)

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

P = [get(S.point(1),'XData');
     get(S.point(2),'XData');
     get(S.point(1),'YData');
     get(S.point(3),'XData');
     get(S.point(4),'XData');
     get(S.point(3),'YData')];
    
P(6) = P(6) + 10;

set(S.point(3),'YData',P(6));
set(S.point(4),'YData',P(6));

targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData')  get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];

% Refresh GUI with commanded coordinates
set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
    ['y = ' num2str(targetPos(2),'%.2f')];...
    ['z = ' num2str(targetPos(3),'%.2f')];...
    ['a = ' num2str(targetPos(4),'%.2f')];...
    ['b = ' num2str(targetPos(5),'%.2f')];...
    ['c = ' num2str(targetPos(6),'%.2f')];...
    ' ';...
    'A1 = NaN';...
    'A2 = NaN';...
    'A3 = NaN';...
    'A4 = NaN';...
    'A5 = NaN';...
    'A6 = NaN'});
            
if strcmp(get(S.button(1),'enable'),'on')
    if isequal(get(S.button(1),'backg'), [1 0 0])
        set(S.button(1),'backg',get(S.fhandle,'color'));
    else
        set(S.button(1),'backg',[1 0 0]);
    end
end

end

function [] = F_button_Hook(varargin)

% WindowButtonMotionFcn for the figure.
S = varargin{3};  % Get the structure.
F = get(S.fhandle,'currentpoint');  % The current point w.r.t the figure.
% Figure out of the current point is over the axes or not -> logicals.

P = [get(S.point(1),'XData');
     get(S.point(2),'XData');
     get(S.point(1),'YData');
     get(S.point(3),'XData');
     get(S.point(4),'XData');
     get(S.point(3),'YData')];
    
P(3) = P(3) + 175;

set(S.point(1),'YData',P(3));
set(S.point(2),'YData',P(3));


targetPos = [get(S.point(1),'XData') get(S.point(2),'XData') get(S.point(1),'YData')  get(S.point(3),'XData') get(S.point(4),'XData') get(S.point(3),'YData')];

% Refresh GUI with commanded coordinates
set(S.tx(1),'str',{['x = ' num2str(targetPos(1),'%.2f')];...
    ['y = ' num2str(targetPos(2),'%.2f')];...
    ['z = ' num2str(targetPos(3),'%.2f')];...
    ['a = ' num2str(targetPos(4),'%.2f')];...
    ['b = ' num2str(targetPos(5),'%.2f')];...
    ['c = ' num2str(targetPos(6),'%.2f')];...
    ' ';...
    'A1 = NaN';...
    'A2 = NaN';...
    'A3 = NaN';...
    'A4 = NaN';...
    'A5 = NaN';...
    'A6 = NaN'});
            
if strcmp(get(S.button(1),'enable'),'on')
    if isequal(get(S.button(1),'backg'), [1 0 0])
        set(S.button(1),'backg',get(S.fhandle,'color'));
    else
        set(S.button(1),'backg',[1 0 0]);
    end
end

end