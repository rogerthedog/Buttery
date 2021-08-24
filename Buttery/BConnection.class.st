Class {
	#name : #BConnection,
	#superclass : #Object,
	#classInstVars : [
		'connection'
	],
	#category : #Buttery
}

{ #category : #'instance creation' }
BConnection class >> databaseFileName [

	self subclassResponsibility 
]

{ #category : #'instance creation' }
BConnection class >> open [

	connection := SQLite3Connection on: self databaseFileName.
	connection open. 
	^ connection

]

{ #category : #'instance creation' }
BConnection class >> reset [ 
	connection := nil.
	
]

{ #category : #'instance creation' }
BConnection class >> startUp [

	self reset
]
