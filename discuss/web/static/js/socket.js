import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

const createTopicSocket = (topicId) => {
  
  let channel = socket.channel(`comments:${topicId}`, {});

  channel.join()
    .receive("ok", resp => {
      renderComments(resp.comments);
    })
    .receive("error", resp => { console.log("Unable to join", resp);});

  document.querySelector('#add-topic-button').addEventListener('click', function(){
    const content = document.querySelector('#add-topic-area').value;
    channel.push('comments:add', {content: content});
  });

  channel.on(`comments:${topicId}:new`, renderComment);

};

function renderComments(comments) {
  const commentsHTML = comments.map(comment => {
    return commentTemplate(comment);
  });

  document.querySelector('#comments').innerHTML = commentsHTML.join("");
  document.querySelector('#add-topic-area').value = "";
}

function commentTemplate(comment) {
  return `
    <li class="collection-item">
      ${comment.content} <span class="right"><b>${comment.user.nickname}</b></span>
    </li>`;
}

function renderComment(event) {
  document.querySelector('#comments').innerHTML += commentTemplate(event.comment);
  document.querySelector('#add-topic-area').value = "";
}

window.createTopicSocket = createTopicSocket;
