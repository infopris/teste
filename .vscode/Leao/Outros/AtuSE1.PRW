#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

User Function AtuSE1()

//¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
//¦¦+-----------------------------------------------------------------------+¦¦
//¦¦¦Programa  ¦  AtuSE1  ¦ Autor ¦   Heitor Sacomani         Data ¦ 09/08/01¦¦¦
//¦¦+----------+------------------------------------------------------------¦¦¦
//¦¦¦Descriçào ¦ Atualização dos Campos E1_Ocorren\E1_BcoCli                ¦¦¦
//¦¦+----------+------------------------------------------------------------¦¦¦
//¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
//¦¦+-----------------------------------------------------------------------+¦¦
//¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯


   Dbselectarea("SE1")
   Reclock("SE1",.F.)
   Replace E1_OCORREN With "01"
   Replace E1_BCO1 With SA1->A1_BCO1
   Replace E1_BCO2 With SA1->A1_BCO2
   Replace E1_BCO3 With SA1->A1_BCO3
   Replace E1_BCO4 With SA1->A1_BCO4
   Replace E1_BCO5 With SA1->A1_BCO5
   Msunlock()
          
   

Return(SA1->A1_NATUREZ)