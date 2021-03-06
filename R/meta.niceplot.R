#' Nice meta-analysis plots.
#'
#' This function displays meta-analysis results of relative abundance as a nice combined heatmap and forest plot. More flexibility/options for plot will be added.
#' @param metadat output data from metatab.show.
#' @param sumtype Either "taxa" for taxa and "path" for pathway.
#' @param level "main" for main level such as phylum or "sub" for higher level such as species. Default is "main".
#' @param p name of variable for p-values
#' @param p.adjust name of variable for multiple testing adjusted p-values
#' @param phyla.col type of color for main level (phylum). Options are "rainbow" (default) or "select".
#' @param phyla.select selected phyla for selected colors (only when phyla.col="select"). Default are c("actinobacteria","bacteroidetes","cyanobacteria","firmicutes","fusobacteria","proteobacteria","verrucomicrobia",".thermi.").
#' @param col.select selected colors for selected phyla (only when phyla.col="select"). Corresponding default are c("#dd1c77","#31a354","#91003f","#d95f0e","#636363","#2ef0e7","#862ef0","#000").
#' @param est.break breaks for estimates to generate color categories on heatmap. Default are c(-Inf, -1,-0.5,-0.1,0,0.1,0.5,1, Inf). For pathway, recommended breaks are c(-Inf, -0.5,-0.1,-0.05,0,0.05,0.1,0.5, Inf).
#' @param est.break.label labels for corresponding color categories on heatmap generated by est.break. Default corresponding to default est.break are c("<-1","[-1,-0.5)","[-0.5,-0.1)","[-0.1,0)", "[0,0.1)", "[01,0.5)", "[0.5,1)", ">=1"). For pathway, corresponding recommended labels are c("<-0.5)", "[-0.5,-0.1)","[-0.1,-0.05)","[-0.05,0)","[0,0.05)","[0.05,0.1)", "[0.1,0.5)", ">=0.5").
#' @param neg.palette color palette for negative estimate values. Default is "PuBu". Use display.brewer.all() of RColorBrewer package for other options.
#' @param pos.palette color palette for positive estimate values. Default is "YlOrRd". Use display.brewer.all() of RColorBrewer package for other options.
#' @param p.sig.heat whether or not show significant p values on heatmap. Default is "yes".
#' @param p.break breaks for significant levels of p values. Default is c(0, 0.0001,0.05, 1).
#' @param p.break.label labels to be showed on heatmap for different levels of p-values from p.break. Default is c("**", "*","") for p breaks at c(0, 0.0001,0.05, 1).
#' @param p.pool.break breaks for pooled p-values to be distinguished in forest plot. Default are c(0,0.05,1).
#' @param p.pool.break.label labels for pooled p-value breaks. Corresponding default are c("[0,0.05)","[0.05,1]").
#' @param padjust.pool.break breaks for multiple testing adjusted p-values to be distinguished in forest plot. Default are c(0,0.1,1).
#' @param padjust.pool.break.label labels for  multiple testing adjusted p-value breaks. Corresponding default are c("[0,0.1)","[0.1,1]").
#' @param forest.est.shape point shape of pooled estimates in forest plot. Default are c("17","16") for corresponding significant and non-significant pooled estimates.
#' @param forest.est.col colors of point (pooled estimates) and 95 CI bars in forest plot. Default are c("red", "black") for significant and non-significant estimates.
#' @param forest.col Color of forest plot (point estimates and 95 CI). Options are "by.pvalue" (distinguished by signficant vs. non-significant p-value) or "by.estimate" (color scaled similarly to heatmap color).
#' @param heat.forest.width.ratio ratio of width between heatmap and forest plot to be used in grid.arrange. Dedault is c(1,1).
#' @param point.ratio ratio of point size between significant pooled estimate and non-significant pooled estimate. Default is c(3,1).
#' @param line.ratio ratio of error bar line size between significant pooled estimate and non-significant pooled estimate. Default is=c(2,1).
#' @param leg.key.size legdend key size for heatmap.
#' @param leg.text.size legend text size for heatmap.
#' @param heat.text.x.size heatmap x label text size.
#' @param heat.text.x.angle heatmap x label text angle.
#' @param forest.axis.text.y forest plot y label text size.
#' @param forest.axis.text.x forest plot x label text size.
#' @return combined heatmap forest plot.
#' @keywords meta-analysis heatmap forest plot.
#' @export
#' @examples
#' #Load saved results of four studies for the comparison of bacterial taxa relative abundance between genders adjusted for breastfeeding and infant age at sample collection
#' data(taxacom.rm.sex.adjustbfage)
#' data(taxacom.ha.sex.adjustbfage)
#' data(taxacom6.zi.usbmk.sex.adjustbfage)
#' data(taxacom6.unc.sex.adjustedbfage)
#' taxacom6.zi.rm.sex.adjustbfage$study<-"Subramanian et al 2014 (Bangladesh)"
#' taxacom6.zi.rm.sex.adjustbfage$pop<-"Bangladesh"
#' taxacom.zi.ha.sex.adjustbfage$study<-"Bender et al 2016 (Haiti)"
#' taxacom.zi.ha.sex.adjustbfage$pop<-"Haiti"
#' taxacom6.zi.usbmk.sex.adjustbfage$study<-"Pannaraj et al 2017 (USA(CA_FL))"
#' taxacom6.zi.usbmk.sex.adjustbfage$pop<-"USA(CA_FL)"
#' taxacom6.zi.unc.sex.adjustedbfage$study<-"Thompson et al 2015 (USA(NC))"
#' taxacom6.zi.unc.sex.adjustedbfage$pop<-"USA(NC)"
#' tabsex4<-plyr::rbind.fill(taxacom6.zi.rm.sex.adjustbfage,taxacom.zi.ha.sex.adjustbfage,taxacom6.zi.usbmk.sex.adjustbfage,taxacom6.zi.unc.sex.adjustedbfage)
#' #Meta-analysis (take time to run)
#' metab.sex<-meta.taxa(taxcomdat=tabsex4,summary.measure="RR",pool.var="id",studylab="study",backtransform=FALSE,percent.meta=0.5,p.adjust.method="fdr")
#' #nice plot phylum level
#' metadat<-metatab.show(metatab=metab.sex$random,com.pooled.tab=tabsex4,tax.lev="l2",showvar="genderMale",p.cutoff.type="p", p.cutoff=1,display="data")
#' meta.niceplot(metadat=metadat,sumtype="taxa",level="main",p="p",p.adjust="p.adjust",phyla.col="rainbow",leg.key.size=1,leg.text.size=8,heat.text.x.size=7,heat.text.x.angle=0,forest.axis.text.y=8,forest.axis.text.x=7)
#' #nice plot family level
#' metadat<-metatab.show(metatab=metab.sex$random,com.pooled.tab=tabsex4,tax.lev="l5",showvar="genderMale",p.cutoff.type="p", p.cutoff=1,display="data")
#' meta.niceplot(metadat=metadat,sumtype="taxa",level="sub",p="p",p.adjust="p.adjust",phyla.col="rainbow",leg.key.size=1,leg.text.size=8,heat.text.x.size=7,forest.axis.text.y=8,forest.axis.text.x=7)


