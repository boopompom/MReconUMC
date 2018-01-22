function slicer(data,aspect,initClims,initCoord,initCH)
%% Function for displaying 3D/4D data sets
% INPUT:    - data (either 3D or 4D, with time as 4th dimension)
%           - aspect ratio in vector format (eg: [1 1 3] if z is 3 times
%             larger than x and y.
%           - initial 2-element color limit vector (e.g.: [0, 1])
%           - initial 3D/4D coordinate (e.g.: [1,1,1] or [1,1,1,1])
%           - setting to show crosshair on initialization (default: 0)
%
% OUTPUT:   Currently no output is defined.
%
% EXAMPLES: - slicer(data) 
%           - slicer(data,[1,1,1],[0,1])
%           - slicer(data,[],[0,1])
%           - slicer(data,[],[],[1,1,1])
%           Default settings are used when input is [].
%
% Functionality
%   - Clicking activates current viewport/subplot
%   - Scrolling lets you skip through slices the active viewport.
%   - Scrolling in plot 4 changes the display of the 4th dimension in the
%     image. The currently displayed data is indicated by an asterisk in
%     the plot of the 4th dimension. (4D data only)
%   - 10x faster scrolling can be toggled by pressing Ctrl key.
%   - Right clicking in the image creates a crosshair. The value at this
%     point is reported above the 4th viewport/subplot. In case of 4D data
%     this subplot will also show the signal evolution in the 4th dimension
%     (e.g., the time series) of the point at the crosshair.
%   - Clicking the scroll wheel on a crosshair will hide all crosshairs
%   - Arrow buttons scale the image (all viewports simultaneously)
% 
% v1.0 July 2014
% Tim Schakel, Frank Simonis, Bjorn Stemkens.
%
% v1.1 April 2015
% fixed for Matlab2014b & higher
%
% v2.0 December 2017
% Stefan Zijlema
% - Changed @click to 'WindowButtonUpFcn'
% - Solve right-click errors on subplot 4
% - Made crosshair partially transparent
% - Added hide crosshair with scroll wheel click
% - Fixed incorrect updating of slice numbers and coordinates when creating
%   crosshairs in other subplot
% - Fixed incorrect updating of slice numbers and coordinates when
%   scrolling
% - Added slice changes in two other dimensions when crosshair was created
% - Enable (continuous) scrolling through time-series of 4D dataset,
%   including updates of all slices
% - Removed drag function (use scrolling in subplot 4)
% - Improved y-scaling in time plot (4D only)
% - Fixed error in imagesc when range values are equal
% - Fixed issue in @scale for very small values or tight boundaries
%
% 22-12-2017
% Tim: fix for bug that showed crosshair when scrolling after
%      initialization
%
% 02-01-2018
% Stefan
% - Added possibility to call with initial coordinate
% - Save CLimRange in slicer directory and remove when figure closes
%
% 11-01-2018
% Stefan
% - Added fast scroll (toggle with Ctrl key)
% - Added functionality to call function with initial coordinate
% - Added possibility to show crosshair on start


%% Settings
    crosshairAlpha = 0.7; %Sets transparency of crosshair. Default: 0.7
    
    titleLines = {'Transversal view: ', 'Coronal view: ', 'Sagittal view: '};
    
    colormapName = 'gray'; %Default: 'gray'
    
%% Initialize
    if ~isreal(data)
        fprintf('The program will automatically use absolute data.\n');
        data = abs(data);
    end
    
    egg=0;
    if nargin < 2
        aspect=[1,1,1];
        egg=0;
    elseif ischar(aspect) && strcmp(aspect,[char(80),char(86)])
        aspect=[1,1,1];
        egg=1;
    elseif length(aspect)<3
        aspect=[1,1,1];
        egg=0;
    end
    
    dim=size(data);
    ndim=length(size(data));
    
    if nargin<4
        initCoord=[];
        if nargin<3
            initClims=[];
        end
    else
        %Check if coordinate matches data size
        if ~isempty(initCoord) && length(initCoord) ~= ndim
            if length(initCoord)<ndim
                warning('initial coordinate size does not match data size')
            elseif length(initCoord)>ndim
                error('initial coordinate size does not match data size')
            end
        end
    end
    
    if nargin<5
        initCH=0;
    end

    %Check if datasizes are valid
    if ndim<3 || ndim>4
        error('Error: cannot handle this type of data. Only 3d or 4d data is allowed');
    end
    
    k=round(size(data)/2); % Default display are the center slices
    if ~isempty(initCoord)
        k(1:length(initCoord))=initCoord;
    end
    
    %Set color limits
    if ~isempty(initClims)
        range = initClims;
    else
        range=[min(data(:)),max(data(:))];
    end
    
    %Check if range values are the same to avoid error on imagesc
    if range(1)==range(2)
        range(2)=range(2)+0.01;
    end
    step=abs(max(data(:))-min(data(:)))/100;
    scrollStep = 1;
    lastPoint = [];
    whichView = 1;
    p = [k(2),k(1),k(3)
         k(2),k(1),k(3)];
    if ndim==3
        offsliceCoord = [3 1 2];
    elseif ndim==4
        offsliceCoord = [3 1 2 4];
    end

%% Make figure
    f1=figure('Position',[50 50 800 800],'Name',inputname(1),'Color',[1 1 1],...
        'WindowScrollWheelFcn', @scroller, ....
        'WindowKeyPressFcn',@scale, ...
        'WindowKeyReleaseFcn',@fastScroll, ...
        'WindowButtonUpFcn', @click, ...
        'CloseRequestFcn',@closefun);
    
    colormap(colormapName)
    if ndim==3
        k(4)=1;
        handle{1} = subplot(221);
        imHandles{1} = imagesc(squeeze(data(:,:,k(3))),range);
        set(gca,'DataAspectRatio',[aspect(1) aspect(2) 1])
        axis off
        titleHandles{1} = title(num2str(k(3)),'FontSize',12);

        handle{2} = subplot(222);
        imHandles{2} = imagesc(squeeze(data(k(1),:,:))',range);
        set(gca,'DataAspectRatio',[aspect(3) aspect(1) 1],'YDir','normal')
        axis off
        titleHandles{2} = title(num2str(k(1)),'FontSize',12);

        handle{3} = subplot(223);
        imHandles{3} = imagesc(squeeze(data(:,k(2),:))',range);
        set(gca,'DataAspectRatio',[aspect(3) aspect(2) 1],'YDir','normal')
        axis off
        titleHandles{3} = title(num2str(k(2)),'FontSize',12);

        for i = 1:3
            set(titleHandles{i}, 'String', [sprintf('%s%d', titleLines{i}, k(offsliceCoord(i))),' of ', num2str(dim(offsliceCoord(i)))]);
        end
        
        %Plot a fancy logo in the otherwise empty subplot
        handle{4} = subplot(224);
        patch([0,0,50,50],[0,50,50,0],'white');
        patch([0,50,65,15],[50,50,65,65],'white')
        patch([50,65,65,50],[0,15,65,50],'white')
        for m=[6,9,11,13,13.5,14,14.5,15];
            line([m,50+m],[50+m,50+m],'Color','k');
            line([50+m,50+m],[m,50+m],'Color','k');
        end; 
        axis image off
        if egg
            text(4,25,char([80,114,111,106,101,99,116,32,86]),'FontSize',32,'FontName','Arial')
        else
        text(4,25,'Slicer','FontSize',52,'FontName','Arial')
        end
        value = data(k(1),k(2),k(3)); if value>10^5;value=num2str(value,'%10.4e\n');else value=num2str(value);end
        titleHandles{4} = title({['Crosshair at point [',num2str(k(1)),' ',num2str(k(2)),' ',num2str(k(3)),'].'],['Value: ',value]}, 'FontSize', 12);
    else
        handle{1} = subplot(221);
        imHandles{1} = imagesc(squeeze(data(:,:,k(3),k(4))),range);
        set(gca,'DataAspectRatio',[aspect(1) aspect(2) 1])
        axis off
        titleHandles{1} = title(['Slice ',num2str(k(3))],'FontSize',12);

        handle{2} = subplot(222);
        imHandles{2} = imagesc(squeeze(data(k(1),:,:,k(4)))',range);
        set(gca,'DataAspectRatio',[aspect(3) aspect(1) 1],'YDir','normal')
        axis off
        titleHandles{2} = title(['Slice ',num2str(k(1))],'FontSize',12);

        handle{3} = subplot(223);
        imHandles{3} = imagesc(squeeze(data(:,k(2),:,k(4)))',range);
        set(gca,'DataAspectRatio',[aspect(3) aspect(2) 1],'YDir','normal')
        axis off
        titleHandles{3} = title(['Slice ',num2str(k(2))],'FontSize',12);

        handle{4} = subplot(224);
        imHandles{4} = plot((1:dim(4)),squeeze(data(k(1),k(2),k(3),:)));
        hold on
        imHandles{5} = plot(k(4),data(k(1),k(2),k(3),k(4)),'r*','MarkerSize',8); hold off
        value = data(k(1),k(2),k(3)); if value>10^5;value=num2str(value,'%10.4e\n');else value=num2str(value);end
        titleHandles{4} = title({['Timeseries at point [',num2str(k(1)),' ',num2str(k(2)),' ',num2str(k(3)), ' ', num2str(k(4)),']. '],['Value: ',value]}, 'FontSize', 12);
        
        for i = 1:3
            set(titleHandles{i}, 'String', [sprintf('%s%d',titleLines{i}, k(offsliceCoord(i))),' of ', num2str(dim(offsliceCoord(i)))]);
        end
    end
    
    
    %Set temporary save path of color limits
    slicerPath = fileparts(mfilename('fullpath'));
    CLimPath=[slicerPath,'/CLimRange',num2str(f1.Number),'.mat'];

    
    %initialize crosshair and hide it
    x = zeros(2,2);
    y = zeros(2,2);
    subplot(221);
    crossHandle{1} = line(x,y);
    subplot(222);
    crossHandle{2} = line(x,y);
    subplot(223);
    crossHandle{3} = line(x,y);
    for i = 1:3
        set(crossHandle{i}, 'Visible', 'off');
    end
    
    if initCH==1
        crosshairUpdate;
    end
    
    %Initialize fast scroll textbox
    scrollTextbox = annotation('textbox','String','Fast scroll on. Disable with Ctrl key.','HorizontalAlignment','center','FontUnits','normalized','EdgeColor','none','Color','r','Visible','off');
    scrollTextbox.Position(1)=0.5-0.5*scrollTextbox.Position(4);
    scrollTextbox.Position(2)=0.5-0.5*scrollTextbox.Position(3);
    scrollTextbox.FontSize=0.022;

    
%% Click function
    function click(~,~) %(src,evnt)
        
        p = get(gca, 'CurrentPoint');
        p = round(p);
        s = get(gcf, 'SelectionType'); %determine if left- or right-click
        lastPoint = [p(1); p(3)];
        
        % Determine in which view was clicked using the lastPoint parameter
        temp=gca;
        if iscell(temp.Title.String) %in 3D mode, right-clicking would cause an error
            whichView = 4;
        elseif (strfind(temp.Title.String,'Transversal')==1)
            whichView = 1;
        elseif (strfind(temp.Title.String,'Coronal')==1)
            whichView = 2;
        elseif (strfind(temp.Title.String,'Sagittal')==1)
            whichView = 3;
        else
            whichView = 4;
        end
        
        %old code, still works with older versions, where axes handles
        %and/or cell2mat were different
        %whichView = find(cell2mat(handle) == gca); 
        
        xlim = get(gca, 'XLim');
        ylim = get(gca, 'YLim');
        
        % If you click outside a figure, nothing will be updated (i.e.
        % the figure you clicked last, will change)
        if lastPoint(1) >= xlim(1) && lastPoint(1) <= xlim(2) && ...
                lastPoint(2) >= ylim(1) && lastPoint(2) <= ylim(2) && whichView ~= 4
          
            %If it's a left click activate window, scaling and scrolling
            if strcmp(s,'normal')
                set(f1, 'WindowScrollWheelFcn', @scroller);
                
            %If it's a right click activate the crosshair
            elseif strcmp(s,'alt')
                
                %Update k (current coordinate)
                if whichView == 1
                    k(1)=p(3);
                    k(2)=p(1);
                    
                elseif whichView == 2
                    k(2)=p(1);
                    k(3)=p(3);
                    
                elseif whichView == 3
                    k(1)=p(1);
                    k(3)=p(3);
                    
                else
                    return %do nothing
                end
                
                %Update slices in all views
                %(not executed when whichView == 4)
                upDateSliceOtherPlanes(k(1),2);
                upDateSliceOtherPlanes(k(2),3);
                upDateSliceOtherPlanes(k(3),1);
                
                updateTitle(k(1),k(2),k(3),k(4));
                updateTimeSeries(k(1),k(2),k(3),k(4));
                
                %Update crosshairs
                crosshairUpdate;

            %Hide crosshair when clicking with scroll button in plot that
            %has an active crosshair
            elseif strcmp(s,'extend')
                set(crossHandle{1}, 'Visible', 'off');
                set(crossHandle{2}, 'Visible', 'off');
                set(crossHandle{3}, 'Visible', 'off');
            end
        end
    end


%% Crosshair function
    function crosshairUpdate(~,~)
        %Values of crosshair coordinate in the three views
        %           x      y
        crossXY = [k(2) , k(1);
                   k(2) , k(3);
                   k(1) , k(3)];
        
        %Update crosshair lines
        for curView = 1:3
            border = [get(handle{curView}, 'xlim') get(handle{curView}, 'ylim')];
            x = [ border(1) crossXY(curView,1)
                  border(2) crossXY(curView,1) ];
            y = [ crossXY(curView,2)    border(3)
                  crossXY(curView,2)    border(4) ];

            set(crossHandle{curView}(1),'xdata',x(:,1));
            set(crossHandle{curView}(1),'ydata',y(:,1));
            set(crossHandle{curView}(2),'xdata',x(:,2));
            set(crossHandle{curView}(2),'ydata',y(:,2));
        end

        %Make crosshair visible and transparent
        for crossAxis=1:3
            set(crossHandle{crossAxis}, 'Visible', 'on');
            set(crossHandle{crossAxis}, 'Color',[1,0,0,crosshairAlpha]);
        end

    end


%% Scroll function
    function scroller(~,evnt)
        % Callback function to scroll through the images, update the
        % coordinates within k
        
        %If scrolling in plot 4 in 3D data, don't do anything
        if ndim~=4 && whichView==4 
            return
        end
        
        if evnt.VerticalScrollCount>0;
            newslice = k(offsliceCoord(whichView)) - scrollStep;
        else
            newslice = k(offsliceCoord(whichView)) + scrollStep;
        end
        upDateSlice(newslice)
        
        %Update crosshairs if visible
        if strcmp(get(crossHandle{1}, 'Visible'),'on')
            crosshairUpdate
        end
        
        %Also update other slices when scrolling through time series
        if ndim == 4 && whichView == 4
            upDateSliceOtherPlanes(k(1),2);
            upDateSliceOtherPlanes(k(2),3);
            upDateSliceOtherPlanes(k(3),1);
        end
    end


    
%% Function to update all slices
    function upDateSliceOtherPlanes(newCoord,viewDim)
        % Update the slice.
        % If you are moving in the xy plane, the update should be in the z
        % direction, etc.        
        if newCoord > 0 && newCoord <= dim(offsliceCoord(viewDim))
            k(offsliceCoord(viewDim)) = newCoord;
        end
        
        subplot(handle{viewDim});
        if ndim==3
            if viewDim == 1
                set(imHandles{1}, 'CData', squeeze(data(:,:,k(3))));
            elseif viewDim == 2
                set(imHandles{2}, 'CData', squeeze(data(k(1),:,:))');
            else
                set(imHandles{3}, 'CData', squeeze(data(:,k(2),:))');
            end
        else
            if viewDim == 1
                set(imHandles{1}, 'CData', squeeze(data(:,:,k(3),k(4))));
            elseif viewDim == 2
                set(imHandles{2}, 'CData', squeeze(data(k(1),:,:,k(4)))');
            else
                set(imHandles{3}, 'CData', squeeze(data(:,k(2),:,k(4)))');
            end
        end
        set(titleHandles{viewDim}, 'String', ...
            [sprintf('%s%d', titleLines{viewDim}, k(offsliceCoord(viewDim))),' of ', num2str(dim(offsliceCoord(viewDim)))]);
    end

%% Update slice
    function upDateSlice(newslice)
        % Update the slice.
        % If you are moving in the xy plane, the update should be in the z
        % direction, etc.        
        if newslice > 0 && newslice <= dim(offsliceCoord(whichView))
            k(offsliceCoord(whichView)) = newslice;
        elseif newslice <= 0 && whichView ~= 4
            k(offsliceCoord(whichView)) = 1;
        elseif newslice > dim(offsliceCoord(whichView)) && whichView ~= 4
            k(offsliceCoord(whichView)) = dim(offsliceCoord(whichView));
        % Enable scrolling between last and first time-points
        elseif newslice < 1 && whichView == 4
            k(offsliceCoord(whichView)) = dim(offsliceCoord(whichView))+newslice;
        elseif newslice > dim(offsliceCoord(whichView)) && whichView == 4
            k(offsliceCoord(whichView)) = newslice-dim(offsliceCoord(whichView));
        end
        
        subplot(handle{whichView});
        if ndim==3
            if whichView == 1
                set(imHandles{1}, 'CData', squeeze(data(:,:,k(3))));
                
            elseif whichView == 2
                set(imHandles{2}, 'CData', squeeze(data(k(1),:,:))');

            else
                set(imHandles{3}, 'CData', squeeze(data(:,k(2),:))');

            end
            
            updateTitle(k(1),k(2),k(3),1);
        else
            if whichView == 1
                set(imHandles{1}, 'CData', squeeze(data(:,:,k(3),k(4))));
                
            elseif whichView == 2
                set(imHandles{2}, 'CData', squeeze(data(k(1),:,:,k(4)))');
                
            elseif whichView == 3
                set(imHandles{3}, 'CData', squeeze(data(:,k(2),:,k(4)))');
                
            end
            
            updateTitle(k(1),k(2),k(3),k(4));
            updateTimeSeries(k(1),k(2),k(3),k(4));
        end
        
        if whichView ~= 4
            set(titleHandles{whichView}, 'String', ...
                [sprintf('%s%d', titleLines{whichView}, k(offsliceCoord(whichView))),' of ', num2str(dim(offsliceCoord(whichView)))]);
        end
    end

    function updateTitle(k1,k2,k3,k4)
        if ndim==3
            value=data(k1,k2,k3); 
            if value>10^5; %set precision for large numbers
                value=num2str(value,'%10.4e\n');
            else
                value=num2str(value);
            end
            set(titleHandles{4}, 'String', {['Crosshair at point [',num2str(k1),' ',num2str(k2),' ',num2str(k3),']. '],['Value: ',value]});
            
        else
            value=data(k1,k2,k3,k4); 
            if value>10^5;
                value=num2str(value,'%10.4e\n');
            else
                value=num2str(value);
            end
            set(titleHandles{4}, 'String', {['Timeseries at point [',num2str(k1),' ',num2str(k2),' ',num2str(k3), ' ', num2str(k4),']. '],['Value: ',value]});
        end
    end

    function updateTimeSeries(k1,k2,k3,k4)
        if ndim==4
            set(imHandles{4}, 'YData',squeeze(data(k1,k2,k3,:)));
            set(imHandles{5}, 'YData',squeeze(data(k1,k2,k3,k4)),'XData',k4);
            curPlot = subplot(224);
            yData = squeeze(data(k1,k2,k3,:));
            
            %Scale y-axis
            if min(yData)~=max(yData)
                curPlot.YLim = [ min(yData) - abs(0.05*min(yData))   ,  max(yData) + abs(0.05*max(yData))] ;
            end
        end
    end

%% Keyboard functions
    function scale(~,evnt)
        curRange = range;
        
        % Scaling function
        if strcmp(evnt.Key,'downarrow');
            range(1)=range(1)-step;            
        elseif strcmp(evnt.Key,'uparrow');
            range(1)=range(1)+step;
            if range(1)>range(2)
                range = curRange;
                return
            end
        elseif strcmp(evnt.Key,'leftarrow');
            range(2)=range(2)-step;
            if range(2)<range(1)
                range = curRange;
                return
            end
        elseif strcmp(evnt.Key,'rightarrow');
            range(2)=range(2)+step;
        else
            %donothing
        end
        
            
        % To be able to update CLim, one has to grab the subplots, and
        % update the CLim range
        for c = get(f1,'Children')
            try
                set(c,'CLim',range)
                slicerPath = fileparts(mfilename('fullpath'));
                save(CLimPath,'range'); %save the CLim to file for later use
            catch
                continue
            end
        end
    end

%% Close function
    function closefun(src,~)
        try
            if exist(CLimPath,'file')
                delete(CLimPath)
            end
        catch
            %do nothing
        end
        delete(src)
    end


%% Fast scroll
    function fastScroll(~,evnt)
        %Enable/disable fast scrolling
        if strcmp(evnt.Key,'control') && scrollStep == 1
            scrollTextbox.Visible='on';
            scrollStep=10;
        elseif strcmp(evnt.Key,'control') && scrollStep == 10
            scrollTextbox.Visible='off';
            scrollStep=1;
        end
    end

end
