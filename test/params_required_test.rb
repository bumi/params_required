require(File.join(File.dirname(__FILE__), 'test_helper'))

# TODO: test render 404 !!!
class PostController < ActionController::Base; end
class CommentsController < ActionController::Base; end

class ParamsRequiredTest < Test::Unit::TestCase

  def test_adds_before_filter
    PostController.class_eval "params_required :user_id"
    assert_equal [:validate_params], PostController.before_filters
  end
  
  def test_allow_nested_hashes
    PostController.class_eval "params_required :user_id"
    assert PostController.new.param_present?({:bavaria => {:germany => :earth}}, {:bavaria => {:germany => {:earth => true}}})
    assert !PostController.new.param_present?({:bavaria => {:germany => :mars}}, {:bavaria => {:germany => {:earth => true}}})
  end

  
  def test_does_not_leak_options
    PostController.class_eval "params_required :user_id"
    CommentsController.class_eval "params_required :blog_id"
    
    assert [:user_id], PostController.required_params
    assert [:blog_id], CommentsController.required_params
  end
  
end
