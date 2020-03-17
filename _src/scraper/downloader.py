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
        print("Removendo arquivo antigo.")
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
    from datetime import date
    # check if file is new and different before replacing
    fname = 'brasil-ivis-' + date.today().isoformat() + '.csv'
    if os.path.exists(save_folder + fname):
        diff = os.system('diff -q ' + save_folder + fname + ' ' + download_folder + 'brasil.csv')
        if diff == 0:
            print("Nenhuma alteração no arquivo.")
            return False
        else:
            # files differ
            print('Nova versão do dia %s encontrada.' % date.today().isoformat())
    else:
        print('Primeira versão do dia %s encontrada.' % date.today().isoformat())
    
    # move/replace file and re-generate data file
    shutil.move(download_folder + 'brasil.csv', save_folder + fname)
    return True

def regenerate_aggregate_datafile(aggregate_files, save_folder, base_name):
    from glob import glob
    import re

    files = sorted(glob(save_folder + base_name + '*.csv'))
    states = ['day;state;suspect.cases;perc.suspect.cases;confirmed.cases;perc.confirmed.cases;discarded.cases;perc.discarded.cases;deaths;perc.deaths;total;local.transmission']
    regions = ['day;region;suspect.cases;perc.suspect.cases;confirmed.cases;perc.confirmed.cases;discarded.cases;perc.discarded.cases;deaths;perc.deaths;total;local.transmission']
    country = ['day;suspect.cases;perc.suspect.cases;confirmed.cases;perc.confirmed.cases;discarded.cases;perc.discarded.cases;deaths;perc.deaths;total;local.transmission']
    for fname in files:
        day = re.search(base_name + '(.+).csv', fname).groups()[0]
        with open(fname, 'r') as f:
            for line in f.readlines():
                g1 = re.search(r'^Unidade da Federação;(.+)', line)
                if g1:
                    states.append(day + ';' + g1.groups()[0])
                    continue
                g2 = re.search(r'^Região;(.+)', line)
                if g2:
                    regions.append(day + ';' + g2.groups()[0])
                    continue
                g3 = re.search(r'^País;Brasil;(.+)', line)
                if g3:
                    country.append(day + ';' + g3.groups()[0])

    with open(aggregate_files[0], 'w') as f:
        f.write('\n'.join(states))
    with open(aggregate_files[1], 'w') as f:
        f.writelines('\n'.join(regions))
    with open(aggregate_files[2], 'w') as f:
        f.writelines('\n'.join(country))

if __name__ == '__main__':
    download_current_file(download_folder)
    isnewfile = save_file_if_new(download_folder, save_folder)
    if isnewfile:
        regenerate_aggregate_datafile([save_folder + 'states.csv',
            save_folder + 'regions.csv', save_folder + 'brazil.csv'],
            save_folder, 'brasil-ivis-')

