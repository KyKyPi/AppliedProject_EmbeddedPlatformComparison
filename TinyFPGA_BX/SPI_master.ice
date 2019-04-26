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
          "id": "4b02a180-6d32-42d0-9fb6-ab8eb258353d",
          "type": "basic.output",
          "data": {
            "name": "MOSI",
            "pins": [
              {
                "index": "0",
                "name": "SPI_IO1",
                "value": "H7"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 920,
            "y": -120
          }
        },
        {
          "id": "5e7c8dec-4c9e-4753-8405-6c89e3485f3b",
          "type": "basic.output",
          "data": {
            "name": "SCK",
            "pins": [
              {
                "index": "0",
                "name": "SPI_SCK",
                "value": "G7"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": -120,
            "y": -16
          }
        },
        {
          "id": "c65753d1-dad2-40eb-be70-67942c3587c1",
          "type": "basic.input",
          "data": {
            "name": "clk",
            "pins": [
              {
                "index": "0",
                "name": "CLK",
                "value": "B2"
              }
            ],
            "virtual": false,
            "clock": true
          },
          "position": {
            "x": -976,
            "y": 88
          }
        },
        {
          "id": "35606418-006a-426c-8237-6ae25c9847af",
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
            "x": 912,
            "y": 344
          }
        },
        {
          "id": "8f305537-deeb-4423-9314-5c4cb88d790a",
          "type": "basic.output",
          "data": {
            "name": "SS",
            "pins": [
              {
                "index": "0",
                "name": "SPI_SS",
                "value": "F7"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": -120,
            "y": 344
          }
        },
        {
          "id": "128e2bfe-8bc9-4341-b367-339ff5936601",
          "type": "basic.input",
          "data": {
            "name": "MISO",
            "pins": [
              {
                "index": "0",
                "name": "SPI_IO0",
                "value": "G6"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": -960,
            "y": 520
          }
        },
        {
          "id": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
          "type": "basic.code",
          "data": {
            "code": "// same thing for SSEL\nreg [2:0] SSr;  always @(posedge clk) \n    SSr <= {SSr[1:0], SS};\n    \n// SSEL is active low\nwire SS_active = ~SSr[1];\n\n// message starts at falling edge\nwire SS_startmessage = (SSr[2:1]==2'b10);\n\n// message stops at rising edge\nwire SS_endmessage = (SSr[2:1]==2'b01);",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                }
              ],
              "out": [
                {
                  "name": "SS_active"
                },
                {
                  "name": "SS_startmessage"
                },
                {
                  "name": "SS_endmessage"
                },
                {
                  "name": "SS"
                }
              ]
            }
          },
          "position": {
            "x": -752,
            "y": 176
          },
          "size": {
            "width": 576,
            "height": 224
          }
        },
        {
          "id": "79205467-76f1-4868-ab00-bb46d40a5efa",
          "type": "basic.code",
          "data": {
            "code": "// sync SCK to the FPGA clock using a 3-bits shift register\nreg [2:0] SCKr; always @(posedge clk) \n    SCKr <= {SCKr[1:0], SCK};\n    \n// now we can detect SCK rising edges\nwire SCK_risingedge = (SCKr[2:1]==2'b01);\n\n// and falling edges\nwire SCK_fallingedge = (SCKr[2:1]==2'b10);",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                }
              ],
              "out": [
                {
                  "name": "SCK_risingedge"
                },
                {
                  "name": "SCK_fallingedge"
                },
                {
                  "name": "SCK"
                }
              ]
            }
          },
          "position": {
            "x": -752,
            "y": -136
          },
          "size": {
            "width": 576,
            "height": 184
          }
        },
        {
          "id": "db2bd5fd-1765-436e-a67b-40dd69b5eefd",
          "type": "basic.code",
          "data": {
            "code": "// and for MOSI\nreg [1:0] MISOr;  always @(posedge clk)\n    MISOr <= {MISOr[0], MISO};\nwire MISO_data = MISOr[1];",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "MISO"
                }
              ],
              "out": [
                {
                  "name": "MISO_data"
                }
              ]
            }
          },
          "position": {
            "x": -752,
            "y": 488
          },
          "size": {
            "width": 576,
            "height": 88
          }
        },
        {
          "id": "d784556b-9415-42cd-a638-e9ed51904a80",
          "type": "basic.code",
          "data": {
            "code": "reg [7:0] byte_data_sent;\n\nreg [7:0] cnt;\n\n// we handle SPI in 8-bits format, so we need a 3 bits counter to count \n// the bits as they come in\nreg [2:0] bitcnt;\n\nreg byte_received;  // high when a byte has been received\nreg [7:0] byte_data_received;\n\nalways @(posedge clk) if(SS_startmessage) cnt<=cnt+8'h1;  // count the messages\n\nalways @(posedge clk)\nif(SS_active)\nbegin\n  if(SS_startmessage)\n    byte_data_sent <= cnt;  // first byte sent in a message is the message count\n  else\n  if(SCK_fallingedge)\n  begin\n    if(bitcnt==3'b000)\n      byte_data_sent <= 8'h00;  // after that, we send 0s\n    else\n      byte_data_sent <= {byte_data_sent[6:0], 1'b0};\n  end\nend\n\nassign MOSI = byte_data_sent[7];  // send MSB first\n// we assume that there is only one slave on the SPI bus\n// so we don't bother with a tri-state buffer for MISO\n// otherwise we would need to tri-state MISO when SSEL \n// is inactive\n\nalways @(posedge clk)\nbegin\n  if(~SS_active)\n    bitcnt <= 3'b000;\n  else\n  if(SCK_risingedge)\n  begin\n    bitcnt <= bitcnt + 3'b001;\n\n    // implement a shift-left register (since we receive the data MSB first)\n    byte_data_received <= {byte_data_received[6:0], MISO_data};\n  end\nend\n\nalways @(posedge clk) \n    byte_received <= SS_active && SCK_risingedge && (bitcnt==3'b111);\n\n// we use the LSB of the data received to control an LED\nreg LED;\nalways @(posedge clk) if(byte_received) LED <= byte_data_received[0];",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "SCK_risingedge"
                },
                {
                  "name": "SCK_fallingedge"
                },
                {
                  "name": "SS_active"
                },
                {
                  "name": "SS_startmessage"
                },
                {
                  "name": "SS_endmessage"
                },
                {
                  "name": "MISO_data"
                }
              ],
              "out": [
                {
                  "name": "MOSI"
                },
                {
                  "name": "LED"
                }
              ]
            }
          },
          "position": {
            "x": 112,
            "y": -320
          },
          "size": {
            "width": 752,
            "height": 928
          }
        },
        {
          "id": "c9685364-b921-4bfe-b46f-214f7f7b3abc",
          "type": "6a50747141af6d1cfb3bb9d0093fb94862ff5a65",
          "position": {
            "x": -504,
            "y": -216
          },
          "size": {
            "width": 96,
            "height": 64
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "c65753d1-dad2-40eb-be70-67942c3587c1",
            "port": "out"
          },
          "target": {
            "block": "79205467-76f1-4868-ab00-bb46d40a5efa",
            "port": "clk"
          },
          "vertices": [
            {
              "x": -840,
              "y": 8
            }
          ]
        },
        {
          "source": {
            "block": "c65753d1-dad2-40eb-be70-67942c3587c1",
            "port": "out"
          },
          "target": {
            "block": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
            "port": "clk"
          },
          "vertices": [
            {
              "x": -840,
              "y": 120
            },
            {
              "x": -840,
              "y": 152
            }
          ]
        },
        {
          "source": {
            "block": "c65753d1-dad2-40eb-be70-67942c3587c1",
            "port": "out"
          },
          "target": {
            "block": "db2bd5fd-1765-436e-a67b-40dd69b5eefd",
            "port": "clk"
          },
          "vertices": [
            {
              "x": -840,
              "y": 152
            }
          ]
        },
        {
          "source": {
            "block": "c65753d1-dad2-40eb-be70-67942c3587c1",
            "port": "out"
          },
          "target": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "clk"
          },
          "vertices": [
            {
              "x": -840,
              "y": -256
            }
          ]
        },
        {
          "source": {
            "block": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
            "port": "SS_startmessage"
          },
          "target": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "SS_startmessage"
          },
          "vertices": []
        },
        {
          "source": {
            "block": "79205467-76f1-4868-ab00-bb46d40a5efa",
            "port": "SCK_fallingedge"
          },
          "target": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "SCK_fallingedge"
          },
          "vertices": []
        },
        {
          "source": {
            "block": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
            "port": "SS_active"
          },
          "target": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "SS_active"
          }
        },
        {
          "source": {
            "block": "79205467-76f1-4868-ab00-bb46d40a5efa",
            "port": "SCK_risingedge"
          },
          "target": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "SCK_risingedge"
          }
        },
        {
          "source": {
            "block": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
            "port": "SS_endmessage"
          },
          "target": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "SS_endmessage"
          }
        },
        {
          "source": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "LED"
          },
          "target": {
            "block": "35606418-006a-426c-8237-6ae25c9847af",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
            "port": "SS"
          },
          "target": {
            "block": "8f305537-deeb-4423-9314-5c4cb88d790a",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "79205467-76f1-4868-ab00-bb46d40a5efa",
            "port": "SCK"
          },
          "target": {
            "block": "5e7c8dec-4c9e-4753-8405-6c89e3485f3b",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "128e2bfe-8bc9-4341-b367-339ff5936601",
            "port": "out"
          },
          "target": {
            "block": "db2bd5fd-1765-436e-a67b-40dd69b5eefd",
            "port": "MISO"
          }
        },
        {
          "source": {
            "block": "db2bd5fd-1765-436e-a67b-40dd69b5eefd",
            "port": "MISO_data"
          },
          "target": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "MISO_data"
          }
        },
        {
          "source": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "MOSI"
          },
          "target": {
            "block": "4b02a180-6d32-42d0-9fb6-ab8eb258353d",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {
    "6a50747141af6d1cfb3bb9d0093fb94862ff5a65": {
      "package": {
        "name": "PrescalerN",
        "version": "0.1",
        "description": "Parametric N-bits prescaler",
        "author": "Juan Gonzalez (Obijuan)",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "e19c6f2f-5747-4ed1-87c8-748575f0cc10",
              "type": "basic.input",
              "data": {
                "name": "",
                "clock": true
              },
              "position": {
                "x": 0,
                "y": 256
              }
            },
            {
              "id": "7e07d449-6475-4839-b43e-8aead8be2aac",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 720,
                "y": 256
              }
            },
            {
              "id": "de2d8a2d-7908-48a2-9e35-7763a45886e4",
              "type": "basic.constant",
              "data": {
                "name": "N",
                "value": "22",
                "local": false
              },
              "position": {
                "x": 352,
                "y": 56
              }
            },
            {
              "id": "2330955f-5ce6-4d1c-8ee4-0a09a0349389",
              "type": "basic.code",
              "data": {
                "code": "//-- Number of bits of the prescaler\n//parameter N = 22;\n\n//-- divisor register\nreg [N-1:0] divcounter;\n\n//-- N bit counter\nalways @(posedge clk_in)\n  divcounter <= divcounter + 1;\n\n//-- Use the most significant bit as output\nassign clk_out = divcounter[N-1];",
                "params": [
                  {
                    "name": "N"
                  }
                ],
                "ports": {
                  "in": [
                    {
                      "name": "clk_in"
                    }
                  ],
                  "out": [
                    {
                      "name": "clk_out"
                    }
                  ]
                }
              },
              "position": {
                "x": 176,
                "y": 176
              },
              "size": {
                "width": 448,
                "height": 224
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "2330955f-5ce6-4d1c-8ee4-0a09a0349389",
                "port": "clk_out"
              },
              "target": {
                "block": "7e07d449-6475-4839-b43e-8aead8be2aac",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "e19c6f2f-5747-4ed1-87c8-748575f0cc10",
                "port": "out"
              },
              "target": {
                "block": "2330955f-5ce6-4d1c-8ee4-0a09a0349389",
                "port": "clk_in"
              }
            },
            {
              "source": {
                "block": "de2d8a2d-7908-48a2-9e35-7763a45886e4",
                "port": "constant-out"
              },
              "target": {
                "block": "2330955f-5ce6-4d1c-8ee4-0a09a0349389",
                "port": "N"
              }
            }
          ]
        }
      }
    }
  }
}