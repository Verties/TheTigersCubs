const readline = require('readline');
var fs = require('fs');

let config = {
    infura: {
        projectId: '',
        projectSecret: ''
    },
};


const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

console.log(`Configurate Infura (https://infura.io/):`);
rl.question('Enter Project ID: ', (answer) => {
    config.infura.projectId = answer.trim();
    rl.question('Enter Project SECRET: ', (answer) => {
        config.infura.projectSecret = answer.trim();
        var json = JSON.stringify(config.infura);
        fs.writeFile('config.infura.json', json, 'utf8', ()=>{});
        rl.close();
    });
});




