{
  "version": "1.2",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "TinyFPGA-BX",
    "graph": {
      "blocks": [
        {
          "id": "9c722b11-a937-4f48-a62a-68060d01e282",
          "type": "basic.input",
          "data": {
            "name": "Button",
            "pins": [
              {
                "index": "0",
                "name": "PIN_2",
                "value": "A1"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 208,
            "y": 168
          }
        },
        {
          "id": "cde72c25-59f1-403e-b101-0db376ed88ec",
          "type": "basic.output",
          "data": {
            "name": "LED",
            "pins": [
              {
                "index": "0",
                "name": "LED",
                "value": "B3"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 384,
            "y": 168
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "9c722b11-a937-4f48-a62a-68060d01e282",
            "port": "out"
          },
          "target": {
            "block": "cde72c25-59f1-403e-b101-0db376ed88ec",
            "port": "in"
          },
          "vertices": [
            {
              "x": 352,
              "y": 200
            }
          ]
        }
      ]
    }
  },
  "dependencies": {}
}