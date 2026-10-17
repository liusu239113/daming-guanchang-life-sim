# Graphics Module (2D)

UrhoX Lua API - Graphics Module (2D)

---

## Classes

- [Drawable2D](#drawable2d)
- [Sprite2D](#sprite2d)
- [SpriteSheet2D](#spritesheet2d)
- [StaticSprite2D](#staticsprite2d)
- [AnimatedSprite2D](#animatedsprite2d)
- [StretchableSprite2D](#stretchablesprite2d)
- [AnimationSet2D](#animationset2d)
- [ParticleEffect2D](#particleeffect2d)
- [ParticleEmitter2D](#particleemitter2d)
- [TileMap2D](#tilemap2d)
- [TileMapLayer2D](#tilemaplayer2d)
- [TileMapInfo2D](#tilemapinfo2d)
- [Tile2D](#tile2d)
- [TileMapObject2D](#tilemapobject2d)
- [TmxFile2D](#tmxfile2d)
- [PropertySet2D](#propertyset2d)

---

**Inherits from**: Drawable

## Drawable2D : Drawable


### Methods


- void SetLayer(int layer)
- void SetOrderInLayer(int orderInLayer)
- int GetLayer() const
- int GetOrderInLayer() const

### Properties


- int layer
- int orderInLayer



---

**Inherits from**: Resource

## Sprite2D : Resource


### Methods


- void SetTexture(Texture2D* texture)
- void SetRectangle(const IntRect& rectangle)
- void SetHotSpot(const Vector2& hotSpot)
- void SetOffset(const IntVector2& offset)
- void SetTextureEdgeOffset(float offset)
- void SetSpriteSheet(SpriteSheet2D* spriteSheet)
- Texture2D* GetTexture() const
- const IntRect& GetRectangle() const
- const Vector2& GetHotSpot() const
- const IntVector2& GetOffset() const
- float GetTextureEdgeOffset() const
- SpriteSheet2D* GetSpriteSheet() const

### Properties


- Texture2D* texture
- IntRect rectangle
- Vector2 hotSpot
- IntVector2 offset
- float textureEdgeOffset
- SpriteSheet2D* spriteSheet



---

**Inherits from**: Resource

## SpriteSheet2D : Resource


### Methods


- void SetTexture(Texture2D* texture)
- Texture2D* GetTexture() const
- Sprite2D* GetSprite(const String name) const
- void DefineSprite(const String name, const IntRect& rectangle)
- void DefineSprite(const String name, const IntRect& rectangle, const Vector2& hotSpot)
- void DefineSprite(const String name, const IntRect& rectangle, const Vector2& hotSpot, const IntVector2& originSize)

### Properties


- Texture2D* texture



---

**Inherits from**: Drawable2D

## StaticSprite2D : Drawable2D


### Methods


- void SetSprite(Sprite2D* sprite)
- void SetBlendMode(BlendMode mode)
- void SetFlip(bool flipX, bool flipY, bool swapXY = false)
- void SetFlipX(bool flipX)
- void SetFlipY(bool flipY)
- void SetSwapXY(bool swapXY)
- void SetColor(const Color& color)
- void SetAlpha(float alpha)
- void SetUseHotSpot(bool useHotSpot)
- void SetHotSpot(const Vector2& hotspot)
- void SetUseDrawRect(bool useDrawRect)
- void SetDrawRect(const Rect& rect)
- void SetUseTextureRect(bool useTextureRect)
- void SetTextureRect(const Rect& rect)
- void SetCustomMaterial(Material* customMaterial)
- Sprite2D* GetSprite() const
- BlendMode GetBlendMode() const
- bool GetFlipX() const
- bool GetFlipY() const
- bool GetSwapXY() const
- const Color& GetColor() const
- float GetAlpha() const
- bool GetUseHotSpot() const
- const Vector2& GetHotSpot() const
- bool GetUseDrawRect() const
- const Rect& GetDrawRect() const
- bool GetUseTextureRect() const
- const Rect& GetTextureRect() const
- Material* GetCustomMaterial() const

### Properties


- Sprite2D* sprite
- BlendMode blendMode
- bool flipX
- bool flipY
- bool swapXY
- Color& color
- float alpha
- bool useHotSpot
- Vector2 hotSpot
- Material* customMaterial
- Rect drawRect
- bool useDrawRect
- Rect textureRect
- bool useTextureRect



---

**Inherits from**: StaticSprite2D

## AnimatedSprite2D : StaticSprite2D


### Methods


- void SetAnimationSet(AnimationSet2D* animationSet)
- void SetEntity(const String entity)
- void SetAnimation(const String name, LoopMode2D loopMode = LM_DEFAULT)
- void SetLoopMode(LoopMode2D loopMode)
- void SetSpeed(float speed)
- AnimationSet2D* GetAnimationSet() const
- const String GetEntity() const
- const String GetAnimation() const
- LoopMode2D GetLoopMode() const
- float GetSpeed() const

### Properties


- float speed
- String entity
- String animation
- AnimationSet2D* animationSet
- LoopMode2D loopMode



---

**Inherits from**: StaticSprite2D

## StretchableSprite2D : StaticSprite2D


### Methods


- void SetBorder(const IntRect& border)
- const IntRect& GetBorder() const

### Properties


- IntRect border



---

**Inherits from**: Resource

## AnimationSet2D : Resource


### Methods


- unsigned GetNumAnimations() const
- String GetAnimation(unsigned index) const

### Properties


- unsigned numAnimations (readonly)



---

**Inherits from**: Resource

## ParticleEffect2D : Resource


### Methods


- ParticleEffect2D* Clone(const String cloneName = String::EMPTY) const



---

**Inherits from**: Drawable2D

## ParticleEmitter2D : Drawable2D


### Methods


- void SetEffect(ParticleEffect2D* effect)
- void SetSprite(Sprite2D* sprite)
- void SetBlendMode(BlendMode blendMode)
- void SetEmitting(bool emitting)
- ParticleEffect2D* GetEffect() const
- Sprite2D* GetSprite() const
- BlendMode GetBlendMode() const
- bool IsEmitting() const

### Properties


- ParticleEffect2D* effect
- Sprite2D* sprite
- BlendMode blendMode
- bool emitting



---

**Inherits from**: Component

## TileMap2D : Component


### Methods


- void SetTmxFile(TmxFile2D* tmxFile)
- TmxFile2D* GetTmxFile() const
- const TileMapInfo2D& GetInfo() const
- unsigned GetNumLayers() const
- TileMapLayer2D* GetLayer(unsigned index) const
- Vector2 TileIndexToPosition(int x, int y) const
- bool PositionToTileIndex(const Vector2& position, int x = 0, int y = 0) const

### Properties


- TmxFile2D* tmxFile
- TileMapInfo2D& info (readonly)
- unsigned numLayers (readonly)



---

**Inherits from**: Component

## TileMapLayer2D : Component


### Methods


- void SetDrawOrder(int drawOrder)
- void SetVisible(bool visible)
- int GetDrawOrder() const
- bool IsVisible() const
- bool HasProperty(const String name) const
- const String GetProperty(const String name) const
- TileMapLayerType2D GetLayerType() const
- int GetWidth() const
- int GetHeight() const
- Node* GetTileNode(int x, int y) const
- Tile2D* GetTile(int x, int y) const
- unsigned GetNumObjects() const
- TileMapObject2D* GetObject(unsigned index) const
- Node* GetObjectNode(unsigned index) const
- Node* GetImageNode() const

### Properties


- int drawOrder (readonly)
- bool visible (readonly)
- TileMapLayerType2D layerType (readonly)
- int width (readonly)
- int height (readonly)
- unsigned numObjects (readonly)
- Node* imageNode (readonly)



---

## TileMapInfo2D



### Methods


- float GetMapWidth() const
- float GetMapHeight() const

### Properties


- Orientation2D orientation
- int width
- int height
- float tileWidth
- float tileHeight
- float mapWidth (readonly)
- float mapHeight (readonly)



---

## Tile2D



### Methods


- unsigned GetGid() const
- bool GetFlipX() const
- bool GetFlipY() const
- bool GetSwapXY() const
- Sprite2D* GetSprite() const
- bool HasProperty(const String name) const
- const String GetProperty(const String name) const

### Properties


- unsigned gid (readonly)
- Sprite2D* sprite (readonly)



---

## TileMapObject2D



### Methods


- TileMapObjectType2D GetObjectType() const
- const String GetName() const
- const String GetType() const
- const Vector2& GetPosition() const
- const Vector2& GetSize() const
- unsigned GetNumPoints() const
- const Vector2& GetPoint(unsigned index) const
- unsigned GetTileGid() const
- bool GetTileFlipX() const
- bool GetTileFlipY() const
- bool GetTileSwapXY() const
- Sprite2D* GetTileSprite() const
- bool HasProperty(const String name) const
- const String GetProperty(const String name) const

### Properties


- TileMapObjectType2D objectType (readonly)
- String name (readonly)
- String type (readonly)
- Vector2 position (readonly)
- Vector2 size (readonly)
- unsigned numPoints (readonly)
- unsigned tileGid (readonly)
- Sprite2D* tileSprite (readonly)



---

**Inherits from**: Resource

## TmxFile2D : Resource


### Methods


- void SetSpriteTextureEdgeOffset(float offset)
- float GetSpriteTextureEdgeOffset() const

### Properties


- float edgeOffset



---

## PropertySet2D



### Methods


- bool HasProperty(const String name) const
- const String GetProperty(const String name) const



---

