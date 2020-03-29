# TODO: load from version.txt perhaps?
type
  PropertyKind* = enum
    rarity = 0
    `ref`
    name
    description
    layer
    colossal
    class
    subclass
    attachable
    upgradeable
    forgeable
    dropable
    indestructible
    event
    clickAction
    sprite
    value
    health
    mass
    durability
    dodgeChance
    consumableCheck
    consumableAction
    consumableObject
    keybindAmount
    keybindDefault
    activationType
    activationSound
    activationDefault
    activationHidden
    shieldGeneration
    shieldCooldown
    shieldMax
    shieldOverload
    energyGeneration
    energyCooldown
    energyMax
    thrustUpward
    thrustHorizontal
    thrustDownward
    thrustCooldown
    damageType
    weaponCooldown
    recoil
    critChance
    damageImpact
    energyUse
    shotAmount
    volleyAmount
    volleyDelay
    spread
    ammunitionGeneration
    ammunitionCooldown
    ammunitionUse
    ammunitionMax
    projectileName
    projectileSprite
    projectileSound
    projectileBehavior
    projectileHealth
    projectileRange
    projectileLife
    projectileKnockback
    damage
    damageDecrease
    damagePenetration
    damageShield
    damageShieldPierce
    damageAbsorb
    damageDeflect
    projectileVelocityInitial
    projectileVelocityFinal
    projectileAcceleration
    projectileVelocityRelative
    projectileRotationInitial
    projectileRotationFinal
    projectileRotationAcceleration
    projectileGravity
    homingRotationSpeed
    homingSpread
    projectileAttractRadius
    projectileAttractForce
    waveAmplitude
    waveFrequency
    secondaryDamage
    secondaryHealth
    secondaryRange
    secondaryShotAmount
    secondarySpread
    rotationTargeting
    rotationSpeed
    rotationAxis
    rotationSpread
    healingAmount
    healingCooldown
    attractRadius
    attractForce
    rangeTrigger
    effectTrail
    effectColor
    effectExplode
    effectAlphaDelta
    effectRandomRotation
    effectRandomFlip
    effectAnimated
    effectMuzzleFlashType
    effectMuzzleOffset
    effectMuzzleOffsetDelta
  ItemKind* = enum
    # blocks
    sand = 0                # sand
    silt                    # silt
    dirt                    # dirt
    compressed_dirt         # compressed dirt
    grass                   # grass
    mudstone                # mudstone
    clay                    # clay
    cloud                   # cloud
    gravel                  # gravel
    leaves                  # leaves
    cobblestone             # cobblestone
    stone                   # stone
    quartz                  # quartz
    sandstone               # sandstone
    marble                  # marble
    limestone               # limestone
    aetherium               # aetherium
    obsidian_light          # light obsidian
    cloud_dense             # dense cloud
    evergrowth              # evergrowth
    granite                 # granite
    crystal                 # crystal
    obsidian                # obsidian
    arcnite                 # arcnite
    darkstone               # darkstone
    molten_rock             # molten rock
    magmium                 # magmium
    aerogel                 # aerogel
                            # special?
    core                    # core
    floatron_basic          # basic floatron
    floatron_advanced       # advanced floatron
    floatron_complex        # complex floatron
    floatron_ultimate       # ultimate floatron
    drifter_basic           # basic drifter
    drifter_advanced        # advanced drifter
    drifter_complex         # complex drifter
    drifter_ultimate        # ultimate drifter
    slammeron_basic         # basic slammeron
    slammeron_advanced      # advanced slammeron
    slammeron_complex       # complex slammeron
    reactor_basic           # basic reactor
    reactor_advanced        # advanced reactor
    reactor_complex         # complex reactor
    battery_basic           # basic battery
    battery_advanced        # advanced battery
    battery_complex         # complex battery
    armor_basic             # basic armor
    armor_advanced          # advanced armor
    armor_complex           # complex armor
    electromagnet           # electromagnet
    electrowreath           # electrowreath
    shield_basic            # basic shield generator
    shield_advanced         # advanced shield generator
    shield_complex          # complex shield generator
    shieldstone_basic       # basic shieldstone
    shieldstone_advanced    # advanced shieldstone
    shieldstone_complex     # complex shieldstone
    shield_ultimate         # ultimate shield generator
                            # buildings
    tree_bush               # bush
    tree_lantern            # jack-o-lantern
    tree_palm               # palm tree
    snowman                 # snowman
    tree_spruce             # spruce tree
    tree_christmas          # christmas tree
    tree_oak                # oak tree
    balloon                 # balloon
    pyramid                 # pyramid
    mount                   # module mount
    forge                   # forge
    house                   # house
    farm                    # farm
    windmill                # windmill
    shop                    # shop
                            # weapons
    cannon                  # cannon
    quickshot               # quickshot
    dualshot                # dualshot
    quadshot                # quadshot
    minicannon              # mini cannon
    megacannon              # mega cannon
    microcannon             # micro cannon
    ternion                 # ternion
    machinegun              # machine gun
    gatling                 # gatling gun
    spreadgun               # spreadgun
    shotgun                 # shotgun
    shotgun_dual            # double-barrelled shotgun
    mortar                  # mortar
    mortar_dual             # dual mortar
    grenador                # grenador
    crystor                 # crystor
    flare                   # flare
    superflare              # superflare
    gigaflare               # gigaflare
    rocket                  # rocket
    rocket_dual             # dual rocket
    monorocket              # monorocket
    missile_swarm           # swarm missiles
    missile_blitz           # blitz missiles
    missile_barrage         # barrage missiles
    missile_annihilator     # annihilator missiles
    missile_obliterator     # obliterator missiles
    crystaling              # crystaling
    crystacle               # crystacle
    zephyr                  # zephyr
    gustin                  # gustin
    spyke                   # spyke
    spyke_dual              # dual spykes
    spyke_uber              # uber spyke
    laser                   # laser
    laser_dual              # dual laser
    turbolaser              # turbolaser
    gravitor                # gravitor
    plasma                  # plasma
    plasma_dual             # dual plasma
    ionodriver              # ionodriver
    ionopiercer             # ionopiercer
    ionocleaver             # ionocleaver
    autolaser               # autolaser
    autolaser_heavy         # heavy autolaser
    beamgun                 # beamgun
    railgun                 # railgun
    railgun_colossal        # colossal railgun
                            # tech
    propulsor_basic         # basic propulsor
    propulsor_advanced      # advanced propulsor
    propulsor_complex       # complex propulsor
    accelerator_basic       # basic accelerator
    accelerator_advanced    # advanced accelerator
    accelerator_complex     # complex accelerator
    reinforcement_basic     # basic reinforcement
    reinforcement_advanced  # advanced reinforcement
    reinforcement_complex   # complex reinforcement
    antimatter_basic        # basic antimatter capsule
    antimatter_advanced     # advanced antimatter capsule
    antimatter_complex      # complex antimatter capsule
    ultramplifier_basic     # basic ultramplifier
    ultramplifier_advanced  # advanced ultramplifier
    ultramplifier_complex   # complex ultramplifier
    firepower_basic         # basic firepower
    firepower_advanced      # advanced firepower
    firepower_complex       # complex firepower
    nuclearizer_basic       # basic nuclearizer
    nuclearizer_advanced    # advanced nuclearizer
    nuclearizer_complex     # complex nuclearizer
    supercapacitor_basic    # basic supercapacitor
    supercapacitor_advanced # advanced supercapacitor
    supercapacitor_complex  # complex supercapacitor
    augmentator_basic       # basic augmentator
    augmentator_advanced    # advanced augmentator
    augmentator_complex     # complex augmentator
    barrel_extender         # barrel extender
    barrel_choke            # barrel choke
    barrel_suppressor       # barrel suppresor
    barrel_piercer          # barrel piercer
    laser_trigger           # laser trigger
    surge_protector         # surge protector
    turbocharger            # turbocharger
    servo                   # servo
    energy_cycler           # energy cycler
    regenerator             # regenerator
    ammunition_box          # ammunition box
    shock_absorber          # shock absorber
    reinforced_bullet       # reinforced bullet
    targeting_system        # targeting system
    rocket_propellant       # rocket propellant
    disruptor               # disruptor
    aileron                 # aileron
                            # keys
    warp_key                # warp key
    realm_key               # realm key

    scrap                   # scrap
    consume                 # consumable test

  PropertyInfo = object
    max: int
    min: int
    class: string
    subclass: string

