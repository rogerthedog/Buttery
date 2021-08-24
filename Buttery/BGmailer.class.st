Class {
	#name : #BGmailer,
	#superclass : #Object,
	#category : #Buttery
}

{ #category : #'as yet unclassified' }
BGmailer class >> gmailAddress [
	
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
BGmailer class >> gmailPassword [
	
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
BGmailer class >> sendTextMailTo: recipientAddress subject: aSubject text: aText [

	|mailMessage|

	[  
		mailMessage := MailMessage new.
		mailMessage from: self gmailAddress.
		mailMessage to: recipientAddress.
		mailMessage subject: aSubject.
		mailMessage body: (MIMEDocument 
                 contentType: MIMEDocument contentTypePlainText  
                 content: aText).
		ZdcSecureSMTPClient sendUsingGMailAccount: self gmailAddress password: self gmailPassword to: recipientAddress message: mailMessage	
	] fork


]
