import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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
import java.awt.BorderLayout; 
import java.awt.GridLayout; 
import java.awt.event.ActionListener; 
import java.awt.event.ActionEvent; 
import java.awt.Container; 
import javax.swing.JPanel; 
import javax.swing.JLabel; 
import javax.swing.JOptionPane; 
import javax.swing.JFrame; 
import javax.swing.JTextField; 
import javax.swing.JCheckBox; 
import javax.swing.BorderFactory; 
import javax.swing.JButton; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SO2 extends PApplet {







  




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
public int getCores(){
  return cores;
}
public float getQuantumMAX(){
  return quantumMAX;
}
public int getMode(){
  return mode;
}
public int getPI(){
  return N;
}
public void setCores(int qtde_cores){
   cores = qtde_cores;
}
public void setQuantumMAX(float valor_quantum){
  quantumMAX = valor_quantum;
}
public void setMode(int mode){
  this.mode = mode;
}
public void setPI(int N){
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
public void addprocess(){
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
public void addprocesslp(){
       process p=new process();
       numMax++;
       p.num=numMax;
       p.time=Math.random()*16+4;
       p.time_max=p.time;
       p.prioridade=(int)(Math.random()*4-0.00001f);
       if(Math.random()*4<1){
        p.estado="Espera";
        naoaptos.add(p);
       }else{
        p.estado="Pronto"; 
        ((Vector)(lp.get((p.prioridade)))).add(p);
       }
}
public void insertprocess(){
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
public void drawprocess(float x,float y,process p){
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
public void drawarray(Vector v,float ix,float iy){
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
public void drawarrayCPU(Vector v,float ix,float iy){
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
public void drawLP(){
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
public void atualizarcpu(){
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
              (((core)(cpu.get(i))).p).time=(((core)(cpu.get(i))).p).time-0.1f;
              ((core)(cpu.get(i))).quantum=((core)(cpu.get(i))).quantum-0.1f;
       }
}
public void atualizarcpusjf(){
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
                       (((core)cpu.get(i)).p).time=(((core)cpu.get(i)).p).time-0.1f;
              }
     }
}
public void atualizarcpulp(){
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
              (((core)(cpu.get(i))).p).time=(((core)(cpu.get(i))).p).time-0.1f;
              ((core)(cpu.get(i))).quantum=((core)(cpu.get(i))).quantum-0.1f;
       }
}
public void CriarCpus(){
     for(int i=0;i<cores;i++){
           core emptycpu = new core();
           emptycpu.p = new process();
           emptycpu.is_empty=true;

             cpu.add(emptycpu);
     }
}
public void CriarLista(){
    for(int i=0;i<4;i++){
         Vector a=new Vector();
         lp.add(a);
    }
}
public void BotaoConfiguracao(){
      Painel panel = new Painel(false);
      panel.setVisible(true);
      panel.pack();
}
public void drawbotoes(){
      fill(255);
      stroke(0);
      rect(20,height-70,80,20);
      rect(130,height-70,50,20);
      fill(0);
      text("Add Process",23,height-55);
      text("Config",133,height-55);
}
public void autalizarnaoaptos(){
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
public void mouseClicked(){
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
public void mouseWheel(MouseEvent event) {
  int e = event.getCount();
  if((iy-50)<100){
  iy = iy-50*e;
  }else{
      iy=iy-50;
  }
  
}
public void setup() {
       Painel painelInicial = new Painel(true);
       painelInicial.setVisible(true);
       painelInicial.pack();
       painelInicial.Pausar();
       
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
public void draw() {
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














class Painel extends JFrame {
  private JLabel i_cores,i_quantum,i_qtde_pi;
  private JTextField t_cores,t_quantum,t_qtde_pi;
  private JCheckBox sjf,r_r,p_r_r;
  private JButton confirmar,cancelar;
  private Container mainContainer = this.getContentPane();
  private JPanel painelVariaveis = new JPanel();
  private JPanel painelAlgoritimos = new JPanel();
  private int qtde_cores = getCores();
  private float valor_quantum = getQuantumMAX();
  private int mode = getMode();
  private int qtde_pi = getPI();
  private boolean first_in;
  
  Painel(boolean first_in) {
    super("Configurações");  
    mainContainer.setLayout( new BorderLayout(50,50) );
    painelVariaveis.setLayout(new GridLayout(6,1,10,15));
    painelVariaveis.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
    painelAlgoritimos.setLayout(new GridLayout(6,1,10,15));
    painelAlgoritimos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
    //Adicionando as Labels, Caixas de Texto e CheckBoxes
    
    i_cores = new JLabel("Quantidade de cores da CPU");
    
    painelVariaveis.add(i_cores);    
    t_cores = new JTextField(""+qtde_cores);
    
    painelVariaveis.add(t_cores);
    t_cores.setEditable(first_in);
    
    i_quantum = new JLabel("Valor do Quantum");
    painelVariaveis.add(i_quantum);
    
    t_quantum = new JTextField(""+valor_quantum);
    t_quantum.setEditable(first_in);
    
    painelVariaveis.add(t_quantum);
    
    i_qtde_pi = new JLabel("Quantidade de processos iniciais");
    painelVariaveis.add(i_qtde_pi);
    t_qtde_pi = new JTextField(""+qtde_pi);
    t_qtde_pi.setEditable(first_in);
    painelVariaveis.add(t_qtde_pi);
    JLabel espaco = new JLabel();
    painelAlgoritimos.add(espaco);
    sjf = new JCheckBox("Shortest Job First");
    sjf.setEnabled(first_in);
    painelAlgoritimos.add(sjf);
    r_r = new JCheckBox("Round-Robin");
    r_r.setEnabled(first_in);
    painelAlgoritimos.add(r_r);
    p_r_r = new JCheckBox("Round-Robin com Prioridade");
    p_r_r.setEnabled(first_in);
    painelAlgoritimos.add(p_r_r);
    confirmar = new JButton("Confirmar");
    confirmar.setEnabled(first_in);
    painelAlgoritimos.add(confirmar);
    cancelar = new JButton("Cancelar");
    painelAlgoritimos.add(cancelar);
    
    mainContainer.add(painelVariaveis, BorderLayout.WEST);
    mainContainer.add(painelAlgoritimos, BorderLayout.EAST);
    
    //Adicionando os configuradores para os checkbox
    CheckBoxHandler handler = new CheckBoxHandler();
    sjf.addActionListener(handler);
    r_r.addActionListener(handler);
    p_r_r.addActionListener(handler);
    confirmar.addActionListener(handler);
    cancelar.addActionListener(handler);
    //Inicializando Dados
    switch(mode){
      case 0:
        sjf.setSelected(true);
        break;
      case 1:
        r_r.setSelected(true);
        break;
      case 2:
        p_r_r.setSelected(true);
        break;
      default:
      break;
    }
    this.first_in = first_in;
  }
  
  class CheckBoxHandler implements ActionListener{
    public void actionPerformed( ActionEvent event ) {
        if(event.getSource() == sjf) {
          r_r.setSelected(false);
          p_r_r.setSelected(false);
          mode = 0;
        }
        else if(event.getSource() == r_r) {
          sjf.setSelected(false);
          p_r_r.setSelected(false);
          mode = 1;
        }
        else if(event.getSource() == p_r_r) {
          sjf.setSelected(false);
          r_r.setSelected(false);
          mode = 2;
        }
      if(event.getSource() == confirmar) {
        setCores(Integer.parseInt(t_cores.getText()));
        setQuantumMAX(Float.parseFloat(t_quantum.getText()));
        setPI(Integer.parseInt(t_qtde_pi.getText()));
        setMode(mode);
        setVisible(false);
        first_in = false;
      }
      else if(event.getSource() == cancelar) {
        setVisible(false);
      }
    }
  }
  public void Pausar(){
    while(first_in){
      try {
      Thread.sleep(90);
      }catch(InterruptedException e) {
      }
    }
  }
}
  public void settings() {  size(1280,700); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SO2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
