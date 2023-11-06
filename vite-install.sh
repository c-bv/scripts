#!/bin/bash

# ----------------------------------------------------------------------------------------------
# Library
# ----------------------------------------------------------------------------------------------
BOLD='\033[1m'
UNDERLINE='\033[4m'

GREEN='\033[0;32m'
BLUE='\033[0;34m'

GREEN_BOLD='\033[1;32m'
BLUE_BOLD='\033[1;34m'

NC='\033[0m'

# ----------------------------------------------------------------------------------------------
# Installation
# ----------------------------------------------------------------------------------------------

clear
echo -e "${GREEN}█ █▄░█ █▀ ▀█▀ ▄▀█ █░░ █░░${NC}"
echo -e "${GREEN}█ █░▀█ ▄█ ░█░ █▀█ █▄▄ █▄▄${NC}"
echo ""
echo "Creating a new React app with Vite and TypeScript"
echo "Enter a project name: "
read project_name

# ----------------------------------------------------------------------------------------------
# Create app
# ----------------------------------------------------------------------------------------------

npx create-vite@latest $project_name --template react-ts
cd $project_name
clear

# ----------------------------------------------------------------------------------------------
# Install dependencies
# ----------------------------------------------------------------------------------------------

dependencies=(
    "react"
    "react-router-dom"
    "react-icons"
)

dev_dependencies=(
    "@types/node"
    "@typescript-eslint/eslint-plugin"
    "@typescript-eslint/parser"
    "eslint"
    "eslint-plugin-react"
    "eslint-plugin-react-hooks"
    "husky"
    "lint-staged"
    "prettier"
    "typescript"
    "vite"
    "vite-plugin-eslint"
)

echo ""
echo -e "${BOLD}${UNDERLINE}The following dependencies will be installed:${NC}"
for dep in "${dependencies[@]}"; do
    echo "- $dep"
done
echo ""
echo -e "${BOLD}${UNDERLINE}The following dev dependencies will be installed:${NC}"
for dep in "${dev_dependencies[@]}"; do
    echo "- $dep"
done
echo ""

while true; do
    read -p "DO YOU WANT TO CONTINUE? (y/n) " yn
    case $yn in
    [Yy]*)
        break
        ;;
    [Nn]*)
        exit
        break
        ;;
    *) echo "Please answer yes or no." ;;
    esac
done
clear

echo "Installing dependencies..."
npm install --save "${dependencies[@]}"
echo -e "${GREEN_BOLD}Done!${NC}"
sleep 2
clear

echo ""
echo "Installing dev dependencies..."
npm install --save-dev "${dev_dependencies[@]}"
echo -e "${GREEN_BOLD}Done!${NC}"
clear

# ----------------------------------------------------------------------------------------------
# Set up Vite
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Setting up Vite...${NC}"

vite_config_content=$(
    cat <<END
import react from '@vitejs/plugin-react';
import path from 'path';
import { defineConfig, loadEnv } from 'vite';
import eslint from 'vite-plugin-eslint';

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
    return {
        plugins: [react(), eslint({ cache: false })],
        server: {
            port: 3000
        },
        define: {
            __APP_ENV__: loadEnv(mode, process.cwd(), '')
        },
        resolve: {
            alias: {
                '@': path.resolve(__dirname, './src'),
                '@assets': path.resolve(__dirname, './src/assets'),
                '@components': path.resolve(__dirname, './src/components'),
                '@contexts': path.resolve(__dirname, './src/contexts'),
                '@hooks': path.resolve(__dirname, './src/hooks'),
                '@lib': path.resolve(__dirname, './src/lib'),
                '@pages': path.resolve(__dirname, './src/pages'),
                '@utils': path.resolve(__dirname, './src/utils')
            }
        }
    };
});
END
)

echo "$vite_config_content" >vite.config.ts

echo -e "${GREEN_BOLD}Done!${NC}"
echo ""

# ----------------------------------------------------------------------------------------------
# Set up TypeScript
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Setting up TypeScript...${NC}"

tsconfig_content=$(
    cat <<END
{
    "compilerOptions": {
        "target": "ESNext",
        "useDefineForClassFields": true,
        "lib": ["DOM", "DOM.Iterable", "ESNext"],
        "module": "ESNext",
        "skipLibCheck": true,

        /* Bundler mode */
        "moduleResolution": "Node",
        "allowImportingTsExtensions": true,
        "resolveJsonModule": true,
        "isolatedModules": true,
        "noEmit": true,
        "jsx": "react-jsx",

        /* Linting */
        "strict": true,
        "noUnusedLocals": true,
        "noUnusedParameters": true,
        "noFallthroughCasesInSwitch": true,

        /* Paths */
        "paths": {
            "@*": ["./src/*"],
            "@assets/*": ["./src/assets/*"],
            "@components/*": ["./src/components/*"],
            "@contexts/*": ["./src/contexts/*"],
            "@hooks/*": ["./src/hooks/*"],
            "@lib/*": ["./src/lib/*"],
            "@pages/*": ["./src/pages/*"],
            "@utils/*": ["./src/utils/*"]
        }
    },
    "include": ["src"],
    "references": [{ "path": "./tsconfig.node.json" }]
}
END
)

