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

previous_outputs=()

add_and_print() {
    previous_outputs+=("$1")
    print_previous_outputs
}

print_previous_outputs() {
    clear
    for output in "${previous_outputs[@]}"; do
        echo -e "$output"
    done
}

# ----------------------------------------------------------------------------------------------
# Installation
# ----------------------------------------------------------------------------------------------

clear
echo -e "${GREEN}█ █▄░█ █▀ ▀█▀ ▄▀█ █░░ █░░${NC}"
echo -e "${GREEN}█ █░▀█ ▄█ ░█░ █▀█ █▄▄ █▄▄${NC}"
echo ""
echo "Creating a new React app with Vite and TypeScript"
echo ""

echo "Enter an installation directory: (the directory will be created if it does not exist)"
read install_dir

if [ ! -d "$install_dir" ]; then
    echo "Directory does not exist. Creating directory..."
    sudo mkdir -p $install_dir
    add_and_print "Creating directory               ${GREEN_BOLD}Done!${NC}"
fi

cd $install_dir

echo "Enter a project name: "
read project_name
clear

# ----------------------------------------------------------------------------------------------
# Create app
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Creating app...${NC}"
npx create-vite@latest $project_name --template react-ts
cd $project_name
add_and_print "Creating app                         ${GREEN_BOLD}Done!${NC}"

# ----------------------------------------------------------------------------------------------
# Install dependencies
# ----------------------------------------------------------------------------------------------

dependencies=(
    "react"
    "react-dom"
    "react-router-dom"
    "react-icons"
    "react-error-boundary"
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
    "npm-check-updates"
)

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

print_previous_outputs

echo "Installing dependencies..."
npm install --save "${dependencies[@]}"
add_and_print "Installing dependencies              ${GREEN_BOLD}Done!${NC}"
sleep 2

echo "Installing dev dependencies..."
npm install --save-dev "${dev_dependencies[@]}"
add_and_print "Installing dev dependencies          ${GREEN_BOLD}Done!${NC}"

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

add_and_print "Setting up Vite                      ${GREEN_BOLD}Done!${NC}"

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
        "allowSyntheticDefaultImports": true,
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

add_and_print "Setting up TypeScript                ${GREEN_BOLD}Done!${NC}"

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

add_and_print "Creating files and folders           ${GREEN_BOLD}Done!${NC}"

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

add_and_print "Setting up Git                       ${GREEN_BOLD}Done!${NC}"

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

add_and_print "Setting up ESLint                    ${GREEN_BOLD}Done!${NC}"

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

add_and_print "Setting up Prettier                  ${GREEN_BOLD}Done!${NC}"

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

add_and_print "Setting up Husky and lint-staged     ${GREEN_BOLD}Done!${NC}"

# ----------------------------------------------------------------------------------------------
# Set up npm-check-updates
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Setting up npm-check-updates...${NC}"


npm pkg set scripts.upgrade="ncu --interactive --format group"

add_and_print "Setting up npm-check-updates         ${GREEN_BOLD}Done!${NC}"

# ----------------------------------------------------------------------------------------------
# Pre-linting and formatting
# ----------------------------------------------------------------------------------------------

echo -e "${BOLD}Linting and formatting...${NC}"

npm run lint:fix
npm run format

add_and_print "Linting and formatting               ${GREEN_BOLD}Done!${NC}"

# ----------------------------------------------------------------------------------------------
# Installation complete
# ----------------------------------------------------------------------------------------------

add_and_print "\n${GREEN_BOLD}Installation complete!${NC}\n"
echo -e "${UNDERLINE}To start the development server, run:${NC}"
echo ""
echo -e "${BLUE_BOLD}cd $install_dir/$project_name && npm run dev${NC}"
echo ""
echo "Happy coding!"
echo ""
