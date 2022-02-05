clc
%% Importamos,analizamos y limpiamos
%Lo hacemos con este siguiente comando, evitamos usar la herramienta de MATLAB
data=readtable("test.csv");
%analizamos la data
summary(data)