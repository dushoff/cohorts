---
title: "BMB's notes"
output: pdf_document
bibliography: cohorts.bib
---


Rough transcription of my scribbled notes: we want to compare methods/concepts for deriving $r$, $R_0$, $\bar G$, $\sigma^2_G$, etc., in both discrete and continuous time, for both compartmental and renewal-type models (recognizing that the latter is more general).

It is interesting (to me) that some metrics are easier to compute in one framework than the other.

In the compartmental framework, $r$ is the dominant eigenvalue/spectral radius of the Jacobian evaluated at the disease-free equilibrium, $R_0$ is the spectral radius of the next-generation matrix $FV^{-1}$ [@van_den_driessche_reproduction_2002]. Generation time? Generation interval distribution/moments?  @allen_basic_2008 gives the expression for $R_0$ in the discrete-time case ($F(1-T)^{-1}$).

In the renewal framework, if $K$ is the kernel, $R_0$ is $\sum K$ or $\int K$. The generation distribution is $K/R_0$. To get $r$ we need to solve the Euler-Lotka equation.

## questions

- can we get the GI distribution for discrete time by thinking about a weighted probability of leaving/re-deriving the $F(1-T)^{-1}$ expression, thinking about an infinite weighted sum?
- definition of DFE in complex cases and/or 'typical' starting conditions?
- ways of programmatically "marking" infected vs uninfected classes in a model so we can automatically derive what belongs in $F$/$V$/$T$?

## references
