function link_port(output_port, input_port)
   if not input_port or not output_port then
      return false
   end

   local link = Link(
      "link-factory", {
         ["link.input.node"] = input_port.properties["node.id"],
         ["link.input.port"] = input_port.properties["object.id"],
         ["link.output.node"] = output_port.properties["node.id"],
         ["link.output.port"] = output_port.properties["object.id"],
         ["object.id"] = nil,
         ["object.linger"] = true,
      }
   )
   link:activate(1)

   return true
end

function delete_link(link_om, output_port, input_port)
   if not input_port or not output_port then
      return false
   end

   local link = link_om:lookup {
      Constraint {
         "link.input.node", "equals", input_port.properties["node.id"]
      },
      Constraint {
         "link.input.port", "equals", input_port.properties["object.id"],
      },
      Constraint {
         "link.output.node", "equals", output_port.properties["node.id"],
      },
      Constraint {
         "link.output.port", "equals", output_port.properties["object.id"],
      }
   }

   if link then
      link:request_destroy()
   end
end

function autoroute(args)
   local output_om = ObjectManager {
      Interest {
         type = "port",
         args.from,
         Constraint { "port.direction", "equals", "out" }
      }
   }

   local input_om = ObjectManager {
      Interest {
         type = "port",
         args.to,
         Constraint { "port.direction", "equals", "in" }
      }
   }

   local all_links = ObjectManager {
      Interest {
         type = "link",
      }
   }

   local unless = nil

   if args.unless then
      unless = ObjectManager {
         Interest {
            type = "port",
            args.unless,
            Constraint { "port.direction", "equals", "in" }
         }
      }
   end

   function _connect()
      local delete_links = unless and unless:get_n_objects() > 0

      for output_name, input_name in pairs(args.ports) do
         local output = output_om:lookup {
            Constraint { "audio.channel", "equals", output_name } }
         local input =  input_om:lookup {
            Constraint { "audio.channel", "equals", input_name }
         }
         if delete_links then
            delete_link(all_links, output, input)
         else
            link_port(output, input)
         end
      end
   end

   output_om:connect("object-added", _connect)
   input_om:connect("object-added", _connect)
   all_links:connect("object-added", _connect)

   output_om:activate()
   input_om:activate()
   all_links:activate()

   if unless then
      unless:connect("object-added", _connect)
      unless:connect("object-removed", _connect)
      unless:activate()
   end
end

-- Master
autoroute {
   from = Constraint { "port.alias", "matches", "Mixxx Master:*" },
   to = Constraint { "object.path", "matches", "alsa:pcm:0:hw:sofhdadsp:*" },
   ports = {
      ["FL"] = "FL",
      ["FR"] = "FR"
   }
}

autoroute {
   from = Constraint { "port.alias", "matches", "Mixxx Master:*" },
   to = Constraint { "port.alias", "matches", "Traktor Audio 2 MK2:*" },
   ports = {
      ["FL"] = "FL",
      ["FR"] = "FR"
   }
}

-- Headphones
autoroute {
   from = Constraint { "port.alias", "matches", "Mixxx Headphones:*" },
   to = Constraint { "object.path", "matches",
                                "bluez_output.08_1E_46_C9_C2_68.1:*" },
   ports = {
      ["FL"] = "FL",
      ["FR"] = "FR"
   }
}

autoroute {
   from = Constraint { "port.alias", "matches", "Mixxx Headphones:*" },
   to = Constraint { "object.path", "matches",
                                "bluez_output.FC_58_FA_2D_2E_A4.1:*" },
   ports = {
      ["FL"] = "FL",
      ["FR"] = "FR"
   }
}

autoroute {
   from = Constraint { "port.alias", "matches", "Mixxx Headphones:*" },
   to = Constraint { "port.alias", "matches", "Traktor Audio 2 MK2:*" },
   ports = {
      ["FL"] = "RL",
      ["FR"] = "RR"
   }
}
