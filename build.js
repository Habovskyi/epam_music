#!/usr/bin/env node

import esbuild from "esbuild";
import svgrPlugin from "esbuild-plugin-svgr"
import { sassPlugin } from "esbuild-sass-plugin";
import postcss from 'postcss';
import autoprefixer from 'autoprefixer';

esbuild.build({
    entryPoints: ["app/javascript/active_admin.js"],
    logLevel: "debug",
    bundle: true,
    outdir: 'app/assets/builds',
    metafile: true,
    plugins: [
        sassPlugin({
            async transform(source) {
                const { css } = await postcss([autoprefixer]).process(source);
                return css;
            },
        }),
        svgrPlugin(),
    ],
});
