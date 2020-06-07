const page_id = "municipios";
const default_uf = "SP";
const default_mun = "Sao_Paulo";
const default_verb = "São Paulo";
const locale =
    [ 
        { prep: "em", uf: "SP-Sao_Paulo",             verbose: "São Paulo",             has_modelogro: true,  has_td: true  },
        { prep: "em", uf: "SP-Jundiai",               verbose: "Jundiaí",               has_modelogro: false, has_td: false },
        { prep: "em", uf: "MG-Belo_Horizonte",        verbose: "Belo Horizonte",        has_modelogro: false, has_td: true  },
        { prep: "no", uf: "RJ-Rio_de_Janeiro",        verbose: "Rio de Janeiro",        has_modelogro: false, has_td: true  },
        { prep: "em", uf: "SC-Florianopolis",         verbose: "Florianópolis",         has_modelogro: false, has_td: true  },
        { prep: "em", uf: "PB-Joao_Pessoa",           verbose: "João Pessoa",           has_modelogro: false, has_td: true  },
        { prep: "em", uf: "GO-Goiania",               verbose: "Goiânia",               has_modelogro: false, has_td: false },
        { prep: "em", uf: "AM-Manaus",                verbose: "Manaus",                has_modelogro: false, has_td: true  },
        { prep: "em", uf: "AM-Tabatinga",             verbose: "Tabatinga",             has_modelogro: false, has_td: true  },
        { prep: "em", uf: "PR-Curitiba",              verbose: "Curitiba",              has_modelogro: false, has_td: true  },
        { prep: "em", uf: "SP-Santos",                verbose: "Santos",                has_modelogro: false, has_td: true  },
        { prep: "em", uf: "RS-Porto_Alegre",          verbose: "Porto Alegre",          has_modelogro: false, has_td: false },
        { prep: "em", uf: "SP-Sao_Bernardo_do_Campo", verbose: "São Bernardo do Campo", has_modelogro: false, has_td: true  },
        { prep: "em", uf: "SP-Guarulhos",             verbose: "Guarulhos",             has_modelogro: false, has_td: true  },
        { prep: "em", uf: "SP-Osasco",                verbose: "Osasco",                has_modelogro: false, has_td: true  },
        { prep: "em", uf: "PA-Belem",                 verbose: "Belém",                 has_modelogro: false, has_td: true  },
        { prep: "em", uf: "PE-Recife",                verbose: "Recife",                has_modelogro: false, has_td: true  },
        { prep: "em", uf: "CE-Fortaleza",             verbose: "Fortaleza",             has_modelogro: false, has_td: true  },
        { prep: "em", uf: "RJ-Duque_de_Caxias",       verbose: "Duque de Caxias",       has_modelogro: false, has_td: true  },
        { prep: "em", uf: "BA-Salvador",              verbose: "Salvador",              has_modelogro: false, has_td: true  },
        { prep: "em", uf: "PA-Ananindeua",            verbose: "Ananindeua",            has_modelogro: false, has_td: true  },
        { prep: "em", uf: "SP-Santo_Andre",           verbose: "Santo André",           has_modelogro: false, has_td: true  },
        { prep: "em", uf: "MA-Sao_Luis",              verbose: "São Luís",              has_modelogro: false, has_td: true  },
        { prep: "em", uf: "ES-Vitoria",               verbose: "Vitória",               has_modelogro: false, has_td: true  },
        { prep: "em", uf: "ES-Alegre",                verbose: "Alegre",                has_modelogro: false, has_td: true  },
        { prep: "em", uf: "AM-Macapa",                verbose: "Macapá",                has_modelogro: false, has_td: true  },
        { prep: "em", uf: "AM-Manacapuru",            verbose: "Manacapuru",            has_modelogro: false, has_td: true  },
        { prep: "em", uf: "RJ-Niteroi",               verbose: "Niterói",               has_modelogro: false, has_td: true  }
    ];
