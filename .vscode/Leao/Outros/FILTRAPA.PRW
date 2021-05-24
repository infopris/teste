#include "rwmake.ch" 
User Function FILTRAPA()

setPrvt("cret")

// Programa  ... FILTRAPA  | Autor ... DANTE PUCCIA NETO  | Data ... 09/08/01
// Descrição ... EXECBLOC PARA FILTAR NO SC6 APENAS PRODUTOS ACABADOS
// Uso       ... Espelhos Leão                                             
    
If Funname() <> "MATA650" .or.Funname() == "MATA220"
   If Funname() == "MATA405" .or.Funname() == "MATA410" .or. Funname() == "MATA415"
      cret :=  B1_TIPO == "PA"
   Else
      cret := B1_TIPO <> "PA"   
   Endif                        
Endif

Return(cret)        // incluido pelo assistente de conversao do AP5 IDE em 25/10/00

