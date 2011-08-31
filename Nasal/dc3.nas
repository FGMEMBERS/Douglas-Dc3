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

###############################################
###############################################
###############################################

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
  tire.get_rotation("yasim");
  settimer(update_system, 0);
}
