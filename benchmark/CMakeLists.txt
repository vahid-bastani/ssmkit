
find_package(Threads QUIET)
find_package( OpenCV QUIET)
#find_package( Benchmark REQUIRED)

if (OpenCV_FOUND)
  message (STATUS "OpenCV Found: opencv comparison is added to the benchmark")
  add_definitions(-DWITH_OpenCV)
endif ()

add_executable(bm EXCLUDE_FROM_ALL kalman.cpp)
target_link_libraries(bm benchmark ${OpenCV_LIBS} ${ARMADILLO_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
