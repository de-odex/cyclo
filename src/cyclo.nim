import os, parsecfg, strutils, tables, sequtils, math, streams, json

import cyclo/[ids, data]

proc saveLocation: string =
  when defined(windows):
    result = getEnv("localappdata")
    if result == "":
      result = getEnv("appdata") /../ "Local"
  elif defined(macosx):
    result = getHomeDir() / "Library" / "Application Support"
  elif defined(linux):
    result = getConfigDir()
  result = result / "IIslandsOfWar" / "save_8" # FIXME: generalize for save v(N)

template logError(s: varargs[string]) =
  echo "error: " & s.join("")

type
  PlayerSave = distinct string
  EditablePlayerSave = object
    playerData: string # TODO: allow this to be edited
    money: int
    sandbox: bool
    inventory: seq[InventoryItem]

#
# ──────────────────────────────────────────────────────────── I ──────────
#   :::::: C O N V E R T E R S : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────────
#

proc toEditable(save: PlayerSave): EditablePlayerSave =
  let saveObj = loadConfig(newStringStream(save.string))
  result.playerData = saveObj.getSectionValue("player", "data")
  result.money = saveObj.getSectionValue("game", "money").parseInt
  result.sandbox = saveObj.getSectionValue("game", "sandbox").parseBool
  result.inventory = saveObj.getSectionValue(
    "inventory", "inventory"
  ).parseInventory

proc toRegular(save: EditablePlayerSave): PlayerSave =
  var saveObj = newConfig()
  saveObj.setSectionKey("player", "data", save.playerData)
  saveObj.setSectionKey("game", "money", $save.money)
  saveObj.setSectionKey("game", "sandbox", if save.sandbox: "1" else: "0")
  saveObj.setSectionKey("inventory", "size", $save.inventory.len)
  saveObj.setSectionKey("inventory", "inventory", save.inventory.toSaveString)
  ($saveObj).PlayerSave

proc parseMapping(arr: openArray[string]): Table[string, string] =
  (arr.map do (it: string) -> (string, string):
    let temp = it.split(":")
    if temp.len < 2:
      logError "malformed argument: ", it
      return
    (temp[0], temp[1])
  ).filterIt(it != ("", "")).toTable

# ────────────────────────────────────────────────────────────────────────────────

