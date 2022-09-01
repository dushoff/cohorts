---
title: Cohort scribbles
author: Cohort consortium
date: in progress
header-includes:
   - \usepackage[margin=1in]{geometry}
---

\newcommand{\Lamtot}{\ensuremath{Λ_\mathrm{tot}}}
\newcommand{\Ro}{\ensuremath{{\mathcal R}_{0}}}

## Continuous-time SIR

We have an initial cohort of infectees $I_0$, a recovery rate $V$, and a force of infection $F$. These are all scalars. $I_0$ is conventionally set to 1 and ignored. We are keeping it here because it might be a vector later.

The cohort of remaining infectees at age of infection $τ$ is given by

$$ I(τ) = I_0 \exp (-Vτ). $$

The generated force of infection is

$$ Λ(τ) = F I_0 \exp(-Vτ) dτ. $$

and the total is:

$$ \Lamtot = F I_0 / V $$

The reproductive number \Ro\ is

$$ \Lamtot/I_0 = F/V $$

and the renewal kernel is 

$$ k(\tau) = Λ(τ)/(\Ro I_0) = V \exp(-Vτ) $$
