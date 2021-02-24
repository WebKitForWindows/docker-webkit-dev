""" Generates templates for the buildbot worker configuration """

import os

from string import Template


def _get_options():
    return {
        # buildbot.tac
        'host': os.environ.get('BUILD_HOST_NAME'),
        'port': os.environ.get('BUILD_HOST_PORT', '17000'),
        'worker': os.environ.get('BUILD_WORKER_NAME'),
        'password': os.environ.get('BUILD_WORKER_PASSWORD'),
        # info/admin
        'name': os.environ.get('ADMIN_NAME'),
        'email': os.environ.get('ADMIN_EMAIL'),
        # info/host
        'description': os.environ.get('HOST_DESCRIPTION'),
    }


def _templated_file(input_file, output_file, options):
    input_file = open(input_file)
    output_file = open(output_file, 'w')

    template = Template(input_file.read())
    result = template.substitute(options)

    output_file.write(result)


def _process_file(file, options):
    output = file[:-5]

    _templated_file(file, output, options)


def main():
    """ Generate the templates """
    options = _get_options()

    _process_file('buildbot.tac.tmpl', options)
    _process_file('info/admin.tmpl', options)
    _process_file('info/host.tmpl', options)


if __name__ == "__main__":
    main()
