import Base.==
import Base.getindex
type Scores
	space::Int
	match::Int
	mismatch::Int
end

type Point
	i::Int
	j::Int
	Point(pt::Tuple{Int,Int}) = begin
		(x,y) = pt
		new(x,y)
	end
	Point(i::Int, j::Int) = new(i,j)
end
==(a::Point, b::Point) = a.i == b.i && a.j == b.j

@enum DIRECTION UP = 1 LEFT = 2 DIAG =3
type Cell
	score::Number
	traceback::Point
	direction::DIRECTION
end

type ScoreMatrix
	matrix::AbstractArray
	strandA::String
	strandB::String
end

function matrixFactory(strandA::String, strandB::String)
	arr = Array{Cell}(length(strandA), length(strandB))
	ScoreMatrix(arr, strandA, strandB)
end
getindex(score_matrix::ScoreMatrix, i::Int,j::Int) = getindex(score_matrix.matrix,i,j)
