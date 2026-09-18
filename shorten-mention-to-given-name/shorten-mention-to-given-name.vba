Option Explicit

' Source of this function: https://github.com/taiyaki32lp64/external_editor_for_outlook365
Private Function CurrentMailItem() As Object
  Dim inspector As Object
  Dim item As Object

  Set inspector = Application.ActiveInspector
  If inspector Is Nothing Then
    Set CurrentMailItem = Nothing
    Exit Function
  End If

  Set item = inspector.CurrentItem
  If item Is Nothing Then
    Set CurrentMailItem = Nothing
    Exit Function
  End If

  ' TODO type check

  Set CurrentMailItem = item
End Function

' Format the current message as HTML.  Useful if default format was set to plain text.
Sub FormatMessageAsHtml()
  ' Get current mail item
  Dim mailItem As Object
  Set mailItem = CurrentMailItem()
  If mailItem Is Nothing Then
    Exit Sub
  End If

  ' Change format to HTML
  With mailItem
    .BodyFormat = olFormatHTML
  End With
  
  ' Change style to "Normal"
  Dim doc As Object
  Dim sel As Object
  
  Set doc = ActiveInspector.WordEditor
  Set sel = doc.Windows(1).Selection
  
  sel.WholeStory
  sel.Style = "Normal"
End Sub
