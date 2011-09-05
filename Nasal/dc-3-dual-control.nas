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
var lights_mpp      = "sim/multiplay/generic/int[9]";
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
var instrument_lights = "controls/lighting/instruments-norm";

# Switch controls
var battery_switch          = "controls/electric/battery-switch";
var starter_switch          = ["controls/engines/engine[0]/starter", "controls/engines/engine[1]/starter"];
var landing_lights          = ["controls/lighting/landing-lights", "controls/lighting/landing-lights[1]"];
var oil_dilution            = ["controls/engines/engine/oil-dilution", "controls/engines/engine[1]/oil-dilution"];
var parachute_signal        = "controls/paratroopers/jump-signal";
var passing_lights          = "controls/lighting/passing-lights";
var pitot_heat              = ["controls/anti-ice/pitot-heat", "controls/anti-ice/pitot-heat[1]"];
var prop_heat               = "controls/anti-ice/prop-heat";
var running_lights          = "controls/lighting/running-lights";
var tail_lights             = "controls/lighting/tail-lights";
var window_heat             = "controls/anti-ice/window-heat";
var boost_pump              = ["controls/fuel/tank/boost-pump", "controls/fuel/tank[1]/boost-pump"];
var carb_heat               = ["controls/anti-ice/engine/carb-heat", "controls/anti-ice/engine[1]/carb-heat"];
var cabin_lights            = "controls/lighting/cabin-lights";
var recognition_lights      = ["controls/lighting/recognition-lights", "controls/lighting/recognition-lights[1]", "controls/lighting/recognition-lights[2]"];
var prop_feather            = ["controls/engines/engine/propeller-feather", "controls/engines/engine[1]/propeller-feather"];
var compass_lights          = "controls/lighting/compass-lights";
var formation_lights        = "controls/lighting/formation-lights";

