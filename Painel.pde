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
  private JLabel i_cores,i_quantum,i_qtde_pi,i_tammem;
  private JTextField t_cores,t_quantum,t_qtde_pi,t_tammem;
  private JCheckBox bestfit,merge;
  private JButton confirmar,cancelar;
  private Container mainContainer = this.getContentPane();
  private JPanel painelVariaveis = new JPanel();
  private JPanel painelAlgoritimos = new JPanel();
  private int qtde_cores = getCores();
  private float valor_quantum = getQuantumMAX();
  private int modemem = getModeMem();
  private int qtde_pi = getPI();
  private int tammem = getTamMem();
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
    
    i_tammem = new JLabel("Tamanho da Memória");
    painelVariaveis.add(i_tammem);
    t_tammem = new JTextField(""+tammem);
    t_tammem.setEditable(first_in);
    painelVariaveis.add(t_tammem);
    
    JLabel espaco = new JLabel();
    painelAlgoritimos.add(espaco);
    
    bestfit = new JCheckBox("Best Fit");
    bestfit.setEnabled(first_in);
    painelAlgoritimos.add(bestfit);
    merge = new JCheckBox("Merge");
    merge.setEnabled(first_in);
    painelAlgoritimos.add(merge);
    confirmar = new JButton("Confirmar");
    confirmar.setEnabled(first_in);
    painelAlgoritimos.add(confirmar);
    cancelar = new JButton("Cancelar");
    painelAlgoritimos.add(cancelar);
    
    mainContainer.add(painelVariaveis, BorderLayout.WEST);
    mainContainer.add(painelAlgoritimos, BorderLayout.EAST);
    
    //Adicionando os configuradores para os checkbox
    CheckBoxHandler handler = new CheckBoxHandler();
    bestfit.addActionListener(handler);
    merge.addActionListener(handler);
    confirmar.addActionListener(handler);
    cancelar.addActionListener(handler);
    //Inicializando Dados
    switch(modemem){
      case 0:
        bestfit.setSelected(true);
        break;
      case 1:
        merge.setSelected(true);
        break;
      default:
      break;
    }
    this.first_in = first_in;
  }
  
  class CheckBoxHandler implements ActionListener{
    void actionPerformed( ActionEvent event ) {
        if(event.getSource() == bestfit) {
          merge.setSelected(false);
          modemem = 0;
        }
        else if(event.getSource() == merge) {
          bestfit.setSelected(false);
          modemem = 1;
        }
      if(event.getSource() == confirmar) {
        setCores(Integer.parseInt(t_cores.getText()));
        setQuantumMAX(Float.parseFloat(t_quantum.getText()));
        setPI(Integer.parseInt(t_qtde_pi.getText()));
        setTamMem(Integer.parseInt(t_tammem.getText()));
        setModeMem(modemem);
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
