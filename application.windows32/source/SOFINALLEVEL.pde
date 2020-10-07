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

HScrollbar hs1; //(AQUI)

Date horario = new Date();
long tempo=horario.getTime();
Vector al = new Vector();
Vector lp = new Vector();
Vector cpu = new Vector();
Vector paginas = new Vector();
Vector blocosLivres = new Vector();
Vector naoaptos = new Vector();
Vector ab= new Vector();
Vector completos= new Vector();
Vector HD=new Vector();
int cores=2;
int squaresize=80;
float quantumMAX=5;
int mode=1;
int numMax=-1;
int ControleLista;
int N=40;
int iy=0;
int ix=0;
int dy;
float timestep=0.1;  //variavel de tempo
int tamanhoMemoria=10000; // tamanho da memoria
int modemem=0; // 0= best ; 1 = merge
int modedraw=1;
float ly;
int hide=0;
int tamanhopagina=1000;
int drawpaginas=1;
short limite=80;
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
int getModeMem(){
  return modemem;
}
int getTamMem(){
  return tamanhoMemoria;
}
void setCores(int qtde_cores){
   cores = qtde_cores;
}
void setQuantumMAX(float valor_quantum){
  quantumMAX = valor_quantum;
}
void setModeMem(int modemem){
  this.modemem = modemem;
}
void setPI(int N){
  this.N = N;
}
void setTamMem(int tamanhoMemoria){
  this.tamanhoMemoria = tamanhoMemoria;
}
public class process{
   int num;
   double time;
   double time_max;
   int tamanho=(int)(Math.random()*(512-128)+128);
   int tamanhostat=tamanho;
   Date deadline=new Date(tempo+(long)((Math.random()*16+4)*1000));
   Date intervalo=(new Date(tempo+(long)((Math.random()*20)*1000)));
   Date HCriacao=(new Date());
   int prioridade;
   String estado;
};
public class particao{
   int processo;
   int tamanho;
   int ocupado;
};
public class core{
   process p;
   double quantum;
   boolean is_empty;
};
public class pagina{
   Vector memoria = new Vector();
   Vector processos = new Vector();
   Vector ocupacao = new Vector();
   particao p=new particao();
   pagina(){
      p.tamanho=tamanhopagina;
      p.ocupado=-1;
      memoria.add(p);
   }
}
void addprocess(){
       process p=new process();
       numMax++;
       p.num=numMax;
       p.time=Math.random()*20+10;
       p.time_max=p.time;
       p.estado="Esp";
      /* if(Math.random()*4<1){
          p.estado="Espera";
          naoaptos.add(p);
       }else{/*/
          p.estado="Pronto"; 
          al.add(p);
      // }
}
void addprocesslp(){
       process p=new process();
       numMax++;
       p.num=numMax;
       p.time=Math.random()*16+4;
       p.time_max=p.time;
       p.prioridade=(int)(Math.random()*4-0.00001);
       /*if(Math.random()*4<1){
        p.estado="Espera";
        naoaptos.add(p);
       }else{ */
        p.estado="Pronto"; 
        ((Vector)(lp.get((p.prioridade)))).add(p);
       //}
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
      // SimpleDateFormat sdf = new SimpleDateFormat("[hh:mm:ss]");
      // fill((int)(255*(p.time/20)),255-(int) (255*(p.time/20)),255-(int)(255*(p.time/20)));
       float rectsize=(float)(squaresize*(1-p.time/p.time_max));
       fill(255,50,50);
       square(x, y, squaresize);
       fill(50,50,255);
       rect(x,y,rectsize,squaresize);
       fill(0);
       text("P"+p.num,x,y+10);
       if(mode==2)
       text("Pr:"+(3-p.prioridade),x+50,y+squaresize/2-20);
       text("E:"+p.estado,x,y+squaresize/2-20);
       if(p.time<0)
          p.time=0;
       text("T:"+(df.format((double)p.time)),x,y+squaresize/2-10);
       text("Tm:"+(df.format((double)p.time_max)),x,y+squaresize/2+10-10);
       text("Tam:"+(df.format((double)p.tamanhostat)),x,y+squaresize/2+10+10-10);
      /* text("DL:"+(sdf.format(p.deadline)),x,y+squaresize/2+20-10);
       text("I:"+(sdf.format(p.HCriacao)+"-"),x,y+squaresize/2+20);
       text((sdf.format(p.intervalo)),x,y+squaresize/2+30);*/
       ly=y+squaresize+50;

}
void drawarray(Vector v,float ix,float iy){
       int i=0,dx=0,dy=0;
       if(v.size()==0){
           ly=iy+squaresize;
       }
       while(i<v.size()){
            if(dx*(10+squaresize)+squaresize>width){
              dx=0;
              if((dy<2 | mode!=2)&&dy<11)
              dy++;
       }
            drawprocess(ix+dx*(10+squaresize),iy+dy*(10+squaresize),(process)v.get(i));
            i++;
            dx++;
           
       }
}
void drawpaginas(Vector pag,float x,float y){
      for(int i=0;i<pag.size();i++){
           x=drawpagina((pagina)(pag.get(i)),x,y,i+1);
      }
      ly=ly+2*squaresize;
}
float drawpagina(pagina p,float x,float y,int ID){
   float largura = 1000*tamanhopagina/tamanhoMemoria+20;
   fill(120,100,255);
   rect(x,y,largura,squaresize+10);
   if(drawpaginas==1){
   drawmemoria(p.memoria,x+5,y-squaresize);
   }else{
   fill(0);
   text("ID:"+ID,x,y+10);
   text("Processos",x,y+20);
   for(int i=0;i<p.processos.size();i++){
       text("P"+(int)(p.processos.get(i))+":"+(int)(p.ocupacao.get(i))+"/"+tamanhopagina,x,y+30+i*10);
   }
   }
   return x+largura+3;
}
float drawparticao(particao p,float x,float y,int i){
      DecimalFormat df=new DecimalFormat("0.###");
      float largura;
      float largurao;
      if(modedraw==1){
       largura=1000*(((float)p.tamanho)/((float)tamanhoMemoria));
       largurao=1000*(((float)p.ocupado)/((float)tamanhoMemoria));
      }else{
       largura=squaresize;
       largurao=squaresize*(((float)p.ocupado)/((float)p.tamanho));
      }
      if(largura+x>width){
          return -1;
      }
      y=y+(5+squaresize);
      fill(255,155,22);
      rect(x,y,largura,squaresize);
      if(p.ocupado>0){
      fill(10,255,22);
      rect(x,y,largurao,squaresize);
      fill(0,0,0);
      text("ID:"+(i+1),x,y+10);
      text("P:"+p.processo,x,y+20);
      text("Oc:"+(df.format((double)p.ocupado)),x,y+squaresize/2-10);
      text("Tam:"+(df.format((double)p.tamanho)),x,y+squaresize/2+10-10);
      }else{
      fill(0,0,0);
      text("Bloco Livre",x,y+10);
      text("Tam:"+(df.format((double)p.tamanho)),x,y+squaresize/2+10-10);
      }
      return (largura+x);
}
void drawmemoria(Vector memoria,float x,float y){
      float dx=x;
      for(int i=0;i<memoria.size();i++){
           dx=drawparticao((particao)memoria.get(i),dx,y,i)+1;
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
             ly=iy+squaresize+50;
            }else{
            drawprocess(ix+dx*(10+squaresize),iy+dy*(10+squaresize),((core)v.get(i)).p);
            if((((core)v.get(i)).quantum)>0)
            text("Q:"+(df.format((double)((core)v.get(i)).quantum)),ix+dx*(10+squaresize),iy+dy*(10+squaresize)+squaresize/2+30);
            }
            i++;
            dx++;
       }
}
boolean requisicao(process p,int tamanho){
       for(int i=0;i<paginas.size();i++){
              pagina pa=(pagina)paginas.get(i);
              Vector mem=pa.memoria;
              if(requisicao2(mem,p,tamanho)){
                   return true;
              }
       }
       return false;
}
boolean requisicao2(Vector memoria,process p,int tamanho){
     if(modemem==0){
     int indicem=0, merro=tamanhoMemoria;
     if(tamanho>0){
     for(int i=0;i<memoria.size();i++){
           if(((particao)(memoria.get(i))).ocupado==-1 && ((particao)(memoria.get(i))).tamanho>=tamanho){
                     particao pa=new particao();
                     pa.tamanho=tamanho;
                     pa.ocupado=tamanho;
                     pa.processo=p.num;
                     (((particao)(memoria.get(i))).tamanho)=(((particao)(memoria.get(i))).tamanho)-tamanho;
                     memoria.add(i,pa);
                     
                     return true;
           }else if(((particao)(memoria.get(i))).ocupado==0 && ((particao)(memoria.get(i))).tamanho>=tamanho){
                          if((((particao)(memoria.get(i))).tamanho-tamanho)<merro && (((particao)(memoria.get(i))).tamanho-tamanho)>=0){
                                     merro=(((particao)(memoria.get(i))).tamanho-tamanho);
                                     indicem=i;
                          }
                     }
           }
     }else{
          return true;
     }
     if(merro!=tamanhoMemoria){
           particao pa=new particao();
                     pa.tamanho= (((particao)(memoria.get(indicem))).tamanho);
                     pa.ocupado=tamanho;
                     pa.processo=p.num;
                     memoria.set(indicem,pa);
     }else{
         return false;
     }
     return true;
    }else{
          if(tamanho==0){
             return true;
          }
          for(int i=0;i<memoria.size();i++){
                 if(((particao)(memoria.get(i))).ocupado<=0 && ((particao)(memoria.get(i))).tamanho>=tamanho){
                       particao pa=new particao();
                       pa.tamanho=tamanho;
                       pa.ocupado=tamanho;
                       pa.processo=p.num;
                       (((particao)(memoria.get(i))).tamanho)=(((particao)(memoria.get(i))).tamanho)-tamanho;
                       memoria.add(i,pa);
                       return true;
                 }else{
                       if(i==memoria.size()-1)
                       return false;
                 }
          }
    }
    return false;
}
void free(int n){
    for(int j=0;j<paginas.size();j++){
    for(int i=0;i<(((pagina)(paginas.get(j))).memoria).size();i++){
          if(((particao)((((pagina)(paginas.get(j))).memoria).get(i))).processo==n){
                 ((particao)((((pagina)(paginas.get(j))).memoria).get(i))).processo=-1;
                 ((particao)((((pagina)(paginas.get(j))).memoria).get(i))).ocupado=0;
                 
          }
    }
    }
}
void atualizarcpu(){
       for(int i=0;i<cores;i++){
              if(((core)(cpu.get(i))).is_empty && al.size()>0){
                   if(requisicao(((process)al.get(0)),((process)al.get(0)).tamanho)){
                           ((core)(cpu.get(i))).p=((process)al.get(0));
                           (((core)(cpu.get(i))).p).estado="Exe";
                           al.remove(0);
                           (((core)(cpu.get(i)))).quantum=quantumMAX;
                           ((core)(cpu.get(i))).is_empty=false;
                           swapin((((core)(cpu.get(i)))).p.num);
                   }else{
                           ab.add(al.get(0));
                           al.remove(0);
                   }
                   if(al.size()>0){
                   if(!requisicao(((process)al.get(0)),((process)al.get(0)).tamanho)){
                       ab.add(al.get(0));
                       al.remove(0);
                   }else{
                   ((process)al.get(0)).tamanho=0;
                   }
                   }
              }
              if((((core)(cpu.get(i))).p).time<=0 && !((core)(cpu.get(i))).is_empty){
                    free((((core)(cpu.get(i))).p).num);
                    completos.add(((core)(cpu.get(i))).p);
                   ((core)(cpu.get(i))).p=new process();
                   ((core)(cpu.get(i))).is_empty=true;
              }else if((((core)(cpu.get(i)))).quantum<=0 && !((core)(cpu.get(i))).is_empty){
                    (((core)(cpu.get(i))).p).estado="Pronto";
                    (((core)(cpu.get(i))).p).tamanho=0;
                    al.add((((core)(cpu.get(i))).p));
                    ((core)(cpu.get(i))).p=new process();
                    ((core)(cpu.get(i))).is_empty=true;
              }else if(!((core)(cpu.get(i))).is_empty && timestep>0){
              (((core)(cpu.get(i))).p).time=(((core)(cpu.get(i))).p).time-timestep;
              ((core)(cpu.get(i))).quantum=((core)(cpu.get(i))).quantum-timestep;
                   if(Math.random()*100<5){
                     if(!requisicao((((core)(cpu.get(i))).p),(int)(Math.random()*100)+32)){
                              free((((core)(cpu.get(i))).p).num);
                              ab.add(((core)(cpu.get(i))).p);
                              ((core)(cpu.get(i))).p=new process();
                              ((core)(cpu.get(i))).is_empty=true;
                     }
       }
      }
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
void CriarMemoria(){
    int npaginas = (int)(tamanhoMemoria/tamanhopagina);
    for(int i=0;i<npaginas;i++){
        pagina p=new pagina();
        paginas.add(p);
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
void keyPressed(){
      if(key=='p'){
           if(timestep==0){
              timestep=0.1;
           }else{
           timestep=0;
           }
      }else if(key=='+'){
           ix=ix+10;
      }else if(key=='-'){
           ix=ix-10;
      }else if(key=='m'){
           drawpaginas=(int)abs(drawpaginas-1);
      }else if(key=='h'){
           hide=(int)abs(hide-1);
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
  iy = min(iy-50*e,0);
  
}
void atualpaginas(){
    for(int i=0;i<paginas.size();i++){
        Vector v=new Vector();
        Vector oc=new Vector();
        for(int j=0;j<((Vector)(((pagina)(paginas.get(i))).memoria)).size();j++){
              if(((particao)(((Vector)(((pagina)(paginas.get(i))).memoria)).get(j))).ocupado>0){
              v.add(((particao)(((Vector)(((pagina)(paginas.get(i))).memoria)).get(j))).processo);
              oc.add(((particao)(((Vector)(((pagina)(paginas.get(i))).memoria)).get(j))).tamanho);
              }
              v.sort(null);
              for(int k=1;k<v.size();k++){
                        if((int)(v.get(k))==(int)(v.get(k-1))){
                             v.remove(k);
                             int aux=(int)oc.get(k)+(int)oc.get(k-1);
                             oc.remove(k);
                             oc.remove(k-1);
                             oc.insertElementAt(aux,k-1);
                        }
              }
        }
        ((pagina)(paginas.get(i))).processos=v;
        ((pagina)(paginas.get(i))).ocupacao=oc;
    }
    float soma=check();
   // print(soma);
    //println();
    if(soma>limite){
        swapout(soma);
    }
}
float check(){
    float soma=0;
    for(int i=0;i<paginas.size();i++){
        for(int j=0;j<((pagina)(paginas.get(i))).ocupacao.size();j++){
                soma=soma+(int)((pagina)(paginas.get(i))).ocupacao.get(j);
        }
    }
    soma=soma/((float)tamanhoMemoria)*100;
    return soma;
}
void swapout(float soma){ 
    Vector salvos=new Vector();
    for(int i=0;i<cpu.size();i++){
          salvos.add((int)(((process)((core)cpu.get(i)).p).num));
    }
    for(int i=0;i<3;i++){
          salvos.add((int)(((process)al.get(i)).num));
    }
    for(int i=0;i<salvos.size();i++){
         print(salvos.get(i)+" ");
    }
    println();
    while(soma>limite){
          Vector removiveis=new Vector();
          Vector Bp=new Vector();
          int Npaginas=(int)tamanhoMemoria/tamanhopagina;
          for(int i=0;i<Npaginas;i++){
              Bp.add(1);
          }
         // boolean sairfor=false;
          for(int i=0;i<paginas.size();i++){
              Vector processos=(Vector)((pagina)paginas.get(i)).processos;
              if(processos.size()==0){
                                     Bp.remove(i);
                                     Bp.insertElementAt(0,i);
              }
              for(int j=0;j<processos.size();j++){
                    for(int k=0;k<salvos.size();k++){
                              println(i+" "+"Processo:"+processos.get(j)+" Salvos:"+salvos.get(k));
                              if(processos.get(j)==salvos.get(k)){
                                     println("Achou");
                                     Bp.remove(i);
                                     Bp.insertElementAt(0,i);
                              }
                    }
               }
        }
        for(int i=0;i<Npaginas;i++){
              int aux=(int)Bp.get(i);
              if(aux==1){
                    removiveis.add(i);
              }
        }
        print("Removiveis:");
        for(int i=0;i<removiveis.size();i++){
         print(removiveis.get(i)+" ");
        }
        println();
        while(soma>limite&&removiveis.size()>0){
               int remov=(int)removiveis.get(removiveis.size()-1);
               HD.add(paginas.get(remov));
               paginas.remove(remov);
               paginas.insertElementAt(new pagina(),remov);
               removiveis.remove(removiveis.size()-1);
               soma=check();
        }
               soma=check();
       /* if(!salvos.isEmpty()&&soma>limite){
           salvos.remove(salvos.size()-1);
        }/*/
        print("Salvos:");
        for(int i=0;i<salvos.size();i++){
         print(salvos.get(i)+" ");
        }
        println();
    }
}
void swapin(int process){
       Vector swapadas=new Vector();
       Vector removiveis=new Vector();
       Vector Swapidas=new Vector();
       boolean auxiliarnumero23234=false;
       for(int i=0;i<HD.size();i++){
            pagina p=(pagina)HD.get(i);
            for(int j=0;j<(p.processos).size();j++){
                  if(auxiliarnumero23234){
                          
                  }else{
                  if((int)(p.processos).get(j)==process){
                        swapadas.add(HD.get(i));
                        Swapidas.add(i);
                  }
                  }
            }
       }
       Vector salvos=new Vector();
       for(int i=0;i<cpu.size();i++){
          salvos.add((int)(((process)((core)cpu.get(i)).p).num));
       }
       for(int i=0;i<3;i++){
          salvos.add((int)(((process)al.get(i)).num));
       }
       while(removiveis.size()<swapadas.size()){
                   Vector Bp=new Vector();
          int Npaginas=(int)tamanhoMemoria/tamanhopagina;
          for(int i=0;i<Npaginas;i++){
              Bp.add(1);
          }
         // boolean sairfor=false;
          for(int i=0;i<paginas.size();i++){
              Vector processos=(Vector)((pagina)paginas.get(i)).processos;
              if(processos.size()==0){
                                     Bp.remove(i);
                                     Bp.insertElementAt(0,i);
              }
              for(int j=0;j<processos.size();j++){
                    for(int k=0;k<salvos.size();k++){
                              println(i+" "+"Processo:"+processos.get(j)+" Salvos:"+salvos.get(k));
                              if(processos.get(j)==salvos.get(k)){
                                     println("Achou");
                                     Bp.remove(i);
                                     Bp.insertElementAt(0,i);
                              }
                    }
               }
        }
        for(int i=0;i<Npaginas;i++){
              int aux=(int)Bp.get(i);
              if(aux==1){
                    removiveis.add(i);
              }
        }
        if(!salvos.isEmpty()){
             salvos.remove(salvos.size()-1);
        }
       }
       for(int i=0;i<swapadas.size();i++){
            int remov=(int)removiveis.get(0);
            pagina aux=(pagina)paginas.get(remov);
            HD.remove((int)(Swapidas.get(i)));
            HD.insertElementAt(aux,(int)Swapidas.get(i));
            paginas.remove(remov);
            paginas.insertElementAt(swapadas.get(i),remov);
            
       }
}
void drawab(){
int j=0;
fill(50,100);
rect(860,400,400,200);
       for(int i=ab.size()-1;i>ab.size()-8;i--){
               if(i>=0){
               textSize(26);
               fill(255);
               text("Processo "+((process)(ab.get(i))).num+" foi abortado",860,600-(j*26));
               textSize(11);
               }
               j++;
       }
}
void setup() {
       Painel painelInicial = new Painel(true);
       painelInicial.setVisible(true);
       painelInicial.pack();
       painelInicial.Pausar();
       dy=(1+((int)cores/14))*squaresize;
       size(1280,700);
       background(50);
       CriarCpus();
       CriarLista();
       CriarMemoria();
       for(int i=0;i<N;i++){
         if(mode==0){
         insertprocess();
         }else if(mode==1){
         addprocess();
         }else if(mode==2){
         addprocesslp();
         }
       }
       hs1 = new HScrollbar(110, 20, 1000, 16, 1);
       
}
void draw() {
      background(40);
      fill(255,255,255);
      text("Timestep:"+timestep,20,23+iy);
          if(timestep>0)
          atualizarcpu();
          fill(255);
          text("Cpu:",20+ix,50+iy);
          drawarrayCPU(cpu,20,60+iy);
          fill(255);
          text("Memoria Ram:",20+ix,ly-5);
          drawpaginas(paginas,20,ly);
          fill(255);
          if(hide==0){
              text("Memoria SWAP:",20+ix,ly-5);
              drawpaginas(HD,20,ly);
          }
          text("Lista:",20+ix,ly-5);
          drawarray(al,20+ix,ly);
          fill(255);
          text("Abortados:",20+ix,ly-5);
          drawarray(ab,20+ix,ly);
          fill(255);
          text("Completos:",20+ix,ly-5);
          drawarray(completos,20+ix,ly);
          atualpaginas();
          drawbotoes();
      try {
         Thread.sleep(90);
      } catch(InterruptedException e) {
              print("got interrupted!");
      }
      hs1.update();
      hs1.display();
      
}
class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw + sh;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
      timestep = (newspos-110)/1000;
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > iy+ypos && mouseY < iy+ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, iy+ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, iy+ypos, sheight, sheight);
  }
}  
