Class {
	#name : #TestCompetition,
	#superclass : #BTable,
	#instVars : [
		'title',
		'eventDate'
	],
	#category : #ButteryExample
}

{ #category : #'as yet unclassified' }
TestCompetition class >> metaDataSetColumnAliases [
	
	self addMetaDataColumnAlias: 'event_date' forMember: 'eventDate'
	 


]

{ #category : #'as yet unclassified' }
TestCompetition class >> table [ 
	^ 'competition'
]

{ #category : #accessing }
TestCompetition >> eventDate [
	^ eventDate
]

{ #category : #accessing }
TestCompetition >> eventDate: anObject [
	eventDate := anObject
]

{ #category : #accessing }
TestCompetition >> title [
	^ title
]

{ #category : #accessing }
TestCompetition >> title: anObject [
	title := anObject
]
