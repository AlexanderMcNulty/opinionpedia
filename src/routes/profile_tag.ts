//
// The endpoint are:
//
// List    GET   /api/tag/profile/:profile_id
// Create  POST  /api/tag/profile
// Delete  DELETE  /api/tag/profile
//

import { Router } from 'express';

import { getConn } from './db.js';
import {
    ReferencedResourceNotFound,
    ResourceAlreadyExistsDBError,
} from './errors.js';
import {
    validateBodyProps,
    validateIdParam,
    validateRequestJWT,
    getProfileID,
    wrapAsync,
} from './util.js';

import { ERR_MYSQL_DUP_ENTRY, ERR_MYSQL_NO_REFERENCED_ROW } from '../db.js';
import { hasCode } from '../errors.js';

import * as model from '../models/profile_tag.js';

//
// Request body types
//
type ListTagsOnProfileReqBody = null;
type ListTagsOnProfileResBody = model.TagOnProfile[];

type CreateProfileTagReqBody = Omit<model.ProfileTag, 'profile_id'>;
type CreateProfileTagResBody = null;

type DeleteProfileTagReqBody = Omit<model.ProfileTag, 'profile_id'>;
type DeleteProfileTagResBody = null;

export default (router: Router): void => {
    // List tags on profile handler
    router.get(
        '/:profile_id',
        wrapAsync(async (req, res) => {
            const profile_id = validateIdParam(req.params.profile_id);

            const conn = await getConn(req);
            const tags: ListTagsOnProfileResBody = await model.getTagsOnProfile(
                conn,
                profile_id
            );

            res.json(tags);
        })
    );

    // Create profile tag handler
    router.post(
        '/',
        wrapAsync(async (req, res) => {
            const { tag_id } = validateBodyProps<CreateProfileTagReqBody>(
                req.body,
                {
                    tag_id: model.isIdValid,
                }
            );

            // Must be logged in to create a profile tag. IP address profiles
            // cannot have profile tags associated with them.
            const { profile_id } = await validateRequestJWT(req);

            const conn = await getConn(req);

            try {
                await model.createProfileTag(conn, {
                    tag_id,
                    profile_id,
                });
            } catch (err) {
                if (hasCode(err, ERR_MYSQL_DUP_ENTRY)) {
                    // This profile tag already existed.
                    throw new ResourceAlreadyExistsDBError();
                } else if (hasCode(err, ERR_MYSQL_NO_REFERENCED_ROW)) {
                    // The profile and/or tag doesn't exist in the database.
                    throw new ReferencedResourceNotFound();
                } else {
                    throw err;
                }
            }

            res.sendStatus(200);
        })
    );

    // Delete profile tag handler
    router.delete(
        '/:tag_id',
        wrapAsync(async (req, res) => {

            const tag_id = validateIdParam(req.params.tag_id);

            // Must be logged in to create a profile tag. IP address profiles
            // cannot have profile tags associated with them.
            const profile_id = await getProfileID(req);
            console.log('here');

            const conn = await getConn(req);
            console.log(tag_id + ", " + profile_id);
            console.log('here');

            try {
                console.log(tag_id + ", " + profile_id);
                await model.deleteProfileTag(conn, {
                    tag_id,
                    profile_id,
                });
            } catch (err) {
                if (hasCode(err, ERR_MYSQL_NO_REFERENCED_ROW)) {
                    // The profile and/or tag doesn't exist in the database.
                    throw new ReferencedResourceNotFound();
                } else {
                    throw err;
                }
            }

            res.sendStatus(200);
        })
    );
};
