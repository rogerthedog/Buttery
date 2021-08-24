Class {
	#name : #TestJoinAthleteHistory,
	#superclass : #BJoin,
	#instVars : [
		'athleteteFirstName',
		'athleteLastName',
		'categoryTitle',
		'competitionTitle',
		'competitionEventDate',
		'competePlacing'
	],
	#category : #ButteryExample
}

{ #category : #adding }
TestJoinAthleteHistory class >> loadTablesJoinsAggregates [
	
	self addTableClass: TestCompete withAlias: 'compete'.
	
	self addInnerJoinTableClass: TestAthlete withAlias: 'athlete' onClause: 'athlete.rowid = compete.athlete_id'.
	self addInnerJoinTableClass: TestCompetition withAlias: 'competition' onClause: 'competition.rowid = compete.competition_id'.
	self addInnerJoinTableClass: TestCategory withAlias: 'category' onClause: 'category.rowid = compete.category_id'.


]

{ #category : #accessing }
TestJoinAthleteHistory >> athleteLastName [
	^ athleteLastName
]

{ #category : #accessing }
TestJoinAthleteHistory >> athleteLastName: anObject [
	athleteLastName := anObject
]

{ #category : #accessing }
TestJoinAthleteHistory >> athleteteFirstName [
	^ athleteteFirstName
]

{ #category : #accessing }
TestJoinAthleteHistory >> athleteteFirstName: anObject [
	athleteteFirstName := anObject
]

{ #category : #accessing }
TestJoinAthleteHistory >> categoryTitle [
	^ categoryTitle
]

{ #category : #accessing }
TestJoinAthleteHistory >> categoryTitle: anObject [
	categoryTitle := anObject
]

{ #category : #accessing }
TestJoinAthleteHistory >> competePlacing [
	^ competePlacing
]

{ #category : #accessing }
TestJoinAthleteHistory >> competePlacing: anObject [
	competePlacing := anObject
]

{ #category : #accessing }
TestJoinAthleteHistory >> competitionEventDate [
	^ competitionEventDate
]

{ #category : #accessing }
TestJoinAthleteHistory >> competitionEventDate: anObject [
	competitionEventDate := anObject
]

{ #category : #accessing }
TestJoinAthleteHistory >> competitionTitle [
	^ competitionTitle
]

{ #category : #accessing }
TestJoinAthleteHistory >> competitionTitle: anObject [
	competitionTitle := anObject
]
