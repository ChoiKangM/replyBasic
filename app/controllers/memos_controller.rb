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
