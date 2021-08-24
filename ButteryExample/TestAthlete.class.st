Class {
	#name : #TestAthlete,
	#superclass : #BTable,
	#instVars : [
		'firstName',
		'lastName',
		'dateOfBirth'
	],
	#category : #ButteryExample
}

{ #category : #'as yet unclassified' }
TestAthlete class >> metaDataSetColumnAliases [
	
	self addMetaDataColumnAlias: 'first_name' forMember: 'firstName'.
	self addMetaDataColumnAlias: 'last_name' forMember: 'lastName'.
	self addMetaDataColumnAlias: 'date_of_birth' forMember: 'dateOfBirth'
	 


]

{ #category : #'as yet unclassified' }
TestAthlete class >> selectWhereTest [
	^ self selectWhere: 'last_name LIKE ?' whereBindingBlock: [ :bindings | bindings add: 'Clark%'] orderBy: 'rowid DESC'
]

{ #category : #'as yet unclassified' }
TestAthlete class >> table [ 
	^ 'athlete'
]

{ #category : #accessing }
TestAthlete >> dateOfBirth [
	^ dateOfBirth
]

{ #category : #accessing }
TestAthlete >> dateOfBirth: anObject [
	dateOfBirth := anObject
]

{ #category : #accessing }
TestAthlete >> firstName [
	^ firstName
]

{ #category : #accessing }
TestAthlete >> firstName: anObject [
	firstName := anObject
]

{ #category : #accessing }
TestAthlete >> lastName [
	^ lastName
]

{ #category : #accessing }
TestAthlete >> lastName: anObject [
	lastName := anObject
]
