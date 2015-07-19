#!/bin/bash

# Affichage de la liste des fichiers
vagrant up

# Affichage de la liste des fichiers
vagrant ssh -- -t "sudo service apache2 start"
