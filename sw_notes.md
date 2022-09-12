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

## Next Steps

* Work on the notation
* Work on the interpretation of the V-matrix
* Convert to discrete time
