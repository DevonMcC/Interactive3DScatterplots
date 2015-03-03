NB.* progDLAParmsTemplate.ijs: template to test parameters to "progressDLA".

3 : 0 ''
   if. -.(0:"_ <: [: 4!:0 <^:(L. = 0:)) 'BASEDSK' do. BASEDSK=: 'D:' end.
)

3 : 0 ''
   if. -.IFJ6 do. load BASEDSK,'\amisc\JSys\J7\DHMConfig.ijs' end.
)

checkFork=: 3 : 0
   svIF=. _1
   if. nameExists 'IsFORKED' do. svIF=. IsFORKED end.
   IsFORKED=: y
   svIF
)
svIF=. checkFork 1  NB. Avoid unnecessary output from parseDir.

require '~Code/WS.ijs'
require '~Code/mutex.ijs'
coinsert 'mutex'
require '~Code/DiffLimAgg.ijs'

NB.* cvt2d3Array: convert table of numbers to char representation used by d3.
cvt2d3Array=: 3 : '}:_1|.;}.&.>;&.><"1 (<''],[''),.~'','',&.>j2n&.>y'
NB. ARGV_z_=: wh}(ARGV_z_#^:_1~]-.wh),:<'-jijx'
dospathsep=: '\'&(('/' I.@:= ])})  NB.* dospathsep: sub DOS path separator.
NB.* c2c: substitute character (0{x) by 1{x
c2c=: 4 : '(0{"1 ((0{x) = ]) |."0 1 (1{x) ,.~ ])y'
NB.* parms2str: convert enclosed vec or scalar nums to char string.
parms2str=: ' _' c2c [: }: [: ; '_' ,~&.> ":&.>
NB.* pts2bool: explicit point coords to boolean array.
pts2bool=: 3 : '(1) y}0$~>:>./>y=. 0 adjPts y'
NB.* bool2pts: boolean array to origin-centered explicit point coords.
bool2pts=: [: (] -"1 [: <. 2 %~ >./) $ #: [: I. ,
progressDLA_dla_=: 4 : 'y+&.>x [ TMS=: TMS,do1_dla_ <.&.>y'
genparms=: 3 : '(<"0 /:~3+?30 30),<\:~2?@$0[y'"0

NB. Initialize globals
3 : 0 ''
   DATDIR=: '/amisc/J/DLA/'
   if. -.dirExists LOGDIR=: DATDIR,'logs' do. shell 'mkdir ',dospathsep LOGDIR end.
   LOGDIR=: LOGDIR,'/'
   LOCKFL=: LOGDIR,'progDLAParms.lock'
   SEED=: bool2pts (15$2)#: 2310 14095 26004 608 1056 192 1728 6400 4096  NB. Starting DLA
)

13!:0]1

NB.* pieceOfWork: generate DLA with parameters changing as determined by parms.
pieceOfWork=: 3 : 0
   parms=. ".y
   if. 3~:#y do.                             NB. Do nothing if an arg missing.
       PTS_dla_=: SEED [ init_dla_ 2         NB. Initialize DLA points.
       TMS_dla_=: 0 9$0                      NB. Initialize timings var.
       parms progressDLA_dla_^:100 ] 20;100;5 2   NB. Do the job.
       saveTimingPoints parms
   end.
)

saveTimingPoints=: 3 : 0
   suff=. '.p' c2c (parms2str y),'x',":?1e9   NB. Distinct name suffix.
   tmname=. 'TMS',suff                   NB. Distinct name for
   (tmname)=: TMS_dla_                   NB.  timings var:
   LOGDIR fileVar_WS_ tmname             NB.  save it.
   dlaname=. 'DLA',suff                  NB. Distinct name for DLA,
   (dlaname)=: PTS_dla_
   LOGDIR fileVar_WS_ dlaname            NB.   save it too.
   tmname;dlaname
NB.EG saveTimingPoints parms
)

runIt=: 3 : 0
NB.* Only invoke if not loaded via interactive session.
   if. -.nameExists 'IsFORKED' do. IsFORKED=. 0 end.
   if. IsFORKED +. (5{.&.>'-jijx';<'-rt') +./ . e. 5&{.&.>tolower&.>ARGV_z_ do.
       parms=. '"'-.~&.>(ARGV_z_,2$a:){~>:ARGV_z_ i. <'PARMS'
       if. 0<#;parms do. pieceOfWork ;parms
           2!:55''
       end.
   end.
)

runIt''
