#############################################################################################################################
# file:  CMakeLists.txt
# brief: Template "CMakeLists.txt" for building of executables and static libraries.
#
# usage: Edit "VARIABLES"-section to suit project requirements.
#        For debug build:
#          cmake -DCMAKE_TOOLCHAIN_FILE=cubeide-gcc.cmake  -S ./ -B Debug -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug
#          make -C Debug VERBOSE=1
#        For release build:
#          cmake -DCMAKE_TOOLCHAIN_FILE=cubeide-gcc.cmake  -S ./ -B Release -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release
#          make -C Release VERBOSE=1
#############################################################################################################################
cmake_minimum_required(VERSION 3.20)

###################### CONSTANTS ######################################
set (PROJECT_TYPE_EXECUTABLE          "exe")
set (PROJECT_TYPE_STATIC_LIBRARY      "static-lib")
set (MCPU_CORTEX_M0				      "-mcpu=cortex-m0")
set (MCPU_CORTEX_M0PLUS				  "-mcpu=cortex-m0plus")
set (MCPU_CORTEX_M3				      "-mcpu=cortex-m3")
set (MCPU_CORTEX_M4				      "-mcpu=cortex-m4")
set (MCPU_CORTEX_M7				      "-mcpu=cortex-m7")
set (MCPU_CORTEX_M33				  "-mcpu=cortex-m33")
set (MCPU_CORTEX_M55				  "-mcpu=cortex-m55")
set (MCPU_CORTEX_M85				  "-mcpu=cortex-m85")
set (MFPU_FPV4_SP_D16                 "-mfpu=fpv4-sp-d16")
set (MFPU_FPV5_D16                    "-mfpu=fpv5-d16")
set (RUNTIME_LIBRARY_REDUCED_C        "--specs=nano.specs")
set (RUNTIME_LIBRARY_STD_C            "")
set (RUNTIME_LIBRARY_SYSCALLS_MINIMAL "--specs=nosys.specs")
set (RUNTIME_LIBRARY_SYSCALLS_NONE    "")
set (MFLOAT_ABI_SOFTWARE              "-mfloat-abi=soft")
set (MFLOAT_ABI_HARDWARE              "-mfloat-abi=hard")
set (MFLOAT_ABI_MIX                   "-mfloat-abi=softfp")
#######################################################################

###################### VARIABLES ######################################
set (PROJECT_NAME             "blackpill")
set (PROJECT_TYPE             "exe")
set (LINKER_SCRIPT            "../STM32F411CEUX_FLASH.ld")
set (MCPU                     "-mcpu=Cortex-M4")
set (MFPU                 "-mfpu=fpv4-sp-d16")
set (MFLOAT_ABI               "-mfloat-abi=hard")
set (RUNTIME_LIBRARY          "--specs=nano.specs")
set (RUNTIME_LIBRARY_SYSCALLS "--specs=nosys.specs")

set(STM32_DRIVER_DIR "STM32_SDK/STM32CubeF4/Drivers/STM32F4xx_HAL_Driver")

set(CMSIS_DRIVER_DIR "STM32_SDK/STM32CubeF4/Drivers/CMSIS")

set (PROJECT_SOURCES
  "Core/src/main.c"
  "${CMSIS_DRIVER_DIR}/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c"
  "${CMSIS_DRIVER_DIR}/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f411xe.s"
  "${STM32_DRIVER_DIR}/Src/stm32f4xx_hal_cortex.c"
  "${STM32_DRIVER_DIR}/Src/stm32f4xx_hal_gpio.c"
  "${STM32_DRIVER_DIR}/Src/stm32f4xx_hal_rcc.c"
  "${STM32_DRIVER_DIR}/Src/stm32f4xx_hal.c"
)

set (PROJECT_DEFINES
    STM32F411xE
)

set (PROJECT_INCLUDES
  "Core/includes"
  "${STM32_DRIVER_DIR}/Inc"
  "${CMSIS_DRIVER_DIR}/Include"
  "${CMSIS_DRIVER_DIR}/Device/ST/STM32F4xx/Include"
)

project(${PROJECT_NAME})
enable_language(C ASM)

add_executable(${PROJECT_NAME}
  ${PROJECT_SOURCES}
)

add_custom_command(TARGET
  ${CMAKE_PROJECT_NAME} 
  POST_BUILD 
  COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${CMAKE_PROJECT_NAME}>
)



add_compile_definitions (${PROJECT_DEFINES})
include_directories (${PROJECT_INCLUDES})

set (CMAKE_EXECUTABLE_SUFFIX ".elf")
set (CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set (CMAKE_C_FLAGS "${MCPU} -std=gnu11 ${MFPU} ${MFLOAT_ABI} ${RUNTIME_LIBRARY} -fdata-sections -ffunction-sections -mthumb -Wall -Werror")
set (CMAKE_EXE_LINKER_FLAGS "-T${LINKER_SCRIPT} ${RUNTIME_LIBRARY_SYSCALLS} -Wl,-Map=${PROJECT_NAME}.map,--cref -Wl,--gc-sections -static -Wl,--start-group -lc -lm -Wl,--end-group")
set (CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp")

add_custom_command(TARGET
  ${CMAKE_PROJECT_NAME} 
  POST_BUILD
  COMMAND arm-none-eabi-objcopy -O ihex ${CMAKE_PROJECT_NAME}.elf ${PROJECT_NAME}.hex
  COMMAND arm-none-eabi-objcopy -O binary ${CMAKE_PROJECT_NAME}.elf ${PROJECT_NAME}.bin
)
#add_subdirectory(Core)
#add_subdirectory(STM32_SDK)