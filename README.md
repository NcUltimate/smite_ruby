# Smite API Client for Ruby
---
A simple gem for consuming Smite's API data that includes a lightweight client (Smite::Client) and a slightly heavier object wrapper (Smite::Game)
1. `gem install smite_ruby`
2. `require 'smite'`

## Examples --  Smite::Game
---

### Creating a session
A session can be created through `Smite::Client` to manipulate API data directly in its raw form.
```
> client = Smite::Client.new(<dev_id>, <auth_key>)
#<Smite::Client:0x007fca3343c948
 @auth_key="<auth_key>",
 @dev_id=<dev_id>,
 @session_id="<session_id>">
 
> client.test_session
"This was a successful test with the following parameters added: developer: <dev_id> time: 1/30/2016 6:14:25 PM signature: <signature> session: <session_id>"

> client.get_gods
(huge amount of json/xml god data)
```

You can also create a session through `Smite::Game`, which will provide extensive convenience methods for manipulating the data. The rest of this documentation will assume authentication was done in this way.
```
> Smite::Game.authenticate!(<dev_id>, <auth_key>)
true
```

### Finding a player
```
> Smite::Game.player('adapting')
#<Smite::Player '[Epsi]Adapting'>
```

### Listing/finding gods
```
> Smite::Game.gods
[#<Smite::God 'Agni'>,
 #<Smite::God 'Ah Muzen Cab'>,
 #<Smite::God 'Ah Puch'>,
 #<Smite::God 'Amaterasu'>,
 ...]

> Smite::Game.god('Agni')
#<Smite::God 'Agni'>

> Smite::Game.god(2065)
#<Smite::God 'Ravana'>
```

### Listing/finding items
```
> Smite::Game.items
[#<Smite::Item 'Iron Mail'>,
 #<Smite::Item 'Steel Mail'>,
 #<Smite::Item 'Sovereignty'>,
 #<Smite::Item 'Mystical Mail'>,
 ...]

> Smite::Game.item('Gem of Isolation')
#<Smite::Item 'Gem of Isolation'>

> Smite::Game.item(7526)
#<Smite::Item 'Iron Mail'>
```
## Examples --  Smite::Player
---
```
> player = Smite::Game.player('adapting')
#<Smite::Player '[Epsi]Adapting'>

> player.mastery_level
66
```


### Listing friends
```
> player.friends
[#<Smite::Friend 'aBROcalypse'>,
 #<Smite::Friend 'Adopting'>,
 #<Smite::Friend 'Advert'>,
 #<Smite::Friend 'Aengy'>,
 #<Smite::Friend 'Aiurz'>,
 ...]
 
 > player.friends[0].to_player
#<Smite::Player '[Aluma]aBROcalypse'>
 ```
 
### Listing god ranks
```
 > player.god_ranks
[#<Smite::GodRank 'Thor' Lvl. 10 (diamond)>,
 #<Smite::GodRank 'Mercury' Lvl. 10 (diamond)>,
 #<Smite::GodRank 'Freya' Lvl. 10 (diamond)>,
 #<Smite::GodRank 'Hun Batz' Lvl. 10 (diamond)>,
 #<Smite::GodRank 'Kali' Lvl. 10 (diamond)>,
 #<Smite::GodRank 'Poseidon' Lvl. 10 (diamond)>,
 ...]
 ```
 
### Listing achievements
```
> achievements = player.achievements
#<Smite::Achievements 'Adapting'>

> achievements.double_kills
5280
> achievements.penta_kills
21
 ```
### Listing match history
```
> player.match_history
[#<Smite::Match 'Leagues: Conquest' 'Win'>,
 #<Smite::Match 'Leagues: Conquest' 'Loss'>,
 #<Smite::Match 'Leagues: Conquest' 'Win'>,
 #<Smite::Match 'Leagues: Conquest' 'Win'>,
 #<Smite::Match 'Leagues: Conquest' 'Loss'>,
 #<Smite::Match 'Leagues: Conquest' 'Win'>,
 ... ]
```
## Examples --  Smite::Match
---
```
> match = player.match_history[0]
#<Smite::Match 'Leagues: Conquest' 'Win'>

> match.god
#<Smite::God 'Ne Zha'>

> match.items
[#<Smite::Item 'Purification Beads'>,
 #<Smite::Item 'Aegis Amulet'>,
 #<Smite::Item 'Bumba's Mask'>,
 #<Smite::Item 'Warrior Tabi'>,
 #<Smite::Item 'Jotunn's Wrath'>,
 #<Smite::Item 'Deathbringer'>,
 nil,
 nil]
 
 > match.killing_spree
 2
 ```
## Examples --  Smite::God
---
```
> merc = Smite::Game.god('Mercury')
#<Smite::God 'Mercury'>

> merc.abilities
[#<Smite::Ability 'Made You Look'>,
 #<Smite::Ability 'Maximum Velocity'>,
 #<Smite::Ability 'Special Delivery'>,
 #<Smite::Ability 'Sonic Boom'>,
 #<Smite::Ability 'Fastest God Alive'>]

> merc.speed
375
 ```
## Examples --  Smite::GodRank
---
```
> rank = player.god_ranks[0]
 #<Smite::GodRank 'Thor' Lvl. 10 (diamond)>
 
 > rank.mastered?
 true
 > rank.level
 "diamond"
 > rank.rank
 10
 > rank.worshippers
 4517
  ```
## Examples --  Smite::Item
---
```
> bov = Smite::Game.item('Breastplate of Valor')
#<Smite::Item 'Breastplate of Valor'>

> bov.item_tier
3
> bov.short_desc
"Reduces ability Cooldowns."

 













