# Inverse Kinematics

UrhoX Lua API - Inverse Kinematics

---

## Classes

- [IKSolver](#iksolver)
- [IKEffector](#ikeffector)
- [IKConstraint](#ikconstraint)

---

**Inherits from**: Component

## IKSolver : Component


### Methods


- void RebuildChainTrees()
- void RecalculateSegmentLengths()
- void CalculateJointRotations()
- void Solve()
- void ApplyOriginalPoseToScene()
- void ApplySceneToOriginalPose()
- void ApplyActivePoseToScene()
- void ApplySceneToActivePose()
- void ApplyOriginalPoseToActivePose()
- void DrawDebugGeometry(bool depthTest)

### Properties


- IKSolver::Algorithm algorithm
- unsigned maximumIterations
- float tolerance
- bool JOINT_ROTATIONS
- bool TARGET_ROTATIONS
- bool UPDATE_ORIGINAL_POSE
- bool UPDATE_ACTIVE_POSE
- bool USE_ORIGINAL_POSE
- bool CONSTRAINTS
- bool AUTO_SOLVE



---

**Inherits from**: Component

## IKEffector : Component


### Methods


- Node* GetTargetNode() const
- void SetTargetNode(Node* targetNode)
- const String GetTargetName() const
- void SetTargetName(const String nodeName)
- const Vector3& GetTargetPosition() const
- void SetTargetPosition(const Vector3& targetPosition)
- const Quaternion& GetTargetRotation() const
- void SetTargetRotation(const Quaternion& targetRotation)
- unsigned GetChainLength() const
- void SetChainLength(unsigned chainLength)
- float GetWeight() const
- void SetWeight(float weight)
- float GetRotationWeight() const
- void SetRotationWeight(float weight)
- float GetRotationDecay() const
- void SetRotationDecay(float decay)

### Properties


- Node* targetNode
- String targetName
- Vector3 targetPosition
- Quaternion targetRotation
- unsigned chainLength
- float weight
- float rotationWeight
- float rotationDecay
- bool WEIGHT_NLERP
- bool INHERIT_PARENT_ROTATION



---

**Inherits from**: Component

## IKConstraint : Component


### Methods


- float GetStiffness() const
- void SetStiffness(float stiffness)
- float GetStretchiness() const
- void SetStretchiness(float stretchiness)
- const Vector2& GetLengthConstraints() const
- void SetLengthConstraints(const Vector2& lengthConstraints)



---