meta.niceplot<-function(metadat,sumtype="taxa",level="main",p,p.adjust,phyla.col=c("rainbow","select"),
                        phyla.select=c("actinobacteria","bacteroidetes","cyanobacteria","firmicutes","fusobacteria","proteobacteria","verrucomicrobia",".thermi."),
                        col.select=c("#dd1c77","#31a354","#91003f","#d95f0e","#636363","#2ef0e7","#862ef0","#000"),
                        est.break=c(-Inf, -1,-0.5,-0.1,0,0.1,0.5,1, Inf), est.break.label=c("<-1", "[-1,-0.5)","[-0.5,-0.1)","[-0.1,0)", "[0,0.1)", "[0.1,0.5)", "[0.5,1)", ">=1"),
                        neg.palette="PuBu", pos.palette="YlOrRd",
                        p.sig.heat="no",p.break=c(0,0.0001,0.05,1),p.break.label=c("**","*",""),
                        p.pool.break=c(0,0.05,1), p.pool.break.label=c("[0,0.05)","[0.05,1]"),
                        padjust.pool.break=c(0,0.1,1), padjust.pool.break.label=c("[0,0.1)","[0.1,1]"),
                        forest.est.shape=c("17","16"), forest.est.col=c("red", "black"),forest.col=c("by.pvalue","by.estimate"),
                        leg.key.size=1,leg.text.size=8,heat.text.x.size=8,heat.text.x.angle=0,forest.axis.text.y=8,forest.axis.text.x=8,
                        heat.forest.width.ratio = c(1,1),point.ratio=c(3,1),line.ratio=c(2,1)){
  #require(ggplot2);require(gridExtra);require("gplots");require(reshape2); require(gdata); require(RColorBrewer)
  #heatmap
  test<-metadat$taxsig.all
  test$taxa<-test$id
  test$taxa<-gsub("k__bacteria.p__","",test$taxa)
  #assign color to estimates
  test$esticat<-cut(test$estimate, breaks=est.break,
                      labels=est.break.label)
  test$esticol<-plyr::mapvalues(test$esticat,from=est.break.label,
                            to=c(rev(RColorBrewer::brewer.pal(((length(est.break)-1)/2)+1, neg.palette)[-1]),RColorBrewer::brewer.pal(((length(est.break)-1)/2)+1, pos.palette)[-1]))
  test$esticat<-gdata::drop.levels(test$esticat, reorder=FALSE)
  test$esticol<-gdata::drop.levels(test$esticol, reorder=FALSE)
  poplev<-levels(factor(test$pop))
  test$pop[is.na(test$pop)]<-"Pooled"
  test$pop<-factor(test$pop,levels=c(poplev[poplev!="Pooled"],"Pooled"))
  if (sumtype=="taxa"){
    if (level=="main"){
      test<-test[order(test$taxa,decreasing = FALSE),]
      test$taxas<-factor(test$taxa,levels=unique(test$taxa))
      test$plotvar<-test$taxas
    }
    if (level=="sub"){
      test$taxas<-sub(".c__.*f__", " ",as.character(test$taxa))
      test<-test[order(test$taxa,decreasing = FALSE),]
      test$taxas<-factor(test$taxas,levels=unique(test$taxas))
      test$taxa<-factor(test$taxa,levels=unique(test$taxa))
      test$plotvar<-test$taxas
    }
  }
  if (sumtype=="path"){
    test<-test[order(test$taxa,decreasing = FALSE),]
    test$taxas<-factor(test$taxa,levels=unique(test$taxa))
    test$plotvar<-test$taxas
  }
  test$study[is.na(test$study)]<-"Meta_analysis"
  if (p.sig.heat=="yes"){
    test$pdot<-cut(test$p, breaks=p.break,labels=p.break.label,include.lowest = TRUE)
  }
  if (p.sig.heat=="no"){
    test$pdot<-""
  }
  nstudy<-length(unique(test$study[!is.na(test$study)]))
  my.lines<-data.frame(x=(nstudy-0.5), y=0.5, xend=(nstudy-0.5), yend=(length(unique(test$taxa))+0.5))
  h<-ggplot2::ggplot(test, ggplot2::aes(pop, plotvar)) +
    ggplot2::geom_tile(ggplot2::aes(fill=esticat)) +
    ggplot2::geom_text(ggplot2::aes(label = pdot)) +
    ggplot2::scale_fill_manual(breaks=levels(test$esticat),
                      values = levels(test$esticol),
                      labels = levels(test$esticat),
                      name = "log(OR)")+
    #ggplot2::scale_y_discrete(limits = rev(levels(test$taxas)))+
    ggplot2::geom_segment(data=my.lines, ggplot2::aes(x,y,xend=xend, yend=yend), size=2, inherit.aes=F)+
    ggplot2::ylab("") +ggplot2::xlab("")+
    ggplot2::theme(legend.title = ggplot2::element_text(size = 12,face="bold"),
          legend.text = ggplot2::element_text(size = leg.text.size,face="bold"),
          plot.title = ggplot2::element_text(size=16),
          axis.title=ggplot2::element_text(size=14,face="bold"),
          legend.position="left",
          plot.background = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_blank(),
          panel.background = ggplot2::element_blank(),
          panel.border = ggplot2::element_blank(),
          axis.ticks.y = ggplot2::element_blank(),
          axis.text.y = ggplot2::element_blank(),
          axis.title.x = ggplot2::element_blank(),
          axis.title.y = ggplot2::element_blank(),
          axis.text.x =ggplot2::element_text(size=heat.text.x.size, angle=heat.text.x.angle, hjust = 1,colour="black",face="bold"),
          legend.key.size = ggplot2::unit(leg.key.size, "cm"))+
    ggplot2::guides(fill=ggplot2::guide_legend(ncol=1))
  #forest plot
  testf<-metadat$taxsig
  testf$taxa<-testf$id
  testf$taxa<-gsub("k__bacteria.p__","",testf$taxa)
  testf<-testf[testf$taxa %in% unique(test$taxa),]
  testf$taxa<-gdata::drop.levels(testf$taxa, reorder=FALSE)
  if (sumtype=="taxa"){
    if (level=="main"){
      testf$taxa2<-paste0(toupper(substr(as.character(testf$taxa), 1, 1)), substr(as.character(testf$taxa), 2, nchar(as.character(testf$taxa))))
      testf<-testf[order(testf$taxa,decreasing = FALSE),]
      testf$taxa2<-factor(testf$taxa2,unique(testf$taxa2))
      testf$taxa<-factor(testf$taxa,unique(testf$taxa))
      if (phyla.col=="select"){
        testf$colp<-plyr::mapvalues(testf$taxa,from=phyla.select,
                              to=col.select)
        testf$colp<-as.character(testf$colp)
      }
      if (phyla.col=="rainbow"){
        testf$colp<-plyr::mapvalues(testf$taxa,from=levels(testf$taxa),to=rainbow(nlevels(testf$taxa)))
        testf$colp<-as.character(testf$colp)
      }
      testf$plotvar<-testf$taxa2
    }
    if (level=="sub"){
      testf$taxas1<-sub(".c__.*f__", " ",as.character(testf$taxa))
      testf$taxas2<-sub(".*f__", "",as.character(testf$taxa))
      testf$taxas2<-paste0(toupper(substr(as.character(testf$taxas2), 1, 1)), substr(as.character(testf$taxas2), 2, nchar(as.character(testf$taxas2))))
      #replace empty truncated names by original names
      oname<-as.character(testf$taxa[testf$taxas2 %in% c("",".g__")])
      testf$taxas2[testf$taxas2 %in% c("",".g__")]<-paste0(toupper(substr(as.character(oname), 1, 1)), substr(as.character(oname), 2, nchar(as.character(oname))))
      testf<-testf[order(testf$taxa,decreasing = FALSE),]
      testf$taxas<-factor(testf$taxas2,levels=testf$taxas2)
      testf$phylum<-sub(".c__.*", "",as.character(testf$taxa))
      testf$phylum<-as.factor(testf$phylum)
      if (phyla.col=="select"){
        testf$colp<-plyr::mapvalues(testf$phylum,from=phyla.select,
                              to=col.select)
        testf$colp<-as.character(testf$colp)
      }
      if (phyla.col=="rainbow"){
        testf$colp<-plyr::mapvalues(testf$phylum,from=levels(testf$phylum),to=rainbow(nlevels(testf$phylum)))
        testf$colp<-as.character(testf$colp)
      }
      testf$plotvar<-testf$taxas
    }
  }
  if (sumtype=="path"){
    testf<-testf[order(testf$taxa,decreasing = FALSE),]
    testf$taxas<-factor(testf$taxa,levels=testf$taxa)
    testf$colp=1
    testf$plotvar<-testf$taxas
  }
  testf$pcut<-testf[,p]
  testf$p.adjustcut<-testf[,p.adjust]
  testf$psig<-cut(testf$pcut, breaks=p.pool.break,labels=p.pool.break.label ,include.lowest = TRUE, right = FALSE)
  testf$psigsize<-mapvalues(testf$psig,from=p.pool.break.label, to=point.ratio)
  testf$psigsize2<-mapvalues(testf$psig,from=p.pool.break.label, to=line.ratio)
  testf$psigcol<-plyr::mapvalues(testf$psig,from=p.pool.break.label,to=forest.est.col)
  testf$psigcol<-gdata::drop.levels(testf$psigcol,reorder=FALSE)
  testf$padjustsig<-cut(testf$p.adjustcut, breaks=padjust.pool.break,labels=padjust.pool.break.label,include.lowest = TRUE, right = FALSE)
  testf$estimate<-as.numeric(as.character(testf$estimate))
  testf$padjustsign<-plyr::mapvalues(testf$padjustsig,from=padjust.pool.break.label,to=forest.est.shape)
  testf$padjustsize<-plyr::mapvalues(testf$padjustsig,from=padjust.pool.break.label,to=point.ratio)
  #assign color to estimates
  testf$esticat<-cut(testf$estimate, breaks=est.break,
                       labels=est.break.label)
  testf$esticol<-mapvalues(testf$esticat,from=est.break.label,
                             to=c(rev(RColorBrewer::brewer.pal(((length(est.break)-1)/2)+1, neg.palette)[-1]),RColorBrewer::brewer.pal(((length(est.break)-1)/2)+1, pos.palette)[-1]))
  testf$esticat<-drop.levels(testf$esticat, reorder=FALSE)
  testf$esticol<-drop.levels(testf$esticol, reorder=FALSE)
  # dirty truncate large estimate, LL and UL for better plot view
  testf[,c("estimate","ll","ul")]<-apply(testf[,c("estimate","ll","ul")],2,function(x){x[x>=5]=5;x[x<=-5]=-5;x})
  if (forest.col=="by.pvalue"){
    f<-ggplot2::ggplot(data=testf,ggplot2::aes(x=estimate,y=plotvar,colour=psigcol))+
      ggplot2::geom_point(shape=as.numeric(as.character(testf$padjustsign)),size=as.numeric(as.character(testf$padjustsize)))+
      ggplot2::scale_y_discrete(position = "right")+ #,limits = rev(levels(testf$taxa2))
      ggplot2::geom_errorbarh(ggplot2::aes(xmin=ll,xmax=ul,colour=psigcol),height=0.0,size=1)+
      ggplot2::geom_vline(xintercept=0,linetype="dashed")+
      ggplot2::scale_colour_manual(breaks=testf$psigcol,values = levels(testf$psigcol))+
      ggplot2::theme(legend.position="none",
                     plot.background = ggplot2::element_blank(),
                     panel.background = ggplot2::element_blank(),
                     axis.ticks.y= ggplot2::element_blank(),
                     axis.title = ggplot2::element_blank(),
                     axis.text.y =ggplot2::element_text(size=forest.axis.text.y, colour = testf$colp,face="bold"),
                     axis.text.x =ggplot2::element_text(size=forest.axis.text.x,colour="black",face="bold"))
  }
  if (forest.col=="by.estimate"){
    f<-ggplot2::ggplot(data=testf,aes(x=estimate,y=plotvar,colour=esticol))+
      ggplot2::geom_point(shape=as.numeric(as.character(testf$padjustsign)),size=as.numeric(as.character(testf$psigsize)))+
      ggplot2::scale_y_discrete(position = "right")+ #,limits = rev(levels(testf$taxa2))
      ggplot2::geom_errorbarh(aes(xmin=ll,xmax=ul,colour=esticol),height=0.0, size=as.numeric(as.character(testf$psigsize2)))+
      ggplot2::geom_vline(xintercept=0,linetype="dashed")+
      ggplot2::scale_colour_manual(breaks=testf$esticol,values = levels(testf$esticol))+
      ggplot2::theme(legend.position="none",
                     plot.background = ggplot2::element_blank(),
                     panel.background = ggplot2::element_blank(),
                     axis.ticks.y= ggplot2::element_blank(),
                     axis.title = ggplot2::element_blank(),
                     axis.text.y =ggplot2::element_text(size=forest.axis.text.y, colour = testf$colp,face="bold"),
                     axis.text.x =ggplot2::element_text(size=forest.axis.text.x,colour="black",face="bold"))
  }
  return(gridExtra::grid.arrange(h,f,nrow=1,widths = heat.forest.width.ratio))
}
