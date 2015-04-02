aircraft.livery.init("Aircraft/Douglas-Dc3/Models/Liveries");

setlistener('sim/model/livery/file', func {
	var emission = props.globals.getNode('sim/model/livery/emission');
	foreach (var component; emission.getChildren()) {
    	component.setValue(0.0);
	}
	var engine_emissions = props.globals.getNode('sim/model/livery-engine/emission');
	foreach (var component; engine_emissions.getChildren()) {
    	component.setValue(0.0);
	}
}, startup=1, runtime=0);