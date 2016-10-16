include("types.jl")
function makeScoreMatrix(input::String, match::Int, mismatch::Int, space::Int)
	strands = readlines(input)
	mat = matrixFactory(strands[1], strands[2])
	scores = Scores(space, match, mismatch)
	(x,y) = size(mat.matrix)
	for i = 1:x
		for j = 1:y
			setindex!(mat.matrix , getScore(mat, scores,i,j), i,j)
		end
	end
	return mat
end
function traceback(score_matrix::ScoreMatrix)
	last_i, last_j = size(score_matrix.matrix)
	curr = Point(size(score_matrix.matrix))
	last = Point(1,1)
	strA = ""
	strB = ""
	while curr != last
		element::Cell = getindex(score_matrix,curr.i, curr.j)
		if element.direction == UP
			strB = string(score_matrix.strandB[curr.i-1], strB)
			strA = string("-" , strA)
		elseif element.direction == LEFT
			strA =  string(score_matrix.strandA[curr.j-1] ,strA)
			strB = string("-", strB)
		elseif element.direction == DIAG
			strA = string(score_matrix.strandA[curr.j-1], strA)
			strB = string(score_matrix.strandB[curr.i-1],strB)
		end
		curr = element.traceback
	end
	println(strA)
	println(strB)
	println(getindex(score_matrix, last_i, last_j).score)
end
function getScore(matrix::ScoreMatrix, scores::Scores, i::Int, j::Int)
	#TODO make sure it follows highroad traceback
	if i == 1 && j == 1
		return Cell(0, Point(1,1),UP)
	end
	left::Number = -Inf
	up::Number = -Inf
	diag::Number = -Inf
	if i > 1
		up  = getindex(matrix,i-1  ,j ).score + scores.space	
	end
	if j > 1
		left = getindex(matrix, i, j-1 ).score + scores.space
	end
	if j >1 && i > 1
		if matrix.strandA[i- 1] == matrix.strandB[j - 1]
			diag = getindex(matrix, i-1 , j-1).score +scores.match
		else
			diag = getindex(matrix, i-1, j-1).score +scores.mismatch
		end
	end
	upTuple::Tuple{Float64, DIRECTION} = (up, UP)
	leftTuple::Tuple{Float64, DIRECTION} = (left, LEFT)
	diagTuple::Tuple{Float64, DIRECTION} = (diag, DIAG)
	list = sort([ leftTuple,diagTuple,upTuple],alg=MergeSort, by= x->x[1])
	best::Tuple{Float64,DIRECTION} = list[3]
	dir::DIRECTION = best[2]
	pt::Point = Point(0,0)
	if dir == UP
		pt = Point(i-1, j)
	elseif dir == LEFT
		pt = Point(i, j-1)
	elseif dir == DIAG
		pt = Point(i-1,j-1)
	else 
		println("error generating point")
	end
	return Cell(best[1], pt, best[2])
end

function getOptimalScore(matrix::ScoreMatrix)
	last_i, last_j = size(matrix.matrix)
	max = -Inf
	for i = 1:last_i
		for j =1:last_j
			if max < getindex(matrix, i, j).score
				max = getindex(matrix, i,j).score
			end
		end
	end
	max
end	

if length(ARGS) > 1
	println("running on $(ARGS[1])")
	mat = makeScoreMatrix(ARGS[1],parse(Int64,ARGS[2]),parse(Int64,ARGS[3]), parse(Int64,ARGS[4]))
	traceback(mat)
end
