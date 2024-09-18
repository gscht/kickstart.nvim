local ls = require 'luasnip'
--local types = require "luasnip.util.types"
local s = ls.snippet
local fmt = require('luasnip.extras.fmt').fmta
local i = ls.insert_node
local rep = require('luasnip.extras').rep

-- Java snippets
ls.add_snippets('java', {
  s(
    {
      trig = 'psvm',
      name = 'main',
    },
    fmt(
      [[
        public static void main(String args[]) {
          <>
        }
      ]],
      {
        i(1, 'Here goes'),
      }
    )
  ),
  s(
    'psf',
    fmt('private static final <> <> = <>;', {
      i(1, 'type'),
      i(2, 'name'),
      i(3, 'value'),
    })
  ),
  s(
    'sout',
    fmt('System.out.println("<>".formatted(<>));', {
      i(1, ''),
      i(2, ''),
    })
  ),
  s(
    'OON',
    fmt('Optional.ofNullable(<>).', {
      i(1, 'nullable'),
    })
  ),
}, {
  key = 'java',
})

-- Yaml snippet
-- Liquibase
ls.add_snippets('yaml', {
  s(
    'cs',
    fmt(
      [[
        - changeSet:
            id: '<>'
            author: guenther.schroettner
            comment: <>
            changes:
              <>
      ]],
      {
        i(1, 'changeSetNumber'),
        i(2, 'comment'),
        i(3, ''),
      }
    )
  ),
  s(
    'ct',
    fmt(
      [[
        - createTable:
            schemaName: robot
            tableName: <>
            columns:
              - column:
                  name: id
                  type: serial
                  autoIncrement: true
                  constraints:
                    primaryKey: true
                    primaryKeyName: pk_<>
      ]],
      {
        i(1, 'table_name'),
        rep(1),
      }
    )
  ),
  s(
    'addCol',
    fmt(
      [[
        - addColumn:
            schemaName: robot
            tableName: <>
            columns:
              - column:
                  name: <>
                  type: <>
                  constraints:
                    nullable: false
      ]],
      {
        i(1, 'table_name'),
        i(2, 'column_name'),
        i(3, 'column_type'),
      }
    )
  ),
  s(
    'addFkCol',
    fmt(
      [[
        - addColumn:
            schemaName: robot
            tableName: <>
            columns:
              - column:
                  name: <>
                  type: <>
                  constraints:
                    nullable: false
                    referencedTableSchemaName: robot
                    referencedTableName: <>
                    referencedColumnNames: <>
                    foreignKeyName: FK_<>_<>__<>

      ]],
      {
        i(1, 'table_name'),
        i(2, 'column_name'),
        i(3, 'column_type'),
        i(4, 'referenced_table_name'),
        i(5, 'id'),
        rep(4),
        rep(5),
        rep(2),
      }
    )
  ),
  s(
    'col',
    fmt(
      [[
              - column:
                  name: <>
                  type: <>
                  constraints:
                    nullable: false
      ]],
      {
        i(1, 'column_name'),
        i(2, 'column_type'),
      }
    )
  ),
  s(
    'addFkConstraint',
    fmt(
      [[
        - addForeignKeyConstraint:
            baseTableSchemaName: robot
            baseTableName: <>
            baseColumnNames: <>
            referencedTableSchemaName: robot
            referencedTableName: <>
            referencedColumnNames: <>
            constraintName: fk_<>_<>__<>
      ]],
      {
        i(1, 'base_table_name'),
        i(2, 'base_column_name'),
        i(3, 'referenced_table_name'),
        i(4, 'id'),
        rep(3),
        rep(4),
        rep(2),
      }
    )
  ),
  s(
    'idx',
    fmt(
      [[
        - createIndex:
            schemaName: robot
            tableName: <>
            indexName: ix_<>__<>
            unique: false
            columns:
              - column:
                  name: <>

      ]],
      {
        i(1, 'table_name'),
        rep(1),
        rep(2),
        i(2, 'column_name'),
      }
    )
  ),
}, {
  key = 'yaml',
})
