##########################################################
######### BACON Guillaume for Douglas DC-3/C-47 ##########
##########################################################

var starter_serviceable = 0;
var cranking_serviceable = 0;
var engine_serviceable = 0;
var time = props.globals.getNode("sim/time/elapsed-sec");
var last_change = 0;

setlistener("/sim/signals/fdm-initialized", func{
  setprop("/controls/gear/brake-parking",1);
  setprop("/instrumentation/doors/crew/position-norm",0);
  settimer(update_system, 2);
  print("Aircraft Systems ... OK");
});

#setlistener("/sim/current-view/view-number", func(vw) {
#    var nm = vw.getValue();
#    setprop("sim/model/sound/volume", 1.0);
#    if(nm == 0 or nm == 7)setprop("sim/model/sound/volume", 0.5);
#},1,0);

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

##############################################
################# ANIMATION  #################
################ INTERPOLATE  ################
##############################################

setlistener("/controls/electric/battery-switch", func(v) {
  if(v.getValue()){
    interpolate("/controls/electric/battery-switch-pos", 1, 0.25);
  }else{
    interpolate("/controls/electric/battery-switch-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/landing-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/landing-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/landing-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/landing-lights[1]", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/landing-lights-pos[1]", 1, 0.25);
  }else{
    interpolate("/controls/lighting/landing-lights-pos[1]", 0, 0.25);
  }
});

setlistener("/controls/engines/engine/oil-dilution", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine/oil-dilution-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine/oil-dilution-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine[1]/oil-dilution", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine[1]/oil-dilution-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine[1]/oil-dilution-pos", 0, 0.25);
  }
});

