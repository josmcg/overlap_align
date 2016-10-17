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
	curr = getOptimalScore(score_matrix)
	last = Point(1,1)
	strA = ""
	strB = ""
	if curr != Point(size(score_matrix.matrix))
		strA = getoffset(score_matrix,curr, 1)
		strB = getoffset(score_matrix,curr,2)
	end
	while curr.j != 1
		element::Cell = getindex(score_matrix,curr.i, curr.j)
		if element.direction == UP
			strA = string(score_matrix.strandA[curr.i-1], strA)
			strB = string("-",strB)
		elseif element.direction == LEFT
			strA = string("-", strA)
			strB = string(score_matrix.strandB[curr.j-1],strB)
		elseif element.direction == DIAG
			strA = string(score_matrix.strandA[curr.i-1],strA)
			strB = string(score_matrix.strandB[curr.j-1],strB)
		end
		curr = element.traceback
	end
	intermediate = ""
	for i = 1:curr.i-1
		intermediate = string(intermediate, score_matrix.strandA[i])
		strB = string(" ", strB)
	end
	strA = string(intermediate, strA)
	println(strA)
	println(strB)
	pt::Point = getOptimalScore(score_matrix)
	i = pt.i
	j = pt.j
	println(getindex(score_matrix,i,j ).score)
end
function getScore(matrix::ScoreMatrix, scores::Scores, i::Int, j::Int)
	if i == 1 && j == 1
		return Cell(0, Point(1,1),UP)
	end
	if j == 1
		return Cell(0, Point(i-1,j), UP)
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
			diag = getindex(matrix, i-1 , j-1).score + scores.match
		else
			diag = getindex(matrix, i-1, j-1).score + scores.mismatch
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
	max::Cell = Cell(-Inf, Point(0,0), UP)
	maxpt::Point = Point(1,1)
	for j =1:last_j
		if max.score <= getindex(matrix, last_i, j).score
			max = getindex(matrix, last_i,j)
			maxpt = Point(last_i,j)
		end
	end
	maxpt
end	

function getoffset(mat::ScoreMatrix, pt::Point, strand::Int)
	if strand == 1
		return mat.strandA[pt.i:end]
	end
	return mat.strandB[pt.j:end]
end

if length(ARGS) > 1
	mat = makeScoreMatrix(ARGS[1],parse(Int64,ARGS[2]),parse(Int64,ARGS[3]), parse(Int64,ARGS[4]))
	traceback(mat)
end
