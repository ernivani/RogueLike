-- lib/Vector3.lua
Vector3 = {}
Vector3.__index = Vector3

function Vector3:new(x, y, z)
    return setmetatable({x = x or 0, y = y or 0, z = z or 0}, Vector3)
end

function Vector3:add(other)
    return Vector3:new(self.x + other.x, self.y + other.y, self.z + other.z)
end

function Vector3:subtract(other)
    return Vector3:new(self.x - other.x, self.y - other.y, self.z - other.z)
end

function Vector3:scale(scalar)
    return Vector3:new(self.x * scalar, self.y * scalar, self.z * scalar)
end

function Vector3:dot(other)
    return self.x * other.x + self.y * other.y + self.z * other.z
end

function Vector3:cross(other)
    return Vector3:new(
        self.y * other.z - self.z * other.y,
        self.z * other.x - self.x * other.z,
        self.x * other.y - self.y * other.x
    )
end

function Vector3:rotate(rotation)
    local x = self.x
    local y = self.y
    local z = self.z
    local cos = math.cos(rotation)
    local sin = math.sin(rotation)
    local newx = x * cos - y * sin
    local newy = x * sin + y * cos
    return Vector3:new(newx, newy, z)
end

function Vector3:project(camera)
    local x = self.x
    local y = self.y
    local z = self.z
    local cameraX = camera.position.x
    local cameraY = camera.position.y
    local cameraZ = camera.position.z
    local cameraAngle = camera.angle
    local cameraCos = math.cos(cameraAngle)
    local cameraSin = math.sin(cameraAngle)
    local cameraFocalLength = camera.focalLength
    local newx = (x - cameraX) * cameraCos + (y - cameraY) * cameraSin
    local newy = (y - cameraY) * cameraCos - (x - cameraX) * cameraSin
    local newz = z - cameraZ
    local newx = newx / newz * cameraFocalLength
    local newy = newy / newz * cameraFocalLength
    return Vector3:new(newx, newy, newz)
end

return Vector3
