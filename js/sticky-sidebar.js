;(function($) {
    $.fn.stickySidebar = function(options) {
        if(!$(this).length)
            return;
        var opts = $.extend({}, $.fn.stickySidebar.defaults, options),
            $main = opts.$main,
            $wrapper = opts.$wrapper,
            minHeight = opts.minHeight,
            $elms = $(this),
            nums = $elms.length,
            firstTop, lastTop;
        var getHeights = function($elms, from, to) {
            var sum = 0;
            $elms.each(function(idx) {
                (to > -1 && idx >= from && idx <= to) && (sum += $(this).height());
            });
            return sum;
        }, getCond = function() {
            var e = window.pageYOffset || document.documentElement.scrollTop;
            firstTop = (e < $wrapper.children().first().position().top + siblingsHeights) ? ($wrapper.children().first().position().top + siblingsHeights) : ( $wrapper.position().top - opts.paddingTop );
            lastTop = $main.position().top + $main.height() - getHeights($elms, 0, nums - 1) - opts.paddingBottom;
        }, checkPositionType = function() {
            var positionType = "static";
            if ($(document).height() > $wrapper.height() && ( $(window).height() > getHeights($elms, 0, nums - 1) || $(window).height() > minHeight )) {
                var e = window.pageYOffset || document.documentElement.scrollTop;
                positionType = e < firstTop ? ("static") : (e < lastTop ? ("fixed") : ("absolute"));
            }
            return positionType;
        }, setEach = function($elms, positionType, $main, $wrapper) {
            $elms.each(function(idx) {
                var top = (positionType === "static") ? ("") : (( positionType === "fixed" ) ? (opts.paddingTop + getHeights($elms, 0, idx - 1) + "px") : ($main.position().top + $main.height() - getHeights($elms, idx, nums - 1) - opts.paddingBottom + "px"));
                $(this).css({
                    "position": positionType,
                    "top": top,
                    "width": $wrapper.width() + "px"
                });
            });
        }, siblingsHeights = (function($wrapper, $first) {
            var sum = 0,
                firstIdx = $first.index();
            $wrapper.children().each(function(idx) {
                idx < firstIdx && (sum += $(this).height());
            });
            return sum;
        })($wrapper, $elms.first());
        // check init position type and top
        getCond();
        setEach($elms, checkPositionType(), $main, $wrapper);
        // event for ajax loading
        $elms.each(function() {
            $(this).on("ajaxComplete", function() {
                getCond();
                setEach($elms, checkPositionType(), $main, $wrapper);
            });
        });
        // event for document load, resize, scroll
        var currentPosition = "static";
        $(window).on({
            "load": function(e) {
                getCond();
                setEach($elms, checkPositionType(), $main, $wrapper);
            }, "scroll": function(e) {
                var positionType = checkPositionType();
                getCond();
                setEach($elms, positionType, $main, $wrapper);
                currentPosition != positionType && (currentPosition = positionType,  opts.onStickyChange(positionType));
            }
        })
    };
    $.fn.stickySidebar.defaults = {
        $main: $(".span8"),
        $wrapper: $(".span3"),
        minHeight: 520,
        paddingTop: 0,
        paddingBottom: 0,
        onStickyChange: function() {}
    };
})(window.jQuery);