const readline = require('readline');
var fs = require('fs');

let config = {
    infura: {
        projectId: '',
        projectSecret: '',
        endpoint: '',
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

        rl.question('Enter Endpoint (https://{endpoint}.infura.io/v3/{projectId}): ', (answer) => {
            config.infura.endpoint = answer.trim();
            var json = JSON.stringify(config.infura);
            fs.writeFile('config.infura.json', json, 'utf8', ()=>{});
            rl.close();
        });
    });
});




