---
title: SW Notes
author: \Large SW
date: ...
header-includes:
   - \usepackage[margin=0.9in]{geometry}
   - \usepackage{color}
   - \usepackage{lineno}
---

\renewcommand{\thelinenumber}{\color{cyan}\arabic{linenumber}}
\large
\linenumbers

# SW Notes

These are notes on deriving the next-gen-mat framework from the macpan framework. There are likely many notational issues and possibly actual errors.

The macpan and next-gen-mat frameworks both use the symbol $F$, but they mean different things. Because the next-gen framework is older I will not use $F$ to mean the flow matrix, which is what it means in macpan.

## Macpan

Here is the macpan model [(link)](https://canmod.github.io/macpan-book/index.html#generalized-model-at-a-glance).
$$
s_{i,t+1} = s_{i,t} + \underbrace{\sum_j M_{ji,t} s_{j,t}}_{\text{inflow}} - \underbrace{s_{i,t} \sum_j  M_{ij,t} {\mathcal I}_{ij}}_{\text{outflow}}
$$
where,

* $s_{i,t}$ is the state of the $i$th compartment at time $t$
* $M_{ij,t}$ is the per-capita rate of flow from compartment $i$ to compartment $j$ at time $t$
* ${\mathcal I}_{ij}\in\{0,1\}$ indicates whether or not individuals should be removed from compartment $i$ after flowing to compartment $j$

## Macpan in Continuous Time

For now I'm going to (1) pretend that macpan is in continuous time, (2) not allow time-varying parameters, and (3) drop the outflow indicator.

$$
\frac{ds_i}{dt} = \underbrace{\sum_j M_{ji} s_{j}}_{\text{inflow}} - \underbrace{s_{i} \sum_j  M_{ij} }_{\text{outflow}}
$$

Define the inflow and outflow vectors.

$$
f_i^{\text{in}} = \sum_j M_{ji} s_{j}
$$

and 

$$
f_i^{\text{out}} = s_{i} \sum_j  M_{ij}
$$

## Next-Gen Connections

I found it tempting to use the inflow and outflow vectors as the connection to next-gen-mat stuff. In particular, the subset of the inflow vector for infected classes looks like the F-side in next-gen theory and the outflow looks like V-side. The problem with this logic is that we must move all components of the inflow vector that do not correspond to processes of infection from the F-side to the V-side.

For example, the inflow vector might include symptom progression from a mild infection to a more severe one. This is certainly not an F-side process because it doesn't generate new infections.

To deal with this issue in our notation we define vectors that are similar to the inflow and outflow vectors, but relate to infection and non-infection.

$$
f_i^{\text{infection}} = \sum_{j\in \Omega} M_{ji} s_{j}
$$

and 

$$
f_i^{\text{other}} = s_{i} \sum_j  M_{ij} - \sum_{j\notin \Omega} M_{ji} s_{j}
$$

where $\Omega$ is the set of indexes of all compartments that are neither infected nor exposed.

These definitions allow us to express the dynamics of the infected/exposed classes in the following way.

$$
\frac{ds_i}{dt} = f_i^{\text{infection}} - f_i^{\text{other}}
$$

such that $i \notin \Omega$.

Also with these definitions, we can identify the elements of two key matrices from the next-gen framework by computing the following derivatives at a disease-free equilibrium.

$$
F_{ik} = \frac{df_i^{\text{infection}}}{ds_k}
$$

$$
V_{ik} = \frac{df_i^{\text{other}}}{ds_k}
$$

such that $i,k \notin \Omega$. With these definitions I think that $\mathcal{R}_0$ is the spectral radius of $FV^{-1}$.

## Relating F and V to M

We can express the elements of $F$ and $V$ in terms of the rate matrix, $M$ and state vector, $s$, by using the product rule.

$$
F_{ik} = 
\sum_{j\in\Omega} s_{j}\frac{dM_{ji}}{ds_k}   +
\sum_{j\in\Omega} M_{ji} \frac{ds_{j}}{ds_k} 
$$

We can simplify $V_{ik}$ by using a delta-thingy, $\delta_{ik} = 1$ when $i=k$ and zero otherwise.

$$
F_{ik} = 
\sum_{j\in\Omega} s_{j} \frac{dM_{ji}}{ds_k} + 
\sum_{j\in\Omega} M_{ji} \delta_{jk}
$$

This allow us to further simplify.

$$
F_{ik} = 
\sum_{j\in\Omega} s_{j} \frac{dM_{ji}}{ds_k} + 
\sum_{k\in\Omega} M_{ki}
$$

The second term must be zero, because $k$ cannot be in $\Omega$.

$$
F_{ik} = 
\sum_{j\in\Omega} s_{j} \frac{dM_{ji}}{ds_k}
$$

Turning to the V-side we have the following.

$$
V_{ik} = 
s_{i} \sum_j  \frac{dM_{ij}}{ds_k} +
\delta_{ik} \sum_j  M_{ij} - 
\sum_{j\notin\Omega} s_{j}\frac{dM_{ji}}{ds_k}   -
\sum_{j\notin\Omega} M_{ji} \delta_{jk}
$$

Evaluating the second delta thingy gives the following.

$$
V_{ik} = 
s_{i} \sum_j  \frac{dM_{ij}}{ds_k} +
\delta_{ik} \sum_j  M_{ij} - 
\sum_{j\notin\Omega} s_{j}\frac{dM_{ji}}{ds_k}   -
M_{ki}
$$

## Per-Capita Rate Tensor

Note that we have a key tensor, which we call $\mathcal{T}$.

$$
\mathcal{T}_{ijk} = \frac{dM_{ij}}{ds_k}
$$

We can now write $F_{ik}$ and $V_{ik}$ in terms of this tensor.

$$
F_{ik} = \sum_{j\in\Omega} \mathcal{T}_{jik} s_j
$$

and

$$
V_{ik} = 
\left[
    \delta_{ik} \sum_j  M_{ij}
    - M_{ki}
\right]
+ 
\left[
    s_{i} \sum_j  \mathcal{T}_{ijk}
    - \sum_{j\notin\Omega} s_{j}\mathcal{T}_{jik}
\right]
$$

The $F$ matrix is related to processes of infection and $V$ to other processes.

## Interpreting the Per-Capita Rate Tensor

The tensor, $\mathcal{T}_{ijk}$, measures the sensitivity of the per-capita $s_i$ to $s_j$ transition rate, to changes in $s_k$.

An important example of this sensitivity is when $s_i$, $s_j$, and $s_k$ are susceptible, exposed, and infectious classes respectively. In this case, $\mathcal{T}_{ijk}$ measures the sensitivity of a force of infection component to changes in one of the infectious classes.

The F-matrix is an affine function of the state vector, $s$, with the per-capita rate tensor as the 'slope'. This linear equation takes vectors in the space of non-infected states to a space of matrices describing how sensitive the force of infection of one infected state is to changes in another infected state. Every component of the tensor that gets summed can be interpreted as the derivative of a force of infection.

The V-matrix is a more complex function of $s$ with four components.

* $\delta_{ik} \sum_j  M_{ij}$
    * This is the per-capita rate of flow out of the $i$th infected compartment into all other compartments in the model
    * It is only applied along the diagonal of $V$
* $M_{ki}$
    * This is the per-captia rate of flow into the $i$th infected compartment from the $k$th infected compartment
    * ... FIXME -- this list is complex and incomplete -- not sure how useful it is

\newpage

## Interpretation

$\mathcal{R}_0$ is the spectral radius of $FV^{-1}$, where F and V are square matrices with rows and columns representing infected individuals and elements given by the following.

$$
F_{ik} = 
\underbrace{\sum_{j\in\Omega} \mathcal{T}_{jik} s_j}_{
    \text{infection (non-linear)}
}
$$

and

$$
\begin{array}{rl}
  V_{ik} = & \underbrace{\delta_{ik} \sum_{j\in\Omega} M_{ij}}_{
    \text{recovery (linear)}
  } \\
  & \underbrace{+ \sum_{j\in\Omega} \mathcal{T}_{ijk} s_{i}}_{
    \text{recovery (non-linear)}
  } \\
& \underbrace{+ \delta_{ik} \sum_{j\notin\Omega}  M_{ij} - M_{ki}}_{
    \text{progression/behaviour (linear)}
} \\
& \underbrace{+ \sum_{j\notin\Omega} \left(
    \mathcal{T}_{ijk} s_{i}
   - \mathcal{T}_{jik} s_{j}
   \right)}_{
    \text{progression/behaviour (non-linear)}
} \\
\end{array}
$$

Where $\mathcal{T}_{ijk} = \frac{dM_{ij}}{ds_k}$, evaluated at a disease-free equilibrium, $\delta_{ik} = 1$ if $i = k$ and zero otherwise, and $\Omega$ is the set of all indices associated with non-infected states. Throughout this section, $i$ and $k$ index  infected compartments and $j$ indexes any compartment -- whether $j$ is infected or not is indicated by its relation to the set of non-infected compartments, $\Omega$.

Why is there no such thing as linear infection? Intuitively it is because infection involves a contact between an individual inside $\Omega$ (non-infected) with one outside of $\Omega$ (infected). Recall that the linear and non-linear contributions to $F$ are as follows.

$$
F_{ik} = 
\underbrace{\sum_{j\in\Omega} s_{j}\frac{dM_{ji}}{ds_k}}_{\text{non-linear}}   +
\underbrace{\sum_{j\in\Omega} M_{ji} \frac{ds_{j}}{ds_k}}_{\text{linear}}
$$

Here $s_j$ is not infected and $s_k$ is infected. The linear term contains the derivative of one with respect to the other. This derivative is either zero if the two states are different (which they must be) or one if the two states are the same (which they cannot be). Therefore, the $F$ matrix cannot have a linear component and infection is an inherently non-linear process.

\newpage

## SIR

For the SIR model we have three states, S, I, and R, which become $s_1, s_2, s_3$ respectively in our formalism.  The per-capita rate matrix for this model is given by the following.

$$
M = \begin{bmatrix}
0 & \beta I & 0 \\
0 & 0 & \gamma \\
0 & 0 & 0 \\
\end{bmatrix}
= \begin{bmatrix}
0 & \beta s_2 & 0 \\
0 & 0 & \gamma \\
0 & 0 & 0 \\
\end{bmatrix}
$$

In this case $F$ and $V$ are 1-by-1 matrices because $\Omega = \{1, 3\}$, and so 2 is the only index associated with an infected state. The derivative of $M$ is a 3-by-3-by-3 per-capita rate tensor with almost all zeros, except for one element, $\mathcal{T}_{122} = \beta$. This element is the derivative of $M_{12} = \beta s_2$ with respect to $s_2$

For this model we only have non-linear infection and linear recovery.

$$
F_{22} = \sum_{j\in\Omega} \mathcal{T}_{jik} s_j = \mathcal{T}_{122} s_1 = \beta s_1
$$

$$
V_{22} = \delta_{ik} \sum_{j\in\Omega} M_{ij} = M_{23} = \gamma
$$

At a disease-free equilibrium of $s_1 = 1$, $s_2 = s_3 = 0$, we have $F_{22} = \beta$ and $V_{22} = \gamma$, which leads to $\mathcal{R}_0 = \beta/\gamma$ as expected.


\newpage

## Disease-Free Equilibrium

Until this point we have assumed that we can find a disease-free equilibrium, but this is not trivial.

At equilibrium the inflows equal the outflows
$$
\underbrace{\sum_j M_{ji} s_{j}}_{\text{inflow}} = \underbrace{s_{i} \sum_j  M_{ij} }_{\text{outflow}}
$$

Rearranging we see that at equilibrium each element of the state vector is a weighted sum of the others with weights given by the weight matrix.
$$
s_{i} = \frac{\sum_j M_{ji} s_{j}}{\sum_j  M_{ij}}
$$

This equation looks vaguely like it could be solved as an eigenvector problem, but some elements of $M$ will depend on some elements of $s$. Nevertheless we could try an iterative power-method-like approach to solving this equation. The initial value of the state vector could be the following.

$$
s^0_i = \begin{array}{ll}
0, & i \notin\Omega' \\
1/|\Omega'|, & i\in\Omega' \\
\end{array}
$$

Where $\Omega'$ is a subset of $\Omega$ containing only individuals that have never been infected (i.e. pre-infected classes that are not recovered, not dead, and not infected). This initial value is a disease-free point, but it is unlikely to be a fixed point.

Finding a disease-free fixed point would be easier if states that are not in $\Omega'$ start at zero, stay at zero. The relevant sub-matrix of $M$ involves rows on $\Omega'$ and columns that are not on $\Omega'$. If we evaluate this sub-matrix at $s^0_i$ and get a matrix with all zeros, then we can simplify the update equation.

$$
s_{i} = \frac{
    \sum_{j\in\Omega'} M_{ji} s_{j}
}{
    \sum_{j\in\Omega'} M_{ij}
}
$$

Such that $i\in\Omega'$.

One might be tempted to try to automatically determine $\Omega'$ with graph theory, but such approaches would break down in some models (e.g. those with wanning immunity).

However, one thing that we could do automatically is to automatically differentiate the sub-matrix of $M$ that goes between pre-infected states, and if we get all zeros then we would know that the solution of the update equation is an eigenvector of the transpose of the matrix with elements given by the following equation.

$$
\frac{M_{ki}}{\sum_{j\in\Omega'} M_{ij}}
$$

This would be a situation where the pre-infected sub-model is linear. This is a reason to build up your model by starting with a pre-infected sub-model, because this would make it straightforward to compute the disease-free equilibrium.

## Operations on Model Space

Defining the different sets described above would seem difficult for a general and complex model. However, if we build up our model from component sub-models using operations on model space, the task should in principle become simpler.

For example, we could define an SEIR model in an abstract way with the following equation.

```
SEIR = S + EI + R
```

Here the `+` operator is defined on model space and is not the ordinary arithmetic plus. If we build our model like this in terms of the three component sub-models -- `S`, `EI`, and `R` -- we can recognize right away that these sub-models correspond to the pre-infected, infected, and post-infected sets. From this point, we can build up each component by multiplying by various structural sub-models (e.g. vaccination status, age, space).

```
SEIR * AGE = S * AGE + EI * AGE + R * AGE
```

In this way, we can easily identify the pre-infected sub-model as `S * AGE`, which could then easily be used to compute the disease-free equilibrium with the equations in the section above.

This process could get even better if we introduced specific kinds of plus operators that guaranteed that sub-models that come first will never flow to sub-models that come later in the sum, unless the starting values are not zero.

The key partitioning of the states includes the following subsets.

* pre-infected -- $\Omega'$
* infected -- $\not{\Omega}$
* post-infected -- $\Omega - \Omega'$


\newpage

## Block Matrix Approach

The rate matrix can be arranged in the following blocks.

$$
M = \begin{bmatrix}
M^{I,I} & M^{I,U} \\
M^{U,I} & M^{U,U} \\
\end{bmatrix}
$$

When the following definitions of the blocks.

* $M^{I,I}$ -- per-capita rates from each infected state to another
* $M^{I,U}$ -- per-capita rates from infected states to uninfected states
* $M^{U,I}$ -- per-capita rates from uninfected states to infected states
* $M^{U,U}$ -- per-capita rates from each uninfected state to another

We express the element in the $k$th row and $l$th column in the block in the $i$th block-row and $j$th block-column as $M_{i[k]j[l]}$. For example, the per-capita rate of transition from the third infected state to the second uninfected state is $M_{I[3]U[2]}$

Similarly we decompose the state vector in the following way.

$$
s = \begin{bmatrix}
s^I \\ s^U
\end{bmatrix}
$$

Similarly, the element in the $k$th element of the $i$th block of this block vector is $s_{i[k]}$.

With this notation we can reexpress the rates of transition from uninfected states to the $k$th infected state as the following.

$$
f^\text{infection}_k = \underbrace{
    \sum_l M_{U[l]I[k]}s_{U[l]}
}_{\text{inflow from U to I}}
$$

The rates out of the $k$th infectious class by mechanisms other than infection can be given by the following.

$$
f^\text{other}_k = 
\underbrace{s_{I[k]}\sum_l M_{I[k]I[l]}}_{\text{outflow from I to I}} + 
\underbrace{s_{I[k]}\sum_l M_{I[k]U[l]}}_{\text{outflow from I to U}}
- \underbrace{\sum_l M_{I[l]I[k]}s_{I[l]}}_{\text{inflow from I to I}}
$$

Alternative notation:

$$
f^\text{infection}_k = \underbrace{
    \sum_l M^{UI}_{lk}s^U_l
}_{\text{inflow from U to I}}
$$


$$
f^\text{other}_k = 
\underbrace{s^I_k\sum_l M^{II}_{kl}}_{\text{outflow from I to I}} + 
\underbrace{s^I_k\sum_l M^{IU}_{kl}}_{\text{outflow from I to U}} -
\underbrace{\sum_l M^{II}_{lk} s^I_l}_{\text{inflow from I to I}}
$$

With these definitions the dynamics of infected states can be expressed as.

$$
\frac{ds^I_k}{dt} = f_k^{\text{infection}} - f_k^{\text{other}}
$$


## Discussion with David E 2022-09-29

* Validation of the general idea that computing the disease free equilibrium will be much simpler than any endemic equilibrium in many cases
  * Sufficient conditions under which this is true -- I think these:
    * Infected classes that start at zero, stay at zero in disease-free cases (this could be violated with a environmental source of infection for example) -- we think that this is equivalent to simpler asserting that there exists at least one disease-free equilibrium
    * The elements of the sub-matrix of M that contains only susceptible compartments do not depend on the state of susceptible compartments -- i.e. linearity
    * This sub-matrix of M is not degenerate in a linear algebra sense (whatever the right word is here 'non-singular', 'full-rank', I don't know but I know it is well-known)
  * Sufficiency is more relevant to Steve than necessity, because I'm not trying to push the limits of knowledge in mathematical biology -- instead I just want a clear way to distinguish models for which R_0 is algorithmically easy to compute and those for which it is probably difficult -- we just want solid software given a simple but powerful framework based on standard well-understood theory
  * Examples where the sufficiency breaks down:
    * Environmental source of infection (e.g. contact with an infectious individual is not required for infection)
    * Two diseases such that you want the R_0 for a focal disease under an endemic equilibrium of another disease -- this case is hard because the focal-disease-free equilibrium is not likely to be linear given that the other disease will likely involve non-linear contact processes
* In general pay more attention to uniqueness and existence of disease free equilibria
  * SIR is a bad example because it does not have a unique DFE (e.g. vital dynamics, SIRS)
* In general give more examples that illustrate why the framework is useful


## Next Steps

* Work on the notation using David's suggestions (https://davidearn.github.io/math4mb/lectures/4mbl06_2019f.pdf, de_notes.md) and reading original references to be consistent with those
* Work on the interpretation of the V-matrix
* Convert to discrete time
