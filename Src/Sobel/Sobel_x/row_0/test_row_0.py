import os
import json
import cocotb
from cocotb.triggers import RisingEdge, Timer, with_timeout
from cocotb.clock import Clock
import numpy as np

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

vecteur_test = np.random.uniform(0, 256, 300).astype(int)


async def run_stimuli(dut):
    """Boucle principale de test"""
    for i in range(len(vecteur_test)//3):
        print(f"Iteration {i}")

        await Timer(30, unit="ns")

        # Première donnée
        print(f"Sending first data: {vecteur_test[3 * i]}")
        dut.data_in.value = int(vecteur_test[3 * i])
        dut.valid_in.value = 1
        await RisingEdge(dut.clk)
        dut.valid_in.value = 0

        await Timer(30, unit="ns")
        await RisingEdge(dut.clk)

        # Deuxième donnée
        print(f"Sending second data: {vecteur_test[3 * i + 1]}")
        dut.data_in.value = int(vecteur_test[3 * i + 1])
        dut.valid_in.value = 1
        await RisingEdge(dut.clk)
        dut.valid_in.value = 0

        await Timer(30, unit="ns")
        await RisingEdge(dut.clk)

        # Troisième donnée
        print(f"Sending third data: {vecteur_test[3 * i + 2]}")
        dut.data_in.value = int(vecteur_test[3 * i + 2])
        dut.valid_in.value = 1
        await RisingEdge(dut.clk)
        dut.valid_in.value = 0

        # Vérifie la sortie avec timeout pour éviter de bloquer
        await with_timeout(RisingEdge(dut.valid_out), 100, 'ns')

        expected_sum = vecteur_test[3 * i] + 2 * vecteur_test[3 * i + 1] + vecteur_test[3 * i + 2]
        got_sum = int(dut.data_out.value)
        print(f"Expected sum: {expected_sum}, Got sum: {got_sum}")

        assert got_sum == expected_sum, \
            f"Adder failed for {vecteur_test[3 * i]} + {vecteur_test[3 * i + 1]} + {vecteur_test[3 * i + 2]}: expected {expected_sum}, got {got_sum}"

        cocotb.log.info(f"Tested {vecteur_test[3 * i]} + {vecteur_test[3 * i + 1]} + {vecteur_test[3 * i + 2]}, got {got_sum}")

        # Enregistrement (création du dossier si besoin)
        os.makedirs("Results", exist_ok=True)
        # with open("Results/log_vhd.txt", "a") as f:
        #     f.write(f"{format(got_sum, '032b')}\n")
        with open("Results/log_result.txt", "a") as f:
            if got_sum == expected_sum:
                f.write("PASS\n")  # Green PASS
            else:
                f.write("FAIL\n")  # Red FAIL
            f.write(f"data_test: {vecteur_test[3 * i]}, {vecteur_test[3 * i + 1]}, {vecteur_test[3 * i + 2]} => data_out: {got_sum}\n")
            f.write(f"Expected sum: {expected_sum}, Got sum: {got_sum}\n")


@cocotb.test()
async def test_row_0(dut):
    """Test principal avec timeout global"""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    # Reset
    dut.reset.value = 1
    await Timer(20, unit="ns")
    dut.reset.value = 0
    dut.addr_in.value = 0

    # Timeout global : tout le test doit finir en moins de 5 µs
    await with_timeout(run_stimuli(dut), 100, 'us')
