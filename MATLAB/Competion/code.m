%% Importamos,analizamos y limpiamos
clc;clear
% analizamos la data
summary(readtable("train.csv"))
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solo nos quedamos con las columnas que deseamos
data=readtable("train.csv");
data=data(:,{'facility_type','energy_star_rating','year_built','floor_area','State_Factor','site_eui'});
%Agregamos la nueva columna, mezcla de palabras
lastCol=data(:,{'facility_type','energy_star_rating','year_built','State_Factor'});
lastCol=string(lastCol{:,1})+"_"+string(lastCol{:,2})+"_"+string(lastCol{:,3})+"_"+string(lastCol{:,4});
lastCol=array2table(lastCol,'VariableNames',{'mix_features'});
data=[data lastCol];
data = movevars(data, 'site_eui', 'After', 'mix_features');
%eliminamos algo de data
data=rmmissing(data, 'DataVariables', 'energy_star_rating');
data=rmmissing(data, 'DataVariables', 'year_built');
%O "promediamos la data faltante"
data.energy_star_rating = fillmissing(data.energy_star_rating, 'pchip');
data.year_built = fillmissing(data.year_built, 'makima');
%elimamos un cierto porcentaje
percentToDelete=10;
testIdx = 1:100/percentToDelete:height(data);
data(testIdx, : ) = [];
clc
fprintf("Espera a que se abra la aplicación, puede demorar segundos\n")
writetable(data,'wids.csv');
%% Entrenamos
clc
regressionLearner
%%
clear
load ('dataTrained_7th.mat')
%Cargamos la data a entrenar
testData=readtable("test.csv");
testData=testData(:,{'facility_type','energy_star_rating','year_built','floor_area','State_Factor'});
%Agregamos la nueva columna, mezcla de palabras
lastCol=testData(:,{'facility_type','energy_star_rating','year_built','State_Factor'});
lastCol=string(lastCol{:,1})+"_"+string(lastCol{:,2})+"_"+string(lastCol{:,3})+"_"+string(lastCol{:,4});
lastCol=array2table(lastCol,'VariableNames',{'mix_features'});
testData=[testData lastCol];

predictedData=trainedModel.predictFcn(testData);
tempMatrix=readmatrix("sample_solution.csv");
tempMatrix(:,2)=predictedData;%favoreció multiplicar el 1.017
solution=table(tempMatrix(:,1),tempMatrix(:,2),'VariableNames',{'id','site_eui'});
writetable(solution,"solution.csv")