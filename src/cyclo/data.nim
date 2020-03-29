import os, parsecfg, strutils, regex, tables, sequtils, math, algorithm
import json, macros

import ids

type
  Item* = object of RootObj
    kind*: ItemKind
    pXp: int
    pTotalXp: int
    pNextXp: int                             # doubles every tier
    pTier: int
    damaged*: bool
    properties*: Table[PropertyKind, string] # TODO: allow this to be edited
  InventoryItem* = object of Item
    count*: int
  Inventory* = seq[InventoryItem]
  PlayerData = object # NOTE: might be a ship schematic format
    x: int
    y: int
    player: bool
    name: string
    class: string
    faction: string
    shopAmount: int
    dropAmount: int
  Player* = object
    data*: string
    schematic*: string
    # FIXME: wrong types for data and schematic

#
# ──────────────────────────────────────────────────────────── I ──────────
#   :::::: P R O C E D U R E S : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────────
#

# ─── UTILITY ────────────────────────────────────────────────────────────────────

proc splitDouble(s, firstIdent, secondIdent: string): seq[seq[string]] =
  s.split(firstIdent).map do (s2: string) -> seq[string]:
    s2.split(secondIdent).filterIt(it != "")

# ─── ITEM ───────────────────────────────────────────────────────────────────────

method minNeededXp(item: Item, tier: int): int {.base.} =
  ((tier-1) * tier div 2) * itemProperty[value][item.kind]

method fix(item: var Item) {.base.} =
  # handle bounds
  let
    maxXp = toSeq(1..5).sum * itemProperty[value][item.kind]
    minXp = 0
  if item.pTotalXp > maxXp:
    item.pTotalXp = maxXp
  elif item.pTotalXp < minXp:
    item.pTotalXp = minXp

  if item.pTier > 5:
    item.pTier = 5
  elif item.pTier < 1:
    item.pTier = 1

  # do recalculations based on new total xp
  var
    tier = 5
    tierXp = item.minNeededXp(tier)
  while item.pTotalXp < tierXp:
    dec tier
    tierXp = item.minNeededXp(tier)
  item.pTier = tier

  let nextXp = itemProperty[value][item.kind] * item.pTier
  if item.pNextXp != nextXp: item.pNextXp = nextXp

  item.pXp = block:
    if item.pTotalXp > toSeq(1..4).sum * itemProperty[value][item.kind]:
      0
    else:
      item.pTotalXp - tierXp

method xp*(item: Item): int {.base.} = item.pXp
method totalXp*(item: Item): int {.base.} = item.pTotalXp
method nextXp*(item: Item): int {.base.} = item.pNextXp
method tier*(item: Item): int {.base.} = item.pTier

method `totalXp=`*(item: var Item, value: int) {.base.} =
  item.pTotalXp = value
  item.fix
method `tier=`*(item: var Item, value: int) {.base.} =
  item.pTotalXp = item.minNeededXp(value)
  item.fix

method `==`(a, b: Item): bool {.base.} =
  a.kind == b.kind and
  a.pTotalXp == b.pTotalXp and
  a.pNextXp == b.pNextXp and
  a.pTier == b.pTier and
  a.damaged == b.damaged and
  a.properties == b.properties

# ─── INVENTORY ITEM ─────────────────────────────────────────────────────────────

proc initInventoryItemXp*(
    kind: ItemKind,
    count: int = 1,
    totalXp: int = 0,
    damaged: bool = false,
    properties: Table[PropertyKind, string] = initTable[PropertyKind, string]()
  ): InventoryItem =
  result.kind = kind
  result.count = count
  result.totalXp = totalXp
  result.damaged = damaged
  result.properties = properties

proc initInventoryItemTier*(
    kind: ItemKind,
    count: int = 1,
    tier: int = 1,
    damaged: bool = false,
    properties: Table[PropertyKind, string] = initTable[PropertyKind, string]()
  ): InventoryItem =
  result.kind = kind
  result.count = count
  result.tier = tier
  result.damaged = damaged
  result.properties = properties

proc combine*(a: var InventoryItem, b: InventoryItem) =
  if a != b:
    raise newException(ValueError, "values are not equal")
  a.count += b.count

proc combine*(a: InventoryItem, b: InventoryItem): InventoryItem =
  result = a
  result.combine b

# ─── INVENTORY ──────────────────────────────────────────────────────────────────

proc deduplicate*(sq: Inventory): Inventory =
  if sq.len > 0:
    for itm in items(sq):
      let dup = result.find(itm)
      if dup == -1:
        result.add(itm)
      else:
        result[dup].combine(itm)

