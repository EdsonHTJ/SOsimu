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
    void actionPerformed( ActionEvent event ) {
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
  void Pausar(){
    while(first_in){
      try {
      Thread.sleep(90);
      }catch(InterruptedException e) {
      }
    }
  }
}
