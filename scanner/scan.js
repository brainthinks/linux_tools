#!/usr/bin/env node
'use strict';

const path = require('path');
const { spawn } = require('child_process');
const glob = require('glob');
const throttle = require('lodash/throttle');

const SCANNER_READY_DELAY = 10 * 1000;
const PROGRESS_LOG_DELAY = 2 * 1000;
const TEST_SCAN_DIR = './test_scans';

const formatTypes = [
  'png',
  // 'pnm',
  // 'tiff',
  // 'jpeg',
];

const compressionTypes = [
  'None',
  // 'JPEG',
];

const resolutions = [
  1200,
  // 600,
];

// Only show the `scanimage` progress once every five seconds
const throttledProcessConsoleLog = throttle((data) => {
  console.log(data.toString());
}, PROGRESS_LOG_DELAY, { leading: true });
const throttledProcessConsoleError = throttle((data) => {
  console.error(data.toString());
}, PROGRESS_LOG_DELAY, { leading: true });

function run (command, ...args) {
  return new Promise((resolve, reject) => {
    console.log('About to run command:');
    console.log(command, ...args);

    const childProcess = spawn(command, args);

    childProcess.stdout.on('data', (data) => {
      // @todo - Why includes?  What does it start with?
      if (!data.toString().includes('Progress: ')) {
        console.log(`stdout: ${data}`);
        return;
      }

      throttledProcessConsoleLog(data);
    });

    childProcess.stderr.on('data', (data) => {
      // @todo - Why includes?  What does it start with?
      if (!data.toString().includes('Progress: ')) {
        console.error(`stderr: ${data}`);
        return;
      }

      throttledProcessConsoleError(data);
    });

    childProcess.on('close', (code) => {
      console.log('Finished running command:');
      console.log(command, ...args);

      console.log(`child process exited with code ${code}`);

      if (code !== 0) {
        return reject(`Process exited with code ${code}.  Review the output above.`);
      }

      return resolve();
    });
  });
}

function sleep (delay = 1000) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve();
    }, delay);
  });
}

async function qualityTest () {
  for (let i = 0; i < formatTypes.length; i++) {
    const formatType = formatTypes[i];

    for (let j = 0; j < compressionTypes.length; j++) {
      const compressionType = compressionTypes[j];
      const filename = `${TEST_SCAN_DIR}/scan_${formatType}_${compressionType}`;

      await run('./scan.sh', filename, formatType, compressionType);

      console.log('Waiting for scanner to become ready...');

      await sleep(SCANNER_READY_DELAY);
    }
  }
}

function constructFilename (targetDirectory, batchNumber, scanNumber) {
  const prefix = 'scan';
  const extension = 'png';

  if (typeof batchNumber === 'number') {
    batchNumber = batchNumber.toString().padStart(4, '0');
  }

  if (typeof scanNumber === 'number') {
    scanNumber = scanNumber.toString().padStart(7, '0');
  }

  return path.join(targetDirectory, `${prefix}_${batchNumber}_${scanNumber}.${extension}`);
}

async function main () {
  const targetDirectory = process.argv[2] || TEST_SCAN_DIR;

  await run('mkdir', '-p', targetDirectory);

  let scanBatch = 0;
  let scanCount = 0;

  let isCurrentBatchNumber = false;

  while (!isCurrentBatchNumber) {
    isCurrentBatchNumber = await new Promise((resolve, reject) => {
      const filePattern = constructFilename(targetDirectory, scanBatch, '*');
      console.log(`Checking for existence of ${filePattern}`);
      glob(filePattern, (error, files) => {
        if (error) {
          return reject(error)
        }

        // Will return true if files exist in the target directory that match the
        // glob, which means the batch number has already been used
        resolve(files.length === 0);
      });
    });

    if (!isCurrentBatchNumber) {
      scanBatch++;
    }
  }

  while (true) {
    console.log('');
    console.log('');
    console.log(`Next up: folder ${targetDirectory}, batch #${scanBatch}, scan #${scanCount}`);
    console.log('Ready to scan next document - load the scanner bed then press any key to continue...');
    console.log('');

    // Wait for the human to press a key
    // @see - https://stackoverflow.com/questions/19687407/press-any-key-to-continue-in-nodejs
    await new Promise((resolve, reject) => {
      process.stdin.setRawMode(true);

      process.stdin.once('data', function (data) {
        const byteArray = [...data];

        if (byteArray.length > 0 && byteArray[0] === 3) {
          console.log('^C');
          process.exit(1);
        }

        process.stdin.setRawMode(false);

        resolve();
      });
    });

    const filename = constructFilename(targetDirectory, scanBatch, scanCount);

    await run('./scan.sh', filename);

    console.log('Waiting for scanner to become ready...');

    await sleep(SCANNER_READY_DELAY);

    scanCount++;
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
