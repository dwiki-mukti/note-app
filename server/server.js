
/* init var */
const dbFilePath = './db_notes.json';

/* import */
const notes = require('./db_notes.json');
const fs = require('fs');
const fastifyMultipart = require('@fastify/multipart');
const fastifyCors = require('@fastify/cors');

/* init server */
const server = require('fastify')()
    .register(fastifyMultipart, { addToBody: true }) /* acc multipart/form-data */
    .register(fastifyCors, { origin: "*" }) /* acc cors */













/* registering route */

server.get('/note', (request, response) => {
    return response.send({ notes })
});





server.post('/note', (request, response) => {
    // init var
    const bodyReq = request.body

    // validate req
    if (!(bodyReq?.title || bodyReq?.content)) {
        return response.status(422).send({ message: 'Must send title or content!' });
    }

    // change current data
    /*
    const newNotes = {
        ...notes,
        ...{
            [Date.now()]: {
                title: title ?? '',
                content: content ?? ''
            }
        }
    };
    */
    notes.push({
        id: Date.now(),
        title: (bodyReq?.title) ?? '',
        content: (bodyReq?.content) ?? ''
    });

    // sync data
    fs.writeFile(dbFilePath, JSON.stringify(notes), err => {
        if (err) throw err;
    });

    // response
    return response.send({ notes });
})





server.get('/note/:id', (request, response) => {
    // init var
    const { id } = request.params

    // get note
    // const note = notes[id];
    const note = notes.filter((note) => (note.id == id))[0];

    // check note
    if (!note) {
        return response.status(404).send({ message: 'Failed get detail note, data not exist!' });
    }

    // response
    return response.send({ note })
});





server.put('/note/:id', (request, response) => {
    // init var
    const { id } = request.params
    const bodyReq = request.body

    // get note
    // const note = notes[id];
    const indexNote = notes.findIndex((note) => (note.id == id));

    // check note
    if (!notes[indexNote]) {
        return response.status(404).send({ message: 'Failed update note, data not exist!' });
    }

    // change current data
    // const newNotes = {
    //     ...notes,
    //     ...{
    //         [id]: {
    //             title: title ?? '',
    //             content: content ?? ''
    //         }
    //     }
    // };
    // const newNotes = notes.filter(({ noteId }) => (noteId == id)).push({
    //     id,
    //     title: title ?? '',
    //     content: content ?? ''
    // });
    notes[indexNote] = {
        id: Number(id),
        title: (bodyReq?.title) ?? '',
        content: (bodyReq?.content) ?? ''
    }

    // sync data
    fs.writeFile(dbFilePath, JSON.stringify(notes), err => {
        if (err) throw err;
    });

    // response
    return response.send({ notes })
});





server.delete('/note/:id', (request, response) => {
    // init var
    const { id } = request.params

    // get note
    // const note = notes[id];
    const indexNote = notes.findIndex((note) => (note.id == id));

    // check note
    if (!notes[indexNote]) {
        return response.status(404).send({ message: 'Failed delete note, data not exist!' });
    }

    // remove data row
    const newNotes = notes.filter((note) => (note.id != id));

    // sync data
    fs.writeFile(dbFilePath, JSON.stringify(newNotes), err => {
        if (err) throw err;
    });

    // response
    console.log(`Success Delete ${id}!`);
    return response.send({ newNotes })
});

/* end registering route */















/* start server */
const port = 3000
server.listen({ port }, (err, address) => {
    if (err) {
        console.error(err)
        process.exit(1)
    }
    console.log(`fastify listening at ${address}`)
})