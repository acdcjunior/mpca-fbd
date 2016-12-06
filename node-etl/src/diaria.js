
class Diaria {
    constructor(linhaString) {
        let colunas = linhaString.split('\t');
        let i = 0;
        this.cd_org_sup = colunas[i++];
        this.nm_org_sup = colunas[i++];
        this.cd_org_sub = colunas[i++];
        this.nm_org_sub = colunas[i++];
        this.cd_un_gest = colunas[i++];
        this.nm_un_gest = colunas[i++];
        this.cd_funcao = colunas[i++];
        this.nm_funcao = colunas[i++];
        this.cd_subfuncao = colunas[i++];
        this.nm_subfuncao = colunas[i++];
        this.cd_prog = colunas[i++];
        this.nm_prog = colunas[i++];
        this.cd_acao = colunas[i++];
        this.nm_acao = colunas[i++];
        this.ling_cidada = colunas[i++];
        this.cpf_fav = colunas[i++];
        this.nm_fav = colunas[i++];
        this.doc = colunas[i++];
        this.gestao = colunas[i++];
        this.dt = colunas[i++];
        this.val = colunas[i++];

        if (this.ling_cidada === '\u0000') {
            this.ling_cidada = '';
        }
    }
}

module.exports = Diaria;