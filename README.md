Author : Qosim Ariqoh Daffa

NPM : 2006522820

Source : https://github.com/CSUI-Game-Development/tutorial-3-template

Godot version : 3.5

---

# Tutorial 3

## Latihan Mandiri: Eksplorasi Mekanika Pergerakan

Sebagai bagian dari latihan mandiri, kamu diminta untuk praktik mengembangkan lebih lanjut mekanika pergerakan karakter di game platformer. Beberapa ide fitur lanjutan terkait pergerakan karakter di game platformer:

-   [x] Double jump - karakter pemain bisa melakukan aksi loncat sebanyak dua kali.
-   [x] Dashing - karakter pemain dapat bergerak lebih cepat dari kecepatan biasa secara sementara ketika pemain menekan tombol arah sebanyak dua kali.
-   [x] Crouching - karakter pemain dapat jongkok dimana sprite-nya terlihat lebih kecil (misal: sprite karakter manusianya terlihat berjongkok) dan kecepatan pergerakannya menjadi lebih lambat ketika lagi jongkok
-   [x] Other Function
    -   [x] Animation - karakter pemain dapat menunjukkan animasi yang berbeda berdasarkan aksi yang dilakukan
    -   [x] Change Texture - tampilan tekstur dari karakter pemain dapat diubah menjadi tekstur lain yang telah disediakan
    -   [x] Reset Position - posisi karakter pemain dapat dikembalikan ke posisi semula
-   [ ] Dan lain-lain. Silakan cari contoh mekanika pergerakan 2D lainnya yang mungkin diimplementasikan di dalam permainan tipe platformer.

Silakan pilih fitur lanjutan yang ingin dikerjakan. Kemudian jelaskan proses pengerjaannya di dalam sebuah dokumen teks README.md. Cantumkan juga referensi-referensi yang digunakan sebagai acuan ketika menjelaskan proses implementasi.

---

## Proses Pengerjaan

### Double Jump

Sebelumnya telah terimplementasi fitur lompat dengan kode sebagai berikut.

```
export (int) var jump_speed = -600

if Input.is_action_pressed("ui_up"):
  if is_on_floor():
		velocity.y = jump_speed
```

