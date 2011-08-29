###############################################################################
##  Nasal for dual control of the Douglas DC3-C47 over the multiplayer network.
##
##  Copyright (C) 2007 - 2008  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license version 2 or later.
##
##  Modified by Clément de l'Hamaide for Douglas DC3-C47 - 13/08/2011
##
###############################################################################

## Renaming (almost :)
var DCT = dual_control_tools;

## Pilot/copilot aircraft identifiers. Used by dual_control.
var pilot_type   = "Aircraft/Douglas-Dc3/Models/dc-3.xml";
var copilot_type = "Aircraft/Douglas-Dc3/Models/dc-3-copilot.xml";

############################ PROPERTIES MP ###########################

#####
# pilot properties
##
var flaps           = "sim/multiplay/generic/float[3]";
var elevator_trim   = "sim/multiplay/generic/float[4]";
var rudder          = "sim/multiplay/generic/float[5]";
var elevator        = "sim/multiplay/generic/float[6]";
var aileron         = "sim/multiplay/generic/float[7]";
var throttle        = ["sim/multiplay/generic/float[8]", "sim/multiplay/generic/float[9]"];
var mixture         = ["sim/multiplay/generic/float[10]", "sim/multiplay/generic/float[11]"];
var propeller       = ["sim/multiplay/generic/float[12]", "sim/multiplay/generic/float[13]"];
var rpm             = ["engines/engine[0]/rpm", "engines/engine[1]/rpm"];
var brake           = ["sim/multiplay/generic/float[14]", "sim/multiplay/generic/float[15]"];
var gear            = "sim/multiplay/generic/float[16]";
var switch_mpp      = "sim/multiplay/generic/int[0]";
var TDM_mpp         = "sim/multiplay/generic/string[0]";

######################################################################
# Useful instrument related property paths.

# Flight controls
var rudder_cmd        = "controls/flight/rudder";
var elevator_cmd      = "controls/flight/elevator";
var aileron_cmd       = "controls/flight/aileron";
var elevator_trim_cmd = "controls/flight/elevator-trim";
var flaps_cmd         = "controls/flight/flaps";
var throttle_cmd      = ["controls/engines/engine[0]/throttle", "controls/engines/engine[1]/throttle"];
var mixture_cmd       = ["controls/engines/engine[0]/mixture", "controls/engines/engine[1]/mixture"];
var propeller_cmd     = ["controls/engines/engine[0]/propeller-pitch", "controls/engines/engine[1]/propeller-pitch"];
var magnetos_cmd      = ["controls/engines/engine[0]/magnetos", "controls/engines/engine[1]/magnetos"];
var rpm_cmd           = ["engines/engine[0]/rpm", "engines/engine[1]/rpm"];
var brake_cmd         = ["controls/gear/brake-left", "controls/gear/brake-right"];
var gear_cmd          = "controls/gear/gear-down";

# Switch controls
var battery_switch          = "controls/electric/battery-switch";
var starter_switch          = ["controls/engines/engine[0]/starter", "controls/engines/engine[1]/starter"];
var light_instrument_switch = "controls/lighting/instrument-lights";

# Boolean properties
var running        = ["engines/engine[0]/running", "engines/engine[1]/running"];
var cranking       = ["engines/engine[0]/cranking", "engines/engine[1]/cranking"];
#var gear_pos          = "gear/gear[0]/position-norm";
var brake_parking  = "controls/gear/brake-parking";

var l_dual_control    = "dual-control/active";

######################################################################
###### Used by dual_control to set up the mappings for the pilot #####
######################## PILOT TO COPILOT ############################
######################################################################

