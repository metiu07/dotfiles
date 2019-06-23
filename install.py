#!/usr/bin/env python3.7
# >= python3.5
#
# Author: Matej Kastak
# Start Date: 21.6.2019
#
# Description:
#      This script will install all specified modules to home directory and
#      create backups. This is the new(improved) version of old bash script.

import argparse
import json
import os
import sys
from typing import Dict, List


class Installer:
    """Class managing the instalation process"""

    def __init__(self, args):

        self.backup_ext = '.bak'
        self.install_cmd = 'mv' if args.move else 'ln -sf'
        self.remove_cmd = 'rm'
        self.verbose = args.verbose

        # Parse the json
        self.confs = self.load_configuration(args.input)
        # print(self.confs)

        if args.list_modules:
            # TODO: Better output
            for k, v in self.confs.items():
                print(k, v)

        # Initialize dry run if wanted
        # TODO: self.dry_run = args.dry
        self.dry_run: bool = True

        # Install them
        self.processed_modules = []
        self.action = self.install if not args.remove else self.remove_conf
        self.run(args.modules)

        if not self.dry_run and self.processed_modules:
            print('Enjoy your new configuration :)')

    def load_configuration(self, input_file: str) -> Dict[str, str]:
        """Load the json configuration.

        If an error occurs during the parsing, abort the instalation.
        """
        try:
            with open(os.path.expanduser(input_file)) as f:
                raw_json_data = f.read()
            return json.loads(raw_json_data)
        except json.decoder.JSONDecodeError:
            sys.exit('Input file "' + input_file + '" can not be parsed.')
        except FileNotFoundError:
            sys.exit('Configuration file "' + input_file + '" not found.')

    def run(self, modules: List[str]):
        """Process each module and {un, E}install configuration files."""

        for m in modules:

            self.vprint('Processing module: ' + m)

            if m not in self.confs:
                print('Aborting... can not find the configuration')

            # "m" configuration from input file
            c = self.confs[m]
            # self.vprint('Processing configuration: ' + str(self.confs[m]))

            if m in self.processed_modules:
                # Skip already processed modules
                print('Aborting... already processed module ' + m)
                continue

            if {'source', 'destination'} <= set(c):
                self.backup(c)
                self.action(c)
                self.processed_modules.append(m)

            if '$deps' in c:
                self.vprint('Resolving dependencies')
                self.processed_modules.append(m)
                self.run(c['$deps'])

    def backup(self, module):
        """If file is present and not symlink, create its backup."""

        dest = os.path.abspath(module['destination'])
        if os.path.exists(dest) and not os.path.islink(dest):
            # Copy the file with backup extension
            self.exec_command('cp {} {}'.format(dest, dest + self.backup_ext))

    def install(self, module):
        """Install the file with specified command."""

        self.exec_command('{} {} {}'.format(self.install_cmd,
                                            os.path.abspath(module['source']),
                                            module['destination']))

    def remove_conf(self, module):
        """Remove the configuration file.

        Warning: This may permanently destroy your configuration.
        """
        self.exec_command('{} {}'.format(self.remove_cmd,
                                         module['destination']))

    def exec_command(self, c) -> int:
        """Execute the commnad, in case of dry run just print it to user."""

        if self.dry_run:
            print(c)
            return 0
        else:
            return os.system(c)

    def vprint(self, s: str):
        """If verbose output is active, print message."""

        if self.verbose:
            print(s)


def parse_arguments():
    """Setup and parse the program arguments."""

    parser = argparse.ArgumentParser(
        description='Dotfiles installer program to symlink config files for user') # noqa
    parser.add_argument('modules', nargs='*')
    parser.add_argument('-r', '--remove', action='store_true',
                        help='uninstall selected modules')
    parser.add_argument('-d', '--dry', action='store_true',
                        help='dry run, only print commnads don\'t execute')
    parser.add_argument('-m', '--move', action='store_true',
                        help='install by moving instead of creating symlinks')
    parser.add_argument('-l', '--list_modules', action='store_true',
                        help='list all modules in INPUT file')
    parser.add_argument('-i', '--input', action='store',
                        default='./configuration.json',
                        help='set the input file (default: ./configuration.json)') # noqa
    parser.add_argument('-v', '--verbose', action='store_true', help='verbose output') # noqa
    return parser.parse_args()


if __name__ == '__main__':
    # print(parse_arguments())
    Installer(parse_arguments())
