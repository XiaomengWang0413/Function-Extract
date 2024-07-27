#!/usr/bin/perl
use  strict;
use  warnings;

#  设置输入和输出文件
my  $gff_file  =  'prokka_output.gff';  #  Prokka生成的GFF文件
my  $output_file  =  'extracted_annotations.txt';  #  提取注释信息的输出文件

#  打开GFF文件和输出文件
open(my  $gff_fh,  '<',  $gff_file)  or  die  "无法打开文件  $gff_file:  $!";
open(my  $out_fh,  '>',  $output_file)  or  die  "无法创建文件  $output_file:  $!";

#  输出文件的标题行
print  $out_fh  "Gene  ID\tGene  Name\tProduct\tCOG\n";

#  读取GFF文件并提取信息
while  (my  $line  =  <$gff_fh>)  {
      #  跳过注释行
      next  if  $line  =~  /^#/;
     
      #  按Tab分割行
      my  @columns  =  split  /\t/,  $line;
     
      #  检查是否为CDS特征
      next  unless  $columns[2]  eq  'CDS';
     
      #  提取基因ID
      my  $gene_id  =  $columns[8];
      $gene_id  =~  s/ID=([^;]+);.*/\$1/;
     
      #  提取基因名称和产物名称
      my  $gene_name  =  '';
      my  $product  =  '';
      if  ($columns[8]  =~  /Name=([^;]+)/)  {
          $gene_name  =  \$1;
      }
      if  ($columns[8]  =~  /product=([^;]+)/)  {
          $product  =  \$1;
      }
     
      #  提取COG
      my  $cog  =  '';
      if  ($columns[8]  =~  /COG=([^;]+)/)  {
          $cog  =  \$1;
      }
     
      #  输出提取的注释信息
      print  $out_fh  "$gene_id\t$gene_name\t$product\t$cog\n";
}

#  关闭文件句柄
close($gff_fh);
close($out_fh);
