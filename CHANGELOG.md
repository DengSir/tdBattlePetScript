## [10.0.0]

- Updated for Dragonflight.
- Added `collected` to the Pets API (`true` if the pet is in your collection).
- Added `trap` to the Status API (`true` if the trap is usable (or potentially usable if enemy hp is low enough)).
- Fixed condition behavior when the condition includes a non-existent pet or ability. This allows (among others) using ability `(Ghostly Bite:654) [enemy.ability (Mudslide:572).duration < 5]`, even if the current pet does not have Mudslide, to be used in generic scripts. See the discussion in [this issue](https://github.com/DengSir/tdBattlePetScript/issues/26) for more detail and exact semantics.
- General bug fixes
