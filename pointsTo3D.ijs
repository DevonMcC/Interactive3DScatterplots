NB.* pointsTo3D.ijs: wrap HTML around 3D points for interactive display.

1!:44 '/amisc/J/DLA'
load 'progDLAParmsTemplate.ijs'

getSomePts=: 0 : 0
   LOGDIR unfileVar_WS_ 'pts3D17634'
   pts0=. _8000{.pts3D17634
   LOGDIR unfileVar_WS_ 'DLA2_5_0p2_0p14x453178703'
   dal=. DLA2_5_0p2_0p14x453178703
   pts1=. dal#~25>%:+/"1 *:dal
   clrs=. (0$~#pts0),1$~#pts1
)

NB.* cvt2d3Array: convert table of numbers to char representation used by d3.
cvt2d3Array=: 3 : '}:_1|.;}.&.>;&.><"1 (<''],[''),.~'','',&.>j2n&.>y'

buildView=: 3 : 0
   'pts clrs flpfx'=. y   
   mystmplt=. fread 'ScatterPlot3D1_files/myScatterPlot3DJS.tmplt'
   tmplt=. fread 'ScatterPlot3D.tmplt'
   (tmplt rplc '{points}';cvt2d3Array pts) fwrite flpfx,'.htm'
   
   set0=. (<cSets) rplc &.> (<'{i.#pts}');&.>":&.>i.#pts
   set1=. ;set0 rplc&.> (<'{colorIx}');&.>":&.>clrs
   subfns=. mystmplt rplc '{colorsets}';set1
   subfns fwrite 'ScatterPlot3D1_files/',flpfx,'.js'
)

cSets=: 0 : 0
    pointGeo.vertices.push(new THREE.Vertex( new THREE.Vector3(csv.data[{i.#pts}][0], csv.data[{i.#pts}][1], csv.data[{i.#pts}][2])));
    pointGeo.colors.push(colors[{colorIx}]);
)
