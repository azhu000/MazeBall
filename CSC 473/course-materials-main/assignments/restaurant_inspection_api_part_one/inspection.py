import typing


class Inspection:
    def __init__(
        self,
        restaurant_id,
        restaurant_name,
        borough,
        zipcode,
        cuisine,
        inspection_date,
        violation_code,
        violation_description,
        score,
        grade,
        grade_date,
    ):
        self.restaurant_id = restaurant_id
        self.restaurant_name = restaurant_name
        self.borough = borough
        self.zipcode = zipcode
        self.cuisine = cuisine
        self.inspection_date = inspection_date
        self.violation_code = violation_code
        self.violation_description = violation_description
        self.score = score
        self.grade = grade
        self.grade_date = grade_date

    def to_json(self) -> typing.Dict:
        return {
            "restaurant_id": self.restaurant_id,
            "restaurant_name": self.restaurant_name,
            "borough": self.borough,
            "zipcode": self.zipcode,
            "cuisine": self.cuisine,
            "inspection_date": self.inspection_date,
            "violation_code": self.violation_code,
            "violation_description": self.violation_description,
            "score": self.score,
            "grade": self.grade,
            "grade_date": self.grade_date,
        }
