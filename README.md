# PowerShell-GenericPester README

This generic pester repository is intended for use as a git submodule, subtree, or similar, across multiple PowerShell projects

## Background

All of my projects at work use a variant of the [ModuleValidation.Tests.ps1](ModuleValidation.Tests.ps1) file, which over time has had incremental changes which often get missed out of older projects, not to mention some hardcoded values that could be replaced with a dynamic lookup / some generic values  
  
Seeing how many places I've been using this, I felt it was time to create a dedicated git repository that I can reference across all my work to cover the basic tests needed to ensure no obvious errors are committed in a consistent manner

## Inspiriation

Inspiration for this project came from [Vexx32](https://github.com/vexx32/)'s own [ModuleValidation.Tests.ps1](https://github.com/vexx32/PSKoans/blob/master/Tests/ModuleValidation.Tests.ps1)

## Usage guide

- [ ] Add example of how to include as a submodule, subtree, and any other useful example
  
  ```powershell
  cd .\tests\
  git submodule add git@github.com:Taoquitok/PowerShell-GenericPester.git generic
  cd ..\
  invoke-pester .\tests\generic\ModuleValidation.Tests.ps1
  ```