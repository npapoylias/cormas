Class {
	#name : #CMECECModel,
	#superclass : #CormasModel,
	#instVars : [
		'restrainedInitialNumber',
		'unrestrainedInitialNumber',
		'theCMECECRestraineds',
		'theCMECECUnrestraineds',
		'theCMECECVegetationUnits',
		'theRestraineds'
	],
	#category : 'Cormas-Model-ECEC'
}

{ #category : #'- probes' }
CMECECModel class >> colorOfProbe_restrainedSize [
	
	^ Color red: 0.104993 green: 0.104993 blue: 0.839458
]

{ #category : #'- probes' }
CMECECModel class >> colorOfProbe_unrestrainedSize [
	
	^ Color r: 0.839458 g: 0.0 b: 0.0
]

{ #category : #'- probes' }
CMECECModel class >> colorOfProbe_vegetationBiomass [
	
	^ Color red: 0.0 green: 0.839458 blue: 0.0
]

{ #category : #default }
CMECECModel class >> defaultFinalStep [
	^ 100
]

{ #category : #default }
CMECECModel class >> defaultInit [
	
	^#homogeneousEnv

]

{ #category : #default }
CMECECModel class >> defaultProbes [

^self probes
]

{ #category : #'examples - with SimManager' }
CMECECModel class >> displayRunDuration: duration simName: simName [
	"display on the Transcript, the duration time of the simulation"

	| txt |
	txt := 'Simulation [', simName, ']was run in ' , duration printString , ' milliseconds'.
	duration > 1000
		ifTrue: [ | dur |
			txt := txt , ', ie. '.
			dur := Time fromSeconds: duration / 1000.
			txt := txt , dur hours printString , ' h: ' , dur minutes printString , ' m: ' , dur seconds asFloat printString , ' s.' ].
	Transcript
		cr;
		show: txt
]

{ #category : #examples }
CMECECModel class >> example1 [

	"Vegetation grid animation without foragers"
	
	| aModel v n c es anim popup|
	
	aModel := self
		initialize;
		new.
		
	v := RTView new.
	"v @ RTZoomableView."
	
	n := RTMultiLinearColor new
		colors: (RTColorPalette sequential colors: 9 scheme: 'YlGnBu').
		
	c := n command: [ :cells | cells biomass / 10.0 ].
	
	aModel initSimulation.
	aModel runStep.
	
	es := (RTBox new
		color: c;
		size: 25) elementsOn: aModel theCMECECVegetationUnits.
		
	v addAll: es.
	
	"Adding a popup for biomass info on hover"
	popup := RTPopup new.
	popup text: [ :object | object asPopupText ].
	es @ popup.
	
	"Adding a popup for object inspection on left click"
	es do: [:element | element when: TRMouseLeftClick do: [ :evt | element model inspect ]].
	
	RTGridLayout new
		gapSize: 0;
		lineItemsCount: aModel spaceModel column;
		on: v elements.
	
	v canvas camera focusOnCenterScaled.
	
	anim := RTActiveAnimation new.
	anim intervalInMilliseconds: 0.
	anim
		blockToExecute: [ aModel runStep.
			v elements do: #updateShape ].
	anim inView: v.
	
	v openWithToolbar.
]

{ #category : #examples }
CMECECModel class >> example2 [
	| aModel |
	aModel := self initialize new initSimulation.
	(CMSimulationGrid new on: aModel with: aModel theCMECECVegetationUnits) runAndVisualize
]

{ #category : #examples }
CMECECModel class >> example3 [

	"Vegetation grid animation without foragers"
	
	| aModel v n c es anim popup menu|
	
	aModel := self
		initialize;
		new.
	
	v := RTView new.
	
	n := RTMultiLinearColor new
		colors: (RTColorPalette sequential colors: 9 scheme: 'YlGnBu').
		
	c := n command: [ :cells | cells biomass / 10.0 ].
	
	aModel initSimulation.
	aModel runStep.
	
	es := (RTBox new
		color: c;
		size: 25) elementsOn: aModel theCMECECVegetationUnits.
		
	v addAll: es.
	
	"Adding a popup for biomass info on hover"
	popup := RTPopup new.
	popup text: [ :object | object asPopupText ].
	es @ popup.
	
	"Adding a popup for object inspection on left click"
	es do: [:element | element when: TRMouseLeftClick do: [ :evt | element model inspect ]].
	
	menu := RTMenuBuilder new view: v. 
	menu menu: 'Visualize' background: Color red callback: [ self visualize ].
	
	RTGridLayout new
		gapSize: 0;
		lineItemsCount: aModel spaceModel column;
		on: v elements.
	
	v canvas camera focusOnCenterScaled.
	
	anim := RTActiveAnimation new.
	"anim intervalInMilliseconds: 0."
	anim
		blockToExecute: [ aModel runStep.
			v elements do: #updateShape ].
	anim inView: v.
	
	v openWithToolbar.
	
]

{ #category : #examples }
CMECECModel class >> example4 [
	| aModel |
	aModel := self initialize new initSimulation.
	(CMSimulationGrid new
		on: aModel
		withCells: aModel theESE
		withSituatedEntities: aModel allTheSituatedEntities) runAndVisualize
]

{ #category : #examples }
CMECECModel class >> example5 [
	| aModel |
	self setActiveProbes: OrderedCollection new.
	aModel := self initialize new initSimulation.
	(CMSimulationGrid new
		on: aModel
		withCells: aModel theESE
		withSituatedEntities: aModel allTheSituatedEntities) runAndVisualizeWithMenus goSlow
]

{ #category : #'examples - with SimManager' }
CMECECModel class >> exampleSM1 [
	"In this example the SimManager is not used at all"

	| aModel finalTime chrono |
	aModel := self initialize new initSimulation.
	finalTime := 200.
	chrono := Time millisecondsToRun: [ finalTime timesRepeat: [ aModel runStep ] ].
	self displayRunDuration: chrono simName: 'a exampleSM1'.
	self transcriptShow_simulationTime: aModel timeStep nbRestrainedForagers: aModel restrainedSize
]

{ #category : #'examples - with SimManager' }
CMECECModel class >> exampleSM2 [
	"In this example the run of the simulation is managed by the SimManager"

	| aModel |
	aModel := self initialize new initSimulation.
	aModel simManager
		finalTime: 200;
		runSimulation.
			self transcriptShow_simulationTime:  aModel simManager currentTime nbRestrainedForagers: aModel restrainedSize 
	
]

{ #category : #'examples - with SimManager' }
CMECECModel class >> exampleSM3 [
	"In this example the initialization and the run of the simulation is managed by the SimManager"

	| aModel |
	aModel := self initialize new.
	aModel simManager
		initializeSimulation;
		finalTime: 200;
		runSimulation.
	self
		transcriptShow_simulationTime: aModel simManager currentTime
		nbRestrainedForagers: aModel restrainedSize
]

{ #category : #'examples - with SimManager' }
CMECECModel class >> exampleSM4 [
	"This example compares the performance of using SimManager or not using it"

	| nbRepetitions chronoRecords finalTime |
	nbRepetitions := 10.
	finalTime := 20.
	"exampleSM1"
	chronoRecords := OrderedCollection new.
	1 to: nbRepetitions do: [ :idRepetition | 
		| chrono |
		chrono := Time
			millisecondsToRun: [ | aModel |
				aModel := self initialize new initSimulation.
				finalTime timesRepeat: [ aModel runStep ] ].
		chronoRecords add: chrono
		"	self displayRunDuration: chrono simName: 'exampleSM1 - repetition' , idRepetition asString " ].
	Transcript
		cr;
		show: 'exampleSM1 (no SimManager) - average time over ' , nbRepetitions asString , ' repetitions: ' , (chronoRecords sum / nbRepetitions) rounded asString , ' ms'.
	"exampleSM2"
	chronoRecords := OrderedCollection new.
	1 to: nbRepetitions do: [ :idRepetition | 
		| chrono |
		chrono := Time
			millisecondsToRun: [ | aModel |
				aModel := self initialize new initSimulation.
				aModel simManager
					finalTime: finalTime;
					runSimulation ].
		chronoRecords add: chrono
		"	self displayRunDuration: chrono simName: 'exampleSM2 - repetition' , idRepetition asString " ].
	Transcript
		cr;
		show:
			'exampleSM2 (SimManager used for run) - average time over ' , nbRepetitions asString , ' repetitions: ' , (chronoRecords sum / nbRepetitions) rounded asString
				, ' ms'.
	"exampleSM3"
	chronoRecords := OrderedCollection new.
	1 to: nbRepetitions do: [ :idRepetition | 
		| chrono |
		chrono := Time
			millisecondsToRun: [ | aModel |
				aModel := self initialize new.
				aModel simManager
					initializeSimulation;
					finalTime: finalTime;
					runSimulation ].
		chronoRecords add: chrono
		"	self displayRunDuration: chrono simName: 'exampleSM3 - repetition' , idRepetition asString " ].
	Transcript
		cr;
		show:
			'exampleSM3 (SimManager used for init and run) - average time over ' , nbRepetitions asString , ' repetitions: '
				, (chronoRecords sum / nbRepetitions) rounded asString , ' ms'.
	Transcript open
]

{ #category : #'- default value' }
CMECECModel class >> restrainedInitialNumber_default [
	"Return the default value of restrainedInitialNumber attribute"
	
	^10
]

{ #category : #'examples - with SimManager' }
CMECECModel class >> transcriptShow_simulationTime: nbTimeStep nbRestrainedForagers: aNbRestrainedForagers [
Transcript
		cr;
		show: 'Number of steps : ' , nbTimeStep asString;
		cr;
		show: 'Number of restrained foragers: ' , aNbRestrainedForagers asString;
		open
]

{ #category : #'- default value' }
CMECECModel class >> unrestrainedInitialNumber_default [
	"Return the default value of unrestrainedInitialNumber attribute"
	
	^10
]

{ #category : #'as yet unclassified' }
CMECECModel class >> visualize [
	
	| data g ds b c |
	data := #(20 30 50 100).
	
	"v := RTView new."
	
	c := RTComposer new.
	
	"First visualization"
	
	g := RTGrapher new.
	g extent: 200 @ 200.
	g view: c view.
	"g view: v view."
	
	ds := RTData new.
	ds interaction popup.
	ds barShape color: Color blue.
	ds points: data.
	
	g add: ds.
	g axisX noTick; noLabel.
	g build.
	"v group: #graph."
	c group: #graph.

	"Second visualization"
	b := RTPieBuilder new.
	b view: c view.
	"b view: v view."
	b interaction popup.
	b objects: data.
	b slice: #yourself.
	b labeled.
	b build.
	"v group: #pie."
   c group: #pie.

	"Layouting"
    c move: #graph onTheLeftOf: #pie.

	RTMetricNormalizer new view: c view;
                 objects: data;
                 distinctColor.
	
	c open.
	
	"v openTitled: 'Data Visualization'."
]

{ #category : #'as yet unclassified' }
CMECECModel class >> visualize: es [
	
	| data g ds b c |
	
	data := #(20 30 50 100).
	
	"v := RTView new."
	
	c := RTComposer new.
	
	"First visualization"
	
	g := RTGrapher new.
	g extent: 200 @ 200.
	g view: c view.
	"g view: v view."
	
	ds := RTData new.
	ds interaction popup.
	ds barShape color: Color blue.
	ds points: data.
	
	g add: ds.
	g axisX noTick; noLabel.
	g build.
	"v group: #graph."
	c group: #graph.

	"Second visualization"
	b := RTPieBuilder new.
	b view: c view.
	"b view: v view."
	b interaction popup.
	b objects: data.
	b slice: #yourself.
	b labeled.
	b build.
	"v group: #pie."
   c group: #pie.

	"Layouting"
    c move: #graph onTheLeftOf: #pie.

	RTMetricNormalizer new view: c view;
                 objects: data;
                 distinctColor.
	
	c open.
	
	"v openTitled: 'Data Visualization'."
]

{ #category : #init }
CMECECModel >> fragmentedEnv [
	"initialize an fragmented space (from fragmented.env file) with randomly located foragers"
	
	self spaceModel loadEnvironmentFromFile: 'fragmented.env'.
	self initAgents
]

{ #category : #init }
CMECECModel >> homogeneousEnv [
	"initialize an homogeneous space (from poor.env file) with randomly located foragers"

	"self spaceModel loadEnvironmentFromFile: 'poor.env'."
	self createGridX: 15 Y: 27 neighbourhood: 8 closed: true.
	self theCMECECVegetationUnits do: [ :c |  c initRandomBiomass].
	self initAgents
]

{ #category : #'instance-creation' }
CMECECModel >> homogeneousEnv2 [
	"initialize an homogeneous space (27x27, random biomass) with randomly located foragers"
	
	self spaceModel initializeRegularX: 27 Y: 27 shape: #squared nbNeighbours:
			#eight boundaries: #toroidal.
	self theCMECECVegetationUnits do: [:cell | cell initRandomBiomass].	"or: self initCells: #initRandomBiomass."
	self initAgents
]

{ #category : #'instance-creation' }
CMECECModel >> initAgents [
	"initialize 10 foragers of each type and move then randomly on a free cell"
	
	self
		createN: self restrainedInitialNumber
		randomlyLocatedAloneEntities: CMECECRestrained.
	self
		createN: self unrestrainedInitialNumber
		randomlyLocatedAloneEntities: CMECECUnrestrained
]

{ #category : #init }
CMECECModel >> noAgent [
	"initialize the space (from poor.env file) without agent"
	
	self spaceModel loadEnvironmentFromFile: 'poor.env'
]

{ #category : #accessing }
CMECECModel >> restrainedInitialNumber [
	"Getter accessor with default value = 10.
	!! Code automaticaly generated by Cormas !!  "
	
	^restrainedInitialNumber ifNil: [restrainedInitialNumber := 10]
]

{ #category : #accessing }
CMECECModel >> restrainedInitialNumber: anObject [
	"Setter accessor of attribute restrainedInitialNumber "
	
	restrainedInitialNumber := anObject
]

{ #category : #probes }
CMECECModel >> restrainedSize [
	"return the current population size of the Restrained foragers"

	<probes>
	^ self theCMECECRestraineds size
]

{ #category : #control }
CMECECModel >> step: t [
	"main step: activation of all the plants (Resource dynamics), then activation of the foragers (Agents dynamics)"
	"Resource dynamics   (because the dynamics of the plants are independants, the activation is not mixted)"
	
	self stepEntities: self theCMECECVegetationUnits.	"Agents dynamics    (because the agents may compete for plant access, the activation is randomly mixted)"
	self askRandom: CMECECForager toDo: #step.
]

{ #category : #accessing }
CMECECModel >> theCMECECForagers [
	"Returns a collection of all the instances of aClass (and sub classes) collected by cormasModel"
	
	^self allTheEntities: CMECECForager
]

{ #category : #accessing }
CMECECModel >> theCMECECRestraineds [
^theRestraineds ifNil:[theRestraineds := IndexedSet new]
]

{ #category : #accessing }
CMECECModel >> theCMECECRestraineds: aCollection [
	theCMECECRestraineds := aCollection
]

{ #category : #accessing }
CMECECModel >> theCMECECUnrestraineds [
	
	^theCMECECUnrestraineds ifNil: [theCMECECUnrestraineds := OrderedCollection new]
]

{ #category : #accessing }
CMECECModel >> theCMECECUnrestraineds: aCollection [
	theCMECECUnrestraineds := aCollection
]

{ #category : #accessing }
CMECECModel >> theCMECECVegetationUnits [
	
	^theCMECECVegetationUnits ifNil: [theCMECECVegetationUnits := OrderedCollection new]
]

{ #category : #accessing }
CMECECModel >> theCMECECVegetationUnits: aCollection [
	theCMECECVegetationUnits := aCollection
]

{ #category : #accessing }
CMECECModel >> unrestrainedInitialNumber [
	"Getter accessor with default value = 10.
	!! Code automaticaly generated by Cormas !!  "
	
	^unrestrainedInitialNumber ifNil: [unrestrainedInitialNumber := 10]
]

{ #category : #accessing }
CMECECModel >> unrestrainedInitialNumber: anObject [
	"Setter accessor of attribute unrestrainedInitialNumber "
	
	unrestrainedInitialNumber := anObject
]

{ #category : #probes }
CMECECModel >> unrestrainedSize [
	"return the current population size of the Unrestrained foragers"

	<probes>
	^ self theCMECECUnrestraineds size
]

{ #category : #probes }
CMECECModel >> vegetationBiomass [
	"return the data (a number) to be plotted as the total Biomass of the vegetation"

	<probes>
	^ self theCMECECVegetationUnits inject: 0 into: [ :i :j | i + j biomass ]
]
