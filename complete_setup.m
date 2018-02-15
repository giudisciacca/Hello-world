function y = complete_setup()

SerialNumber_Sample = 0; %insert serial number of sample stage controller, 0 if not used
global apt_sample;

SerialNumber_4plate = 0; %insert serial number of quarter wave plate stage controller, 0 if not used
global apt_4_plate;

SerialNumber_Polarizer = 0; %insert serial number of polarizer stage controller, 0 if not used
global apt_polarizer;

%spectrometer data        
integrationTime = 0;
integration_time = 100000; 
averaging_number = 0; 


% rotation data
step_4plate = 15; 
cycles_4plate = 1; 

step_sample = 360;
cycles_sample = 1;

step_polarizer = 0;
cycles_polarizer = 0;
find_pol = 0; % if set to 1 it enables the search for linear polarization
study_polarization = 0; %if set to 0 it enables study of polarization for the harmonics
 

%search for linear polarization angle of the quater wave plate
if ( find_pol == 1)
            %find position for linear polarization
                %to be implemented...
            find_pol = 0;
            disp('Position of linear Polarization has been found. You have 30 seconds to remove the powermeter');
            timeout = 10;
            disp('times is over');
end

%connection to spectrometer, setting of parameters and subtraction of dark spectrum
%IMPORTANT: just one spectrometer can be connected 
%dark spectrum substraction to be implemented
spectrometerObj = connection_to_spectrometer(integrationTime);
disp('connection to spectrometer successfull');

%connection of apts
connect_apt(SerialNumber_Sample);
connect_apt(SerialNumber_4plate);
connect_apt(SerialNumber_Polarizer);


%start of measurements
maxDegree_sample = cycles_sample * 360;
maxDegree_4plate = cycles_4plate * 360;
maxDegree_polarizer = cycles_polarizer * 360;

current_sample = 0;
current_4plate = 0;
current_polarizer = 0; % to be substituted with value of linear polarization
    while (current_sample <= maxDegree_sample)        
          while (current_4plate <= maxDegree_4plate)
             if(study_polarizer != 1)
               T = get_spectrum()
               filename ='C:\Users\cfelatto\Desktop\program_meas\meas_ %current_4plate';
               %_' + integrationTime + '_degree4plate_' + current_4plate + '_degreesample_' + current_sample + clock+'.txt';
               %filename = fullfile('D:','Users', 'cfelatto', 'Desktop', 'program_meas', 'meas');
               fileID = fopen(filename, 'w');
               fprintf(fileID,'%6s %12s\r\n','wavelength','intensity');
               fprintf(fileID,'%6.2f %12.8f \r\n',T);
               fclose(fileID);
               
               %writetable(T, filename);
             end
                    
                    %study of polarization
             if ( study_polarization == 1)%reiterate procedure to get spectrum
                 while ( current_pol <= maxDegree_polarizer) 
                     move_apt(SerialNumber_Polarizer, step_polarizer, current_polarizer)
                     T = get_spectrum()
                     filename ='C:\Users\cfelatto\Desktop\program_meas\meas_ %current_4plate';
                     %_' + integrationTime + '_degree4plate_' + current_4plate + '_degreesample_' + current_sample + clock+'.txt';
                     %filename = fullfile('D:','Users', 'cfelatto', 'Desktop', 'program_meas', 'meas');
                     fileID = fopen(filename, 'w');
                     fprintf(fileID,'%6s %12s\r\n','wavelength','intensity');
                     fprintf(fileID,'%6.2f %12.8f \r\n',T)
                     fclose(fileID);
                  end
            end
               
               
               %rotate 4plate, update conditions %rotate sample
               move_apt(SerialNumber_4plate, step_4plate,current_4plate);
               current_4plate = current_4plate + step_4plate;
               
            end
         %rotate sample
         move_apt(SerialNumber_Sample, step_sample, current_sample);
         current_sample = current_sample + step_sample;
     end
y = 1;
disp('process over');
clear;

end