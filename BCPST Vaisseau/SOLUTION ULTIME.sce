function test(win,x,y,ibut)
  a=0;
  if ibut==-1000 then return,end
  if ibut==122|ibut==-122 then messagebox("Salut");
  end
  

endfunction

plot2d()
fig = gcf() ;
fig.event_handler = 'test' ;
fig.event_handler_enable = "on" ;