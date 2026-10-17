# Particle System

UrhoX Lua API - Particle System

---

## Classes

- [ParticleEffect](#particleeffect)
- [ParticleEmitter](#particleemitter)
- [ColorFrame](#colorframe)
- [TextureFrame](#textureframe)

---

**Inherits from**: Resource

## ParticleEffect : Resource


### Methods


- ParticleEffect() (GC)
- ParticleEffect* new()
- void delete()
- void SetMaterial(Material* material)
- void SetNumParticles(unsigned num)
- void SetUpdateInvisible(bool enable)
- void SetRelative(bool enable)
- void SetScaled(bool enable)
- void SetSorted(bool enable)
- void SetFixedScreenSize(bool enable)
- void SetAnimationLodBias(float lodBias)
- void SetEmitterType(EmitterType type)
- void SetEmitterSize(const Vector3& size)
- void SetMinDirection(const Vector3& direction)
- void SetMaxDirection(const Vector3& direction)
- void SetConstantForce(const Vector3& force)
- void SetDampingForce(float force)
- void SetActiveTime(float time)
- void SetInactiveTime(float time)
- void SetMinEmissionRate(float rate)
- void SetMaxEmissionRate(float rate)
- void SetMinParticleSize(const Vector2& size)
- void SetMaxParticleSize(const Vector2& size)
- void SetMinTimeToLive(float time)
- void SetMaxTimeToLive(float time)
- void SetMinVelocity(float velocity)
- void SetMaxVelocity(float velocity)
- void SetMinRotation(float rotation)
- void SetMaxRotation(float rotation)
- void SetMinRotationSpeed(float speed)
- void SetMaxRotationSpeed(float speed)
- void SetSizeAdd(float sizeAdd)
- void SetSizeMul(float sizeMul)
- void AddColorTime(const Color& color, float time)
- void AddColorFrame(const ColorFrame& colorFrame)
- void RemoveColorFrame(unsigned index)
- void SetColorFrame(unsigned index, const ColorFrame& colorFrame)
- void SetNumColorFrames(unsigned number)
- void SortColorFrames()
- void AddTextureTime(const Rect& uv, float time)
- void AddTextureFrame(const TextureFrame& textureFrame)
- void RemoveTextureFrame(unsigned index)
- void SetTextureFrame(unsigned index, const TextureFrame& textureFrame)
- void SetNumTextureFrames(unsigned number)
- void SortTextureFrames()
- ParticleEffect* Clone(const String cloneName = String::EMPTY) const
- Material* GetMaterial() const
- unsigned GetNumParticles() const
- bool GetUpdateInvisible() const
- bool IsRelative() const
- bool IsScaled() const
- bool IsSorted() const
- bool IsFixedScreenSize() const
- float GetAnimationLodBias() const
- EmitterType GetEmitterType() const
- const Vector3& GetEmitterSize() const
- const Vector3& GetMinDirection() const
- const Vector3& GetMaxDirection() const
- const Vector3& GetConstantForce() const
- float GetDampingForce() const
- float GetActiveTime() const
- float GetInactiveTime() const
- float GetMinEmissionRate() const
- float GetMaxEmissionRate() const
- const Vector2& GetMinParticleSize() const
- const Vector2& GetMaxParticleSize() const
- float GetMinTimeToLive() const
- float GetMaxTimeToLive() const
- float GetMinVelocity() const
- float GetMaxVelocity() const
- float GetMinRotation() const
- float GetMaxRotation() const
- float GetMinRotationSpeed() const
- float GetMaxRotationSpeed() const
- float GetSizeAdd() const
- float GetSizeMul() const
- unsigned GetNumColorFrames() const
- const ColorFrame* GetColorFrame(unsigned index) const
- unsigned GetNumTextureFrames() const
- const TextureFrame* GetTextureFrame(unsigned index) const

### Properties


- Material* material
- unsigned numParticles
- bool updateInvisible
- bool relative
- bool scaled
- bool sorted
- bool fixedScreenSize
- float animationLodBias
- EmitterType emitterType
- const Vector3& emitterSize
- const Vector3& minDirection
- const Vector3& maxDirection
- const Vector3& constantForce
- float dampingForce
- float activeTime
- float inactiveTime
- float minEmissionRate
- float maxEmissionRate
- const Vector2& minParticleSize
- const Vector2& maxParticleSize
- float minTimeToLive
- float maxTimeToLive
- float minVelocity
- float maxVelocity
- float minRotation
- float maxRotation
- float minRotationSpeed
- float maxRotationSpeed
- float sizeAdd
- float sizeMul
- unsigned numColorFrames
- unsigned numTextureFrames



---

**Inherits from**: BillboardSet

## ParticleEmitter : BillboardSet


### Methods


- void SetEffect(ParticleEffect* effect)
- void SetNumParticles(unsigned num)
- void SetEmitting(bool enable)
- void SetSerializeParticles(bool enable)
- void SetAutoRemoveMode(AutoRemoveMode mode)
- void ResetEmissionTimer()
- void RemoveAllParticles()
- void Reset()
- void ApplyEffect()
- ParticleEffect* GetEffect() const
- unsigned GetNumParticles() const
- bool IsEmitting() const
- bool GetSerializeParticles() const
- AutoRemoveMode GetAutoRemoveMode() const

### Properties


- ParticleEffect* effect
- unsigned numParticles
- bool emitting
- bool serializeParticles
- AutoRemoveMode autoRemoveMode



---

## ColorFrame



### Methods


- ColorFrame() (GC)
- ColorFrame* new()
- ColorFrame(const Color& color) (GC)
- ColorFrame* new(const Color& color)
- ColorFrame(const Color& color, float time) (GC)
- ColorFrame* new(const Color& color, float time)
- void delete()
- Color Interpolate(const ColorFrame& next, float time)

### Properties


- Color color
- float time



---

## TextureFrame



### Methods


- TextureFrame() (GC)
- TextureFrame* new()
- void delete()

### Properties


- Rect uv
- float time



---

