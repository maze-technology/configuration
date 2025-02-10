locals {
  formatted_default_tags_values = lower(join("-", concat(
    [for v in values(var.default_tags) : replace(v, " ", "-")],
    ["Maze-Github"]
  )))
}
