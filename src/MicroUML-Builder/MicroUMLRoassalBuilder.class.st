"
I build Roassal objects based on the MicroUML's AST.
See my class method `exampleSerie` to see how to use me.
"
Class {
	#name : 'MicroUMLRoassalBuilder',
	#superclass : 'RSBuilder',
	#instVars : [
		'classDiagramNode'
	],
	#category : 'MicroUML-Builder',
	#package : 'MicroUML-Builder'
}

{ #category : 'examples' }
MicroUMLRoassalBuilder class >> exampleSerie [

	| uml builder |
	uml := 
#(abstract) % #AbstractSeries 
	+ #name @ String 
	- #(abstract) % #numEpisodes @ Integer
	+ #(static) % #findByName ~#(String) @ #AbstractSeries
=== 
#NovelSeries 
	--|> #AbstractSeries
	+ #author @ String 
	* #Publisher @ String 
	+ #read~{}
=== 
#ComicSeries 
	--|> #AbstractSeries 
	+ #toonAuthor @ String
	* #storyAuthor @ String 
	+ #print~{} 
=== 
#AnimeSeries
	--|> #AbstractSeries 
	+ #director @ String 
	- #animators @ String
	- #voiceActors @ String 
	+ #play~{} 
	<><'original'>---<'comicalize'> #ComicSeries 
	<><'main'>---<'side stories'> #NovelSeries .
	builder := MicroUMLRoassalBuilder new
		           classDiagramNode: uml diagram;
		           build.
	builder
		@ RSCanvasController;
		open
]

{ #category : 'examples' }
MicroUMLRoassalBuilder class >> exampleSerie2 [

	| uml builder |
	uml := 
#(abstract) % #AbstractSeries 
   --@ #TSearch
	--@ #TArtifact
	+ #name @ String 
	- #(abstract) % #numEpisodes @ Integer
	+ #(static) % #findByName ~#(String) @ #AbstractSeries
=== 
#NovelSeries 
	--|> #AbstractSeries
	+ #author @ String 
	* #Publisher @ String 
	+ #read~{}
=== 
#ComicSeries 
	--|> #AbstractSeries 
	+ #toonAuthor @ String
	* #storyAuthor @ String 
	+ #print~{} 
=== 
#AnimeSeries
	--|> #AbstractSeries 
	+ #director @ String 
	- #animators @ String
	- #voiceActors @ String 
	+ #play~{} 
	<><'original'>---<'comicalize'> #ComicSeries 
	<><'main'>---<'side stories'> #NovelSeries .
	builder := MicroUMLRoassalBuilder new
		           classDiagramNode: uml diagram;
		           build.
	builder
		@ RSCanvasController;
		open
]

{ #category : 'private' }
MicroUMLRoassalBuilder >> attachPointFromBottomOf: aRSShape to: anotherRSShape [

	| theta rect |
	theta := ((GLine
		           through: aRSShape encompassingRectangle center
		           and: anotherRSShape encompassingRectangle center)
		          angleWith: (GLine through: 0 @ 0 and: 0 @ 1))
	         \\ (Float pi * 2).
	theta > Float pi ifTrue: [ theta := theta - (Float pi * 2.0) ].
	rect := aRSShape encompassingRectangle.
	^ rect bottomCenter + (theta / Float pi * rect width / 2.0 @ 0)
]

{ #category : 'private' }
MicroUMLRoassalBuilder >> attachPointFromLeftOf: aRSShape to: anotherRSShape [

	| theta rect |
	theta := ((GLine
		           through: aRSShape encompassingRectangle center
		           and: anotherRSShape encompassingRectangle center)
		          angleWith: (GLine through: 1 @ 0 and: 0 @ 0))
	         \\ (Float pi * 2).
	theta > Float pi ifTrue: [ theta := theta - (Float pi * 2.0) ].
	rect := aRSShape encompassingRectangle.
	^ rect leftCenter + (0 @ (theta / Float pi * rect height / 2.0))
]

{ #category : 'private' }
MicroUMLRoassalBuilder >> attachPointFromRightOf: aRSShape to: anotherRSShape [

	| theta rect |
	theta := ((GLine
		           through: aRSShape encompassingRectangle center
		           and: anotherRSShape encompassingRectangle center)
		          angleWith: (GLine through: 1 @ 0 and: 0 @ 0))
	         \\ (Float pi * 2).
	theta > Float pi ifTrue: [ theta := theta - (Float pi * 2.0) ].
	rect := aRSShape encompassingRectangle.
	^ rect rightCenter + (0 @ (theta / Float pi * rect height / 2.0))
]

{ #category : 'private' }
MicroUMLRoassalBuilder >> attachPointFromTopOf: aRSShape to: anotherRSShape [

	| theta rect |
	theta := ((GLine
		           through: aRSShape encompassingRectangle center
		           and: anotherRSShape encompassingRectangle center)
		          angleWith: (GLine through: 0 @ 0 and: 0 @ 1))
	         \\ (Float pi * 2).
	theta > Float pi ifTrue: [ theta := theta - (Float pi * 2.0) ].
	rect := aRSShape encompassingRectangle.
	^ rect topCenter + (theta / Float pi * rect width / 2.0 @ 0)
]

{ #category : 'private' }
MicroUMLRoassalBuilder >> canOccupy: aRectangle ifTrue: aBlock [

	(self canvas shapes anySatisfy: [ :shape |
		 shape encompassingRectangle intersects: aRectangle ]) ifFalse:
		aBlock
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> classDiagramNode [

	^ classDiagramNode
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> classDiagramNode: aMicroUMLClassDiagramNode [

	classDiagramNode := aMicroUMLClassDiagramNode
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> gap [

	^ 100
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> horizontalGap [

	^ 80
]

{ #category : 'testing' }
MicroUMLRoassalBuilder >> isBottommostShape: aRSShape in: aCollectionOfRSShape [

	| left right y |
	left := aRSShape encompassingRectangle left.
	right := aRSShape encompassingRectangle right.
	y := aRSShape encompassingRectangle top.
	^ aCollectionOfRSShape allSatisfy: [ :shape |
			  y > shape encompassingRectangle bottom or: [
					  shape encompassingRectangle right < left or: [
						  shape encompassingRectangle left > right ] ] ]
]

{ #category : 'testing' }
MicroUMLRoassalBuilder >> isLeftmostShape: aRSShape in: aCollectionOfRSShape [

	| x top bottom |
	x := aRSShape encompassingRectangle right.
	top := aRSShape encompassingRectangle top.
	bottom := aRSShape encompassingRectangle bottom.
	^ aCollectionOfRSShape allSatisfy: [ :shape |
			  x < shape encompassingRectangle left or: [
					  shape encompassingRectangle bottom < top or: [
						  shape encompassingRectangle top > bottom ] ] ]
]

{ #category : 'testing' }
MicroUMLRoassalBuilder >> isRightmostShape: aRSShape in: aCollectionOfRSShape [

	| x top bottom |
	x := aRSShape encompassingRectangle left.
	top := aRSShape encompassingRectangle top.
	bottom := aRSShape encompassingRectangle bottom.
	^ aCollectionOfRSShape allSatisfy: [ :shape |
			  x > shape encompassingRectangle right or: [
					  shape encompassingRectangle bottom < top or: [
						  shape encompassingRectangle top > bottom ] ] ]
]

{ #category : 'testing' }
MicroUMLRoassalBuilder >> isTopmostShape: aRSShape in: aCollectionOfRSShape [

	| left right y |
	left := aRSShape encompassingRectangle left.
	right := aRSShape encompassingRectangle right.
	y := aRSShape encompassingRectangle bottom.
	^ aCollectionOfRSShape allSatisfy: [ :shape |
			  y < shape encompassingRectangle top or: [
					  shape encompassingRectangle right < left or: [
						  shape encompassingRectangle left > right ] ] ]
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newClassBoxFor: aMicroUMLClassNode [

	| myLabel attributeShapes methodShapes memberShapes rect y1 y2 |
	myLabel := Array streamContents: [ :stream |
			           | label |
			           aMicroUMLClassNode keywordsDo: [ :keyword |
					           stream nextPut: (RSLabel new
							            text: '<<' , keyword , '>>';
							            color: Color darkGray) ].
			           label := RSLabel new
				                    model: aMicroUMLClassNode;
				                    text: aMicroUMLClassNode name;
				                    color: Color black.
			           aMicroUMLClassNode isAbstract ifTrue: [ label italic ].
			           stream nextPut: label ].
	RSVerticalLineLayout new
		alignCenter;
		on: myLabel.
	myLabel := myLabel asShape.
	myLabel extent x < 100 ifTrue: [
		myLabel extent: 100 @ myLabel extent y ].
	aMicroUMLClassNode isEmptyDefinition
		ifTrue: [
				^ {
					  (RSBox new
						   extent: myLabel extent + (10 @ 6);
						   position: myLabel position;
						   color: Color white;
						   borderColor: Color black;
						   borderWidth: 1).
					  myLabel } asShapeFor: aMicroUMLClassNode ]
		ifFalse: [
				attributeShapes := aMicroUMLClassNode attributesCollect: [
					                   :attribute |
					                   self newMemberLabelFor: attribute ].
				RSVerticalLineLayout new
					alignLeft;
					on: attributeShapes.
				attributeShapes := attributeShapes asShape.

				methodShapes := aMicroUMLClassNode methodsCollect: [ :method |
					                self newMemberLabelFor: method ].
				RSVerticalLineLayout new
					alignLeft;
					on: methodShapes.
				methodShapes := methodShapes asShape.

				RSVerticalLineLayout new
					alignLeft;
					gapSize: 10;
					on: {
							attributeShapes.
							methodShapes }.
				memberShapes := {
					                attributeShapes.
					                methodShapes } asShape.

				myLabel extent x < memberShapes extent x ifTrue: [
					myLabel extent: memberShapes extent x @ myLabel extent y ].
				RSVerticalLineLayout new
					alignLeft;
					gapSize: 10;
					on: {
							myLabel.
							memberShapes }.
				rect := {
					        myLabel.
					        memberShapes } asShape encompassingRectangle.
				y1 := myLabel encompassingRectangle bottom + 5.
				y2 := y1 + attributeShapes encompassingRectangle height + 10.

				^ {
					  (RSBox new
						   extent: rect extent + (10 @ 6);
						   color: Color white;
						   borderColor: Color black;
						   borderWidth: 1).
					  (RSLine new
						   startPoint: rect extent x / -2 - 5 @ y1;
						   endPoint: rect extent x / 2 + 5 @ y1).
					  (RSLine new
						   startPoint: rect extent x / -2 - 5 @ y2;
						   endPoint: rect extent x / 2 + 5 @ y2).
					  myLabel.
					  memberShapes } asShapeFor: aMicroUMLClassNode ]
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newEdgeFor: aMicroUMLAssociationNode [

	^ RSBezier new
		  model: aMicroUMLAssociationNode;
		  color: Color black;
		  markerStart:
			  (self newMarkerFor: aMicroUMLAssociationNode leftHead);
		  markerEnd: (self newMarkerFor: aMicroUMLAssociationNode rightHead);
		  attachPoint: RSBorderAttachPoint new;
		  yourself
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newInheritanceLinkBetween: aMicroUMLClassBox andSuperclass: anotherMicroUMLClassBox [

	^ RSBezier new
		  color: Color black;
		  markerStart: ((RSPolygon new
				    points: {
						    (-8 @ 8).
						    (0 @ 0).
						    (8 @ 8) };
				    color: Color white;
				    borderColor: Color black;
				    borderWidth: 1;
				    asMarker) offset: 4);
		  attachPoint: RSBorderAttachPoint new;
		  from: anotherMicroUMLClassBox;
		  to: aMicroUMLClassBox;
		  controlPointsController: RSVerticalCPAPController new;
		  yourself
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newMarkerFor: aSymbol [

	aSymbol = #aggregation ifTrue: [
			^ (RSPolygon new
				   points: {
						   (-6 @ 0).
						   (0 @ 8).
						   (6 @ 0).
						   (0 @ -8) };
				   color: Color white;
				   borderColor: Color black;
				   borderWidth: 1;
				   asMarker) offset: 8 ].
	aSymbol = #composition ifTrue: [
			^ (RSPolygon new
				   points: {
						   (-6 @ 0).
						   (0 @ 8).
						   (6 @ 0).
						   (0 @ -8) };
				   color: Color black;
				   borderColor: Color black;
				   borderWidth: 1;
				   asMarker) offset: 8 ].
	^ nil
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newMemberLabelFor: aMicroUMLMemberNode [

	| label |
	label := RSLabel
		         text: (String streamContents: [ :stream |
					          aMicroUMLMemberNode isPrivate
						          ifTrue: [ stream nextPut: $- ]
						          ifFalse: [ stream nextPut: Character space ].
					          stream nextPutAll: aMicroUMLMemberNode name.
					          aMicroUMLMemberNode argumentTypes ifNotNil: [
							          :argumentTypes |
							          stream
								          nextPut: $(;
								          nextPutAll: (', ' join: argumentTypes);
								          nextPut: $) ].
					          aMicroUMLMemberNode type ifNotNil: [ :type |
							          stream
								          nextPut: $:;
								          nextPutAll: type ] ])
		         model: aMicroUMLMemberNode.
	aMicroUMLMemberNode isAbstract ifTrue: [
		label emphasis: TextEmphasis italic ].
	aMicroUMLMemberNode isClassSide ifTrue: [
		label emphasis: TextEmphasis underlined ].
	^ label
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newTraitLinkBetween: aRSShape andLollipop: anotherRSShape [

	^ RSBezier new
		  color: Color black;
		  attachPoint: RSCenteredAttachPoint new;
		  from: aRSShape;
		  to: anotherRSShape;
		  controlPointsController: RSVerticalCPAPController new;
		  yourself
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderExtraLink: aRSBezier from: aRSShape to: anotherRSShape in: aRSCanvas [

	| margin others others1 others2 |
	aRSCanvas add: aRSBezier.
	margin := self horizontalGap max: self verticalGap.
	others := aRSCanvas nodes copyWithoutAll: {
			          aRSShape.
			          anotherRSShape }.
	others1 := aRSCanvas nodes copyWithout: aRSShape.
	others2 := aRSCanvas nodes copyWithout: anotherRSShape.
	((self isRightmostShape: aRSShape in: others1) and: [
		 self isRightmostShape: anotherRSShape in: others2 ]) ifTrue: [
			| right point1 point2 |
			right := (((others select: [ :shape |
					            shape encompassingRectangle center y
						            between: (aRSShape encompassingRectangle top min:
								             anotherRSShape encompassingRectangle top)
						            and: (aRSShape encompassingRectangle bottom max:
								             anotherRSShape encompassingRectangle bottom) ])
				           copyWithAll: {
						           aRSShape.
						           anotherRSShape }) collect: [ :shape |
				          shape encompassingRectangle right ]) max.
			right := right
			         + (right - (aRSShape encompassingRectangle right max:
					           anotherRSShape encompassingRectangle right)) + margin.
			point1 := self attachPointFromRightOf: aRSShape to: anotherRSShape.
			point2 := self attachPointFromRightOf: anotherRSShape to: aRSShape.
			aRSBezier controlPoints: {
					point1.
					(right @ point1 y).
					(right @ point2 y).
					point2 }.
			^ self ].
	((self isLeftmostShape: aRSShape in: others1) and: [
		 self isLeftmostShape: anotherRSShape in: others2 ]) ifTrue: [
			| left point1 point2 |
			left := (((others select: [ :shape |
					           shape encompassingRectangle center y
						           between: (aRSShape encompassingRectangle top min:
								            anotherRSShape encompassingRectangle top)
						           and: (aRSShape encompassingRectangle bottom max:
								            anotherRSShape encompassingRectangle bottom) ])
				          copyWithAll: {
						          aRSShape.
						          anotherRSShape }) collect: [ :shape |
				         shape encompassingRectangle left ]) min.
			left := left + ((aRSShape encompassingRectangle left min:
				          anotherRSShape encompassingRectangle left) - left)
			        - margin.
			point1 := self attachPointFromLeftOf: aRSShape to: anotherRSShape.
			point2 := self attachPointFromLeftOf: anotherRSShape to: aRSShape.
			aRSBezier controlPoints: {
					point1.
					(left @ point1 y).
					(left @ point2 y).
					point2 }.
			^ self ].
	((self isBottommostShape: aRSShape in: others1) and: [
		 self isBottommostShape: anotherRSShape in: others2 ]) ifTrue: [
			| bottom point1 point2 |
			bottom := (((others select: [ :shape |
					             shape encompassingRectangle center x
						             between: (aRSShape encompassingRectangle left min:
								              anotherRSShape encompassingRectangle left)
						             and: (aRSShape encompassingRectangle right max:
								              anotherRSShape encompassingRectangle right) ])
				            copyWithAll: {
						            aRSShape.
						            anotherRSShape }) collect: [ :shape |
				           shape encompassingRectangle bottom ]) max.
			bottom := bottom
			          + (bottom - (aRSShape encompassingRectangle bottom max:
					            anotherRSShape encompassingRectangle bottom))
			          + margin.
			point1 := self attachPointFromBottomOf: aRSShape to: anotherRSShape.
			point2 := self attachPointFromBottomOf: anotherRSShape to: aRSShape.
			aRSBezier controlPoints: {
					point1.
					(point1 x @ bottom).
					(point2 x @ bottom).
					point2 }.
			^ self ].
	((self isTopmostShape: aRSShape in: others1) and: [
		 self isTopmostShape: anotherRSShape in: others2 ]) ifTrue: [
			| top point1 point2 |
			top := (((others select: [ :shape |
					          shape encompassingRectangle center x
						          between: (aRSShape encompassingRectangle left min:
								           anotherRSShape encompassingRectangle left)
						          and: (aRSShape encompassingRectangle right max:
								           anotherRSShape encompassingRectangle right) ])
				         copyWithAll: {
						         aRSShape.
						         anotherRSShape }) collect: [ :shape |
				        shape encompassingRectangle top ]) min.
			top := top + ((aRSShape encompassingRectangle top min:
				         anotherRSShape encompassingRectangle top) - top) - margin.
			point1 := self attachPointFromTopOf: aRSShape to: anotherRSShape.
			point2 := self attachPointFromTopOf: anotherRSShape to: aRSShape.
			aRSBezier controlPoints: {
					point1.
					(point1 x @ top).
					(point2 x @ top).
					point2 }.
			^ self ].

	aRSBezier
		attachPoint: RSBorderAttachPoint new;
		from: aRSShape;
		to: anotherRSShape;
		controlPointsController: RSDirectedBezierCPAPController new
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderIn: aRSCanvas [

	| nodes edges lollipops connectedNodes extraEdges |
	nodes := Dictionary new.
	edges := OrderedCollection new.
	lollipops := Dictionary new.
	connectedNodes := IdentitySet new.
	extraEdges := OrderedCollection new.
	classDiagramNode classesDo: [ :classAst |
			| node |
			node := self newClassBoxFor: classAst.
			aRSCanvas
				add: node;
				addNode: node.
			nodes at: classAst name put: node.
			classAst traitsDo: [ :traitName |
					| lollipop |
					lollipop := RSCircle new
						            extent: 20 @ 20;
						            color: Color white;
						            border: (RSBorder new color: Color black);
						            yourself.
					aRSCanvas
						add: lollipop;
						addNode: lollipop.
					lollipops
						at: {
								node.
								traitName }
						put: lollipop ] ].
	classDiagramNode classesDo: [ :classAst |
			classAst superclass ifNotNil: [ :superclassName |
					(nodes includesKey: superclassName) ifTrue: [
							| link |
							link := self
								        newInheritanceLinkBetween: (nodes at: classAst name)
								        andSuperclass: (nodes at: superclassName).
							connectedNodes
								add: (nodes at: classAst name);
								add: (nodes at: superclassName).
							aRSCanvas add: link ] ] ].
	lollipops keysAndValuesDo: [ :classNodeAndTraitName :lollipop |
			| link |
			link := self
				        newTraitLinkBetween: classNodeAndTraitName first
				        andLollipop: lollipop.
			aRSCanvas add: link.
			link pushBack ].
	classDiagramNode associationsDo: [ :associationNode |
			| edge leftNode rightNode |
			leftNode := nodes at: associationNode leftClass.
			rightNode := nodes at: associationNode rightClass.
			edge := self newEdgeFor: associationNode.
			edges add: edge.
			((connectedNodes includes: leftNode) and: [
				 connectedNodes includes: rightNode ])
				ifTrue: [ extraEdges add: edge ]
				ifFalse: [
						edge
							from: leftNode;
							to: rightNode;
							controlPointsController: RSVerticalCPAPController new.
						aRSCanvas
							add: edge;
							addEdge: edge.
						edge pushBack ] ].
	RSTreeLayout new
		verticalGap: self verticalGap;
		horizontalGap: self horizontalGap;
		on: (nodes values , lollipops values as: RSGroup).
	extraEdges do: [ :edge |
			| leftNode rightNode |
			leftNode := nodes at: edge model leftClass.
			rightNode := nodes at: edge model rightClass.
			self
				renderExtraLink: edge
				from: leftNode
				to: rightNode
				in: aRSCanvas ].
	edges do: [ :bezier | self renderLinkLabelsFor: bezier in: aRSCanvas ].
	lollipops keysAndValuesDo: [ :classNodeAndTraitName :lollipop |
			self
				renderTraitLabelAt: lollipop
				classNode: classNodeAndTraitName first
				traitName: classNodeAndTraitName second
				in: aRSCanvas ].
	aRSCanvas zoomToFit
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderLinkLabelsFor: aRSBezier in: aRSCanvas [

	aRSBezier model ifNotNil: [ :edge |
			edge leftLabel ifNotNil: [ :text |
					| label vector markerOffset |
					label := RSLabel new text: text.
					aRSCanvas add: label.
					vector := aRSBezier controlPoints second
					          - aRSBezier controlPoints first.
					markerOffset := aRSBezier markerStart
						                ifNotNil: [ :m |
								                | extent |
								                extent := m shape encompassingRectangle extent.
								                (extent x max: extent y) / 2 ]
						                ifNil: [ 0 ].
					vector x >= vector y abs ifTrue: [
							label position: aRSBezier startPoint
								+
								(label textWidth / 2 + 6 + markerOffset
								 @ (label textHeight / 2 + 6)) ].
					vector x <= vector y abs negated ifTrue: [
							label position: aRSBezier startPoint
								+
								(label textWidth / -2 - 6 - markerOffset
								 @ (label textHeight / 2 + 6)) ].
					vector y > vector x abs ifTrue: [
							label position: aRSBezier startPoint
								+
								(label textWidth / 2 + 6
								 @ (label textHeight / 2 + 6 + markerOffset)) ].
					vector y < vector x abs negated ifTrue: [
							label position: aRSBezier startPoint
								+
								(label textWidth / 2 + 6
								 @ (label textHeight / -2 - 6 - markerOffset)) ] ].
			edge rightLabel ifNotNil: [ :text |
					| label vector markerOffset |
					label := RSLabel new text: text.
					aRSCanvas add: label.
					vector := aRSBezier controlPoints third
					          - aRSBezier controlPoints fourth.
					markerOffset := aRSBezier markerEnd
						                ifNotNil: [ :m |
								                | extent |
								                extent := m shape encompassingRectangle extent.
								                (extent x max: extent y) / 2 ]
						                ifNil: [ 0 ].
					vector x >= vector y abs ifTrue: [
							label position: aRSBezier endPoint
								+
								(label textWidth / 2 + 6 + markerOffset
								 @ (label textHeight / 2 + 6)) ].
					vector x <= vector y abs negated ifTrue: [
							label position: aRSBezier endPoint
								+
								(label textWidth / -2 - 6 - markerOffset
								 @ (label textHeight / 2 + 6)) ].
					vector y > vector x abs ifTrue: [
							label position: aRSBezier endPoint
								+
								(label textWidth / 2 + 6
								 @ (label textHeight / 2 + 6 + markerOffset)) ].
					vector y < vector x abs negated ifTrue: [
							label position: aRSBezier endPoint
								+
								(label textWidth / 2 + 6
								 @ (label textHeight / -2 - 6 - markerOffset)) ] ] ]
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderTraitLabelAt: aRSShape classNode: anotherRSShape traitName: aSymbol in: aRSCanvas [

	| label extent |
	label := RSLabel new
		         text: aSymbol asString;
		         color: Color black;
		         yourself.
	extent := label extent.
	anotherRSShape position y < aRSShape position y
		ifTrue: [
				label position:
					aRSShape encompassingRectangle bottomCenter + (0 @ extent y) ]
		ifFalse: [
				label position:
					aRSShape encompassingRectangle topCenter - (0 @ extent y) ].
	aRSCanvas add: label
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> verticalGap [

	^ 100
]
