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

vecteur_test = np.random.uniform(-2**11, 2**11, 400).astype(int)
time = np.random.uniform(1, 5, 200).astype(int)

async def run_stimuli(dut):
    """Boucle principale de test"""
    for i in range(len(vecteur_test)//2):
        print("###############")
        print(f"Iteration {i}")
        print("###############")

        await Timer(30, unit="ns")

        # Première donnée
        print(f"Value_1 : {vecteur_test[2 * i]}, Value_2 : {vecteur_test[2 * i + 1]}")
        print(f"Time delay : {time[i]} clk")
        dut.data_1.value = int(vecteur_test[2 * i])
        dut.valid_1.value = 1
        await RisingEdge(dut.clk)
        dut.valid_1.value = 0

        await Timer(10 * time[i], unit="ns")

        # Deuxième donnée
        print(f"Sending second data: {vecteur_test[2 * i + 1]}")
        dut.data_2.value = int(vecteur_test[2 * i + 1])
        dut.valid_2.value = 1
        await RisingEdge(dut.clk)
        dut.valid_2.value = 0



        # Vérifie la sortie avec timeout pour éviter de bloquer
        await with_timeout(RisingEdge(dut.valid_out), 100, 'ns')

        expected_sum = vecteur_test[2 * i] - vecteur_test[2 * i + 1]

        # 14 bits signed
        expected_bits = Bits(int=expected_sum, length=14)
        got_bits      = Bits(bin=dut.result.value.binstr, length=14)

        expected_sum = expected_bits.int
        got_sum      = got_bits.int

        print(f"Expected sum: {expected_sum}, Got sum: {got_sum}")

        assert got_sum == expected_sum, \
            f"Adder failed for {vecteur_test[2*i]} - {vecteur_test[2*i+1]}: expected {expected_sum}, got {got_sum}"


        assert got_sum == expected_sum, \
            f"Adder failed for {vecteur_test[2 * i]} - {vecteur_test[2 * i + 1]}: expected {expected_sum}, got {got_sum}"

        cocotb.log.info(f"Tested {vecteur_test[2 * i]} - {vecteur_test[2 * i + 1]}, got {got_sum}")

        # Enregistrement (création du dossier si besoin)
        os.makedirs("Results", exist_ok=True)
        # with open("Results/log_vhd.txt", "a") as f:
        #     f.write(f"{format(got_sum, '032b')}\n")
        with open("Results/log_result.txt", "a") as f:
            if got_sum == expected_sum:
                f.write("PASS\n")  # Green PASS
            else:
                f.write("FAIL\n")  # Red FAIL
            f.write(f"data_test: {vecteur_test[2 * i]}, {vecteur_test[2 * i + 1]} => data_out: {got_sum}\n")
            f.write(f"Expected sum: {expected_sum}, Got sum: {got_sum}\n")


@cocotb.test()
async def test_add(dut):
    """Test principal avec timeout global"""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    # Reset
    dut.reset.value = 1
    await Timer(20, unit="ns")
    dut.reset.value = 0
    dut.addr_in.value = 0

    # Timeout global : tout le test doit finir en moins de 5 µs
    await with_timeout(run_stimuli(dut), 1000, 'us')
