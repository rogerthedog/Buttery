Class {
	#name : #TestCompete,
	#superclass : #BTable,
	#instVars : [
		'athleteId',
		'categoryId',
		'competitionId',
		'placing'
	],
	#category : #ButteryExample
}

{ #category : #'as yet unclassified' }
TestCompete class >> metaDataSetColumnAliases [
	
	self addMetaDataColumnAlias: 'athlete_id' forMember: 'athleteId'.
	self addMetaDataColumnAlias: 'competition_id' forMember: 'competitionId'.
	self addMetaDataColumnAlias: 'category_id' forMember: 'categoryId'
	
]

{ #category : #'as yet unclassified' }
TestCompete class >> table [ 
	^ 'compete'
]

{ #category : #accessing }
TestCompete >> athleteId [
	^ athleteId
]

{ #category : #accessing }
TestCompete >> athleteId: anObject [
	athleteId := anObject
]

{ #category : #accessing }
TestCompete >> categoryId [
	^ categoryId
]

{ #category : #accessing }
TestCompete >> categoryId: anObject [
	categoryId := anObject
]

{ #category : #accessing }
TestCompete >> competitionId [
	^ competitionId
]

{ #category : #accessing }
TestCompete >> competitionId: anObject [
	competitionId := anObject
]

{ #category : #accessing }
TestCompete >> placing [
	^ placing
]

{ #category : #accessing }
TestCompete >> placing: anObject [
	placing := anObject
]
