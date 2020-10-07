import java.util.Iterator;
import java.util.Vector;
import javax.swing.JButton;
import javax.swing.JFrame;
import java.awt.FlowLayout;
import java.util.concurrent.TimeUnit;
import java.text.DecimalFormat;  
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.text.SimpleDateFormat;
Date horario = new Date();
long tempo=horario.getTime();
Vector al = new Vector();
Vector lp = new Vector();
Vector cpu = new Vector();
Vector naoaptos = new Vector();
int cores=0;
int squaresize=80;
float quantumMAX=0;
int mode=0;
int numMax=-1;
int ControleLista;
int N=0;
int iy=0;
int getCores(){
  return cores;
}
float getQuantumMAX(){
  return quantumMAX;
}
int getMode(){
  return mode;
}
int getPI(){
  return N;
}
void setCores(int qtde_cores){
   cores = qtde_cores;
}
void setQuantumMAX(float valor_quantum){
  quantumMAX = valor_quantum;
}
void setMode(int mode){
  this.mode = mode;
}
void setPI(int N){
  this.N = N;
}
public class process{
   int num;
   double time;
   double time_max;
   Date deadline=new Date(tempo+(long)((Math.random()*16+4)*1000));
   Date intervalo=(new Date(tempo+(long)((Math.random()*20)*1000)));
   Date HCriacao=(new Date());
   int prioridade;
   String estado;
};
public class core{
   process p;
   double quantum;
   boolean is_empty;
};
void addprocess(){
       process p=new process();
       numMax++;
       p.num=numMax;
       p.time=Math.random()*16+4;
       p.time_max=p.time;
       p.estado="Esp";
       if(Math.random()*4<1){
          p.estado="Espera";
          naoaptos.add(p);
       }else{
          p.estado="Pronto"; 
          al.add(p);
       }
}
void addprocesslp(){
       process p=new process();
       numMax++;
       p.num=numMax;
       p.time=Math.random()*16+4;
       p.time_max=p.time;
       p.prioridade=(int)(Math.random()*4-0.00001);
       if(Math.random()*4<1){
        p.estado="Espera";
        naoaptos.add(p);
       }else{
        p.estado="Pronto"; 
        ((Vector)(lp.get((p.prioridade)))).add(p);
       }
}
void insertprocess(){
   process p=new process();
   p.time=p.time_max=Math.random()*16+4;
   p.num=numMax;
   numMax++;
   if(Math.random()*4<1){
          p.estado="Espera";
          naoaptos.add(p);
   }else{
          p.estado="Pronto"; 
         if(al.isEmpty()){
               al.add(p);
         }else{
               int i=0;
               while(p.time>((process)al.get(i)).time){
               i++;
               if(i>=al.size()){
                   break;
               }
               }
               al.insertElementAt(p,i);
       }  
   }
}
void drawprocess(float x,float y,process p){
       noStroke();
       DecimalFormat df=new DecimalFormat("0.###");
       SimpleDateFormat sdf = new SimpleDateFormat("[hh:mm:ss]");
       fill((int)(255*(p.time/20)),255-(int) (255*(p.time/20)),255-(int)(255*(p.time/20)));
       square(x, y, squaresize);
       fill(0);
       text("P"+p.num,x,y+10);
       if(mode==2)
       text("Pr:"+(3-p.prioridade),x+50,y+squaresize/2-20);
       text("E:"+p.estado,x,y+squaresize/2-20);
       text("T:"+(df.format((double)p.time)),x,y+squaresize/2-10);
       text("Tm:"+(df.format((double)p.time_max)),x,y+squaresize/2+10-10);
       text("DL:"+(sdf.format(p.deadline)),x,y+squaresize/2+20-10);
       text("I:"+(sdf.format(p.HCriacao)+"-"),x,y+squaresize/2+20);
       text((sdf.format(p.intervalo)),x,y+squaresize/2+30);

}
void drawarray(Vector v,float ix,float iy){
       int i=0,dx=0,dy=0;
       while(i<v.size()){
            if(dx*(10+squaresize)+squaresize>width){
              dx=0;
              if(dy<2 | mode!=2)
              dy++;
       }
            drawprocess(ix+dx*(10+squaresize),iy+dy*(10+squaresize),(process)v.get(i));
            i++;
            dx++;
           
       }
}
void drawarrayCPU(Vector v,float ix,float iy){
       int i=0,dx=0,dy=0;
       DecimalFormat df=new DecimalFormat("0.###");
       while(i<v.size()){
            if(dx*(10+squaresize)+squaresize>width){
              dx=0;
              dy++;
       }
            if (((core)v.get(i)).is_empty){
             fill(255);
             text("Core",ix+dx*(10+squaresize)+5,iy+dy*(10+squaresize)+10);
             text("Vazio",ix+dx*(10+squaresize)+5,iy+dy*(10+squaresize)+20);
            }else{
            drawprocess(ix+dx*(10+squaresize),iy+dy*(10+squaresize),((core)v.get(i)).p);
            if((((core)v.get(i)).quantum)>0)
            text("Q:"+(df.format((double)((core)v.get(i)).quantum)),ix+dx*(10+squaresize),iy+dy*(10+squaresize)+squaresize/2+40);
            }
            i++;
            dx++;
       }
}
void drawLP(){
     fill(255);
     text("Prioridade 3",20,height/2+200+iy);
     drawarray((Vector)lp.get(0),20,height/2+205+iy);
     fill(255);
     text("Prioridade 2",20,height/2+400+squaresize+iy);
     drawarray((Vector)lp.get(1),20,height/2+405+squaresize+iy);
     fill(255);
     text("Prioridade 1",20,height/2+600+2*squaresize+iy);
     drawarray((Vector)lp.get(2),20,height/2+605+2*squaresize+iy);
     fill(255);
     text("Prioridade 0",20,height/2+800+3*squaresize+iy);
     drawarray((Vector)lp.get(3),20,height/2+805+3*squaresize+iy);
     
}
void atualizarcpu(){
       for(int i=0;i<cores;i++){
              if(((core)(cpu.get(i))).is_empty && al.size()>0){
                   ((core)(cpu.get(i))).p=((process)al.get(0));
                   (((core)(cpu.get(i))).p).estado="Exe";
                   al.remove(0);
                   (((core)(cpu.get(i)))).quantum=quantumMAX;
                   ((core)(cpu.get(i))).is_empty=false;
              }
              if((((core)(cpu.get(i))).p).time<=0){
                   ((core)(cpu.get(i))).p=new process();
                   ((core)(cpu.get(i))).is_empty=true;
              }else if((((core)(cpu.get(i)))).quantum<=0){
                    (((core)(cpu.get(i))).p).estado="Pronto";
                    al.add((((core)(cpu.get(i))).p));
                    ((core)(cpu.get(i))).p=new process();
                    ((core)(cpu.get(i))).is_empty=true;
              }
              (((core)(cpu.get(i))).p).time=(((core)(cpu.get(i))).p).time-0.1;
              ((core)(cpu.get(i))).quantum=((core)(cpu.get(i))).quantum-0.1;
       }
}
void atualizarcpusjf(){
     for(int i=0;i<cores;i++){
              if(((core)(cpu.get(i))).is_empty && al.size()>0){
                   ((core)(cpu.get(i))).p=((process)al.get(0));
                   (((core)(cpu.get(i))).p).estado="Exe";
                   al.remove(0);
                   ((core)(cpu.get(i))).is_empty=false;
              }
              if((((core)cpu.get(i)).p).time<=0){
                       ((core)(cpu.get(i))).p=new process();
                       ((core)(cpu.get(i))).is_empty=true;
              }else{
                       (((core)cpu.get(i)).p).time=(((core)cpu.get(i)).p).time-0.1;
              }
     }
}
void atualizarcpulp(){
       for(int i=0;i<cores;i++){
              if(((core)(cpu.get(i))).is_empty){
                if(((Vector)lp.get(ControleLista)).size()<=0){
                      ControleLista++;
                      ControleLista=ControleLista%4;
                }
                if(((Vector)lp.get(ControleLista)).size()<=0){
                      ControleLista++;
                      ControleLista=ControleLista%4;
                }
                if(((Vector)lp.get(ControleLista)).size()<=0){
                      ControleLista++;
                      ControleLista=ControleLista%4;
                }
                if(((Vector)lp.get(ControleLista)).size()<=0){
                      ControleLista++;
                      ControleLista=ControleLista%4;
                }
                if(((Vector)lp.get(ControleLista)).size()>0){
                   ((core)(cpu.get(i))).p=(process)(((Vector)lp.get(ControleLista)).get(0));
                   (((core)(cpu.get(i))).p).estado="Exe";
                   ((Vector)lp.get(ControleLista)).remove(0);
                   (((core)(cpu.get(i)))).quantum=quantumMAX/(1+ControleLista);
                   ((core)(cpu.get(i))).is_empty=false;
                   ControleLista++;
                   ControleLista=ControleLista%4;
                }
              }
              if((((core)(cpu.get(i))).p).time<=0){
                   ((core)(cpu.get(i))).p=new process();
                   ((core)(cpu.get(i))).is_empty=true;
              }else if((((core)(cpu.get(i)))).quantum<=0){
                    (((core)(cpu.get(i))).p).estado="Pronto";
                    ((Vector)lp.get(((((core)(cpu.get(i))).p).prioridade))).add((((core)(cpu.get(i))).p));
                    ((core)(cpu.get(i))).p=new process();
                    ((core)(cpu.get(i))).is_empty=true;
              }
              (((core)(cpu.get(i))).p).time=(((core)(cpu.get(i))).p).time-0.1;
              ((core)(cpu.get(i))).quantum=((core)(cpu.get(i))).quantum-0.1;
       }
}
void CriarCpus(){
     for(int i=0;i<cores;i++){
           core emptycpu = new core();
           emptycpu.p = new process();
           emptycpu.is_empty=true;

             cpu.add(emptycpu);
     }
}
void CriarLista(){
    for(int i=0;i<4;i++){
         Vector a=new Vector();
         lp.add(a);
    }
}
void BotaoConfiguracao(){
      Painel panel = new Painel(false);
      panel.setVisible(true);
      panel.pack();
}
void drawbotoes(){
      fill(255);
      stroke(0);
      rect(20,height-70,80,20);
      rect(130,height-70,50,20);
      fill(0);
      text("Add Process",23,height-55);
      text("Config",133,height-55);
}
void autalizarnaoaptos(){
      for(int i=0;i<naoaptos.size();i++){
            if(Math.random()*100<1){
                 ((process)(naoaptos.get(i))).estado="Pronto";
                 if(mode==0){
                             if(al.isEmpty()){
                                al.add((process)(naoaptos.get(i)));
                             }else{
                                int j=0;
                                while(((process)(naoaptos.get(i))).time>((process)al.get(j)).time){
                                i++;
                                if(i>=al.size()){
                                       break;
                                }
                                }
                                al.insertElementAt(((process)(naoaptos.get(i))),j);
                           }  
                 }else if(mode==1){
                             al.add(((process)(naoaptos.get(i))));
                 }else if(mode==2){
                             ((Vector)(lp.get((((process)(naoaptos.get(i)))).prioridade))).add(((process)(naoaptos.get(i))));
                 }
                 naoaptos.remove(i);
            }
      }
      
}
void mouseClicked(){
      if(mouseY<height-50 && mouseY>height-70 && mouseX>20 && mouseX<100){
          if(mode==0){
            insertprocess();
          }else if(mode==1){
            addprocess();
          }else if(mode==2){
            addprocesslp();
          }
      }
      if(mouseX>130 && mouseX<180 && mouseY<height-50 && mouseY>height-70){
          BotaoConfiguracao();
      }
}
void mouseWheel(MouseEvent event) {
  int e = event.getCount();
  if((iy-50)<100){
  iy = iy-50*e;
  }else{
      iy=iy-50;
  }
  
}
void setup() {
       Painel painelInicial = new Painel(true);
       painelInicial.setVisible(true);
       painelInicial.pack();
       painelInicial.Pausar();
       size(1280,700);
       background(50);
       CriarCpus();
       CriarLista();
          for(int i=0;i<N;i++){
                if(mode==0){
                insertprocess();
                }else if(mode==1){
                addprocess();
                }else if(mode==2){
                addprocesslp();
                }
          }
       
}
void draw() {
      background(40);
      if(mode==0){
          atualizarcpusjf();
          drawarray(al,20,height/2+iy+3*squaresize);
          fill(255);
          text("Cpus:",20,50+iy);
          text("Lista de processos:",20,330+iy+3*squaresize);
          drawarrayCPU(cpu,20,60+iy);
      }else if(mode==1){
          atualizarcpu();
          fill(255);
          text("Cpu:",20,50+iy);
          text("Lista:",20,340+iy+3*squaresize);
          drawarray(al,20,height/2+iy+3*squaresize);
          drawarrayCPU(cpu,20,60+iy);
      }else if(mode==2){
          fill(255);
          text("Cpu:",20,50+iy);
          atualizarcpulp();
          drawarrayCPU(cpu,20,60+iy);
          drawLP();
      }
      fill(255);
      text("Nao Aptos:",20,1700+iy);
      drawarray(naoaptos,20,1705+5+iy);
      drawbotoes();
      autalizarnaoaptos();
      try {
         Thread.sleep(90);
      } catch(InterruptedException e) {
              print("got interrupted!");
      }
      
}
