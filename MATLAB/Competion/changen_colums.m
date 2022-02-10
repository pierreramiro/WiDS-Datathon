%% Importamos,analizamos y limpiamos
clear;clc
%Lo hacemos con este siguiente comando, evitamos usar la herramienta de MATLAB
data=readtable("train.csv");
%% columna de State_Factor
str2num=zeros(length(data.State_Factor),1);
for i=1:length(data.State_Factor)
    for j=1:11
        string=data.State_Factor(i);
        string=convertCharsToStrings(string{1});
        if (string==sprintf("State_%d",j))
            str2num(i)= j;  
        end
    end
end