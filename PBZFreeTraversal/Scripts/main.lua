-- PBZFreeTraversal 0.1.2-preview：独立运行时补丁，不覆盖游戏脚本。
local PREFIX='[PBZFreeTraversal] '
local function log(s) print(PREFIX..s..'\n') end
local healthy=true
local function confirmationText()
 local function read(path)
  local lib=StaticFindObject(path)
  if not lib or not lib:IsValid()then return nil end
  local value=lib:GetCurrentLanguage()
  return type(value)=='string'and value or value:ToString()
 end
 local ok,lang=pcall(read,'/Script/EasyLocalizationTool.Default__ELTBlueprintLibrary')
 if not ok or not lang or lang==''then ok,lang=pcall(read,'/Script/Engine.Default__KismetInternationalizationLibrary')end
 lang=ok and type(lang)=='string'and lang:lower()or 'en'
 if lang:match('^zh')then return '确认穿行？本次穿行不消耗穿行符。' end
 return 'Travel now? No traversal charm will be consumed.'
end
local function activeMap()
 local cls=StaticFindObject('/Script/CommonUI.CommonActivatableWidget')
 if not cls or not cls:IsValid() then return false end
 for _,map in ipairs(FindObjects(8,'WB_MapNew_C',nil,0,EObjectFlags.RF_ClassDefaultObject,false) or {}) do
  if map:IsValid() and map.MapClickSurface:IsValid() then
   local outer=map:GetOuter()
   local host=outer:IsValid() and outer:GetOuter() or nil
   if host and host:IsValid() and host:IsA(cls) and host:IsActivated() then
    local visible=true; local parent=map
    for _=1,10 do
     local visibility=parent:GetVisibility()
     if visibility==1 or visibility==2 then visible=false;break end
     parent=parent:GetParent();if not parent:IsValid()then break end
    end
    if visible then return true end
   end
  end
 end
 return false
end
local function charm(param) return param:get():ToString():lower()=='item_traversing' end
local function guarded(fn)
 return function(...)
  if not healthy then return end
  local ok,err=pcall(fn,...)
  if not ok then healthy=false;log('DISABLED '..tostring(err)) end
 end
end
local hooks={}
local function hook(path,pre,post)
 local a,b=RegisterHook(path,pre,post);hooks[#hooks+1]={path,a,b}
end
ExecuteWithDelay(12000,function()
 local ok,err=pcall(function()
  -- 启动时确认函数参数结构，变化时拒绝启用。
  local expected={
   {'/Script/ProjectPBZ.PBZBackPackSubsystem:GetItemNumInfo',{'PropID','CurrentNum','MaxNum'}},
   {'/Script/ProjectPBZ.PBZBackPackSubsystem:RemovePropsFromBackPack',{'Num','ItemId','bSendBroadcast'}}
  }
  for _,entry in ipairs(expected)do
   local f=StaticFindObject(entry[1]);assert(f and f:IsValid(),'missing '..entry[1])
   local names={};f:ForEachProperty(function(p)names[#names+1]=p:GetFName():ToString()end)
   assert(#names==#entry[2],'parameter count changed')
   for i,name in ipairs(entry[2])do assert(names[i]==name,'parameter changed '..name)end
  end
  hook(expected[1][1],function()end,guarded(function(context,id,current,max)
   if charm(id) and current:get()==0 and activeMap()then current:set(1);log('ZERO_CHARM_GATE_ALLOWED')end
  end))
  local dialog='/Script/ProjectPBZ.PBZItemCostDialogDescriptor:CreateItemCostConfirmationYesNo'
  assert(StaticFindObject(dialog):IsValid(),'missing confirmation factory')
  hook(dialog,guarded(function(context,world,header,body,display,id,cost)
   if charm(id) and activeMap()then
    body:set(FText(confirmationText()))
    cost:set(0)
    log('FREE_CONFIRMATION')
   end
  end))
  hook(expected[2][1],guarded(function(context,num,id,broadcast)
   if charm(id) and num:get()==1 and activeMap()then num:set(0);log('CHARM_COST_ZERO')end
  end))
 end)
 if not ok then
  healthy=false
  for _,h in ipairs(hooks)do UnregisterHook(h[1],h[2],h[3])end
  log('INCOMPATIBLE '..tostring(err));return
 end
 log('READY 0.1.2-preview; map-scoped; no file override')
end)
