Class {
	#name : #TestCategory,
	#superclass : #BTable,
	#instVars : [
		'title'
	],
	#category : #ButteryExample
}

{ #category : #'as yet unclassified' }
TestCategory class >> table [ 
	^ 'category'
]

{ #category : #accessing }
TestCategory >> title [
	^ title
]

{ #category : #accessing }
TestCategory >> title: anObject [
	title := anObject
]
