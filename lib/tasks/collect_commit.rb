#!/root/.rbenv/shims/ruby

# description
# SVNのログを、月始めから当日まで取得し、誰が今月何回コミットしたかをDBに保存する。
# DBにはcreated_atもあるが、手動でdateも追加している。こちらは時間以降が無い。
# 一日ごとのコミットを取得していないのは、とりあえずrails側で月間結果を簡単に出力したいから。
# なれたら改変するかも。
# コミット数が多いので、時間がかかる。特に月末では数十分の実行時間が見込まれる。
# svnへの接続は、公式のswigを検討したが、バージョンが古すぎるため使えなかった。

require "commit_collection"
require 'date'

today              = Date.today.to_s
beginning_of_month = Date.today.beginning_of_month.to_s

value =`svn log #{SVN_REPO} -r \{#{beginning_of_month}\}:HEAD --no-auth-cache --password #{SVN_PASSWORD} --username #{SVN_USER} --quiet`

# ログから名前だけを取得し、名前をキー、値が重複数の配列に変換する。対象行の形式は「rリビジョン番号 | ユーザー名 | …」である
hash = Hash.new(0)
value.scan(/^.*\s\|\s(.*)\s\|/) {|user| hash[user[0]] += 1 }

hash.each do |name, count|
    commit = CommitCollection.new
    commit.name  = name
    commit.count = count
    commit.date  = today
#=begin
    if commit.save
        #p '成功しました'
    else
        #p '失敗しました'
    end
#=end
end
