"""
    prerequisites:
    instal Python 3.7+
    
    pip install pytest
    pip install selenium
    
    Edit your "NAME_SPACE" (Visu ID)
    
    For you to run the test - you also need to exchange IDs of the elemnets you want to click to match your project
    
    Run command: pytest test_sample.py
    
    Pytest - testing framework
        - https://docs.pytest.org/en/7.4.x/
        - short tutorial https://www.guru99.com/pytest-tutorial.html
    
    For testing HMI
    Selenium + Chromedriver (Specific location)
        - https://selenium-python.readthedocs.io/getting-started.html
        - as of 4.6 you no longer need to download the chromedriver, selenium automatically does this
"""

import time
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as ec
from selenium.common.exceptions import ElementClickInterceptedException, NoSuchElementException, StaleElementReferenceException
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager

import allure
from allure_commons.types import AttachmentType

from asyncua.sync import Client
from asyncua import ua


NAME_SPACE = "mappFrameworkVis"                                          # Visu ID
VISU_URL = r"http://127.0.0.1:81/index.html?visuId=" + NAME_SPACE        # Check if address is matching

@pytest.fixture(scope="class")
def visu_setup():
    #SetUp
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--log-level=3")

    browser = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=chrome_options)
    #browser = webdriver.Chrome(options=chrome_options)
    browser.get(VISU_URL)
    browser.maximize_window()
    browser.fullscreen_window()
    
    yield browser
    
    #Teardown
    browser.close()
    browser.quit()

@pytest.fixture()
def login(visu_setup, request):
    load_content(visu_setup, 'Navigation_content_LoadUserContent', 'UserX_content')
    # select username
    set_input(visu_setup, "UserList_content_LoginUser_liUser", request.param[0])
    # set password
    set_input(visu_setup, "UserList_content_LoginUser_liPassword", request.param[1])
    # login
    wait_and_click_element(visu_setup, f"UserList_content_LoginUser_liButton", sleep_before=0.5, sleep_after=0.5)

    yield
    #logout current user
    load_content(visu_setup, 'Navigation_content_LoadUserContent', 'UserX_content')
    wait_and_click_element(visu_setup, f"UserList_content_LogoutBtnUser")
    load_content(visu_setup, 'Navigation_content_HelpContent', 'Help_content')

@pytest.fixture(scope="class")
def opcua_setup():
    #Setup
    opcua_client = Client("opc.tcp://localhost:4840/")
    opcua_client.connect()
    
    yield opcua_client
    
    #Teardown
    opcua_client.disconnect()


""" Get an element
    :param: driver:         webdriver browser interface
    :param: selector_name:  any string describing the selector
    :param: select_by:      selection type (ID, XPATH, NAME, ...) (default ID)
    :param: select_event:   expected condition (default element_to_be_clickable)
    :param: default_time:   waiting time if the exception ElementClickInterceptedException appears
"""
def get_element(driver, selector_name, select_by=By.ID, select_event=ec.element_to_be_clickable, default_time=10):
    #wait for element + return it
    wait = WebDriverWait(driver, default_time)
    element = wait.until(select_event((select_by, selector_name)))
    return element


""" Waits for an element
    :param: driver:         webdriver browser interface
    :param: selector_name:  any string describing the selector
    :param: select_by:      selection type (ID, XPATH, NAME, ...) (default ID)
    :param: select_event:   expected condition (default element_to_be_clickable)
    :param: default_time:   waiting time if the exception ElementClickInterceptedException appears
"""
def wait_for_element(driver, selector_name, select_by=By.ID, select_event=ec.element_to_be_clickable, default_time=10) -> None:
    # Waits for an element
    wait = WebDriverWait(driver, default_time)
    wait.until(select_event((select_by, selector_name)), f"Element {selector_name} not found!")

