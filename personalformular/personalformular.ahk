#requires AutoHotkey v2.0

Institutsnummer := "3140"
Institutskürzel := "FIT"
Personalnummer := "10013705"
Vorname := "Christoph"
Nachname := "Lange-Bever"

SendText(Institutsnummer)
Send("{Tab}")
SendText(Institutskürzel)
Send("{Tab}")
SendText(Personalnummer)
Send("{Tab}")
SendText(Vorname)
Send("{Tab}")
SendText(Nachname)