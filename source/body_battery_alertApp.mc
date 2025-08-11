import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Time;

(:background)
class body_battery_alertApp extends Application.AppBase {
    
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        // Register for background events - check every 5 minutes (300 seconds)
        Background.registerForTemporalEvent(new Time.Duration(300));
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        // Background events will continue even when app is closed
    }
    
    // Handle background service data
    function onBackgroundData(data as Application.PersistableType) as Void {
       
    }
    
    // Get the background service delegate
    function getServiceDelegate() {
        return [new BodyBatteryBackground()];
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new body_battery_alertView(), new body_battery_alertDelegate() ];
    } 

}

function getApp() as body_battery_alertApp {
    return Application.getApp() as body_battery_alertApp;
}
