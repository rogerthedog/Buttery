Class {
	#name : #TestConfiguration,
	#superclass : #BConfiguration,
	#category : #ButteryExample
}

{ #category : #acccessing }
TestConfiguration class >> databaseFileName [
	
	^ self valueForKey: 'databaseFileName'
]

{ #category : #initialize }
TestConfiguration class >> delimiter [

	^ '|'
]

{ #category : #initialize }
TestConfiguration class >> fileReference [

	^ Smalltalk imageDirectory / 'bbdb.cfg'
]
