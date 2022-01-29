%% Creamos el .csv para luego importar, procesar y crear el modelo
load carbig
%Guardamos las variables en variable tipo table
tbl = table(Acceleration, cyl4, Cylinders, Displacement, Horsepower, Mfg, Model, Model_Year, MPG, org, Origin, Weight,...
'VariableNames', {'Acceleration', 'Cyl4', 'Cylinders', 'Displacement', 'Horsepower', 'Make', 'Model', 'Year', 'MPG', 'RegionOfOrigin', 'CountryOfOrigin', 'Weight'});
%Guardamos la data en un .csv
writetable(tbl, 'carData.csv');
%Eliminamos las variables
clear;
%Limpiamos la pantalla
clc;
%% Importamos, analizamos y limpiamos
%Lo hacemos con este siguiente comando, evitamos usar la herramienta de MATLAB
carData = readtable("carData.csv");
%analizamos la data
summary(carData)
%limpiamos de la data los valores de tipo 'char' o que sean Non-numbers
carData = removevars(carData, {'Cyl4', 'Make', 'Model', 'RegionOfOrigin',...
 'CountryOfOrigin'});
%Para los casos de data faltante preguntarse:
%     What values are used to indicate that a piece of data is missing?
%           Usar standardizedData = standardizeMissing(messyData,{‘-‘, ‘NA’, -99, ‘.’});
%     Is there a good way to fill in the missing data, or should I leave it as missing?
%           Podes usar standardizedData.Age = fillmissing(standardizedData.Age, ‘linear’);
%     Under what circumstances should I delete an observation with missing data?       
        % Get indices of all missing values
        missingIdx = ismissing(carData);
        % Get indices of any rows that contain missing values
        %any(~MATRIX=missingIdx~,~dim=2~) tests elements of each row and returns a column vector of logical 1s and 0s.
        rowIdxWithMissing = any(missingIdx, 2);
        % Return rows with missing values
        rowsWithMissing = carData(rowIdxWithMissing, : );
 %eliminamos las filas que tienen valor NaN en la variable MPG
carData = rmmissing(carData, 'DataVariables', 'MPG');
%Movemos la columna MPG al final
carData = movevars(carData, 'MPG', 'After', 'Weight');
%% Creamos las variables de la data para la etapa de Train and Testing
%prevent overfitting
%%%%%%%%%%%%%%%Creamos la data para la etapa de Testing%%%%%%%%%%%%%
% every fifth observation is used for testing (20% of data)
testIdx = 1:5:398; %Usaremos aprox el 20% de la data para testear
testData = carData(testIdx, : );
%Separamos unicamente la columna de MPG de la tabla, y guardamos en una variable
testAnswers = testData.MPG;
testData = removevars(testData,'MPG');
%%%%%%%%%%%%%%%Creamos la data para la etapa de Training%%%%%%%%%%%%
trainData = carData;
trainData(testIdx, : ) = [];
%% Entrenamos el modelo
fprintf("Espera a que se abra la aplicación, puede demorar segundos")
%regressionLearner
%% Testeamos el modelo
%save("trainedModel.mat","trainedModel")
%Obtemos el MPG de nuestro modelo
predictedMPG = trainedModel.predictFcn(testData);
%Obtenemos el error de nuestro modelo
testErrors = testAnswers - predictedMPG;
%eliminamos algun NaN value
testErrors=rmmissing(testErrors); %Ojo con esto!
%error medio promedio
testAvgError = sum(abs(testErrors)) ./ length(testAnswers);
display(testAvgError)
%error cuadratico
myLoss = sum(testErrors .* testErrors) ./ length(testErrors);
display(myLoss)
%error con la funcion de matlab
testLoss = loss(trainedModel.RegressionGP, testData, testAnswers);
display(testLoss)
%Evaluamos con la data con la que se entreno, verificamos overfit
trainLoss = loss(trainedModel.RegressionGP, trainData, trainData.MPG);
display(trainLoss)
fprintf("No hay overfitting!\n")
%% Realizamos algunos plot
close all
%The further away a point is from the solid line, the less accurate the prediction was.
figure(1)
plot(testAnswers, testAnswers);
hold on
plot(testAnswers, predictedMPG, '.');
hold off
xlabel('Actual Miles Per Gallo');
ylabel('Predicted Miles Per Gallon');
figure (2)
%A positive residual means the predicted value was too low by that amount, 
%and a negative residual means that the predicted value was too high by that amount.
plot(testAnswers,testAnswers - predictedMPG,".")
hold on
yline(0)
hold off
xlabel('Actual Miles Per Gallon (MPG)')
ylabel('MPG Residuals')
%Los valores con mayor error
fprintf("Los siguiente valores tienen un error absoluto mayor a 5:\n")
testData(testErrors > 5 | testErrors < -5, : )
%% Lo que deberia venir es un exhaustivo analisis de la data
%Los valores con mayor error
fprintf("Los siguiente valores tienen un error absoluto mayor a 5:\n")
testData(testErrors > 5 | testErrors < -5, : )

%% Consejos
% For each model you create, try asking yourself these questions:
%     Does it perform better than my other models?
%     What are the differences between this and my other models? What are the similarities?
%     Which observations does it perform poorly on? Why?
