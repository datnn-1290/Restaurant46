json.dishes do
  json.array!(@dishes) do |dish|
    json.name dish.name
    json.url dish_path(dish)
  end
end
