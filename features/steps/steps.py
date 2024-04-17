#!/usr/bin/env python3
"""
Main file where the python code is located for execution via behave.
"""

from behave import step  # pylint: disable=no-name-in-module

from qecore.common_steps import *


@step("Custom step template")
def custom_step_template(context) -> None:
    """
    Custom step template.

    :param context: Holds contextual information during the running of tests.
    :type context: <behave.runner.Context>
    """

    # Create step here.

    # The qecore pulls the root in environment.
    # You can load it on your own but it reduces complexity and improves cleanup.
    # context.gtg is the qecore.TestSandbox.Application object, you do not need this.
    # context.gtg.instance is the root for Atspi object in session.
    # Query a child in the root with name and roleName
    context.gtg.instance.child(
        name="", roleName="push button", description="Create a new task"
    ).click()
    # For more queries look at https://modehnal.github.io/#the-main-queries-you-will-be-using
