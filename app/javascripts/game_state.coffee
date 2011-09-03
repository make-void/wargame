GameState = { 
  default: "browse",
  states: ["browse", "move", "attack"]
  
  # redefine current= and act on status change
  
} 

MoveState = {
  default: "wait",
  states: ["wait", "choose", "selected"]
}

AttackState = {
  default: "wait",
  states: ["wait", "choose", "selected"]
}