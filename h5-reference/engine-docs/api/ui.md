# UI Module（旧版原生 UI）

> ⛔ **此文档是旧版原生 UI 系统**（`ui.root` / `UIElement` / `Button` / `Text` 等）。
> 新代码请使用 urhox-libs/UI，权威指南见 [../recipes/ui.md](../recipes/ui.md)。
> 本文档保留是为了维护引用了旧 UI 的历史代码。

UrhoX Lua API - UI Module

---

## Classes

- [UI](#ui)
- [UIElement](#uielement)
- [UIComponent](#uicomponent)
- [UISelectable](#uiselectable)
- [BorderImage](#borderimage)
- [Sprite](#sprite)
- [Button](#button)
- [CheckBox](#checkbox)
- [Slider](#slider)
- [ScrollBar](#scrollbar)
- [ScrollView](#scrollview)
- [ListView](#listview)
- [Text](#text)
- [Text3D](#text3d)
- [LineEdit](#lineedit)
- [DropDownList](#dropdownlist)
- [Window](#window)
- [View3D](#view3d)
- [ProgressBar](#progressbar)
- [ToolTip](#tooltip)
- [Menu](#menu)
- [Cursor](#cursor)
- [MessageBox](#messagebox)
- [FileSelector](#fileselector)
- [FileSelectorEntry](#fileselectorentry)
- [HierarchyContainer](#hierarchycontainer)

---

**Inherits from**: Object

## UI : Object


### Methods


- void SetCursor(Cursor* cursor)
- void SetFocusElement(UIElement* element, bool byKey = false)
- bool SetModalElement(UIElement* modalElement, bool enable)
- void Clear()
- void DebugDraw(UIElement* element)
- UIElement* LoadLayout(File* source, XMLFile* styleFile = 0)
- UIElement* LoadLayout(const String fileName, XMLFile* styleFile = 0)
- UIElement* LoadLayout(XMLFile* file, XMLFile* styleFile = 0)
- bool SaveLayout(Serializer& dest, UIElement* element)
- void SetClipboardText(const String text)
- void SetDoubleClickInterval(float interval)
- void SetMaxDoubleClickDistance(float pixels)
- void SetDragBeginInterval(float interval)
- void SetDragBeginDistance(int pixels)
- void SetDefaultToolTipDelay(float delay)
- void SetMaxFontTextureSize(int size)
- void SetNonFocusedMouseWheel(bool nonFocusedMouseWheel)
- void SetUseSystemClipboard(bool enable)
- void SetUseScreenKeyboard(bool enable)
- void SetUseMutableGlyphs(bool enable)
- void SetForceAutoHint(bool enable)
- void SetFontHintLevel(FontHintLevel level)
- void SetFontSubpixelThreshold(float threshold)
- void SetFontOversampling(int limit)
- void SetScale(float scale)
- void SetWidth(float width)
- void SetHeight(float height)
- void SetCustomSize(const IntVector2& size)
- void SetCustomSize(int width, int height)
- UIElement* GetRoot() const
- UIElement* GetRootModalElement() const
- Cursor* GetCursor() const
- IntVector2 GetCursorPosition() const
- UIElement* GetElementAt(const IntVector2& position, bool enabledOnly = true)
- UIElement* GetElementAt(int x, int y, bool enabledOnly = true)
- UIElement* GetFocusElement() const
- UIElement* GetFrontElement() const
- UIElement* GetDragElement(unsigned index)
- const String GetClipboardText() const
- float GetDoubleClickInterval() const
- float GetMaxDoubleClickDistance() const
- float GetDragBeginInterval() const
- int GetDragBeginDistance() const
- float GetDefaultToolTipDelay() const
- int GetMaxFontTextureSize() const
- bool IsNonFocusedMouseWheel() const
- bool GetUseSystemClipboard() const
- bool GetUseScreenKeyboard() const
- bool GetUseMutableGlyphs() const
- bool GetForceAutoHint() const
- FontHintLevel GetFontHintLevel() const
- float GetFontSubpixelThreshold() const
- int GetFontOversampling() const
- bool HasModalElement() const
- bool IsDragging() const
- float GetScale() const
- const IntVector2& GetCustomSize() const

### Properties


- UIElement* root (readonly)
- UIElement* rootModalElement (readonly)
- Cursor* cursor
- IntVector2 cursorPosition (readonly)
- UIElement* focusElement (readonly)
- UIElement* frontElement (readonly)
- String clipboardText
- float doubleClickInterval
- float dragBeginInterval
- int dragBeginDistance
- float defaultToolTipDelay
- int maxFontTextureSize
- bool nonFocusedMouseWheel
- bool useSystemClipboard
- bool useScreenKeyboard
- bool useMutableGlyphs
- bool forceAutoHint
- FontHintLevel fontHintLevel
- float fontSubpixelThreshold
- int fontOversampling
- bool modalElement (readonly)
- float scale
- IntVector2& customSize



---

**Inherits from**: Animatable

## UIElement : Animatable


### Methods


- UIElement() (GC)
- UIElement* new()
- void delete()
- const IntVector2& GetScreenPosition() const
- bool LoadXML(Deserializer& source)
- bool SaveXML(Serializer& dest, const String indentation = "\t") const
- bool LoadXML(const String fileName)
- bool SaveXML(const String fileName, const String indentation = "\t") const
- bool FilterAttributes(XMLElement& dest) const
- void SetName(const String name)
- void SetPosition(const IntVector2& position)
- void SetPosition(int x, int y)
- void SetSize(const IntVector2& size)
- void SetSize(int width, int height)
- void SetWidth(int width)
- void SetHeight(int height)
- void SetMinSize(const IntVector2& minSize)
- void SetMinSize(int width, int height)
- void SetMinWidth(int width)
- void SetMinHeight(int height)
- void SetMaxSize(const IntVector2& maxSize)
- void SetMaxSize(int width, int height)
- void SetMaxWidth(int width)
- void SetMaxHeight(int height)
- void SetFixedSize(const IntVector2& size)
- void SetFixedSize(int width, int height)
- void SetFixedWidth(int width)
- void SetFixedHeight(int height)
- void SetAlignment(HorizontalAlignment hAlign, VerticalAlignment vAlign)
- void SetHorizontalAlignment(HorizontalAlignment align)
- void SetVerticalAlignment(VerticalAlignment align)
- void SetEnableAnchor(bool enable)
- void SetMinAnchor(const Vector2& anchor)
- void SetMinAnchor(float x, float y)
- void SetMaxAnchor(const Vector2& anchor)
- void SetMaxAnchor(float x, float y)
- void SetMinOffset(const IntVector2& offset)
- void SetMaxOffset(const IntVector2& offset)
- void SetPivot(const Vector2& pivot)
- void SetPivot(float x, float y)
- void SetClipBorder(const IntRect& rect)
- void SetColor(const Color& color)
- void SetColor(Corner corner, const Color& color)
- void SetPriority(int priority)
- void SetOpacity(float opacity)
- void SetBringToFront(bool enable)
- void SetBringToBack(bool enable)
- void SetClipChildren(bool enable)
- void SetSortChildren(bool enable)
- void SetUseDerivedOpacity(bool enable)
- void SetEnabled(bool enable)
- void SetDeepEnabled(bool enable)
- void ResetDeepEnabled()
- void SetEnabledRecursive(bool enable)
- void SetEditable(bool enable)
- void SetFocus(bool enable)
- void SetSelected(bool enable)
- void SetVisible(bool enable)
- void SetFocusMode(FocusMode mode)
- void SetDragDropMode(DragAndDropMode mode)
- bool SetStyle(const String styleName, XMLFile* file = 0)
- bool SetStyle(const XMLElement& element)
- bool SetStyleAuto(XMLFile* file = 0)
- void SetDefaultStyle(XMLFile* style)
- void SetLayout(LayoutMode mode, int spacing = 0)
- void SetLayout(LayoutMode mode, int spacing, const IntRect& border)
- void SetLayoutMode(LayoutMode mode)
- void SetLayoutSpacing(int spacing)
- void SetLayoutBorder(const IntRect& border)
- void SetLayoutFlexScale(const Vector2& scale)
- void SetIndent(int indent)
- void SetIndentSpacing(int indentSpacing)
- void UpdateLayout()
- void DisableLayoutUpdate()
- void EnableLayoutUpdate()
- void BringToFront()
- UIElement* CreateChild(const String type, const String name = String::EMPTY, unsigned index = M_MAX_UNSIGNED)
- void AddChild(UIElement* element)
- void InsertChild(unsigned index, UIElement* element)
- void RemoveChild(UIElement* element, unsigned index = 0)
- void RemoveChildAtIndex(unsigned index)
- void RemoveAllChildren()
- void Remove()
- unsigned FindChild(UIElement* element) const
- void SetParent(UIElement* parent, unsigned index = M_MAX_UNSIGNED)
- void SetVar(StringHash key, const Variant& value)
- void SetInternal(bool enable)
- void SetTraversalMode(TraversalMode traversalMode)
- void SetElementEventSender(bool flag)
- void AddTag(const String tag)
- void AddTags(const String tags, char separator)
- bool RemoveTag(const String tag)
- void RemoveAllTags()
- const String GetName() const
- const IntVector2& GetPosition() const
- const IntVector2& GetSize() const
- int GetWidth() const
- int GetHeight() const
- const IntVector2& GetMinSize() const
- int GetMinWidth() const
- int GetMinHeight() const
- const IntVector2& GetMaxSize() const
- int GetMaxWidth() const
- int GetMaxHeight() const
- bool IsFixedSize() const
- bool IsFixedWidth() const
- bool IsFixedHeight() const
- const IntVector2& GetChildOffset() const
- HorizontalAlignment GetHorizontalAlignment() const
- VerticalAlignment GetVerticalAlignment() const
- bool GetEnableAnchor() const
- const Vector2& GetMinAnchor() const
- const Vector2& GetMaxAnchor() const
- const IntVector2& GetMinOffset() const
- const IntVector2& GetMaxOffset() const
- const Vector2& GetPivot() const
- const IntRect& GetClipBorder() const
- const Color& GetColor(Corner corner) const
- int GetPriority() const
- float GetOpacity() const
- float GetDerivedOpacity() const
- bool GetBringToFront() const
- bool GetBringToBack() const
- bool GetClipChildren() const
- bool GetSortChildren() const
- bool GetUseDerivedOpacity() const
- bool HasFocus() const
- bool IsEnabled() const
- bool IsEnabledSelf() const
- bool IsEditable() const
- bool IsSelected() const
- bool IsVisible() const
- bool IsVisibleEffective() const
- bool IsHovering() const
- bool IsInternal() const
- bool HasColorGradient() const
- FocusMode GetFocusMode() const
- DragAndDropMode GetDragDropMode() const
- const String GetAppliedStyle() const
- XMLFile* GetDefaultStyle(bool recursiveUp = true) const
- LayoutMode GetLayoutMode() const
- int GetLayoutSpacing() const
- const IntRect& GetLayoutBorder() const
- const Vector2& GetLayoutFlexScale() const
- unsigned GetNumChildren(bool recursive = false) const
- int GetDragButtonCombo() const
- unsigned GetDragButtonCount() const
- UIElement* GetChild(const String name, bool recursive = false) const
- UIElement* GetChild(unsigned index) const
- bool IsChildOf(UIElement* element) const
- UIElement* GetParent() const
- UIElement* GetRoot() const
- const Color& GetDerivedColor() const
- const Variant& GetVar(StringHash key) const
- const VariantMap& GetVars() const
- bool HasTag(const String tag) const
- const StringVector& GetTags() const
- const PODVector<UIElement*>& GetChildrenWithTag(const String tag, bool recursive = false) const
- IntVector2 ScreenToElement(const IntVector2& screenPosition)
- IntVector2 ElementToScreen(const IntVector2& position)
- bool IsInside(IntVector2 position, bool isScreen)
- bool IsInsideCombined(IntVector2 position, bool isScreen)
- IntRect GetCombinedScreenRect()
- void SortChildren()
- int GetIndent() const
- int GetIndentSpacing() const
- int GetIndentWidth() const
- void SetChildOffset(const IntVector2& offset)
- void SetHovering(bool enable)
- const Color& GetColor() const
- TraversalMode GetTraversalMode() const
- bool IsElementEventSender() const
- UIElement* GetElementEventSender() const

### Properties


- IntVector2& screenPosition (readonly)
- String name
- IntVector2& position
- IntVector2 size
- int width
- int height
- IntVector2 minSize
- int minWidth
- int minHeight
- IntVector2 maxSize
- int maxWidth
- int maxHeight
- bool fixedSize (readonly)
- bool fixedWidth (readonly)
- bool fixedHeight (readonly)
- IntVector2& childOffset
- HorizontalAlignment horizontalAlignment
- VerticalAlignment verticalAlignment
- bool enableAnchor
- IntVector2& minOffset
- IntVector2& maxOffset
- Vector2& minAnchor
- Vector2& maxAnchor
- Vector2& pivot
- IntRect clipBorder
- Color& color
- int priority
- float opacity
- float derivedOpacity (readonly)
- bool bringToFront
- bool bringToBack
- bool clipChildren
- bool sortChildren
- bool useDerivedOpacity
- bool focus
- bool enabled
- bool enabledSelf (readonly)
- bool editable
- bool selected
- bool visible
- bool visibleEffective (readonly)
- bool hovering
- bool internal
- bool colorGradient (readonly)
- FocusMode focusMode
- DragAndDropMode dragDropMode
- String style
- XMLFile* defaultStyle
- LayoutMode layoutMode
- int layoutSpacing
- IntRect& layoutBorder
- Vector2& layoutFlexScale
- unsigned numChildren (readonly)
- UIElement* parent
- UIElement* root (readonly)
- Color& derivedColor (readonly)
- IntRect combinedScreenRect (readonly)
- int indent
- int indentSpacing
- int indentWidth (readonly)
- TraversalMode traversalMode
- bool elementEventSender



---

**Inherits from**: Component

## UIComponent : Component


### Methods


- UIComponent() (GC)
- UIComponent* new()
- UIElement* GetRoot() const
- Material* GetMaterial() const
- Texture2D* GetTexture() const

### Properties


- UIElement* root (readonly)
- Material* material (readonly)
- Texture2D* texture (readonly)



---

**Inherits from**: UIElement

## UISelectable : UIElement


### Methods


- UISelectable() (GC)
- UISelectable* new()
- void delete()
- void SetSelectionColor(const Color& color)
- void SetHoverColor(const Color& color)
- const Color& GetSelectionColor() const
- const Color& GetHoverColor() const

### Properties


- Color& selectionColor
- Color& hoverColor



---

**Inherits from**: UIElement

## BorderImage : UIElement


### Methods


- BorderImage() (GC)
- BorderImage* new()
- void delete()
- void SetTexture(Texture* texture)
- void SetImageRect(const IntRect& rect)
- void SetFullImageRect()
- void SetBorder(const IntRect& rect)
- void SetImageBorder(const IntRect& rect)
- void SetHoverOffset(const IntVector2& offset)
- void SetHoverOffset(int x, int y)
- void SetBlendMode(BlendMode mode)
- void SetTiled(bool enable)
- Texture* GetTexture() const
- const IntRect& GetImageRect() const
- const IntRect& GetBorder() const
- const IntRect& GetImageBorder() const
- const IntVector2& GetHoverOffset() const
- BlendMode GetBlendMode() const
- bool IsTiled() const

### Properties


- Texture* texture
- IntRect& imageRect
- IntRect& border
- IntRect& imageBorder
- IntVector2& hoverOffset
- BlendMode blendMode
- bool tiled



---

**Inherits from**: UIElement

## Sprite : UIElement


### Methods


- Sprite() (GC)
- Sprite* new()
- void delete()
- void SetPosition(const Vector2& position)
- void SetPosition(float x, float y)
- void SetHotSpot(const IntVector2& hotSpot)
- void SetHotSpot(int x, int y)
- void SetScale(const Vector2& scale)
- void SetScale(float x, float y)
- void SetScale(float scale)
- void SetRotation(float angle)
- void SetTexture(Texture* texture)
- void SetImageRect(const IntRect& rect)
- void SetFullImageRect()
- void SetBlendMode(BlendMode mode)
- const Vector2& GetPosition() const
- const IntVector2& GetHotSpot() const
- const Vector2& GetScale() const
- float GetRotation() const
- Texture* GetTexture() const
- const IntRect& GetImageRect() const
- BlendMode GetBlendMode() const
- const Matrix3x4& GetTransform() const

### Properties


- Vector2& position
- IntVector2& hotSpot
- Vector2& scale
- float rotation
- Texture* texture
- IntRect& imageRect
- BlendMode blendMode
- Matrix3x4& transform (readonly)



---

**Inherits from**: BorderImage

## Button : BorderImage


### Methods


- Button() (GC)
- Button* new()
- void delete()
- void SetPressedOffset(const IntVector2& offset)
- void SetPressedOffset(int x, int y)
- void SetDisabledOffset(const IntVector2& offset)
- void SetDisabledOffset(int x, int y)
- void SetPressedChildOffset(const IntVector2& offset)
- void SetPressedChildOffset(int x, int y)
- void SetRepeat(float delay, float rate)
- void SetRepeatDelay(float delay)
- void SetRepeatRate(float rate)
- const IntVector2& GetPressedOffset() const
- const IntVector2& GetDisabledOffset() const
- const IntVector2& GetPressedChildOffset() const
- float GetRepeatDelay() const
- float GetRepeatRate() const
- bool IsPressed() const

### Properties


- IntVector2& pressedOffset
- IntVector2& disabledOffset
- IntVector2& pressedChildOffset
- float repeatDelay
- float repeatRate
- bool pressed (readonly)



---

**Inherits from**: BorderImage

## CheckBox : BorderImage


### Methods


- CheckBox() (GC)
- CheckBox* new()
- void delete()
- void SetChecked(bool enable)
- void SetCheckedOffset(const IntVector2& rect)
- void SetCheckedOffset(int x, int y)
- bool IsChecked() const
- const IntVector2& GetCheckedOffset() const

### Properties


- bool checked
- IntVector2& checkedOffset



---

**Inherits from**: BorderImage

## Slider : BorderImage


### Methods


- Slider() (GC)
- Slider* new()
- void delete()
- void SetOrientation(Orientation orientation)
- void SetRange(float range)
- void SetValue(float value)
- void ChangeValue(float delta)
- void SetRepeatRate(float rate)
- Orientation GetOrientation() const
- float GetRange() const
- float GetValue() const
- BorderImage* GetKnob() const
- float GetRepeatRate() const

### Properties


- Orientation orientation
- float range
- float value
- BorderImage* knob (readonly)
- float repeatRate



---

**Inherits from**: BorderImage

## ScrollBar : BorderImage


### Methods


- ScrollBar() (GC)
- ScrollBar* new()
- void delete()
- void SetOrientation(Orientation orientation)
- void SetRange(float range)
- void SetValue(float value)
- void ChangeValue(float delta)
- void SetScrollStep(float step)
- void SetStepFactor(float factor)
- void StepBack()
- void StepForward()
- Orientation GetOrientation() const
- float GetRange() const
- float GetValue() const
- float GetScrollStep() const
- float GetStepFactor() const
- float GetEffectiveScrollStep() const
- Button* GetBackButton() const
- Button* GetForwardButton() const
- Slider* GetSlider() const

### Properties


- Orientation orientation
- float range
- float value
- float scrollStep
- float stepFactor
- float effectiveScrollStep (readonly)
- Button* backButton (readonly)
- Button* forwardButton (readonly)
- Slider* slider (readonly)



---

**Inherits from**: UIElement

## ScrollView : UIElement


### Methods


- ScrollView() (GC)
- ScrollView* new()
- void delete()
- void SetContentElement(UIElement* element)
- void SetViewPosition(const IntVector2& position)
- void SetViewPosition(int x, int y)
- void SetScrollBarsVisible(bool horizontal, bool vertical)
- void SetScrollBarsAutoVisible(bool enable)
- void SetScrollStep(float step)
- void SetPageStep(float step)
- void SetScrollDeceleration(float deceleration)
- void SetScrollSnapEpsilon(float snap)
- void SetAutoDisableChildren(bool disable)
- void SetAutoDisableThreshold(float amount)
- const IntVector2& GetViewPosition() const
- UIElement* GetContentElement() const
- ScrollBar* GetHorizontalScrollBar() const
- ScrollBar* GetVerticalScrollBar() const
- BorderImage* GetScrollPanel() const
- bool GetScrollBarsAutoVisible() const
- float GetScrollStep() const
- float GetPageStep() const
- float GetScrollDeceleration() const
- float GetScrollSnapEpsilon() const
- bool GetAutoDisableChildren() const
- float GetAutoDisableThreshold() const

### Properties


- IntVector2& viewPosition
- UIElement* contentElement
- ScrollBar* horizontalScrollBar (readonly)
- ScrollBar* verticalScrollBar (readonly)
- BorderImage* scrollPanel (readonly)
- bool scrollBarsAutoVisible
- bool horizontalScrollBarVisible
- bool verticalScrollBarVisible
- float scrollStep
- float pageStep
- float scrollDeceleration
- float scrollSnapEpsilon



---

**Inherits from**: ScrollView

## ListView : ScrollView


### Methods


- ListView() (GC)
- ListView* new()
- void delete()
- void UpdateInternalLayout()
- void DisableInternalLayoutUpdate()
- void EnableInternalLayoutUpdate()
- void AddItem(UIElement* item)
- void InsertItem(unsigned index, UIElement* item, UIElement* parentItem = 0)
- void RemoveItem(UIElement* item, unsigned index = 0)
- void RemoveItem(unsigned index)
- void RemoveAllItems()
- void SetSelection(unsigned index)
- void SetSelections(const PODVector<unsigned>& indices)
- void AddSelection(unsigned index)
- void RemoveSelection(unsigned index)
- void ToggleSelection(unsigned index)
- void ChangeSelection(int delta, bool additive = false)
- void ClearSelection()
- void SetHighlightMode(HighlightMode mode)
- void SetMultiselect(bool enable)
- void SetHierarchyMode(bool enable)
- void SetBaseIndent(int baseIndent)
- void SetClearSelectionOnDefocus(bool enable)
- void SetSelectOnClickEnd(bool enable)
- void Expand(unsigned index, bool enable, bool recursive = false)
- void ToggleExpand(unsigned index, bool recursive = false)
- unsigned GetNumItems() const
- UIElement* GetItem(unsigned index) const
- const PODVector<UIElement*>& GetItems() const
- unsigned FindItem(UIElement* item) const
- unsigned GetSelection() const
- const PODVector<unsigned>& GetSelections() const
- void CopySelectedItemsToClipboard() const
- UIElement* GetSelectedItem() const
- const PODVector<UIElement*>& GetSelectedItems() const
- bool IsSelected(unsigned index) const
- bool IsExpanded(unsigned index) const
- HighlightMode GetHighlightMode() const
- bool GetMultiselect() const
- bool GetClearSelectionOnDefocus() const
- bool GetSelectOnClickEnd() const
- bool GetHierarchyMode() const
- int GetBaseIndent() const

### Properties


- unsigned numItems (readonly)
- unsigned selection
- UIElement* selectedItem (readonly)
- HighlightMode highlightMode
- bool multiselect
- bool clearSelectionOnDefocus
- bool selectOnClickEnd
- bool hierarchyMode
- int baseIndent



---

**Inherits from**: UISelectable

## Text : UISelectable


### Methods


- Text() (GC)
- Text* new()
- void delete()
- bool SetFont(const String fontName, float size = DEFAULT_FONT_SIZE)
- bool SetFont(Font* font, float size = DEFAULT_FONT_SIZE)
- bool SetFontSize(float size)
- void SetText(const String text)
- void SetTextAlignment(HorizontalAlignment align)
- void SetRowSpacing(float spacing)
- void SetWordwrap(bool enable)
- void SetSelection(unsigned start, unsigned length = M_MAX_UNSIGNED)
- void ClearSelection()
- void SetTextEffect(TextEffect textEffect)
- void SetEffectShadowOffset(const IntVector2& offset)
- void SetEffectStrokeThickness(int thickness)
- void SetEffectRoundStroke(bool roundStroke)
- void SetEffectColor(const Color& effectColor)
- bool GetAutoLocalizable() const
- void SetAutoLocalizable(bool enable)
- Font* GetFont() const
- float GetFontSize() const
- const String GetText() const
- HorizontalAlignment GetTextAlignment() const
- float GetRowSpacing() const
- bool GetWordwrap() const
- unsigned GetSelectionStart() const
- unsigned GetSelectionLength() const
- TextEffect GetTextEffect() const
- const IntVector2& GetEffectShadowOffset() const
- int GetEffectStrokeThickness() const
- bool GetEffectRoundStroke() const
- const Color& GetEffectColor() const
- float GetRowHeight() const
- unsigned GetNumRows() const
- unsigned GetNumChars() const
- float GetRowWidth(unsigned index) const
- Vector2 GetCharPosition(unsigned index)
- Vector2 GetCharSize(unsigned index)
- void SetEffectDepthBias(float bias)
- float GetEffectDepthBias() const

### Properties


- Font* font
- float fontSize
- String text
- HorizontalAlignment textAlignment
- float rowSpacing
- bool wordwrap
- bool autoLocalizable
- unsigned selectionStart (readonly)
- unsigned selectionLength (readonly)
- TextEffect textEffect
- IntVector2& effectShadowOffset
- int effectStrokeThickness
- bool effectRoundStroke
- Color& effectColor
- float rowHeight (readonly)
- unsigned numRows (readonly)
- unsigned numChars (readonly)



---

**Inherits from**: Drawable

## Text3D : Drawable


### Methods


- Text3D() (GC)
- Text3D* new()
- void delete()
- bool SetFont(const String fontName, float size = DEFAULT_FONT_SIZE)
- bool SetFont(Font* font, float size = DEFAULT_FONT_SIZE)
- bool SetFontSize(float size)
- void SetMaterial(Material* material)
- void SetText(const String text)
- void SetAlignment(HorizontalAlignment hAlign, VerticalAlignment vAlign)
- void SetHorizontalAlignment(HorizontalAlignment align)
- void SetVerticalAlignment(VerticalAlignment align)
- void SetTextAlignment(HorizontalAlignment align)
- void SetRowSpacing(float spacing)
- void SetWordwrap(bool enable)
- void SetTextEffect(TextEffect textEffect)
- void SetEffectShadowOffset(const IntVector2& offset)
- void SetEffectStrokeThickness(int thickness)
- void SetEffectRoundStroke(bool roundStroke)
- void SetEffectColor(const Color& effectColor)
- void SetEffectDepthBias(float bias)
- void SetWidth(int width)
- void SetColor(const Color& color)
- void SetColor(Corner corner, const Color& color)
- void SetOpacity(float opacity)
- void SetFixedScreenSize(bool enable)
- void SetFaceCameraMode(FaceCameraMode mode)
- Font* GetFont() const
- Material* GetMaterial() const
- float GetFontSize() const
- const String GetText() const
- HorizontalAlignment GetTextAlignment() const
- HorizontalAlignment GetHorizontalAlignment() const
- VerticalAlignment GetVerticalAlignment() const
- float GetRowSpacing() const
- bool GetWordwrap() const
- TextEffect GetTextEffect() const
- const IntVector2& GetEffectShadowOffset() const
- int GetEffectStrokeThickness() const
- bool GetEffectRoundStroke() const
- const Color& GetEffectColor() const
- float GetEffectDepthBias() const
- int GetWidth() const
- int GetHeight() const
- float GetRowHeight() const
- unsigned GetNumRows() const
- unsigned GetNumChars() const
- float GetRowWidth(unsigned index) const
- Vector2 GetCharPosition(unsigned index)
- Vector2 GetCharSize(unsigned index)
- const Color& GetColor(Corner corner) const
- float GetOpacity() const
- bool IsFixedScreenSize() const
- FaceCameraMode GetFaceCameraMode() const

### Properties


- Font* font
- Material* material
- float fontSize
- String text
- HorizontalAlignment textAlignment
- HorizontalAlignment horizontalAlignment
- VerticalAlignment verticalAlignment
- float rowSpacing
- bool wordwrap
- TextEffect textEffect
- IntVector2& effectShadowOffset
- int effectStrokeThickness
- bool effectRoundStroke
- Color& effectColor
- float effectDepthBias
- int width
- Color& color
- int height (readonly)
- float rowHeight (readonly)
- unsigned numRows (readonly)
- unsigned numChars (readonly)
- float opacity
- bool fixedScreenSize
- FaceCameraMode faceCameraMode



---

**Inherits from**: BorderImage

## LineEdit : BorderImage


### Methods


- LineEdit() (GC)
- LineEdit* new()
- void delete()
- void SetText(const String text)
- void SetCursorPosition(unsigned position)
- void SetCursorBlinkRate(float rate)
- void SetMaxLength(unsigned length)
- void SetEchoCharacter(unsigned c)
- void SetCursorMovable(bool enable)
- void SetTextSelectable(bool enable)
- void SetTextCopyable(bool enable)
- const String GetText() const
- unsigned GetCursorPosition() const
- float GetCursorBlinkRate() const
- unsigned GetMaxLength() const
- unsigned GetEchoCharacter() const
- bool IsCursorMovable() const
- bool IsTextSelectable() const
- bool IsTextCopyable() const
- Text* GetTextElement() const
- BorderImage* GetCursor() const

### Properties


- String text
- unsigned cursorPosition
- float cursorBlinkRate
- unsigned maxLength
- unsigned echoCharacter
- bool cursorMovable
- bool textSelectable
- bool textCopyable
- Text* textElement (readonly)
- BorderImage* cursor (readonly)



---

**Inherits from**: Menu

## DropDownList : Menu


### Methods


- DropDownList() (GC)
- DropDownList* new()
- void delete()
- void AddItem(UIElement* item)
- void InsertItem(unsigned index, UIElement* item)
- void RemoveItem(UIElement* item)
- void RemoveItem(unsigned index)
- void RemoveAllItems()
- void SetSelection(unsigned index)
- void SetPlaceholderText(const String text)
- void SetResizePopup(bool enable)
- unsigned GetNumItems() const
- UIElement* GetItem(unsigned index) const
- const PODVector<UIElement*>& GetItems() const
- unsigned GetSelection() const
- UIElement* GetSelectedItem() const
- ListView* GetListView() const
- UIElement* GetPlaceholder() const
- const String GetPlaceholderText() const
- bool GetResizePopup() const

### Properties


- unsigned numItems (readonly)
- unsigned selection
- UIElement* selectedItem (readonly)
- ListView* listView (readonly)
- UIElement* placeholder (readonly)
- String placeholderText
- bool resizePopup



---

**Inherits from**: BorderImage

## Window : BorderImage


### Methods


- Window() (GC)
- Window* new()
- void delete()
- void SetMovable(bool enable)
- void SetResizable(bool enable)
- void SetFixedWidthResizing(bool enable)
- void SetFixedHeightResizing(bool enable)
- void SetResizeBorder(const IntRect& rect)
- void SetModal(bool modal)
- void SetModalShadeColor(const Color& color)
- void SetModalFrameColor(const Color& color)
- void SetModalFrameSize(const IntVector2& size)
- void SetModalAutoDismiss(bool enable)
- bool IsMovable() const
- bool IsResizable() const
- bool GetFixedWidthResizing() const
- bool GetFixedHeightResizing() const
- const IntRect& GetResizeBorder() const
- bool IsModal() const
- const Color& GetModalShadeColor() const
- const Color& GetModalFrameColor() const
- const IntVector2& GetModalFrameSize() const
- bool GetModalAutoDismiss() const

### Properties


- bool movable
- bool resizable
- bool fixedWidthResizing
- bool fixedHeightResizing
- IntRect& resizeBorder
- bool modal
- Color& modalShadeColor
- Color& modalFrameColor
- IntVector2& modalFrameSize
- bool modalAutoDismiss



---

**Inherits from**: Window

## View3D : Window


### Methods


- View3D() (GC)
- View3D* new()
- void delete()
- void SetView(Scene* scene, Camera* camera, bool ownScene = true)
- void SetFormat(unsigned format)
- void SetAutoUpdate(bool enable)
- void QueueUpdate()
- unsigned GetFormat() const
- bool GetAutoUpdate() const
- Scene* GetScene() const
- Node* GetCameraNode() const
- Texture2D* GetRenderTexture() const
- Texture2D* GetDepthTexture() const
- Viewport* GetViewport() const

### Properties


- unsigned format
- bool autoUpdate



---

**Inherits from**: BorderImage

## ProgressBar : BorderImage


### Methods


- ProgressBar() (GC)
- ProgressBar* new()
- void delete()
- void SetOrientation(Orientation orientation)
- void SetRange(float range)
- void SetValue(float value)
- void ChangeValue(float delta)
- void SetLoadingPercentStyle(const String style)
- void SetShowPercentText(bool showPercentText)
- Orientation GetOrientation() const
- float GetRange() const
- float GetValue() const
- BorderImage* GetKnob() const
- const String GetLoadingPercentStyle()
- bool GetShowPercentText() const

### Properties


- Orientation orientation
- float range
- float value
- BorderImage* knob (readonly)
- String loadingPercentStyle (readonly)
- bool showPercentText



---

**Inherits from**: UIElement

## ToolTip : UIElement


### Methods


- ToolTip() (GC)
- ToolTip* new()
- void delete()
- void SetDelay(float delay)
- float GetDelay() const

### Properties


- float delay



---

**Inherits from**: Button

## Menu : Button


### Methods


- Menu() (GC)
- Menu* new()
- void delete()
- void SetPopup(UIElement* element)
- void SetPopupOffset(const IntVector2& offset)
- void SetPopupOffset(int x, int y)
- void ShowPopup(bool enable)
- void SetAccelerator(int key, int qualifiers)
- UIElement* GetPopup() const
- const IntVector2& GetPopupOffset() const
- bool GetShowPopup() const
- int GetAcceleratorKey() const
- int GetAcceleratorQualifiers() const

### Properties


- UIElement* popup
- IntVector2& popupOffset
- bool showPopup
- int acceleratorKey (readonly)
- int acceleratorQualifiers (readonly)



---

**Inherits from**: BorderImage

## Cursor : BorderImage


### Methods


- Cursor() (GC)
- Cursor* new()
- void delete()
- void DefineShape(const String shape, Image* image, const IntRect& imageRect, const IntVector2& hotSpot)
- void DefineShape(CursorShape shape, Image* image, const IntRect& imageRect, const IntVector2& hotSpot)
- void SetShape(CursorShape shape)
- void SetShape(const String shape)
- void SetUseSystemShapes(bool enable)
- String GetShape() const
- bool GetUseSystemShapes() const

### Properties


- String shape
- bool useSystemShapes



---

**Inherits from**: Object

## MessageBox : Object


### Methods


- MessageBox(const String messageString = String::EMPTY, const String titleString = String::EMPTY, XMLFile* layoutFile = 0, XMLFile* styleFile = 0) (GC)
- MessageBox* new(const String messageString = String::EMPTY, const String titleString = String::EMPTY, XMLFile* layoutFile = 0, XMLFile* styleFile = 0)
- void delete()
- void SetTitle(const String text)
- void SetMessage(const String text)
- const String GetTitle() const
- const String GetMessage() const
- UIElement* GetWindow() const

### Properties


- String title
- String message
- UIElement* window (readonly)



---

**Inherits from**: Object

## FileSelector : Object


### Methods


- FileSelector() (GC)
- FileSelector* new()
- void delete()
- void SetDefaultStyle(XMLFile* style)
- void SetTitle(const String text)
- void SetButtonTexts(const String okText, const String cancelText)
- void SetPath(const String path)
- void SetFileName(const String fileName)
- void SetFilters(const Vector<String>& filters, unsigned defaultIndex)
- void SetDirectoryMode(bool enable)
- void UpdateElements()
- XMLFile* GetDefaultStyle() const
- Window* GetWindow() const
- Text* GetTitleText() const
- ListView* GetFileList() const
- LineEdit* GetPathEdit() const
- LineEdit* GetFileNameEdit() const
- DropDownList* GetFilterList() const
- Button* GetOKButton() const
- Button* GetCancelButton() const
- Button* GetCloseButton() const
- const String GetTitle() const
- const String GetPath() const
- const String GetFileName() const
- const String GetFilter() const
- unsigned GetFilterIndex() const
- bool GetDirectoryMode() const

### Properties


- XMLFile* defaultStyle
- Window* window (readonly)
- Text* titleText (readonly)
- ListView* fileList (readonly)
- LineEdit* pathEdit (readonly)
- LineEdit* fileNameEdit (readonly)
- DropDownList* filterList (readonly)
- Button* OKButton (readonly)
- Button* cancelButton (readonly)
- Button* closeButton (readonly)
- String title
- String path
- String fileName
- String filter (readonly)
- unsigned filterIndex (readonly)
- bool directoryMode



---

## FileSelectorEntry



### Properties


- String name
- bool directory



---

**Inherits from**: UIElement

## HierarchyContainer : UIElement




---

