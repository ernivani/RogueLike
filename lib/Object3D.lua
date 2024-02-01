-- lib/Object3D.lua

Object3D = {}
Object3D.__index = Object3D

function Object3D:new(vertices, edges)
    vertices = vertices or {}  
    edges = edges or {}       
    return setmetatable({vertices = vertices, edges = edges}, Object3D)
end


function Object3D:translate(translation)
    local newVertices = {}
    for i, vertex in ipairs(self.vertices) do
        newVertices[i] = vertex:add(translation)
    end
    return Object3D:new(newVertices, self.edges)
end

function Object3D:scale(scalar)
    local newVertices = {}
    for i, vertex in ipairs(self.vertices) do
        newVertices[i] = vertex:scale(scalar)
    end
    return Object3D:new(newVertices, self.edges)
end

function Object3D:rotate(rotation)
    local newVertices = {}
    for i, vertex in ipairs(self.vertices) do
        newVertices[i] = vertex:rotate(rotation)
    end
    return Object3D:new(newVertices, self.edges)
end

function Object3D:project(camera)
    local newVertices = {}
    for i, vertex in ipairs(self.vertices) do
        newVertices[i] = vertex:project(camera)
    end
    return Object3D:new(newVertices, self.edges)
end

function Object3D:draw()
    for i, edge in ipairs(self.edges) do
        local v1 = self.vertices[edge[1]]
        local v2 = self.vertices[edge[2]]
        love.graphics.line(v1.x, v1.y, v2.x, v2.y)
    end
end

return Object3D