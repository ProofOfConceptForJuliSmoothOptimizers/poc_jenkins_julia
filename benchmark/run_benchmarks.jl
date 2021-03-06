using Pkg
bmark_dir = @__DIR__
print(bmark_dir)
Pkg.activate(bmark_dir)
Pkg.develop(PackageSpec(url=joinpath(bmark_dir, ".."))) 
Pkg.instantiate()

using GitHub, JSON, PkgBenchmark

print("benchmarking commit:")
commit = benchmarkpkg("Krylov")  # current state of repository
print("benchmarking master: ")
master = benchmarkpkg("Krylov", "master")
print("judging: ")
judgement = judge(commit, master)
export_markdown("judgement.md", judgement)
export_markdown("master.md", master)
export_markdown("commit.md", commit)

gist_json = JSON.parse("""
    {
        "description": "A benchmark for Krylov repository",
        "public": true,
        "files": {
            "judgement.md": {
                "content": "$(escape_string(sprint(export_markdown, judgement)))"
            },
            "master.md": {
                "content": "$(escape_string(sprint(export_markdown, master)))"
            },
            "commit.md": {
                "content": "$(escape_string(sprint(export_markdown, commit)))"
            }
        }
    }""")
    
open("gist.json", "w") do f
    JSON.print(f, gist_json)
end