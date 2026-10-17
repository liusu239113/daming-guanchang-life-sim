# Input/Output

UrhoX Lua API - Input/Output

---

## Classes

- [File](#file)
- [FileSystem](#filesystem)
- [Serializer](#serializer)
- [Deserializer](#deserializer)
- [VectorBuffer](#vectorbuffer)
- [NamedPipe](#namedpipe)
- [PackageFile](#packagefile)
- [PackageEntry](#packageentry)
- [XMLFile](#xmlfile)
- [XMLElement](#xmlelement)
- [JSONFile](#jsonfile)
- [JSONValue](#jsonvalue)

---

**Inherits from**: Object

## File : Object


### Methods


- File() (GC)
- File* new()
- File(const String fileName, FileMode mode = FILE_READ) (GC)
- File* new(const String fileName, FileMode mode = FILE_READ)
- File(PackageFile* package, const String fileName) (GC)
- File* new(PackageFile* package, const String fileName)
- void delete()
- bool Open(const String fileName, FileMode mode = FILE_READ)
- bool Open(PackageFile* package, const String fileName)
- void Close()
- void Dispose()
- void Flush()
- void SetName(const String name)
- FileMode GetMode() const
- bool IsOpen() const
- void* GetHandle() const
- bool IsPackaged() const
- VectorBuffer Read(unsigned size)
- unsigned Seek(unsigned position)
- unsigned SeekRelative(int delta)
- const String GetName() const
- unsigned GetChecksum()
- unsigned GetPosition() const
- unsigned Tell() const
- unsigned GetSize() const
- bool IsEof() const
- int ReadInt()
- long ReadInt64()
- short ReadShort()
- char ReadByte()
- unsigned ReadUInt()
- long ReadUInt64()
- short ReadUShort()
- char ReadUByte()
- bool ReadBool()
- float ReadFloat()
- double ReadDouble()
- IntRect ReadIntRect()
- IntVector2 ReadIntVector2()
- IntVector3 ReadIntVector3()
- Rect ReadRect()
- Vector2 ReadVector2()
- Vector3 ReadVector3()
- Vector3 ReadPackedVector3(float maxAbsCoord)
- Vector4 ReadVector4()
- Quaternion ReadQuaternion()
- Quaternion ReadPackedQuaternion()
- Matrix3 ReadMatrix3()
- Matrix3x4 ReadMatrix3x4()
- Matrix4 ReadMatrix4()
- Color ReadColor()
- BoundingBox ReadBoundingBox()
- String ReadString()
- String ReadFileID()
- StringHash ReadStringHash()
- VectorBuffer ReadBuffer()
- ResourceRef ReadResourceRef()
- ResourceRefList ReadResourceRefList()
- Variant ReadVariant()
- Variant ReadVariant(VariantType type)
- VariantVector ReadVariantVector()
- VariantMap ReadVariantMap()
- unsigned ReadVLE()
- unsigned ReadNetID()
- String ReadLine()
- unsigned Write(const VectorBuffer& buffer)
- bool WriteInt(int value)
- bool WriteInt64(long value)
- bool WriteShort(short value)
- bool WriteByte(char value)
- bool WriteUInt(unsigned value)
- bool WriteUInt64(long value)
- bool WriteUShort(short value)
- bool WriteUByte(char value)
- bool WriteBool(bool value)
- bool WriteFloat(float value)
- bool WriteDouble(double value)
- bool WriteIntRect(const IntRect& value)
- bool WriteIntVector2(const IntVector2& value)
- bool WriteIntVector3(const IntVector3& value)
- bool WriteRect(const Rect& value)
- bool WriteVector2(const Vector2& value)
- bool WriteVector3(const Vector3& value)
- bool WritePackedVector3(const Vector3& value, float maxAbsCoord)
- bool WriteVector4(const Vector4& value)
- bool WriteQuaternion(const Quaternion& value)
- bool WritePackedQuaternion(const Quaternion& value)
- bool WriteMatrix3(const Matrix3& value)
- bool WriteMatrix3x4(const Matrix3x4& value)
- bool WriteMatrix4(const Matrix4& value)
- bool WriteColor(const Color& value)
- bool WriteBoundingBox(const BoundingBox& value)
- bool WriteString(const String value)
- bool WriteFileID(const String value)
- bool WriteStringHash(const StringHash& value)
- bool WriteBuffer(const VectorBuffer& buffer)
- bool WriteResourceRef(const ResourceRef& value)
- bool WriteResourceRefList(const ResourceRefList& value)
- bool WriteVariant(const Variant& value)
- bool WriteVariantData(const Variant& value)
- bool WriteVariantVector(const VariantVector& value)
- bool WriteVariantMap(const VariantMap& value)
- bool WriteVLE(unsigned value)
- bool WriteNetID(unsigned value)
- bool WriteLine(const String value)

### Properties


- FileMode mode (readonly)
- bool open (readonly)
- bool packaged (readonly)
- String name (readonly)
- unsigned checksum (readonly)
- unsigned position (readonly)
- unsigned size (readonly)
- bool eof (readonly)



---

**Inherits from**: Object

## FileSystem : Object


### Methods


- bool SetCurrentDir(const String pathName)
- bool CreateDir(const String pathName)
- void SetExecuteConsoleCommands(bool enable)
- int SystemCommand(const String commandLine, bool redirectStdOutToLog = false)
- int SystemRun(const String fileName, const Vector<String>& arguments)
- unsigned SystemCommandAsync(const String commandLine)
- unsigned SystemRunAsync(const String fileName, const Vector<String>& arguments)
- bool SystemOpen(const String fileName, const String mode = String::EMPTY)
- bool Copy(const String srcFileName, const String destFileName)
- bool Rename(const String srcFileName, const String destFileName)
- bool Delete(const String fileName)
- bool SetLastModifiedTime(const String fileName, unsigned newTime)
- String GetCurrentDir() const
- bool GetExecuteConsoleCommands() const
- bool HasRegisteredPaths() const
- bool CheckAccess(const String pathName) const
- unsigned GetLastModifiedTime(const String fileName) const
- bool FileExists(const String fileName) const
- bool DirExists(const String pathName) const
- const Vector<String>& ScanDir(const String pathName, const String filter, unsigned flags, bool recursive) const
- String GetProgramDir() const
- String GetUserDocumentsDir() const
- String GetAppPreferencesDir(const String org, const String app) const
- String GetTemporaryDir() const



---

## Serializer



### Methods


- unsigned Write(const VectorBuffer& buffer)
- bool WriteInt(int value)
- bool WriteInt64(long value)
- bool WriteShort(short value)
- bool WriteByte(char value)
- bool WriteUInt(unsigned value)
- bool WriteUInt64(long value)
- bool WriteUShort(short value)
- bool WriteUByte(char value)
- bool WriteBool(bool value)
- bool WriteFloat(float value)
- bool WriteDouble(double value)
- bool WriteIntRect(const IntRect& value)
- bool WriteIntVector2(const IntVector2& value)
- bool WriteIntVector3(const IntVector3& value)
- bool WriteRect(const Rect& value)
- bool WriteVector2(const Vector2& value)
- bool WriteVector3(const Vector3& value)
- bool WritePackedVector3(const Vector3& value, float maxAbsCoord)
- bool WriteVector4(const Vector4& value)
- bool WriteQuaternion(const Quaternion& value)
- bool WritePackedQuaternion(const Quaternion& value)
- bool WriteMatrix3(const Matrix3& value)
- bool WriteMatrix3x4(const Matrix3x4& value)
- bool WriteMatrix4(const Matrix4& value)
- bool WriteColor(const Color& value)
- bool WriteBoundingBox(const BoundingBox& value)
- bool WriteString(const String value)
- bool WriteFileID(const String value)
- bool WriteStringHash(const StringHash& value)
- bool WriteBuffer(const VectorBuffer& buffer)
- bool WriteResourceRef(const ResourceRef& value)
- bool WriteResourceRefList(const ResourceRefList& value)
- bool WriteVariant(const Variant& value)
- bool WriteVariantData(const Variant& value)
- bool WriteVariantVector(const VariantVector& value)
- bool WriteVariantMap(const VariantMap& value)
- bool WriteVLE(unsigned value)
- bool WriteNetID(unsigned value)
- bool WriteLine(const String value)



---

## Deserializer



### Methods


- VectorBuffer Read(unsigned size)
- unsigned Seek(unsigned position)
- unsigned SeekRelative(int delta)
- const String GetName() const
- unsigned GetChecksum()
- unsigned GetPosition() const
- unsigned Tell() const
- unsigned GetSize() const
- bool IsEof() const
- int ReadInt()
- long ReadInt64()
- short ReadShort()
- char ReadByte()
- unsigned ReadUInt()
- long ReadUInt64()
- short ReadUShort()
- char ReadUByte()
- bool ReadBool()
- float ReadFloat()
- double ReadDouble()
- IntRect ReadIntRect()
- IntVector2 ReadIntVector2()
- IntVector3 ReadIntVector3()
- Rect ReadRect()
- Vector2 ReadVector2()
- Vector3 ReadVector3()
- Vector3 ReadPackedVector3(float maxAbsCoord)
- Vector4 ReadVector4()
- Quaternion ReadQuaternion()
- Quaternion ReadPackedQuaternion()
- Matrix3 ReadMatrix3()
- Matrix3x4 ReadMatrix3x4()
- Matrix4 ReadMatrix4()
- Color ReadColor()
- BoundingBox ReadBoundingBox()
- String ReadString()
- String ReadFileID()
- StringHash ReadStringHash()
- VectorBuffer ReadBuffer()
- ResourceRef ReadResourceRef()
- ResourceRefList ReadResourceRefList()
- Variant ReadVariant()
- Variant ReadVariant(VariantType type)
- VariantVector ReadVariantVector()
- VariantMap ReadVariantMap()
- unsigned ReadVLE()
- unsigned ReadNetID()
- String ReadLine()

### Properties


- String name (readonly)
- unsigned checksum (readonly)
- unsigned position (readonly)
- unsigned size (readonly)
- bool eof (readonly)



---

## VectorBuffer



### Methods


- VectorBuffer() (GC)
- VectorBuffer* new()
- VectorBuffer(Deserializer& source, unsigned size) (GC)
- VectorBuffer* new(Deserializer& source, unsigned size)
- void delete()
- void SetData(Deserializer& source, unsigned size)
- void Clear()
- void Resize(unsigned size)
- const void* GetData() const
- void* GetModifiableData()
- VectorBuffer Read(unsigned size)
- unsigned Seek(unsigned position)
- unsigned SeekRelative(int delta)
- const String GetName() const
- unsigned GetChecksum()
- unsigned GetPosition() const
- unsigned Tell() const
- unsigned GetSize() const
- bool IsEof() const
- int ReadInt()
- long ReadInt64()
- short ReadShort()
- char ReadByte()
- unsigned ReadUInt()
- long ReadUInt64()
- short ReadUShort()
- char ReadUByte()
- bool ReadBool()
- float ReadFloat()
- double ReadDouble()
- IntRect ReadIntRect()
- IntVector2 ReadIntVector2()
- IntVector3 ReadIntVector3()
- Rect ReadRect()
- Vector2 ReadVector2()
- Vector3 ReadVector3()
- Vector3 ReadPackedVector3(float maxAbsCoord)
- Vector4 ReadVector4()
- Quaternion ReadQuaternion()
- Quaternion ReadPackedQuaternion()
- Matrix3 ReadMatrix3()
- Matrix3x4 ReadMatrix3x4()
- Matrix4 ReadMatrix4()
- Color ReadColor()
- BoundingBox ReadBoundingBox()
- String ReadString()
- String ReadFileID()
- StringHash ReadStringHash()
- VectorBuffer ReadBuffer()
- ResourceRef ReadResourceRef()
- ResourceRefList ReadResourceRefList()
- Variant ReadVariant()
- Variant ReadVariant(VariantType type)
- VariantVector ReadVariantVector()
- VariantMap ReadVariantMap()
- unsigned ReadVLE()
- unsigned ReadNetID()
- String ReadLine()
- unsigned Write(const VectorBuffer& buffer)
- bool WriteInt(int value)
- bool WriteInt64(long value)
- bool WriteShort(short value)
- bool WriteByte(char value)
- bool WriteUInt(unsigned value)
- bool WriteUInt64(long value)
- bool WriteUShort(short value)
- bool WriteUByte(char value)
- bool WriteBool(bool value)
- bool WriteFloat(float value)
- bool WriteDouble(double value)
- bool WriteIntRect(const IntRect& value)
- bool WriteIntVector2(const IntVector2& value)
- bool WriteIntVector3(const IntVector3& value)
- bool WriteRect(const Rect& value)
- bool WriteVector2(const Vector2& value)
- bool WriteVector3(const Vector3& value)
- bool WritePackedVector3(const Vector3& value, float maxAbsCoord)
- bool WriteVector4(const Vector4& value)
- bool WriteQuaternion(const Quaternion& value)
- bool WritePackedQuaternion(const Quaternion& value)
- bool WriteMatrix3(const Matrix3& value)
- bool WriteMatrix3x4(const Matrix3x4& value)
- bool WriteMatrix4(const Matrix4& value)
- bool WriteColor(const Color& value)
- bool WriteBoundingBox(const BoundingBox& value)
- bool WriteString(const String value)
- bool WriteFileID(const String value)
- bool WriteStringHash(const StringHash& value)
- bool WriteBuffer(const VectorBuffer& buffer)
- bool WriteResourceRef(const ResourceRef& value)
- bool WriteResourceRefList(const ResourceRefList& value)
- bool WriteVariant(const Variant& value)
- bool WriteVariantData(const Variant& value)
- bool WriteVariantVector(const VariantVector& value)
- bool WriteVariantMap(const VariantMap& value)
- bool WriteVLE(unsigned value)
- bool WriteNetID(unsigned value)
- bool WriteLine(const String value)

### Properties


- String name (readonly)
- unsigned checksum (readonly)
- unsigned position (readonly)
- unsigned size (readonly)
- bool eof (readonly)



---

**Inherits from**: Object

## NamedPipe : Object


### Methods


- NamedPipe() (GC)
- NamedPipe* new()
- NamedPipe(const String pipeName, bool isServer) (GC)
- NamedPipe* new(const String pipeName, bool isServer)
- void delete()
- bool Open(const String pipeName, bool isServer)
- void Close()
- bool IsOpen() const
- VectorBuffer Read(unsigned size)
- const String GetName() const
- bool IsEof() const
- int ReadInt()
- short ReadShort()
- char ReadByte()
- unsigned ReadUInt()
- short ReadUShort()
- char ReadUByte()
- bool ReadBool()
- float ReadFloat()
- double ReadDouble()
- IntRect ReadIntRect()
- IntVector2 ReadIntVector2()
- IntVector3 ReadIntVector3()
- Rect ReadRect()
- Vector2 ReadVector2()
- Vector3 ReadVector3()
- Vector3 ReadPackedVector3(float maxAbsCoord)
- Vector4 ReadVector4()
- Quaternion ReadQuaternion()
- Quaternion ReadPackedQuaternion()
- Matrix3 ReadMatrix3()
- Matrix3x4 ReadMatrix3x4()
- Matrix4 ReadMatrix4()
- Color ReadColor()
- BoundingBox ReadBoundingBox()
- String ReadString()
- String ReadFileID()
- StringHash ReadStringHash()
- VectorBuffer ReadBuffer()
- ResourceRef ReadResourceRef()
- ResourceRefList ReadResourceRefList()
- Variant ReadVariant()
- Variant ReadVariant(VariantType type)
- VariantVector ReadVariantVector()
- VariantMap ReadVariantMap()
- unsigned ReadVLE()
- unsigned ReadNetID()
- String ReadLine()
- unsigned Write(const VectorBuffer& buffer)
- bool WriteInt(int value)
- bool WriteShort(short value)
- bool WriteByte(char value)
- bool WriteUInt(unsigned value)
- bool WriteUShort(short value)
- bool WriteUByte(char value)
- bool WriteBool(bool value)
- bool WriteFloat(float value)
- bool WriteDouble(double value)
- bool WriteIntRect(const IntRect& value)
- bool WriteIntVector2(const IntVector2& value)
- bool WriteIntVector3(const IntVector3& value)
- bool WriteRect(const Rect& value)
- bool WriteVector2(const Vector2& value)
- bool WriteVector3(const Vector3& value)
- bool WritePackedVector3(const Vector3& value, float maxAbsCoord)
- bool WriteVector4(const Vector4& value)
- bool WriteQuaternion(const Quaternion& value)
- bool WritePackedQuaternion(const Quaternion& value)
- bool WriteMatrix3(const Matrix3& value)
- bool WriteMatrix3x4(const Matrix3x4& value)
- bool WriteMatrix4(const Matrix4& value)
- bool WriteColor(const Color& value)
- bool WriteBoundingBox(const BoundingBox& value)
- bool WriteString(const String value)
- bool WriteFileID(const String value)
- bool WriteStringHash(const StringHash& value)
- bool WriteBuffer(const VectorBuffer& buffer)
- bool WriteResourceRef(const ResourceRef& value)
- bool WriteResourceRefList(const ResourceRefList& value)
- bool WriteVariant(const Variant& value)
- bool WriteVariantData(const Variant& value)
- bool WriteVariantVector(const VariantVector& value)
- bool WriteVariantMap(const VariantMap& value)
- bool WriteVLE(unsigned value)
- bool WriteNetID(unsigned value)
- bool WriteLine(const String value)

### Properties


- String name (readonly)
- bool eof (readonly)
- bool open (readonly)



---

**Inherits from**: Object

## PackageFile : Object


### Methods


- PackageFile() (GC)
- PackageFile* new()
- PackageFile(const String fileName, unsigned startOffset = 0) (GC)
- PackageFile* new(const String fileName, unsigned startOffset = 0)
- void delete()
- bool Open(const String fileName, unsigned startOffset = 0)
- bool Exists(const String fileName) const
- const PackageEntry* GetEntry(const String fileName) const
- const HashMap<String,PackageEntry>& GetEntries() const
- const String GetName() const
- StringHash GetNameHash() const
- unsigned GetNumFiles() const
- unsigned GetTotalSize() const
- unsigned GetTotalDataSize() const
- unsigned GetChecksum() const
- bool IsCompressed() const

### Properties


- String name (readonly)
- StringHash nameHash (readonly)
- unsigned numFiles (readonly)
- unsigned totalSize (readonly)
- unsigned totalDataSize (readonly)
- unsigned checksum (readonly)
- bool compressed (readonly)



---

## PackageEntry



### Properties


- unsigned offset
- unsigned size
- unsigned checksum



---

**Inherits from**: Resource

## XMLFile : Resource


### Methods


- XMLFile() (GC)
- XMLFile* new()
- void delete()
- bool FromString(const String source)
- XMLElement CreateRoot(const String name = String::EMPTY)
- XMLElement GetOrCreateRoot(const String name = String::EMPTY)
- XMLElement GetRoot(const String name = String::EMPTY)
- String ToString(const String indentation = "\t") const
- void Patch(XMLFile* patchFile)
- void Patch(XMLElement patchElement)
- bool Save(const String fileName, const String indentation = "\t") const



---

## XMLElement



### Methods


- bool AppendChild(XMLElement element, bool asCopy)
- XMLElement CreateChild(const String name)
- XMLElement GetOrCreateChild(const String name)
- bool RemoveChild(const XMLElement& element)
- bool RemoveChild(const String name)
- bool RemoveChildren(const String name = String::EMPTY)
- bool RemoveAttribute(const String name = String::EMPTY)
- bool Remove()
- bool SetValue(const String value)
- bool SetAttribute(const String name, const String value)
- bool SetAttribute(const String value)
- bool SetBool(const String name, bool value)
- bool SetBoundingBox(const BoundingBox& value)
- bool SetColor(const String name, const Color& value)
- bool SetFloat(const String name, float value)
- bool SetDouble(const String name, double value)
- bool SetUInt(const String name, unsigned value)
- bool SetInt(const String name, int value)
- bool SetUInt64(const String name, long value)
- bool SetInt64(const String name, long value)
- bool SetIntRect(const String name, const IntRect& value)
- bool SetIntVector2(const String name, const IntVector2& value)
- bool SetIntVector3(const String name, const IntVector3& value)
- bool SetRect(const String name, const Rect& value)
- bool SetQuaternion(const String name, const Quaternion& value)
- bool SetString(const String name, const String value)
- bool SetVariant(const Variant& value)
- bool SetVariantValue(const Variant& value)
- bool SetResourceRef(const ResourceRef& value)
- bool SetResourceRefList(const ResourceRefList& value)
- bool SetVector2(const String name, const Vector2& value)
- bool SetVector3(const String name, const Vector3& value)
- bool SetVector4(const String name, const Vector4& value)
- bool SetVectorVariant(const String name, const Variant& value)
- bool SetMatrix3(const String name, const Matrix3& value)
- bool SetMatrix3x4(const String name, const Matrix3x4& value)
- bool SetMatrix4(const String name, const Matrix4& value)
- bool IsNull() const
- bool NotNull() const
- bool operatorbool() const
- String GetName() const
- bool HasChild(const String name) const
- XMLElement GetChild(const String name = String::EMPTY) const
- XMLElement GetNext(const String name = String::EMPTY) const
- XMLElement GetParent() const
- unsigned GetNumAttributes() const
- bool HasAttribute(const String name) const
- String GetValue() const
- String GetAttribute(const String name = String::EMPTY) const
- String GetAttributeLower(const String name) const
- String GetAttributeUpper(const String name) const
- Vector<String> GetAttributeNames() const
- bool GetBool(const String name) const
- BoundingBox GetBoundingBox() const
- Color GetColor(const String name) const
- float GetFloat(const String name) const
- double GetDouble(const String name) const
- unsigned GetUInt(const String name) const
- int GetInt(const String name) const
- long GetUInt64(const String name) const
- long GetInt64(const String name) const
- IntRect GetIntRect(const String name) const
- IntVector2 GetIntVector2(const String name) const
- IntVector3 GetIntVector3(const String name) const
- Rect GetRect(const String name) const
- Quaternion GetQuaternion(const String name) const
- Variant GetVariant() const
- Variant GetVariantValue(VariantType type) const
- ResourceRef GetResourceRef() const
- ResourceRefList GetResourceRefList() const
- VariantMap GetVariantMap() const
- Vector2 GetVector2(const String name) const
- Vector3 GetVector3(const String name) const
- Vector4 GetVector4(const String name) const
- Vector4 GetVector(const String name) const
- Matrix3 GetMatrix3(const String name) const
- Matrix3x4 GetMatrix3x4(const String name) const
- Matrix4 GetMatrix4(const String name) const
- XMLFile* GetFile() const

### Properties


- const XMLElement EMPTY
- bool null (readonly)
- String name (readonly)
- XMLElement parent (readonly)
- String value (readonly)
- unsigned numAttributes (readonly)
- XMLFile* file (readonly)



---

**Inherits from**: Resource

## JSONFile : Resource


### Methods


- JSONFile() (GC)
- JSONFile* new()
- void delete()
- bool FromString(const String source)
- String ToString(const String indendation = "\t") const
- const JSONValue& GetRoot() const
- bool Save(const String fileName, const String indentation = "\t") const



---

## JSONValue



### Methods


- JSONValue() (GC)
- JSONValue* new()
- JSONValue(bool value) (GC)
- JSONValue* new(bool value)
- JSONValue(const char* value) (GC)
- JSONValue* new(const char* value)
- JSONValue(double value) (GC)
- JSONValue* new(double value)
- JSONValue(const JSONArray& value) (GC)
- JSONValue* new(const JSONArray& value)
- JSONValue(const JSONObject& value) (GC)
- JSONValue* new(const JSONObject& value)
- JSONValue(const JSONValue& value) (GC)
- JSONValue* new(const JSONValue& value)
- void delete()
- void SetBool(bool value)
- void SetInt(int value)
- void SetUint(unsigned value)
- void SetFloat(float value)
- void SetDouble(double value)
- void SetString(const String value)
- void SetArray(const JSONArray& value)
- void SetObject(const JSONObject& value)
- void SetVariant(const Variant& value)
- void SetVariantMap(const VariantMap& value)
- JSONValueType GetValueType() const
- JSONNumberType GetNumberType() const
- String GetValueTypeName() const
- String GetNumberTypeName() const
- bool IsNull() const
- bool IsBool() const
- bool IsNumber() const
- bool IsString() const
- bool IsArray() const
- bool IsObject() const
- bool GetBool() const
- int GetInt() const
- unsigned GetUInt() const
- float GetFloat() const
- double GetDouble() const
- const String GetString() const
- const JSONArray& GetArray() const
- const JSONObject& GetObject() const
- Variant GetVariant() const
- VariantMap GetVariantMap() const
- JSONValue operator&[](unsigned index, JSONValue tolua_value)
- JSONValue operator[](unsigned index)
- const JSONValue operator[](unsigned index) const
- void Push(const JSONValue& value)
- void Pop()
- void Insert(unsigned pos, const JSONValue& value)
- void Erase(unsigned pos, unsigned length = 1)
- void Resize(unsigned newSize)
- unsigned Size() const
- void Set(const String key, const JSONValue& value)
- const JSONValue& Get(const String key) const
- bool Erase(const String key)
- bool Contains(const String key) const
- void Clear()

### Properties


- const JSONValue EMPTY
- const JSONArray emptyArray
- const JSONObject emptyObject
- bool null (readonly)
- JSONValueType valueType (readonly)
- JSONNumberType numberType (readonly)
- String valueTypeName (readonly)
- String numberTypeName (readonly)



---

