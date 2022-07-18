import json
import xml.etree.ElementTree as ET
from glob import glob
from pathlib import Path

from bcolors import bcolors

"""
This will generate a fake package.json next to any package.xml
"""

PACKAGES_DIRECTORY = "packages"
package_xmls = glob(str(Path.cwd() / f"{PACKAGES_DIRECTORY}/**/package.xml"))

if __name__ == "__main__":
    print(
        bcolors.OKBLUE + f"Generate package.json files: {len(package_xmls)} total" + bcolors.ENDC
    )
    for package_xml_path in package_xmls:
        package_xml = ET.parse(package_xml_path)
        root = package_xml.getroot()
        package_name = root.find("name").text  # type: ignore
        package_json = {"name": package_name, "version": "0.0.0", "license": "UNLICENSED"}
        package_json_path = str(Path(package_xml_path).parent / "package.json")

        print(bcolors.OKCYAN + f"Writing {package_json_path}" + bcolors.ENDC)
        f = open(package_json_path, "w")
        f.write(json.dumps(package_json, indent="    "))
        f.close()

    print(bcolors.OKGREEN + "Complete" + bcolors.ENDC)