when isMainModule:
  # TODO: macroize help generation
  let helpString = """
  {} means to substitute the contents with the proper value
    ex: item_name -> the name of the item (compressed_dirt or floatron_basic)
  [] means the argument is optional
  / means you can substitute what's on the left with what's on the right
    ex: you can put "show player" or "show inventory"

  commit
    commit your edits to your save file
  reload
    reload your save file
  exit, quit, stop, end
    finish editing your save
  help [{command_name}]
    shows this or help for the command
    unimplemented: command help
  give item:{item_name} [tier:{tier_number}] [count:{count_number}]
    give yourself an item
  show player/inventory/save
    show your player/inventory/save data
    unimplemented: player show
  list item/property
    list the available items/properties
    unimplemented: property list
  unglitch
    unglitch in-game "give"n items
  cheatpack tech
    gives you a pack of items with count 200
    unimplemented: other packs
  edit
    create a file which you can edit to add items manually
    similar to manually editing your save, but in a more human friendly format
  """.unindent(2).strip
  echo helpString

  var playerSave = readFile(saveLocation() / "player.txt").PlayerSave.toEditable
  writeFile("player.txt.bak", readFile(saveLocation() / "player.txt"))

  # TODO: macroize command loop
  while true:
    stdout.write ">>> "
    let
      line = stdin.readLine
      args = line.split
    if args.len < 1:
      continue
    case args[0]
    of "exit", "quit", "stop", "end":
      break
    of "help", "?":
      if args.len < 2:
        echo helpString
      else:
        discard
    of "give":
      let mapping = args[1..^1].parseMapping
      if "item" notin mapping:
        logError "item not in args"
        continue
      try:
        let
          count = if "count" in mapping: mapping["count"].parseInt else: 1
          tier = if "tier" in mapping: mapping["tier"].parseInt else: 1
          item = initInventoryItemTier(parseEnum[ItemKind](mapping["item"]),
          count, tier)
        playerSave.inventory.addItem item
        # let dup = playerSave.inventory.find item
        # if dup != -1:
        #   playerSave.inventory[dup].combine item
        # else:
        #   playerSave.inventory.add item
      except ValueError:
        logError getCurrentExceptionMsg()
    of "show":
      if args.len < 2:
        logError "missing arguments"
        continue
      case args[1]
      of "player":
        discard
      of "inventory":
        for item in playerSave.inventory:
          echo item
      of "save":
        echo playerSave.toRegular.string
      else:
        logError "unknown argument: ", args[1]
    of "list":
      if args.len < 2:
        logError "missing arguments"
        continue
      case args[1]
      of "item":
        for i in ItemKind.low..ItemKind.high:
          echo i.ItemKind
      else:
        logError "unknown argument: ", args[1]
    of "unglitch":
      for item in playerSave.inventory.mitems:
        if rarity in item.properties and item.properties[rarity] == "glitched":
          item.properties.del rarity
    of "cheatpack":
      if args.len < 2:
        logError "missing arguments"
        continue
      var itemIds: seq[int]
      case args[1]
      of "blocks":
        itemIds = toSeq(sand.int..aerogel.int)
      of "special":
        itemIds = toSeq(floatron_basic.int..shield_ultimate.int)
      of "buildings":
        itemIds = toSeq(tree_bush.int..mount.int)
      of "weapons":
        itemIds = toSeq(cannon.int..railgun_colossal.int)
      of "tech":
        itemIds = toSeq(propulsor_basic.int..aileron.int)
      else:
        logError "unknown argument: ", args[1]
        continue
      for itemId in itemIds:
        let item = initInventoryItemTier(itemId.ItemKind, 200, 1)
        playerSave.inventory.addItem item
    of "edit":
      # TODO: generate automatically, detect changes automatically
      #       then deprecate this command

      # prep edit file
      var editFile = open("edit_me.txt", fmReadWrite)
      # editFile.writeLine "// you cannot change the xp or tier values here"
      # editFile.writeLine "// use the regular mode instead"

      editFile.write (%playerSave).pretty()
      editFile.flushFile
      editFile.close

      stdout.write "press enter when finished..."
      discard stdin.readLine

      # reconvert edited file to normal editable save
      discard editFile.open("edit_me.txt", fmRead)
      editFile.setFilePos(0)
      var editJson = editFile.readAll.split("\n").filterIt(not it.startsWith(
          "//")).join("\n").parseJson

      var editedPlayerSave: EditablePlayerSave
      editedPlayerSave.playerData = editJson["playerData"].getStr
      editedPlayerSave.money = editJson["money"].getInt
      editedPlayerSave.sandbox = editJson["sandbox"].getBool
      let tempInv = editJson["inventory"].getElems
      editedPlayerSave.inventory = tempInv.map do (item: JsonNode) -> InventoryItem:
        result.count = item["count"].getInt
        result.kind = parseEnum[ItemKind](item["kind"].getStr)
        result.totalXp = item["totalXp"].getInt
        result.damaged = item["damaged"].getBool
        let tempProps = toSeq(item["properties"].getFields.pairs)
        let tempProps2 = tempProps.map do (pair: (string, JsonNode)) -> (
            PropertyKind, string):
          (parseEnum[PropertyKind](pair[0]), pair[1].getStr)
        result.properties = tempProps2.toTable

      editFile.close()
      removeFile("edit_me.txt")
      playerSave = editedPlayerSave
    of "commit":
      writeFile("player.txt.bak", readFile(saveLocation() / "player.txt"))
      writeFile(saveLocation() / "player.txt", toRegular(playerSave).string)
    of "reload":
      # TODO: maybe detect changes automatically
      playerSave = readFile(saveLocation() / "player.txt").PlayerSave.toEditable
      writeFile("player.txt.bak", readFile(saveLocation() / "player.txt"))
    of "":
      continue
    else:
      logError "unknown command: ", args[0]
