#!/bin/bash
psql -U postgres -d BD_NIVELAMENTO -c "CREATE TABLE exemplo (id SERIAL PRIMARY KEY, nome TEXT);"
