const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

const app = express();
const port = process.env.PORT || 3000;

// MongoDB Atlas connection string
const mongoURI = 'mongodb+srv://google:<STXiksSgji6bF5YX>@cluster0.ylvzdkb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(mongoURI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'MongoDB connection error:'));
db.once('open', () => {
  console.log('Connected to MongoDB Atlas');
});

// Define user schema and model
const userSchema = new mongoose.Schema({
  googleId: String,
  displayName: String,
  email: String,
});

const User = mongoose.model('User', userSchema);

app.use(bodyParser.json());

// API endpoint to store user data
app.post('/api/user', async (req, res) => {
  try {
    const { googleId, displayName, email } = req.body;
    const newUser = new User({ googleId, displayName, email });
    await newUser.save();
    res.status(201).send('User stored in MongoDB Atlas');
  } catch (error) {
    res.status(500).send('Failed to store user');
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${5555}`);
});
