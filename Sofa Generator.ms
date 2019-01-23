--1
boxObj = Box()
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{6}[0,0,10]

--2
boxObj = Box()
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{6,8}[0,0,10]

--3
boxObj = Box widthsegs:2 
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{8,11}[0,0,5]


--4
boxObj = Box widthsegs:2 
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{8,11}[0,0,5]
boxObj.extrusionType = 0
polyop.extrudeFaces boxObj #{3,4} 1

--5
boxObj = Box widthsegs:2 
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{8,11}[0,0,5]
boxObj.extrusionType = 0
polyop.extrudeFaces boxObj #{3,4} 2
boxObj.extrusionType = 2
polyop.extrudeFaces boxObj #{11,12,14,15} 2
boxObj.extrusionType = 2
polyop.extrudeFaces boxObj #{13,16,20,22,28,30} 2

--6
boxObj = Box widthsegs:2 heightsegs: 2
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{8,11}[0,0,5]
polyop.moveVert boxObj #{13,14,15,16,17,18} [0,0,-10]
boxObj.extrusionType = 0
polyop.extrudeFaces boxObj #{3,4} 2
boxObj.extrusionType = 2
polyop.extrudeFaces boxObj #{17,18,20,21} 2
boxObj.extrusionType = 2
polyop.extrudeFaces boxObj #{28,19,34,36,22,26} 2
boxObj.extrusionType = 1
polyop.extrudeFaces boxObj #{5,6,9,11,12,15} 2

--7
boxObj = Box widthsegs:2 lengthsegs: 2 
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{14}[0,0,10]

--8
boxObj = Box height: 2 widthsegs:2 lengthsegs: 2 
convertTo boxObj Editable_Poly
polyop.chamferVerts boxObj  14 5
polyop.extrudeFaces boxObj 17 -1

--9
boxObj = Box widthsegs:3 lengthsegs: 3 
convertTo boxObj Editable_Poly
polyop.extrudeFaces boxObj #{10,12,16,18} 1

--10
boxObj = Box widthsegs:3 lengthsegs: 3 
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{2, 6, 10, 14, 18, 22, 26, 30} [-3, 0, 0]
polyop.moveVert boxObj #{3, 7, 11, 15, 19, 23, 27, 31} [3, 0, 0]
polyop.moveVert boxObj #{9..12, 25..28}[0,3,0]
polyop.moveVert boxObj #{5..8, 21..24} [0, -3, 0]
polyop.extrudeFaces boxObj #{10,12,16,18} 6


-11
boxObj = Box()
convertTo boxObj Editable_Poly
polyop.collapseVerts boxObj #{5..8}


--12
boxObj = Box widthsegs:3 lengthsegs: 3 
convertTo boxObj Editable_Poly
polyop.moveVert boxObj #{2, 6, 10, 14, 18, 22, 26, 30} [-4, 0, 0]
polyop.moveVert boxObj #{3, 7, 11, 15, 19, 23, 27, 31} [4, 0, 0]
polyop.moveVert boxObj #{9..12, 25..28}[0,4,0]
polyop.moveVert boxObj #{5..8, 21..24} [0, -4, 0]
polyop.extrudeFaces boxObj #{16..18} 20
polyop.moveVert boxObj #{1..16} [0,0,20]
polyop.extrudeFaces boxObj #{1,3,7,9} 20

