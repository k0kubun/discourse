# discourse bench

## Setup

### 1. Prepare database for RAILS\_ENV=profile

```bash
sudo su postgres
createuser --createdb --superuser -Upostgres k0kubun
psql -c "ALTER USER k0kubun WITH PASSWORD 'password';"
psql -c "create database discourse_profile owner k0kubun encoding 'UTF8' TEMPLATE template0;"
psql -d discourse_profile -c "CREATE EXTENSION hstore;"
psql -d discourse_profile -c "CREATE EXTENSION pg_trgm;"
exit
```

### 2. Setup environment and benchmark with unicorn

```bash
# Without JIT
ruby script/bench.rb --unicorn

# With JIT
ruby script/bench.rb --unicorn --rubyopt="--jit"
```

### 3. Simple bench with "/"

```bash
ruby script/simple_bench.rb
```

## Copyright / License

Copyright 2014 - 2017 Civilized Discourse Construction Kit, Inc.

Licensed under the GNU General Public License Version 2.0 (or later);
you may not use this work except in compliance with the License.
You may obtain a copy of the License in the LICENSE file, or at:

   http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Discourse logo and “Discourse Forum” ®, Civilized Discourse Construction Kit, Inc.

## Dedication

Discourse is built with [love, Internet style.](http://www.youtube.com/watch?v=Xe1TZaElTAs)
