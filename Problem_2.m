%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ручное заполнение массивов
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=input('Введи 1, чтобы начать ручное заполнение массивов');
if k==1
    clear;
    k=1;
    else
end;
if k==1
m=input('Число измерений');
x=zeros(m,1);
i=1;
x(1)=1;
while i < m
    i=i+1;
    x(i)=x(i-1)+1;
end;
i=0;
x=zeros(m,1);
while i < m
    i=i+1;
    x(i)=input('Заполняем x');
end;

i=0;
y=zeros(m,1);
while i < m
    i=i+1;
    y(i)=input('Заполняем y');
end;

i=0;
epsilon=zeros(m,1);
while i < m
    i=i+1;
    epsilon(i)=input('Заполняем epsilon');
end;
else
end;

X = [ x.^0 x ];                               # матрица значений переменных при beta1 и beta2
lb = [-inf 0];                                # нижние границы beta1 и beta2
irp_steam = ir_problem(X, y, epsilon, lb);    # создание переменной, содержащей описание задачи
                                              #               построения интервальной регрессии
## График интервальных измерений
figure
ir_scatter(irp_steam);
xlim([0 8])
ylim([0 6])
set(gca, 'fontsize', 12)
xlabel('x');
ylabel('y');

## Графическое представление информационного множества
figure
ir_plotbeta(irp_steam)
grid on
set(gca, 'fontsize', 12)
xlabel('\beta_1')
ylabel('\beta_2')


## Вершины информационного множества задачи построения интервальной регрессии
vertices = ir_beta2poly(irp_steam)

## Диаметр и наиболее удаленные вершины информационного множества
[rhoB, b1, b2] = ir_betadiam(irp_steam)

## Внешние интервальние оценки параметров модели y = beta1 + beta2 * x
b_int = ir_outer(irp_steam)

## Точечные оценки параметров
b_maxdiag = (b1 + b2) / 2    # как середина наибольшей диагонали информационного множества

b_gravity = mean(vertices)   # как центр тяжести информационного множества

b_lsm = (X \ y)'             # методом наименьших квадратов

## Графическое представление внешней интервальной оценки информационного множества
figure;
ir_plotbeta(irp_steam)
hold on
grid on
set(gca, 'fontsize', 12)
xlabel('\beta_1')
ylabel('\beta_2')


## Точечные оценки
plot(b_maxdiag(1), b_maxdiag(2), 'ro')
plot(b_gravity(1), b_gravity(2), 'r+')
plot(b_lsm(1), b_lsm(2), 'rx')
hold off

## Графическое представление коридора совместных зависимостей для модели y = beta1 + beta2 * x
figure;
xlimits = [-20 40];
ir_plotmodelset(irp_steam, xlimits)     # коридор совместных зависимостей
hold on
ir_scatter(irp_steam,'bo')              # интервальные измерения
%ir_plotline(b_maxdiag, xlimits, 'r-')   # зависимость с параметрами, оцененными как центр наибольшей диагонали ИМ
#ir_plotline(b_gravity, xlim, 'b--')     # зависимость с параметрами, оцененными как центр тяжести ИМ
#ir_plotline(b_lsm, xlim, 'b--')         # зависимость с параметрами, оцененными МНК
#ir_scatter(ir_problem(Xp,ypmid,yprad),'ro')

grid on
set(gca, 'fontsize', 12)
xlabel('x')
ylabel('y')



## Значения y, предсказанные с помощью модели y = beta1 + beta2 * x в точках эксперимента
yp0 = ir_predict(irp_steam, X)       %[yp, betap, exitcode] = ir_predict(irproblem, Xp)# интервальный прогноз значений y в точках x

yp0mid = mean(yp0,2)                 # средние значения прогнозных интервалов
yp0rad = 0.5 * (yp0(:,2) - yp0(:,1)) # радиус прогнозных интервалов

yp0rad_rel = 100 * yp0rad ./ yp0mid  # относительная величина неопределенности прогнозов в процентах


## Значения y, предсказанные с помощью модели y = beta1 + beta2 * x
xp = [1; 4; 6; 7; 8.75; 11; 15.5]
Xp = [xp.^0 xp];

yp = ir_predict(irp_steam, Xp)         # интервальный прогноз значений y в точках xp
ypmid = mean(yp,2)                     # средние значения прогнозных интервалов
yprad = 0.5 * (yp(:,2) - yp(:,1))      # радиус прогнозных интервалов

yprad_relative = 100 * yprad ./ ypmid  # относительная величина неопределенности прогнозов в процентах

## Коридор совместных зависимостей для модели y = beta2 * x
figure
ir_plotmodelset(irp_steam,xlimits)
grid on
hold on
ir_scatter(irp_steam,'bo')
ir_scatter(ir_problem(Xp,ypmid,yprad),'r.')
xlabel('x')
ylabel('y')

