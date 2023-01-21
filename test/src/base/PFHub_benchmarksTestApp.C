//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "PFHub_benchmarksTestApp.h"
#include "PFHub_benchmarksApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

InputParameters
PFHub_benchmarksTestApp::validParams()
{
  InputParameters params = PFHub_benchmarksApp::validParams();
  return params;
}

PFHub_benchmarksTestApp::PFHub_benchmarksTestApp(InputParameters parameters) : MooseApp(parameters)
{
  PFHub_benchmarksTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

PFHub_benchmarksTestApp::~PFHub_benchmarksTestApp() {}

void
PFHub_benchmarksTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  PFHub_benchmarksApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"PFHub_benchmarksTestApp"});
    Registry::registerActionsTo(af, {"PFHub_benchmarksTestApp"});
  }
}

void
PFHub_benchmarksTestApp::registerApps()
{
  registerApp(PFHub_benchmarksApp);
  registerApp(PFHub_benchmarksTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
PFHub_benchmarksTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  PFHub_benchmarksTestApp::registerAll(f, af, s);
}
extern "C" void
PFHub_benchmarksTestApp__registerApps()
{
  PFHub_benchmarksTestApp::registerApps();
}
