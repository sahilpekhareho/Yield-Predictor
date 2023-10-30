
% Clear workspace
clc
clear all
close all
%%%%%%%%%%%%% Moiisture Parameters%%%%%%%%%%%%%%%%%
%Minimum allowed soil moisture level
Moist_min = 0.1;
%Maximum allowed soil moisture level
Moist_max = 0.8;

%Initial soil moisture level (Initial condition)
Moist_ini = 0.5;

%Farm1 Soil moisture decay rate
dec_rate1 = 0.005;
%Farm2 Soil moisture decay rate
dec_rate2 = 0.07;
%Farm3 Soil moisture decay rate
dec_rate3 = 0.05;
%Farm4 Soil moisture decay rate
dec_rate4 = 0.02;

%step size (number of days in a sixteen weeks season = 112)
num_days = 7*16; 

%Moisture level from time t=1 till t=num_days
%%%Farm 1
M1 = zeros(1,num_days);
M1(1) = Moist_ini;
%%%Farm 2
M2 = zeros(1,num_days);
M2(1) = Moist_ini;
%%%Farm 3
M3 = zeros(1,num_days);
M3(1) = Moist_ini;
%%%Farm 4
M4 = zeros(1,num_days);
M4(1) = Moist_ini;


%Rain Input
rain_prob = 0.05;   
R = full(sprand(1,num_days,rain_prob));  % Generate sparse rain events with a uniform distribution  

% Irrigation Supply 
I_total = 2  ;
Inlet_size = 0.2;
water_delay = 21; 
I = zeros(1,num_days);
I(1) = I_total; 
%%%%%%%%% Initial YIELD DATA and parameters%%%%%%%%%
Yield_max = 100;
% Yield data for farm 1
ydecay_rate1 = 0.09;
Y1 = zeros(1,num_days);
Y1(1) = Yield_max;
% Yield data for farm 2
ydecay_rate2 = 0.05;
Y2 = zeros(1,num_days);
Y2(1) = Yield_max;
% Yield for farm 3
ydecay_rate3 = 0.07;
Y3 = zeros(1,num_days);
Y3(1) = Yield_max;
%Yield for farm 4
ydecay_rate4 = 0.1;
Y4 = zeros(1,num_days);
Y4(1) = Yield_max;
%%%%%% GETTING READY TO PLOT %%%%%%%%% 
s = get(0, 'ScreenSize');
figure('Position', [100 100 1024 1200]);
%%%%  fig for farm 1
subplot(10,1,1); plot([1:num_days],Moist_min*ones(1,num_days),'.');
hold on
subplot(6,1,1); plot([1:num_days],Moist_max*ones(1,num_days),'.');
axis([1 num_days 0 1.2])
%%%% for farm 2
subplot(6,1,2); plot([1:num_days],Moist_min*ones(1,num_days),'.');
hold on
subplot(6,1,2); plot([1:num_days],Moist_max*ones(1,num_days),'.');
axis([1 num_days 0 1.2])
%%%% for farm 3
subplot(6,1,3); plot([1:num_days],Moist_min*ones(1,num_days),'.');
hold on
subplot(6,1,3); plot([1:num_days],Moist_max*ones(1,num_days),'.');
axis([1 num_days 0 1.2])
%%%% for farm 4
subplot(6,1,4); plot([1:num_days],Moist_min*ones(1,num_days),'.');
hold on
subplot(6,1,4); plot([1:num_days],Moist_max*ones(1,num_days),'.');
axis([1 num_days 0 1.2])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% MAIN SIMULATION FOR LOOP %%%%% 
for t = 1:1:num_days
    
    %%%% Soil moisture system update at step t+1 
    %%For Farm 1
    dec_moisture1 = M1(t)*dec_rate1;  %Decrease in moisture level in one day
    M1(t+1) = M1(t) - dec_moisture1 + R(t); %Moisture level at the next day
      %%For Farm 2
    dec_moisture2 = M2(t)*dec_rate2;  %Decrease in moisture level in one day
    M2(t+1) = M2(t) - dec_moisture2 + R(t); %Moisture level at the next day
     %%For Farm 3
    dec_moisture3 = M3(t)*dec_rate3;  %Decrease in moisture level in one day
    M3(t+1) = M3(t) - dec_moisture3 + R(t); %Moisture level at the next day
      %%For Farm 4
    dec_moisture4 = M4(t)*dec_rate4;  %Decrease in moisture level in one day
    M4(t+1) = M4(t) - dec_moisture4 + R(t); %Moisture level at the next day
    
    %%%%%%% Control action at time step t %%%%%%%%%%%%
    
    %%% OPTION 1:  Open-loop control with fixed delivery 
   if(t==1&& I(t) > 0)
       water_input = min(Inlet_size, I(t));
            M1(t+1) = M1(t+1) + water_input;
            I(t+1) = I(t) - water_input; 
   elseif(t==2&& I(t) > 0)
    water_input = min(Inlet_size, I(t));
            M2(t+1) = M2(t+1) + water_input;
            I(t+1) = I(t) - water_input; 
    
     elseif(t==3&& I(t) > 0)
          water_input = min(Inlet_size, I(t));
            M3(t+1) = M3(t+1) + water_input;
            I(t+1) = I(t) - water_input; 
     elseif(t==4&& I(t) > 0)
           water_input = min(Inlet_size, I(t));
            M4(t+1) = M4(t+1) + water_input;
            I(t+1) = I(t) - water_input; 
   else
          I(t+1) = I(t); 
   end
  if (t>10)
    if (mod(t,water_delay) == 0 && I(t) > 0)
   %irrigation for farm 1
        water_input = min(Inlet_size, I(t));
            M1(t+1) = M1(t+1) + water_input;
            I(t+1) = I(t) - water_input; 
             %irrigation for farm 2
             elseif (mod(t-1,water_delay) == 0 && I(t) > 0)
             water_input = min(Inlet_size, I(t));
            M2(t+1) = M2(t+1) + water_input;
            I(t+1) = I(t) - water_input; 
             %irrigation for farm 3
             elseif (mod(t-2,water_delay) == 0 && I(t) > 0)
             water_input = min(Inlet_size, I(t));
            M3(t+1) = M3(t+1) + water_input;
            I(t+1) = I(t) - water_input; 
             %irrigation for farm 4
             elseif (mod(t-3,water_delay) == 0 && I(t) > 0)
             water_input = min(Inlet_size, I(t));
            M4(t+1) = M4(t+1) + water_input;
            I(t+1) = I(t) - water_input; 
        else
            I(t+1) = I(t);     
    end
   end
