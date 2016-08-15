// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:wildfire/wildfire.dart';
import 'dart:io';

main() async {
  try {
    var configFileName = "config.yaml";
    var config = new WildfireConfiguration(configFileName);

    var path = "api.log";
    var logger = new LoggingServer([new RotatingLoggingBackend(path)]);
    await logger.start();

    var app = new Application<WildfirePipeline>();
    app.configuration.port = config.port;
    app.configuration.pipelineOptions = {
      WildfirePipeline.LoggingTargetKey : logger.getNewTarget(),
      WildfirePipeline.ConfigurationFileKey : configFileName
    };

    await app.start(numberOfInstances: 3);
  } on IsolateSupervisorException catch (e, st) {
    writeError("IsolateSupervisorException, server failed to start: ${e.message} $st");
  } catch (e, st) {
    writeError("Server failed to start: $e $st");
  }
}

void writeError(String error) {
  var file = new File("error.log");
  file.writeAsStringSync(error);
}