echo "$tsconfig_content" >tsconfig.json

echo -e "${GREEN_BOLD}Done!${NC}"
echo ""

# ----------------------------------------------------------------------------------------------
# Create files and folders
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Creating files and folders...${NC}"

mkdir -p src/assets
mkdir -p src/components
mkdir -p src/contexts
mkdir -p src/hooks
mkdir -p src/lib
mkdir -p src/pages
mkdir -p src/utils

touch .env
touch .env.development.local
touch .env.example

echo "# $project_name" >README.md

echo -e "${GREEN_BOLD}Done!${NC}"
echo ""

# ----------------------------------------------------------------------------------------------
# Set up Git
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Setting up Git...${NC}"

git init -b main

gitignore_content=$(
    cat <<END
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

node_modules
dist
dist-ssr
*.local
.env

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
END
)

echo "$gitignore_content" >.gitignore

echo -e "${GREEN_BOLD}Done!${NC}"
echo ""

# ----------------------------------------------------------------------------------------------
# Set up ESLint
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Setting up ESLint...${NC}"

eslintrc_content=$(
    cat <<END
module.exports = {
    root: true,
    env: { browser: true, es2021: true },
    extends: [
        'eslint:recommended',
        'plugin:@typescript-eslint/recommended',
        'plugin:react/recommended',
        'plugin:react-hooks/recommended'
    ],
    ignorePatterns: ['dist', '.eslintrc.cjs'],
    parser: '@typescript-eslint/parser',
    parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module'
    },
    plugins: ['@typescript-eslint', 'react', 'react-refresh'],
    rules: {
        semi: 'error',
        'react/prop-types': 'off',
        'react/react-in-jsx-scope': 'off',
        '@typescript-eslint/explicit-module-boundary-types': 'off',
        '@typescript-eslint/no-explicit-any': 'off',
        '@typescript-eslint/no-var-requires': 'off',
        'react-refresh/only-export-components': ['warn', { allowConstantExport: true }]
    },
    settings: {
        react: { version: 'detect' }
    }
};
END
)

echo "$eslintrc_content" >.eslintrc.cjs

npm pkg set scripts.lint:fix="eslint . --ext ts,tsx --fix"

echo -e "${GREEN_BOLD}Done!${NC}"
echo ""

# ----------------------------------------------------------------------------------------------
# Set up Prettier
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Setting up Prettier...${NC}"

prettierrc_content=$(
    cat <<END
{
    "tabWidth": 4,
    "semi": true,
    "singleQuote": true,
    "jsxSingleQuote": true,
    "printWidth": 120,
    "trailingComma": "none",
    "arrowParens": "avoid",
    "plugins": []
}
END
)

echo "$prettierrc_content" >.prettierrc

npm pkg set scripts.format="prettier --write './**/*.{js,jsx,ts,tsx,css,md,json}' --config ./.prettierrc"

echo -e "${GREEN_BOLD}Done!${NC}"
echo ""

# ----------------------------------------------------------------------------------------------
# Set up Husky and lint-staged
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Setting up Husky and lint-staged...${NC}"

lintstagedrc_content=$(
    cat <<END
module.exports = {
    '*.{js,jsx,ts,tsx}': ['eslint --fix', 'prettier --write'],
    '*.{css,md,json}': ['prettier --write'],
};
END
)

echo "$lintstagedrc_content" >.lintstagedrc.cjs

npm pkg set scripts.prepare="husky install"
npm run prepare
npx husky add .husky/pre-commit "npx lint-staged --config ./.lintstagedrc.cjs"

echo -e "${GREEN_BOLD}Done!${NC}"
echo ""

# ----------------------------------------------------------------------------------------------
# Pre-linting and formatting
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Linting and formatting...${NC}"

npm run lint:fix
npm run format

echo ""
echo -e "${GREEN_BOLD}Done!${NC}"

# ----------------------------------------------------------------------------------------------
# Installation complete
# ----------------------------------------------------------------------------------------------

sleep 5
clear
echo -e "${GREEN_BOLD}Installation complete!${NC}"
echo "To start the development server, run:"
echo ""
echo -e "${BLUE_BOLD}cd $project_name && npm run dev${NC}"
echo ""
echo "Happy coding!"
echo ""
