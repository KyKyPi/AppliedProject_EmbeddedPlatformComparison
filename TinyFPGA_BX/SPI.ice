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
          "id": "4393f0b1-d278-41f2-b215-23bb65e6460a",
          "type": "basic.input",
          "data": {
            "name": "SCK",
            "pins": [
              {
                "index": "0",
                "name": "SPI_SCK",
                "value": "G7"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": -976,
            "y": -112
          }
        },
        {
          "id": "4b02a180-6d32-42d0-9fb6-ab8eb258353d",
          "type": "basic.output",
          "data": {
            "name": "MISO",
            "pins": [
              {
                "index": "0",
                "name": "SPI_IO0",
                "value": "G6"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1080,
            "y": -64
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
                "name": "",
                "value": ""
              }
            ],
            "virtual": true,
            "clock": true
          },
          "position": {
            "x": -976,
            "y": 8
          }
        },
        {
          "id": "5b01a2cf-f118-4521-8b08-7a7de8b5102b",
          "type": "basic.input",
          "data": {
            "name": "SS",
            "pins": [
              {
                "index": "0",
                "name": "SPI_SS",
                "value": "F7"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": -976,
            "y": 120
          }
        },
        {
          "id": "cef98ef8-ae3d-4ae0-9977-b0bf85ccbf38",
          "type": "basic.input",
          "data": {
            "name": "MOSI",
            "pins": [
              {
                "index": "0",
                "name": "SPI_IO1",
                "value": "H7"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": -976,
            "y": 264
          }
        },
        {
          "id": "0bd2aa46-2d99-4a8f-955a-c6dec29063fb",
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
            "x": 1192,
            "y": 536
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
                },
                {
                  "name": "SCK"
                }
              ],
              "out": [
                {
                  "name": "SCK_risingedge"
                },
                {
                  "name": "SCK_fallingedge"
                }
              ]
            }
          },
          "position": {
            "x": -744,
            "y": -216
          },
          "size": {
            "width": 576,
            "height": 176
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
                },
                {
                  "name": "SS"
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
                }
              ]
            }
          },
          "position": {
            "x": -744,
            "y": -16
          },
          "size": {
            "width": 576,
            "height": 224
          }
        },
        {
          "id": "db2bd5fd-1765-436e-a67b-40dd69b5eefd",
          "type": "basic.code",
          "data": {
            "code": "// and for MOSI\nreg [1:0] MOSIr;  always @(posedge clk)\n    MOSIr <= {MOSIr[0], MOSI};\nwire MOSI_data = MOSIr[1];",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "MOSI"
                }
              ],
              "out": [
                {
                  "name": "MOSI_data"
                }
              ]
            }
          },
          "position": {
            "x": -744,
            "y": 232
          },
          "size": {
            "width": 576,
            "height": 88
          }
        },
        {
          "id": "2222060a-9334-48cf-a7e2-93e61b056278",
          "type": "basic.code",
          "data": {
            "code": "// we handle SPI in 8-bits format, so we need a 3 bits counter to count \n// the bits as they come in\nreg [2:0] bitcnt;\n\nreg byte_received;  // high when a byte has been received\nreg [7:0] byte_data_received;\n\nalways @(posedge clk)\nbegin\n  if(~SS_active)\n    bitcnt <= 3'b000;\n  else\n  if(SCK_risingedge)\n  begin\n    bitcnt <= bitcnt + 3'b001;\n\n    // implement a shift-left register (since we receive the data MSB first)\n    byte_data_received <= {byte_data_received[6:0], MOSI_data};\n  end\nend\n\nalways @(posedge clk) \n    byte_received <= SS_active && SCK_risingedge && (bitcnt==3'b111);\n\n// we use the LSB of the data received to control an LED\nreg LED;\nalways @(posedge clk) if(byte_received) LED <= byte_data_received[0];",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "SCK_risingedge"
                },
                {
                  "name": "SS_active"
                },
                {
                  "name": "SS_endmessage"
                },
                {
                  "name": "MOSI_data"
                },
                {
                  "name": "clk"
                }
              ],
              "out": [
                {
                  "name": "bitcnt"
                },
                {
                  "name": "LED"
                }
              ]
            }
          },
          "position": {
            "x": 248,
            "y": 352
          },
          "size": {
            "width": 728,
            "height": 432
          }
        },
        {
          "id": "d784556b-9415-42cd-a638-e9ed51904a80",
          "type": "basic.code",
          "data": {
            "code": "reg [7:0] byte_data_sent;\n\nreg [7:0] cnt;\nalways @(posedge clk) if(SS_startmessage) cnt<=cnt+8'h1;  // count the messages\n\nalways @(posedge clk)\nif(SS_active)\nbegin\n  if(SS_startmessage)\n    byte_data_sent <= cnt;  // first byte sent in a message is the message count\n  else\n  if(SCK_fallingedge)\n  begin\n    if(bitcnt==3'b000)\n      byte_data_sent <= 8'h00;  // after that, we send 0s\n    else\n      byte_data_sent <= {byte_data_sent[6:0], 1'b0};\n  end\nend\n\nassign MISO = byte_data_sent[7];  // send MSB first\n// we assume that there is only one slave on the SPI bus\n// so we don't bother with a tri-state buffer for MISO\n// otherwise we would need to tri-state MISO when SSEL \n// is inactive",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
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
                  "name": "bitcnt"
                }
              ],
              "out": [
                {
                  "name": "MISO"
                }
              ]
            }
          },
          "position": {
            "x": 456,
            "y": -272
          },
          "size": {
            "width": 560,
            "height": 472
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
          "vertices": []
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
            "block": "4393f0b1-d278-41f2-b215-23bb65e6460a",
            "port": "out"
          },
          "target": {
            "block": "79205467-76f1-4868-ab00-bb46d40a5efa",
            "port": "SCK"
          }
        },
        {
          "source": {
            "block": "5b01a2cf-f118-4521-8b08-7a7de8b5102b",
            "port": "out"
          },
          "target": {
            "block": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
            "port": "SS"
          }
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
            "block": "cef98ef8-ae3d-4ae0-9977-b0bf85ccbf38",
            "port": "out"
          },
          "target": {
            "block": "db2bd5fd-1765-436e-a67b-40dd69b5eefd",
            "port": "MOSI"
          }
        },
        {
          "source": {
            "block": "2222060a-9334-48cf-a7e2-93e61b056278",
            "port": "LED"
          },
          "target": {
            "block": "0bd2aa46-2d99-4a8f-955a-c6dec29063fb",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "79205467-76f1-4868-ab00-bb46d40a5efa",
            "port": "SCK_risingedge"
          },
          "target": {
            "block": "2222060a-9334-48cf-a7e2-93e61b056278",
            "port": "SCK_risingedge"
          },
          "vertices": [
            {
              "x": 136,
              "y": 168
            }
          ]
        },
        {
          "source": {
            "block": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
            "port": "SS_active"
          },
          "target": {
            "block": "2222060a-9334-48cf-a7e2-93e61b056278",
            "port": "SS_active"
          },
          "vertices": [
            {
              "x": 64,
              "y": 472
            }
          ]
        },
        {
          "source": {
            "block": "7e0c7f8c-8e5e-414b-a5c8-b3df6e65dabd",
            "port": "SS_endmessage"
          },
          "target": {
            "block": "2222060a-9334-48cf-a7e2-93e61b056278",
            "port": "SS_endmessage"
          },
          "vertices": [
            {
              "x": -24,
              "y": 400
            }
          ]
        },
        {
          "source": {
            "block": "db2bd5fd-1765-436e-a67b-40dd69b5eefd",
            "port": "MOSI_data"
          },
          "target": {
            "block": "2222060a-9334-48cf-a7e2-93e61b056278",
            "port": "MOSI_data"
          },
          "vertices": [
            {
              "x": -112,
              "y": 480
            }
          ]
        },
        {
          "source": {
            "block": "c65753d1-dad2-40eb-be70-67942c3587c1",
            "port": "out"
          },
          "target": {
            "block": "2222060a-9334-48cf-a7e2-93e61b056278",
            "port": "clk"
          },
          "vertices": [
            {
              "x": -840,
              "y": 448
            }
          ]
        },
        {
          "source": {
            "block": "2222060a-9334-48cf-a7e2-93e61b056278",
            "port": "bitcnt"
          },
          "target": {
            "block": "d784556b-9415-42cd-a638-e9ed51904a80",
            "port": "bitcnt"
          },
          "vertices": [
            {
              "x": 768,
              "y": 288
            }
          ]
        }
      ]
    }
  },
  "dependencies": {}
}