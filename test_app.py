from app import app

def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert b"Enrique Julian ha desplegado el servidor" in response.data
