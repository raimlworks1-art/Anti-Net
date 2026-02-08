--[[
   
   Anti-Net
   By Rai
   
   A anti network system dedicated to decrypt runtime remotes with hidden names
   With Universal Support.
   
   Config
      getgenv.Config() = {}
         Yielding -> Bool
         Runtime -> Bool
         Path -> Instance | If you want to decrypt Remotes in a selected folder, Please Add the path of the folder
         Id -> PlaceId | optional
         
         Note: Id is not yet implemented.
    
    Functions
      Decrypt() -> Decrypts runtime name hidden remotes
      
      
    
]]--

local Log = loadstring(game:HttpGet("https://raw.githubusercontent.com/raimlworks1-art/Log_Sys/refs/heads/main/Main.lua"))()

local Net = {}

local Config = getgenv().Config or {
  Yielding = false, 
  Runtime = true, -- Should be true, ALWAYS
  Path = nil, 
  Id = 0
}

--// For Easy Access \\--
local Y = Config.Yielding
local R = Config.Runtime
local P = Config.Path

function GC(Parm)
   local suc, res = pcall(getgc(), Parm)
   return suc, res or {}
end

Net.Decrypt = function()
    local Funcs, Remotes
    local count = 0

    Log.log("S", "Decrypting...")

    -- if Path was set to nil then the Decryptor will use this
    if not P then
       for _, C in pairs(GC(true)) do
        if type(C) ~= "function" then
            continue
        end

        count += 1

        local Name = debug.info(C, "n")

        if Name then
            if not Remotes and Name:match("GetEventHandler") then
                Remotes = C
                Log.log("S", "Found Remote Handler: " .. Name)
            end

            if not Funcs and Name:match("GetFunctionHandler") then
                Funcs = C
                Log.log("S", "Found Function Handler: " .. Name)
            end
        end

        if Y and count % 100 == 0 then
            task.wait(0.1)
            Log.log("W", "Processed " .. count .. " Funcs")
        end

        if Remotes and Funcs then
            Log.log("S", "Both Handlers Found, Scan Stopping.")
            break
        end
    end

    local Events, Functions

    if Remotes then
        Events = getupvalue(Remotes, 1)
        Log.log("S", "Successfully Extracted Remote Events From Remote Handler.")
    else
        Log.log("F", "Remote Handler Was Not Found")
    end

    if Funcs then
        Functions = getupvalue(Funcs, 1)
        Log.log("S", "Successfully Extracted Functions From Function Handler")
    else
        Log.log("W", "Function Handler Was Not Found")
    end

    if Events then
        for Name, Tbl in next, Events do
            if Tbl.Remote then
                Tbl.Remote.Name = Name
                
            end
        end
    end

    if Functions then
        for Name, Tbl in next, Functions do
            if Tbl.Remote then
                Tbl.Remote.Name = Name
                
            end
        end
    end
    end
    
    -- A different scenario if Path Was not nil
    if P then
    if typeof(P) == "Instance" and P:IsA("Folder") then
        Log.log("S", "Using Custom Path: " .. P:GetFullName())
        
        for _, C in pairs(P:GetDescendants()) do
            if C:IsA("RemoteEvent") or C:IsA("RemoteFunction") then
                -- we still find the handler
                for _, Func in pairs(GC(true)) do
                    if type(Func) ~= "function" then
                        continue
                    end
                    
                    local Name = debug.info(Func, "n")
                    
                    if Name then
                        local Handler
                        if C:IsA("RemoteEvent") and Name:match("GetEventHandler") then
                            Handler = getupvalue(Func, 1)
                        elseif C:IsA("RemoteFunction") and Name:match("GetFunctionHandler") then
                            Handler = getupvalue(Func, 1)
                        end
                        
                        if Handler then
                            for HandlerName, Tbl in next, Handler do
                                if Tbl.Remote == C then
                                    C.Name = HandlerName
                                    Log.log("S", "Decrypted: " .. C.ClassName .. " -> " .. HandlerName)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        
        Log.log("S", "Path Decryption Finished.")
    else
        Log.log("W", "Path is not a valid Folder Instance")
    end
end

    Log.log("S", "Decryption Finished.")
    return Funcs, Remotes
end

if R then
    local run, res = pcall(Net.Decrypt)
    if not run then 
        Log.log("F", "Failed To Run | ", res)
    end
end

return Net
