#!/usr/bin/env node
'use strict';

// const util = require('util');
// const exec = util.promisify(require('child_process').exec);
const { spawn } = require('child_process');

const SCANNER_READY_DELAY = 10 * 1000;

const formatTypes = [
  'pnm',
  // 'tiff',
  // 'png',
  // 'jpeg',
];

const compressionTypes = [
  'None',
  'JPEG',
];

function run (command, ...args) {
  return new Promise((resolve, reject) => {
    console.log('About to run command:');
    console.log(command, ...args);

    const childProcess = spawn(command, args);

    childProcess.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });

    childProcess.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });

    childProcess.on('close', (code) => {
      console.log('Finished running command:');
      console.log(command, ...args);

      console.log(`child process exited with code ${code}`);

      if (code === 0) {
        setTimeout(() => {
          console.log('Waiting for scanner to become ready...');
          resolve();
        }, SCANNER_READY_DELAY);

        return;
      }

      reject(`Process exited with code ${code}.  Review the output above.`);
    });
  });
}

// function _run (command) {
//   return new Promise(async (resolve, reject) => {
//     try {
//       console.log('About to run command:');
//       console.log(command);
//       const { stdout, stderr } = await exec(command);

//       console.log('stdout:', stdout);
//       console.error('stderr:', stderr);

//       console.log('Finished running command:');
//       console.log(command);

//       setTimeout(() => {
//         console.log('Waiting for scanner to become ready...');
//         resolve();
//       }, 10000);
//     }
//     catch (error) {
//       reject(error);
//     }
//   });
// }

async function main () {
  // console.log('Ready to scan next document - Press ENTER...');

  for (let i = 0; i < formatTypes.length; i++) {
    const formatType = formatTypes[i];

    for (let j = 0; j < compressionTypes.length; j++) {
      const compressionType = compressionTypes[j];
      const filename = `scan_${formatType}_${compressionType}`;

      await run('./scan.sh', formatType, compressionType);
    }
  }
}

main()
  .then(() => {
    console.log('Successfully finished scanning');
    process.exit(0)
  })
  .catch((error) => {
    console.error(error);
    console.error('Error while scanning!');
    process.exit(1);
  });