%     
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Your controllers will be added here to replace 
%the above piece of code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%% Expected Yield update after every time step t+1 %%%%%%%% 
    if (M1(t) < Moist_min | M1(t) > Moist_max) 
        Y1(t+1) = Y1(t) - Y1(t)*ydecay_rate1;
    else 
        Y1(t+1) = Y1(t);
    end
    if (M2(t) < Moist_min | M2(t) > Moist_max) 
        Y2(t+1) = Y2(t) - Y2(t)*ydecay_rate2;
    else 
        Y2(t+1) = Y2(t);
    end
    if (M3(t) < Moist_min | M3(t) > Moist_max) 
        Y3(t+1) = Y3(t) - Y3(t)*ydecay_rate3;
    else
        Y3(t+1) = Y3(t);
    end
    if (M4(t) < Moist_min | M4(t) > Moist_max) 
        Y4(t+1) = Y4(t) - Y4(t)*ydecay_rate4;
    else 
        Y4(t+1) = Y4(t);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%% PLOTTING GRAPHS at time t 
    %moisture plot of soil for farm 1
%     subplot(10,1,1); plot(1:t,M1(1:t),'*m-'); hold on;
%     axis([1 num_days 0 1.2])
%     title(['\bf Moisture content in Farm 1`s soil']);set(gca,'FontSize',14)
%     %moisture plot of soil for farm 2
%     subplot(10,1,2); plot(1:t,M2(1:t),'*m-'); hold on;
%     axis([1 num_days 0 1.2])
%     title(['\bf Moisture content in Farm 2`s soil']);set(gca,'FontSize',14)
%     %moisture plot of soil for farm 3
%     subplot(10,1,3); plot(1:t,M3(1:t),'*m-'); hold on;
%     axis([1 num_days 0 1.2])
%     title(['\bf Moisture content in Farm 3`s soil']);set(gca,'FontSize',14)
%     %moisture plot of soil for farm 4
%        subplot(10,1,4); plot(1:t,M4(1:t),'*m-'); hold on;
%     axis([1 num_days 0 1.2])
%     title(['\bf Moisture content in Farm 4`s soil']);set(gca,'FontSize',14)
%    %Rain plot
    subplot(6,1,1); stem(1:t,R(1:t),'r'); hold on;
    axis([1 num_days 0 1.2])
    title(['\bf Precipitation Table']);set(gca,'FontSize',14)
    %Irrigation plot
    subplot(6,1,2); plot(1:t,I(1:t),'bo-'); hold on;
    axis([1 num_days 0 2.5])
    title(['\bf Irrigation Plot']);set(gca,'FontSize',14)
    %%plot for Yield farm 1
    subplot(6,1,3); plot(1:t,Y1(1:t),'r-'); hold on;
    subplot(6,1,3); plot([1:num_days],Yield_max*ones(1,num_days),'b:');
    axis([1 num_days 0 Yield_max*1.2])
    title(['\bf Farm1`s yield']);set(gca,'FontSize',14)
    %%plot for Yield farm 2
    subplot(6,1,4); plot(1:t,Y2(1:t),'b-'); hold on;
    subplot(6,1,4); plot([1:num_days],Yield_max*ones(1,num_days),'b:');
    axis([1 num_days 0 Yield_max*1.2])
     title(['\bf Farm2`s yield']);set(gca,'FontSize',14)
    %%plot for Yield farm 3
    subplot(6,1,5); plot(1:t,Y3(1:t),'c-'); hold on;
    subplot(6,1,5); plot([1:num_days],Yield_max*ones(1,num_days),'b:');
    axis([1 num_days 0 Yield_max*1.2])
    title(['\bf Farm3`s yield']);set(gca,'FontSize',14)
    %%plot for Yield farm 4
    subplot(6,1,6); plot(1:t,Y4(1:t),'g-'); hold on;
    subplot(6,1,6); plot([1:num_days],Yield_max*ones(1,num_days),'b:');
    axis([1 num_days 0 Yield_max*1.2])
    title(['\bf Farm4`s yield']);set(gca,'FontSize',14)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    pause(0.01);   % stalls the code before processing next t. Creates a video-like effect on figures
end
