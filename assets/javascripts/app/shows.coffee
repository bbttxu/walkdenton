shows.coffee
define [ "postal", "jquery", "viewModels/showDate", "viewModels/show", "viewModels/gig", "viewModels/venue", "knockout" ], (postal, $, showDate, showModel, gigModel, venueModel, ko)->
  channel = postal.channel()


  showDateView = new showDate
  ko.applyBindings showDateView, $('#showDate')[0]

  grabShowsForDate = (event, date)->
    # console.log 'grabShowsForDates'
    showDateView.date(date)
    showDateView.shows []

    $.getJSON "http://denton1.krakatoa.io/shows/" + date + ".json?callback=?", (data, status)->
      # console.log 'grabShowsForDates callback'
      artistByID = (artistID)->
        for artist in data.artists
          return artist.name if artist.id is artistID
        "no artist found"

      gigByID = (id)->
        for gig in data.gigs
          return gig if gig.id is id
        "no gig found"

      venueViewByID = (id)->
        for venue in data.venues
          return new venueModel venue if venue.id is id
        "no venue found"

      shows = for thisShow in data.shows
        thisShow.gigs = for gig in thisShow.gigs
          gig = gigByID gig
          gig.artist = artistByID(gig.artists)
          new gigModel gig

        showView = new showModel thisShow

        showView.venue( venueViewByID( thisShow.venues ) )

        showView

      showDateView.shows shows

      # console.log showDateView.venueMarkers()

      # $('#map').trigger 'map:setDataset', venues: showDateView.venueMarkers()

      channel.publish 'set.setDataset', venues: showDateView.venueMarkers()


  $(document).on('dateChange', 'body', grabShowsForDate).trigger('dateChange', new Date())
