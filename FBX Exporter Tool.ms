--------------------------------------------------------------------------------------
-- Script Name:	FBXExport.ms
-- Compatible:		Max 2018 and up
-- Version:		v1.0
-- Release date:   27 December 2018
-- Code by:		Nicolás Tapia
------------------------------------------------------------------------------------

rollout fbxExport "FBX Export" width:352 height:480
(
	label 'name' "FBX Export" pos:[148,16] width:56 height:16 align:#left
	button 'buttonCreate' "Create Assets" pos:[16,39] width:320 height:32 align:#left
	GroupBox 'assetTypeGroup' "Asset Type" pos:[20,88] width:312 height:56 align:#left
	radiobuttons 'radioButtonsAsset' " " pos:[25,98] width:301 height:30 labels:#("Static Mesh", "Skeletal Mesh", "Animation") default:1 columns:3 align:#left
	GroupBox 'exportSettingsGroup' "Export Settings" pos:[20,152] width:312 height:208 align:#left
	checkbox 'smoothingGroups' "Smoothing Groups" pos:[30,170] width:106 height:16 checked:true align:#left
	checkbox 'split' "Split per-vertex Normals" pos:[30,185] width:130 height:16 align:#left
	checkbox 'tangents' "Tangents and binormals" pos:[30,200] width:130 height:16 align:#left
	checkbox 'turboSmooth' "Turbosmooth" pos:[30,215] width:82 height:16 align:#left
	checkbox 'preserve' "Preserve Instances" pos:[30,230] width:114 height:16 align:#left
	checkbox 'selection' "Selection Sets" pos:[30,245] width:82 height:16 align:#left
	checkbox 'convert' "Convert Deforming Dummies to bones" pos:[30,260] width:202 height:16 align:#left
	checkbox 'animation' "Animation" pos:[30,275] width:66 height:16 align:#left
	checkbox 'bake' "Bake Animation" pos:[30,290] width:90 height:16 align:#left
	checkbox 'deformations' "Deformations" pos:[30,305] width:82 height:16 align:#left
	checkbox 'skins' "Skins" pos:[30,320] width:50 height:16 align:#left
	checkbox 'morphs' "Morphs" pos:[30,335] width:52 height:16 align:#left
	GroupBox 'exportButtonGroup' "Export Settings" pos:[21,364] width:312 height:44 align:#left
	button 'buttonPath' "..." pos:[300,384] width:24 height:16 align:#left
	edittext 'path' "" pos:[27,384] width:261 height:16 align:#left
	button 'exportButton' "Export" pos:[21,424] width:313 height:32 align:#left
	
	-- Crear Estructura
	on buttonCreate pressed do
		createStructure radioButtonsAsset.state
	
	-- Cambio en el tipo de archivo
	on radioButtonsAsset changed state do
		saveState currentRadioState radioButtonsAsset.state
	
	-- Selección de ruta
	on buttonPath pressed do
		selectPath()
	
	-- Exportar archivo
	on exportButton pressed do
		exportFBX()
	
)

createDialog fbxExport

-- Variables de Static Mesh
staticValues = #(true, false, false, false, false, false, false, false, false, false, false, false)
-- Variables de Skeletal Mesh
skeletalValues = #(true, false, false, false, false, false, false, false, false, true, true, true)
-- Variables de Animation Mesh
animationValues = #(false, false, false, false, false, false, false, true, true, false, true, true)

-- Array con las checkBoxes
checkBoxes = #(fbxExport.smoothingGroups, fbxExport.split, fbxExport.tangents, fbxExport.turbosmooth, fbxExport.preserve, fbxExport.selection, fbxExport.convert, fbxExport.animation, fbxExport.bake, fbxExport.deformations, fbxExport.skins, fbxExport.morphs)

-- Estado actual de tipo de fbx
currentRadioState = 1

-- Path por defecto
fbxExport.path.text = "C:\\Users\\Alumno\\Desktop"

/* -----------------------------------------------------------------*/







-- Guarda las variables que ha cambiado el usuario en cada tipo de fbx y los actualiza
function saveState position state=(
	checkChangeName state
	case position of
	(
		1: saveValues staticValues
		2: saveValues skeletalValues
		3: saveValues animationValues
	)
	checkRadioButtons state
	currentRadioState = state
)

-- Guarda valores del tipo correspondiente que ha podido ser modificado
function saveValues arrayChanged =(
	for i = 1 to arrayChanged.count do
		arrayChanged[i] = checkBoxes[i].state
)

-- Manda cargar los valores correspondientes al estado actual de fbx
function checkRadioButtons position =(
	case position of
	(
		1: showValues staticValues
		2: showValues skeletalValues
		3: showValues animationValues
	)
)

-- Carga valores del tipo correspondiente que ha seleccionado el usuario
function showValues tempValues =(
	for i = 1 to tempValues.count do
		checkBoxes[i].state = tempValues[i]
)