_Conditional_ di atas hanya akan menjalankan `velocity.y = jump_speed` ketika `Player` berada di lantai (`is_on_floor`). _Method_ [`is_on_floor`](https://docs.godotengine.org/en/3.5/getting_started/first_3d_game/06.jump_and_squash.html) merupakan _method_ yang berasal dari _node_ `KinematicBody`. _Method_ ini akan mengembalikan nilai `true` apabila `Player` _collide_ dengan _floor_.

Supaya `Player` dapat melakukan **double jump**, diperlukan variable _bool_ `can_double_jump` yang dapat berubah ketika `Player` melakukan **double jump** sebanyak sekali. Hal ini dilakukan supaya `Player` tidak dapat mengespam _on mid air jump_. Perubahan value **double jump** terjadi dalam dua (2) kondisi, yaitu ketika `Player` melakukan **jump** _in mid air_ (ubah ke `false`) dan ketika `Player` menyentuk lantai (ubah ke `true`).

```
export (int) var jump_speed = -600
export (bool) var can_double_jump = true  # init var

func get_input():
  if Input.is_action_just_pressed("ui_up"):
    if is_on_floor():
      can_double_jump = true    # update var ke true

    if is_on_floor():
      velocity.y = jump_speed
    elif can_double_jump:       # conditional on air + click jump
      velocity.y = jump_speed
      can_double_jump = false   # update var ke false
```

### Dashing

Dikarenakan belum ada _acction key_ untuk dash, perlu ditambahkan pada `Project Settings... > Input Map`. Dalam lab ini ditambahkan _action key_ **ui_dash** dengan input tombol _Shift_ pada keyboard.

Untuk implementasi, ditambahkan _conditional_ baru di akhir fungsi `get_input()`.

```
export (int) var dash_multiplier = 2

func get_input():

  # implementasi lainnya

  if Input.is_action_just_pressed("ui_dash"):
		velocity.x *= dash_multiplier
```

Diletakkan dibawah kode supaya `velocity.x` sudah terupdate ketika pemain menggerakkan `Player` ke kanan maupun kekiri yang dimana akan di*multiplier* sehingga `Player` bergerak makin cepat.

### Crouching

_Action key_ yang digunakan untuk **crouching** adalah tombol _down_. Implemetasi dilakukan pada conditional `is_on_floor` yang telah digunakan sebelumnya untuk mengupdate nilai `can_double_jump`.

```
func get_input():
  if is_on_floor():
		can_double_jump = true

		if Input.is_action_pressed("ui_crouch"):
			$Sprite.frame = 3
			speed = 200
		else:
			$Sprite.frame = 0
			speed = 400
```

Sebagai penanda `Player` _crouching_, digunakan _frame_ dari gambar yg telah disediakan. Gambar berupa _tilemap_ yang telah dibagi menjadi beberapa _frame_ dari _attribute_ yang dimiliki oleh _node_ `Sprite`. Pengaturan dilakukan pada _attribute_ `Hframes` dan `Vframes` ke dalam bentuk _frame_ yang indeksnya dapat dipilih dari _attribute_ `Frame`.

Berdasarkan gambar yang disediakan, _frame_ 3 merupakan _frame_ jongkok. _Frame_ akan diganti ke 3 ketika pemain menekan tombol _down_ dan dikembalikan ke frame semula ketika pemain melepas tombol _down_. Pergantian ini terjadi ketika `Player` menyentuh lantai sebagai kondisi awal dari _crouching_.

### Animation

Reference : [Learn How To Use The Godot Animation Player In Less Than 5 Minutes](https://www.youtube.com/watch?v=ATfE4k6EP9U&t=58s)

#### Implementasi Animation

Implementasi menggunakan `AnimationPlayer` untuk menyimpan animasi dari `Sprite` yang digunakan. Animasi yang dibuat adalah

-   idle
-   walk
-   jump
-   crouch
-   dash

Dari _script_, `AnimationPlayer` dapat dipanggil dengan fungsi `.play()` untuk menjalankan animasi yang diinginkan. Namun sebelum itu, _node_ perlu dipanggil pada _script_.

```
onready var animation_player = get_node("AnimationPlayer")
```

Kode diatas akan menginisiasi var `animation_player` ketika _node_ `Player` sudah _ready_.

Selain var `animation_player`, akan diambil var `direction` untuk menghandle perubahan arah tampilan `Sprite`.

```
var direction : Vector2 = Vector2.ZERO # for animation

func _process(delta):
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
```

Var `direction` akan selalu terupdate setiap frame dengan vector dari _input_ yang diberikan oleh pemain. Fungsi [get_vector](https://docs.godotengine.org/en/3.5/classes/class_input.html#methods) akan menerima atribut (String negative_x, String positive_x, String negative_y, String positive_y, float deadzone=-1.0) yang kemudian akan mengembalikan nilai `Vector2` dari input yang diberikan.

Untuk implementasi update animasi, dapat dilihat pada kode di bawah.

```
func update_animation():
	if is_on_floor():
		if Input.is_action_pressed("ui_crouch"):
			animation_player.play("crouch")
		elif direction != Vector2.ZERO:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
	else:
		animation_player.play("jump")

	if Input.is_action_pressed("ui_dash") and direction != Vector2.ZERO:
		animation_player.play("dash")

	if Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = true
```

Penulisan kode sudah disesuaikan dengan kondisi dari dijalankannya suatu animasi. Untuk menjalankan animasi, digunakan `animation_player(<nama_animasi>)`.

Sehingga hasil akhir dari implementasi animasi adalah sebagai berikut.

```
var direction : Vector2 = Vector2.ZERO # for animation

onready var animation_player = get_node("AnimationPlayer")

func _process(delta):
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
	update_animation()

func update_animation():
	if is_on_floor():
		if Input.is_action_pressed("ui_crouch"):
			animation_player.play("crouch")
		elif direction != Vector2.ZERO:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
	else:
		animation_player.play("jump")

	if Input.is_action_pressed("ui_dash") and direction != Vector2.ZERO:
		animation_player.play("dash")

	if Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = true
```

#### Update: implementasi jump

Animasi `jump` diimplementasi menjadi dua jenis animasi, `jump_up` dan `jump_down`. Animasi dibedakan untuk membuatnya lebih detail. Sehingga tidak hanya animasi `jump` saja, namun juga dapat digunakan sebagai animasi `fall`.

**Before:**

```
func update_animation():
  //
  else:
    animation_player.play("jump")
  //
```

**After:**

```
func update_animation():
  //
  else:
    if velocity.y < 0:
			animation_player.play("jump_up")
		else:
			animation_player.play("jump_down")
  //
```

### Update: Fix Dash Animation

**Before:**

```
func update_animation():
  if Input.is_action_pressed("ui_dash") and direction != Vector2.ZERO:
		animation_player.play("dash")
```

Fungsi di atas merupakan fungsi untuk menjalankan animasi `dash`. Namun, `dash` dapat dijalankan dengan menekan tombol `dash` + `crouch` secara bersamaan, dimana seharusnya yang dijalankan tetaplah animasi `crouch`.

Maka dari itu, dilakukan sedikit perubahan pada _if conditional_ sehingga animasi `dash` hanya dilakukan ketika `direction.x`nya tidak nol dan tidak ketika `direction.y` tidak nol (sedang `crouch`).

**After:**

```
func update_animation():
  if Input.is_action_pressed("ui_dash") and direction.x != 0:
		animation_player.play("dash")
```

---

## Change Sprite Texture

Reference: [How to change the image/texture of a sprite when it enters a specific area](https://forum.godotengine.org/t/how-to-change-the-image-texture-of-a-sprite-when-it-enters-a-specific-area/3590)

Sebelumnya menambahkan Input Map baru `"ui_interact"` dengan _key_ `"F"`. Untuk menyediakan texture yang akan digunakan, inisiasi dengan fungsi `preload`.

```
var curr_texture_index = 0
var texture_list = [
  preload("res://assets/kenney_platformercharacters/PNG/Adventurer/adventurer_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Female/female_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Player/player_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Soldier/soldier_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Zombie/zombie_tilesheet.png"),
]
```

Texture yang akan diguanakan adalah semua _tilesheet_ yang telah disediakan untuk project, yaitu Adventurer, Female, Player, Soldier, dan Zombie. Kemudian var `player_sprite` akan diinstansiasi untuk memanggil _node_ `Sprite` yang akan diupdate atribut `texture`nya.

```
onready var player_sprite = get_node("Sprite")
```

Untuk mengubah texture, perlu update atribut `texture` pada `player_sprite`. Implementasi yang dilakukan adalah dengan mengupdate nilai `curr_texture_index` yang dapat dibatasi dengan jumlah dari `texture_list` sehingga dapat ditambahkan texture lainnya selama masih sesuai dengan _frame_ dari `Sprite`.

```
func _process(delta):
	//
	if Input.is_action_just_pressed("ui_interact"):
		increase_curr_texture_index()
		player_sprite.texture = texture_list[curr_texture_index]

func increase_curr_texture_index():
	curr_texture_index += 1
	if curr_texture_index >= texture_list.size():
		curr_texture_index = 0
```

Ketika pemain menekan key "F", `Sprite` dari `Player` akan digantikan dengan _texture_ berikutnya pada list.

---

## Restart Position

Reference: (position in center of screen)[https://forum.godotengine.org/t/position-in-center-of-screen/20171]

Sebelumnya menambahkan Input Map baru `"ui_restart"` dengan _key_ `"R"`. Implementasi dari _`restart position`_ adalah sebagai berikut.

```
func _process(delta):
	//
	if Input.is_action_just_pressed("ui_restart"):
		position = get_parent().get_viewport_rect().size / 2.0
```

Var `position` dari `Player` akan terupdate dengan posisi tepat di tengah layar game ketika pemain menekan tombol `Restart`.

### Update: Refactor Implementasi Fitur

Implementasi fitur `restart position` dipindahkan ke _script_ `Main.gd`. Alasannya adalah sebelumnya pada `Player.gd`, dilakukan pemanggilan `get_parent()` untuk mengambil _node_ parentnya yang kemudian dilanjutkan dengan pengambilan `get_viewport_rect().size`. Implementasi ini tidak fleksibel karena posisi hanya dapat diubah ke tengah _screen_. Dengan dipindahkannya ke `Main.gd` memungkinkan posisi reset `Player` berbeda untuk setiap level yang ditempatinya.

Implementasi yang baru pada file `Main.gd` adalah sebagai berikut.

```
func _process(delta):
	if Input.is_action_just_pressed("ui_restart"):
		reset_player_position()

func reset_player_position():
	player.position = get_viewport_rect().size / 2.0
```

### Update: Use `Camera` as Mid-view

Setelah berpikir panjang untuk penempatan reset posisi `Player`, dicoba menggunakan _node_ `Camera`. _Node_ tersebut dapat digunakan untuk menjadi _main view_ dari game yang dibuat. Nantinya, _node_ `Camera` tersebut dapat diatur untuk mengikuti gerakan `Player`, dikarenakan atribut `position` dari `Player` akan selalu berubah ketika digerakkan (bisa update `position` dari `Camera` dengan `position` dari `Player`).

Pada `Main.gd` ditambahkan kode berikut.

```
func _process(delta):
	camera.position = player.position
	//
```

---

## Tambahan

Untuk menyesuaikan dengan CI/CD dari github, terdapat beberapa perubahan pada kodingan.

1. Perubahan pada kode `export`

**Sebelum**

```
export (int) var speed = 400
```

**Setelah**

```
var speed : int = 400
```

2. Perubahan pada kode `onready`

`onready` digunakan berdasarkan rekomendasi yang diberikan dari godot. Hal ini dilakukan untuk menginstansiasi variable ketika `scene` _ready_.

**Sebelum**

```
onready var player = get_node("Player")
```

**Setelah**

```
var player : Node2D

func _ready():
	player = get_node("Player")
```

### Last Update's Note

Doesn't seem to be working

---

---

# Tutorial 5

## Upgrade AnimationPlayer Code

Implementasi yang ada di tutorial merupakan implementasi yang lebih baik dikarenakan fungsi `AnimationPlayer.play()` tidak akan dijalankan terus menerus.

```
var animation : String = 'idle'

func update_animation():
	if is_on_floor():
		if Input.is_action_pressed("ui_crouch"):
			animation = "crouch"
		elif direction != Vector2.ZERO:
			animation = "walk"
		else:
			animation = "idle"
	else:
		if velocity.y < 0:
			animation = "jump_up"
		else:
			animation = "jump_down"

	if Input.is_action_pressed("ui_dash") and direction.x != 0:
		animation = "dash"

	if Input.is_action_pressed("ui_right"):
		player_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		player_sprite.flip_h = true

	if animation_player.current_animation != animation:
		animation_player.play(animation)
```

## Penggunaan `AnimationSprite`

Setelah dilakukan percobaan pembuatan `AnimationSprite`, dikarenakan implementasi pada tutorial-3 sebelumnya ada pergantian pemain, implementasi `AnimationSprite` cukup memakan banyak waktu dan usaha pada satu `AnimationSprite` yang sama.
Meski memindahkan untuk satu karakter satu _scene_, hal ini tidak efektif dikarenakan `AnimationSprite`, atau lebih tepatnya `SpritesFrames` tidak begitu sederhana untuk menanganinya.
Untuk _workaround_ permasalahan ini dapat mengikuti [solusi berikut](https://stackoverflow.com/questions/70139487/how-to-change-the-texture-of-animatedsprite-programatically).
Namun ada baiknya me*expend* `AnimationPlayer` yang sudah dibuat sebelumnya.

Berdasarkan observasi dari pengerjaan **tutorial-5** ini, `AnimationSprite` berfokus kepada animasi `Sprite` yang sudah ditentukan sebelumnya dengan jarak antar _frame_ yang fixed, sehingga `AnimationSprite` sangat cocok untuk digunakan pada karakter bermodel _pixelart_.
Namun, `AnimationPlayer` + `Sprite` dapat melakukan yang serupa, bahkan lebih dari situ.
`AnimationPlayer` tidak hanya menentukan perubahan animasi _frame_ karakter, namun beberapa perubahan lain, seperti `position`, `scale`, `modulate`, bahkan hingga `function` (seperti `queue_free()`) yang beberapa telah dilakukan pada **tutorial-4**.

---

## Latihan Mandiri: Membuat dan Menambah Variasi Aset

Silakan eksplorasi lebih lanjut mengenai animasi berdasarkan spritesheet dan audio. Untuk latihan mandiri yang dikerjakan di akhir tutorial, kamu diharapkan untuk:

-   [ ] Membuat minimal 1 (satu) objek baru di dalam permainan yang dilengkapi dengan animasi menggunakan spritesheet selain yang disediakan tutorial. Silakan cari spritesheet animasi di beberapa koleksi aset gratis seperti Kenney.

-   [x] Membuat minimal 1 (satu) audio untuk efek suara (SFX) dan memasukkannya ke dalam permainan. Kamu dapat membuatnya sendiri atau mencari dari koleksi aset gratis.

-   [ ] Membuat minimal 1 (satu) musik latar (background music) dan memasukkannya ke dalam permainan. Kamu dapat membuatnya sendiri atau mencari dari koleksi aset gratis.

-   [ ] Implementasikan interaksi antara objek baru tersebut dengan objek yang dikendalikan pemain. Misalnya, pemain dapat menciptakan atau menghilangkan objek baru tersebut ketika menekan suatu tombol atau tabrakan dengan objek lain di dunia permainan.

-   [ ] Implementasikan audio feedback dari interaksi antara objek baru dengan objek pemain. Misalnya, muncul efek suara ketika pemain tabrakan dengan objek baru.

Beberapa ide lain yang bisa kamu coba kerjakan di luar latihan mandiri:

-   [ ] Implementasi sistem audio yang relatif terhadap posisi objek. Misalnya, musik latar akan semakin terdengar samar ketika pemain semakin jauh dari posisi awal level.

Silakan berkreasi lebih lanjut untuk membuat Tutorial 3 dan 5 kamu lebih menarik dari sebelumnya!
Jangan lupa untuk menjelaskan proses pengerjaan tutorial ini di dalam berkas `README.md` yang sama dengan Tutorial 3. Silakan tambahkan subbab (_section_) baru yang berisi penjelasan proses pengerjaan Tutorial 5.
Cantumkan juga referensi-referensi yang digunakan sebagai acuan ketika menjelaskan proses implementasi.

---

### Pembuatan Objek Baru Beserta dengan Animasinya

Pada _scene_ `Coin`, digunakan `AnimationSprite` untuk membuat animasinya. Sederhananya, pada bagian `AnimationSprite` dibuat sebuah `SpriteFrame` dan menambahkan dua (2) buah _frame_ untuk memperlihatkan bahwa koin berputar.

![coin animation sprite](pics\coin_animation_sprite.png)

Untuk membuat animasi `Coin` dapat dimainkan ketika pertama kali dibuka, _check_ true pada atribut `playing`.

---

### Penambahan Musik Latar

Resource: https://www.youtube.com/watch?v=4a4hwDRKBJU

Pertama, aset background ditambahkan terlebih dahulu kedalam project. Kemudian, ditambahkan Input Mapping dengan kunci "G" untuk interaksi ubah _background music_. Lalu, dibuat fungsi ubah lagu pada _script_ `Main`.

```
var currMusic = 0
var musicList = [
	preload("res://assets/sound/bgm.wav"),
	preload("res://assets/sound/アトリエと電脳世界_2.mp3")
]

onready var audioStreamPlayer = get_node("AudioStreamPlayer2D")

func _process(delta):
	//
	if Input.is_action_just_pressed("ui_music"):
		change_music()

func change_music():
	currMusic += 1
	if currMusic >= musicList.size():
		currMusic = 0

	audioStreamPlayer.stream = musicList[currMusic]
	audioStreamPlayer.play(0)
```

Fungsi diatas akan membuat _background music_ berubah. Perlu ditambahkan `audioStreamPlayer.play(0)` dikarenakan _background music_ akan berhenti dimainkan ketika diganti dengan musik yang lain.

---

### Interaksi Antara Objek dan Pemain

IDE: Koin

Buat satu _scene_ baru dengan struktur _tree_ sebagai berikut.

```
Coin (Node2D)
| - AnimationSprite (animasi dari objek Coin)
| - Area2D (collision dengan pemain)
| | - CollisionShape2D
| - AnimationPlayer
| - AudioStreamPlayer
```

Implementasi dilakukan dengan membuat satu animasi koin pada `AnimationPlayer` dan mengkoneksikan fungsi `body_entered()`.
Isi dari fungsi `body_entered()` hanya digunakan untuk memanggil animasi pada `AnimationPlayer`.

```
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("coin")
```

Untuk isi dari `AnimationPlayer` adalah seperti berikut.

![coin animation player](pics\coin_animation_player.png)

Berdasarkan pada pengerjaan **Tutorial 4**, telah dilakukan percobaan untuk menghilangkan objek `FallingFish` via `AnimationPlayer`.
Percobaan tersebut dilakukan kembali pada kasus menghilangkan koin.
Selain itu, untuk memberikan efek suara koin terambil, ditambahkan `AudioStreamPlayer` dari opsi `Audio Playback Track` yang tersedia di `AnimationPlayer`.

---

### Audio Feedback dari Interaksi Antara Objek dan Pemain

Sumber audio: https://freesound.org/people/ProjectsU012/sounds/341695/

Proses implementasi sudah dijelaskan di atas.

---

### Implementasi Audio yang relatif terhadap posisi Pemain (OPTIONAL)
