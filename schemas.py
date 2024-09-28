from pydantic import BaseModel

class CourseCreate(BaseModel):
    title: str
    description: str
    duration: int

class Course(CourseCreate):
    id: int

    class Config:
        orm_mode = True
