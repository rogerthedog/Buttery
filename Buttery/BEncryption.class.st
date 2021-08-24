Class {
	#name : #BEncryption,
	#superclass : #Object,
	#category : #Buttery
}

{ #category : #'as yet unclassified' }
BEncryption class >> encrypt: plainText [

	^ (SHA256 hashMessage: plainText) asString
]
