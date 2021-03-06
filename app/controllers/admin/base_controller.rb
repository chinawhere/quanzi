class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :admin_required, except: [:admin_login]
  # before_action :admin_required, except: [:index]

  def admin_login
    if cookies.signed[:admin_id].present? and Admin.where(id: cookies.signed[:admin_id]).includes(:roles).first
      redirect_to admin_home_url
    else
      render layout: false
    end
  end

  def home
    p @admin
  end

  def admin_required
    if (not cookies.signed[:admin_id]) or (not Admin.where(id: cookies.signed[:admin_id]).first.active)
      redirect_to root_url
    else
      @admin = Admin.where(id: cookies.signed[:admin_id]).includes(:roles).first
      redirect_to root_url if @admin.blank?
    end
  end

  def file_upload_to_qiniu(image_type)
    bucket = ENV['QINIU_BUCKET']
    if params[:type].present?
      key = "shequ/#{image_type}/#{params[:type]}/#{Time.now.to_i * 1000 + rand(1000)}"
    else
      key = "shequ/#{image_type}/#{Time.now.to_i * 1000 + rand(1000)}"
    end
    put_policy = Qiniu::Auth::PutPolicy.new(
        bucket,
        key,
        3600
    )
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    filePath = params['FileContent'].tempfile
    begin
      code, result, response_headers = Qiniu::Storage.upload_with_token_2(
          uptoken,
          filePath,
          key,
          nil,
          bucket: bucket,
          content_type: params['FileContent'].content_type,
          )

    rescue
      logger.fatal "error:#{$!} at:#{$@}"
      render status: :internal_server_error, json: {status: -1}
    else
      render json: {status: 0, message: 'success', download_url: "#{ENV['QINIU_URL']}#{result['key']}"}
    end
  end
end