template `[]=`[T](a: openArray[T], i: ItemKind or PropertyKind, v: T) = a[i.int] = v
template `[]`*[T](a: openArray[T], i: ItemKind or PropertyKind): T = a[i.int]
var itemProperty*: array[PropertyKind.high.int+1, array[ItemKind.high.int+1, int]]
var itemPropertyInfo*: array[PropertyKind.high.int+1, PropertyInfo]
block:
  itemProperty[value][marble] = 52
  itemProperty[value][flare] = 25
  itemProperty[value][gravel] = 32
  itemProperty[value][monorocket] = 80
  itemProperty[value][warp_key] = 80
  itemProperty[value][spyke] = 15
  itemProperty[value][armor_complex] = 60
  itemProperty[value][quickshot] = 25
  itemProperty[value][mudstone] = 24
  itemProperty[value][crystor] = 80
  itemProperty[value][laser_dual] = 60
  itemProperty[value][grass] = 20
  itemProperty[value][battery_basic] = 25
  itemProperty[value][quartz] = 44
  itemProperty[value][ammunition_box] = 40
  itemProperty[value][tree_palm] = 25
  itemProperty[value][grenador] = 60
  itemProperty[value][tree_spruce] = 40
  itemProperty[value][mortar_dual] = 40
  itemProperty[value][nuclearizer_basic] = 25
  itemProperty[value][firepower_basic] = 40
  itemProperty[value][slammeron_complex] = 60
  itemProperty[value][reactor_advanced] = 40
  itemProperty[value][reinforcement_complex] = 80
  itemProperty[value][shotgun] = 40
  itemProperty[value][realm_key] = 80
  itemProperty[value][barrel_suppressor] = 25
  itemProperty[value][magmium] = 82
  itemProperty[value][autolaser] = 60
  itemProperty[value][crystacle] = 80
  itemProperty[value][windmill] = 1000
  itemProperty[value][mortar] = 25
  itemProperty[value][cloud] = 30
  itemProperty[value][minicannon] = 40
  itemProperty[value][missile_blitz] = 40
  itemProperty[value][plasma_dual] = 80
  itemProperty[value][ultramplifier_basic] = 25
  itemProperty[value][microcannon] = 100
  itemProperty[value][propulsor_advanced] = 25
  itemProperty[value][laser] = 40
  itemProperty[value][clay] = 28
  itemProperty[value][shield_advanced] = 40
  itemProperty[value][tree_christmas] = 40
  itemProperty[value][aileron] = 25
  itemProperty[value][missile_barrage] = 60
  itemProperty[value][drifter_basic] = 15
  itemProperty[value][arcnite] = 80
  itemProperty[value][railgun_colossal] = 100
  itemProperty[value][shock_absorber] = 40
  itemProperty[value][crystaling] = 60
  itemProperty[value][dirt] = 16
  itemProperty[value][servo] = 60
  itemProperty[value][shield_ultimate] = 100
  itemProperty[value][autolaser_heavy] = 80
  itemProperty[value][gustin] = 40
  itemProperty[value][dualshot] = 40
  itemProperty[value][augmentator_basic] = 80
  itemProperty[value][compressed_dirt] = 18
  itemProperty[value][antimatter_basic] = 25
  itemProperty[value][ternion] = 15
  itemProperty[value][obsidian] = 72
  itemProperty[value][shop] = 1000
  itemProperty[value][ionocleaver] = 80
  itemProperty[value][augmentator_advanced] = 100
  itemProperty[value][energy_cycler] = 40
  itemProperty[value][house] = 1000
  itemProperty[value][supercapacitor_complex] = 60
  itemProperty[value][laser_trigger] = 25
  itemProperty[value][reinforcement_advanced] = 40
  itemProperty[value][shieldstone_complex] = 60
  itemProperty[value][granite] = 70
  itemProperty[value][propulsor_complex] = 60
  itemProperty[value][evergrowth] = 65
  itemProperty[value][ionopiercer] = 40
  itemProperty[value][reinforcement_basic] = 25
  itemProperty[value][drifter_complex] = 60
  itemProperty[value][zephyr] = 25
  itemProperty[value][snowman] = 25
  itemProperty[value][slammeron_basic] = 25
  itemProperty[value][balloon] = 25
  itemProperty[value][darkstone] = 75
  itemProperty[value][superflare] = 40
  itemProperty[value][nuclearizer_complex] = 60
  itemProperty[value][shield_complex] = 60
  itemProperty[value][megacannon] = 80
  itemProperty[value][accelerator_advanced] = 60
  itemProperty[value][cannon] = 15
  itemProperty[value][ultramplifier_advanced] = 40
  itemProperty[value][missile_swarm] = 25
  itemProperty[value][cobblestone] = 36
  itemProperty[value][reactor_basic] = 25
  itemProperty[value][antimatter_advanced] = 40
  itemProperty[value][spyke_uber] = 60
  itemProperty[value][shieldstone_advanced] = 40
  itemProperty[value][limestone] = 56
  itemProperty[value][turbolaser] = 80
  itemProperty[value][firepower_advanced] = 60
  itemProperty[value][drifter_advanced] = 40
  itemProperty[value][ultramplifier_complex] = 80
  itemProperty[value][plasma] = 60
  itemProperty[value][leaves] = 36
  itemProperty[value][supercapacitor_advanced] = 40
  itemProperty[value][shieldstone_basic] = 25
  itemProperty[value][rocket_dual] = 60
  itemProperty[value][electromagnet] = 40
  itemProperty[value][sandstone] = 48
  itemProperty[value][battery_complex] = 60
  itemProperty[value][shotgun_dual] = 60
  itemProperty[value][armor_advanced] = 40
  itemProperty[value][floatron_ultimate] = 100
  itemProperty[value][silt] = 10
  itemProperty[value][core] = 100
  itemProperty[value][machinegun] = 40
  itemProperty[value][railgun] = 80
  itemProperty[value][barrel_choke] = 25
  itemProperty[value][aetherium] = 60
  itemProperty[value][pyramid] = 80
  itemProperty[value][tree_bush] = 15
  itemProperty[value][ionodriver] = 25
  itemProperty[value][supercapacitor_basic] = 25
  itemProperty[value][farm] = 1000
  itemProperty[value][accelerator_complex] = 80
  itemProperty[value][quadshot] = 60
  itemProperty[value][disruptor] = 40
  itemProperty[value][rocket_propellant] = 25
  itemProperty[value][armor_basic] = 15
  itemProperty[value][accelerator_basic] = 40
  itemProperty[value][molten_rock] = 85
  itemProperty[value][reactor_complex] = 60
  itemProperty[value][barrel_piercer] = 40
  itemProperty[value][turbocharger] = 40
  itemProperty[value][regenerator] = 60
  itemProperty[value][battery_advanced] = 40
  itemProperty[value][beamgun] = 60
  itemProperty[value][floatron_advanced] = 40
  itemProperty[value][forge] = 1000
  itemProperty[value][stone] = 40
  itemProperty[value][surge_protector] = 40
  itemProperty[value][shield_basic] = 25
  itemProperty[value][nuclearizer_advanced] = 40
  itemProperty[value][missile_annihilator] = 80
  itemProperty[value][spreadgun] = 25
  itemProperty[value][gigaflare] = 100
  itemProperty[value][gravitor] = 80
  itemProperty[value][firepower_complex] = 80
  itemProperty[value][reinforced_bullet] = 60
  itemProperty[value][gatling] = 60
  itemProperty[value][electrowreath] = 40
  itemProperty[value][targeting_system] = 60
  itemProperty[value][rocket] = 40
  itemProperty[value][propulsor_basic] = 15
  itemProperty[value][crystal] = 65
  itemProperty[value][slammeron_advanced] = 40
  itemProperty[value][antimatter_complex] = 60
  itemProperty[value][spyke_dual] = 40
  itemProperty[value][obsidian_light] = 72
  itemProperty[value][drifter_ultimate] = 100
  itemProperty[value][floatron_complex] = 60
  itemProperty[value][sand] = 8
  itemProperty[value][floatron_basic] = 15
  itemProperty[value][cloud_dense] = 62
  itemProperty[value][tree_lantern] = 15
  itemProperty[value][tree_oak] = 60
  itemProperty[value][missile_obliterator] = 100
  itemProperty[value][barrel_extender] = 25
  itemProperty[value][aerogel] = 100
  itemProperty[value][mount] = 25
  itemProperty[value][augmentator_complex] = 120

block:
  discard
