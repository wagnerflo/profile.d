local outputs = {}

outputs["Mixxx Master"] = {
   "alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH30240QFZL1MQAP-00.analog-stereo",
}

outputs["Mixxx Headphones"] = {
   "bluez_output.FC_58_FA_2D_2E_A4.1",
   "bluez_output.98_D3_31_87_03_88.1",
}

local self = {}
self.scanning = false
self.pending_rescan = false

linkables_om = ObjectManager { Interest { type = "SiLinkable" } }
links_om = ObjectManager { Interest { type = "SiLink" } }

function findNode (name)
   return linkables_om:lookup {
      Constraint { "node.name", "=", name }
   }
end

function findLink (src, tgt)
   return links_om:lookup {
      Constraint { "out.item.id", "=", src.id },
      Constraint { "in.item.id", "=", tgt.id }
   }
end

function scheduleRescan (om)
   if self.scanning then
      self.pending_rescan = true
      return
   end

   self.scanning = true
   rescan()
   self.scanning = false

   if self.pending_rescan then
      self.pending_rescan = false
      Core.sync(scheduleRescan)
   end
end

function rescan()
   for src,tgts in pairs(outputs) do
      local src_node = findNode(src)
      if src_node ~= nil then
         for _,tgt in pairs(tgts) do
            local tgt_node = findNode(tgt)
            if tgt_node ~= nil then
               handleLink(src_node, tgt_node)
            end
         end
      end
   end
end

function handleLink (src, tgt)
   if findLink(src, tgt) then
      return
   end

   local si_link = SessionItem ( "si-standard-link" )
   if not si_link:configure {
      ["out.item"] = src,
      ["in.item"] = tgt,
      ["out.item.port.context"] = "output",
      ["in.item.port.context"] = "input",
      ["passive"] = false,
   } then
      Log.warning (si_link, "failed to configure si-standard-link")
      return
   end

   si_link:register()
   si_link:activate(
      Feature.SessionItem.ACTIVE,
      function (l, e)
         if e then
            Log.warning (l, "failed to activate si-standard-link: " .. tostring(e))
            l:remove ()
         else
            Log.warning (l, "activated si-standard-link")
         end
      end
   )
end

linkables_om:connect("objects-changed", scheduleRescan)
linkables_om:activate()
links_om:activate()
