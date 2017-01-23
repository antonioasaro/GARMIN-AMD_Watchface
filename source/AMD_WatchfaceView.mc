using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer as Timer;
using Toybox.ActivityMonitor as AttMon;

class AMD_WatchfaceView extends Ui.WatchFace {
    var bigFont;
    var bigFontBold;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
       setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        Sys.println("Antonio - onUpdate");
        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        var dateString = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
        var dateView = View.findDrawableById("id_date");
        dateView.setText(dateString);
            
        var clockTime = Sys.getClockTime();
        var hour = clockTime.hour; 
        if (hour > 12) { hour = hour - 12; }
        var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
        var timeView = View.findDrawableById("id_time");
        timeView.setText(timeString);    
    
        var BTstatusBitmap;
        var devSettings = Sys.getDeviceSettings();
        if (devSettings.phoneConnected) { 
	 		BTstatusBitmap = Ui.loadResource(Rez.Drawables.ConnectIcon);
        } else {
	 		BTstatusBitmap = Ui.loadResource(Rez.Drawables.DisconnectIcon);
	 	}
	 	
	 	var activity= AttMon.getInfo();
	 	var steps = activity.steps;
        var stepsView = View.findDrawableById("id_steps");
        stepsView.setText(steps.toString());

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var stats = Sys.getSystemStats(); 
        var battery = stats.battery;
        dc.setColor(0xBBBBBB, Gfx.COLOR_TRANSPARENT);
        if (battery < 100) { dc.drawText(22, 101, Gfx.FONT_SYSTEM_XTINY, battery.format("%d") + "%", Gfx.TEXT_JUSTIFY_CENTER); }
        if (battery <= 75) { dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT); }
        if (battery <= 50) { dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT); }
        if (battery <= 25) { dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT); }
        dc.fillRectangle(15, 74, 9, 3);
        dc.fillRectangle(13, 77, 14, 25);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(15, 79, 10, (20 * (100 - battery)) / 100);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
