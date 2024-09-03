require 'logging'


# Configura o logger global
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :info