---
lang: "eng"
title: "Minecraft Playtime Command Block"
date: 2025-05-08 03:55 +0800
---

A set of commandblock to track player's online time, storage as minutes, display using custom unit.

## Command Block Code and Structure

```text
[repeating]
execute as @a if score @s playtime_ticks matches 1200.. run scoreboard players add @s playtime_minutes 1
[chain]
execute as @a if score @s playtime_ticks matches 1200.. run scoreboard players set @s playtime_ticks 0

[chain]
scoreboard players set @a kPlaytimeDisplayDivisor 60
[chain]
execute as @a run scoreboard players operation @s playtime_display = @s playtime_minutes
[chain]
execute as @a run scoreboard players operation @s playtime_display /= @s kPlaytimeDisplayDivisor
```

> NOTE:\
> Please point the previous block to the next one properly.

> WARNING:\
> The `score @s playtime_ticks matches 1200..` part must use `1200..`(score greater than 1200) as the condition because the chain block needs 1 tick to pass the signal to the next block.\
> Not doing so will cause a lot of bugs.

The scoreboard objective `playtime_ticks` is a temporary variable of the structure, the real playtime storage in `playtime_minutes`.

The minute is the smallest unit that can be recorded here, but we usually don't want to display them directly, that would be too long.\
So the second part of the code is used to calculate objective `playtime_display` by `playtime_minutes / kPlaytimeDisplayDivisor`. As an example in the code, the `kPlaytimeDisplayDivisor` is 60, which means the display unit is one hour.\
Same thing, 120 is two hours.

## Show to users

Type this command to display this objective in sidebar:

```text
/scoreboard objectives setdisplay sidebar playtime_display
```

## See also

- [Command Block – Minecraft Wiki](https://minecraft.wiki/w/Command_Block)
- [Scoreboard – Minecraft Wiki](https://minecraft.wiki/w/Scoreboard)
- And some random YouTube videos :D