# Boolean properties
var running        = ["engines/engine[0]/running", "engines/engine[1]/running"];
var cranking       = ["engines/engine[0]/cranking", "engines/engine[1]/cranking"];
#var gear_pos      = "gear/gear[0]/position-norm";
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
      DCT.Translator.new(copilot.getNode(rudder), props.globals.getNode("dual-control/copilot/"~rudder_cmd, 1)),
      DCT.Translator.new(copilot.getNode(aileron), props.globals.getNode("dual-control/copilot/"~aileron_cmd, 1)),
      DCT.Translator.new(copilot.getNode(elevator), props.globals.getNode("dual-control/copilot/"~elevator_cmd, 1)),
      DCT.Translator.new(copilot.getNode(elevator_trim), props.globals.getNode("dual-control/copilot/"~elevator_trim_cmd, 1)),
      DCT.Translator.new(copilot.getNode(flaps), props.globals.getNode("dual-control/copilot/"~flaps_cmd, 1)),
      DCT.Translator.new(copilot.getNode(throttle[0]), props.globals.getNode("dual-control/copilot/"~throttle_cmd[0], 1)),
      DCT.Translator.new(copilot.getNode(throttle[1]), props.globals.getNode("dual-control/copilot/"~throttle_cmd[1], 1)),
      DCT.Translator.new(copilot.getNode(mixture[0]), props.globals.getNode("dual-control/copilot/"~mixture_cmd[0], 1)),
      DCT.Translator.new(copilot.getNode(mixture[1]), props.globals.getNode("dual-control/copilot/"~mixture_cmd[1], 1)),
      DCT.Translator.new(copilot.getNode(propeller[0]), props.globals.getNode("dual-control/copilot/"~propeller_cmd[0], 1)),
      DCT.Translator.new(copilot.getNode(propeller[1]), props.globals.getNode("dual-control/copilot/"~propeller_cmd[1], 1)),
      DCT.Translator.new(copilot.getNode(brake[0]), props.globals.getNode("dual-control/copilot/"~brake_cmd[0], 1)),
      DCT.Translator.new(copilot.getNode(brake[1]), props.globals.getNode("dual-control/copilot/"~brake_cmd[1], 1)),

      ##################################################
      # Switch Encoder
      DCT.TDMEncoder.new
        ([
          props.globals.getNode(instrument_lights),
          props.globals.getNode(magnetos_cmd[0]),
          props.globals.getNode(magnetos_cmd[1])
         ], props.globals.getNode(TDM_mpp)),
      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(battery_switch),
          props.globals.getNode(oil_dilution[0]),
          props.globals.getNode(oil_dilution[1]),
          props.globals.getNode(parachute_signal),
          props.globals.getNode(pitot_heat[0]),
          props.globals.getNode(pitot_heat[1]),
          props.globals.getNode(prop_heat),
          props.globals.getNode(window_heat),
          props.globals.getNode(boost_pump[0]),
          props.globals.getNode(boost_pump[1]),
          props.globals.getNode(carb_heat[0]),
          props.globals.getNode(carb_heat[1]),
          props.globals.getNode(starter_switch[0]),
          props.globals.getNode(starter_switch[1]),
          props.globals.getNode(prop_feather[0]),
          props.globals.getNode(prop_feather[1]),
          props.globals.getNode(running[0]),
          props.globals.getNode(running[1]),
          props.globals.getNode(cranking[0]),
          props.globals.getNode(cranking[1]),
          props.globals.getNode(gear_cmd),
          props.globals.getNode(brake_parking),
         ], props.globals.getNode(switch_mpp)),
      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(landing_lights[0]),
          props.globals.getNode(landing_lights[1]),
          props.globals.getNode(passing_lights),
          props.globals.getNode(running_lights),
          props.globals.getNode(tail_lights),
          props.globals.getNode(cabin_lights),
          props.globals.getNode(recognition_lights[0]),
          props.globals.getNode(recognition_lights[1]),
          props.globals.getNode(recognition_lights[2]),
          props.globals.getNode(compass_lights),
          props.globals.getNode(formation_lights),
         ], props.globals.getNode(lights_mpp)),

      ##################################################
      # Switch decoder
      DCT.TDMDecoder.new
        (copilot.getNode(TDM_mpp), 
        [func(v){props.globals.getNode("dual-control/copilot/"~instrument_lights, 1).setValue(v);},
         func(v){props.globals.getNode("dual-control/copilot/"~magnetos_cmd[0], 1).setValue(v);},
         func(v){props.globals.getNode("dual-control/copilot/"~magnetos_cmd[1], 1).setValue(v);},
        ]),

      DCT.SwitchDecoder.new
        (copilot.getNode(switch_mpp),
        [func(b){props.globals.getNode("dual-control/copilot/"~battery_switch, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~oil_dilution[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~oil_dilution[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~parachute_signal, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~pitot_heat[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~pitot_heat[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~prop_heat, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~window_heat, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~boost_pump[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~boost_pump[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~carb_heat[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~carb_heat[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~starter_switch[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~starter_switch[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~prop_feather[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~prop_feather[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~running[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~running[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~cranking[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~cranking[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~gear_cmd, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~brake_parking, 1).setValue(b);},
        ]),

      DCT.SwitchDecoder.new
        (copilot.getNode(lights_mpp),
        [func(b){props.globals.getNode("dual-control/copilot/"~landing_lights[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~landing_lights[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~passing_lights, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~running_lights, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~tail_lights, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~cabin_lights, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~recognition_lights[0], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~recognition_lights[1], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~recognition_lights[2], 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~compass_lights, 1).setValue(b);},
         func(b){props.globals.getNode("dual-control/copilot/"~formation_lights, 1).setValue(b);},
        ]),

      ##################################################      
      # Map the most recent value between pilot and copilot to pilot properties
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~rudder_cmd, 1), props.globals.getNode(rudder_cmd), props.globals.getNode(rudder_cmd), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~aileron_cmd, 1), props.globals.getNode(aileron_cmd), props.globals.getNode(aileron_cmd), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~elevator_cmd, 1), props.globals.getNode(elevator_cmd), props.globals.getNode(elevator_cmd), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~elevator_trim_cmd, 1), props.globals.getNode(elevator_trim_cmd), props.globals.getNode(elevator_trim_cmd), 0.00001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~flaps_cmd, 1), props.globals.getNode(flaps_cmd), props.globals.getNode(flaps_cmd), 0.01),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~throttle_cmd[0], 1), props.globals.getNode(throttle_cmd[0]), props.globals.getNode(throttle_cmd[0]), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~throttle_cmd[1], 1), props.globals.getNode(throttle_cmd[1]), props.globals.getNode(throttle_cmd[1]), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~mixture_cmd[0], 1), props.globals.getNode(mixture_cmd[0]), props.globals.getNode(mixture_cmd[0]), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~mixture_cmd[1], 1), props.globals.getNode(mixture_cmd[1]), props.globals.getNode(mixture_cmd[1]), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~propeller_cmd[0], 1), props.globals.getNode(propeller_cmd[0]), props.globals.getNode(propeller_cmd[0]), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~propeller_cmd[1], 1), props.globals.getNode(propeller_cmd[1]), props.globals.getNode(propeller_cmd[1]), 0.001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~magnetos_cmd[0], 1), props.globals.getNode(magnetos_cmd[0]), props.globals.getNode(magnetos_cmd[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~magnetos_cmd[1], 1), props.globals.getNode(magnetos_cmd[1]), props.globals.getNode(magnetos_cmd[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~brake_cmd[0], 1), props.globals.getNode(brake_cmd[0]), props.globals.getNode(brake_cmd[0]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~brake_cmd[1], 1), props.globals.getNode(brake_cmd[1]), props.globals.getNode(brake_cmd[1]), 0.000001),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~battery_switch, 1), props.globals.getNode(battery_switch), props.globals.getNode(battery_switch), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~oil_dilution[0], 1), props.globals.getNode(oil_dilution[0]), props.globals.getNode(oil_dilution[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~oil_dilution[1], 1), props.globals.getNode(oil_dilution[1]), props.globals.getNode(oil_dilution[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~parachute_signal, 1), props.globals.getNode(parachute_signal), props.globals.getNode(parachute_signal), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~pitot_heat[0], 1), props.globals.getNode(pitot_heat[0]), props.globals.getNode(pitot_heat[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~pitot_heat[1], 1), props.globals.getNode(pitot_heat[1]), props.globals.getNode(pitot_heat[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~prop_heat, 1), props.globals.getNode(prop_heat), props.globals.getNode(prop_heat), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~window_heat, 1), props.globals.getNode(window_heat), props.globals.getNode(window_heat), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~boost_pump[0], 1), props.globals.getNode(boost_pump[0]), props.globals.getNode(boost_pump[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~boost_pump[1], 1), props.globals.getNode(boost_pump[1]), props.globals.getNode(boost_pump[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~carb_heat[0], 1), props.globals.getNode(carb_heat[0]), props.globals.getNode(carb_heat[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~carb_heat[1], 1), props.globals.getNode(carb_heat[1]), props.globals.getNode(carb_heat[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~starter_switch[0], 1), props.globals.getNode(starter_switch[0]), props.globals.getNode(starter_switch[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~starter_switch[1], 1), props.globals.getNode(starter_switch[1]), props.globals.getNode(starter_switch[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~prop_feather[0], 1), props.globals.getNode(prop_feather[0]), props.globals.getNode(prop_feather[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~prop_feather[1], 1), props.globals.getNode(prop_feather[1]), props.globals.getNode(prop_feather[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~running[0], 1), props.globals.getNode(running[0]), props.globals.getNode(running[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~running[1], 1), props.globals.getNode(running[1]), props.globals.getNode(running[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~cranking[0], 1), props.globals.getNode(cranking[0]), props.globals.getNode(cranking[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~cranking[1], 1), props.globals.getNode(cranking[1]), props.globals.getNode(cranking[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~gear_cmd, 1), props.globals.getNode(gear_cmd), props.globals.getNode(gear_cmd), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~brake_parking, 1), props.globals.getNode(brake_parking), props.globals.getNode(brake_parking), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~landing_lights[0], 1), props.globals.getNode(landing_lights[0]), props.globals.getNode(landing_lights[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~landing_lights[1], 1), props.globals.getNode(landing_lights[1]), props.globals.getNode(landing_lights[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~passing_lights, 1), props.globals.getNode(passing_lights), props.globals.getNode(passing_lights), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~running_lights, 1), props.globals.getNode(running_lights), props.globals.getNode(running_lights), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~tail_lights, 1), props.globals.getNode(tail_lights), props.globals.getNode(tail_lights), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~cabin_lights, 1), props.globals.getNode(cabin_lights), props.globals.getNode(cabin_lights), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~recognition_lights[0], 1), props.globals.getNode(recognition_lights[0]), props.globals.getNode(recognition_lights[0]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~recognition_lights[1], 1), props.globals.getNode(recognition_lights[1]), props.globals.getNode(recognition_lights[1]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~recognition_lights[2], 1), props.globals.getNode(recognition_lights[2]), props.globals.getNode(recognition_lights[2]), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~compass_lights, 1), props.globals.getNode(compass_lights), props.globals.getNode(compass_lights), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~formation_lights, 1), props.globals.getNode(formation_lights), props.globals.getNode(formation_lights), 0.1),
      DCT.MostRecentSelector.new
        (props.globals.getNode("dual-control/copilot/"~instrument_lights, 1), props.globals.getNode(instrument_lights), props.globals.getNode(instrument_lights), 0.001),
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
#      DCT.Translator.new(pilot.getNode(rudder), props.globals.getNode("dual-control/pilot/"~rudder_cmd, 1)),
#      DCT.Translator.new(pilot.getNode(aileron), props.globals.getNode("dual-control/pilot/"~aileron_cmd, 1)),
#      DCT.Translator.new(pilot.getNode(elevator), props.globals.getNode("dual-control/pilot/"~elevator_cmd, 1)),
#      DCT.Translator.new(pilot.getNode(elevator_trim), props.globals.getNode("dual-control/pilot/"~elevator_trim_cmd, 1)),
#      DCT.Translator.new(pilot.getNode(flaps), props.globals.getNode("dual-control/pilot/"~flaps_cmd, 1)),
#      DCT.Translator.new(pilot.getNode(throttle[0]), props.globals.getNode("dual-control/pilot/"~throttle_cmd[0], 1)),
#      DCT.Translator.new(pilot.getNode(throttle[1]), props.globals.getNode("dual-control/pilot/"~throttle_cmd[1], 1)),
#      DCT.Translator.new(pilot.getNode(mixture[0]), props.globals.getNode("dual-control/pilot/"~mixture_cmd[0], 1)),
#      DCT.Translator.new(pilot.getNode(mixture[1]), props.globals.getNode("dual-control/pilot/"~mixture_cmd[1], 1)),
#      DCT.Translator.new(pilot.getNode(propeller[0]), props.globals.getNode("dual-control/pilot/"~propeller_cmd[0], 1)),
#      DCT.Translator.new(pilot.getNode(propeller[1]), props.globals.getNode("dual-control/pilot/"~propeller_cmd[1], 1)),
#      DCT.Translator.new(pilot.getNode(brake[0]), props.globals.getNode("dual-control/pilot/"~brake_cmd[0], 1)),
#      DCT.Translator.new(pilot.getNode(brake[1]), props.globals.getNode("dual-control/pilot/"~brake_cmd[1], 1)),

      ##################################################
      # Switch Encoder
      DCT.TDMEncoder.new
        ([
          props.globals.getNode(instrument_lights),
          props.globals.getNode(magnetos_cmd[0]),
          props.globals.getNode(magnetos_cmd[1])
         ], props.globals.getNode(TDM_mpp)),
      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(battery_switch),
          props.globals.getNode(oil_dilution[0]),
          props.globals.getNode(oil_dilution[1]),
          props.globals.getNode(parachute_signal),
          props.globals.getNode(pitot_heat[0]),
          props.globals.getNode(pitot_heat[1]),
          props.globals.getNode(prop_heat),
          props.globals.getNode(window_heat),
          props.globals.getNode(boost_pump[0]),
          props.globals.getNode(boost_pump[1]),
          props.globals.getNode(carb_heat[0]),
          props.globals.getNode(carb_heat[1]),
          props.globals.getNode(starter_switch[0]),
          props.globals.getNode(starter_switch[1]),
          props.globals.getNode(prop_feather[0]),
          props.globals.getNode(prop_feather[1]),
          props.globals.getNode(running[0]),
          props.globals.getNode(running[1]),
          props.globals.getNode(cranking[0]),
          props.globals.getNode(cranking[1]),
          props.globals.getNode(gear_cmd),
          props.globals.getNode(brake_parking),
         ], props.globals.getNode(switch_mpp)),
      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(landing_lights[0]),
          props.globals.getNode(landing_lights[1]),
          props.globals.getNode(passing_lights),
          props.globals.getNode(running_lights),
          props.globals.getNode(tail_lights),
          props.globals.getNode(cabin_lights),
          props.globals.getNode(recognition_lights[0]),
          props.globals.getNode(recognition_lights[1]),
          props.globals.getNode(recognition_lights[2]),
          props.globals.getNode(compass_lights),
          props.globals.getNode(formation_lights),
         ], props.globals.getNode(lights_mpp)),

      ##################################################
      # Switch decoder
      DCT.TDMDecoder.new
        (pilot.getNode(TDM_mpp), 
        [func(v){pilot.getNode(instrument_lights).setValue(v); props.globals.getNode("dual-control/pilot/"~instrument_lights, 1).setValue(v);},
         func(v){pilot.getNode(magnetos_cmd[0]).setValue(v); props.globals.getNode("dual-control/pilot/"~magnetos_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(magnetos_cmd[1]).setValue(v); props.globals.getNode("dual-control/pilot/"~magnetos_cmd[1], 1).setValue(v);},
        ]),

      DCT.SwitchDecoder.new
        (pilot.getNode(switch_mpp),
        [func(b){props.globals.getNode(battery_switch).setValue(b);},
         func(b){props.globals.getNode(oil_dilution[0]).setValue(b);},
         func(b){props.globals.getNode(oil_dilution[1]).setValue(b);},
         func(b){props.globals.getNode(parachute_signal).setValue(b);},
         func(b){props.globals.getNode(pitot_heat[0]).setValue(b);},
         func(b){props.globals.getNode(pitot_heat[1]).setValue(b);},
         func(b){props.globals.getNode(prop_heat).setValue(b);},
         func(b){props.globals.getNode(window_heat).setValue(b);},
         func(b){props.globals.getNode(boost_pump[0]).setValue(b);},
         func(b){props.globals.getNode(boost_pump[1]).setValue(b);},
         func(b){props.globals.getNode(carb_heat[0]).setValue(b);},
         func(b){props.globals.getNode(carb_heat[1]).setValue(b);},
         func(b){props.globals.getNode(starter_switch[0]).setValue(b);},
         func(b){props.globals.getNode(starter_switch[1]).setValue(b);},
         func(b){props.globals.getNode(prop_feather[0]).setValue(b);},
         func(b){props.globals.getNode(prop_feather[1]).setValue(b);},
         func(b){props.globals.getNode(running[0]).setValue(b);},
         func(b){props.globals.getNode(running[1]).setValue(b);},
         func(b){props.globals.getNode(cranking[0]).setValue(b);},
         func(b){props.globals.getNode(cranking[1]).setValue(b);},
         func(b){props.globals.getNode(gear_cmd).setValue(b);},
         func(b){props.globals.getNode(brake_parking).setValue(b);},
        ]),

      DCT.SwitchDecoder.new
        (pilot.getNode(lights_mpp),
        [func(b){props.globals.getNode(landing_lights[0]).setValue(b);},
         func(b){props.globals.getNode(landing_lights[1]).setValue(b);},
         func(b){props.globals.getNode(passing_lights).setValue(b);},
         func(b){props.globals.getNode(running_lights).setValue(b);},
         func(b){props.globals.getNode(tail_lights).setValue(b);},
         func(b){props.globals.getNode(cabin_lights).setValue(b);},
         func(b){props.globals.getNode(recognition_lights[0]).setValue(b);},
         func(b){props.globals.getNode(recognition_lights[1]).setValue(b);},
         func(b){props.globals.getNode(recognition_lights[2]).setValue(b);},
         func(b){props.globals.getNode(compass_lights).setValue(b);},
         func(b){props.globals.getNode(formation_lights).setValue(b);},
        ]),

      ##################################################
      # Enable animation for copilot
      DCT.Translator.new(pilot.getNode(rudder), pilot.getNode(rudder_cmd)),
      DCT.Translator.new(pilot.getNode(aileron), pilot.getNode(aileron_cmd)),
      DCT.Translator.new(pilot.getNode(elevator), pilot.getNode(elevator_cmd)),
      DCT.Translator.new(pilot.getNode(throttle[0]), pilot.getNode(throttle_cmd[0])),
      DCT.Translator.new(pilot.getNode(throttle[1]), pilot.getNode(throttle_cmd[1])),
      DCT.Translator.new(pilot.getNode(mixture[0]), pilot.getNode(mixture_cmd[0])),
      DCT.Translator.new(pilot.getNode(mixture[1]), pilot.getNode(mixture_cmd[1])),
      DCT.Translator.new(pilot.getNode(propeller[0]), pilot.getNode(propeller_cmd[0])),
      DCT.Translator.new(pilot.getNode(propeller[1]), pilot.getNode(propeller_cmd[1])),
      DCT.Translator.new(pilot.getNode(rpm[0]), props.globals.getNode(rpm_cmd[0])),
      DCT.Translator.new(pilot.getNode(rpm[1]), props.globals.getNode(rpm_cmd[1])),
      DCT.Translator.new(props.globals.getNode(battery_switch~"-pos", 1), pilot.getNode(battery_switch~"-pos")),
      DCT.Translator.new(props.globals.getNode(oil_dilution[0]~"-pos", 1), pilot.getNode(oil_dilution[0]~"-pos")),
      DCT.Translator.new(props.globals.getNode(oil_dilution[1]~"-pos", 1), pilot.getNode(oil_dilution[1]~"-pos")),
      DCT.Translator.new(props.globals.getNode(parachute_signal~"-pos", 1), pilot.getNode(parachute_signal~"-pos")),
      DCT.Translator.new(props.globals.getNode(pitot_heat[0]~"-pos", 1), pilot.getNode(pitot_heat[0]~"-pos")),
      DCT.Translator.new(props.globals.getNode(pitot_heat[0]~"-pos[1]", 1), pilot.getNode(pitot_heat[0]~"-pos[1]")),
      DCT.Translator.new(props.globals.getNode(prop_heat~"-pos", 1), pilot.getNode(prop_heat~"-pos")),
      DCT.Translator.new(props.globals.getNode(window_heat~"-pos", 1), pilot.getNode(window_heat~"-pos")),
      DCT.Translator.new(props.globals.getNode(boost_pump[0]~"-pos", 1), pilot.getNode(boost_pump[0]~"-pos")),
      DCT.Translator.new(props.globals.getNode(boost_pump[1]~"-pos", 1), pilot.getNode(boost_pump[1]~"-pos")),
      DCT.Translator.new(props.globals.getNode(carb_heat[0]~"-pos", 1), pilot.getNode(carb_heat[0]~"-pos")),
      DCT.Translator.new(props.globals.getNode(starter_switch[0]~"-pos", 1), pilot.getNode(starter_switch[0]~"-pos")),
      DCT.Translator.new(props.globals.getNode(starter_switch[1]~"-pos", 1), pilot.getNode(starter_switch[1]~"-pos")),
      DCT.Translator.new(props.globals.getNode(prop_feather[0]~"-pos", 1), pilot.getNode(prop_feather[0]~"-pos")),
      DCT.Translator.new(props.globals.getNode(prop_feather[1]~"-pos", 1), pilot.getNode(prop_feather[1]~"-pos")),
      DCT.Translator.new(props.globals.getNode(landing_lights[0]~"-pos", 1), pilot.getNode(landing_lights[0]~"-pos")),
      DCT.Translator.new(props.globals.getNode(landing_lights[1]~"-pos", 1), pilot.getNode(landing_lights[0]~"-pos[1]")),
      DCT.Translator.new(props.globals.getNode(passing_lights~"-pos", 1), pilot.getNode(passing_lights~"-pos")),
      DCT.Translator.new(props.globals.getNode(running_lights~"-pos", 1), pilot.getNode(running_lights~"-pos")),
      DCT.Translator.new(props.globals.getNode(tail_lights~"-pos", 1), pilot.getNode(tail_lights~"-pos")),
      DCT.Translator.new(props.globals.getNode(cabin_lights~"-pos", 1), pilot.getNode(cabin_lights~"-pos")),
      DCT.Translator.new(props.globals.getNode(recognition_lights[0]~"-pos", 1), pilot.getNode(recognition_lights[0]~"-pos")),
      DCT.Translator.new(props.globals.getNode(recognition_lights[0]~"-pos[1]", 1), pilot.getNode(recognition_lights[0]~"-pos[1]")),
      DCT.Translator.new(props.globals.getNode(recognition_lights[0]~"-pos[2]", 1), pilot.getNode(recognition_lights[0]~"-pos[2]")),
      DCT.Translator.new(props.globals.getNode(compass_lights~"-pos", 1), pilot.getNode(compass_lights~"-pos")),
      DCT.Translator.new(props.globals.getNode(formation_lights~"-pos", 1), pilot.getNode(formation_lights~"-pos")),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~flaps_cmd, 1), props.globals.getNode(flaps_cmd), props.globals.getNode(flaps_cmd), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~magnetos_cmd[0], 1), props.globals.getNode(magnetos_cmd[0]), props.globals.getNode(magnetos_cmd[0]), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~magnetos_cmd[1], 1), props.globals.getNode(magnetos_cmd[1]), props.globals.getNode(magnetos_cmd[1]), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instrument_lights, 1), props.globals.getNode(instrument_lights), props.globals.getNode(instrument_lights), 0.001),
  ];
}

var copilot_disconnect_pilot = func {
  setprop(l_dual_control, 0);
}
