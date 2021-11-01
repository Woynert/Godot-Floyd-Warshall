extends Node2D

#number of nodes
var n
var line
var label

func _ready():
	
	#create empty matrix
	n = $container.get_children().size()
	print(n)
	
	var matrix=[]
	for x in range(n):
		matrix.append([])
		for y in range(n):
			matrix[x].append(null)
	
	#get distances between nodes
	for ic in range($container.get_child_count()):
		
		var i = $container.get_children()[ic]
		
		#set node label
		i.get_node("./Label").text = str(ic+1)
		
		for jc in range($container.get_child_count()):
			
			var j = $container.get_children()[jc]
			
			#check if has direct conection
			$RayCast.position.x = i.position.x
			$RayCast.position.y = i.position.y
			
			$RayCast.cast_to.x = j.position.x - i.position.x
			$RayCast.cast_to.y = j.position.y - i.position.y
			
			#detect wall
			$RayCast.force_raycast_update()
			if (not $RayCast.is_colliding()):
				
				#no ha sido calculad
				if (matrix[jc][ic] == null):
					
					var dist = int(sqrt(pow(abs(i.position.x - j.position.x),2) + pow(abs(i.position.y - j.position.y),2)))
					matrix[jc][ic] = dist
					
					#create line and label
					if (dist != 0):
						line = Line2D.new()
						label = Label.new()
						$Decoration.add_child(line)
						$Decoration.add_child(label)
						
						line.width = 2
						line.add_point(Vector2(i.position.x, i.position.y))
						line.add_point(Vector2(j.position.x, j.position.y))
						
						label.text = str(dist)
						label.rect_position.x = (i.position.x + j.position.x)/2
						label.rect_position.y = (i.position.y + j.position.y)/2
				else:
					matrix[ic][jc] = matrix[jc][ic]
			
		
	printMatrix(matrix)
	
	#apply algorithm
	floyd(matrix)
	
	printMatrix(matrix)

#imprimir matrix
func printMatrix(matrix):
	print("")
	var txt
	for i in matrix:
		txt = ""
		for j in i:
			txt += str(j) + ", "
		print(txt)

#pair shortest path 
func floyd(mat):
	
	for k in range(n):
		for i in range(n):
			for j in range(n):
				#si los dos nuevos son enteros
				if (mat[i][k] != null and mat[k][j] != null):
					if (mat[i][j] != null):
						if (mat[i][j] > mat[i][k] + mat[k][j]):
							mat[i][j] = mat[i][k] + mat[k][j]
					else:
						mat[i][j] = mat[i][k] + mat[k][j]
				else:
					continue
				
		
