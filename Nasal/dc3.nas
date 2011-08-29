##########################################################
######### BACON Guillaume for Douglas DC-3/C-47 ##########
##########################################################

var starter_serviceable = 0;
var cranking_serviceable = 0;
var engine_serviceable = 0;
var time = props.globals.getNode("sim/time/elapsed-sec");
var last_change = 0;

setlistener("/sim/signals/fdm-initialized", func{
  settimer(update_system, 1);
  setprop("/controls/gear/brake-parking",1);
  setprop("/instrumentation/doors/crew/position-norm",0);
});

setlistener("/sim/current-view/view-number", func(vw) {
    var nm = vw.getValue();
    setprop("sim/model/sound/volume", 1.0);
    if(nm == 0 or nm == 7)setprop("sim/model/sound/volume", 0.5);
},1,0);

setlistener("controls/flight/flaps", func(flaps){
  var flaps_current = flaps.getValue() / 0.25;
  flaps_current = int(flaps_current+0.5);
  flaps = flaps_current * 0.25;
  setprop("sim/flaps/current-setting", flaps_current);
  setprop("controls/flight/flaps", flaps);
});

##############################################
######### AUTOSTART / AUTOSHUTDOWN ###########
##############################################

setlistener("/sim/model/start-idling", func(idle){
    var run= idle.getBoolValue();
    if(run){
    Startup();
    }else{
    Shutdown();
    }
},0,0);

var Startup = func{
  setprop("controls/electric/engine[0]/generator",1);
  setprop("controls/electric/engine[1]/generator",1);
  setprop("/controls/engines/engine[0]/magnetos",3);
  setprop("controls/engines/engine[0]/fuel-pump",1);
  setprop("controls/engines/engine[0]/propeller-pitch",1);
  setprop("controls/engines/engine[0]/mixture",1);
  setprop("/engines/engine[0]/rpm",250);
  setprop("/engines/engine[0]/running",1);
  setprop("/controls/engines/engine[1]/magnetos",3);
  setprop("controls/engines/engine[1]/fuel-pump",1);
  setprop("controls/engines/engine[1]/propeller-pitch",1);
  setprop("controls/engines/engine[1]/mixture",1);
  setprop("/engines/engine[1]/rpm",250);
  setprop("/engines/engine[1]/running",1);
  setprop("/controls/gear/brake-parking",0);
  setprop("/instrumentation/doors/crew/position-norm",0);
  setprop("/systems/electrical/outputs/instrument-lights",1);
  setprop("controls/electric/battery-switch",1);
}

var Shutdown = func{
  setprop("controls/electric/engine[0]/generator",0);
  setprop("controls/electric/engine[1]/generator",0);
  setprop("/controls/engines/engine[0]/magnetos",0);
  setprop("controls/engines/engine[0]/fuel-pump",0);
  setprop("controls/engines/engine[0]/propeller-pitch",0);
  setprop("controls/engines/engine[0]/mixture",0);
  setprop("/engines/engine[0]/rpm",0);
  setprop("/engines/engine[0]/running",0);
  setprop("/controls/engines/engine[1]/magnetos",0);
  setprop("controls/engines/engine[1]/fuel-pump",0);
  setprop("controls/engines/engine[1]/propeller-pitch",0);
  setprop("controls/engines/engine[1]/mixture",0);
  setprop("/engines/engine[1]/rpm",0);
  setprop("/engines/engine[1]/running",0);
  setprop("/controls/gear/brake-parking",1);
  setprop("/instrumentation/doors/crew/position-norm",1);
  setprop("/systems/electrical/outputs/instrument-lights",0);
  setprop("controls/electric/battery-switch",0);
}

###############################################
###############################################
###############################################

var update_system = func{

  settimer(update_system, 0);
}