""" Waits for an element and clicks on it
    :param: driver:         webdriver browser interface
    :param: selector_name:  any string describing the selector
    :param: select_by:      selection type (ID, XPATH, NAME, ...) (default ID)
    :param: select_event:   expected condition (default element_to_be_clickable)
    :param: default_time:   waiting time if the exception ElementClickInterceptedException appears
    :param: sleep_before:   waiting time before clicking
    :param: sleep_after:    waiting time after clicking
"""
def wait_and_click_element(driver, selector_name, select_by=By.ID, select_event=ec.element_to_be_clickable,
                           default_time=10, sleep_before: float = 0, sleep_after: float = 0) -> None:

    elem = get_element(driver, selector_name, select_by, select_event, default_time)
    # Sleep before clicking [s]
    if sleep_before > 0:
        time.sleep(sleep_before)
    t_start = time.time()
    while not (elem.is_displayed() and elem.is_enabled()):
        if time.time() - t_start > default_time:
            raise
        time.sleep(0.5)

    # Clicking element
    t_start = time.time()
    while True:
        try:
            elem.click()
        except ElementClickInterceptedException:
            if time.time() - t_start > default_time:
                raise
            time.sleep(0.5)
        else:
            break
    # Sleep after clicking [s]
    if sleep_after > 0:
        time.sleep(sleep_after)


""" Waits for the initialization page to be visible
    :param: driver:         webdriver browser interface
"""
def wait_for_init_page(driver) -> None:
    #Waits for init page to be loaded - in another words we wait until main element on init page is available 
    wait_for_element(driver, f"root_Standard_layout_AreaContent", select_event=ec.visibility_of_element_located)

""" Sets an input field to a value, tested with standard keyboard and numpad
    :param: driver:         webdriver browser interface
    :param: selector_name:  any string describing the selector
    :param: selector_value: any value that the selector can be set to
    :param: select_by:      selection type (ID, XPATH, NAME, ...) (default ID)
    :param: select_event:   expected condition (default element_to_be_clickable)
    :param: default_time:   waiting time if the exception ElementClickInterceptedException appears
"""
def set_input(driver, selector_name, selector_value, select_by=By.ID, select_event=ec.element_to_be_clickable, default_time=10) -> None:
    wait_and_click_element(driver, selector_name)
    #checks if the alphanumeric keyboard is displayed or the numeric
    keyboard = driver.find_element(By.CLASS_NAME, "keyBoardInputField").find_element(By.TAG_NAME, "input")
    if keyboard.is_displayed():
        keyboard.clear()
        keyboard.send_keys(f"{selector_value}\n")
    else:
        numpad = driver.find_element(By.CLASS_NAME, 'numpadWrapper').find_elements(By.TAG_NAME, 'button')
        for c in selector_value:
            match c:
                case '0':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[13]').click()
                case '1':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[9]').click()
                case '2':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[10]').click()
                case '3':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[11]').click()
                case '4':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[5]').click()
                case '5':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[6]').click()
                case '6':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[7]').click()
                case '7':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[1]').click()
                case '8':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[2]').click()
                case '9':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[3]').click()
                case '-':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[8]').click()
                case '.':
                    driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[14]').click()
        driver.find_element(By.XPATH, '//*[@id="breaseNumPad"]/div/div/section[2]/button[12]').click()

def load_content(driver, button_name, content_name):
    wait_and_click_element(driver, button_name, sleep_before=0.1, sleep_after=0.5)
    WebDriverWait(driver, 5).until(ec.text_to_be_present_in_element_attribute((By.CLASS_NAME, 'systemContentLoader'), 'data-brease-contentid', content_name))

""" Returns the output from a text output
    :param: driver:         webdriver browser interface
    :param: selector_name:  any string describing the selector
    :param: selector_value: any value that the selector can be set to
    :param: select_by:      selection type (ID, XPATH, NAME, ...) (default ID)
"""
def get_output(driver, selector_name, select_by=By.ID, default_time=10):
    driver.find_element(select_by, selector_name).text

