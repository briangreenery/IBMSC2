class StaticController < ApplicationController
  def random
    @random_map = [ 'Antiga Shipyard', 'Cloud Kingdom', 'Condemned Ridge', 'Daybreak',
                    'Entombed Valley', 'Ohana', 'Shakuras Plateau', 'Tal\'Darim Altar' ].choice

    idra = "idrA"
    mc = "MC"
    apollo = "dApollo"
    artosis = "Artosis"
    mma = "MMA"
    whitera = "WhiteRa"
    destiny = "Destiny"
    naniwa = "NaNiwa"

    @random_quote = [
      {
        :text => "It turns out the game is a lot harder when you can't see the whole map.",
        :name => idra
      },
      {
        :text => "MarineKing is only king of marine, I am king of all units.",
        :name => mc
      },
      {
        :text => "I don't know how to cheese. I tried cheesing once, ended up expanding.",
        :name => apollo
      },
      {
        :text => "When your opponent attacks, defend. If he defends, expand. If he expands, attack.",
        :name => artosis
      },
      {
        :text => "Three years no girl, only game.",
        :name => mma
      },
      {
        :text => "you're really good at making carriers, very useful talent toi have",
        :name => idra
      },
      {
        :text => "apologize for playing that race",
        :name => idra
      },
      {
        :text => "Terran micro is silly",
        :name => idra
      }
      {
        :text => "Is no problem, I use Special Tactics",
        :name => whitera
      },
      {
        :text => "I only make ultralisks when I'm really far ahead and want to lose.",
        :name => destiny
      },
      {
        :text => "We make expand then defense it",
        :name => whitera
      },
      {
        :text => "Forge fast expand or die trying",
        :name => naniwa
      },
      {
        :text => "Battlecrusier operational",
        :name => "Terran Battlecruiser"
      },
      {
        :text => "My life for Auir",
        :name => "Protoss Zealot"
      },
      {
        :text => "I'm a thor! Click me!",
        :text => "Terran Thor"
      }

    ].choice
  end
end
