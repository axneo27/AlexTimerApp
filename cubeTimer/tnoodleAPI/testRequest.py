import requests

response = requests.get("http://127.0.0.1:8000/scramble/two/4")
print(response.json()['Scrambles two'][3])