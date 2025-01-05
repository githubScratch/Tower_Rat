extends Polygon2D

@export var curve_depth := 40.0  # How deep the concave curve goes
@export var curve_width := 1.0   # How wide the curve spreads (0.1 to 2.0 recommended)
@export var segments := 30       # How smooth the curve is
@export var top_offset := 20.0   # How far down from the top the curve starts

func _ready():
	generate_concave_shape()

func generate_concave_shape():
	var points = PackedVector2Array()
	var width = 200  # Width of the shape
	var height = 300 # Height of the shape
	
	# Start from top-left
	points.push_back(Vector2(0, 0))
	
	# Generate top curved line
	for i in range(segments + 1):
		var t = float(i) / segments
		var x = t * width
		
		# Create concave curve using a modified quadratic function
		# This creates a deeper curve in the middle that tapers at the edges
		var normalized_x = (t - 0.5) * 2.0  # Convert t to range -1 to 1
		var curve_factor = 1.0 - pow(normalized_x * curve_width, 2)
		var y = curve_depth * curve_factor
		
		# Only apply curve if we're past the top_offset
		y = max(0, y)
		y += top_offset
		
		points.push_back(Vector2(x, y))
	
	# Add bottom-right corner
	points.push_back(Vector2(width, height))
	# Add bottom-left corner
	points.push_back(Vector2(0, height))
	
	polygon = points

# Optional: Add this if you want to adjust the curve in real-time
func update_curve(new_depth: float, new_width: float):
	curve_depth = new_depth
	curve_width = new_width
	generate_concave_shape()
