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

	^ ' LIMIT ', rowsPerPage printString, ' OFFSET ', ((pageNumber - 1) * rowsPerPage) printString 
	

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

{ #category : #'as yet unclassified' }
BEntity class >> countWhere: whereClause whereBindingBlock: bindingBlock [

	| connection |

	connection := self connectionClass open.
	^ self countWhere: whereClause whereBindingBlock: bindingBlock using: connection

]

{ #category : #'as yet unclassified' }
BEntity class >> countWhere: whereClause whereBindingBlock: bindingBlock using: aConnection [

	| fullSql bindings cursor |

	fullSql := self fullSqlWhere: whereClause orderBy: '' page: 0 rowsPerPage: 0.

	fullSql := 'SELECT COUNT(*) FROM (', fullSql, ')'.

	bindings := OrderedCollection new.
	bindingBlock ifNotNil: [  
		bindingBlock value: bindings
	].

	cursor := aConnection execute: fullSql with: bindings. 

	cursor rows size = 1 ifTrue: [  
		^ ((cursor rows at: 1) at: 1)		
	].
	^ 0

]

{ #category : #'as yet unclassified' }
BEntity class >> fullSqlWhere: whereClause orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage [

	self subclassResponsibility 


]

{ #category : #'as yet unclassified' }
BEntity class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause [

	| connection objectCollection |

	connection := self connectionClass open.
	[  
		objectCollection := self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause using: connection
	] 
	ensure: [ connection close ].

	^ objectCollection

]

{ #category : #'as yet unclassified' }
BEntity class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage [ 

	| connection objectCollection |
	connection := self connectionClass open.
	[  
		objectCollection := self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage using: connection.
	]
	ensure: [ connection close ].
	
	^ objectCollection  
]

{ #category : #'as yet unclassified' }
BEntity class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage using: aConnection [

	| fullSql newObject objectCollection bindings cursor |

	fullSql := self fullSqlWhere: whereClause orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage.

	bindings := OrderedCollection new.
	bindingBlock ifNotNil: [  
		bindingBlock value: bindings
	].

	cursor := aConnection execute: fullSql with: bindings. 

	objectCollection := OrderedCollection new.	
	cursor rows do: [ :row |  
		newObject := self new.
		newObject setMembersFromRow: row.
		objectCollection add: newObject.	
	].

	^ objectCollection
]

{ #category : #'as yet unclassified' }
BEntity class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause using: aConnection [

	^ self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: 0 rowsPerPage: 0 using: aConnection


]

{ #category : #initialization }
BEntity >> setMembersFromRow: row [

	self class allInstVarNames do: [ :member |  
		self instVarNamed: member put: (	row at: member).
	]
]
