module GraphQL

  # String Scalar
  #
  String = GraphQL::Type::Scalar.new do
    name "String"

    coerce -> (value) { value.to_s }

    coerceLiteral -> (ast) { ast[:kind] == :string ? ast[:value] : nil }
  end

  # Int Scalar
  #
  Int = GraphQL::Type::Scalar.new do
    name "Int"

    coerce -> (value) { value.is_a?(Integer) ? value : nil }

    coerceLiteral -> (ast) { ast[:kind] == :int ? ast[:value].to_i : nil }
  end

  # Float Scalar
  #
  Float = GraphQL::Type::Scalar.new do
    name "Float"

    coerce -> (value) { value.is_a?(Number) ? value : nil }

    coerceLiteral -> (ast) { ast[:kind] == :float || ast[:kind] == :int ? ast[:value].to_f : nil }
  end

  # Boolean Scalar
  #
  Boolean = GraphQL::Type::Scalar.new do
    name "Boolean"

    coerce -> (value) { !!value }

    coerceLiteral -> (ast) { ast[:kind] == :boolean ? ast[:value] : nil }
  end

  # ID Scalar
  #
  ID = GraphQL::Type::Scalar.new do
    name "ID"

    coerce -> (value) { value.to_s }

    coerceLiteral -> (ast) { ast[:kind] == :string || ast[:kind] == :int ? ast[:value] : nil }
  end

end
