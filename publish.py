import requests
import time
import os

def getNewVersion(current_version):
    new_version = ""

    carry = 1
    for n in reversed(current_version.split(".")):
        new_n = (int(n) + carry) % 1000
        carry = (int(n) + carry) // 1000
        new_version = new_version + str(new_n) + "."

    # remove last '.'
    new_version = new_version[:-1]

    new_version = ".".join(reversed(new_version.split(".")))

    return new_version

def getLatestVersionFromNexus(library):
    uri = "https://nexus.cmd.navi-tech.in/service/rest/v1/search/assets?repository=maven-snapshots&group=com.navi.medici.test-library&name={library}&sort=version"
    uri = uri.format(library = library)
    response_data = requests.get(uri).json()['items']
    # print(len(response_data))
    response_data.sort(key = lambda x: time.mktime(time.strptime(x['lastModified'].split(".")[0], '%Y-%m-%dT%H:%M:%S')), reverse = True)
    latest_version = response_data[0]['maven2']['version']
    # print(latest_version)

    return latest_version.split("-")[0]

modified_modules = os.popen("git show --format="" --name-only | xargs dirname | awk -F'/' '{print $1}' | sort | uniq").read().splitlines()
print("total modified modules: ", len(modified_modules))
for module in modified_modules:
    library = module.split("/")[0]
    if library in ["dto-library", "ui-library", "database-library", "api-library", "gi-helper", "test-report-library", "common-library"]:
        print("publishing new module for: ", library)
        current_version = getLatestVersionFromNexus(library)
        print("current version is:\t", current_version)
        print("new version is:\t", getNewVersion(current_version))

# libraries = ["dto-library", "ui-library", "database-library", "api-library", "gi-helper", "test-report-library", "common-library"]

# for library in libraries:
#     print(library, getLatestVersionFromNexus(library))