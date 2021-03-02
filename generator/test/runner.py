"""
All tests
"""
import logging
import sys
from pathlib import Path
from unittest import TestLoader, TestSuite, TextTestRunner

ROOT = Path(__file__).absolute()

sys.path.append(ROOT.parents[1].joinpath('rpc_spec/InterfaceParser').as_posix())
sys.path.append(ROOT.parents[1].as_posix())

try:
    from test_enums import TestEnumsProducer
    from test_functions import TestFunctionsProducer
    from test_structs import TestStructsProducer
    from test_CodeFormatAndQuality import CodeFormatAndQuality
except ImportError as error:
    print('{}.\nProbably you did not initialize submodule'.format(error))
    sys.exit(1)


def config_logging():
    """
    Configuring logging for all application
    """
    handler = logging.StreamHandler()
    handler.setFormatter(logging.Formatter(fmt='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                                           datefmt='%m-%d %H:%M'))
    root_logger = logging.getLogger()
    handler.setLevel(logging.INFO)
    root_logger.setLevel(logging.INFO)
    root_logger.addHandler(handler)


def main():
    """
    Without performing Tests (simple instances initialization) there are following initial test code coverage:
    generator/transformers/common_producer.py		21%
    generator/transformers/enums_producer.py		24%
    generator/transformers/functions_producer.py	18%
    generator/transformers/structs_producer.py		32%

    After performing Tests there are following initial test code coverage:
    generator/transformers/common_producer.py		100%
    generator/transformers/enums_producer.py		100%
    generator/transformers/functions_producer.py	100%
    generator/transformers/structs_producer.py		100%
    """
    config_logging()
    suite = TestSuite()

    suite.addTests(TestLoader().loadTestsFromTestCase(TestFunctionsProducer))
    suite.addTests(TestLoader().loadTestsFromTestCase(TestStructsProducer))
    suite.addTests(TestLoader().loadTestsFromTestCase(TestEnumsProducer))
    suite.addTests(TestLoader().loadTestsFromTestCase(CodeFormatAndQuality))

    runner = TextTestRunner(verbosity=2)
    test_results = runner.run(suite)

    if test_results.wasSuccessful():
        exit(0)
    else:
        exit(1)


if __name__ == '__main__':
    """
    Entry point for parser and generator.
    """
    main()
