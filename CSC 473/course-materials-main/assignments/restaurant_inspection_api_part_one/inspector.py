import csv
import typing

import inspection


class Inspector:
    @staticmethod
    def get_inspections() -> typing.Generator[inspection.Inspection, None, None]:
        with open("data.csv", encoding="utf-8") as file:
            reader = csv.reader(file, delimiter=",")
            # Skip the first row, which is considered the header.
            next(reader)

            for _, line in enumerate(reader):
                yield inspection.Inspection(
                    restaurant_id=line[0],
                    restaurant_name=line[1],
                    borough=line[2],
                    zipcode=line[5],
                    cuisine=line[7],
                    inspection_date=line[8],
                    violation_code=line[10],
                    violation_description=line[11],
                    score=line[13],
                    grade=line[14],
                    grade_date=line[15],
                )
