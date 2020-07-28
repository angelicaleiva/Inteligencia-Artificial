% Problema de asignación de asistentes de vuelo

% Datos
int: numVuelos= 10; %% Cantidad total de vuelos
int: numAsistentes= 20; %% Cantidad total de asistentes de vuelo

array[1..numAsistentes,1..5] of 0..1: Atributos; %% Matriz con los Atributos de cada asistente
%% Atributos de cada asistente: 1=Azafato, 2= Azafata; 3= Francés, 4=Español y 5=Alemán

array[1..numVuelos, 1..6] of int: Restricciones; %% Matriz con las restricciones del problema para cada vuelo
%% restricciones: 1=N° requerido, 2=min hombres, 3=min mujeres, 4=N° frances,5=N° español y 6=N° alemán

array[1..numAsistentes] of string: nombres =["Tom","David","Jeremy","Ron","Joe","Bill","Fred","Bob","Mario","Ed","Carol","Janet","Tracy","Marilyn","Carolyn","Cathy","Inez","Jean","Heather","Juliet"]; %% Matriz con los nombres para mostrar solución


% Variable
array[1..numVuelos,1..numAsistentes] of var 0..1: x; %% Matriz de 10x20 que tendrá la solución, donde filas=Vuelos, columnas=Asistentes, 0=no trabaja en ese vuelo, 1=trabaja en ese vuelo
var 1..numAsistentes: y = sum(j in 1..numAsistentes) (bool2int(sum(i in 1..numVuelos) (x[i,j]) > 0)); %%función para minimizar el número de Asistentes


% Restricciones
constraint forall (i in 1..numVuelos-2, j in 1..numAsistentes)(if x[i,j]=1 then x[i+1,j]=0 /\ x[i+2,j]=0 endif); %% Si asistente trabaja en 1 vuelo no puede volar en los 2 vuelos siguientes

constraint forall (i in 1..numVuelos)(sum(j in 1..numAsistentes)(x[i,j])=Restricciones[i,1]); %% Cada vuelo debe cumplir con la cantidad requerida de Asistentes

constraint forall (i in 1..numVuelos)(sum(j in 1..numAsistentes)(x[i,j]*Atributos[j,1])>=Restricciones[i,2]); %% Cada vuelo debe cumplir con el minimo de azafatos

constraint forall (i in 1..numVuelos)(sum(j in 1..numAsistentes)(x[i,j]*Atributos[j,2])>=Restricciones[i,3]); %% Cada vuelo debe cumplir con el minimo de azafatas

constraint forall (i in 1..numVuelos)(sum(j in 1..numAsistentes)(x[i,j]*Atributos[j,3])>=Restricciones[i,4]); %% Cada vuelo debe tener alguien que hable francés

constraint forall (i in 1..numVuelos)(sum(j in 1..numAsistentes)(x[i,j]*Atributos[j,4])>=Restricciones[i,5]); %% Cada vuelo debe tener alguien que hable español

constraint forall (i in 1..numVuelos)(sum(j in 1..numAsistentes)(x[i,j]*Atributos[j,5])>=Restricciones[i,6]); %% Cada vuelo debe tener alguien que hable alemán
  
 
% Resolver
solve :: int_search([x[i,j] |i in 1..numVuelos, j in 1..numAsistentes], first_fail, indomain_min, complete) minimize y;


% Salida
output["Mínimo de asistententes requeridos: " ++show(y)++"\n"]++
       [if j mod numAsistentes = 1 then if i<10 then "Vuelo " ++ show(i) ++ " : " else "Vuelo " ++ show(i) ++ 
       ": " endif else "" endif ++ 
       if fix(x[i,j]) == 1 then show(nombres[j]) else "" endif ++
       if j mod numAsistentes = 0 then "\n" else "" endif
       | i in 1..numVuelos, j in 1..numAsistentes];
     