# This will run poetry install alongside any pyproject.tomls

import subprocess
from glob import glob
from pathlib import Path

from bcolors import bcolors

if __name__ == "__main__":
    print(bcolors.OKBLUE + "Running poetry install..." + bcolors.ENDC)
    PACKAGES_DIRECTORY = "packages"
    pyproject_tomls = glob(str(Path.cwd() / f"{PACKAGES_DIRECTORY}/**/pyproject.toml"))
    pyproject_toml_dirs = [Path(item).parent for item in pyproject_tomls]

    for dir in pyproject_toml_dirs:
        print(bcolors.OKCYAN + f"Poetry install {str(dir)}..." + bcolors.ENDC)
        subprocess.call(f"cd {dir} && poetry install", shell=True)

    print(bcolors.OKGREEN + "Complete" + bcolors.ENDC)
