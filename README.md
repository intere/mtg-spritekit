# CardGameV2

The inspiration behind this app is to implement Magic The Gathering so that I can play some Modern games against friends on my iPad.


### Strategy
1. Read deck lists (See the [Download](https://www.mtggoldfish.com/deck/download/1389631) link for the [Jeskai](https://www.mtggoldfish.com/archetype/modern-jeskai-48608#paper) deck on mtggoldfish.com)
2. After building a model (`Deck.swift`), go off to MTG APIs to do the following
    1. Search for each unique card by name
    2. After finding the metdata for that card, write it to cache (filename format is `<multiversid>.json`)
    3. Write a map of cardname to multiverseid to user defaults
    4. When looking up a card, we look to cache first, then go out to the MTG APIs
3. When presenting a game scene (or deck preview scene), we go out and fetch all of the images for each unique card in the deck.
