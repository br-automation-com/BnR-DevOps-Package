from IntegrationTestBase import *

class TestAlarm(object):

    def reset_alarms(self, opcua_setup):
        for i in range(0, 100):
            write_variable(opcua_setup, f'::AlarmMgr:Alarms[{i}]', False)
        time.sleep(1)

    @pytest.fixture(scope="class")
    def setup_class(self, visu_setup, opcua_setup):
        # Wait for init page
        wait_for_init_page(visu_setup)
        self.reset_alarms(opcua_setup)

    @pytest.fixture(autouse=True)
    def setup_and_teardown(self, visu_setup, opcua_setup):
        # Go to alarm page
        wait_and_click_element(visu_setup, f"Navigation_content_LoadAlarmContent", sleep_after=0.5)
        wait_and_click_element(visu_setup, f"AlarmXCurrent_content_PushBtnAcknowledgeAllAlarms", sleep_after=0.5)
        yield
        wait_and_click_element(visu_setup, f"Navigation_content_HelpContent", sleep_after=0.5)
        for i in range(0, 99):
            write_variable(opcua_setup, f'::AlarmMgr:Alarms[{i}]', False)
        time.sleep(0.5)

    @pytest.mark.parametrize("alarm_index,expected_text", [(0, 'Alarm 0'), (1, 'Alarm 1'), (2, 'Alarm 2')])
    # TEST FUNCTION ======================================================================================================
    def  test_alarm(self,  visu_setup, opcua_setup, alarm_index, expected_text):

        # attempt to edit recipe
        write_variable(opcua_setup, f'::AlarmMgr:Alarms[{alarm_index}]', True)

        # Passive wait 1 seconds
        time.sleep(0.5)
        # Check the button is displayed - OK - correct element name
        alarm_row = get_table_row(visu_setup, 'AlarmXCurrent_content_AlarmListCurrentAlarms', 'AlarmXCurrent_content_AlarmListItemAlarmMessage', expected_text)

        assert expected_text in alarm_row, \
            f'Alarm {alarm_index} did not occur'
