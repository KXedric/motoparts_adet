# Security and privacy

**Last checked:** 2026-10-15

This describes the current source and configuration, rather than a full security audit.

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Motorcycle model, year, displacement, optional license plate, mileage, specifications, and image reference | Local Hive `motorcycle` box | Anyone using the app in the same device or browser profile |
| Parts, brands, categories, purchase details, warranty dates, installation notes, and image paths | Local Hive `parts` box | Anyone using the app in the same device or browser profile |
| Maintenance titles, service dates, mileage, notes, and timestamps | Local Hive `maintenance` box | Anyone using the app in the same device or browser profile |

`lib/services/hive_service.dart` opens these boxes locally. Web records live in browser storage; native records live in local application storage. Image fields hold references; the current screens do not implement photo uploads. No cloud database, account system, analytics service, or runtime ChatGPT integration is configured.

## Secrets

- The current application requires no runtime API keys or service credentials.
- `.env`, `.env.*` except `.env.example`, and `env.json` are git-ignored.
- The committed `.env.example` contains template Supabase settings. The app does not load them or connect to Supabase.
- The GitHub Pages workflow builds a static Flutter app. Supabase secret references are commented out, and no application secrets are passed into the build. Deployment uses GitHub Actions permissions.
- Web code and bundled assets are publicly readable. The application does not bundle locally saved user records into the deployed build.

## What protects the data

Saved records are not sent to a backend by the current application, so Firestore rules and Supabase RLS policies do not apply. Access depends on operating system and browser profile protections.

There is no login, app lock, or configured Hive encryption. Someone with access to the same app or its local storage may read or modify records. License plates and notes can contain personal information, so avoid exposing them on shared devices or in screenshots.

There is no cloud backup or synchronization. Clearing browser storage, uninstalling the app, or losing the device can remove records. The storage service provides deletion methods, but secure erasure and removal from device backups are not guaranteed.

## Checklist

- [x] `.env` and `env.json` are ignored, and `.env.example` is committed.
- [x] No `.env`, keystore, or service-account filename was found in the tracked-file and history filename checks performed for this update.
- [ ] A complete secret scan of file contents and all Git history remains to be performed. Filename checks do not establish that no credentials were ever committed.
- [x] No cloud database is configured; server-side security rules are not applicable.
- [ ] Confirm sample data, screenshots, and the demo video contain no real personal data before submission.
- [ ] Confirm no course or university credentials appear in repository contents or history.
- [ ] Obtain permission before using another person's data in tests or demonstrations; consent has not been verified here.

No key revocation is recorded by this documentation update.
