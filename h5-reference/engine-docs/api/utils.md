# Utilities

UrhoX Lua API - Utilities

---

## Classes

- [StringHash](#stringhash)
- [Variant](#variant)
- [VariantMap](#variantmap)
- [Log](#log)
- [Console](#console)
- [DebugHud](#debughud)
- [DebugRenderer](#debugrenderer)
- [Localization](#localization)
- [LuaScriptInstance](#luascriptinstance)
- [Database](#database)
- [DbConnection](#dbconnection)
- [DbResult](#dbresult)
- [CustomGeometryVertex](#customgeometryvertex)
- [VertexElement](#vertexelement)
- [OctreeQueryResult](#octreequeryresult)
- [RayQueryResult](#rayqueryresult)

---

## StringHash



### Methods


- StringHash() (GC)
- StringHash* new()
- StringHash(const StringHash& rhs) (GC)
- StringHash* new(const StringHash& rhs)
- StringHash(const char* str) (GC)
- StringHash* new(const char* str)
- StringHash(unsigned value) (GC)
- StringHash* new(unsigned value)
- void delete()
- StringHash operator+(const StringHash& rhs) const
- bool operator==(const StringHash& rhs) const
- bool operator<(const StringHash& rhs) const
- bool operatorbool() const
- unsigned Value() const
- String ToString() const
- unsigned ToHash() const
- unsigned Calculate(const char* str, unsigned hash = 0)

### Properties


- const StringHash ZERO
- unsigned value (readonly)



---

## Variant



### Methods


- Variant() (GC)
- Variant* new()
- Variant(const Variant& value) (GC)
- Variant* new(const Variant& value)
- Variant(const char* type, const char* value) (GC)
- Variant* new(const char* type, const char* value)
- Variant(VariantType type, const char* value) (GC)
- Variant* new(VariantType type, const char* value)
- void delete()
- void Clear()
- bool operator==(const Variant& rhs) const
- void Set(const Variant& rhs)
- void* Get(const char* type = 0) const
- int GetInt() const
- unsigned GetUInt() const
- int GetInt64() const
- int GetUInt64() const
- StringHash GetStringHash() const
- bool GetBool() const
- float GetFloat() const
- double GetDouble() const
- const Vector2& GetVector2() const
- const Vector3& GetVector3() const
- const Vector4& GetVector4() const
- const Quaternion& GetQuaternion() const
- const Color& GetColor() const
- const String GetString() const
- const PODVector<unsigned char>& GetRawBuffer() const
- VectorBuffer GetBuffer() const
- void* GetVoidPtr(const char* type) const
- const ResourceRef& GetResourceRef() const
- const ResourceRefList& GetResourceRefList() const
- const Vector<Variant>& GetVariantVector() const
- const VariantMap& GetVariantMap() const
- const Vector<String>& GetStringVector() const
- const Rect& GetRect() const
- const IntRect& GetIntRect() const
- const IntVector2& GetIntVector2() const
- const IntVector3& GetIntVector3() const
- RefCounted* GetPtr(const char* type) const
- const Matrix3& GetMatrix3() const
- const Matrix3x4& GetMatrix3x4() const
- const Matrix4& GetMatrix4() const
- VariantType GetType() const
- String GetTypeName() const
- String ToString() const
- bool IsZero() const
- bool IsEmpty() const

### Properties


- VariantType type (readonly)
- String typeName (readonly)
- bool zero (readonly)
- bool empty (readonly)



---

## VariantMap



### Methods


- VariantMap() (GC)
- VariantMap* new()
- void delete()



---

**Inherits from**: Object

## Log : Object


### Methods


- void Open(const String fileName)
- void Close()
- void SetLevel(int level)
- void SetTimeStamp(bool enable)
- void SetQuiet(bool quiet)
- int GetLevel() const
- bool GetTimeStamp() const
- String GetLastMessage() const
- bool IsQuiet() const
- void Write(int level, const String message)
- void WriteRaw(const String message, bool error = false)

### Properties


- int level
- bool timeStamp
- bool quiet



---

**Inherits from**: Object

## Console : Object


### Methods


- void SetDefaultStyle(XMLFile* style)
- void SetVisible(bool enable)
- void Toggle()
- void SetAutoVisibleOnError(bool enable)
- void SetCommandInterpreter(const String interpreter)
- void SetNumBufferedRows(unsigned rows)
- void SetNumRows(unsigned rows)
- void SetNumHistoryRows(unsigned rows)
- void SetFocusOnShow(bool enable)
- void AddAutoComplete(const String option)
- void RemoveAutoComplete(const String option)
- void UpdateElements()
- XMLFile* GetDefaultStyle() const
- BorderImage* GetBackground() const
- LineEdit* GetLineEdit() const
- Button* GetCloseButton() const
- bool IsVisible() const
- bool IsAutoVisibleOnError() const
- const String GetCommandInterpreter() const
- unsigned GetNumBufferedRows() const
- unsigned GetNumRows() const
- void CopySelectedRows() const
- unsigned GetNumHistoryRows() const
- unsigned GetHistoryPosition() const
- const String GetHistoryRow(unsigned index) const
- bool GetFocusOnShow() const

### Properties


- XMLFile* defaultStyle
- BorderImage* background (readonly)
- LineEdit* lineEdit (readonly)
- Button* closeButton (readonly)
- bool visible
- bool autoVisibleOnError
- String commandInterpreter
- unsigned numBufferedRows
- unsigned numRows
- unsigned numHistoryRows
- unsigned historyPosition (readonly)
- bool focusOnShow



---

**Inherits from**: Object

## DebugHud : Object


### Methods


- void Update()
- void SetDefaultStyle(XMLFile* style)
- void SetMode(unsigned mode)
- void SetProfilerMaxDepth(unsigned depth)
- void SetProfilerInterval(float interval)
- void SetUseRendererStats(bool enable)
- void Toggle(unsigned mode)
- void ToggleAll()
- XMLFile* GetDefaultStyle() const
- Text* GetStatsText() const
- Text* GetModeText() const
- Text* GetProfilerText() const
- unsigned GetMode() const
- unsigned GetProfilerMaxDepth() const
- float GetProfilerInterval() const
- bool GetUseRendererStats() const
- void SetAppStats(const String label, const Variant stats)
- void SetAppStats(const String label, const String stats)
- bool ResetAppStats(const String label)
- void ClearAppStats()

### Properties


- XMLFile* defaultStyle
- Text* statsText (readonly)
- Text* modeText (readonly)
- Text* profilerText (readonly)
- unsigned mode
- unsigned profilerMaxDepth
- float profilerInterval
- bool useRendererStats



---

**Inherits from**: Component

## DebugRenderer : Component


### Methods


- void SetLineAntiAlias(bool enable)
- void SetView(Camera* camera)
- void AddLine(const Vector3& start, const Vector3& end, const Color& color, bool depthTest = true)
- void AddLine(const Vector3& start, const Vector3& end, unsigned color, bool depthTest = true)
- void AddTriangle(const Vector3& v1, const Vector3& v2, const Vector3& v3, const Color& color, bool depthTest = true)
- void AddTriangle(const Vector3& v1, const Vector3& v2, const Vector3& v3, unsigned color, bool depthTest = true)
- void AddPolygon(const Vector3& v1, const Vector3& v2, const Vector3& v3, const Vector3& v4, const Color& color, bool depthTest = true)
- void AddPolygon(const Vector3& v1, const Vector3& v2, const Vector3& v3, const Vector3& v4, unsigned color, bool depthTest = true)
- void AddNode(Node* node, float scale = 1.0f, bool depthTest = true)
- void AddBoundingBox(const BoundingBox& box, const Color& color, bool depthTest = true, bool solid = false)
- void AddBoundingBox(const BoundingBox& box, const Matrix3x4& transform, const Color& color, bool depthTest = true, bool solid = false)
- void AddFrustum(const Frustum& frustum, const Color& color, bool depthTest = true)
- void AddPolyhedron(const Polyhedron& poly, const Color& color, bool depthTest = true)
- void AddSphere(const Sphere& sphere, const Color& color, bool depthTest = true)
- void AddSphereSector(const Sphere& sphere, const Quaternion& rotation, float angle, bool drawLines, const Color& color, bool depthTest = true)
- void AddSkeleton(const Skeleton& skeleton, const Color& color, bool depthTest = true)
- void AddTriangleMesh(const void* vertexData, unsigned vertexSize, const void* indexData, unsigned indexSize, unsigned indexStart, unsigned indexCount, const Matrix3x4& transform, const Color& color, bool depthTest = true)
- void AddTriangleMesh(const void* vertexData, unsigned vertexSize, unsigned vertexStart, const void* indexData, unsigned indexSize, unsigned indexStart, unsigned indexCount, const Matrix3x4& transform, const Color& color, bool depthTest = true)
- void AddCircle(const Vector3& center, const Vector3& normal, float radius, const Color& color, int steps = 64, bool depthTest = true)
- void AddCross(const Vector3& center, float size, const Color& color, bool depthTest = true)
- void AddQuad(const Vector3& center, float width, float height, const Color& color, bool depthTest = true)
- void Render()
- bool GetLineAntiAlias() const
- const Matrix3x4& GetView() const
- const Matrix4& GetProjection() const
- const Frustum& GetFrustum() const
- bool IsInside(const BoundingBox& box) const

### Properties


- bool lineAntiAlias
- Matrix3x4& view (readonly)
- Matrix4& projection (readonly)
- Frustum& frustum (readonly)



---

**Inherits from**: Object

## Localization : Object


### Methods


- int GetNumLanguages() const
- int GetLanguageIndex() const
- int GetLanguageIndex(const String language)
- String GetLanguage()
- String GetLanguage(int index)
- void SetLanguage(const String language)
- void SetLanguage(int index)
- String Get(const String id)
- void Reset()
- void LoadJSON(const JSONValue& source)
- void LoadJSONFile(const String name)

### Properties


- int numLanguages (readonly)
- int languageIndex (readonly)
- String language (readonly)



---

**Inherits from**: Component

## LuaScriptInstance : Component


### Methods


- bool CreateObject(const String scriptObjectType)
- bool CreateObject(LuaFile* scriptFile, const String scriptObjectType)
- void SetScriptFile(LuaFile* scriptFile)
- void SetScriptObjectType(const String scriptObjectType)
- void SubscribeToEvent(const String eventName, void* functionOrFunctionName)
- void SubscribeToEvent(void* sender, const String eventName, void* functionOrFunctionName)
- void UnsubscribeFromEvent(const String eventName)
- void UnsubscribeFromEvent(Object* sender, const String eventName)
- void UnsubscribeFromEvents(Object* sender)
- void UnsubscribeFromAllEvents()
- void UnsubscribeFromAllEventsExcept(const Vector<String>& exceptionNames)
- bool HasSubscribedToEvent(const String eventName)
- bool HasSubscribedToEvent(Object* sender, const String eventName)
- LuaFile* GetScriptFile() const
- const String GetScriptObjectType() const

### Properties


- const LuaFile* scriptFile
- const String scriptObjectType



---

**Inherits from**: Object

## Database : Object


### Methods


- DbConnection* Connect(const String connectionString)
- void Disconnect(DbConnection* connection)
- bool IsPooling() const
- unsigned GetPoolSize() const
- void SetPoolSize(unsigned poolSize)

### Properties


- bool pooling (readonly)
- unsigned poolSize



---

**Inherits from**: Object

## DbConnection : Object


### Methods


- void Finalize()
- DbResult Execute(const String sql, bool useCursorEvent = false)
- const String GetConnectionString() const
- bool IsConnected() const

### Properties


- const String connectionString (readonly)
- bool connected (readonly)



---

## DbResult



### Methods


- unsigned GetNumColumns() const
- unsigned GetNumRows() const
- long GetNumAffectedRows() const

### Properties


- unsigned numColumns (readonly)
- unsigned numRows (readonly)
- long numAffectedRows (readonly)



---

## CustomGeometryVertex



### Properties


- Vector3 position
- Vector3 normal
- unsigned color
- Vector2 texCoord
- Vector4 tangent



---

## VertexElement



### Methods


- VertexElement() (GC)
- VertexElement* new()
- VertexElement(VertexElementType type, VertexElementSemantic semantic, char index = 0, bool perInstance = false) (GC)
- VertexElement* new(VertexElementType type, VertexElementSemantic semantic, char index = 0, bool perInstance = false)

### Properties


- VertexElementType type
- VertexElementSemantic semantic
- char index
- bool perInstance
- unsigned offset



---

## OctreeQueryResult



### Methods


- OctreeQueryResult() (GC)
- OctreeQueryResult* new()
- void delete()

### Properties


- Drawable* drawable
- Node* node



---

## RayQueryResult



### Methods


- RayQueryResult() (GC)
- RayQueryResult* new()
- void delete()

### Properties


- Vector3 position
- Vector3 normal
- Vector2 textureUV
- float distance
- Drawable* drawable
- Node* node
- unsigned subObject



---

