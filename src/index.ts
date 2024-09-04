async function main() {
  return Promise.resolve('Executing in index.ts');
}

const str = await main();

console.log(str);
