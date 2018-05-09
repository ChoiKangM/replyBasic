class Reply < ApplicationRecord
  # 댓글(Reply)는 게시글(Memo)에 속해 있습니다.
  belongs_to :memo
end
