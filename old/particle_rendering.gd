extends GPUParticles2D

func _ready():
	#RenderingServer.canvas_item_set_visible(get_canvas_item(), true)
	RenderingServer.canvas_item_set_visible(self.get_canvas_item(), true)