proc addItem*(sq: var Inventory, val: InventoryItem) =
  let dup = sq.find val
  if dup != -1:
    sq[dup].combine val
  else:
    sq.add val

# ─── PLAYER DATA ────────────────────────────────────────────────────────────────

# Empty as of now

#
# ──────────────────────────────────────────────────────────── II ──────────
#   :::::: C O N V E R T E R S : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────────
#

# ─── TO STRING ──────────────────────────────────────────────────────────────────

proc toSaveString*(properties: Table[PropertyKind, string]): string =
  var sortedProps = toSeq(properties.pairs)
  sortedProps.sort do (x, y: (PropertyKind, string)) -> int:
    cmp(x[0], y[0])
  let stringProps = sortedProps.map do (it: (PropertyKind, string)) -> string:
    "·" & $it[0].int & ":" & it[1]
  stringProps.join("|")

proc toSaveString*(item: InventoryItem): string =
  let stringProps = block:
    if item.properties.len > 0:
      "|" & item.properties.toSaveString
    else:
      ""
  result = "|" & [
      "§" & $item.kind.int,
      $item.pXp,
      $item.pTotalXp,
      $item.pNextXp,
      $(item.pTier - 1),
      (if item.damaged: "1" else: "0")
    ].join("|") & stringProps & "| " & $item.count

proc toSaveString*(items: Inventory): string =
  var convertedItems = items.map(toSaveString)
  result = convertedItems.join(" ") & " "

# ─── FROM STRING ────────────────────────────────────────────────────────────────

proc parseItem(s: string): Item =
  # example:
  # |§0|0|8|16|1|0|·16:9|·17:24|
  let splitItemProperties = s.split('|')[1..^2]
  # §, ¦, ·, ° is 2 bytes
  result.kind = block:
    let
      portion = splitItemProperties[0]
      discriminator = portion[0..1]
    if discriminator == "§":
      portion[2..^1].parseInt.ItemKind
    elif discriminator == "¦":
      parseEnum[ItemKind](portion[2..^1])
    else:
      raise newException(ValueError, "invalid discriminator")
  result.pXp = splitItemProperties[1].parseInt
  result.pTotalXp = splitItemProperties[2].parseInt
  result.pNextXp = splitItemProperties[3].parseInt
  result.pTier = splitItemProperties[4].parseInt + 1
  result.damaged = splitItemProperties[5].parseBool
  result.properties = (splitItemProperties.filterIt(it.len > 2)
      .mapIt(it[2..^1].split(":"))
      .map do (it: seq[string]) -> (PropertyKind, string):
        let
          portion = it[0]
          discriminator = portion[0..1]
        if discriminator == "·":
          (portion[2..^1].parseInt.PropertyKind, it[1])
        elif discriminator == "°":
          (parseEnum[PropertyKind](portion[2..^1]), it[1])
        else:
          raise newException(ValueError, "invalid discriminator")
    ).toTable

proc parseInventoryItem*(s: string): InventoryItem =
  let splitItem = s.split()
  result = splitItem[0].parseItem().InventoryItem
  result.count = splitItem[1].parseInt

  # let generated = initInventoryItemXp(result.kind, result.count,
  #     result.pTotalXp, result.damaged, result.properties)
  # if generated != result:
  #   echo "save issue found:"
  #   echo "  generated = " & $generated
  #   echo "  from save = " & $result

proc parseInventory*(s: string): Inventory =
  var rawItems = s.replace(re"( \d+) ", "$1\n").splitLines().filterIt(it != "")
  result = rawItems.map(parseInventoryItem)

proc parsePlayerData(s: string): PlayerData =
  # FIXME: naming style
  # FIXME: incomplete
  discard
  let inputArray = s.splitDouble(" ", "|")
  var counter = 0
  var data: Table[string, string]
  for sq in inputArray:
    discard

proc parsePlayer*(s: string): Player =
  # FIXME: incomplete
  let splitData = s.split(" & ")
  result.data = splitData[0]
  result.schematic = splitData[1]

# ─── JSON ───────────────────────────────────────────────────────────────────────

proc `%`*[T](table: Table[enum, T]|OrderedTable[enum, T]): JsonNode =
  result = newJObject()
  for k, v in table: result[$k] = %v

proc `%`*(o: InventoryItem): JsonNode =
  result = newJObject()
  for k, v in o.fieldPairs:
    if not (k.startsWith("p") and k[1].isUpperAscii):
      result[k] = %v
  result["totalXp"] = %o.pTotalXp
