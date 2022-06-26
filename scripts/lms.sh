#! /bin/bash

pushd "$(dirname "$0")" > /dev/null

[ -z "${LMS_DIR}" ] && . common.sh
check_root

start_service() {
  pushd "${LMS_DIR}" > /dev/null
  COMPOSE_HTTP_TIMEOUT=120 docker-compose up -d
  popd > /dev/null
}

stop_service() {
  pushd "${LMS_DIR}" > /dev/null
  docker-compose stop
  popd > /dev/null
}

get_status() {
  if [ "$(is_running)" == '1' ]; then
    echo "Logitech Media Server is running"
  else
    echo "Logitech Media Server is not running"
  fi
}

# parse arguments
EXIT_CODE=0
for i in "$@"
do
case $i in
    start)
        start_service
        ;;
    stop)
        stop_service
        ;;
    status)
        get_status
        ;;
    *)
        echo "Unknown option ${i}. Valid: start | stop | status"
        EXIT_CODE=1
        ;;
esac
done

popd > /dev/null
exit $EXIT_CODE