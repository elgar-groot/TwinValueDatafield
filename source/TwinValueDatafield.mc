using Toybox.WatchUi   as Ui;
using Toybox.Graphics  as Gfx;
using Toybox.Activity  as Act;
using Toybox.System    as Sys;
using Toybox.Lang      as Lang;

class TwinValueDatafield extends Ui.DataField {
    var _mainValue = "--";
    var _secondaryValue = "--";
    // Change to reflect values
    var _label = "SPEED";

    var _speedFactor = 1.0;

    var _tinyFont = Gfx.FONT_XTINY;
    var _smallFont = Gfx.FONT_SMALL;
    var _largeFont = Gfx.FONT_LARGE;
    // Realistic font height in pixels.
    // Both fonts have 1px in descent and 6 or 7 pixels whitespace above
    // so these values are the actual font height in pixels as displayed
    var _hOffsetSmall = 5;
    var _hOffsetLarge = 6;
    var _hSmall = Gfx.getFontAscent(_smallFont) - _hOffsetSmall;
    var _hLarge = Gfx.getFontAscent(_largeFont) - _hOffsetLarge;

    var _minHeightVerticalLayout = _hSmall + _hLarge + _hSmall;

    function initialize() {
        Ui.DataField.initialize();
        if (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC) {
            _speedFactor = 3.6;
        } else {
            _speedFactor = 2.2369363;
        }
    }

    function formatSpeed(mps as Lang.Float) as Lang.String {
        // system speed is in m/s so needs to be
        return (mps * _speedFactor).format("%03.1f");
    }

    function getCurrentSpeed(info as Act.Info) {
        // value may be null, so check
        var currentSpeed = (info != null && (info has :currentSpeed)) ? info.currentSpeed : null;
        return (currentSpeed != null) ? formatSpeed(currentSpeed) : "--";
    }

    function getAverageSpeed(info as Act.Info) {
        // value may be null, so check
        var averageSpeed = (info != null && (info has :averageSpeed)) ? info.averageSpeed : null;
        return (averageSpeed != null) ? formatSpeed(averageSpeed) : "--";
    }

    function compute(info as Act.Info) as Void {
        // change to whatever values you want to display
        _mainValue = getCurrentSpeed(info);
        _secondaryValue = getAverageSpeed(info);
    }

    function onUpdate(dc as Gfx.Dc) as Void {
        var bg = getBackgroundColor();
        dc.setColor(bg, bg);
        dc.clear();
        var fg = (bg == Gfx.COLOR_BLACK) ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK;
        dc.setColor(fg, Gfx.COLOR_TRANSPARENT);

        var W = dc.getWidth();
        var H = dc.getHeight();

        // difference between text height and field height
        var hDiff = H - _minHeightVerticalLayout;
        if (hDiff < 0) {
            /* In horizontal layout the values are displayed side by side like:
                MAIN  SECONDARY
            */
            var leftW = dc.getTextWidthInPixels(_mainValue, _largeFont);
            var rightW = dc.getTextWidthInPixels(_secondaryValue, _smallFont);
            // difference between text width and field width
            var wDiff = W - (leftW + rightW);
            var padX = wDiff / 3;
            var leftX = padX;
            var rightX = padX + leftW + padX;
            var padY = (H - _hLarge) / 2;
            var leftY = padY - _hOffsetLarge;
            var rightY = padY - _hOffsetSmall + (_hLarge - _hSmall);
            dc.drawText(leftX, leftY, _largeFont, _mainValue, Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(rightX, rightY, _smallFont, _secondaryValue, Gfx.TEXT_JUSTIFY_LEFT);
        } else {
            /* In vertical layout the values are displayed like:
                LABEL
                MAIN
                SECONDARY
            */
            var pad = hDiff / 4;
            var topY = pad + _hSmall/2;
            var middleY = pad + _hSmall + pad + _hLarge/2;
            var bottomY = pad + _hSmall + pad + _hLarge + pad + _hSmall/2;
            dc.drawText(W/2, topY, _tinyFont, _label, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            dc.drawText(W/2, middleY, _largeFont, _mainValue, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            dc.drawText(W/2, bottomY, _smallFont, _secondaryValue, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        }
    }
}
