---
title: Cohort scribbles
author: Cohort consortium
date: in progress
header-includes:
   - \usepackage[margin=1in]{geometry}
---

\newcommand{\Lamtot}{\ensuremath{Λ_\mathrm{tot}}}
\newcommand{\Ro}{\ensuremath{{\mathcal R}_{0}}}
\newcommand{\inv}{^{-1}}

## Continuous-time SIR

We have an initial cohort of infectees $I_0$, a recovery rate $V$ (analogous to SIR $γ$), and a transmission factor $F$ (analogous to SIR $β$). These are all scalars. $I_0$ is conventionally set to 1 and ignored. We are keeping it here because it might be a vector later.

The cohort of remaining infectees at age of infection $τ$ is given by

$$ I(τ) = I_0 \exp (-Vτ). $$

The generated force of infection is

$$ Λ(τ) = F I_0 \exp(-Vτ). $$

and the next cohort is given by the integral:

$$ I' = F I_0 / V $$

The reproductive number \Ro\ is

$$ I'/I_0 = F/V $$

and the renewal kernel is 

$$ k(\tau) = Λ(τ)/(\Ro I_0) = V \exp(-Vτ) , $$

with moments 

$$k_n = Γ(n+1)/V^n.$$

In particular, the mean $mu_k=k_1 = 1/V$, and the squared CV $κ_k = k_2/k_1^2 - 1 = 1$.

## Continuous-time with compartments

The initial cohort of infectees $I_0$ is now an $i×1$ column vector, where $i$ is the number of initial-infection boxes.
To model flow through the $c$ infected compartments (containing individuals who can infect without infecting again), we multiply by a $c×i$ “expansion matrix” $X$, with 1s on the main diagonal and 0s elsewhere.

NB: We don't really need $X$ if we're willing to just put a lot of extra zeroes into $F$, which I guess is the more standard way to do it.

$V$ is now a $c×c$ open flow matrix, with outflows representing recovery. 

The cohort of infectees at age of infection $τ$ is now

$$ I(τ) = \exp (-Vτ) X I_0, $$

basically the same as above, but with the correct linear-algebra book-keeping.

The generated force of infection is based on a $i×c$ transmission matrix ($F$), describing how each of the infected compartments moves individuals into the initial-infection compartments, so

$$ Λ(τ) = F \exp (-Vτ) X I_0. $$

and the next-generation integral is:

$$ I' = F V\inv X I_0 = G I_0, $$

where $G = F V\inv X$ is an next-generation operator, and \Ro\ is the dominant eigenvalue, with associated eigenvector $I^*$.

## Taking stock

None of the above is new.

Does it give a good way to think about or calculate things? We can straightforwardly extend our formal calculation to the kernel when $i=1$, even if $c>1$, but I guess there's a sensible way to do it with right eigenvectors when $c>1$. Note that this would involve _defining_ the mean kernel in a non-obvious multi-compartment case. We could also explore the circumstances under which you _don't_ need to do that (e.g., if there are different tracks ($i>1$), but they are synchronized (the only difference is how the groups interact with each other, not the timing).

## Future

I expect whatever we do in continuous time to be translatable to discrete time. I was thinking of staying on this side until the concepts are ironed out, since it seems likely that the algebra is simpler. On the other hand, I could imagine switching to the discrete side if things get confusing in a way that makes us want to test ourselves with simple simulations (or with MacPan itself).
