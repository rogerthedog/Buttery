Class {
	#name : #BJoin,
	#superclass : #BEntity,
	#classInstVars : [
		'aggregateColumns',
		'aliases',
		'sqlGroupBy',
		'tables',
		'joinTexts',
		'joins',
		'sqlSelectText'
	],
	#category : #Buttery
}

{ #category : #adding }
BJoin class >> addAggregateColumnName: columnName definition: aString [

	self aggregateColumns at: columnName put: aString
]

{ #category : #adding }
BJoin class >> addCrossJoinTableClass: tableClass withAlias: aliasString [

	self addTableClass: tableClass withAlias: aliasString joinText: 'OUTER LEFT JOIN' onClause: ''

]

{ #category : #adding }
BJoin class >> addInnerJoinTableClass: tableClass withAlias: aliasString onClause: aString [

	self addTableClass: tableClass withAlias: aliasString joinText: 'INNER JOIN' onClause: aString

]

{ #category : #adding }
BJoin class >> addLeftOuterJoinTableClass: tableClass withAlias: aliasString onClause: aString [

	self addTableClass: tableClass withAlias: aliasString joinText: 'LEFT OUTER JOIN' onClause: aString

]

{ #category : #adding }
BJoin class >> addTableClass: tableClass withAlias: aliasString [

	self tables add: tableClass.
	self aliases add: aliasString

]

{ #category : #adding }
BJoin class >> addTableClass: tableClass withAlias: aliasString joinText: joinText onClause: aString [

	self addTableClass: tableClass withAlias: aliasString.
	self joins at: aliasString put: aString.
	self joinTexts at: aliasString put: joinText 

]

{ #category : #adding }
BJoin class >> addTableClass: tableClass withAlias: aliasString onClause: aString [

	self addTableClass: tableClass withAlias: aliasString.
	self joins at: aliasString put: aString

]

{ #category : #adding }
BJoin class >> aggregateColumns [

	^ aggregateColumns ifNil: [ aggregateColumns := Dictionary new ]
]

{ #category : #adding }
BJoin class >> aliases [

	^ aliases ifNil: [ aliases := OrderedCollection new ]
]

{ #category : #adding }
BJoin class >> buildSelectText [

	| sqlSelect sqlFrom alias tableClass instVar fullSqlText sqlWhere groupByHasColumns |

	self loadTablesJoinsAggregates.

	sqlSelect := 'SELECT'.
	sqlGroupBy := ' GROUP BY'.
	groupByHasColumns := false.

	1 to: tables size do: [ :i |

		alias := aliases at: i.
		tableClass := tables at: i.
		
		tableClass allInstVarNames do: [ :var | 
			instVar := alias, var capitalized.

			(self instVarNames includes: instVar) ifTrue: [  
				sqlSelect := sqlSelect, ' ', alias, '.', (tableClass buildColumnAlias: var), ' AS ', instVar , ','.
				sqlGroupBy := sqlGroupBy, ' ', instVar, ','.
				groupByHasColumns := true
			]
		].

		(i = 1) ifTrue: [  
			sqlFrom := ' FROM '. 
			sqlWhere := ' WHERE ', alias, '.active = "Y"' 
		] ifFalse: [  
			(self joinTexts includesKey: alias) ifTrue: [
				sqlFrom := sqlFrom, ' ', (joinTexts at: alias), ' ' 
			] ifFalse: [  
				sqlFrom := sqlFrom, ' JOIN ' 
			]

		].
		sqlFrom := sqlFrom, tableClass table, ' ', alias. 

		(joins includesKey: alias) ifTrue: [
			sqlFrom := sqlFrom, ' ON (', (joins at: alias), ') AND ', alias, '.active = "Y"'.
		].
	].

	self aggregateColumns keysAndValuesDo: [ :colName :colDefinition |
		sqlSelect := sqlSelect, ' ', colDefinition, ' AS ', colName, ','   		
	].

	sqlSelect := sqlSelect allButLast.
	fullSqlText := sqlSelect, sqlFrom, sqlWhere.
	
	((aggregateColumns isNotEmpty) and: groupByHasColumns) ifTrue: [  
		sqlGroupBy := sqlGroupBy allButLast  			
	] ifFalse: [  
		sqlGroupBy := ''  			
	].

	^ fullSqlText 

]

{ #category : #adding }
BJoin class >> joinTexts [

	^ joinTexts ifNil: [ joinTexts := Dictionary new ]
]

{ #category : #adding }
BJoin class >> joins [

	^ joins ifNil: [ joins := Dictionary new ]
]

{ #category : #adding }
BJoin class >> loadTablesJoinsAggregates [
	
	self subclassResponsibility 
]

{ #category : #adding }
BJoin class >> reset [

	tables := nil.
	joins := nil.
	joinTexts := nil.
	aliases := nil.
	aggregateColumns := nil.
	sqlSelectText := nil.
	sqlGroupBy := nil

]

{ #category : #adding }
BJoin class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause [

	| connection objectCollection |
	connection := self connectionClass open.
	[  
		objectCollection := self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause using: connection.
	]
	ensure: [ connection close ].
	
	^ objectCollection  
	
]

{ #category : #adding }
BJoin class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage [ 

	| connection objectCollection |
	connection := self connectionClass open.
	[  
		objectCollection := self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage using: connection.
	]
	ensure: [ connection close ].
	
	^ objectCollection  
	
]

{ #category : #adding }
BJoin class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: pageNumber rowsPerPage: rowsPerPage using: aConnection [

	| fullSql objectCollection newInstance bindings cursor |

	fullSql := self sqlSelectText.

	whereClause ifNotEmpty: [
		fullSql := fullSql, ' AND (', whereClause, ')' 
	].		

	sqlGroupBy ifNotEmpty: [
		fullSql := fullSql, sqlGroupBy 
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
		newInstance := self new.
		newInstance setMembersFromRow: row. 
		objectCollection add: newInstance
	].	

	^ objectCollection
]

{ #category : #adding }
BJoin class >> selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause using: aConnection [

	^ self selectWhere: whereClause whereBindingBlock: bindingBlock orderBy: orderByClause page: 0 rowsPerPage: 0 using: aConnection

]

{ #category : #adding }
BJoin class >> sqlSelectText [

	^ sqlSelectText ifNil: [sqlSelectText := self buildSelectText]
]

{ #category : #adding }
BJoin class >> tables [

	^ tables ifNil: [ tables := OrderedCollection new ]
]
