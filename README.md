# Ans::VariousConnection

複数の DB 接続を動的に生成する

当然 DB 接続は膨れ上がるが、各接続ごとに同様の ActiveRecord を使用することができる

## Installation

Add this line to your application's Gemfile:

    gem 'ans-various_connection'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ans-various_connection

## Usage

    # config/initializers/ans-various_connection.rb
    # 接続名のシンボル(小文字、 underscore)の配列を指定
    Ans::VariousConnection.establish_connections [:connection1,:connection2]

    # config/database.yml
    connection1_production:
      # 接続 "connection1" の production 環境用設定
    connection1_development:
      # 接続 "connection1" の development 環境用設定
    connection1_test:
      # 接続 "connection1" の test 環境用設定

    connection2_production:
      # 接続 "connection2" の production 環境用設定
    connection2_development:
      # 接続 "connection2" の development 環境用設定
    connection2_test:
      # 接続 "connection2" の test 環境用設定

    # app/models/my_model.rb
    class MyModel
      include Ans::VariousConnection
      for_all_connection do |name|
        # for_all_connection のブロックの中に ActiveRecord のコンテキストで呼ばれるメソッドを記述

        belongs_to :my_sub_model, foreign_key: my_sub_model_id, class_name: MySubModel.connections[name]

        scope :my_scope, lambda{
          ...
        }

        def my_method
        end

      end
    end

    # connections で全接続のハッシュを参照可能
    MyModel.connections.each do |name,connection|
      connection.my_scope.each do |instance|
        instance.my_method
        instance.my_sub_model
      end
    end

    # 各接続の参照は [] メソッドでも可能
    MyModel[:connection1].my_scope

    # 接続名の定数的な名前でクラスが定義される
    MyModel::Connection1.my_scope
    MyModel::Connection2.my_scope

### アソシエーションについて

`for_all_connection` には、 `establish_connections` で指定した名前が渡される  
この名前を使用してアソシエーション先のクラスを指定する

    belongs_to :my_sub_model, foreign_key: my_sub_model_id, class_name: MySubModel.connections[name]

今のところ、 `foreign_key` と `class_name` を適切に指定しないといけない  
また、この場合 `MySubModel` も `include Ans::VariousConnection` している必要がある

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
