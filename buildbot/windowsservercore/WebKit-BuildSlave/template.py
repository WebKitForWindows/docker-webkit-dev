import os
from string import Template

def get_options():
    return {
        # buildbot.tac
        'master': os.environ.get('BUILD_MASTER_NAME', 'build.webkit.org'),
        'port': os.environ.get('BUILD_MASTER_PORT', '17000'),
        'slave': os.environ.get('BUILD_SLAVE_NAME'),
        'password': os.environ.get('BUILD_SLAVE_PASSWORD'),
        # info/admin
        'name': os.environ.get('ADMIN_NAME'),
        'email': os.environ.get('ADMIN_EMAIL'),
        # info/host
        'description': os.environ.get('HOST_DESCRIPTION'),
    }

def process_file(file, options):
    input = open(file)

    src = Template(input.read())

    result = src.substitute(options)

    output = open(file[:-5], 'w')

    output.write(result)

def main():
    options = get_options()

    process_file('buildbot.tac.tmpl', options)
    process_file('info/admin.tmpl', options)
    process_file('info/host.tmpl', options)

if __name__ == "__main__": main()
