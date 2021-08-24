Class {
	#name : #BTable,
	#superclass : #BEntity,
	#instVars : [
		'rowid',
		'created',
		'active'
	],
	#classInstVars : [
		'columnAliases',
		'sqlTextSelectById',
		'sqlTextInsert',
		'sqlTextUpdate',
		'sqlTextDeleteById',
		'sqlTextSelectWhere'
	],
	#category : #Buttery
}

{ #category : #'as yet unclassified' }
BTable class >> addMetaDataColumnAlias: columnAlias forMember: memberName [ 

	columnAliases at: memberName put: columnAlias
]

{ #category : #'as yet unclassified' }
BTable class >> buildColumnAlias: memberName [

	| alias columnWithAlias |
	alias := self columnAliases at: memberName ifAbsent: nil.
	
	alias ifNil: [  
		columnWithAlias := memberName
	] ifNotNil: [  
		columnWithAlias := alias
	].

	^ columnWithAlias
]

{ #category : #'as yet unclassified' }
BTable class >> buildInsertColumnsOn: aStream [

	self instVarNames do: [ :member | 
		aStream nextPutAll: (self buildColumnAlias: member).
		aStream nextPutAll: ', '
	]

]

{ #category : #'as yet unclassified' }
BTable class >> buildSelectColumnWithAlias: memberName [

	| alias columnWithAlias |
	alias := self columnAliases at: memberName ifAbsent: nil.
	
	alias ifNil: [  
		columnWithAlias := memberName
	] ifNotNil: [  
		columnWithAlias := alias, ' AS ', memberName
	].

	^ columnWithAlias
]

{ #category : #'as yet unclassified' }
BTable class >> buildSelectColumnsOn: aStream [

	| sqlTextStream |
	sqlTextStream := WriteStream on: (String new).

	self allInstVarNames do: [ :member | 
		sqlTextStream nextPutAll: (self buildSelectColumnWithAlias: member).
		sqlTextStream nextPutAll: ', '
	].

	aStream nextPutAll: (sqlTextStream contents allButLast: 2)
]

{ #category : #'as yet unclassified' }
BTable class >> buildSqlTextDeleteById [

	| sqlTextStream |
	sqlTextStream := WriteStream on: (String new).

	sqlTextStream nextPutAll: 'UPDATE '.
	sqlTextStream nextPutAll: (self table).
	sqlTextStream nextPutAll: ' SET active = "N" WHERE rowid = ?'.

	^ sqlTextStream contents

]

{ #category : #'as yet unclassified' }
BTable class >> buildSqlTextInsert [

	| sqlTextStream |
	sqlTextStream := WriteStream on: (String new).

	sqlTextStream nextPutAll: 'INSERT INTO '.
	sqlTextStream nextPutAll: (self table).
	sqlTextStream nextPutAll: ' ('.
	self buildInsertColumnsOn: sqlTextStream.
	sqlTextStream nextPutAll: 'active, created) values ('.
	sqlTextStream nextPutAll: ('?, ' repeat: self instVarNames size).
	sqlTextStream nextPutAll: '?, ?)'.

	^ sqlTextStream contents

]

{ #category : #'as yet unclassified' }
BTable class >> buildSqlTextSelectById [

	| sqlTextStream |
	sqlTextStream := WriteStream on: (String new).

	sqlTextStream nextPutAll: 'SELECT '.
	self buildSelectColumnsOn: sqlTextStream.
	sqlTextStream nextPutAll: ' FROM '.
	sqlTextStream nextPutAll: (self table).
	sqlTextStream nextPutAll: ' where rowid = ? and active = "Y"'.

	^ sqlTextStream contents

]

{ #category : #'as yet unclassified' }
BTable class >> buildSqlTextSelectWhere [

	| sqlTextStream |
	sqlTextStream := WriteStream on: (String new).

	sqlTextStream nextPutAll: 'SELECT '.
	self buildSelectColumnsOn: sqlTextStream.
	sqlTextStream nextPutAll: ' FROM '.
	sqlTextStream nextPutAll: (self table).
	sqlTextStream nextPutAll: ' where active = "Y"'.

	^ sqlTextStream contents

]

{ #category : #'as yet unclassified' }
BTable class >> buildSqlTextUpdate [

	| sqlTextStream |
	sqlTextStream := WriteStream on: (String new).

	sqlTextStream nextPutAll: 'UPDATE '.
	sqlTextStream nextPutAll: (self table).
	sqlTextStream nextPutAll: ' SET '.
	sqlTextStream nextPutAll: (self buildUpdateColumns).
	sqlTextStream nextPutAll: ' WHERE rowid = ?'.

	^ sqlTextStream contents

]

{ #category : #'as yet unclassified' }
BTable class >> buildUpdateColumnWithAlias: memberName [

	| alias columnWithAlias |
	alias := self columnAliases at: memberName ifAbsent: nil.
	
	alias ifNil: [  
		columnWithAlias := memberName
	] ifNotNil: [  
		columnWithAlias := alias
	].

	^ columnWithAlias
]

{ #category : #'as yet unclassified' }
BTable class >> buildUpdateColumns [

	| sqlTextStream |
	sqlTextStream := WriteStream on: (String new).

	self instVarNames do: [ :member | 
		sqlTextStream nextPutAll: (self buildUpdateColumnWithAlias: member).
		sqlTextStream nextPutAll: ' = ?, '
	].

	^ sqlTextStream contents allButLast: 2
]

{ #category : #'as yet unclassified' }
BTable class >> columnAliases [

	columnAliases ifNil: [ 
		columnAliases := Dictionary new.
		self metaDataSetColumnAliases
	].
	^ columnAliases 
]

{ #category : #'as yet unclassified' }
BTable class >> deleteById: anId [

	| connection |
	
	connection := self connectionClass open.
	[  
		self deleteById: anId using: connection
	] 
	ensure: [ connection close ]
]

{ #category : #'as yet unclassified' }
BTable class >> deleteById: anId using: aConnection [

	aConnection execute: (self sqlTextDeleteById) value: anId. 

]

{ #category : #'as yet unclassified' }
BTable class >> deleteWhere: whereClause bindingBlock: bindingBlock [

	| connection |

	connection := self connectionClass open.
	[  
		self deleteWhere: whereClause bindingBlock: bindingBlock using: connection
	] 
	ensure: [ connection close ]
]

{ #category : #'as yet unclassified' }
BTable class >> deleteWhere: whereClause bindingBlock: bindingBlock using: aConnection [

	| bindings sqlTextStream |
	
	sqlTextStream := WriteStream on: (String new).

	sqlTextStream nextPutAll: 'UPDATE '.
	sqlTextStream nextPutAll: self table.
	sqlTextStream nextPutAll: ' SET active = "N" WHERE active = "Y"'.

	whereClause ifNotEmpty: [
		sqlTextStream nextPutAll: ' AND ('.
		sqlTextStream nextPutAll: whereClause.
		sqlTextStream nextPutAll: ')'.
	].		
	
	bindings := OrderedCollection new.
	bindingBlock ifNotNil: [  
		bindingBlock value: bindings
	].

	aConnection execute: sqlTextStream contents with: bindings. 


]

{ #category : #'as yet unclassified' }
BTable class >> metaDataSetColumnAliases [
	
	"overridden by subclass if aliases are required - load them here"
]

{ #category : #'as yet unclassified' }
BTable class >> reset [ 
	columnAliases := nil.
	sqlTextSelectById := nil.
	sqlTextInsert := nil.
	sqlTextUpdate := nil.
	sqlTextDeleteById := nil.
	sqlTextSelectWhere := nil	
]

{ #category : #'as yet unclassified' }
BTable class >> selectById: anId [

	| connection newObject |
 
	connection := self connectionClass open.
	[  
		newObject := self selectById: anId using: connection
	] 
	ensure: [ connection close ].
	
	^ newObject. 	

]

{ #category : #'as yet unclassified' }
BTable class >> selectById: anId using: aConnection [

	| newObject cursor row |

	cursor := aConnection execute: (self sqlTextSelectById) value: anId. 

	cursor rows size == 1 ifTrue: [  

		row := cursor rows first.

		newObject := self new.
		newObject rowid: anId.
		newObject active: 'Y'.
		newObject created: (row at: 'created').
		newObject setMembersFromRow: row
	].

	^ newObject 	
]

{ #category : #'as yet unclassified' }
BTable class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause [

	| connection objectCollection |

	connection := self connectionClass open.
	[  
		objectCollection := self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause using: connection
	] 
	ensure: [ connection close ].

	^ objectCollection

]

{ #category : #'as yet unclassified' }
BTable class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage using: aConnection [

	| fullSql newObject objectCollection bindings cursor |

	fullSql := self sqlTextSelectWhere.

	whereClause ifNotEmpty: [
		fullSql := fullSql, ' AND (', whereClause, ')' 
	].		

	orderByClause ifNotEmpty:[
		fullSql := fullSql, ' ORDER BY ', orderByClause 
	].		

	pageNumber > 0 ifTrue: [  
		fullSql := fullSql, self buildOffsetLimitfromPage: pageNumber rowsPerPage: rowsPerPage  
	].

	bindings := OrderedCollection new.
	bindingBlock ifNotNil: [  
		bindingBlock value: bindings
	].

	cursor := aConnection execute: fullSql with: bindings. 

	objectCollection := OrderedCollection new.	
	cursor rows do: [ :row |  
		newObject := self new.
		newObject rowid: (row at: 'rowid').
		newObject active: 'Y'.
		newObject created: (row at: 'created').
		newObject setMembersFromRow: row.
		objectCollection add: newObject.	
	].

	^ objectCollection
]

{ #category : #'as yet unclassified' }
BTable class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: page rowsPerpage: rowsPerPage [

	| connection objectCollection |

	connection := self connectionClass open.
	[  
		objectCollection := self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: page rowsPerPage: rowsPerPage using: connection
	] 
	ensure: [ connection close ].

	^ objectCollection

]

{ #category : #'as yet unclassified' }
BTable class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause using: aConnection [

	^ self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: 0 rowsPerPage: 0 using: aConnection


]

{ #category : #'as yet unclassified' }
BTable class >> sqlTextDeleteById [

	^ sqlTextDeleteById ifNil: [sqlTextDeleteById := self buildSqlTextDeleteById]
]

{ #category : #'as yet unclassified' }
BTable class >> sqlTextInsert [

	^ sqlTextInsert ifNil: [sqlTextInsert := self buildSqlTextInsert]
]

{ #category : #'as yet unclassified' }
BTable class >> sqlTextSelectById [

	^ sqlTextSelectById ifNil: [sqlTextSelectById := self buildSqlTextSelectById]
]

{ #category : #'as yet unclassified' }
BTable class >> sqlTextSelectWhere [

	^ sqlTextSelectWhere ifNil: [sqlTextSelectWhere := self buildSqlTextSelectWhere]
]

{ #category : #'as yet unclassified' }
BTable class >> sqlTextUpdate [

	^ sqlTextUpdate ifNil: [sqlTextUpdate := self buildSqlTextUpdate]
]

{ #category : #'as yet unclassified' }
BTable class >> table [ 

	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
BTable class >> updateSet: setClause where: whereClause bindingBlock: bindingBlock [

	| connection |

	connection := self connectionClass open.
	[  
		self updateSet: setClause where: whereClause bindingBlock: bindingBlock using: connection
	] 
	ensure: [ connection close ].

]

{ #category : #'as yet unclassified' }
BTable class >> updateSet: setClause where: whereClause bindingBlock: bindingBlock using: aConnection [

	| bindings sqlTextStream |
	
	sqlTextStream := WriteStream on: (String new).

	sqlTextStream nextPutAll: 'UPDATE '.
	sqlTextStream nextPutAll: self table.
	sqlTextStream nextPutAll: ' SET '.
	sqlTextStream nextPutAll: setClause.
	sqlTextStream nextPutAll: ' WHERE active = "Y"'.

	whereClause ifNotEmpty: [
		sqlTextStream nextPutAll: ' AND ('.
		sqlTextStream nextPutAll: whereClause.
		sqlTextStream nextPutAll: ')'.
	].		
	
	bindings := OrderedCollection new.
	bindingBlock ifNotNil: [  
		bindingBlock value: bindings
	].

	aConnection execute: sqlTextStream contents with: bindings. 


]

{ #category : #accessing }
BTable >> active [
	^ active
]

{ #category : #accessing }
BTable >> active: anObject [
	active := anObject
]

{ #category : #accessing }
BTable >> bindColumns [
	
	| bindings |

	bindings := OrderedCollection new.

	self class instVarNames do: [ :member |
		bindings add: (self instVarNamed: member)

	].

	^ bindings
]

{ #category : #accessing }
BTable >> created [
	^ created
]

{ #category : #accessing }
BTable >> created: anObject [
	created := anObject
]

{ #category : #initialization }
BTable >> delete [

	| connection |
	
	connection := self class connectionClass open.
	[  
		self deleteUsing: connection
	] 
	ensure: [ connection close ].

]

{ #category : #initialization }
BTable >> deleteUsing: aConnection [

	active := 'N'.
	self class deleteById: (self rowid) using: aConnection

]

{ #category : #initialization }
BTable >> insert [

	| connection |

	connection := self class connectionClass open.
	[  
		self insertUsing: connection
	] 
	ensure: [ connection close ].

]

{ #category : #initialization }
BTable >> insertUsing: aConnection [

	| bindings idRows |

	active := 'Y'.
	created := DateAndTime now.

	bindings := self bindColumns.
	bindings add: active.
	bindings add: created.

	aConnection execute: (self class sqlTextInsert) with: bindings.				
	
	idRows := (aConnection execute: 'select last_insert_rowid() as lid') rows.
	self rowid: (idRows first at: 'lid')
]

{ #category : #accessing }
BTable >> rowid [
	^ rowid
]

{ #category : #accessing }
BTable >> rowid: anObject [
	rowid := anObject
]

{ #category : #initialization }
BTable >> update [

	| connection |
	
	connection := self class connectionClass open.
	[  
		self updateUsing: connection
	] 
	ensure: [ connection close ].

]

{ #category : #initialization }
BTable >> updateUsing: aConnection [

	| bindings |

	active := 'Y'.
	created := DateAndTime now.

	bindings := self bindColumns.
	bindings add: rowid.

	aConnection execute: (self class sqlTextUpdate) with: bindings.				
	
]
