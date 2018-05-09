# 레일즈로 댓글 달기 + Ajax
> [레일즈로 게시판 만들기 기초](https://github.com/knulikelion/crudBasic)에 이어지는 강좌입니다.  
> 레일즈로 댓글 달아봅시다.  

#### `CRUD`
[지난 시간에 배운 CRUD](https://github.com/knulikelion/crudBasic#crud)  
댓글을 달기 위해 게시글에 `CRUD`, 댓글에 'CD' 구조를 사용합니다.  

## 레일즈 프로젝트 생성하기
레일즈 프로젝트를 만듭니다.
```bash
$ rail new commentBasic
```
생성된 Rails 프로젝트 폴더로 이동합니다.
```bash
$ cd commentBasic
```

## model 만들기
게시글 모델 만들고
```bash
rails g model Memo title:string content:text
```
> 레일즈야 만들자 모델 이름은 Memo(게시글)야  
> 게시글의 Column(속성)으로 title(제목)은 string으로 content(내용)는 text로 만들어   

| Model(모델 이름) | Column(속성) |
|:----------------:|--------------|
|       `Memo`     | `title`:string |
|                  | `content`:text |

댓글 모델 만들기
```bash
rails g model Reply content:text memo:belongs_to
```
> 레일즈야 만들자 모델 이름은 Reply(댓글)야  
> 게시글의 Column(속성)으로 title(제목)은 string으로 content(내용)는 text로 만들어   

| Model(모델 이름) | Column(속성)    |
|:----------------:|-----------------|
|       Reply      | content:text    |
|                  | memo:belongs_to |

## `1:N 관계`
인터넷 서핑을 하다보면 게시글(1)에 여러 댓글(N)이 달려있습니다.  
게시글 1개에 댓글 N개가 달린 구조입니다.  
이를 레일즈로 구현해봅시다.  

## model 설정
#### `reply.rb`
```ruby
class Reply < ApplicationRecord
  # 댓글(Reply)는 게시글(Memo)에 속해 있습니다.
  belongs_to :memo
end
```
#### `memo.rb`
```ruby
class Memo < ApplicationRecord
  # 게시글(Memo)은 여러 댓글(Reply)을 가지고 있습니다.
  has_many :replies
end
```

## controller 만들기

```bash
rails g controller Memos new index show edit
```
> 레일즈야 만들자 컨트롤러 이름은 Memos야  
> 안에 액션으로 new, edit, index, show를 만들어

```bash
rails g controller Replies
```
> 레일즈야 만들자 컨트롤러 이름은 Replies야  

## `memos_controller.rb` 액션 로직
```ruby
class MemosController < ApplicationController
  # CREATE
  def new     # 새로운 메모 쓰기
  end
  def create  # 새로 쓴 메모 저장하기
    @memo = Memo.new
    @memo[:title] = params[:title]
    @memo[:content] = params[:content]
    @memo.save

    redirect_to root_path
  end

  # READ
  def index   # 모든 메모 읽기
    @memos = Memo.all
  end
  def show    # 원하는 메모 읽기
    @memo = Memo.find(params[:id])

    # 원하는 메모의 댓글을 모두 불러옵니다
    @replies = @memo.replies
  end

  # UPDATE
  def edit    # 원하는 메모 수정하기
    @memo = Memo.find(params[:id])
  end
  def update  # 수정한 메모 저장하기
    @memo = Memo.find(params[:id])
    @memo[:title] = params[:title]
    @memo[:content] = params[:content]
    @memo.save

    redirect_to "/memos/#{@memo.id}/show"
  end
  
  # DELETE
  def destroy  # 원하는 메모 삭제하기
    @memo = Memo.find(params[:id])
    @memo.destroy
    redirect_to '/'
  end
end

```
## `replies_controller.rb` 액션 로직
```ruby
class RepliesController < ApplicationController
    def create  # 쓴 댓글 저장하기
        @reply = Reply.new
        @reply.memo_id = params[:memo_id] 
        @reply.content = params[:reply_content]
        @reply.save
        redirect_to :back
    end
    def destroy # 원하는 댓글 삭제하기
        @reply = Reply.find(params[:id])
        @reply.destroy
        redirect_to :back
    end
end
```
## `routes.rb`
```ruby
Rails.application.routes.draw do
  root 'memos#index'
  # Memo
  # Create
  get '/memos/new' => 'memos#new'
  get '/memos/create' => 'memos#create' 
  # Read
  get '/memos/index' => 'memos#index'
  get '/memos/:id/show' => 'memos#show'
  # Update
  get '/memos/:id/edit' => 'memos#edit'
  get '/memos/:id/update' => 'memos#update'
  # Delete
  get '/memos/:id/destroy' => 'memos#destroy'

  # Reply
  # Create
  get '/memos/:memo_id/replies' => 'replies#create'
  # Delete
  get '/memos/:memo_id/replies/:id' => 'replies#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
```
## `memos/new.html.erb`
```erb
<h1>새글 쓰기</h1>
<!-- 현재 new 액션은 글을 직접 쓰는 곳이고 -->
<!-- 글 내용은 create 액션으로 보내어 Memo 모델로 저장합니다. -->
<form action="/memos/create">
  <!-- 글을 쓸 때 해킹을 예방할 토큰을 함께 보냅니다  -->
  <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
  제목 <br>
  <input type="text" name="title" placeholder="제목을 입력하세요">
  <br>
  내용 <br>
  <textarea name="content" cols="30" rows="10" placeholder="내용을 입력하세요"></textarea>
  <br>
  <!-- form 태그를 submit 타입으로 제출해야 글이 써집니다. -->
  <input type="submit" value="글쓰기">
</form> 
```
## `memos/index.html.erb`
```erb
<!-- /memos/new는 routes.rb에서 설정했습니다 -->
<a href="/memos/new">글쓰기</a> <br>
<!-- 모든 메모들을 불러와 하나씩 보여줍니다 -->
<% @memos.each do |m| %>
    <!-- 제목을 누르면 해당 글로 이동합니다 -->
    <h1>제목 : <a href="/memos/<%= m.id %>/show"><%= m.title %></a></h1>
    <br>
    <h4>내용 : <%= m.content %></h4>
    <hr>
<% end %>
```
## `memos/show.html.erb`
```erb
<!-- 글의 제목과 내용을 보여줍니다 -->
<h1>제목 : <%= @memo.title %></h1>
<p>내용 : <%= @memo.content %></p>
<!-- 수정페이지로 갑니다 -->
<a href="/memos/<%=@memo.id%>/edit">수정하기</a>
<!-- 글을 삭제합니다 -->
<a href="/memos/<%=@memo.id%>/destroy"data-confirm="정말로 삭제합니까?">삭제하기</a>
<!-- 목록으로 돌아갑니다 -->
<a href="/memos/index">목록으로</a>

<br><br>
<%= render 'replies/replies'%>
<%= render 'replies/reply'%>
```
## `memos/edit.html.erb`
```erb
<h1>수정하기</h1>
<form action="/memos/<%= @memo.id%>/update">
  <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
  제목 <br>
  <!-- input 태그 속성 value="<%= @memo.title%>"로 써둔 제목을 불러옵니다.-->
  <input type="text" name="title" value="<%= @memo.title%>">
  <br>
  내용 <br>
  <!--textarea 내용에 <%=@memo.content%>로 써둔 내용을 불러옵니다. -->
  <textarea name="content" cols="30" rows="10"><%=@memo.content%></textarea>
  <br>
  <input type="submit" value="글쓰기">
</form> 
```

## `replies/_new_reply.html.erb`
```erb
<!-- memos 컨트롤러의 show 액션에서 새로운 댓글을 작성합니다 -->
<form action="/memos/<%=@memo.id%>/replies">
  <!-- 글을 쓸 때 해킹을 예방할 토큰을 함께 보냅니다  -->
  <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
  댓글:<br>
  <!-- 댓글이 속한 memo의 id를 숨겨서 보냅니다 -->
  <input type="hidden" value="<%= @memo.id%>" name="memo_id">
  <input type="text" name="reply_content" placeholder="댓글을 입력하세요"><br>
  <!-- form 태그를 submit 타입으로 제출해야 글이 써집니다. -->
  <input type="submit" value="댓글쓰기">
</form> 
```
## `replies/_replies.html.erb`
```erb
<h3>전체 댓글</h3>
<!-- memos 컨트롤러의 show 액션에서 모든 댓글을 보여줍니다 -->
<ul id="replies">
    <% @replies.each do |reply| %>
        <!-- 댓글 각각을 보여줍니다 -->
        <li><%= reply.content %></li>
        <!-- 댓글 삭제 -->
        <a href="/memos/<%=@memo.id%>/replies/<%=reply.id%>">삭제</a> <br>
    <% end %>
</ul>   
```

여기까지 레일즈를 이용해 댓글 기능을 구현해봤습니다.  
이제 Ajax를 사용해 봅니다.  

Ajax란?  
위키피디아 검색결과
> Ajax(Asynchronous JavaScript and XML)는 비동기적인 웹 애플리케이션의 제작을 위해 아래와 같은 조합을 이용하는 웹 개발 기법이다.  
> 표현 정보를 위한 HTML (또는 XHTML) 과 CSS  
> 동적인 화면 출력 및 표시 정보와의 상호작용을 위한 DOM, 자바스크립트  
> 웹 서버와 비동기적으로 데이터를 교환하고 조작하기 위한 XML, XSLT, XMLHttpRequest (Ajax 애플리케이션은 XML/XSLT 대신 미리 정의된 HTML이나 일반 텍스트, JSON, JSON-RPC를 이용할 수 있다).  

비동기적 웹 어플.. 어려운 말이 많습니다.  
**페이지 이동없이 고속으로 화면을 전환 가능**한 기술로 줄여서 기억합시다.  

Ajax를 적용합니다.  


#### `replies_controller.rb`
```ruby
class RepliesController < ApplicationController
    def create  # 쓴 댓글 저장하기
        @reply = Reply.new
        @reply.memo_id = params[:memo_id] 
        @reply.content = params[:reply_content]
        if @reply.save
            # 댓글이 저장되면 create.js에서 ajax 처리를 진행합니다
            # Ajax를 사용하기 때문에 컨트롤러가 뷰를 부를 때, JavaScript로 응답하도록 합니다.  
            respond_to do |format|
                # format.js로 지정한 뷰의 응답은 create 메소드의 이름과 동일한 JavaScript 파일로 
                # app/views/comments/create.js.erb 라는 이름의 파일로 매핑됩니다.
                format.js
            end
        end
    end
    def destroy # 원하는 댓글 삭제하기
        @reply = Reply.find(params[:id])
        @reply.destroy
        redirect_to :back
    end
end
```

#### `_replies.html.erb`

```erb
<h3>전체 댓글</h3>
<!-- memos 컨트롤러의 show 액션에서 모든 댓글을 보여줍니다 -->
<!-- Ajax로 ul 태그에 li를 넣습니다. -->
<ul id="replies">
    <% @replies.each do |reply| %>
        <!-- 댓글 각각을 보여줍니다 -->
        <li><%= reply.content %></li>
        <!-- 댓글 삭제 -->
        <a href="/memos/<%=@memo.id%>/replies/<%=reply.id%>">삭제</a> <br>
    <% end %>
    <!-- Ajax로 추가한 li가 들어갑니다-->
</ul>   
```
## `jQuery`의 기본적인 사용법
```bash
$(요소).행동();
```
요소 찾아 행동하게 합니다.  
요소엔 css 선택자인 class와 id, html 태그 등이 들어갑니다.  
행동엔 함수가 들어갑니다.
#### `create.js.erb`
Comments 목록을 출력하는 DOM에 저장한 Comment 내용을 추가하는 코드이다.
```javascript
// @reply를 저장한 이후 
(function($){
    // 입력폼을 비웁니다. 
    $("#reply_content").val("")
    // ul#replies 끝에 새로운 댓글인 li 태그를 붙입니다.
    $("#replies").append("<li><%= @reply.content %></li>");
})(jQuery)
```