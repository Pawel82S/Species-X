extends Resource
# Galaxy names taken from "https://www.fantasynamegenerators.com/galaxy-names.php"
const DEFAULT_GALAXY_NAMES = [ "A-944",
	"AFW 6G",
	"AS-51",
	"AY-86",
	"Acorn Galaxy",
	"Acorn Star System",
	"Aegialeus Nebula",
	"Aegialeus Star System",
	"Aegimius Galaxy",
	"Aldebaran Galaxy",
	"Alpha Achelois",
	"Alpha Centauri",
	"Alpha Majoris",
	"Alpha Palioxis",
	"Amphiaraus Galaxy",
	"Anadeia Star System",
	"Apus Calesius",
	"Ara Icarius",
	"Ara Kentaurus",
	"Ara Proioxis",
	"Aurigae Nebula",
	"BGE 30A",
	"BU-32",
	"Banana Star System",
	"Beansprout Cloud",
	"Beansprout Nebula",
	"Beanstalk Star System",
	"Bell Nebula",
	"Bell Star System",
	"Beta Capella",
	"Beta Euthenia",
	"Blue Ribbon Galaxy",
	"Blue Ribbon Star System",
	"Blueberry Cloud",
	"Boreas Cloud",
	"Bowl Nebula",
	"CJ-865",
	"Canis Astraeus",
	"Cassiopeia Star System",
	"Catterpillar Nebula",
	"Centaurus Nebula",
	"Coconut Galaxy",
	"Comae Cassiopeia",
	"Comae Majoris",
	"Corona Odysseus",
	"Crescent Star System",
	"Crow's Feet Star System",
	"Crux Aegimius",
	"Crux Zephyrus",
	"Cymopoleia Galaxy",
	"Cymopoleia Nebula",
	"Delta Ophiuchi",
	"Delta Orion",
	"Draco Nebula",
	"Draco Proioxis",
	"Draconis Cloud",
	"ECY 66G",
	"EX-678",
	"Eagle Claw Nebula",
	"Eggshell Galaxy",
	"Eioneus Galaxy",
	"Eioneus Star System",
	"Epsilon Asteria",
	"Epsilon Euphorion",
	"Eridani Nebula",
	"Eridanus Galaxy",
	"Eridanus Nebula",
	"FBZ 62C",
	"FDK 88I",
	"FV-705",
	"FZB 21B",
	"Falling Star System",
	"Fisheye Star System",
	"Football Nebula",
	"GA-9",
	"GHT 6G",
	"Gamma Acallaris",
	"Gamma Anadeia",
	"Gamma Boreas",
	"Gamma Nebula",
	"Grain Cloud",
	"HK 89J",
	"Heart Galaxy",
	"Horseshoe Galaxy",
	"Horseshoe Nebula",
	"Hurricane Star System",
	"Hyperes Cloud",
	"Hyperion Star System",
	"IKC 93D",
	"IS-919",
	"IS-968",
	"IV-73",
	"Icarius Nebula",
	"Ichnaea Nebula",
	"Icicle Nebula",
	"JTD 0K",
	"Jellyfish Star System",
	"Kettle Cloud",
	"LF-093",
	"Lambda Aldebaran",
	"Leaf Cloud",
	"Leaf Nebula",
	"Leporis Cloud",
	"Leporis Star System",
	"Librae Nebula",
	"Librae Star System",
	"Lilypad Star System",
	"Lyra Borysthenis",
	"Lyra Centauri",
	"Lyra Cymopoleia",
	"Lyrae",
	"Lyrae Nebula",
	"MHO 96G",
	"MT-599",
	"MV-603",
	"Meridian Galaxy",
	"Miriandynus",
	"Miriandynus Star System",
	"Myrmidon Galaxy",
	"NHV 57H",
	"NP-830",
	"OE-19",
	"OY-425",
	"Octopus Star System",
	"Omega Aegialeus",
	"Omega Orionis",
	"Omicron Chronos",
	"Omicron Ophiuchi",
	"Omicron Orion",
	"Ophiuchi Galaxy",
	"Owl Head Star System",
	"PNS 59J",
	"PZR 26G",
	"Pavo Perileos",
	"Pavo Sirius",
	"Pavo Solymus",
	"Pinecone Galaxy",
	"Porphyrion Galaxy",
	"Potato Galaxy",
	"Proioxis",
	"Proioxis Galaxy",
	"Proxima Aurigae",
	"QRI 7H",
	"RL-830",
	"Red Ribbon Star System",
	"Rose Petal Cloud",
	"Rose Petal Nebula",
	"Sagitta Alcyoneus",
	"Sagitta Amphiaraus",
	"Sagitta Aurigae",
	"Sagitta Hemithea",
	"Sagitta Palioxis",
	"Sagittarius Nebula",
	"Sawblade Cloud",
	"Serpens Icarius",
	"Serpens Orionis",
	"Serpens Polystratus",
	"Sharkfin Nebula",
	"Sharktooth Cloud",
	"Shooting Star Nebula",
	"Sigma Orionis",
	"Sirius Cloud",
	"Sirius Nebula",
	"Snowflake Nebula",
	"Soap Bubble Star System",
	"Solymus Star System",
	"Spearpoint Nebula",
	"Spiderleg Cloud",
	"Spiderweb Nebula",
	"Spiderweb Star System",
	"Spiral Star System",
	"TLQ 42C",
	"Teacup Cloud",
	"Theta Amphiaraus",
	"Theta Eusebeia",
	"Tree Root Star System",
	"Tree Trunk Galaxy",
	"UCD 1B",
	"VBK 31B",
	"VEB 43D",
	"Vela Calesius",
	"Vela Nebula",
	"Vela Orion",
	"Virgo Librae",
	"Vortex Nebula",
	"Vortex Star System",
	"Whale's Tail Nebula",
	"YV-575",
	"ZB-253",
	"ZNJ 30A",
	"Zagreus Cloud",
	"Zagreus Galaxy",
	"Zeta Orion",
	"Zeta Phoroneus",
	"Zodiac Galaxy" ]


func GetRandomName() -> String:
	return DEFAULT_GALAXY_NAMES[randi() % DEFAULT_GALAXY_NAMES.size()]