""" Returns the value of an output, can be either text output or numeric
    :param: driver:         webdriver browser interface
    :param: selector_name:  any string describing the selector
    :param: selector_value: any value that the selector can be set to
"""
def get_value(driver, selector_name):
    wait_for_element(driver, selector_name)
    try:
        input = driver.find_element(By.ID, selector_name).find_element(By.TAG_NAME, 'input')
        return input.get_attribute("value")
    except NoSuchElementException:
        return driver.find_element(By.ID, selector_name).text

""" Returns the data table id and it's associated wrapper id
    :param: driver:         webdriver browser interface
    :param: table_name:  table name
"""
def get_table_info(driver, table_name):
    WebDriverWait(driver, 5).until(ec.element_to_be_clickable((driver.find_element(By.ID, f"{table_name}"))))
    table = driver.find_element(By.ID, table_name)
    data_table_id = table.find_element(By.CLASS_NAME, 'dataTable').get_attribute('id')
    wrapper_id = table.find_element(By.CLASS_NAME, 'dataTables_wrapper').get_attribute('id')
    return data_table_id, wrapper_id

""" Returns the values in a column of a table
    :param: driver:         webdriver browser interface
    :param: table_name:     any string describing the table name
    :param: column_name:    any string describing the column name
"""
def get_table_column(driver, table_name, column_name) -> list:
    table_id, data_wrapper = get_table_info(driver, table_name)
    num_rows = len(driver.find_elements(By.XPATH, f"//*[@id='{table_id}']/tbody/tr"))
    columns = driver.find_element(By.XPATH, f"//*[@id='{data_wrapper}']/div[2]").find_elements(By.CLASS_NAME, 'breaseTableColumnWidget')
    if columns == []:
        columns = driver.find_element(By.XPATH, f"//*[@id='{table_name}']/div[1]").find_elements(By.CLASS_NAME, 'breaseTableItemWidget')
    column_id = driver.find_element(By.XPATH, f"//*[@id='{column_name}']").id
    column = -1
    for t_col in range(0, len(columns)):
        if columns[t_col].id == column_id:
            column = t_col+1
            break
    if (column == -1):
        pytest.fail(f'Column {column_id} not found in table {table_name}, valid columns are {columns}')
    columns = []
    try:
        for t_row in range(1, num_rows+1):
            columns.append(driver.find_element(By.XPATH, f'//*[@id="{table_id}"]/tbody/tr[{t_row}]/td[{column}]').text)
    except StaleElementReferenceException:
        # if the data becomes stale then try again
        columns = get_table_column(driver, table_name, column_name)
    return columns
    

""" Returns the values in a row of a table, column name and item are used to select the row.
    :param: driver:         webdriver browser interface
    :param: table_name:     any string describing the table name
    :param: column_name:    any string describing the column name
    :param: column_item:    string to identify the wanted row
"""
def get_table_row(driver, table_name, column_name, column_item) -> list:
    table_id, data_wrapper = get_table_info(driver, table_name)
    num_rows = len(driver.find_elements(By.XPATH, f"//*[@id='{table_id}']/tbody/tr"))
    num_cols = len(driver.find_elements(By.XPATH, f"//*[@id='{table_id}']/tbody/tr[1]/td"))
    columns = get_table_column(driver, table_name, column_name)
    row_index = 1
    for t_row in range(0, num_rows):
        if columns[t_row] == column_item:
            row_index = t_row+1
            break
    row = []
    try:
        for t_col in range(1, num_cols+1):
            row.append(driver.find_element(By.XPATH, f'//*[@id="{table_id}"]/tbody/tr[{str(row_index)}]/td[{t_col}]').text)
    except StaleElementReferenceException:
        # if the data becomes stale then try again
        row = get_table_row(driver, table_name, column_name, column_item)
    return row

