# Navigation Module

UrhoX Lua API - Navigation Module

---

## Classes

- [NavigationMesh](#navigationmesh)
- [DynamicNavigationMesh](#dynamicnavigationmesh)
- [Navigable](#navigable)
- [NavArea](#navarea)
- [NavigationGeometryInfo](#navigationgeometryinfo)
- [OffMeshConnection](#offmeshconnection)
- [Obstacle](#obstacle)
- [CrowdManager](#crowdmanager)
- [CrowdAgent](#crowdagent)

---

**Inherits from**: Component

## NavigationMesh : Component


### Methods


- void SetTileSize(int size)
- void SetCellSize(float size)
- void SetCellHeight(float height)
- void SetAgentHeight(float height)
- void SetAgentRadius(float radius)
- void SetAgentMaxClimb(float maxClimb)
- void SetAgentMaxSlope(float maxSlope)
- void SetRegionMinSize(float size)
- void SetRegionMergeSize(float size)
- void SetEdgeMaxLength(float length)
- void SetEdgeMaxError(float error)
- void SetDetailSampleDistance(float distance)
- void SetDetailSampleMaxError(float error)
- void SetPadding(const Vector3& padding)
- void SetAreaCost(unsigned areaID, float cost)
- bool Allocate(const BoundingBox& boundingBox, unsigned maxTiles)
- bool Build()
- bool Build(const BoundingBox& boundingBox)
- bool Build(const IntVector2& from, const IntVector2& to)
- VectorBuffer GetTileData(const IntVector2& tile) const
- bool AddTile(const VectorBuffer& tileData)
- void RemoveTile(const IntVector2& tile)
- void RemoveAllTiles()
- bool HasTile(const IntVector2& tile) const
- BoundingBox GetTileBoudningBox(const IntVector2& tile) const
- IntVector2 GetTileIndex(const Vector3& position) const
- void SetPartitionType(NavmeshPartitionType aType)
- void SetDrawOffMeshConnections(bool enable)
- void SetDrawNavAreas(bool enable)
- Vector3 FindNearestPoint(const Vector3& point)
- Vector3 FindNearestPoint(const Vector3& point, const Vector3& extents)
- Vector3 MoveAlongSurface(const Vector3& start, const Vector3& end)
- Vector3 MoveAlongSurface(const Vector3& start, const Vector3& end, const Vector3& extents, int maxVisited = 3)
- const PODVector<Vector3>& FindPath(const Vector3& start, const Vector3& end)
- const PODVector<Vector3>& FindPath(const Vector3& start, const Vector3& end, const Vector3& extents)
- Vector3 GetRandomPoint()
- Vector3 GetRandomPointInCircle(const Vector3& center, float radius)
- Vector3 GetRandomPointInCircle(const Vector3& center, float radius, const Vector3& extents)
- float GetDistanceToWall(const Vector3& point, float radius)
- float GetDistanceToWall(const Vector3& point, float radius, const Vector3& extents)
- Vector3 Raycast(const Vector3& start, const Vector3& end)
- Vector3 Raycast(const Vector3& start, const Vector3& end, const Vector3& extents)
- void DrawDebugGeometry(bool depthTest)
- int GetTileSize() const
- float GetCellSize() const
- float GetCellHeight() const
- float GetAgentHeight() const
- float GetAgentRadius() const
- float GetAgentMaxClimb() const
- float GetAgentMaxSlope() const
- float GetRegionMinSize() const
- float GetRegionMergeSize() const
- float GetEdgeMaxLength() const
- float GetEdgeMaxError() const
- float GetDetailSampleDistance() const
- float GetDetailSampleMaxError() const
- const Vector3& GetPadding() const
- float GetAreaCost(unsigned areaID) const
- bool IsInitialized() const
- const BoundingBox& GetBoundingBox() const
- BoundingBox GetWorldBoundingBox() const
- IntVector2 GetNumTiles() const
- NavmeshPartitionType GetPartitionType()
- bool GetDrawOffMeshConnections() const
- bool GetDrawNavAreas() const

### Properties


- int tileSize
- float cellSize
- float cellHeight
- float agentHeight
- float agentRadius
- float agentMaxClimb
- float agentMaxSlope
- float regionMinSize
- float regionMergeSize
- float edgeMaxLength
- float edgeMaxError
- float detailSampleDistance
- float detailSampleMaxError
- Vector3& padding
- NavmeshPartitionType partitionType
- bool drawOffMeshConnections
- bool drawNavAreas
- bool initialized (readonly)
- BoundingBox& boundingBox (readonly)
- BoundingBox worldBoundingBox (readonly)
- IntVector2 numTiles (readonly)



---

**Inherits from**: NavigationMesh

## DynamicNavigationMesh : NavigationMesh


### Methods


- void SetDrawObstacles(bool enable)
- void SetMaxLayers(unsigned maxLayers)
- void SetMaxObstacles(unsigned maxObstacles)
- bool GetDrawObstacles() const
- unsigned GetMaxLayers() const
- unsigned GetMaxObstacles() const

### Properties


- bool drawObstacles
- int maxObstacles
- unsigned maxLayers



---

**Inherits from**: Component

## Navigable : Component


### Methods


- void SetRecursive(bool enable)
- bool IsRecursive() const

### Properties


- bool recursive



---

**Inherits from**: Component

## NavArea : Component


### Methods


- unsigned GetAreaID() const
- void SetAreaID(unsigned tolua_var_3)
- BoundingBox GetBoundingBox()
- void SetBoundingBox(const BoundingBox& bnds)
- BoundingBox GetWorldBoundingBox() const

### Properties


- unsigned areaID
- BoundingBox boundingBox
- BoundingBox worldBoundingBox (readonly)



---

## NavigationGeometryInfo



### Properties


- Component* component
- unsigned lodLevel
- Matrix3x4 transform
- BoundingBox boundingBox



---

**Inherits from**: Component

## OffMeshConnection : Component


### Methods


- void SetEndPoint(Node* node)
- void SetRadius(float radius)
- void SetBidirectional(bool enabled)
- void SetMask(unsigned newMask)
- void SetAreaID(unsigned newAreaID)
- Node* GetEndPoint() const
- float GetRadius() const
- bool IsBidirectional() const
- unsigned GetMask() const
- unsigned GetAreaID() const

### Properties


- Node* endPoint
- float radius
- bool bidirectional
- unsigned mask
- unsigned areaID



---

**Inherits from**: Component

## Obstacle : Component


### Methods


- void DrawDebugGeometry(bool depthTest)
- void SetRadius(float radius)
- void SetHeight(float height)
- float GetRadius() const
- float GetHeight() const

### Properties


- float radius
- float height



---

**Inherits from**: Component

## CrowdManager : Component


### Methods


- void DrawDebugGeometry(bool depthTest)
- void SetCrowdTarget(const Vector3& position, Node* node = 0)
- void SetCrowdVelocity(const Vector3& velocity, Node* node = 0)
- void ResetCrowdTarget(Node* node = 0)
- void SetMaxAgents(unsigned agentCt)
- void SetMaxAgentRadius(float maxAgentRadius)
- void SetNavigationMesh(NavigationMesh* navMesh)
- void SetIncludeFlags(unsigned queryFilterType, short flags)
- void SetExcludeFlags(unsigned queryFilterType, short flags)
- void SetAreaCost(unsigned queryFilterType, unsigned areaID, float cost)
- void SetObstacleAvoidanceParams(unsigned obstacleAvoidanceType, const CrowdObstacleAvoidanceParams& params)
- PODVector<CrowdAgent*> GetAgents(Node* node = 0, bool inCrowdFilter = true) const
- Vector3 FindNearestPoint(const Vector3& point, int queryFilterType)
- Vector3 MoveAlongSurface(const Vector3& start, const Vector3& end, int queryFilterType, int maxVisited = 3)
- const PODVector<Vector3>& FindPath(const Vector3& start, const Vector3& end, int queryFilterType)
- Vector3 GetRandomPoint(int queryFilterType)
- Vector3 GetRandomPointInCircle(const Vector3& center, float radius, int queryFilterType)
- float GetDistanceToWall(const Vector3& point, float radius, int queryFilterType, Vector3* hitPos = 0, Vector3* hitNormal = 0)
- Vector3 Raycast(const Vector3& start, const Vector3& end, int queryFilterType, Vector3* hitNormal = 0)
- unsigned GetMaxAgents() const
- float GetMaxAgentRadius() const
- NavigationMesh* GetNavigationMesh() const
- unsigned GetNumQueryFilterTypes() const
- unsigned GetNumAreas(unsigned queryFilterType) const
- short GetIncludeFlags(unsigned queryFilterType) const
- short GetExcludeFlags(unsigned queryFilterType) const
- float GetAreaCost(unsigned queryFilterType, unsigned areaID) const
- unsigned GetNumObstacleAvoidanceTypes() const
- const CrowdObstacleAvoidanceParams& GetObstacleAvoidanceParams(unsigned obstacleAvoidanceType) const

### Properties


- int maxAgents
- float maxAgentRadius
- NavigationMesh* navigationMesh



---

**Inherits from**: Component

## CrowdAgent : Component


### Methods


- void DrawDebugGeometry(bool depthTest)
- void SetTargetPosition(const Vector3& position)
- void SetTargetVelocity(const Vector3& velocity)
- void ResetTarget()
- void SetUpdateNodePosition(bool unodepos)
- void SetMaxAccel(float maxAccel)
- void SetMaxSpeed(float maxSpeed)
- void SetRadius(float radius)
- void SetHeight(float height)
- void SetQueryFilterType(unsigned queryFilterType)
- void SetObstacleAvoidanceType(unsigned obstacleOvoidanceType)
- void SetNavigationQuality(NavigationQuality val)
- void SetNavigationPushiness(NavigationPushiness val)
- Vector3 GetPosition() const
- Vector3 GetDesiredVelocity() const
- Vector3 GetActualVelocity() const
- const Vector3& GetTargetPosition() const
- const Vector3& GetTargetVelocity() const
- CrowdAgentRequestedTarget GetRequestedTargetType() const
- CrowdAgentState GetAgentState() const
- CrowdAgentTargetState GetTargetState() const
- bool GetUpdateNodePosition() const
- float GetMaxAccel() const
- float GetMaxSpeed() const
- float GetRadius() const
- float GetHeight() const
- unsigned GetQueryFilterType() const
- unsigned GetObstacleAvoidanceType() const
- NavigationQuality GetNavigationQuality() const
- NavigationPushiness GetNavigationPushiness() const
- bool HasRequestedTarget() const
- bool HasArrived() const
- bool IsInCrowd() const

### Properties


- Vector3 targetPosition
- Vector3 targetVelocity
- bool updateNodePosition
- float maxAccel
- float maxSpeed
- float radius
- float height
- unsigned queryFilterType
- unsigned obstacleAvoidanceType
- NavigationQuality navigationQuality
- NavigationPushiness navigationPushiness
- Vector3 position (readonly)
- Vector3 desiredVelocity (readonly)
- Vector3 actualVelocity (readonly)
- CrowdAgentRequestedTarget requestedTargetType (readonly)
- CrowdAgentState agentState (readonly)
- CrowdAgentTargetState targetState (readonly)
- bool requestedTarget (readonly)
- bool arrived (readonly)
- bool inCrowd (readonly)



---

