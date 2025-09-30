import os
import json
import cocotb
from cocotb.triggers import RisingEdge, Timer, with_timeout
from cocotb.clock import Clock
import numpy as np
from bitstring import Bits


def extract_all_stimuli(json_data):
    """
    Parcourt le JSON et retourne un dict {nom_signal: [stimuli]} 
    pour toutes les clés qui contiennent 'stimuli'.
    """
    result = {}
    for key, value in json_data.items():
        if isinstance(value, dict) and "stimuli" in value:
            result[key] = value["stimuli"]
    return result

vecteur_test_1 = np.random.uniform(0, 2**7, 300).astype(int)
vecteur_test_2 = np.random.uniform(0, 2**7, 300).astype(int)
vecteur_test_3 = np.random.uniform(0, 2**7, 300).astype(int)


async def run_stimuli(dut):
    """Boucle principale de test"""
    for i in range(len(vecteur_test_1)//3):
        print("###############")
        print(f"Iteration {i}")
        print("###############")

        await RisingEdge(dut.clk)

        #envoie des données

        print(f"Value_1 : {vecteur_test_1[i]}, Value_2 : {vecteur_test_2[i]}")
        

        dut.data_1_in.value = int(vecteur_test_1[i])
        dut.valid_data_1_in.value = 1

        await RisingEdge(dut.clk)

        dut.valid_data_1_in.value = 0
        dut.data_2_in.value = int(vecteur_test_2[i])
        dut.valid_data_2_in.value = 1

        await RisingEdge(dut.clk)

        dut.valid_data_2_in.value = 0
        dut.data_3_in.value = int(vecteur_test_3[i])
        dut.valid_data_3_in.value = 1

        await RisingEdge(dut.clk)

        dut.valid_data_3_in.value = 0

        await RisingEdge(dut.clk)
        
        if i % 3 == 2:

            
            await with_timeout(RisingEdge(dut.valid_out_x), 600, 'ns')
            await RisingEdge(dut.clk)

            tmp_1_y = vecteur_test_1[i - 2] - vecteur_test_1[i] 
            tmp_2_y = vecteur_test_2[i - 2] - vecteur_test_2[i]
            tmp_3_y = vecteur_test_3[i - 2] - vecteur_test_3[i]

            expected_sum_y = tmp_1_y + 2 * tmp_2_y + tmp_3_y

            tmp_1_x = vecteur_test_1[i - 2] + 2 * vecteur_test_1[i - 1] + vecteur_test_1[i]
            tmp_3_x = vecteur_test_3[i - 2] + 2 * vecteur_test_3[i - 1] + vecteur_test_3[i]

            expected_sum_x = tmp_1_x - tmp_3_x

            expected_bits_x = Bits(int=expected_sum_x, length=14)
            got_bits_x      = Bits(bin=dut.data_out_x.value.binstr, length=14)

            expected_bits_y = Bits(int=expected_sum_y, length=14)
            got_bits_y      = Bits(bin=dut.data_out_y.value.binstr, length=14)

            expected_sum_x = expected_bits_x.int
            got_sum_x      = got_bits_x.int

            expected_sum_y = expected_bits_y.int
            got_sum_y      = got_bits_y.int


            print(f"Expected sum X : {expected_sum_x}, Got sum X : {got_sum_x}")
            print(f"Expected sum Y : {expected_sum_y}, Got sum Y : {got_sum_y}")

            assert got_sum_x == expected_sum_x, \
                f"Error: got {dut.data_out_x.value}, expected {expected_sum_x}"

            assert got_sum_y == expected_sum_y, \
                f"Error: got {dut.data_out_y.value}, expected {expected_sum_y}"

            with open("Results/log_result.txt", "a") as f:
                if got_sum_y == expected_sum_y and got_sum_x == expected_sum_x:
                    f.write("PASS\n")  # Green PASS
                else:
                    f.write("FAIL\n")  # Red FAIL
                f.write(f"data_test: {vecteur_test_1[i - 2]}, {vecteur_test_1[i - 1]}, {vecteur_test_1[i]} \n")
                f.write(f"data_test: {vecteur_test_2[i - 2]}, {vecteur_test_2[i - 1]}, {vecteur_test_2[i]} \n")
                f.write(f"data_test: {vecteur_test_3[i - 2]}, {vecteur_test_3[i - 1]}, {vecteur_test_3[i]} \n")
                f.write(f"Expected sum: {expected_sum_y}, Got sum: {got_sum_y}\n")
                f.write(f"")







@cocotb.test()
async def test_top_sobel_y(dut):
    """Test principal avec timeout global"""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    # Reset
    dut.reset.value = 1
    await Timer(20, unit="ns")
    dut.reset.value = 0
    dut.addr_in.value = 0

    # Timeout global : tout le test doit finir en moins de 5 µs
    await with_timeout(run_stimuli(dut), 1000, 'us')



