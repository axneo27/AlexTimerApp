from fastapi import FastAPI
import subprocess

app = FastAPI()

# two
# three
# four_fast

def formatScrambles(scrambles: list):
    result = []
    for i in range(len(scrambles)):
        element = {}
        element["id"] = str(i+1)
        element["scramble"] = scrambles[i]
        result.append(element)
    return result

@app.get("/scramble/{puzzle}/{count}")
async def read_root(puzzle: str, count: str):
    result = subprocess.run(['tnoodle', 'scramble', '--puzzle', puzzle, '--count', count], stdout=subprocess.PIPE)
    
    scrambles = result.stdout.decode('utf-8').split('\n')
    scrambles.pop()
    scramblesFormatted = formatScrambles(scrambles)
    return {f"Scrambles {puzzle}": scramblesFormatted}