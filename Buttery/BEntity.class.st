Class {
	#name : #BEntity,
	#superclass : #Object,
	#classInstVars : [
		'connectionClass'
	],
	#category : #Buttery
}

{ #category : #'as yet unclassified' }
BEntity class >> buildOffsetLimitfromPage: pageNumber rowsPerPage: rowsPerPage [  

	^ ' LIMIT ', rowsPerPage , ' OFFSET ', (pageNumber - 1) * rowsPerPage 
	

]

{ #category : #'as yet unclassified' }
BEntity class >> connectionClass [

	^ connectionClass ifNil: [ connectionClass := self connectionClassForCategory ] 
]

{ #category : #'as yet unclassified' }
BEntity class >> connectionClassForCategory [

	| categoryName matchingClasses matchedClass|
	categoryName := self category. 

	matchingClasses := BConnection subclasses select: [ :each | each category = categoryName].
	
	matchingClasses size = 1 ifTrue: [ matchedClass := matchingClasses first ].
	
	^ matchedClass	
]

{ #category : #initialization }
BEntity >> setMembersFromRow: row [

	self class instVarNames do: [ :member |  
		self instVarNamed: member put: (	row at: member).
	]
]
