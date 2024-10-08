if(MPI_FOUND)
  # Save current values
  set(CMAKE_REQUIRED_INCLUDES_TMP ${CMAKE_REQUIRED_INCLUDES})
  set(CMAKE_REQUIRED_LIBRARIES_TMP ${CMAKE_REQUIRED_LIBRARIES})
  set(CMAKE_REQUIRED_FLAGS_TMP ${CMAKE_REQUIRED_FLAGS})
  # Set flags for building test program
  set(CMAKE_REQUIRED_INCLUDES ${MPI_INCLUDE_PATH})
  set(CMAKE_REQUIRED_LIBRARIES ${MPI_LIBRARIES})
  set(CMAKE_REQUIRED_FLAGS ${MPI_COMPILE_FLAGS})

  set(CODE_MPI_THREAD_MULTIPLE "#include<stdlib.h>\n#include <mpi.h>\n int main(int argc, char **argv) { int prov\; MPI_Init_thread (&argc, &argv, MPI_THREAD_MULTIPLE, &prov)\; MPI_Finalize ()\; return ((prov < MPI_THREAD_MULTIPLE) ? EXIT_FAILURE : EXIT_SUCCESS)\; }")
  set(tmp_name "${CMAKE_BINARY_DIR}/test_mpi_multiple.c")
  file(WRITE ${tmp_name} ${CODE_MPI_THREAD_MULTIPLE})
  execute_process(COMMAND ${MPI_C_COMPILER} -o ${tmp_name}.x ${tmp_name} RESULT_VARIABLE _res_compiles)
  if (NOT _res_compiles)
    execute_process(COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 3 ${tmp_name}.x ERROR_QUIET OUTPUT_QUIET OUTPUT_VARIABLE _out RESULT_VARIABLE _res_run)
    if (NOT _res_run)
      set(MPI_THREAD_MULTIPLE_OK ON)
    endif(NOT _res_run)
  endif(NOT _res_compiles)
  file(REMOVE ${tmp_name})
  file(REMOVE ${tmp_name}.x)
  # Restore previous values
  set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES_TMP})
  set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES_TMP})
  set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS_TMP})
endif()