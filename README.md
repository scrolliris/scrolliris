# Scrolliris

Text readability analysis platform utilizes anonymized data.


## Setup

### 0. Build base container image

```zsh
% docker image build -t scrolliris/gentoo:latest .

# check
% docker container run -it --rm scrolliris/gentoo:latest /bin/bash -V
```

### 1. Prepare seed files

Add your user account using seed files.

```zsh
% cp opt/seed/{users.sample.yml,users.yml}
% cp opt/seed/{user_emails.sample.yml,user_emails.yml}
```

### 2. Build/Start images

```zsh
# with --build
% make init

% make up
```


## License

`AGPL-3.0` (See also LICENSE of each project)

```txt
This is free software: You can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
```

```txt
Scrolliris
Copyright (c) 2017-2018 Lupine Software LLC
```
