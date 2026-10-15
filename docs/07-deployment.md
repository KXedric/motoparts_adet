# Deploying MotoParts Manager

The app is configured for GitHub Pages at:

https://kxedric.github.io/motoparts_adet/

## One-time GitHub setup

1. Open https://github.com/KXedric/motoparts_adet/settings/pages while signed in as the repository owner.
2. Under **Build and deployment**, select **GitHub Actions** as the source.
3. In the repository's **Actions** tab, enable workflows if GitHub asks.
4. Commit the deployment files and push them to `main`.
5. Open **Actions > Deploy web demo** and wait for both `build` and `deploy` to succeed. You can also select **Run workflow** on `main` to deploy the code already on GitHub.
6. Open the deployment URL above. Future pushes to `main` deploy automatically.

No API keys, Supabase project, paid hosting, or custom domain are required by the current app. GitHub Actions supplies the deployment token automatically.

## Verify locally

```powershell
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter build web --release --base-href /motoparts_adet/
```

The workflow uploads `build/web` and deploys that artifact. The base path is required because this site lives under the repository name. The workflow derives it from the repository name automatically.

## Troubleshooting

- **Pages configuration or deployment fails:** Confirm the Pages source is GitHub Actions and that the repository owner has enabled Actions. Inspect the failing step's log in the Actions tab.
- **Deployment waits for approval:** Open the run and approve the `github-pages` environment deployment if repository protection rules require it.
- **404:** Confirm the deploy job succeeded and include `/motoparts_adet/` in the URL.
- **Blank screen or missing assets:** Check the browser console and confirm the build used the repository base path. Reload after a successful deployment.
- **Old version:** Check that the desired commit is on `main` and its workflow succeeded.
- **Analysis or test failures:** The current workflow reports these but continues deployment. A successful deployment alone does not mean those checks passed.

Records stay in the local browser profile through Hive; they are not shared between visitors or synchronized with the native app. Verify navigation, saving a record, and persistence after reload on the deployed site.

Reference: [GitHub Pages custom workflow documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages).
