module StarWars
  module Data

    Human   = Struct.new('Human', :id, :name, :friends, :appears_in, :home_planet)
    Droid   = Struct.new('Droid', :id, :name, :friends, :appears_in, :primary_function)

    Luke    = Human.new('1000', 'Like Skywalker',   ['1002', '1003', '2000', '2001'],   [4, 5, 6], 'Tatooine')
    Vader   = Human.new('1001', 'Darth Vader',      ['1004'],                           [4, 5, 6], 'Tatooine')
    Han     = Human.new('1002', 'Han Solo',         ['1000', '1003', '2001'],           [4, 5, 6])
    Leia    = Human.new('1003', 'Lea Organa',       ['1000', '1002', '2000', '2001'],   [4, 5, 6], 'Alderaan')
    Tarkin  = Human.new('1004', 'Wilhuff Tarkin',   ['1001'],                           [4])

    ThreePO = Droid.new('2000', 'C-3PO',            ['1000', '1002', '1003', '2001'],   [4, 5, 6], 'Protocol')
    Artoo   = Droid.new('2001', 'R3-D2',            ['1000', '1002', '1003'],           [4, 5, 6], 'Astromech')

  end
end
