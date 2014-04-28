#include xpath.ahk

global fmTop := 
global fmLeft :=

global xTrait0 := 197
global yTrait0 := 239

global xTraitShift := 169
global yTraitShift := 89

global xHaunting := 549
global yHaunting := 175

global xRBooster := 630
global yRBooster := 124

global xStartButton := 550
global yStartButton := 510

global dGrid := 17
global dInvGrid := 28

global xInv0 := 867
global yInv0 := 457

global createdGemPos := 0

global gemTypes = {}

global opts_xml :=
global opts_xml_path := "options.xml"
global options := { bomb_count : 20 }

init()

GetTopLeftPos()
{
	MouseGetPos, fmLeft, fmTop
}

Start()
{
	x := fmLeft + xTrait0
	y := fmTop + yTrait0
	dx := xTraitShift
	dy := yTraitShift

	; Boost fragment rarity 3 times
	MouseClick left, fmLeft + xRBooster, fmTop + yRBooster, 3

	; Set Haunting difficulty
	MouseClick left, fmLeft + xHaunting, fmTop + yHaunting

	; Max all traits
	Send {Shift down}

	MouseClick left, x, y
	MouseClick left, x + dx, y
	MouseClick left, x + 2 * dx, y

	MouseClick left, x, y + dy
	MouseClick left, x + dx, y + dy
	MouseClick left, x + 2 * dx, y + dy

	MouseClick left, x, y + 2 * dy
	MouseClick left, x + dx, y + 2 * dy
	MouseClick left, x + 2 * dx, y + 2 * dy
	
	Send {Shift up}

	; Start the battle
	MouseClick left, fmLeft + xStartButton, fmTop + yStartButton
}

init()
{
	SetDefaultMouseSpeed, 0

	xpath_load(xml, opts_xml_path)
	options.bomb_count := xpath(xml, "/options/bomb_count/text()")
	;msgbox, % 4 | 64, Hello world!, Ctrl+i - init`nCtrl+c - combine
}

mp2ip(xpos, ypos)
{
	x := xInv0 - (xpos - fmLeft) + (dInvGrid / 2)
	y := yInv0 - (ypos - fmTop) + (dInvGrid / 2)

	return 3 * (y // dInvGrid) + (x // dInvGrid)
}

ip2mp(a, ByRef xpos, ByRef ypos)
{
	xpos := fmLeft + xInv0 - (dInvGrid * mod(a, 3))
	ypos := fmTop + yInv0 - (dInvGrid * (a // 3))
}

swapGems(a, b)
{
	xpos1 :=, ypos1 :=
	xpos2 :=, ypos2 :=
	ip2mp(a, xpos1, ypos1)
	ip2mp(b, xpos2, ypos2)
	MouseClickDrag, left, xpos1, ypos1, xpos2, ypos2
}

createGem(grade)
{
	xpos0 :=, ypos0 :=
	xpos1 :=, ypos1 :=
	xpos2 :=, ypos2 :=
	MouseGetPos, xpos0, ypos0
	ip2mp(3 * grade, xpos1, ypos1)
	ip2mp(createdGemPos, xpos2, ypos2)
	MouseClick, left, xpos1, ypos1
	MouseClickDrag, left, xpos1, ypos1, xpos2, ypos2
	createdGemPos++
	MouseMove, xpos0, ypos0
}

Combine()
{
	xpos0 :=, ypos0 :=
	xpos1 :=, ypos1 :=
	xpos2 :=, ypos2 :=
	MouseGetPos, xpos0, ypos0
	ip2mp(createdGemPos - 1, xpos1, ypos1)
	Loop, % createdGemPos - 1
	{
		ip2mp(createdGemPos - a_index - 1, xpos2, ypos2)
		Send {g}
		MouseClickDrag, left, xpos1, ypos1, xpos2, ypos2
		xpos1 := xpos2
		ypos1 := ypos2
	}
	swapGems(0, 35)
	createdGemPos := 0
	MouseMove, xpos0, ypos0
}

Bomb()
{
	Send {b}
	Send {Shift down}

	MouseClick, left, , , options.bomb_count

	Send {Shift up}
	Send {b}
}

^+i::
	GetTopLeftPos()
return

^+s::
	KeyWait Control
	Start()
return

^+c::
	KeyWait Control
	Combine()
return

^RButton::
	KeyWait Control
	Bomb()
return

^!r::Reload

F1::
	createGem(0)
return

F2::
	createGem(1)
return

F3::
	createGem(2)
return

F4::
	createGem(3)
return

F5::
	createGem(4)
return

F6::
	createGem(5)
return

F7::
	createGem(6)
return

F8::
	createGem(7)
return

F9::
	createGem(8)
return

F10::
	createGem(9)
return

F11::
	createGem(10)
return

F12::
	createGem(11)
return

