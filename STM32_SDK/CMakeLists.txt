add_library(STM32_SDK STATIC "")

add_compile_definitions(
    STM32F411xE
)

set(STM32_DRIVER_DIR "../STM32_SDK/STM32CubeF4/Drivers/STM32F4xx_HAL_Driver")

set(CMSIS_DRIVER_DIR "../STM32_SDK/STM32CubeF4/Drivers/CMSIS")

target_include_directories(STM32_SDK PUBLIC
    "${CMSIS_DRIVER_DIR}/Include"
    "${CMSIS_DRIVER_DIR}/Device/ST/STM32F4xx/Include"
    "${STM32_DRIVER_DIR}/Inc"
    "../Core/includes"
)

target_sources(STM32_SDK PRIVATE
    "${CMSIS_DRIVER_DIR}/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c"
    "${CMSIS_DRIVER_DIR}/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f411xe.s"
    "${STM32_DRIVER_DIR}/Src/stm32f4xx_hal_cortex.c"
    "${STM32_DRIVER_DIR}/Src/stm32f4xx_hal.c"
)

target_link_libraries(${PROJECT_NAME} PUBLIC STM32_SDK)