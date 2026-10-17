# Animation Module

UrhoX Lua API - Animation Module

---

## Classes

- [Animation](#animation)
- [AnimationState](#animationstate)
- [AnimationController](#animationcontroller)
- [AnimationControl](#animationcontrol)
- [AnimationTrack](#animationtrack)
- [AnimationKeyFrame](#animationkeyframe)
- [AnimationTriggerPoint](#animationtriggerpoint)
- [ObjectAnimation](#objectanimation)
- [ValueAnimation](#valueanimation)
- [Skeleton](#skeleton)
- [Bone](#bone)

---

**Inherits from**: ResourceWithMetadata

## Animation : ResourceWithMetadata


### Methods


- Animation() (GC)
- Animation* new()
- void delete()
- void SetAnimationName(const String name)
- void SetLength(float length)
- AnimationTrack* CreateTrack(const String name)
- bool RemoveTrack(const String name)
- void RemoveAllTracks()
- void SetTrigger(unsigned index, const AnimationTriggerPoint& trigger)
- void AddTrigger(const AnimationTriggerPoint& trigger)
- void AddTrigger(float time, bool timeIsNormalized, const Variant& data)
- void RemoveTrigger(unsigned index)
- void RemoveAllTriggers()
- Animation* Clone(const String cloneName = String::EMPTY) const
- const String GetAnimationName() const
- float GetLength() const
- unsigned GetNumTracks() const
- AnimationTrack* GetTrack(const String name)
- AnimationTrack* GetTrack(StringHash nameHash)
- AnimationTrack* GetTrack(unsigned index)
- unsigned GetNumTriggers() const
- AnimationTriggerPoint* GetTrigger(unsigned index)

### Properties


- String animationName
- float length
- unsigned numTracks (readonly)
- unsigned numTriggers (readonly)



---

## AnimationState



### Methods


- AnimationState(AnimatedModel* model, Animation* animation) (GC)
- AnimationState* new(AnimatedModel* model, Animation* animation)
- AnimationState(Node* node, Animation* animation) (GC)
- AnimationState* new(Node* node, Animation* animation)
- void delete()
- void SetStartBone(Bone* bone)
- void SetLooped(bool looped)
- void SetWeight(float weight)
- void SetTime(float time)
- void SetBoneWeight(const String name, float weight, bool recursive = false)
- void SetBoneWeight(StringHash nameHash, float weight, bool recursive = false)
- void SetBoneWeight(unsigned index, float weight, bool recursive = false)
- void AddWeight(float delta)
- void AddTime(float delta)
- void SetLayer(char layer)
- void SetBlendMode(AnimationBlendMode mode)
- Animation* GetAnimation() const
- Bone* GetStartBone() const
- float GetBoneWeight(const String name) const
- float GetBoneWeight(StringHash nameHash) const
- float GetBoneWeight(unsigned index) const
- unsigned GetTrackIndex(const String name) const
- unsigned GetTrackIndex(StringHash nameHash) const
- bool IsEnabled() const
- bool IsLooped() const
- float GetWeight() const
- float GetTime() const
- float GetLength() const
- char GetLayer() const
- AnimationBlendMode GetBlendMode() const

### Properties


- Animation* animation (readonly)
- Bone* startBone
- bool enabled (readonly)
- bool looped
- float weight
- float time
- float length (readonly)
- char layer
- AnimationBlendMode blendMode



---

**Inherits from**: Component

## AnimationController : Component


### Methods


- bool Play(const String name, char layer, bool looped, float fadeInTime = 0.0f)
- bool PlayExclusive(const String name, char layer, bool looped, float fadeTime = 0.0f)
- bool Stop(const String name, float fadeOutTime = 0.0f)
- void StopLayer(char layer, float fadeOutTime = 0.0f)
- void StopAll(float fadeTime = 0.0f)
- bool Fade(const String name, float targetWeight, float fadeTime)
- bool FadeOthers(const String name, float targetWeight, float fadeTime)
- bool SetLayer(const String name, char layer)
- bool SetStartBone(const String name, const String startBoneName)
- bool SetTime(const String name, float time)
- bool SetWeight(const String name, float weight)
- bool SetLooped(const String name, bool enable)
- bool SetBlendMode(const String name, AnimationBlendMode mode)
- bool SetSpeed(const String name, float speed)
- bool SetAutoFade(const String name, float fadeOutTime)
- bool SetRemoveOnCompletion(const String name, bool removeOnCompletion)
- bool IsPlaying(const String name) const
- bool IsPlaying(char layer) const
- bool IsFadingIn(const String name) const
- bool IsFadingOut(const String name) const
- bool IsAtEnd(const String name) const
- char GetLayer(const String name) const
- Bone* GetStartBone(const String name) const
- const String GetStartBoneName(const String name) const
- float GetTime(const String name) const
- float GetWeight(const String name) const
- bool IsLooped(const String name) const
- AnimationBlendMode GetBlendMode(const String name) const
- float GetLength(const String name) const
- float GetSpeed(const String name) const
- float GetFadeTarget(const String name) const
- float GetFadeTime(const String name) const
- float GetAutoFade(const String name) const
- bool GetRemoveOnCompletion(const String name) const
- AnimationState* GetAnimationState(const String name) const
- AnimationState* GetAnimationState(StringHash nameHash) const
- const AnimationControl* GetAnimation(unsigned index) const
- unsigned GetNumAnimations() const



---

## AnimationControl



### Methods


- AnimationControl() (GC)
- AnimationControl* new()
- void delete()

### Properties


- String name
- StringHash hash
- float speed
- float targetWeight
- float fadeTime
- float autoFadeTime
- bool removeOnCompletion



---

## AnimationTrack



### Methods


- void SetKeyFrame(unsigned index, const AnimationKeyFrame& keyFrame)
- void AddKeyFrame(const AnimationKeyFrame& keyFrame)
- void InsertKeyFrame(unsigned index, const AnimationKeyFrame& keyFrame)
- void RemoveKeyFrame(unsigned index)
- void RemoveAllKeyFrames()
- AnimationKeyFrame* GetKeyFrame(unsigned index)
- unsigned GetNumKeyFrames() const

### Properties


- const String name
- const StringHash nameHash
- char channelMask
- Vector<AnimationKeyFrame> keyFrames
- unsigned numKeyFrames (readonly)



---

## AnimationKeyFrame



### Properties


- float time
- Vector3 position
- Quaternion rotation
- Vector3 scale



---

## AnimationTriggerPoint



### Methods


- AnimationTriggerPoint() (GC)
- AnimationTriggerPoint* new()

### Properties


- float time
- Variant data



---

**Inherits from**: Resource

## ObjectAnimation : Resource


### Methods


- ObjectAnimation() (GC)
- ObjectAnimation* new()
- void delete()
- void AddAttributeAnimation(const String name, ValueAnimation* attributeAnimation, WrapMode wrapMode = WM_LOOP, float speed = 1.0f)
- void RemoveAttributeAnimation(const String name)
- void RemoveAttributeAnimation(ValueAnimation* attributeAnimation)
- ValueAnimation* GetAttributeAnimation(const String name) const
- WrapMode GetAttributeAnimationWrapMode(const String name) const
- float GetAttributeAnimationSpeed(const String name) const



---

**Inherits from**: Resource

## ValueAnimation : Resource


### Methods


- ValueAnimation() (GC)
- ValueAnimation* new()
- void delete()
- void SetInterpolationMethod(InterpMethod method)
- void SetSplineTension(float tension)
- void SetValueType(VariantType valueType)
- bool SetKeyFrame(float time, const Variant& value)
- void SetEventFrame(float time, const StringHash& eventType)
- void SetEventFrame(float time, const StringHash& eventType, const VariantMap& eventData)
- InterpMethod GetInterpolationMethod() const
- float GetSplineTension() const
- VariantType GetValueType() const

### Properties


- InterpMethod interpolationMethod
- float splineTension
- VariantType valueType



---

## Skeleton



### Methods


- unsigned GetNumBones() const
- Bone* GetRootBone()
- Bone* GetBone(const String name)
- Bone* GetBone(unsigned index)
- unsigned GetBoneIndex(const String boneName) const
- unsigned GetBoneIndex(const Bone* bone) const
- Bone* GetBoneParent(const Bone* bone)

### Properties


- unsigned numBones (readonly)
- Bone* rootBone (readonly)



---

## Bone



### Methods


- Bone() (GC)
- Bone* new()
- void delete()

### Properties


- String name
- StringHash nameHash
- unsigned parentIndex
- Vector3 initialPosition
- Quaternion initialRotation
- Vector3 initialScale
- Matrix3x4 offsetMatrix
- bool animated
- char collisionMask
- float radius
- BoundingBox boundingBox
- Node* node



---

