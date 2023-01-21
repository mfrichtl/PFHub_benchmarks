#include "PFHub_benchmarksApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
PFHub_benchmarksApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  return params;
}

PFHub_benchmarksApp::PFHub_benchmarksApp(InputParameters parameters) : MooseApp(parameters)
{
  PFHub_benchmarksApp::registerAll(_factory, _action_factory, _syntax);
}

PFHub_benchmarksApp::~PFHub_benchmarksApp() {}

void
PFHub_benchmarksApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAll(f, af, syntax);
  Registry::registerObjectsTo(f, {"PFHub_benchmarksApp"});
  Registry::registerActionsTo(af, {"PFHub_benchmarksApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
PFHub_benchmarksApp::registerApps()
{
  registerApp(PFHub_benchmarksApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
PFHub_benchmarksApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  PFHub_benchmarksApp::registerAll(f, af, s);
}
extern "C" void
PFHub_benchmarksApp__registerApps()
{
  PFHub_benchmarksApp::registerApps();
}
