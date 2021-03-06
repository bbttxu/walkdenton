define(["jquery", "sammy"], function($, Sammy) {

    Sammy = Sammy || {};

    // A simple plugin that pings Google Analytics tracker
    // every time a route is triggered
    //
    // === Arguments
    //
    // +tracker+:: the Google Analytics pageTracker object.  Defaults to
    // the default object defined by the GA snippet, or pass your own if you
    // have a custom install
    Sammy.GoogleAnalytics = function(app, tracker) {
        var _tracker = tracker || window.pageTracker,
            shouldTrack = true;

        this.helpers({
            noTrack: function() {
                disableTracking();
            }
        });

        this.bind('event-context-after', function() {
            if (typeof _tracker != 'undefined' && shouldTrack) {
                console.log('tracking', this.path);
                _tracker._trackPageview(this.path);
            }
            enableTracking();
        });

        function disableTracking() {
            shouldTrack = false;
        }

        function enableTracking() {
            shouldTrack = true;
        }
    };
});