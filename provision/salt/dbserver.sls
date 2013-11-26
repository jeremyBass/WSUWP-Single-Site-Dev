group-mysql:
  group.present:
    - name: mysql

user-mysql:
  user.present:
    - name: mysql
    - groups:
      - mysql
    - require_in:
      - pkg: mysql

user-vagrant:
  user.present:
    - name: vagrant
    - groups:
      - vagrant
      - www-data
      - mysql
    - require:
      - group: www-data
      - group: mysql
    - require_in:
      - cmd: wp-cli
      - pkg: mysql

/var/log/mysql:
  file.directory:
    - user: mysql
    - group: mysql
    - dir_mode: 775
    - file_mode: 664
    - recurse:
        - user
        - group
        - mode

mysql:
  pkg.installed:
    - pkgs:
      - mysql
      - mysql-libs
      - mysql-server
      - MySQL-python

/etc/my.cnf:
  file.managed:
    - source: salt://config/mysql/my.cnf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: mysql

mysql-start:
  service.running:
    - name: mysqld
    - watch:
      - file: /etc/my.cnf
    - require:
      - file: /etc/my.cnf
