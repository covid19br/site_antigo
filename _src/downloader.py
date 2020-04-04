import os, shutil, sys
from datetime import date, timedelta

# config
# notice `download_folder` should reflect your Chrome default download folder
download_folder = os.path.expanduser('~/Downloads/')
save_folder = os.path.expanduser('~/Dropbox/covid19/covid19BR/dados/brutos/')

def download_current_file(download_folder):
    '''Download current file from MS website.'''
    import time
    from selenium import webdriver
    # clean possible saved file
    if os.path.exists(download_folder + 'brasil.csv'):
        print("Removendo arquivo antigo de %s." % download_folder)
        os.remove(download_folder + 'brasil.csv')
    
    # download current file
    driver = webdriver.Chrome()
    
    driver.get("https://covid.saude.gov.br/")
    # take a breath and let it load
    time.sleep(2)
    # click buttom to get table
    buttom = driver.find_elements_by_xpath("//input[@class='ok' and @role='button']")[0]
    button.click()
    #driver.execute_script("dashboard.coronavirus.brazilCSV()");
    # wait for download to finish
    fname = getDownLoadedFileName(300)
    print('Arquivo baixado')
    driver.close()
    return(fname)

def save_file_if_new(fname, save_folder):
    '''Save downloaded file to proper place if it's different from previous one. Return True if the file is new, False otherwise.'''
    # check if file is new and different before replacing
    fnames = [ 'BRnCov19_' +  (date.today()-timedelta(1)).strftime("%Y%m%d") + '.csv',
               'BRnCov19_' +  date.today().strftime("%Y%m%d") + '.csv' ]

    diffs = []
    for f in fnames:
        if os.path.exists(save_folder + f):
            diffs.append(os.system('diff -q ' + save_folder + f + ' ' + \
                    fname)
        else:
            diffs.append(1)

    if diffs == [0, 1]:
        print("Nenhuma alteração no arquivo de ontem.")
        return False
    elif diffs == [1, 0]:
        print("Nenhuma alteração no arquivo de hoje.")
        return False
    elif diffs == [1, 1]:
        print('Nova versão encontrada.')

    # move/replace file and re-generate data file
    shutil.move(fname, save_folder + 'BRnCov19_' + date.today().strftime("%Y%m%d") + '.csv')
    return True

# method to get the downloaded file name
def getDownLoadedFileName(waitTime):
    driver.execute_script("window.open()")
    # switch to new tab
    driver.switch_to.window(driver.window_handles[-1])
    # navigate to chrome downloads
    driver.get('chrome://downloads')
    # define the endTime
    endTime = time.time()+waitTime
    while True:
        try:
            # get downloaded percentage
            downloadPercentage = driver.execute_script(
                "return document.querySelector('downloads-manager').shadowRoot.querySelector('#downloadsList downloads-item').shadowRoot.querySelector('#progress').value")
            # check if downloadPercentage is 100 (otherwise the script will keep waiting)
            if downloadPercentage == 100:
                # return the file name once the download is completed
                return driver.execute_script("return document.querySelector('downloads-manager').shadowRoot.querySelector('#downloadsList downloads-item').shadowRoot.querySelector('div#content  #file-link').text")
        except:
            pass
        time.sleep(1)
        if time.time() > endTime:
            break

def regenerate_aggregate_datafile(aggregate_files, save_folder, base_name):
    from glob import glob
    import re

    files = sorted(glob(save_folder + base_name + '*.csv'))
    states = []
    country = ['day;suspect.cases;confirmed.cases;discarded.cases;deaths']

    for fname in files:
        day = re.search(base_name + '(.+).csv', fname).groups()[0]
        if day < '2020-03-09':
            # old tables were manually cleaned
            continue
        fields = [0, 1, 3, 5, 7, 10]
        if day < '2020-03-11':
            # table has 1 missing fields (total cases)
            fields = [0, 1, 3, 5, 7, 9]
        if day == '2020-03-11':
            # table has 2 extra fields (probable cases)
            fields = [0, 1, 5, 7, 9, 12]
        with open(fname, 'r') as f:
            for line in f.readlines():
                g1 = re.search(r'^Unidade da Federação;(.+)', line)
                if g1:
                    text = g1.groups()[0].replace('.', '')
                    # break fields
                    sfields = [day] + [ text.split(';')[i] for i in fields ]
                    # clean up state name
                    sfields[1] = re.search(r'^(.+) \(.+\)\**', sfields[1]).groups()[0]
                    states.append(';'.join(sfields))
                    continue
                g3 = re.search(r'^País;(.+)', line)
                if g3:
                    text = g3.groups()[0].replace('.', '')
                    # break fields
                    sfields = [day] + [ text.split(';')[i] for i in fields[1:-1] ]
                    country.append(';'.join(sfields))

    with open(aggregate_files[0], 'w') as f:
        with open(save_folder + 'states_begin.csv', 'r') as states_begin:
            f.write(states_begin.read())
        f.write('\n'.join(states))
    with open(aggregate_files[1], 'w') as f:
        f.writelines('\n'.join(country))

if __name__ == '__main__':
    fname = download_current_file(download_folder)
    isnewfile = save_file_if_new(fname, save_folder)
    if isnewfile:
        #regenerate_aggregate_datafile([save_folder + 'states.csv',
        #    save_folder + 'brazil.csv'], save_folder, 'brasil-ivis-')
        os.system('R -q --no-save < atualiza_dados.R')
        os.system('git add ' + save_folder + 'states.csv ' + save_folder + 'brazil.csv ' + save_folder + 'brasil-ivis-' + date.today().isoformat() + '.csv')
        os.system('git commit -m "[auto] novos dados" && git push')
        sys.exit(0)
    sys.exit(1)

# dia 11/03: 2 colunas a mais (casos provaveis)
# dias 09-10/03: coluna Total a menos
# dias 25/02 - 08/03: Unidade da Federação;Suspeitos;Confirmados;Descartados;Óbitos;Transmissão local
# dias 02/02 - 07/2: UF;Suspeito;Confirmado;Descartado;Transmissão local

