scenario = "Stimuli_Rating_Task_run1";

pulse_width = indefinite_port_code; 

default_background_color = 192,192,192;

active_buttons = 3;
button_codes = 1,2,3;

response_matching = legacy_matching; #simple_matching;
response_logging = log_active;

#write_codes = true;
#pulse_width = indefinite_port_code; #If a code is written with a duration of indefinite_port_code, subsequent codes will never cause a conflict. They will simply overwrite the previous code.

begin;

############################## define picture parts for the fixation cross ##############################
#box {height = 5; width = 20; color = 255,255,255;}horiz;
#box {height = 20; width = 5; color = 255,255,255;}vertic;

############################## videos ###################################################################################


$pic_items = 26;
array{
   LOOP $i $pic_items; 
   $k='$i+1';
   bitmap{ 
      filename = "pics_test/run1/pic1$k.jpg"; description = "pic1$k"; scale_factor = scale_to_width; width = 900;
   } "pic$k";
   ENDLOOP;
}pics_test;

############################## define pictures to make a scale - VALENCE #################################
$nb_items = 5;
array{
   LOOP $i $nb_items; 
   $k='$i+1';
   bitmap{ 
      filename = "valence/valence_SAM_0$k.jpg"; description = "valence$k"; scale_factor = scale_to_width; width = 1100;
   };
   ENDLOOP;
}escala_valence;

############################## define pictures to make a scale - DOMINANCE #################################
$nb_items = 5;
array{
   LOOP $i $nb_items; 
   $k='$i+1';
   bitmap{ 
      filename = "dominance/dominance_SAM_0$k.jpg"; description = "dominance$k"; scale_factor = scale_to_width; width = 1100;
   };
   ENDLOOP;
}escala_dominance;

############################## define pictures to make a scale - barras #################################
$nb_items = 5;
array{
   LOOP $i $nb_items; 
   $k='$i+1';
   bitmap{ 
      filename = "arousal/arousal_SAM_0$k.jpg"; description = "arousal$k"; scale_factor = scale_to_width; width = 1100;
   };
   ENDLOOP;
}escala_arousal;



############################## define pictures to make a TRUSTWORTHINESS scale - barras #################################
$nb_items = 3;
array{
   LOOP $i $nb_items; 
   $k='$i+1';
   bitmap{ 
      filename = "trust/trust0$k.jpg"; description = "trust$k"; scale_factor = scale_to_height; height = 150;
   };
   ENDLOOP;
}t_escala; # fazer imagens para o eye gaze type e para o trust type


####### iti ###################################################

array{
    bitmap {filename = "default_pic.bmp"; description = "iti"; 
    } bmpiti; 
}default_iti;

array{
    bitmap {filename = "default_pic.bmp"; description = "rest"; 
    } bmprest; 
}default_rest;

######################################################################## trials definitions ############################################

## eye gaze - video presentation

trial{
	trial_duration = 4000;
	all_responses = false;
	stimulus_event {
		picture{
		} picf;
		#time = 0;
      #code = "  ";
		} stim_pics;
	} face;

#trial {
 #  trial_duration = stimuli_length; # 4000   # play entire video
	#all_responses = false;
    #  stimulus_event{
    #  video vid1;
     # time = 0;
      #code = "  "; 
   #} stim_videos;
#} main;


######################################################################## response trials ###############################################

# valence scale - trial for response (-2 to 2)
trial{
   trial_type = first_response;
	trial_duration = forever;
	stimulus_event {
		picture {
		}valence_scale;
  }vscale_stimevent;
}vscale_trial;


# arousal scale - trial for response (0 to 4)
trial{
   trial_type = first_response;
	trial_duration = forever;
	stimulus_event {
		picture {
		}arousal_scale;
  }ascale_stimevent;
}ascale_trial;


# dominance scale - trial for response (-2 to 2)
trial{
   trial_type = first_response;
	trial_duration = forever;
	stimulus_event {
		picture {
		}dominance_scale;
  }dscale_stimevent;
}dscale_trial;


# "trust" "untrust" "neutral" - trustworthiness scale - trial for response
trial{
   trial_type = first_response;
	trial_duration = forever;
	stimulus_event {
		picture {
		}trust_scale;
  }tscale_stimevent;
}tscale_trial;

######################################################################## ITI trials ###############################################

# second Inter-Trial-Interval - duration = 12s to 15s, random values
trial {
	trial_duration = 1000;
	stimulus_event {  
			picture{	bitmap { filename = "default_pic.bmp"; scale_factor = scale_to_width; width = 1024;} softimgbmp;
			x = 0; y = 0; 
				} default_pic; code = "iti"; #duration = next_picture;
		} iti_stimevent; 	
} iti;

