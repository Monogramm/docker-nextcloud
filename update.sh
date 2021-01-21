#!/bin/bash
set -eo pipefail

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

min_version='17.0'
dockerLatest='20.0'


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
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)

	# Only add versions >= "$min_version"
	if version_greater_or_equal "$version" "$min_version"; then

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
					echo "$latest-$variant $variant $latest latest " > "$dir/.dockertags"
				else
					echo "$latest-$variant $variant " > "$dir/.dockertags"
				fi
			else
				if [ "$variant" = 'apache' ]; then
					echo "$latest-$variant $version-$variant $latest $version " > "$dir/.dockertags"
				else
					echo "$latest-$variant $version-$variant " > "$dir/.dockertags"
				fi
			fi

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

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
