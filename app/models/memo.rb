class Memo < ApplicationRecord
    #  게시글(Memo)은 여러 댓글(Reply)을 가지고 있습니다.
    has_many :replies
end
