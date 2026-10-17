# Resource Management

UrhoX Lua API - Resource Management

---

## Classes

- [ResourceCache](#resourcecache)
- [Resource](#resource)
- [ResourceWithMetadata](#resourcewithmetadata)
- [ResourceRef](#resourceref)
- [ResourceRefList](#resourcereflist)
- [Image](#image)
- [Font](#font)

---

## ResourceCache



### Methods


- void ReleaseAllResources(bool force = false)
- bool ReloadResource(Resource* resource)
- void ReloadResourceWithDependencies(const String fileName)
- void SetMemoryBudget(StringHash type, long budget)
- void SetMemoryBudget(const String type, long budget)
- void SetAutoReloadResources(bool enable)
- void SetReturnFailedResources(bool enable)
- void SetSearchPackagesFirst(bool value)
- void SetFinishBackgroundResourcesMs(int ms)
- File* GetFile(const String name)
- Resource* GetResource(const String type, const String name, bool sendEventOnFailure = true)
- Resource* GetExistingResource(const String type, const String name)
- bool BackgroundLoadResource(const String type, const String name, bool sendEventOnFailure = true)
- unsigned GetNumBackgroundLoadResources() const
- const Vector<String>& GetResourceDirs() const
- bool Exists(const String name) const
- long GetMemoryBudget(StringHash type) const
- long GetMemoryUse(StringHash type) const
- long GetTotalMemoryUse() const
- String GetResourceFileName(const String name) const
- bool GetAutoReloadResources() const
- bool GetReturnFailedResources() const
- bool GetSearchPackagesFirst() const
- int GetFinishBackgroundResourcesMs() const
- String GetPreferredResourceDir(const String path) const
- String SanitateResourceName(const String name) const
- String SanitateResourceDirName(const String name) const

### Properties


- long totalMemoryUse (readonly)
- bool autoReloadResources
- bool returnFailedResources
- bool searchPackagesFirst
- unsigned numBackgroundLoadResources (readonly)
- Vector<String>& resourceDirs (readonly)
- int finishBackgroundResourcesMs



---

## Resource



### Methods


- bool Load(Deserializer& source)
- bool Save(Serializer& dest) const
- bool Load(const String fileName)
- bool Save(const String fileName) const
- const String GetName() const
- StringHash GetNameHash() const
- unsigned GetMemoryUse() const

### Properties


- String name (readonly)
- StringHash nameHash (readonly)
- unsigned memoryUse (readonly)



---

**Inherits from**: Resource

## ResourceWithMetadata : Resource


### Methods


- void AddMetadata(const String name, const Variant& value)
- void RemoveMetadata(const String name)
- void RemoveAllMetadata()
- const Variant& GetMetadata(const String name) const
- bool HasMetadata() const



---

## ResourceRef



### Methods


- ResourceRef() (GC)
- ResourceRef* new()
- ResourceRef(StringHash type) (GC)
- ResourceRef* new(StringHash type)
- ResourceRef(StringHash type, String name) (GC)
- ResourceRef* new(StringHash type, String name)
- ResourceRef(String type, String name) (GC)
- ResourceRef* new(String type, String name)
- ResourceRef(const ResourceRef& rhs) (GC)
- ResourceRef* new(const ResourceRef& rhs)
- void delete()
- bool operator==(const ResourceRef& rhs) const

### Properties


- StringHash type
- String name



---

## ResourceRefList



### Methods


- ResourceRefList() (GC)
- ResourceRefList* new()
- ResourceRefList(StringHash type) (GC)
- ResourceRefList* new(StringHash type)
- void delete()
- bool operator==(const ResourceRefList& rhs) const

### Properties


- StringHash type



---

**Inherits from**: Resource

## Image : Resource


### Methods


- Image() (GC)
- Image* new()
- void delete()
- bool SetSize(int width, int height, unsigned components)
- bool SetSize(int width, int height, int depth, unsigned components)
- void SetPixel(int x, int y, const Color& color)
- void SetPixel(int x, int y, int z, const Color& color)
- void SetPixelInt(int x, int y, unsigned uintColor)
- void SetPixelInt(int x, int y, int z, unsigned uintColor)
- bool LoadColorLUT(Deserializer& source)
- bool LoadColorLUT(const String fileName)
- bool FlipHorizontal()
- bool FlipVertical()
- bool Resize(int width, int height)
- void Clear(const Color& color)
- void ClearInt(unsigned uintColor)
- bool SaveBMP(const String fileName) const
- bool SavePNG(const String fileName) const
- bool SaveTGA(const String fileName) const
- bool SaveJPG(const String fileName, int quality) const
- bool SaveDDS(const String fileName) const
- bool SaveWEBP(const String fileName, float compression = 0.0f) const
- Color GetPixel(int x, int y) const
- Color GetPixel(int x, int y, int z) const
- unsigned GetPixelInt(int x, int y) const
- unsigned GetPixelInt(int x, int y, int z) const
- Color GetPixelBilinear(float x, float y) const
- Color GetPixelTrilinear(float x, float y, float z) const
- int GetWidth() const
- int GetHeight() const
- int GetDepth() const
- unsigned GetComponents() const
- bool IsCompressed() const
- CompressedFormat GetCompressedFormat() const
- unsigned GetNumCompressedLevels() const
- Image* GetSubimage(const IntRect& rect) const
- bool SetSubimage(const Image* image, const IntRect rect)
- bool IsCubemap() const
- bool IsArray() const
- bool IsSRGB() const
- bool HasAlphaChannel() const

### Properties


- int width (readonly)
- int height (readonly)
- int depth (readonly)
- unsigned components (readonly)
- bool compressed (readonly)
- CompressedFormat compressedFormat (readonly)
- unsigned numCompressedLevels (readonly)
- bool cubemap (readonly)
- bool array (readonly)
- bool sRGB (readonly)



---

**Inherits from**: Resource

## Font : Resource


### Methods


- void SetAbsoluteGlyphOffset(const IntVector2& offset)
- void SetScaledGlyphOffset(const Vector2& offset)
- const IntVector2& GetAbsoluteGlyphOffset() const
- const Vector2& GetScaledGlyphOffset() const
- IntVector2 GetTotalGlyphOffset(float pointSize) const
- FontType GetFontType() const
- bool IsSDFFont() const

### Properties


- IntVector2 absoluteGlyphOffset
- Vector2 scaledGlyphOffset
- FontType fontType (readonly)



---

