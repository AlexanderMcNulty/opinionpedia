import bodyParser from 'body-parser';
import express, { NextFunction, Request, Response, Router } from 'express';

import { closeDatabase } from './db.js';
import { HTTPError, UnknownDBError } from './errors.js';

import setupProfile from './profile.js';
import setupQuestion from './question.js';
import setupOption from './option.js';
import setupVote from './vote.js';

import { development } from '../config.js';
import { MySQLError } from '../errors.js';

const INVALID_REQUEST_PARAMETERS = 'Invalid request parameters';

const allowedOrigins = {
    'http://localhost:3000': true,
};

const allowedHeaders = [
    'authorization',
    'content-type',
].join(', ');

const allowedMethods = [
    'GET',
    'POST',
    'PATCH',
    'DELETE',
    'HEAD',
    'OPTIONS',
].join(', ');

function cors(req: Request, res: Response, next: NextFunction) {
    const origin = req.headers.origin;
    if (origin === undefined) {
        next();
        return;
    }

    //if (origin in allowedOrigins) {
    //    res.set('Access-Control-Allow-Origin', origin);
    //    res.vary('Origin');
    //}

    res.set('Access-Control-Allow-Origin', '*');

    res.set('Access-Control-Allow-Headers', allowedHeaders);
    res.set('Access-Control-Allow-Methods', allowedMethods);

    next();
}

function handleMySQLError(
    err: Error,
    req: Request,
    res: Response,
    next: NextFunction
): void {
    if (err instanceof MySQLError) {
        next(new UnknownDBError(err));
    } else {
        next(err);
    }
}

function handleHTTPError(
    err: Error,
    req: Request,
    res: Response,
    next: NextFunction
): void {
    if (err instanceof HTTPError) {
        const { statusCode, statusMessage, message } = err;
        if (message) {
            console.error(`HTTP ${statusCode} ${statusMessage}: ${message}`);
            res.status(statusCode);
            res.type('txt');
            res.send(message);
        } else {
            console.error(`HTTP ${statusCode} ${statusMessage}`);
            res.sendStatus(statusCode);
        }
        next();
    } else {
        next(err);
    }
}

function handleUnknownError(
    err: Error,
    req: Request,
    res: Response,
    next: NextFunction
): void {
    console.error(err);
    console.error(`HTTP 500 Internal Server Error`);

    if (development) {
        res.status(500);
        res.type('txt');
        res.send('Unknown error handling request. This shouldn\'t happen ' +
                 'and is probably a bug! Please report it.');
    } else {
        res.sendStatus(500);
    }
    next();
}

function setupRoutes(router: Router) {
    router.use(cors);

    router.use(bodyParser.json());
    router.use(bodyParser.urlencoded({ extended: false }));

    const profile = express.Router();
    const login = express.Router();
    const question = express.Router();
    const option = express.Router();
    const vote = express.Router();

    router.use('/profile', profile);
    router.use('/login', login);
    router.use('/question', question);
    router.use('/option', option);
    router.use('/vote', vote);

    setupProfile({ profile, login });
    setupQuestion(question);
    setupOption(option);
    setupVote(vote);

    router.use(handleMySQLError);
    router.use(handleHTTPError);
    router.use(handleUnknownError);

    router.use(closeDatabase);
}

export default setupRoutes;
