#!/bin/bash
set -eo pipefail

declare -A conf=(
	[apache]=''
	[fpm]='nginx'
	[fpm-alpine]='nginx'
)

declare -A compose=(
	[apache]='apache'
	[fpm]='fpm'
	[fpm-alpine]='fpm'
)

declare -A base=(
	[apache]='debian'
	[fpm]='debian'
	[fpm-alpine]='alpine'
)

variants=(
	apache
	fpm
	fpm-alpine
)

min_version='19.0'
dockerLatest='22.1'


# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

dockerRepo="monogramm/docker-nextcloud"
fullversions=( $( curl -fsSL 'https://download.nextcloud.com/server/releases/' |tac|tac| \
	grep -oE 'nextcloud-[[:digit:]]+(\.[[:digit:]]+){2}' | \
	grep -oE '[[:digit:]]+(\.[[:digit:]]+){2}' | \
	sort -urV ) )
latests=( $( printf '%s\n' "${fullversions[@]}" | cut -d. -f1-2 | sort -urV ) )

# Remove existing images
echo "reset docker images"
find ./images -maxdepth 1 -type d -regextype sed -regex '\./images/[[:digit:]]\+\.[[:digit:]]\+' -exec rm -r '{}' \;

echo "update docker images"
readmeTags=
githubEnv=
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)

	# Only add versions >= "$min_version"
	if version_greater_or_equal "$version" "$min_version"; then

		if [ ! -d "images/$version" ]; then
			# Add GitHub Actions env var
			githubEnv="'$version', $githubEnv"
		fi

		for variant in "${variants[@]}"; do
			echo "updating $latest [$version] $variant"

			# Create the version+php_version+variant directory with a Dockerfile.
			dir="images/$version/$variant"
			if [ -d "$dir" ]; then
				continue
			fi
			mkdir -p "$dir"

			template="Dockerfile.${base[$variant]}.template"
			cp "template/$template" "$dir/Dockerfile"

			cp -r "template/hooks/" "$dir/"
			cp -r "template/test/" "$dir/"
			cp "template/.env" "$dir/.env"
			cp "template/.dockerignore" "$dir/.dockerignore"
			cp "template/docker-compose.${compose[$variant]}.test.yml" "$dir/docker-compose.test.yml"

			if [ -n "${conf[$variant]}" ] && [ -d "template/${conf[$variant]}" ]; then
				cp -r "template/${conf[$variant]}" "$dir/${conf[$variant]}"
			fi

			# Replace the docker variables.
			sed -ri -e '
				s/%%VERSION%%/'"$version"'/g;
				s/%%VARIANT%%/'"$variant"'/g;
			' "$dir/Dockerfile"

			sed -ri -e '
				s|DOCKER_TAG=.*|DOCKER_TAG='"$version-$variant"'|g;
				s|DOCKER_REPO=.*|DOCKER_REPO='"$dockerRepo"'|g;
			' "$dir/hooks/run"

			# Create a list of "alias" tags for DockerHub post_push
			if [ "$latest" = "$dockerLatest" ]; then
				if [ "$variant" = 'apache' ]; then
					export DOCKER_TAGS="$latest-$variant $variant $latest latest "
				else
					export DOCKER_TAGS="$latest-$variant $variant "
				fi
			else
				if [ "$variant" = 'apache' ]; then
					export DOCKER_TAGS="$latest-$variant $latest "
				else
					export DOCKER_TAGS="$latest-$variant "
				fi
			fi
			echo "${DOCKER_TAGS}" > "$dir/.dockertags"

			# Add README.md tags
			readmeTags="$readmeTags\n-   \`$dir/Dockerfile\`: $(cat $dir/.dockertags)<!--+tags-->"

			# Add Travis-CI env var
			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant$travisEnv"

			if [[ $1 == 'build' ]]; then
				tag="$version-$version-$variant"
				echo "Build Dockerfile for ${tag}"
				docker build -t "${dockerRepo}:${tag}" "$dir"
			fi
		done

	fi

done

# update README.md
sed -i -e '/^-   .*<!--+tags-->/d' README.md
readme="$(awk -v 'RS=\n\n' '$1 == "Tags:" { $0 = "Tags:'"$readmeTags"'" } { printf "%s%s", $0, RS }' README.md)"
echo "$readme" > README.md

# update .github workflows
sed -i -e "s|version: \[.*\]|version: [${githubEnv}]|g" .github/workflows/hooks.yml

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