setlistener("/controls/paratroopers/jump-signal", func(v) {
  if(v.getValue()){
    interpolate("/controls/paratroopers/jump-signal-pos", 1, 0.25);
  }else{
    interpolate("/controls/paratroopers/jump-signal-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/passing-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/passing-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/passing-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/anti-ice/pitot-heat", func(v) {
  if(v.getValue()){
    interpolate("/controls/anti-ice/pitot-heat-pos", 1, 0.25);
  }else{
    interpolate("/controls/anti-ice/pitot-heat-pos", 0, 0.25);
  }
});

setlistener("/controls/anti-ice/pitot-heat[1]", func(v) {
  if(v.getValue()){
    interpolate("/controls/anti-ice/pitot-heat-pos[1]", 1, 0.25);
  }else{
    interpolate("/controls/anti-ice/pitot-heat-pos[1]", 0, 0.25);
  }
});

setlistener("/controls/anti-ice/prop-heat", func(v) {
  if(v.getValue()){
    interpolate("/controls/anti-ice/prop-heat-pos", 1, 0.25);
  }else{
    interpolate("/controls/anti-ice/prop-heat-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/running-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/running-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/running-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/tail-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/tail-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/tail-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/anti-ice/window-heat", func(v) {
  if(v.getValue()){
    interpolate("/controls/anti-ice/window-heat-pos", 1, 0.25);
  }else{
    interpolate("/controls/anti-ice/window-heat-pos", 0, 0.25);
  }
});

setlistener("/controls/electric/battery-switch", func(v) {
  if(v.getValue()){
    interpolate("/controls/electric/battery-switch-pos", 1, 0.25);
  }else{
    interpolate("/controls/electric/battery-switch-pos", 0, 0.25);
  }
});

setlistener("/controls/electric/battery-switch", func(v) {
  if(v.getValue()){
    interpolate("/controls/electric/battery-switch-pos", 1, 0.25);
  }else{
    interpolate("/controls/electric/battery-switch-pos", 0, 0.25);
  }
});

setlistener("/controls/fuel/tank/boost-pump", func(v) {
  if(v.getValue()){
    interpolate("/controls/fuel/tank/boost-pump-pos", 1, 0.25);
  }else{
    interpolate("/controls/fuel/tank/boost-pump-pos", 0, 0.25);
  }
});

setlistener("/controls/fuel/tank[1]/boost-pump", func(v) {
  if(v.getValue()){
    interpolate("/controls/fuel/tank[1]/boost-pump-pos", 1, 0.25);
  }else{
    interpolate("/controls/fuel/tank[1]/boost-pump-pos", 0, 0.25);
  }
});

setlistener("/controls/anti-ice/engine/carb-heat", func(v) {
  if(v.getValue()){
    interpolate("/controls/anti-ice/engine/carb-heat-pos", 1, 0.25);
  }else{
    interpolate("/controls/anti-ice/engine/carb-heat-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/cabin-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/cabin-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/cabin-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine/starter", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine/starter-pos", 1, 0.1);
  }else{
    interpolate("/controls/engines/engine/starter-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine[1]/starter", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine[1]/starter-pos", 1, 0.1);
  }else{
    interpolate("/controls/engines/engine[1]/starter-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/recognition-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/recognition-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/recognition-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/recognition-lights[1]", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/recognition-lights-pos[1]", 1, 0.25);
  }else{
    interpolate("/controls/lighting/recognition-lights-pos[1]", 0, 0.25);
  }
});

setlistener("/controls/lighting/recognition-lights[2]", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/recognition-lights-pos[2]", 1, 0.25);
  }else{
    interpolate("/controls/lighting/recognition-lights-pos[2]", 0, 0.25);
  }
});

setlistener("/controls/engines/engine/propeller-feather", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine/propeller-feather-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine/propeller-feather-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine[1]/propeller-feather", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine[1]/propeller-feather-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine[1]/propeller-feather-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/compass-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/compass-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/compass-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/formation-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/formation-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/formation-lights-pos", 0, 0.25);
  }
});

##############################################
################ TIRE SYSTEM #################
##############################################

#tire rotation per minute by circumference/groundspeed#
TireSpeed = {
    new : func(number){
        m = { parents : [TireSpeed] };
            m.num=number;
            m.circumference=[];
            m.tire=[];
            m.rpm=[];
            for(var i=0; i<m.num; i+=1) {
                var diam =arg[i];
                var circ=diam * math.pi;
                append(m.circumference,circ);
                append(m.tire,props.globals.initNode("gear/gear["~i~"]/tire-rpm",0,"DOUBLE"));
                append(m.rpm,0);
            }
        m.count = 0;
        return m;
    },
    #### calculate and write rpm ###########
    get_rotation: func (fdm1){
        var speed=0;
        if(fdm1=="yasim"){ 
            speed =getprop("gear/gear["~me.count~"]/rollspeed-ms") or 0;
            speed=speed*60;
            }elsif(fdm1=="jsb"){
                speed =getprop("fdm/jsbsim/gear/unit["~me.count~"]/wheel-speed-fps") or 0;
                speed=speed*18.288;
            }
        var wow = getprop("gear/gear["~me.count~"]/wow");
        if(wow){
            me.rpm[me.count] = speed / me.circumference[me.count];
        }else{
            if(me.rpm[me.count] > 0) me.rpm[me.count]=me.rpm[me.count]*0.95;
        }
        me.tire[me.count].setValue(me.rpm[me.count]);
        me.count+=1;
        if(me.count>=me.num)me.count=0;
    },
};


#var tire=TireSpeed.new(# of gear,diam[0],diam[1],diam[2], ...);
var tire=TireSpeed.new(3, 1.143, 1.143, 0.560);

###############################################
###############################################
###############################################

var update_system = func{

  if(getprop("/systems/electrical/outputs/starter") > 11){
    setprop("/engines/engine[0]/cranking",1);
  }else{
    setprop("/engines/engine[0]/cranking",0);
  }

  if(getprop("/systems/electrical/outputs/starter[1]") > 11){
    setprop("/engines/engine[1]/cranking",1);
  }else{
    setprop("/engines/engine[1]/cranking",0);
  }

  tire.get_rotation("yasim");
  settimer(update_system, 0);
}
