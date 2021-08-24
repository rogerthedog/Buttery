Class {
	#name : #BConfiguration,
	#superclass : #Object,
	#classInstVars : [
		'dictionary'
	],
	#category : #Buttery
}

{ #category : #utilities }
BConfiguration class >> castString: aString toClassName: aClassName [

	|class|

	aClassName = 'String' ifTrue: [  
		^ aString	
	] ifFalse: [
		class := self class environment at: aClassName asSymbol.  
		^  class perform: #readFrom: with: aString
	]
]

{ #category : #initialize }
BConfiguration class >> delimiter [

	^ self subclassResponsibility 
]

{ #category : #utilities }
BConfiguration class >> dictionary [

	^ dictionary ifNil: [ self loadFromFile ]
]

{ #category : #initialize }
BConfiguration class >> fileReference [

	^ self subclassResponsibility 
]

{ #category : #initialize }
BConfiguration class >> loadFromFile [

	| elements typedValue|

	dictionary := Dictionary new.

	self fileReference fullName asFileReference contents lines do: [ :eachLine |

		elements := eachLine substrings: self delimiter.
	
		elements 	size = 3 ifTrue: [  
			typedValue := self castString: (elements at: 2) toClassName: (elements at: 3). 
			dictionary at: (elements at: 1) put: typedValue 	
		]
	].
	^ dictionary
]

{ #category : #reset }
BConfiguration class >> reset [

	dictionary := nil
]

{ #category : #utilities }
BConfiguration class >> valueForKey: aString [

	^ self dictionary at: aString ifAbsent: [ ^ nil ]
]