var pilot_connect_copilot = func (copilot) {
  # Make sure dual-control is activated in the FDM FCS.
	print("Pilot section");
  setprop(l_dual_control, 1);
  return [
      ##################################################
      # Map copilot properties to buffer properties
      DCT.Translator.new
        (copilot.getNode(rudder),
	 props.globals.getNode("dual-control/copilot/"~rudder_cmd)),
      DCT.Translator.new
        (copilot.getNode(aileron),
	 props.globals.getNode("dual-control/copilot/"~aileron_cmd)),
      DCT.Translator.new
        (copilot.getNode(elevator),
	 props.globals.getNode("dual-control/copilot/"~elevator_cmd)),
      DCT.Translator.new
        (copilot.getNode(elevator_trim),
	 props.globals.getNode("dual-control/copilot/"~elevator_trim_cmd)),
      DCT.Translator.new
        (copilot.getNode(flaps),
	 props.globals.getNode("dual-control/copilot/"~flaps_cmd)),
      DCT.Translator.new
        (copilot.getNode(throttle[0]),
	 props.globals.getNode("dual-control/copilot/"~throttle_cmd[0])),
      DCT.Translator.new
        (copilot.getNode(throttle[1]),
	 props.globals.getNode("dual-control/copilot/"~throttle_cmd[1])),
      DCT.Translator.new
        (copilot.getNode(mixture[0]),
	 props.globals.getNode("dual-control/copilot/"~mixture_cmd[0])),
      DCT.Translator.new
        (copilot.getNode(mixture[1]),
	 props.globals.getNode("dual-control/copilot/"~mixture_cmd[1])),
      DCT.Translator.new
        (copilot.getNode(propeller[0]),
	 props.globals.getNode("dual-control/copilot/"~propeller_cmd[0])),
      DCT.Translator.new
        (copilot.getNode(propeller[1]),
	 props.globals.getNode("dual-control/copilot/"~propeller_cmd[1])),
      DCT.Translator.new
        (copilot.getNode(brake[0]),
	 props.globals.getNode("dual-control/copilot/"~brake_cmd[0])),
      DCT.Translator.new
        (copilot.getNode(brake[1]),
	 props.globals.getNode("dual-control/copilot/"~brake_cmd[1])),

      ##################################################
      # Switch Encoder
      DCT.TDMEncoder.new
        ([
          props.globals.getNode(magnetos_cmd[0]),
          props.globals.getNode(magnetos_cmd[1])
         ], props.globals.getNode(TDM_mpp)),
      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(battery_switch),
          props.globals.getNode(starter_switch[0]),
          props.globals.getNode(starter_switch[1]),
          props.globals.getNode(light_instrument_switch),
          props.globals.getNode(running[0]),
          props.globals.getNode(running[1]),
          props.globals.getNode(cranking[0]),
          props.globals.getNode(cranking[1]),
          props.globals.getNode(gear_cmd),
          props.globals.getNode(brake_parking),
         ], props.globals.getNode(switch_mpp)),

      ##################################################
      # Switch decoder
      DCT.TDMDecoder.new
        (copilot.getNode(TDM_mpp), 
        [func(v){
           props.globals.getNode("dual-control/copilot/"~magnetos_cmd[0]).setValue(v);
        },
         func(v){
           props.globals.getNode("dual-control/copilot/"~magnetos_cmd[1]).setValue(v);
        },]),
      DCT.SwitchDecoder.new
        (copilot.getNode(switch_mpp),
        [func(b){
           props.globals.getNode("dual-control/copilot/"~battery_switch).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~starter_switch[0]).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~starter_switch[1]).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~light_instrument_switch).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~running[0]).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~running[1]).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~cranking[0]).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~cranking[1]).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~gear_cmd).setValue(b);
        },
         func(b){
           props.globals.getNode("dual-control/copilot/"~brake_parking).setValue(b);
        },]),

      ##################################################      
      # Map the most recent value between pilot and copilot to pilot properties
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~rudder_cmd), props.globals.getNode(rudder_cmd), props.globals.getNode(rudder_cmd), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~aileron_cmd), props.globals.getNode(aileron_cmd), props.globals.getNode(aileron_cmd), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~elevator_cmd), props.globals.getNode(elevator_cmd), props.globals.getNode(elevator_cmd), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~elevator_trim_cmd), props.globals.getNode(elevator_trim_cmd), props.globals.getNode(elevator_trim_cmd), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~flaps_cmd), props.globals.getNode(flaps_cmd), props.globals.getNode(flaps_cmd), 0.01),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~throttle_cmd[0]), props.globals.getNode(throttle_cmd[0]), props.globals.getNode(throttle_cmd[0]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~throttle_cmd[1]), props.globals.getNode(throttle_cmd[1]), props.globals.getNode(throttle_cmd[1]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~mixture_cmd[0]), props.globals.getNode(mixture_cmd[0]), props.globals.getNode(mixture_cmd[0]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~mixture_cmd[1]), props.globals.getNode(mixture_cmd[1]), props.globals.getNode(mixture_cmd[1]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~propeller_cmd[0]), props.globals.getNode(propeller_cmd[0]), props.globals.getNode(propeller_cmd[0]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~propeller_cmd[1]), props.globals.getNode(propeller_cmd[1]), props.globals.getNode(propeller_cmd[1]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~magnetos_cmd[0]), props.globals.getNode(magnetos_cmd[0]), props.globals.getNode(magnetos_cmd[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~magnetos_cmd[1]), props.globals.getNode(magnetos_cmd[1]), props.globals.getNode(magnetos_cmd[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~battery_switch), props.globals.getNode(battery_switch), props.globals.getNode(battery_switch), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~starter_switch[0]), props.globals.getNode(starter_switch[0]), props.globals.getNode(starter_switch[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~starter_switch[1]), props.globals.getNode(starter_switch[1]), props.globals.getNode(starter_switch[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~light_instrument_switch), props.globals.getNode(light_instrument_switch), props.globals.getNode(light_instrument_switch), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~running[0]), props.globals.getNode(running[0]), props.globals.getNode(running[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~running[1]), props.globals.getNode(running[1]), props.globals.getNode(running[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~cranking[0]), props.globals.getNode(cranking[0]), props.globals.getNode(cranking[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~cranking[1]), props.globals.getNode(cranking[1]), props.globals.getNode(cranking[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~gear_cmd), props.globals.getNode(gear_cmd), props.globals.getNode(gear_cmd), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~brake_parking), props.globals.getNode(brake_parking), props.globals.getNode(brake_parking), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~brake_cmd[0]), props.globals.getNode(brake_cmd[0]), props.globals.getNode(brake_cmd[0]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~brake_cmd[1]), props.globals.getNode(brake_cmd[1]), props.globals.getNode(brake_cmd[1]), 0.000001),

  ];
}

##############
var pilot_disconnect_copilot = func {
  setprop(l_dual_control, 0);
}


######################################################################
##### Used by dual_control to set up the mappings for the copilot ####
######################## COPILOT TO PILOT ############################
######################################################################

var copilot_connect_pilot = func (pilot) {
  # Make sure dual-control is activated in the FDM FCS.
	print("Copilot section");
  setprop(l_dual_control, 1);
  return [
      ##################################################
      # Map pilot properties to buffer properties
      DCT.Translator.new
        (pilot.getNode(rudder),
	 props.globals.getNode("dual-control/pilot/"~rudder_cmd)),
      DCT.Translator.new
        (pilot.getNode(aileron),
	 props.globals.getNode("dual-control/pilot/"~aileron_cmd)),
      DCT.Translator.new
        (pilot.getNode(elevator),
	 props.globals.getNode("dual-control/pilot/"~elevator_cmd)),
      DCT.Translator.new
        (pilot.getNode(elevator_trim),
	 props.globals.getNode("dual-control/pilot/"~elevator_trim_cmd)),
      DCT.Translator.new
        (pilot.getNode(flaps),
	 props.globals.getNode("dual-control/pilot/"~flaps_cmd)),
      DCT.Translator.new
        (pilot.getNode(throttle[0]),
	 props.globals.getNode("dual-control/pilot/"~throttle_cmd[0])),
      DCT.Translator.new
        (pilot.getNode(throttle[1]),
	 props.globals.getNode("dual-control/pilot/"~throttle_cmd[1])),
      DCT.Translator.new
        (pilot.getNode(mixture[0]),
	 props.globals.getNode("dual-control/pilot/"~mixture_cmd[0])),
      DCT.Translator.new
        (pilot.getNode(mixture[1]),
	 props.globals.getNode("dual-control/pilot/"~mixture_cmd[1])),
      DCT.Translator.new
        (pilot.getNode(propeller[0]),
	 props.globals.getNode("dual-control/pilot/"~propeller_cmd[0])),
      DCT.Translator.new
        (pilot.getNode(propeller[1]),
	 props.globals.getNode("dual-control/pilot/"~propeller_cmd[1])),
      DCT.Translator.new
        (pilot.getNode(brake[0]),
	 props.globals.getNode("dual-control/pilot/"~brake_cmd[0])),
      DCT.Translator.new
        (pilot.getNode(brake[1]),
	 props.globals.getNode("dual-control/pilot/"~brake_cmd[1])),

      ##################################################
      # Switch Encoder
      DCT.TDMEncoder.new
        ([
          props.globals.getNode(magnetos_cmd[0]),
          props.globals.getNode(magnetos_cmd[1])
         ], props.globals.getNode(TDM_mpp)),
      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(battery_switch),
          props.globals.getNode(starter_switch[0]),
          props.globals.getNode(starter_switch[1]),
          props.globals.getNode(light_instrument_switch),
          props.globals.getNode(running[0]),
          props.globals.getNode(running[1]),
          props.globals.getNode(cranking[0]),
          props.globals.getNode(cranking[1]),
          props.globals.getNode(gear_cmd),
          props.globals.getNode(brake_parking),
         ], props.globals.getNode(switch_mpp)),

      ##################################################
      # Switch decoder
      DCT.TDMDecoder.new
        (pilot.getNode(TDM_mpp), 
        [func(v){
           pilot.getNode(magnetos_cmd[0]).setValue(v);
           props.globals.getNode("dual-control/pilot/"~magnetos_cmd[0]).setValue(v);
        },
         func(v){
           pilot.getNode(magnetos_cmd[1]).setValue(v);
           props.globals.getNode("dual-control/pilot/"~magnetos_cmd[1]).setValue(v);
        },]),
      DCT.SwitchDecoder.new
        (pilot.getNode(switch_mpp),
        [func(b){
           pilot.getNode(battery_switch).setValue(b);
           props.globals.getNode(battery_switch).setValue(b);
        },
         func(b){
           pilot.getNode(starter_switch[0]).setValue(b);
           props.globals.getNode("dual-control/pilot/"~starter_switch[0]).setValue(b);
        },
         func(b){
           pilot.getNode(starter_switch[1]).setValue(b);
           props.globals.getNode("dual-control/pilot/"~starter_switch[1]).setValue(b);
        },
         func(b){
           pilot.getNode(light_instrument_switch).setValue(b);
           props.globals.getNode(light_instrument_switch).setValue(b);
        },
         func(b){
           props.globals.getNode(running[0]).setValue(b);
        },
         func(b){
           props.globals.getNode(running[1]).setValue(b);
        },
         func(b){
           props.globals.getNode(cranking[0]).setValue(b);
        },
         func(b){
           props.globals.getNode(cranking[1]).setValue(b);
        },
         func(b){
           props.globals.getNode(gear_cmd).setValue(b);
        },
         func(b){
           props.globals.getNode(brake_parking).setValue(b);
        },]),

      ##################################################
      # Enable animation for copilot
      DCT.Translator.new
        (pilot.getNode(rudder),
	 pilot.getNode(rudder_cmd)),
      DCT.Translator.new
        (pilot.getNode(aileron),
	 pilot.getNode(aileron_cmd)),
      DCT.Translator.new
        (pilot.getNode(elevator),
	 pilot.getNode(elevator_cmd)),
      DCT.Translator.new
        (pilot.getNode(throttle[0]),
	 pilot.getNode(throttle_cmd[0])),
      DCT.Translator.new
        (pilot.getNode(throttle[1]),
	 pilot.getNode(throttle_cmd[1])),
      DCT.Translator.new
        (pilot.getNode(mixture[0]),
	 pilot.getNode(mixture_cmd[0])),
      DCT.Translator.new
        (pilot.getNode(mixture[1]),
	 pilot.getNode(mixture_cmd[1])),
      DCT.Translator.new
        (pilot.getNode(propeller[0]),
	 pilot.getNode(propeller_cmd[0])),
      DCT.Translator.new
        (pilot.getNode(propeller[1]),
	 pilot.getNode(propeller_cmd[1])),
      DCT.Translator.new
        (pilot.getNode(rpm[0]),
	 props.globals.getNode(rpm_cmd[0])),
      DCT.Translator.new
        (pilot.getNode(rpm[1]),
	 props.globals.getNode(rpm_cmd[1])),
      DCT.Translator.new
        (pilot.getNode(flaps),
	 props.globals.getNode("surface-positions/flap-pos-norm")),
      DCT.Translator.new
        (pilot.getNode(gear),
	 props.globals.getNode("gear/gear[0]/position-norm")),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/pilot/"~flaps_cmd), props.globals.getNode(flaps_cmd), props.globals.getNode(flaps_cmd), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/pilot/"~magnetos_cmd[0]), props.globals.getNode(magnetos_cmd[0]), props.globals.getNode(magnetos_cmd[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/pilot/"~magnetos_cmd[1]), props.globals.getNode(magnetos_cmd[1]), props.globals.getNode(magnetos_cmd[1]), 0.1),

  ];
}

var copilot_disconnect_pilot = func {
  setprop(l_dual_control, 0);
}
