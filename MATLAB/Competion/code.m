%% Importamos,analizamos y limpiamos
clc
%Lo hacemos con este siguiente comando, evitamos usar la herramienta de MATLAB
data=readtable("train.csv");
%analizamos la data
summary(data)
%%
%eliminamos caracteres y columnas innecesarias
data= removevars(data, {'State_Factor', 'building_class','facility_type','direction_max_wind_speed','direction_peak_wind_speed','max_wind_speed','days_with_fog'});
%"promediamos la data faltante"
data.energy_star_rating = fillmissing(data.energy_star_rating, 'linear');
data.year_built = fillmissing(data.year_built, 'makima');
%Movemos la columna de "enfoque" al final
data = movevars(data, 'site_eui', 'After', 'id');
data = movevars(data, 'id', 'Before', 'Year_Factor');
%% Entrenamos el modelo
clc
fprintf("Espera a que se abra la aplicación, puede demorar segundos")
data= removevars(data, {'id'});
writetable(data,'wids.csv');
%%
regressionLearner

