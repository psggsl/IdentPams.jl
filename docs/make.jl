using Documenter
using IdentPams

makedocs(
    sitename = "IdentPams",
    format = Documenter.HTML(),
    modules = [IdentPams]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
