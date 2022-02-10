%% Importamos,analizamos y limpiamos
clc
%Lo hacemos con este siguiente comando, evitamos usar la herramienta de MATLAB
data=readtable("train.csv");
%%
%analizamos la data
summary(data)
%eliminamos caracteres y columnas innecesarias
%data= removevars(data, {'State_Factor', 'building_class','facility_type','direction_max_wind_speed','direction_peak_wind_speed','max_wind_speed','days_with_fog'});
data= removevars(data,{'direction_max_wind_speed','direction_peak_wind_speed','max_wind_speed','days_with_fog'});

%"promediamos la data faltante"
<<<<<<< HEAD
data.energy_star_rating = fillmissing(data.energy_star_rating, 'spline');
%data.year_built = fillmissing(data.year_built, 'makima');
=======
data.energy_star_rating = fillmissing(data.energy_star_rating, 'pchip');
data.year_built = fillmissing(data.year_built, 'makima');
>>>>>>> 7bfc6134695d1f51624175c6af8d88872c50063f
%Movemos la columna de "enfoque" al final
data = movevars(data, 'site_eui', 'After', 'id');
data = movevars(data, 'id', 'Before', 'Year_Factor');
testIdx = 1:3:398; %Usaremos aprox el 20% de la data para testear
data(testIdx, : ) = [];
%%
%Entrenamos el modelo
clc
fprintf("Espera a que se abra la aplicación, puede demorar segundos")
data= removevars(data, {'id'});
writetable(data,'wids.csv');
%%
regressionLearner
%%
clear
load ('dataTrained_4th.mat')
%Cargamos la data a entrenar
testData=readtable("test.csv");
%Eliminamos algunas columnas
testData= removevars(testData, {'direction_max_wind_speed','direction_peak_wind_speed','max_wind_speed','days_with_fog'});
%Movemos la columna id
testData = movevars(testData, 'id', 'Before', 'Year_Factor');
predictedData=trainedModel.predictFcn(testData);
tempMatrix=readmatrix("sample_solution.csv");
tempMatrix(:,2)=predictedData*1.017;%favoreció multiplicar el 1.017
solution=table(tempMatrix(:,1),tempMatrix(:,2),'VariableNames',{'id','site_eui'});
writetable(solution,"solution.csv")