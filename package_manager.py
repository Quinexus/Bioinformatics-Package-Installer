import os
import subprocess
import shutil

def install_package(metadata):
    repo_url = metadata['repo']
    build_cmd = metadata.get('build', 'make')
    install_cmd = metadata.get('install', 'make install PREFIX=/usr/local')
    dependencies = metadata.get('dependencies', [])

    # Check dependencies
    for dep in dependencies:
        if shutil.which(dep) is None:
            raise Exception(f"Dependency {dep} is missing.")

    # Clone the repository
    repo_dir = f"/tmp/{metadata['name']}"
    subprocess.run(["git", "clone", repo_url, repo_dir], check=True)

    # Build and install
    os.chdir(repo_dir)
    subprocess.run(build_cmd.split(), check=True)
    subprocess.run(install_cmd.split(), check=True)

    print(f"Package {metadata['name']} installed successfully.")