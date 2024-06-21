const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const mongoose = require('mongoose');
const app = express();

app.use(bodyParser.json());
app.use(cors());

const secretKey = 'your-secret-key';

// Connect to MongoDB
mongoose.connect('mongodb+srv://Rithvik:rithvik123@sdapp1.4t2ccd9.mongodb.net/mydb?retryWrites=true&w=majority', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('Connected to MongoDB Atlas');
}).catch(err => {
  console.error('Error connecting to MongoDB', err);
});

// Define School schema
const schoolSchema = new mongoose.Schema({
  name: { type: String, required: true },
  code: { type: String, required: true, unique: true }
});

// Create School model
const School = mongoose.model('School', schoolSchema);

// Define User schema
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, required: true },
  school: { type: String, required: true },
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  grade: { type: String, required: true },
  classes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Class' }]
});

// Create User model
const User = mongoose.model('User', userSchema);

// Define Class schema
const classSchema = new mongoose.Schema({
  className: { type: String, required: true },
  subject: { type: String, required: true },
  period: { type: String, required: true },
  design: { type: String, required: true },
  teacher: { type: String, required: true },
  students: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  assignments: [{
    name: { type: String, required: true },
    description: { type: String, required: true }
  }]
});

// Create Class model
const Class = mongoose.model('Class', classSchema);

// Register endpoint
app.post('/register', async (req, res) => {
  const { email, password, role, schoolCode, firstName, lastName, grade } = req.body;

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).send('Email already registered');
    }

    const school = await School.findOne({ code: schoolCode });
    if (!school) {
      return res.status(400).send('Invalid school code');
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = new User({ email, password: hashedPassword, role, school: school.name, firstName, lastName, grade });

    const savedUser = await user.save();
    const token = jwt.sign({ email: user.email, role: user.role, school: user.school }, secretKey, { expiresIn: '1h' });
    res.status(201).json({ token, role: user.role, school: user.school, firstName: user.firstName, lastName: user.lastName });
  } catch (error) {
    res.status(500).send('Error registering user');
  }
});

// Login endpoint
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });
  if (!user) {
    return res.status(401).send('Invalid email or password');
  }
  const isPasswordValid = await bcrypt.compare(password, user.password);
  if (!isPasswordValid) {
    return res.status(401).send('Invalid email or password');
  }
  const token = jwt.sign({ email: user.email, role: user.role, school: user.school }, secretKey, { expiresIn: '1h' });
  res.json({ token, role: user.role, school: user.school, firstName: user.firstName, lastName: user.lastName });
});

// Add class endpoint
app.post('/classes', async (req, res) => {
  const { className, subject, period, design, teacher } = req.body;

  try {
    const newClass = new Class({ className, subject, period, design, teacher });
    const savedClass = await newClass.save();
    res.status(201).json(savedClass);
  } catch (error) {
    res.status(500).send('Error adding class');
  }
});

// Add students to class endpoint
app.post('/classes/addStudents', async (req, res) => {
  const { className, students } = req.body;
  console.log(`Adding students to class: ${className}, Students: ${students}`);

  try {
    const classDoc = await Class.findOne({ className });
    if (!classDoc) {
      console.log('Class not found');
      return res.status(404).send('Class not found');
    }

    // Check if students array is empty
    if (students.length === 0) {
      console.log('No students selected');
      return res.status(200).send('No students added to class');
    }

    // Log the class document before adding students
    console.log(`Class before adding students: ${JSON.stringify(classDoc)}`);

    // Add students to the class only if they are not already added
    students.forEach(studentId => {
      const objectId = new mongoose.Types.ObjectId(studentId); // Add 'new' keyword
      if (!classDoc.students.includes(objectId)) {
        classDoc.students.push(objectId);
      }
    });

    // Log the class document after adding students
    console.log(`Class after adding students: ${JSON.stringify(classDoc)}`);
    const userIds = students.map(studentId => new mongoose.Types.ObjectId(studentId));
    await User.updateMany({ _id: { $in: userIds } }, { $push: { classes: classDoc._id } });

    await classDoc.save();
    console.log('Students added to class successfully');
    res.status(200).send('Students added to class');
  } catch (error) {
    console.error('Error adding students to class:', error);
    res.status(500).send('Error adding students to class');
  }
});

// Add assignment to class endpoint
app.post('/classes/:classId/assignments', async (req, res) => {
  const { classId } = req.params;
  const { name, description } = req.body;

  try {
    const classDoc = await Class.findById(classId);
    if (!classDoc) {
      return res.status(404).send('Class not found');
    }

    classDoc.assignments.push({ name, description });
    await classDoc.save();

    res.status(201).send('Assignment added');
  } catch (error) {
    res.status(500).send('Error adding assignment');
  }
});

app.get('/students/:studentId/classes', async (req, res) => {
  const studentId = req.params.studentId;

  try {
    const user = await User.findById(studentId).populate('classes');
    const classes = user.classes;
    res.json(classes);
  } catch (error) {
    res.status(500).send('Error fetching classes for student');
  }
});

// Fetch classes endpoint
app.get('/classes', async (req, res) => {
  const teacher = req.query.teacher;
  try {
    const classes = await Class.find({ teacher });
    res.json(classes);
  } catch (error) {
    res.status(500).send('Error fetching classes');
  }
});

// Fetch students endpoint
app.get('/students', async (req, res) => {
  const school = req.query.school;
  console.log(`Fetching students for school: ${school}`);  // Log the school query parameter
  try {
    const students = await User.find({ school: school, role: 'student' });
    console.log(`Found students: ${JSON.stringify(students)}`);  // Log the found students
    res.json(students);
  } catch (error) {
    console.error('Error fetching students', error);
    res.status(500).send('Error fetching students');
  }
});

// Fetch classes for a specific student
app.get('/students/:studentId/classes', async (req, res) => {
  const studentId = req.params.studentId;

  try {
    const user = await User.findById(studentId).populate('classes');
    const classes = user.classes;
    res.json(classes);
  } catch (error) {
    res.status(500).send('Error fetching classes for student');
  }
});

// Protected endpoint
app.get('/protected', (req, res) => {
  const token = req.headers['authorization'];
  if (!token) {
    return res.status(401).send('Access denied');
  }
  try {
    const decoded = jwt.verify(token, secretKey);
    res.json({ message: 'This is a protected route', user: decoded });
  } catch (err) {
    res.status(401).send('Invalid token');
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
