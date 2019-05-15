local graph = {}

 -- convert tensor of edges to adjacency list
function graph.tensorToAdj(edges)
    local adj = {}
    for i = 1, edges:size(1) do
        local edge = edges[i]
        local s, e = edge[1], edge[2]
        if not adj[s] then
            adj[s] = {}
        end
        table.insert(adj[s], e)
    end
    return adj
end

-- computes transitive closure of the given tensor of directed edges
function graph.transitiveClosure(edges)
    local adj = graph.tensorToAdj(edges)

    local edges = {}
    local function dfs(s, e) -- dfs starting from s, currently at e
        if e ~= s then
            table.insert(edges, {s,e})
        end
        if adj[e] then
            for _, e in ipairs(adj[e]) do
                dfs(s, e)
            end
        end
    end
    for s, _ in pairs(adj) do
        dfs(s, s)
    end

    -- remove duplicates from edges table
    local unique_edges = {}
    local hash = {}

    for i=1, #edges do
        hypo = edges[i][1]
        hyper = edges[i][2]
        label = hypo .. " " .. hyper
        if not hash[label] then
            unique_edges[#unique_edges+1] = edges[i]
            hash[label] = true
        end
    end

    return torch.LongTensor(unique_edges)
end

return graph
