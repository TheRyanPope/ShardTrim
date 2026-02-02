# ShardTrim

A lightweight World of Warcraft addon that helps manage Soul Shards by deleting excess shards **one at a time** down to a configurable keep count via a slash command. Designed for **TBC Classic / Anniversary**.

## Why ShardTrim?

Managing Soul Shards can get annoying fast—especially when farming, summoning, or prepping for raids.  
ShardTrim gives you a quick, repeatable way to trim excess shards without digging through bags or accidentally deleting too many.

## Usage

Due to World of Warcraft client restrictions, addons **cannot automatically delete multiple items from bags with a single user action**.

**Each `/shardtrim` or `/st` command deletes *one* excess Soul Shard**, as long as you are above the configured keep count.

This behavior is intentional and fully compliant with Blizzard’s protected action rules.

## Commands

- `/st` or `/shardtrim`  
  Deletes **one** excess Soul Shard if you are above the keep count.

- `/shardtrim <number>`  
  Sets how many Soul Shards to keep.

- `/shardtrim reset`  
  Resets the keep count to the default (4).

- `/shardtrim help`  
  Displays usage information in chat.

## Notes

- Deletes excess Soul Shards **one per slash command use**
- Will not delete shards while in combat
- Safe against accidental mass deletion
- No UI, no keybinds, no bloat

## Installation

### CurseForge / WoW Interface
1. Open the CurseForge app and navigate to **World of Warcraft → `_anniversary_` →Interface\AddOns**.
2. Search for **ShardTrim**.
3. Click **Install**.
4. Reload WoW or log in.

### GitHub
1. Go to the [ShardTrim GitHub repository](https://github.com/TheRyanPope/ShardTrim.git).
2. Click **Code → Download ZIP**.
3. Extract the ZIP into your `Interface/AddOns` folder.
4. Reload WoW or log in.

### Git Clone
1. Open a terminal in your `Interface/AddOns` folder.
2. Run:
   ```bash
   git clone https://github.com/TheRyanPope/ShardTrim.git
