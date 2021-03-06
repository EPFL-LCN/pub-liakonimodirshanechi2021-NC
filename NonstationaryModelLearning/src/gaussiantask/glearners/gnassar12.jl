using Distributions, SpecialFunctions, Roots, LinearAlgebra
# import SpecialFunctions: lbeta
"""
GNas12: Modified algorithm of Nassar et al., Nat Neuro, 2012 for Gaussian prior
            for the Gaussian task (section 2.3.1)
"""
struct GNas12 <: GLearner
    χ_0::Float64
    ν_0::Float64
    mu_0::Float64
    sigma_0::Float64 # std of observations
    sigma::Float64 # std of observations
    changeprobability::Float64
    m::Float64
    ρ::Float64
    χ_n::Array{Float64, 1}
    ν_n::Array{Float64, 1}
    r_n::Array{Float64, 1}
    var_n::Array{Float64, 1}
    mu_n::Array{Float64, 1} #parameter we are interested in
    Sgm_n::Array{Float64, 1} # Bayes Factor Surprise
    γ_n::Array{Float64, 1}
    Ssh_n::Array{Float64, 1} # Shannon Surprise
    Py_0_n::Array{Float64, 1}
end
function GNas12(; mu_0 = 0., sigma_0 = 1., sigma = 0.1, changeprobability = .001)
    ρ = sigma^2 / sigma_0^2
    m = changeprobability/ (1. - changeprobability)
    ν_0 = calcν(sigma, sigma_0)
    χ_0 = calcχ(mu_0, ν_0, sigma)
    var_n_0 = sigma^2 / ν_0
    mu_n_0 = sigma * χ_0 / ν_0
    GNas12(χ_0, ν_0, mu_0, sigma_0, sigma, changeprobability, m, ρ, [χ_0], [ν_0],
                [1.], [var_n_0], [mu_n_0], [1.], [m/(1. + m)], [1.], [1.])
end
export GNas12
function update!(learnerG::Union{GNas12, GNas12original}, y)
    calcSgm!(learnerG, y)
    calcγ!(learnerG) # Ω = learnerG.m * learnerG.Sgm_n[1]/(1. + learnerG.m * learnerG.Sgm_n[1])
    calcShannon!(learnerG, y)
    Δrule_mu_n = learnerG.mu_n[1] + (y - learnerG.mu_n[1])/(learnerG.ρ + learnerG.r_n[1] + 1.)
    Δrule_mu_0 = learnerG.mu_0 + (y - learnerG.mu_0)/(learnerG.ρ + 1.)
    computemu_n!(learnerG, Δrule_mu_n, Δrule_mu_0)
    computevar_n!(learnerG, Δrule_mu_n, Δrule_mu_0)
    computer_n!(learnerG)
    transformto_χ_ν!(learnerG)
    # learnerG.Sgm_n[1] = copy(Sgm)
end
export update!
function computevar_n!(learnerG::Union{GNas12, GNas12original},
                    Δrule_mu_n, Δrule_mu_0)
    α = (learnerG.ρ + learnerG.γ_n[1]*learnerG.r_n[1] + 1.) / (learnerG.ρ + learnerG.r_n[1] + 1.)
    learnerG.var_n[1] = learnerG.sigma^2 * α / (learnerG.ρ + 1.)
    learnerG.var_n[1] += (1. - learnerG.γ_n[1]) * learnerG.γ_n[1] * (Δrule_mu_n - Δrule_mu_0)^2
end
function computer_n!(learnerG::Union{GNas12, GNas12original})
    learnerG.r_n[1] = learnerG.sigma^2/learnerG.var_n[1] - learnerG.sigma^2/learnerG.sigma_0^2
end
