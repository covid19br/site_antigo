import os, shutil

# config
# notice `download_folder` should reflect your Chrome default download folder
download_folder = os.path.expanduser('~/Downloads/')
save_folder = os.path.expanduser('~/Dropbox/covid19/covid19BR/dados/brutos-ivis/')

def download_current_file(download_folder):
    '''Download current file from IVIS website.'''
    import time
    from selenium import webdriver
    # clean possible saved file
    if os.path.exists(download_folder + 'brasil.csv'):
        print("Removendo arquivo antigo de %s." % download_folder)
        os.remove(download_folder + 'brasil.csv')
    
    # download current file
    driver = webdriver.Chrome()
    
    driver.get("http://plataforma.saude.gov.br/novocoronavirus")
    driver.execute_script("dashboard.coronavirus.brazilCSV()");
    # wait for download to finish
    i = 0
    while not os.path.exists(download_folder + 'brasil.csv'):
        time.sleep(1)
        i += 1
        # 5 min !?
        if i > 300:
            break
    print('Arquivo baixado após %d segundos.' % i)
    driver.close()

def save_file_if_new(download_folder, save_folder):
    '''Save downloaded file to proper place if it's different from previous one. Return True if the file is new, False otherwise.'''
    from datetime import date, timedelta
    # check if file is new and different before replacing
    fnames = [ 'brasil-ivis-' + (date.today()-timedelta(1)).isoformat() + '.csv',
               'brasil-ivis-' + date.today().isoformat() + '.csv']
    diffs = []
    for fname in fnames:
        if os.path.exists(save_folder + fname):
            diffs.append(os.system('diff -q ' + save_folder + fname + ' ' + \
                    download_folder + 'brasil.csv'))
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
    shutil.move(download_folder + 'brasil.csv', save_folder + fname)
    return True

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
                    # break fields
                    sfields = [day] + [ g1.groups()[0].split(';')[i] for i in fields ]
                    # clean up state name
                    sfields[1] = re.search(r'^(.+) \(.+\)\**', sfields[1]).groups()[0]
                    states.append(';'.join(sfields))
                    continue
                g3 = re.search(r'^País;(.+)', line)
                if g3:
                    # break fields
                    sfields = [day] + [ g3.groups()[0].split(';')[i] for i in fields[1:-1] ]
                    country.append(';'.join(sfields))

    with open(aggregate_files[0], 'w') as f:
        with open(save_folder + 'states_begin.csv', 'r') as states_begin:
            f.write(states_begin.read())
        f.write('\n'.join(states))
    with open(aggregate_files[1], 'w') as f:
        f.writelines('\n'.join(country))

if __name__ == '__main__':
    download_current_file(download_folder)
    isnewfile = save_file_if_new(download_folder, save_folder)
    if isnewfile:
        regenerate_aggregate_datafile([save_folder + 'states.csv',
            save_folder + 'brazil.csv'], save_folder, 'brasil-ivis-')


# dia 11/03: 2 colunas a mais (casos provaveis)
# dias 09-10/03: coluna Total a menos
# dias 25/02 - 08/03: Unidade da Federação;Suspeitos;Confirmados;Descartados;Óbitos;Transmissão local
# dias 02/02 - 07/2: UF;Suspeito;Confirmado;Descartado;Transmissão local

