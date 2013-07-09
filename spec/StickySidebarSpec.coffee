(($)->
  jasmine.getFixtures().fixturesPath = 'base/spec/fixtures'

  describe "$.fn.stickySidebar", ->
    beforeEach(->
      loadFixtures "mainBody.html"
    )
    afterEach(->
      $("#main-body").remove()
      $(window).off()
    )

    it "should be exist", ->
      expect($).not.toEqual(undefined)
      expect(typeof $.fn.stickySidebar).toEqual("function")

    it "should be static position at init", ->
      $("#main-body .side-sticky").stickySidebar(
        $main: $("#main-body")
        $wrapper: $("#main-body .span3")
      )
      $("#main-body .side-sticky").each(->
        expect($(@).css("position")).toEqual("static")
      )

    it "should be fixed position if window.height is great enough", ->
      callback =
        onStickyChange: () ->
      options =
        $main: $("#main-body")
        $wrapper: $("#main-body .span3")
        onStickyChange: (positionType) ->
          callback.onStickyChange(positionType)
      $("#main-body .side-sticky").stickySidebar(options)
      spyOn(callback, "onStickyChange")

      runs ->
        $(window).scrollTop(700)
      waits 1000
      runs ->
        expect(callback.onStickyChange).toHaveBeenCalledWith("fixed")

    it "should be absolute position if window.height is great enough and scroll to bottom", ->
      callback =
        onStickyChange: () ->
      options =
        $main: $("#main-body")
        $wrapper: $("#main-body .span3")
        onStickyChange: (positionType) ->
          callback.onStickyChange(positionType)
      $("#main-body .side-sticky").stickySidebar(options)
      spyOn(callback, "onStickyChange")

      runs ->
        $(window).scrollTop($(document).height())
      waits 1000
      runs ->
        expect(callback.onStickyChange).toHaveBeenCalledWith("absolute")

    it "should always be static if document's height < minHeight", ->
      $("#main-body").css("height", "200px")
      callback =
        onStickyChange: () ->
      options =
        $main: $("#main-body")
        $wrapper: $("#main-body .span3")
        onStickyChange: (positionType) ->
          callback.onStickyChange()
      $("#main-body .side-sticky").stickySidebar(options)
      spyOn(callback, "onStickyChange")

      runs ->
        $(window).scrollTop(700)
      waits 1000
      runs ->
        expect(callback.onStickyChange).not.toHaveBeenCalled()

    it "should set top if position fixed and options.paddingTop", ->
      callback =
        onStickyChange: () ->
      options =
        $main: $("#main-body")
        $wrapper: $("#main-body .span3")
        paddingTop: 20
        onStickyChange: (positionType) ->
          callback.onStickyChange(positionType)
      $("#main-body .side-sticky").stickySidebar(options)
      spyOn(callback, "onStickyChange")

      runs ->
        $(window).scrollTop(700)
      waits 1000
      runs ->
        expect(callback.onStickyChange).toHaveBeenCalledWith("fixed")
        expect( $("#main-body .side-sticky").first().css("top") ).toEqual("20px")

    it "should set bottom if position absolute and options.paddingBottom", ->
      callback =
        onStickyChange: () ->
      options =
        $main: $("#main-body")
        $wrapper: $("#main-body .span3")
        paddingBottom: 20
        onStickyChange: (positionType) ->
          callback.onStickyChange(positionType)
      $("#main-body .side-sticky").stickySidebar(options)
      spyOn(callback, "onStickyChange")

      runs ->
        $(window).scrollTop($(document).height())
      waits 1000
      runs ->
        $last = $("#main-body .side-sticky").last()
        $mainBody = $("#main-body")
        expect(callback.onStickyChange).toHaveBeenCalledWith("absolute")
        expect($last.position().top + $last.height() + 20).toEqual($mainBody.position().top + $mainBody.height())
)(window.$)
