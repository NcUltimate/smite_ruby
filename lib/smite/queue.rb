module Smite
  class Queue < Smite::Object
    QUEUES = [
      { 'name' => 'Conquest', 'id' => 426 },
      { 'name' => 'MOTD', 'id' => 434 },
      { 'name' => 'Arena', 'id' => 435 },
      { 'name' => 'JoustLeague', 'id' => 440 },
      { 'name' => 'Assault', 'id' => 445 },
      { 'name' => 'Joust3v3', 'id' => 448 },
      { 'name' => 'ConquestLeague', 'id' => 451 },
      { 'name' => 'MOTD', 'id' => 465 },
      { 'name' => 'Clash', 'id' => 466 },
    ]

    def inspect
      "#<Smite::Queue #{id} #{name}>"
    end
  end
end