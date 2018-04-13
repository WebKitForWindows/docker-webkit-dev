import os

from template import templated_file

def get_options():
    return {
        # buildbot.tac
        'master': os.environ.get('BUILD_MASTER_NAME', 'build.webkit.org'),
        'port': os.environ.get('BUILD_MASTER_PORT', '17000'),
        'slave': os.environ.get('BUILD_WORKER_NAME'),
        'password': os.environ.get('BUILD_WORKER_PASSWORD'),
        # info/admin
        'name': os.environ.get('ADMIN_NAME'),
        'email': os.environ.get('ADMIN_EMAIL'),
        # info/host
        'description': os.environ.get('HOST_DESCRIPTION'),
    }

def process_file(file, options):
    output = file[:-5]

    templated_file(file, output, options)

def main():
    options = get_options()

    process_file('buildbot.tac.tmpl', options)
    process_file('info/admin.tmpl', options)
    process_file('info/host.tmpl', options)

if __name__ == "__main__": main()
