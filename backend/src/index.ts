import compression from 'compression';
import express, { NextFunction, Request, Response } from 'express';

import { runMigrations } from './db.js';

import setupApi from './routes/index.js';

const port = process.env.HTTP_PORT || 4000;

function log(req: Request, res: Response, next: NextFunction) {
    const { method, path } = req;
    console.log(`${method} ${path}`);
    next();
}

function send404(req: Request, res: Response) {
    if (res.finished) {
        return;
    }

    console.log('HTTP 404 Not Found');
    res.sendFile('public/404.html', {
        root: process.cwd(),
    });
}

async function main() {
    try {
        await runMigrations();
        console.log('Finished setting up database');
    } catch (err) {
        console.error(err);
        process.exit(1);
    }

    const app = express();

    // Compress responses.
    app.use(compression());

    // Log all requests.
    app.use(log);

    //
    // Backend API
    //
    const api = express.Router();
    app.use('/api', api);
    setupApi(api);

    // Send a 404 HTML page for all other situations.
    app.use('/', send404);

    /// Listen on port 4000.
    app.listen(port, () => {
        console.log(`Listening on port ${port}`);
    });
}

main();