-- Busca si el elemento es un Dummy Root y trata de cambiarlo al tipo de FBX seleccionado
function checkChangeName position =(
	
	sel = selection as array
	if(sel[1] != undefined and classOf sel[1] == Dummy) do(
		if(findString sel[1].name "SM_" == 1 or findString sel[1].name "SK_" == 1 or findString sel[1].name "A_" == 1 ) do(
 
			nombre = filterString sel[1].name "_"
			changeName sel[1] nombre[2] position
		)
	)
)

-- Completa el nombre del asset cuando cambie de tipo de FBX
function changeName element nameElem assetType =(
	case assetType of(
		1: element.name = "SM_" + nameElem
		2: element.name = "SK_" +nameElem
		3: element.name = "A_" + nameElem
	)
)








/* -----------------------------------------------------------------*/






-- Crear la estructura de Dummies para los elementos seleccionados con la correcta nomenclatura
function createStructure assetType =(
	
	dummyParent = Dummy ()
	case assetType of(
		1: dummyParent.name = "SM_"
		2: dummyParent.name = "SK_"
		3: dummyParent.name = "A_"
	)
	sel = selection as array
	if sel[1] != undefined then(
		sel.parent = dummyParent
		dummyParent.name += sel[1].name
	)
	else
		dummyParent.name += "Object"

		
		dummyGeo = Dummy()
		dummyGeo.name = "geo"
		dummyGeo.parent = dummyParent
		
		dummyJoint = Dummy()
		dummyJoint.name = "joints"
		dummyJoint.parent = dummyParent
		
		dummyRig = Dummy()
		dummyRig.name = "rig"
		dummyRig.parent = dummyParent
)




/* -----------------------------------------------------------------*/





-- Seleccion de la ruta por parte del usuario
function selectPath =(
	try(
		selectedPath = getSavePath initialDir:(GetDir #maxroot)
	)catch(
		print "No se ha introducido ninguna ruta"
	)
	fbxExport.path.text = selectedPath
	sel = selection as array
	fbxExport.path.text = fbxExport.path.text
)

-- Selecciona todos los objetos hijos de uno concreto
function selectAllChildren obj = (
	myChildren = #(obj)
	
	index = 0
	while index < myChildren.count do(
		index += 1
		join myChildren myChildren[index].children
	)
	selectMore myChildren
)

-- Exporta el FBX de la manera correcta dependiendo de su tipo
function exportFBX = (
	if fbxExport.path.text != "" then(
		sel = selection as array
		geo = #()
		joints  = #()
		for elem in sel do (
			
			-- Static Mesh
			if(findString elem.name "SM_") == true then(
				for item in elem.children do(
					if item.name == "geo" then(
						try(
							select item.children
							item.children.parent = undefined
							exportation elem.name
							geo = GetCurrentSelection()
							geo.parent = item
						)catch(
							print "No había ningun elemento de geometría"
						)
					)
				)
			)
			
			-- Skeletal Mesh
			if(findString elem.name "SK_") == true then(
				for item in elem.children do(
					if item.name == "geo" then(
						if item.children != undefined then(
							select item.children
							item.children.parent = undefined
							geo = selection as array
							deselect $*
						)
					)
					if item.name == "joints" then(
						if item.children != undefined then(
							select item.children
							item.children.parent = undefined
							joints = selection as array
							deselect $*
						)
					)
				)
				select geo
				selectAllChildren geo[1]
				selectMore joints
				selectAllChildren joints[1]

				exportation elem.name
				for item in elem.children do(
					if (geo.count >= 1 and item.name == "geo") then(
						geo.parent = item
					)
					if(joints.count >= 1 and item.name == "joints" )then(
						joints.parent = item
					)
				)
			)
			
			-- Animation Mesh
			if(findString elem.name "A_") == true then(
				for item in elem.children do(
					if item.name == "joints" then(
						select item.children
						item.children.parent = undefined
						-- Falta bake de animacion
						-- No está hecho porque no sé que es ni como se hace
						exportation elem.name
						joints = GetCurrentSelection()
						joints.parent = item
					)
				)
			)
		)
	)
)


-- Exporta el fbx con las propiedades seleccionadas por el usuario y en la ruta correspondiente con el nombre correcto
-- Tan solo exporta los elementos seleccionados
function exportation elemName= (
	FBXExporterSetParam "SmoothingGroups" checkBoxes[1].state
	FBXExporterSetParam "NormalsPerPoly" checkBoxes[2].state
	FBXExporterSetParam "TangentSpaceExport" checkBoxes[3].state
	FBXExporterSetParam "SmoothMeshExport" checkBoxes[4].state
	FBXExporterSetParam "Preserveinstances" checkBoxes[5].state
	FBXExporterSetParam "SelectionSetExport" checkBoxes[6].state
	FBXExporterSetParam "GeomAsBone" checkBoxes[7].state
	FBXExporterSetParam "Animation" checkBoxes[8].state
	FBXExporterSetParam "BakeAnimation" checkBoxes[9].state
	FBXExporterSetParam "Deformations" checkBoxes[10].state
	FBXExporterSetParam "Shape" checkBoxes[11].state
	FBXExporterSetParam "Skin" checkBoxes[12].state
	filePath = fbxExport.path.text
	filePath += "\\" + elemName
	print filePath
	exportfile filePath #noprompt selectedonly:true
)

