import 'package:cufs/cufs.dart' as cufs;

void main(List<String> arguments) {
  // This is an example of how to run the CLI programmatically.
  // In a real scenario, you would run this from the command line:
  // $ cufs create my_app

  print('Running CUFS example...');
  cufs.run(['--help']);
}
