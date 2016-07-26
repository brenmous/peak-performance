~~~~~~~~~~~ PEAK PERFORMANCE ~~~~~~~~~~~~

I'll do up a proper readme with a nice flowchart or something eventually but
currently this is the flow of the program:

LOG IN -------------------> TAB BAR VIEW CONTROLLER (goals etc.)
  |           ^			^
  |   fetch user and 		|
  |   load user content		|
  |          			|
  | 				|
  |                             |
  v                             |     
SIGN UP -----> TUTORIAL -> INITAL SETUP
         ^
     create and save user

All text content and other easily loadable stuff should be done before 
dispalying the tab bar views (home screen). Images for dreams should be
loaded in the background though.

I've added a few comments to the DataService methods and throughout the code
to hopefully make it easier to work with. I'm still working it out myself
but I hope it helps.  
