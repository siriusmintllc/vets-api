# Appeals

## GET /v0/appeals

Returns a list of appeals by logged-in user SSN

+ Response 200

    + Body

        {
            "data": [
                {
                    "id": "123C",
                    "type": "appeals_status_models_appeals",
                    "attributes": {
                        "active": true,
                        "type": "original",
                        "prior_decision_date": "2017-05-05",
                        "requested_hearing_type": "judgement",
                        "events": [
                            {
                                "type": "ssoc",
                                "date": "2017-05-28"
                            },
                            {
                                "type": "bva_final_decision",
                                "date": "2017-05-31"
                            },
                            {
                                "type": "nod",
                                "date": "2017-06-04"
                            },
                            {
                                "type": "form9",
                                "date": "2017-06-04"
                            },
                            {
                                "type": "ssoc",
                                "date": "2017-06-04"
                            },
                            {
                                "type": "soc",
                                "date": "2017-06-06"
                            }
                        ],
                        "hearings": [
                            {
                                "id": 53,
                                "type": "travel_board",
                                "date": "2018-03-12"
                            }
                        ]
                    }
                }
            ]
        }
