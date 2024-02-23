Author : Qosim Ariqoh Daffa

NPM : 2006522820

Source : https://github.com/CSUI-Game-Development/tutorial-3-template

---

# Latihan Mandiri: Eksplorasi Mekanika Pergerakan

Sebagai bagian dari latihan mandiri, kamu diminta untuk praktik mengembangkan lebih lanjut mekanika pergerakan karakter di game platformer. Beberapa ide fitur lanjutan terkait pergerakan karakter di game platformer:

[x] Double jump - karakter pemain bisa melakukan aksi loncat sebanyak dua kali.
[x] Dashing - karakter pemain dapat bergerak lebih cepat dari kecepatan biasa secara sementara ketika pemain menekan tombol arah sebanyak dua kali.
[x] Crouching - karakter pemain dapat jongkok dimana sprite-nya terlihat lebih kecil (misal: sprite karakter manusianya terlihat berjongkok) dan kecepatan pergerakannya menjadi lebih lambat ketika lagi jongkok
[ ] Dan lain-lain. Silakan cari contoh mekanika pergerakan 2D lainnya yang mungkin diimplementasikan di dalam permainan tipe platformer.

Silakan pilih fitur lanjutan yang ingin dikerjakan. Kemudian jelaskan proses pengerjaannya di dalam sebuah dokumen teks README.md. Cantumkan juga referensi-referensi yang digunakan sebagai acuan ketika menjelaskan proses implementasi.

---

# Proses Pengerjaan

## Double Jump

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

## Dashing

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

## Crouching

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

## Animation (On Going)
