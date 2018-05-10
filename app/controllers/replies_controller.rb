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
                # app/views/replies/create.js.erb 라는 이름의 파일로 매핑됩니다.
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