import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSeedService {
  static final _db = FirebaseFirestore.instance.collection('products');

  static const List<Map<String, dynamic>> _products = [
    // ── PHONES ──────────────────────────────────────────────────────────────
    {
      'productId': 'iphone-15-pro-max-256gb',
      'productTitle': 'Apple iPhone 15 Pro Max (256GB) - Natural Titanium',
      'productPrice': '1199.99',
      'productCategory': 'Phones',
      'productDescription':
          'The iPhone 15 Pro Max features a titanium design with a textured matte-glass back. It\'s the first iPhone to offer a 5x Optical zoom. The 48 MP Main camera has a larger sensor and records 4K ProRes video at 60 fps. Dynamic Island: A versatile pill-shaped region on the display that adapts to notifications and activities. A17 Pro chip with 6-core CPU and 6-core GPU. Always-On display (2796×1290 resolution at 460 ppi). Action Button for quick access to features. USB 3 speeds with USB-C. Up to 29 hours video playback.',
      'productImage':
          'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=800&q=80',
      'productQuantity': '500',
    },
    {
      'productId': 'samsung-galaxy-s24-ultra',
      'productTitle': 'Samsung Galaxy S24 Ultra 512GB - Titanium Black',
      'productPrice': '1299.00',
      'productCategory': 'Phones',
      'productDescription':
          'Galaxy S24 Ultra is the ultimate AI smart­phone experience. World\'s first 200MP adaptive pixel sensor with four times zoom resolutions. Integrated S Pen with zero latency for precise control. 6.8" QHD+ Dynamic AMOLED 2X with 2600 nits peak brightness. Snapdragon 8 Gen 3 for Galaxy. 5000mAh battery with 45W fast charging. Titanium frame with Corning Gorilla Glass Armor. Wi-Fi 7, Bluetooth 5.3, NFC. Android 14 with Galaxy AI features including real-time interpretation and Circle to Search.',
      'productImage':
          'https://images.unsplash.com/photo-1706193869023-f39e8d4ed0bb?w=800&q=80',
      'productQuantity': '320',
    },
    {
      'productId': 'google-pixel-9-pro',
      'productTitle': 'Google Pixel 9 Pro 256GB - Obsidian',
      'productPrice': '999.00',
      'productCategory': 'Phones',
      'productDescription':
          'Google Pixel 9 Pro is built with Google AI at its core. Features a 50 MP wide + 48 MP ultrawide + 48 MP telephoto triple rear camera system. The new Tensor G4 chip powers real-time AI features including Magic Eraser, Photo Unblur, and Best Take. 6.3" LTPO OLED with 120Hz adaptive refresh. 4700mAh battery. Titan M2 security chip. 7 years of OS updates. 24 GB RAM. Temperature sensor. Weather-resistant IP68.',
      'productImage':
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800&q=80',
      'productQuantity': '210',
    },
    {
      'productId': 'oneplus-12-256gb',
      'productTitle': 'OnePlus 12 5G 256GB - Flowy Emerald',
      'productPrice': '799.00',
      'productCategory': 'Phones',
      'productDescription':
          'The OnePlus 12 features Hasselblad-tuned cameras and Snapdragon 8 Gen 3 processor. 50MP Main (Sony LYT-808) + 64 MP periscope telephoto + 48MP ultrawide. 6.82" ProXDR Display with 2K resolution and 120Hz. 5400mAh battery with 100W SUPERVOOC fast charging and 50W wireless. 24 GB RAM + 256GB storage. OxygenOS 14 based on Android 14. IP65 dust and water resistant. Dolby Atmos speakers.',
      'productImage':
          'https://images.unsplash.com/photo-1585060544812-6b45742d762f?w=800&q=80',
      'productQuantity': '180',
    },
    {
      'productId': 'xiaomi-14-ultra',
      'productTitle': 'Xiaomi 14 Ultra 512GB - Black - Global Version',
      'productPrice': '1099.00',
      'productCategory': 'Phones',
      'productDescription':
          'Xiaomi 14 Ultra co-engineered with Leica. Quad camera system: 50MP Main (LYT-900, 1-inch sensor) + 50MP ultrawide + 50MP 3.2× telephoto + 50MP 5× periscope. Variable aperture from f/1.63 to f/4.0. Snapdragon 8 Gen 3. 6.73" LTPO AMOLED 120Hz. 5300mAh battery with 90W wired + 80W wireless. IP68 water resistance. Aluminum frame with ceramic back.',
      'productImage':
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800&q=80',
      'productQuantity': '95',
    },

    // ── LAPTOPS ─────────────────────────────────────────────────────────────
    {
      'productId': 'macbook-pro-16-m3-pro',
      'productTitle': 'Apple MacBook Pro 16" M3 Pro - Space Black',
      'productPrice': '2499.00',
      'productCategory': 'Laptops',
      'productDescription':
          'MacBook Pro with M3 Pro chip delivers exceptional performance for demanding professional workflows. 12-core CPU, 18-core GPU, 36GB unified memory, 512GB SSD. 16.2" Liquid Retina XDR display with ProMotion (3456×2234, up to 120Hz). Up to 18 hours battery life. Six-speaker sound system with Spatial Audio. Three Thunderbolt 4 ports + HDMI + SD card slot + MagSafe 3. Space Black finish with anodization seal. 1080p FaceTime camera.',
      'productImage':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
      'productQuantity': '75',
    },
    {
      'productId': 'dell-xps-15-9530',
      'productTitle': 'Dell XPS 15 9530 - Intel Core i9 - RTX 4070',
      'productPrice': '2199.99',
      'productCategory': 'Laptops',
      'productDescription':
          'Dell XPS 15 features a stunning 15.6" OLED touch display (3456×2160, 60Hz, 400 nits). Intel Core i9-13900H (up to 5.4GHz, 24 core). NVIDIA GeForce RTX 4070 8GB GDDR6. 64GB DDR5 RAM, 2TB NVMe SSD. Thunderbolt 4, USB-C, SD card reader. 86Wh battery. Premium machined aluminum chassis. Windows 11 Pro. Killer Wi-Fi 6E. Excellent for creative pros and gamers.',
      'productImage':
          'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800&q=80',
      'productQuantity': '60',
    },
    {
      'productId': 'asus-rog-zephyrus-g16',
      'productTitle': 'ASUS ROG Zephyrus G16 - Ryzen 9 - RTX 4080',
      'productPrice': '2799.00',
      'productCategory': 'Laptops',
      'productDescription':
          'ROG Zephyrus G16 is the ultimate ultra-slim gaming laptop. AMD Ryzen 9 8945H (up to 5.2GHz). NVIDIA GeForce RTX 4090 16GB GDDR6. 32GB DDR5-7500 RAM, 1TB PCIe 4.0 SSD. 16" ROG Nebula HDR display (2560×1600, 240Hz, MUX Switch, Dolby Vision). ROG Intelligent Cooling with liquid metal. Six-speaker system with Dolby Atmos. Per-key RGB keyboard. 90Wh battery. MIL-SPEC tested.',
      'productImage':
          'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80',
      'productQuantity': '45',
    },
    {
      'productId': 'hp-spectre-x360-14',
      'productTitle': 'HP Spectre x360 14" 2-in-1 Laptop - Intel Evo',
      'productPrice': '1649.00',
      'productCategory': 'Laptops',
      'productDescription':
          'HP Spectre x360 14 is a premium 2-in-1 with Intel Core Ultra 7 processor (Intel Evo certified). 13.5" 2.8K OLED touch display (2880×1920, 120Hz, 400 nits, VESA DisplayHDR True Black 500). Intel Arc Graphics. 32GB LPDDR5 RAM, 2TB PCIe 4.0 SSD. Gem-cut aluminum chassis. Tile tracker built-in. HP Sure View Reflect privacy screen. Windows 11 Pro. 2×Thunderbolt 4, USB-A, MicroSD, headphone jack. OLED HP pen included.',
      'productImage':
          'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&q=80',
      'productQuantity': '88',
    },

    // ── WATCHES ─────────────────────────────────────────────────────────────
    {
      'productId': 'apple-watch-series-9-45mm',
      'productTitle': 'Apple Watch Series 9 GPS 45mm - Midnight Aluminum',
      'productPrice': '429.00',
      'productCategory': 'Watches',
      'productDescription':
          'Apple Watch Series 9 features the new S9 SiP chip with 4-core neural engine. The new Double Tap gesture lets you control your Watch without touching the display. 2000 nits peak brightness — 2× brighter than Series 8. On-device Siri processing. Advanced sensors: electrical heart sensor, blood oxygen, temperature sensing. Crash Detection, Emergency SOS via satellite, Fall Detection. 45mm Retina always-on display. Up to 18 hours battery life. IP6X dust resistant, WR50 water resistant. Carbon neutral.',
      'productImage':
          'https://images.unsplash.com/photo-1551816230-ef5deaed4a26?w=800&q=80',
      'productQuantity': '300',
    },
    {
      'productId': 'samsung-galaxy-watch-6-classic',
      'productTitle': 'Samsung Galaxy Watch 6 Classic 47mm - Black',
      'productPrice': '399.99',
      'productCategory': 'Watches',
      'productDescription':
          'Galaxy Watch 6 Classic brings back the iconic rotating bezel in a refined design. Advanced health tracking with BioActive Sensor: body composition, ECG, blood pressure monitoring. Sleep coaching with 6-stage sleep analysis. Advanced workout tracking for 90+ exercise types. Google Wear OS 5 with One UI Watch 5. AMOLED display (480×480) with Sapphire Crystal glass. 5ATM + IP68 + MIL-SPEC 810H rated. 40 hours battery life (Power Saving mode up to 30 days).',
      'productImage':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
      'productQuantity': '175',
    },
    {
      'productId': 'garmin-fenix-7-pro',
      'productTitle': 'Garmin Fenix 7 Pro Solar - Sapphire - Carbon Gray',
      'productPrice': '899.99',
      'productCategory': 'Watches',
      'productDescription':
          'Garmin Fēnix 7 Pro Solar is the ultimate multisport GPS watch. Built-in flashlight for low-light workouts. Solar charging lens extends battery life to 37 days. LED underwater flashlight. Multi-band GPS for ultimate accuracy. Advanced training metrics including Training Readiness, HRV Status, and daily workout suggestions. Mountain biking dynamics. Dive app (to 100m). Ski maps and golf maps included. Sapphire crystal lens. Stainless steel bezel. Silicone band.',
      'productImage':
          'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=800&q=80',
      'productQuantity': '90',
    },
    {
      'productId': 'rolex-submariner-date',
      'productTitle': 'Rolex Submariner Date 41mm - Oystersteel - Black',
      'productPrice': '10550.00',
      'productCategory': 'Watches',
      'productDescription':
          'The Rolex Submariner is the archetype of the divers\' watch. A legend in its own right, it is recognized all over the world. The Submariner Date is waterproof to a depth of 300 metres (1,000 feet). Its Cerachrom bezel in ceramic features graduations moulded in the material, which doesn\'t fade, is virtually unscratchable and is resistant to corrosion. The watch is powered by a Perpetual, mechanical, self-winding movement calibre 3235 with Chronergy escapement. 70-hour power reserve. Oystersteel case.',
      'productImage':
          'https://images.unsplash.com/photo-1622818425740-7d6e2c5cbaa6?w=800&q=80',
      'productQuantity': '12',
    },

    // ── SHOES ───────────────────────────────────────────────────────────────
    {
      'productId': 'nike-air-force-1-07-white',
      'productTitle': "Nike Air Force 1 '07 - White/White",
      'productPrice': '110.00',
      'productCategory': 'Shoes',
      'productDescription':
          "The Nike Air Force 1 '07 is the OG basketball shoe that began a revolution in footwear. Debuting in 1982, it was the first basketball shoe to use Nike Air cushioning, which set a new standard for style and comfort. This heritage version includes a full-grain leather upper that adds a premium look and feel. The non-marking rubber sole adds traction and durability. An Air-cushioned midsole provides lightweight, all-day comfort. Padded, low-cut collar for a sleek look and feel. Perforations on the toe add breathability.",
      'productImage':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80',
      'productQuantity': '800',
    },
    {
      'productId': 'adidas-ultraboost-23-black',
      'productTitle': 'Adidas Ultraboost 23 Running Shoes - Core Black',
      'productPrice': '180.00',
      'productCategory': 'Shoes',
      'productDescription':
          'Adidas Ultraboost 23 is engineered for runners who demand the best. The Primeknit+ upper adapts to the foot\'s natural movement for an incredible fit. Linear Energy Push system provides 5% more energy return than previous Ultraboost. BOOST midsole cushioning. Continental rubber outsole for superior traction on wet and dry surfaces. Torsion System for smooth transitions. They\'re built for performance but styled for every day. Available in Extended Sizes.',
      'productImage':
          'https://images.unsplash.com/photo-1608231387042-66d1773d3028?w=800&q=80',
      'productQuantity': '450',
    },
    {
      'productId': 'jordan-1-retro-high-chicago',
      'productTitle': 'Air Jordan 1 Retro High OG - Chicago Reimagined',
      'productPrice': '180.00',
      'productCategory': 'Shoes',
      'productDescription':
          'The Air Jordan 1 Retro High OG pays homage to the original colorway that sparked a revolution. Premium leather upper with perforations at the toe for ventilation. Nike Air-cushioned midsole. Rubber outsole with pivot point for enhanced traction. High-top silhouette with padded collar. Full-length Air-Sole unit. Available in men\'s sizing. Lace closure. Woven label at tongue. Style icon since 1985.',
      'productImage':
          'https://images.unsplash.com/photo-1556906781-9a412961d28e?w=800&q=80',
      'productQuantity': '200',
    },
    {
      'productId': 'new-balance-990v6',
      'productTitle': 'New Balance 990v6 Made in USA - Grey',
      'productPrice': '184.99',
      'productCategory': 'Shoes',
      'productDescription':
          'The New Balance 990v6 is an icon of American running footwear, made in the USA. Crafted with premium pigskin suede upper and mesh overlays for breathability. ENCAP midsole technology combining a soft EVA foam core with a durable polyurethane rim. An ACTEVA LITE cushioning insert round out the underfoot for additional cushioning. Blown rubber sole for traction and durability. Widths available. 30+ year legacy of excellence.',
      'productImage':
          'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=800&q=80',
      'productQuantity': '280',
    },
    {
      'productId': 'birkenstock-arizona-sandals',
      'productTitle': "Birkenstock Arizona Soft Footbed - Tobacco Oiled Leather",
      'productPrice': '139.95',
      'productCategory': 'Shoes',
      'productDescription':
          'The Birkenstock Arizona is one of the brand\'s most iconic sandals. Two adjustable buckle straps for a customizable fit. Upper: Tobacco Oiled Leather — a premium nubuck leather with a natural, matte finish. Anatomically shaped cork-latex footbed molds to the shape of your foot over time. Soft footbed version with additional layer of foam padding. Shock-absorbing EVA outsole. Sizes 35-47. Made in Germany since 1774.',
      'productImage':
          'https://images.unsplash.com/photo-1603487742131-4160ec999306?w=800&q=80',
      'productQuantity': '380',
    },

    // ── CLOTHES ─────────────────────────────────────────────────────────────
    {
      'productId': 'levis-501-original-jeans',
      "productTitle": "Levi's 501 Original Fit Jeans - Medium Stonewash",
      'productPrice': '69.50',
      'productCategory': 'Clothes',
      'productDescription':
          "The iconic Levi's 501 Original Fit Jeans. The original blue jean since 1873. Sit at the waist, straight leg through the hip and thigh. Button fly closure. 100% cotton denim with medium stonewash finish. Straight fit not too baggy, not too slim. Five-pocket styling. Authentic riveted details. Shrink-to-fit option available in select washes. Machine washable. Model wears size 32×32. The world's most-copied jean, reimagined in premium denim.",
      'productImage':
          'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&q=80',
      'productQuantity': '600',
    },
    {
      'productId': 'north-face-nuptse-jacket',
      'productTitle':
          'The North Face Nuptse 1996 Retro Down Jacket - Black',
      'productPrice': '299.00',
      'productCategory': 'Clothes',
      'productDescription':
          "The North Face Nuptse 1996 Retro jacket delivers outstanding warmth in a classic boxy silhouette. 700-fill-power goose down. Water-resistant DWR (durable water repellent) finish. Shell: 100% nylon ripstop. Full zip front with snap placket. Elasticized cuffs and hem. Inner security zip pocket. Stuff sack. The original Nuptse from 1992 was designed to be worn under the Himalayan Suit on summit pushes, so it's inherently compressible and lightweight. Unisex sizing available. Men's Relaxed Fit.",
      'productImage':
          'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&q=80',
      'productQuantity': '150',
    },
    {
      'productId': 'zara-tech-blazer',
      'productTitle': 'Zara Technical Fabric Double-Breasted Blazer',
      'productPrice': '129.00',
      'productCategory': 'Clothes',
      'productDescription':
          'Zara Technical Fabric Double-Breasted Blazer is a modern essential for work and beyond. Double-breasted button-front closure. Long sleeves with button cuffs. Welt pockets at chest. Inner patch pocket. Welt pockets at hip. Technical fabric with a slight stretch for movement and comfort. 60% Polyester, 37% Rayon, 3% Elastane. Lined. Available in Black, Navy, and Beige. Machine washable. Regular fit — model wears 38/M.',
      'productImage':
          'https://images.unsplash.com/photo-1594938298603-7bb29b3a0204?w=800&q=80',
      'productQuantity': '220',
    },
    {
      'productId': 'hm-oversized-tshirt',
      'productTitle': "H&M Oversized Fit T-shirt - White / 5-Pack",
      'productPrice': '34.99',
      'productCategory': 'Clothes',
      'productDescription':
          "H&M 5-pack of oversized fit T-shirts in a classic, casual silhouette. Round neckline, short sleeves, dropped shoulders, and a slightly longer body length. Made from 100% combed cotton jersey, which is soft and breathable. Machine washable. A wardrobe staple that pairs with everything. Pack includes: White, Black, Grey, Navy, and Olive. Sizes: XS–XXL. H&M's cotton products are GOTS certified organic cotton.",
      'productImage':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80',
      'productQuantity': '1200',
    },
    {
      'productId': 'patagonia-down-sweater',
      'productTitle': 'Patagonia Down Sweater Jacket - Smolder Blue',
      'productPrice': '279.00',
      'productCategory': 'Clothes',
      'productDescription':
          "Patagonia's best-selling Down Sweater is a do-it-all jacket with 800-fill-power RDS-certified responsibly sourced goose down. Shell: 100% recycled nylon ripstop with a DWR finish. 2 zipper-closure hand pockets. Zipper-closure interior chest pocket stuffs into itself for convenient storage. Drawcord-adjustable hem. Trim fit. An incredibly lightweight, packable, and warm everyday jacket. Traceable Down Standard certified. Fair Trade facility.",
      'productImage':
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&q=80',
      'productQuantity': '110',
    },

    // ── ELECTRONICS ─────────────────────────────────────────────────────────
    {
      'productId': 'airpods-pro-2nd-gen',
      'productTitle': 'Apple AirPods Pro (2nd generation) with USB-C',
      'productPrice': '249.00',
      'productCategory': 'Electronics',
      'productDescription':
          "AirPods Pro (2nd generation) with USB-C deliver up to 2× more Active Noise Cancellation than the previous generation. Personalized Spatial Audio with dynamic head tracking. Adaptive Audio seamlessly adjusts to the sounds around you. Transparency mode and Conversation Awareness. Swipe control on the stem for volume. H2 chip. Up to 6 hours of listening time with ANC on (up to 30 hours with case). IP54 dust, sweat, and water resistant. Precision Finding, Lost Mode, and Find My compatible. Lossless Audio with Apple Vision Pro.",
      'productImage':
          'https://images.unsplash.com/photo-1588423771073-b8903febb85b?w=800&q=80',
      'productQuantity': '400',
    },
    {
      'productId': 'sony-wh-1000xm5',
      'productTitle': 'Sony WH-1000XM5 Wireless Noise Canceling Headphones - Black',
      'productPrice': '349.99',
      'productCategory': 'Electronics',
      'productDescription':
          "Sony's best noise canceling headphones ever. Industry-leading noise cancellation powered by two processors and eight microphones. Crystal clear hands-free calling thanks to four beam-forming microphones and a bone-conduction sensor. Automatic switching to focus on or cancel sound. Multipoint connection connects to two Bluetooth devices at once. Up to 30-hour battery life with quick charge (3 min charge = 3 hours). Ultra-comfortable and lightweight. Foldable design. Hi-Res Audio certified. LDAC, DSEE Extreme, 360 Reality Audio. Speak-to-Chat auto-pause.",
      'productImage':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80',
      'productQuantity': '260',
    },
    {
      'productId': 'ipad-pro-13-m4',
      'productTitle': 'Apple iPad Pro 13" (M4) - 256GB - Wi-Fi - Space Black',
      'productPrice': '1299.00',
      'productCategory': 'Electronics',
      'productDescription':
          "The new iPad Pro with M4 chip is the thinnest Apple product ever — just 5.1mm thin. The Ultra Retina XDR display features nano-texture glass and tandem OLED technology for incredible brightness (1000 nits full screen, 1600 nits HDR). M4 chip with 10-core CPU and 10-core GPU runs AI and machine learning tasks with incredible efficiency. 16GB unified memory. Apple Pencil Pro compatible. Magic Keyboard for iPad Pro compatible. Wi-Fi 6E. 10.8 hours battery life. Landscape front camera. Four speakers. Three mics.",
      'productImage':
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800&q=80',
      'productQuantity': '130',
    },
    {
      'productId': 'samsung-qn90d-neo-qled-55',
      'productTitle': 'Samsung 55" QN90D Neo QLED 4K Smart TV (2024)',
      'productPrice': '1499.99',
      'productCategory': 'Electronics',
      'productDescription':
          "The Samsung QN90D Neo QLED TV delivers stunning visuals. Neo Quantum Processor 4K uses AI to upscale and enhance content. Quantum Matrix Technology Pro with Quantum Mini LEDs for precise backlighting. Anti-Reflection and Ultra Viewing Angle. Object Tracking Sound+ for immersive surround sound. 4 HDMI 2.1 ports (144Hz gaming). Real Game Enhancer+ with Motion Xcelerator Turbo Pro. AMD FreeSync Premium Pro, NVIDIA G-Sync compatible. Tizen OS with Samsung Smart Hub. 4K/120fps gaming support. Dolby Atmos.",
      'productImage':
          'https://images.unsplash.com/photo-1593359677879-a4bb92f829e1?w=800&q=80',
      'productQuantity': '80',
    },
    {
      'productId': 'dyson-v15-detect',
      'productTitle': 'Dyson V15 Detect Absolute Cordless Vacuum',
      'productPrice': '749.99',
      'productCategory': 'Electronics',
      'productDescription':
          "The Dyson V15 Detect reveals microscopic dust with a precisely-angled built-in green laser. Piezo sensor counts and measures hidden dust particles to scientifically validate a deep clean. Intelligently adapts suction to the task for optimum performance and extended battery life. HEPA filtration system captures 99.97% of particles as small as 0.3 microns. Up to 60 minutes fade-free power. LCD screen shows remaining runtime in real time. Compatible with all Dyson cordless attachments. Anti-tangle conical brush bar captures long hair and pet hair.",
      'productImage':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      'productQuantity': '65',
    },

    // ── BOOKS ───────────────────────────────────────────────────────────────
    {
      'productId': 'atomic-habits-james-clear',
      'productTitle': 'Atomic Habits by James Clear - Hardcover',
      'productPrice': '14.99',
      'productCategory': 'Books',
      'productDescription':
          "No. 1 New York Times bestseller. James Clear, one of the world's leading experts on habit formation, reveals practical strategies that will teach you exactly how to form good habits, break bad ones, and master the tiny behaviors that lead to remarkable results. If you're having trouble changing your habits, the problem isn't you. The problem is your system. Bad habits repeat themselves again and again not because you don't want to change, but because you have the wrong system for change. You do not rise to the level of your goals. You fall to the level of your systems. 320 pages.",
      'productImage':
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=800&q=80',
      'productQuantity': '900',
    },
    {
      'productId': 'the-lean-startup-eric-ries',
      'productTitle': 'The Lean Startup by Eric Ries - Paperback',
      'productPrice': '12.99',
      'productCategory': 'Books',
      'productDescription':
          "The Lean Startup has revolutionized how companies are built and new products are launched. Most startups fail. But many of those failures are preventable. Eric Ries defines a startup as an organization dedicated to creating something new under conditions of extreme uncertainty. Eric Ries explains it's the boring stuff that matters the most: validated learning, scientific experimentation, as well as a number of counter-intuitive practices that shorten product development cycles, minimize risk, and adapt and adjust before it's too late. 336 pages. Bestseller in Entrepreneurship.",
      'productImage':
          'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=800&q=80',
      'productQuantity': '700',
    },
    {
      'productId': 'rich-dad-poor-dad',
      'productTitle': "Rich Dad Poor Dad - Robert T. Kiyosaki - 25th Anniversary",
      'productPrice': '11.49',
      'productCategory': 'Books',
      'productDescription':
          "Rich Dad Poor Dad is Robert's story of growing up with two dads — his real father and the father of his best friend, his 'rich dad' — and the ways in which both men shaped his thoughts about money and investing. The book explodes the myth that you need to earn a high income to be rich and explains the difference between working for money and having your money work for you. 25th Anniversary Edition with updated commentary and a new foreword. Over 32 million copies sold worldwide. #1 Personal Finance book of all time. 336 pages.",
      'productImage':
          'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=800&q=80',
      'productQuantity': '1100',
    },
    {
      'productId': 'deep-work-cal-newport',
      'productTitle': 'Deep Work: Rules for Focused Success - Cal Newport',
      'productPrice': '13.99',
      'productCategory': 'Books',
      'productDescription':
          "One of the most valuable skills in our economy is becoming increasingly rare. If you master this skill, you'll achieve extraordinary results. Deep work is the ability to focus without distraction on a cognitively demanding task. Deep work will make you better at what you do and provide the sense of true fulfillment that comes from craftsmanship. In short, deep work is like a superpower in our increasingly competitive twenty-first century economy. Cal Newport is one of today's most respected voices on the art of productive work. 304 pages.",
      'productImage':
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&q=80',
      'productQuantity': '550',
    },

    // ── COSMETICS ───────────────────────────────────────────────────────────
    {
      'productId': 'mac-ruby-woo-lipstick',
      'productTitle': 'M·A·C Ruby Woo Retro Matte Lipstick',
      'productPrice': '21.00',
      'productCategory': 'Cosmetics',
      'productDescription':
          "One of M·A·C's most iconic shades — Ruby Woo. A vivid blue-red, this retro matte lipstick has been a bestseller since its launch and never goes out of style. The formula provides intense color payoff with a comfortable, matte finish that lasts all day. Not tested on animals. Dermatologist tested. Available in 150+ shades. 3g / 0.1 oz. How to use: Starting at the center of the upper lip, work toward the corners. Blot and reapply for intense color. Pair with M·A·C Prep + Prime Lip for extended wear.",
      'productImage':
          'https://images.unsplash.com/photo-1586495777744-4e6b0d0e0b75?w=800&q=80',
      'productQuantity': '800',
    },
    {
      'productId': 'nars-natural-radiant-foundation',
      'productTitle': "NARS Natural Radiant Longwear Foundation - Syracuse",
      'productPrice': '50.00',
      'productCategory': 'Cosmetics',
      'productDescription':
          "NARS Natural Radiant Longwear Foundation delivers buildable medium to full coverage with a natural, skin-like finish. Lightweight formula blends effortlessly for a seamless look that lasts up to 16 hours. Hyaluronic acid and light-reflecting pigments create a luminous, radiant complexion. Sweat, humidity, and transfer-resistant. Available in 45 inclusive shades with 6 undertones. Oil-free. Fragrance-free. Cruelty-free. Size: 30 ml. SPF: 12. Suitable for all skin types.",
      'productImage':
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&q=80',
      'productQuantity': '350',
    },
    {
      'productId': 'charlotte-tilbury-pillow-talk',
      'productTitle': 'Charlotte Tilbury Pillow Talk Original Lip Liner',
      'productPrice': '29.00',
      'productCategory': 'Cosmetics',
      'productDescription':
          "Charlotte Tilbury's most iconic shade — Pillow Talk. This cult-classic lip liner in a universally flattering shade of soft pink-nude has been sold more than 1 million times. The creamy, long-lasting formula helps prevent lipstick from bleeding and keeps it in place all day. Twist to sharpen. Retractable with no cap to lose. A must-have for the 'your lips but better' look. Cruelty-free. Size: 0.5g / 0.0176 oz. Suitable for all skin tones.",
      'productImage':
          'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=800&q=80',
      'productQuantity': '620',
    },
    {
      'productId': 'fenty-beauty-gloss-bomb',
      'productTitle': 'Fenty Beauty Gloss Bomb Universal Lip Luminizer - Fenty Glow',
      'productPrice': '22.00',
      'productCategory': 'Cosmetics',
      'productDescription':
          "Fenty Beauty's iconic Gloss Bomb Universal Lip Luminizer in Fenty Glow — the universally flattering shade that works on every skin tone. A high-shine, non-sticky formula that delivers mega-watt gloss. Infused with shea butter to moisturize and condition lips. Vanilla scent. The oversized doe-foot applicator makes it super easy to apply. Vegan. Not tested on animals. Size: 9 ml. Key ingredients: Shea butter, vitamins C and E. Shade range: 14 shades.",
      'productImage':
          'https://images.unsplash.com/photo-1600428877878-1a0fd85beda8?w=800&q=80',
      'productQuantity': '750',
    },
    {
      'productId': 'dyson-airwrap-multi-styler',
      'productTitle': 'Dyson Airwrap Multi-Styler Complete Long - Nickel/Copper',
      'productPrice': '599.99',
      'productCategory': 'Cosmetics',
      'productDescription':
          "The Dyson Airwrap multi-styler uses air to create multiple styles — curls, waves, blowouts, and more — without extreme heat. Intelligent heat control measures air temperature 40 times per second to maintain the right temperature for each style. The Coanda effect attracts and wraps hair around the barrel automatically. Complete for long hair: includes 5 styling attachments. Works on all hair types. EVO Motor. 3 precise airflow settings. 3 heat settings. Cool shot. PTFE-coated plates eliminate frizz. For fine, medium, and thick hair.",
      'productImage':
          'https://images.unsplash.com/photo-1522338242992-e1a54906a8da?w=800&q=80',
      'productQuantity': '95',
    },
  ];

  /// Seeds products to Firestore only if the collection is empty.
  static Future<void> seedIfEmpty() async {
    try {
      final snapshot = await _db.limit(1).get();
      if (snapshot.docs.isNotEmpty) return; // already seeded

      final batch = FirebaseFirestore.instance.batch();
      for (final product in _products) {
        final ref = _db.doc(product['productId'] as String);
        batch.set(ref, {
          ...product,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (_) {
      // silently fail — products may already exist
    }
  }
}
