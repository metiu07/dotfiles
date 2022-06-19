#!/usr/bin/env python3
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
import stat
import subprocess
import sys
from typing import Dict, List, Optional

# TODO: Add Ctrl-C handler
# TODO: Rename to dotfiles
# TODO: Create symlink to ~/.local/bin/dotfiles
# TODO: After instalation append the list of installed modules
# TODO: Add update flag -u and reinstall currently installed modules
# TODO: Make compat with older python just in case?


class Installer:
    """Class managing the instalation process"""

    def __init__(self, args):

        self.verbose = args.verbose
        self.vprint('Parsed args "{}"'.format(args))

        self.install_mode = False if args.remove else True
        self.backup_ext = ".bak"
        self.install_cmd = ["mv"] if args.move else ["ln", "-sf"]
        self.remove_cmd = ["rm"]
        self.auto_confirm = args.auto_confirm

        # Parse the json
        self.confs = self.load_configuration(args.input)
        # print(self.confs)

        if args.list_modules:
            # TODO: Better output
            for k, v in self.confs.items():
                print(k, v)
            return

        # Initialize dry run if wanted
        self.dry_run = args.dry

        # Avoid dependency cycles
        self.processed_modules = []
        self.action = self.install if self.install_mode else self.remove_conf

        # Ask user to uninstall modules
        if not self.install_mode:
            print('Would remove "{}" modules.'.format(" ".join(args.modules)))
            if not self.confirm(
                "Do you want to proceed?", default=False, auto_confirm=True
            ):
                sys.exit("Aborting... Don't uninstall modules.")

        # Install configurations
        self.run(args.modules)

        if not self.dry_run and self.processed_modules:
            print("Enjoy your new configuration :)")

    def load_configuration(self, input_file: str) -> Dict[str, str]:
        """Load the json configuration.

        If an error occurs during the parsing, abort the instalation.
        """

        try:
            with open(os.path.expanduser(input_file)) as f:
                raw_json_data = f.read()
            return json.loads(raw_json_data)
        except json.decoder.JSONDecodeError as err:
            sys.exit(
                'Input file "{}" can not be parsed.\n{}'.format(input_file, str(err))
            )
        except FileNotFoundError:
            sys.exit('Configuration file "{}" not found.'.format(input_file))

    def run(self, modules: List[str]):
        """Process each module and {un, re}install configuration files."""

        for m in modules:

            self.vprint("Processing module: {}".format(m))

            if m not in self.confs:
                sys.exit('Aborting... can not find the configuration "{}"'.format(m))

            # "m" configuration from input file
            c = self.confs[m]
            # self.vprint('Processing configuration: {}'.format(str(self.confs[m])))

            if m in self.processed_modules:
                # Skip already processed modules
                self.vprint('Skipping... already processed module "{}"'.format(m))
                continue

            if {"source", "destination"} <= set(c):
                self.backup(c)
                self.action(c)
                self.processed_modules.append(m)

            if "$deps" in c:
                self.vprint("Resolving dependencies")
                self.processed_modules.append(m)
                self.run(c["$deps"])

            if self.install_mode and "install" in c:
                install_script = c["install"]
                if os.path.exists(install_script):
                    print(
                        'Target "{}" wants to run script "{}"'.format(m, install_script)
                    )
                    if self.confirm("Do you want to view the file?", default=False):
                        self.exec_command(["less", install_script])
                    if not self.confirm('Install "{}"?'.format(m)):
                        sys.exit(
                            'Aborting... Install script for "{}" @ "{}" was not allowed to run.'.format(
                                m, c["install"]
                            )
                        )
                    self.exec_command([c["install"]])
                else:
                    sys.exit(
                        'Aborting... Install script for "{}" @ "{}" does not exist.'.format(
                            m, c["install"]
                        )
                    )

    def backup(self, module):
        """If file is present and not symlink, create its backup."""

        dest = self.prepare_path(module["destination"])
        if os.path.exists(dest) and not os.path.islink(dest):
            # Copy the file with backup extension
            self.exec_command(["mv", dest, dest + self.backup_ext])

    def install(self, module):
        """Install the file with specified command."""

        # Create directories if they don't exists already
        dest = self.prepare_path(module["destination"])
        src = self.prepare_path(module["source"])
        os.makedirs(os.path.dirname(dest), exist_ok=True)

        self.exec_command(
            self.install_cmd
            + [
                src,
                dest,
            ]
        )

        if module["exec"]:
            orig_mode = os.stat(dest).st_mode
            os.chmod(dest, mode=orig_mode | stat.S_IEXEC)

    def remove_conf(self, module):
        """Remove the configuration file.

        Warning: This may permanently destroy your configuration.
        """

        self.exec_command(self.remove_cmd + [module["destination"]])

    def exec_command(
        self, c: List[str], check=True, **kwargs
    ) -> subprocess.CompletedProcess:
        """Execute the commnad, in case of dry run just print it to user."""

        if self.dry_run:
            print(" ".join(c))
            # Maybe there is a better way to return empty program
            return subprocess.run(["true"])
        else:
            try:
                return subprocess.run(c, check=check, **kwargs)
            except subprocess.CalledProcessError as err:
                sys.exit('Aborting... Command failed "{}"'.format(err))

    def prepare_path(self, p: str) -> str:
        """Prepare path expanding user and getting absolute path."""

        return os.path.abspath(os.path.expanduser(p))

    def vprint(self, s: str):
        """If verbose output is active, print message."""

        if self.verbose:
            print(s)

    def confirm(
        self, s: str, default: bool = True, auto_confirm: Optional[bool] = None
    ) -> bool:
        """Ask user for confirmation."""

        if self.auto_confirm:
            return auto_confirm or default

        prompt = "{} {} ".format(s, "[Y/n]" if default else "[y/N]")
        while True:
            ans = input(prompt)
            if ans == "":
                return default
            elif ans.lower() in ["y"]:
                return True
            elif ans.lower() in ["n"]:
                return False

            print("Please answer [y, n]")


def parse_arguments():
    """Setup and parse the program arguments."""

    parser = argparse.ArgumentParser(
        description="Dotfiles installer program to symlink config files for user"
    )  # noqa
    parser.add_argument("modules", nargs="*", default=["linux"])
    parser.add_argument(
        "-r", "--remove", action="store_true", help="uninstall selected modules"
    )
    parser.add_argument(
        "-d",
        "--dry",
        action="store_true",
        help="dry run, only print commnads don't execute",
    )
    parser.add_argument(
        "-m",
        "--move",
        action="store_true",
        help="install by moving instead of creating symlinks",
    )
    parser.add_argument(
        "-l",
        "--list-modules",
        action="store_true",
        help="list all modules in INPUT file",
    )
    parser.add_argument(
        "-a", "--auto-confirm", action="store_true", help="skip all user confirmations"
    )
    parser.add_argument(
        "-i",
        "--input",
        action="store",
        default="./configuration.json",
        help="set the input file (default: ./configuration.json)",
    )  # noqa
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="verbose output"
    )  # noqa
    return parser.parse_args()


if __name__ == "__main__":
    Installer(parse_arguments())
