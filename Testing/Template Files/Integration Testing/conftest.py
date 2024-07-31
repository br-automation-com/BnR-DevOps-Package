from typing import Dict
import pytest
from pytest import StashKey, CollectReport
import allure
from allure_commons.types import AttachmentType

phase_report_key = StashKey[Dict[str, CollectReport]]()
@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    rep = outcome.get_result()
    setattr(item, "rep_" + rep.when, rep)
    return rep

def reorder_early_fixtures(metafunc):
    """
    Put fixtures with `pytest.mark.late` last during execution
    This allows patch of configurations before the application is initialized
    """
    for fixturedef in metafunc._arg2fixturedefs.values():
        fixturedef = fixturedef[0]
        for mark in getattr(fixturedef.func, 'pytestmark', []):
            if mark.name == 'late':
                order = metafunc.fixturenames
                order.append(order.pop(order.index(fixturedef.argname)))
                break

def pytest_generate_tests(metafunc):
    reorder_early_fixtures(metafunc)

# mark it late because the teardowns run in the opposite order of setup, so this will run before any other teardowns
@pytest.fixture(autouse=True)
@pytest.mark.late
def screenshot_on_failure(request, visu_setup):
    yield
    node = request.node
    if node.rep_call.failed:
        allure.attach(visu_setup.get_screenshot_as_png(), name=node.name, attachment_type=AttachmentType.PNG)