trial {
	trial_duration = 200;
	stimulus_event {  
			picture{	bitmap { filename = "default_pic.bmp"; scale_factor = scale_to_width; width = 1024;} restbmp;
			x = 0; y = 0; 
				} rest_pic; code = "rest"; #duration = next_picture;
		} rest_stimevent; 	
} rest;

#................................................................PCL..............................................................#
begin_pcl;

#define number of trial (target trials) 
array<int> trial_no[26]={
1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26};

# define random seed to be shuffled and used with the TARGET trials: 
array <int> random[26]= {
1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26};

#set terminator buttons
#array<int> terminator[1]={3}; #desnecessário!

# Open an output file
output_file out = new output_file();
out.open( "run1_output_foto.txt" );
out.print( "trial\n" ); 


   ############################################################################### VIDEOS #################################################################

pics_test.shuffle(); 


iti_stimevent.set_event_code( default_iti[1].description() );
iti.present();

loop 
	int i = 1 
until 
	i > pics_test.count()
begin
	picf.add_part( pics_test[i], 0,0);
	stim_pics.set_event_code(pics_test[i].description());
	#pics[i].prepare();
	face.present();
	picf.clear(); #removes the previous picture, instead of placing one above other
	
		iti_stimevent.set_event_code( default_iti[1].description() );
		iti.present();
	
	############################################################################### RATING SCALES #########################################################

		/* ................................................................. 1................	*/

		# present a rating scale: VALENCE dimensions
		loop 
			int resp_fin;
			int z = 3; # beggining: starting position!
			int resp = 1;
			until resp == resp_fin

			begin	    
				valence_scale.add_part( escala_valence[z],0,0);
				vscale_stimevent.set_event_code( escala_valence[z].description() );
				vscale_trial.present();
				
				if response_manager.last_response() == 2 then
					if z < 5 then
						z = z + 1;
					end;
				elseif response_manager.last_response() == 1 then
					if z > 1 then
						z = z - 1;
					end;
				elseif response_manager.last_response() == 3 then
					resp_fin = 3;#terminator[1] 
				end;
			resp = response_manager.last_response(); # trial only registers last response - last-response == last position on the bar)
		end;
		
		
	
		# present a rating scale: AROUSAL dimensions
		loop 
			int resp_fin;
			int z = 3; # beggining: starting position!
			int resp = 1;
			until resp == resp_fin

			begin	    
				arousal_scale.add_part( escala_arousal[z],0,0);
				ascale_stimevent.set_event_code( escala_arousal[z].description() );
				ascale_trial.present();
				
				if response_manager.last_response() == 2 then
					if z < 5 then
						z = z + 1;
					end;
				elseif response_manager.last_response() == 1 then
					if z > 1 then
						z = z - 1;
					end;
				elseif response_manager.last_response() == 3 then
					resp_fin = 3;#terminator[1] 
				end;
			resp = response_manager.last_response(); # trial only registers last response - last-response == last position on the bar)
		end;
		
		# present a rating scale: DOMINANCE dimensions
		loop 
			int resp_fin;
			int z = 3; # beggining: starting position!
			int resp = 1;
			until resp == resp_fin

			begin	    
				dominance_scale.add_part( escala_dominance[z],0,0);
				dscale_stimevent.set_event_code( escala_dominance[z].description() );
				dscale_trial.present();
				
				if response_manager.last_response() == 2 then
					if z < 5 then
						z = z + 1;
					end;
				elseif response_manager.last_response() == 1 then
					if z > 1 then
						z = z - 1;
					end;
				elseif response_manager.last_response() == 3 then
					resp_fin = 3;#terminator[1] 
				end;
			resp = response_manager.last_response(); # trial only registers last response - last-response == last position on the bar)
		end;
	
		/* ................................................................. 2................	*/

		
		/* ................................................................. 3................	*/
				
		# present a rating scale: trustworthiness
		loop 
			int resp_fin;
			int z = 2; # beggining: starting position!
			int resp = 1;
			until resp == resp_fin

			begin	    
				trust_scale.add_part( t_escala[z],0,0);
				tscale_stimevent.set_event_code( t_escala[z].description() );
				tscale_trial.present();
				
				if response_manager.last_response() == 2 then
					if z < 3 then
						z = z + 1;
					end;
				elseif response_manager.last_response() == 1 then
					if z > 1 then
						z = z - 1;
					end;
				elseif response_manager.last_response() == 3 then
					resp_fin = 3;#terminator[1] 
				end;
			resp = response_manager.last_response(); # trial only registers last response - last-response == last position on the bar)
		end;
	

	############################################################################### interval #################################################################
		
	
		# start ITI interval, to allow recovery from the response related SCR
		iti_stimevent.set_event_code( default_iti[1].description() );
		iti.present();
		
		############################################################################### define output file #######################################################	
		# print positions to outputfile
		out.print (trial_no[i]);
		out.print ("/");
		out.print ("\n");	
			
	i = i + 1;
end;