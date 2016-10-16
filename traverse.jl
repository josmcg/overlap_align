##common matrix traversal movements
include("types.jl")
function up(pt::Point)
	Point(pt.i -1, pt.j)
end

function down(pt::Point)
	Point(pt.i+1, pt.j)
end

function left(pt::Point)
	Point(pt.i, pt.j-1)
end

function right(pt::Point)
	Point(pt.i, pt.j+1)
end
