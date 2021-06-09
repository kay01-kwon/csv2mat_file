clear all

file_name = 'Take 2021-06-06 09.28.06 PM';
openFile = fopen([file_name '.csv'],'r');

DataStartLine = 8;

for i=1:7
    line=fgetl(openFile);
    lines(i).string=regexp(line, ',', 'split');
end

% parse the general properties
FormatVersion=str2double(lines(1).string(2));
fps=str2double(lines(1).string(8));
date=lines(1).string(10);
TotalFrames=str2double(lines(1).string(14));
filename=file_name;

body_names = ["EEF" "mobile_robot"];
TotalBodies = length(body_names);

fprintf('The total number of Rigid Body: %d \n',TotalBodies);
fprintf("Body Names: %s %s \n",body_names(1),body_names(2))
R = [0 0 1;
    1 0 0;
    0 1 0];

for i=1:TotalBodies
    body_index(i,:)=find(body_names(i)==lines(4).string);
    field = body_names(i);
    value(:,1:2) = readmatrix([file_name '.csv'],'Range',[DataStartLine, 1, TotalFrames+DataStartLine, 2]);
    value(:,3:9) = readmatrix([file_name '.csv'],...
        'Range',[DataStartLine, body_index(i,1), TotalFrames+DataStartLine, body_index(i,end)-1]);
    value(:,7:9) = (1000*R*value(:,7:9)')';
    data(i).body_name = body_names(i);
    data(i).CSVdata = value;
    data(i).CSVprocessedData=fillmissing(data(i).CSVdata,'linear');
end

%%
close all
figure(1)
plot(data(2).CSVprocessedData(:,2),data(2).CSVprocessedData(:,7))
hold on;
plot(data(2).CSVprocessedData(:,2),data(2).CSVprocessedData(:,8))
legend('x','y')
% fprintf('CSV Data stored \n');
save([file_name,'.mat'],'data')