import os

from template import templated_file
from urlparse import urlparse

def get_options(url):
    return {
        'proxy_host': url.hostname,
        'proxy_port': url.port,
    }

def main():
    http_proxy = os.environ.get('HTTP_PROXY', '')

    if http_proxy:
        profile_path = os.environ.get('USERPROFILE')
        svn_servers_path = os.path.join(profile_path, 'AppData', 'Roaming', 'Subversion', 'servers')

        options = get_options(urlparse(http_proxy))

        templated_file('servers.tmpl', svn_servers_path, options)

if __name__ == "__main__": main()
