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
        

        dut.data_in_1.value = int(vecteur_test_1[i])
        dut.valid_in_1.value = 1

        await RisingEdge(dut.clk)

        dut.valid_in_1.value = 0
        dut.data_in_2.value = int(vecteur_test_2[i])
        dut.valid_in_2.value = 1

        await RisingEdge(dut.clk)

        dut.valid_in_2.value = 0
        dut.data_in_3.value = int(vecteur_test_3[i])
        dut.valid_in_3.value = 1

        await RisingEdge(dut.clk)

        dut.valid_in_3.value = 0

        await RisingEdge(dut.clk)
        
        if i % 3 == 2:

            
            await with_timeout(RisingEdge(dut.valid_out), 600, 'ns')

            tmp_1 = vecteur_test_1[i - 2] - vecteur_test_1[i] 
            tmp_2 = vecteur_test_2[i - 2] - vecteur_test_2[i]
            tmp_3 = vecteur_test_3[i - 2] - vecteur_test_3[i]

            expected_sum = tmp_1 + 2 * tmp_2 + tmp_3

            expected_bits = Bits(int=expected_sum, length=14)
            got_bits      = Bits(bin=dut.data_out.value.binstr, length=14)

            expected_sum = expected_bits.int
            got_sum      = got_bits.int

            print(f"Expected sum: {expected_sum}, Got sum: {got_sum}")

            assert got_sum == expected_sum, \
                f"Error: got {dut.data_out.value}, expected {expected_sum}"

            with open("Results/log_result.txt", "a") as f:
                if got_sum == expected_sum:
                    f.write("PASS\n")  # Green PASS
                else:
                    f.write("FAIL\n")  # Red FAIL
                f.write(f"data_test: {vecteur_test_1[i - 2]}, {vecteur_test_1[i - 1]}, {vecteur_test_1[i]} \n")
                f.write(f"data_test: {vecteur_test_2[i - 2]}, {vecteur_test_2[i - 1]}, {vecteur_test_2[i]} \n")
                f.write(f"data_test: {vecteur_test_3[i - 2]}, {vecteur_test_3[i - 1]}, {vecteur_test_3[i]} \n")

                
                f.write(f"Expected sum: {expected_sum}, Got sum: {got_sum}\n")







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
