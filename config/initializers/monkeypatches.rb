# instead of !!foo == foo 
# here is a more OO way (used in specs)
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end