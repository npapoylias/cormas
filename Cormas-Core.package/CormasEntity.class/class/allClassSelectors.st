as yet unclassified
allClassSelectors
"Purpose: returns the list of all methods defined at class level
Return value: an indexedSet
Example: CormasNS.Kernel.Agent allClassSelectors"		
	| coll |
	coll := IndexedSet new.
	(self superClassesUntil: Object)
		do: [:aClass | coll addAll: aClass class selectors].
	^coll