""" Returns the values in a column of a table
    :param: driver:         webdriver browser interface
    :param: table_name:     any string describing the table name
"""
def get_table(driver, table_name) -> list:
    table_id, data_wrapper = get_table_info(driver, table_name)
    num_rows = len(driver.find_elements(By.XPATH, f"//*[@id='{table_id}']/tbody/tr"))
    num_cols = len(driver.find_elements(By.XPATH, f"//*[@id='{table_id}']/tbody/tr[1]/td"))
    table = []
    try:
        for t_row in range(1, num_rows+1):
            columns = []
            for t_col in range(1, num_cols+1):
                columns.append(driver.find_element(By.XPATH, f'//*[@id="{table_id}"]/tbody/tr[{t_row}]/td[{t_col}]').text)
            table.append(columns)
    except StaleElementReferenceException:
        # if the data becomes stale then try again
        table = get_table(driver, table_name)
    return table

""" Selects (clicks) a row in a table
    :param: driver:         webdriver browser interface
    :param: table_name:     any string describing the table name
    :param: column_name:    any string describing the column name
    :param: column_item:    string to identify the wanted row
    :param: sleep_before:   waiting time before clicking
    :param: sleep_after:    waiting time after clicking
"""
def select_table_row(driver, table_name, column_name, column_item, sleep_before: float = 0, sleep_after: float = 0) -> None:
    if sleep_before > 0:
        time.sleep(sleep_before)
    table_id, data_wrapper = get_table_info(driver, table_name)
    columns = get_table_column(driver, table_name, column_name)
    row = 1
    for t_row in range(0, len(columns)):
        if columns[t_row] == column_item:
            row = t_row+1
            break
    driver.find_element(By.XPATH, f"//*[@id='{table_id}']/tbody/tr[{str(row)}]").click()
    if sleep_after > 0:
        time.sleep(sleep_after)

""" Selects an item from a dropdown input
    :param: driver:         webdriver browser interface
    :param: dropdown_name:  any string describing the dropdown name
    :param: dropdown_item:  string to identify the wanted item from the dropdown
    :param: sleep_before:   waiting time before clicking
    :param: sleep_after:    waiting time after clicking
"""
def select_dropdown_item(driver, dropdown_name, dropdown_item, sleep_before: float = 0, sleep_after: float = 0) -> None:
    if sleep_before > 0:
        time.sleep(sleep_before)
    
    wait_and_click_element(driver, dropdown_name)
    items = driver.find_element(By.XPATH, f"//*[@id='{dropdown_name}_listBoxWrapper']").find_elements(By.CLASS_NAME, 'ItemView')
    for item in items:
        if (item.text == dropdown_item):
            item.click()
            break

    if sleep_after > 0:
        time.sleep(sleep_after)
    
""" Returns the id of the currently open dialog
    :param: driver:         webdriver browser interface
"""
def get_open_dialog_id(driver):
    try:
        return driver.find_element(By.CLASS_NAME, 'breaseGenericDialog').get_attribute('id')
    except NoSuchElementException:
        return driver.find_element(By.CLASS_NAME, 'breaseDialogWindowContentBox').get_attribute('id')

""" Takes a screenshot using the selenium driver
    :param: driver:         webdriver browser interface
"""
def take_screenshot(driver, name):
    filename = name if name.endswith('.png') else f'{name}.png'
    driver.get_screenshot_as_file(filename)
    allure.attach(driver.get_screenshot_as_png(), name, attachment_type=AttachmentType.PNG)

""" Returns the value of a variable read via OpcUa
    :param: client:     OpcUa client instance
    :param: variable:   name of the variable to read
    :param: namespace:  integer number of the namespace that the variable is in (default = 6, B&R standard)
"""
def read_variable(client, variable, namespace: int = 6):
    tag = client.get_node(f'ns={namespace};s={variable}')
    return tag.read_value()

""" Writes a value to a variable via OpcUa
    :param: client:     OpcUa client instance
    :param: variable:   name of the variable to write
    :param: value:      value read from the variable
    :param: namespace:  integer number of the namespace that the variable is in (default = 6, B&R standard)
"""
def write_variable(client, variable, value, namespace: int = 6):
    tag = client.get_node(f'ns={namespace};s={variable}')
    type = tag.read_data_type_as_variant_type()
    return tag.write_value(ua.DataValue(ua.Variant(value, type)))