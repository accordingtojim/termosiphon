within Thermosiphon_prelim;

model TestLoop_004
  /*****************************************************************************/
  package Medium = Modelica.Media.Water.StandardWater;
  Medium.BaseProperties bp;
  Medium.SaturationProperties sp;
  Modelica.SIunits.SpecificEnthalpy hls, hvs;
  Modelica.SIunits.MassFraction x;
  /*****************************************************************************/
  inner ThermoPower.System system annotation(
    Placement(visible = true, transformation(origin = {-190, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoPower.Water.Flow1DFV2ph evap(A = 0.01 * 0.05, Dhyd = 0.03, FFtype = ThermoPower.Choices.Flow1D.FFtypes.OpPoint, H = 0, HydraulicCapacitance = ThermoPower.Choices.Flow1D.HCtypes.Middle, L = 0.05, N = 4, Nt = 1, dpnom(displayUnit = "Pa") = 2000, fixedMassFlowSimplified = true, hstartin = 3e4, hstartout = 3e4, noInitialPressure = true, omega = 2 * (0.01 + 0.05), pstart = 2500, rhonom = 1000, wnm = 1000, wnom = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-110, 10}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  ThermoPower.Thermal.HeatSource1DFV HeatSrc(Nw = 3) annotation(
    Placement(visible = true, transformation(origin = {-110, -10}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Pheat(y = 100) annotation(
    Placement(visible = true, transformation(origin = {-150, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tsink(y = 273.15 + 20) annotation(
    Placement(visible = true, transformation(origin = {-150, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression wloop(y = 0.001) annotation(
    Placement(visible = true, transformation(origin = {-150, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoPower.Water.SinkPressure snk(h = 3e4, p0 = 2500) annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoPower.Water.SourcePressure src(h = 3e4, p0 = 2500 + 100) annotation(
    Placement(visible = true, transformation(origin = {-150, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoPower.Thermal.TempSource1DFV TempSnk(Nw = 3) annotation(
    Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  ThermoPower.Thermal.ConvHTFV conv_cond(G = 4, Nv = 3) annotation(
    Placement(visible = true, transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoPower.Water.Flow1DFV2ph cond(A = 0.01 * 0.05, Dhyd = 0.03, FFtype = ThermoPower.Choices.Flow1D.FFtypes.OpPoint, H = 0, HydraulicCapacitance = ThermoPower.Choices.Flow1D.HCtypes.Middle, L = 0.05, N = 4, Nt = 1, dpnom(displayUnit = "Pa") = 2000, fixedMassFlowSimplified = true, hstartin = 3e4, hstartout = 3e4, noInitialPressure = true, omega = 2 * (0.01 + 0.05), pstart = 2500, rhonom = 1000, wnm = 1000, wnom = 0.011) annotation(
    Placement(visible = true, transformation(origin = {-30, 10}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
equation
/*****************************************************************************/
  bp.p = evap.fluidState[4].p;
  bp.h = evap.fluidState[4].h;
  sp = bp.sat;
  hls = Medium.bubbleEnthalpy(sp);
  hvs = Medium.dewEnthalpy(sp);
  x = (bp.h - hls) / (hvs - hls);
/*****************************************************************************/
  connect(HeatSrc.wall, evap.wall) annotation(
    Line(points = {{-110, -7}, {-110, 5}}, color = {255, 127, 0}));
  connect(Pheat.y, HeatSrc.power) annotation(
    Line(points = {{-139, -30}, {-110, -30}, {-110, -14}}, color = {0, 0, 127}));
  connect(src.flange, evap.infl) annotation(
    Line(points = {{-140, 10}, {-120, 10}}, color = {0, 0, 255}));
  connect(conv_cond.side2, TempSnk.wall) annotation(
    Line(points = {{-30, -14}, {-30, -26}}, color = {255, 127, 0}));
  connect(cond.wall, conv_cond.side1) annotation(
    Line(points = {{-30, 6}, {-30, -6}}, color = {255, 127, 0}));
  connect(Tsink.y, TempSnk.temperature) annotation(
    Line(points = {{-138, -70}, {-30, -70}, {-30, -34}}, color = {0, 0, 127}));
  connect(cond.outfl, snk.flange) annotation(
    Line(points = {{-20, 10}, {20, 10}}, color = {0, 0, 255}));
  connect(evap.outfl, cond.infl) annotation(
    Line(points = {{-100, 10}, {-40, 10}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-6, Interval = 1.2),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"));
end TestLoop_004;