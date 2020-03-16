import os
from datetime import date
from selenium import webdriver

# config
download_folder = os.path.expanduser('~/Downloads/')
save_folder = os.path.expanduser('~/Dropbox/covid19/BR/')

# clean possible saved file
if os.path.exists(download_folder + 'brasil.csv'):
    print("Removendo arquivo antigo.")
    os.remove(download_folder + 'brasil.csv')

# download current file
driver = webdriver.Chrome()

driver.get("http://plataforma.saude.gov.br/novocoronavirus")
driver.execute_script("dashboard.coronavirus.brazilCSV()");
driver.close()

# check if file is new and different before replacing
fname = 'brasil-ivis-' + date.today().isoformat() + '.csv'
if os.path.exists(save_folder + fname):
    diff = os.system('diff -q ' + save_folder + fname + ' ' + download_folder + 'brasil.csv')
    if diff == 0:
        print("Nenhuma alteração no arquivo.")
    else:
        # files differ
        print('Nova versão do dia %s encontrada.' % date.today().isoformat())
        os.replace(download_folder + 'brasil.csv', save_folder + fname)
else:
    print('Primeira versão do dia %s encontrada.' % date.today().isoformat())
    os.rename(download_folder + 'brasil.csv', save_folder + fname)

