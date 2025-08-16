using Toybox.Application as App;
using Toybox.WatchUi as WatchUi;

class TwinValueDatafieldApp extends App.AppBase {
    function initialize() { App.AppBase.initialize(); }
    function getInitialView() { return [ new TwinValueDatafield() ]; }
}
