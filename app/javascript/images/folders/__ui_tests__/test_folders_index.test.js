import puppeteer from 'puppeteer';

let browser;
let page;

beforeAll(async () => {
    browser = await puppeteer.launch({
        headless: false,
    });
});
beforeEach(async () => {
    page = await browser.newPage();
    await page.goto('http://localhost:3000/components_test/open');
});
describe('display and get screenshot', () => {
    test('First Test', async () => {
        await page.evaluate(() => {
            window.tests.folders_index.no_folders();
        });
        await page.waitForSelector('.folders-index');
        await page.screenshot({
            path: 'screenshots/images/folders/folders_index/no_folders.png',
        });
    }, 16000);
    test('First Test', async () => {
        await page.evaluate(() => {
            window.tests.folders_index.with_folders();
        });
        await page.waitForSelector('.folders-index');
        await page.screenshot({
            path: 'screenshots/images/folders/folders_index/has_folders.png',
        });
    }, 16000);
});
describe('manupulations', () => {
    test('rename', async () => {
        await page.evaluate(() => {
            window.tests.folders_index.with_folders();
        });
        await page.waitForSelector('.folders-index');
        await page.click('button[name="rename"]');
        const input = await page.$('input[type="text"]');
        const oldName = await page.$eval('input[type="text"]', (i) => i.value);
        expect(oldName).toBe('folder1');
        await input.type('folder3', {delay: 300});
        await page.click('button[name="apply"]');
        const result = await page.evaluate(() => {
            return window.check();
        });
        expect(result).toBeTruthy();
        const element = await page.$('.folders-index');
        await element.screenshot({
            path: 'screenshots/images/folders/folders_index/after_renamed.png',
        });

    }, 100000);
});
afterEach(async () => {
    if (page) {
        await page.close();
    }
});
afterAll(() => {
        if (browser) {
            browser.close();
        }
    }
);