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
y=zeros(m,1);
while i < m
    i=i+1;
    y(i)=input('Заполняем y');
end;
i=0'
epsilon=zeros(m,1);
while i < m
    i=i+1;
    epsilon(i)=input('Заполняем epsilon');
end;
else
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Строим диаграмму рассеяния 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
errorbar(x,y,epsilon,'b.');
xlabel('Номер измерения'); 
ylabel('Измеренная величина');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Высчитываем интервал минимума по включению.
%Делаем вывод о совместности данных
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=0;
while i < m
    i=i+1;
    maxy(i)=y(i)+epsilon(i);
    miny(i)=y(i)-epsilon(i);
    infI = max(miny);
    supI = min(maxy);    
end

midI=(infI+supI)/2;

figure;
errorbar(y,x,epsilon,'horizontal','k.');
xline(infI,'--b');
xline(midI,'--m');
xline(supI,'--b');
xlabel('Измеренная величина'); 
ylabel('Номер измерения');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Определяем моду. Считаем меру Жаккара.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if infI < supI
    disp ('Интервал минимума по включению - правильный. Данные совместны');
    disp ('Мера совместности');
    Jakkar=(min(maxy)-max(miny))/(max(maxy)-min(miny))
    disp ('Мода равна');
    [infI,supI]
else disp ('Интервал минимума по включению - неправильный. Данные несовместны');
    minmaxy=zeros(2*m,1);
    disp ('Мера совместности');
    Jakkar=(min(maxy)-max(miny))/(max(maxy)-min(miny))

    [infz,supz,infmod,supmod,mzmod,mz,L] = Moda(miny,maxy,m);
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Изображаем моду  
    i=0;
    while i < length(mz)
        i=i+1;
        Ox(i)=infz(i);
        Ox(length(mz)+i)=supz(i);
    end
    Oxy=sort(Ox);
    
    mzy=zeros(2*length(mz),1);
    i=0;
    while i < length(mz)
        i=i+1;
        mzy(2*i)=mz(i);
        mzy(2*i-1)=mz(i);
    end
    i=0;  
    
figure;
plot(Oxy,mzy,'b'); 
hold on;
while i < length(L)
    i=i+1;
    modxy=[infmod(i),supmod(i)];
    plot(modxy,mzmod,'r','LineWidth',4);
end 
xlabel('Измеренная величина'); 
ylabel('Частота встречаемости');
grid on;
hold off;  

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Увеличиваем радиусы интервалов
 i=0;
 while i < m
     i=i+1;
     if (miny(i) <= midI) & (maxy(i) >= midI)
         epsiloncor(i)=epsilon(i);
     elseif miny(i)>midI 
          epsiloncor(i)=epsilon(i)+(miny(i)-midI);   
     else 
          epsiloncor(i)=epsilon(i)+(midI-maxy(i));  
     end
 end
 
i=0;
while i < m
    i=i+1;
    maxycor(i)=y(i)+epsiloncor(i);
    minycor(i)=y(i)-epsiloncor(i);   
end
midIcor=(max(minycor)+min(maxycor))/2;
    
figure;
errorbar(y,x,epsiloncor,'horizontal','b.');
hold on
errorbar(y,x,epsilon,'horizontal','k.');
xline(midI,'--m');
xlabel('Измеренная величина'); 
ylabel('Номер измерения');
hold off 

[infzcor,supzcor,infmodcor,supmodcor,mzmodcor,mzcor,Lcor] = Moda(minycor,maxycor,m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Изображаем "исправленную" моду  
    i=0;
    while i < length(mzcor)
        i=i+1;
        Oxcor(i)=infzcor(i);
        Oxcor(length(mzcor)+i)=supzcor(i);
    end
    Oxycor=sort(Oxcor);
    
    mzycor=zeros(2*length(mzcor),1);
    i=0;
    while i < length(mzcor)
        i=i+1;
        mzycor(2*i)=mzcor(i);
        mzycor(2*i-1)=mzcor(i);
    end
    i=0;  
    mzmodcor(2)=mzmodcor(1);
    
figure;
plot(Oxycor,mzycor,'b'); 
hold on;
while i < length(Lcor)
    i=i+1;
    modxycor=[infmodcor(i),supmodcor(i)];
    plot(modxycor,mzmodcor,'r','LineWidth',4);
end 
xlabel('Измеренная величина'); 
ylabel('Частота встречаемости');
grid on;
hold off; 

disp ('Мода равна');
[infmodcor,supmodcor]
 
Jakkar=(min(maxycor)-max(minycor))/(max(maxycor)-min(minycor))

[w,depsilon,A]= correcteps(m,epsiloncor,epsilon,miny,midI,maxy);

epsiloncor2=transpose(epsilon)+depsilon;
i=0;
while i < m
    i=i+1;
    maxycor2(i)=y(i)+epsiloncor2(i);
    minycor2(i)=y(i)-epsiloncor2(i);   
end
midIcor2=(max(minycor2)+min(maxycor2))/2;
    
figure;
errorbar(y,x,epsiloncor2,'horizontal','b.');
hold on
errorbar(y,x,epsilon,'horizontal','k.');
xline(midIcor2,'--m');
xlabel('Измеренная величина'); 
ylabel('Номер измерения');
hold off 

Jokkarcor=(min(maxycor2)-max(minycor2))/(max(maxycor2)-min(minycor2))

[infzcor2,supzcor2,infmodcor2,supmodcor2,mzmodcor2,mzcor2,Lcor2] = Moda(minycor2,maxycor2,m);
  i=0;
    while i < length(mzcor2)
        i=i+1;
        Oxcor2(i)=infzcor2(i);
        Oxcor2(length(mzcor2)+i)=supzcor2(i);
    end
    Oxycor2=sort(Oxcor2);
    
    mzycor2=zeros(2*length(mzcor2),1);
    i=0;
    while i < length(mzcor2)
        i=i+1;
        mzycor2(2*i)=mzcor2(i);
        mzycor2(2*i-1)=mzcor2(i);
    end
    i=0;  
    mzmodcor2(2)=mzmodcor2(1);
    
figure;
plot(Oxycor2,mzycor2,'b'); 
hold on;
while i < length(Lcor2)
    i=i+1;
    modxycor2=[infmodcor2(i),supmodcor2(i)];
    plot(modxycor2,mzmodcor2,'r','LineWidth',4);
end 
xlabel('Измеренная величина'); 
ylabel('Частота встречаемости');
grid on;
hold off; 

disp ('Мода равна');
[infmodcor2,supmodcor2]
end