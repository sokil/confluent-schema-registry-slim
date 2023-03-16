log4j.rootLogger=$SCHEMA_REGISTRY_LOG4J_ROOT_LOGLEVEL, stdout, file

log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c:%L)%n

log4j.logger.kafka=ERROR, stdout
log4j.logger.org.apache.zookeeper=ERROR, stdout
log4j.logger.org.apache.kafka=ERROR, stdout
log4j.additivity.kafka.server=false

log4j.appender.file=org.apache.log4j.RollingFileAppender
log4j.appender.file.maxBackupIndex=10
log4j.appender.file.maxFileSize=100MB
log4j.appender.file.File=${schema-registry.log.dir}/schema-registry.log
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=[%d] %p %m (%c)%n
