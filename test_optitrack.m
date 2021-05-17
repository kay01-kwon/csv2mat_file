clear all

file_name = 'Take 2021-05-17 02.49.47 PM';
openFile = fopen([file_name '.csv'],'r');

DataStartLine = 8;

for i=1:7
    line=fgetl(openFile);
    lines(i).string=regexp(line, ',', 'split');
end

% parse the general properties
data.FormatVersion=str2double(lines(1).string(2));
data.fps=str2double(lines(1).string(8));
data.date=lines(1).string(10);
data.TotalFrames=str2double(lines(1).string(14));
data.filename=file_name;

body_names = ["EEF" "mobile_robot"];
TotalBodies = length(body_names);

fprintf('The total number of Rigid Body: %d \n',TotalBodies);

for i=1:TotalBodies
    body.body_index(i,:)=find(body_names(i)==lines(4).string);
end


data.CSVdata(:,1:2) = readmatrix([file_name '.csv'],'Range',[DataStartLine, 1, data.TotalFrames+DataStartLine, 2]);

R = [0 0 1;
    1 0 0;
    0 1 0];

for i=1:TotalBodies
    data.CSVdata(:,7*(i-1)+3:7*(i-1)+9) = readmatrix([file_name '.csv'],...
        'Range',[DataStartLine, body.body_index(i,1), data.TotalFrames+DataStartLine, body.body_index(i,end)-1]);
    data.CSVdata(:,7*(i-1)+7:7*(i-1)+9) = (R*data.CSVdata(:,7*(i-1)+7:7*(i-1)+9)')'; 
end


data.CSVprocessedData=fillmissing(data.CSVdata,'linear');


fprintf('CSV Data stored \n');