const express = require("express");
const app = express();

const getNote = require("../crud/get_note");
const getNotes = require("../crud/get_notes");
const postNote = require("../crud/insert_note");
const deleteNote = require("../crud/delete_note");

app.use(express.json());

app.get("/:id", async (req, res) => {
  try {
    const rs = await getNote(req.params.id);
    res.json(rs);
  } catch (error) {
    res.status(400).json(error);
  }
});

app.get("/", async (req, res) => {
  try {
    const rs = await getNotes();
    res.json(rs);
  } catch (error) {
    res.status(400).json(error);
  }
});

app.post("/", async (req, res) => {
  try {
    const rs = await postNote(req.body);
    res.json(rs);
  } catch (error) {
    res.status(400).send(error.message);
  }
});

app.delete("/:id", async (req, res) => {
  try {
    await deleteNote(req.params.id);
    res.status(200).send();
  } catch (error) {
    res.status(400).send(error.message);
  }
});

app.listen(3333, () => console.log("Client server"));
