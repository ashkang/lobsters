class LoginController < ApplicationController
  before_filter :authenticate_user

  def logout
    if @user
      reset_session
    end

    redirect_to "/"
  end

  def index
    @title = "Login"
    @referer ||= request.referer
    render :action => "index"
  end

  def login
    if params[:email].to_s.match(/@/)
      user = User.where(:email => params[:email]).first
    else
      user = User.where(:username => params[:email]).first
    end

    begin
      if !user
        raise "no user"
      end

      if !user.try(:authenticate, params[:password].to_s)
        raise "authentication failed"
      end

      if user.is_banned?
        raise "user is banned"
      end

      if !user.is_active?
        user.undelete!
        flash[:success] = I18n.t('controllers.login_controller.reactivated')
      end

      session[:u] = user.session_token

      if !user.password_digest.to_s.match(/^\$2a\$#{BCrypt::Engine::DEFAULT_COST}\$/)
        user.password = user.password_confirmation = params[:password].to_s
        user.save!
      end

      if (rd = session[:redirect_to]).present?
        session.delete(:redirect_to)
        return redirect_to rd
      elsif params[:referer].present?
        begin
          ru = URI.parse(params[:referer])
          if ru.host == Rails.application.domain
            return redirect_to ru.to_s
          end
        rescue => e
          Rails.logger.error "error parsing referer: #{e}"
        end
      end

      return redirect_to "/"
    rescue
    end

    flash.now[:error] = I18n.t('controllers.login_controller.invalidemailpassword')
    @referer = params[:referer]
    index
  end

  def forgot_password
    @title = "Reset Password"
    render :action => "forgot_password"
  end

  def reset_password
    @found_user = User.where("email = ? OR username = ?", params[:email].to_s,
      params[:email].to_s).first

    if !@found_user
      flash.now[:error] = I18n.t('controllers.login_controller.invaliduseremail')
      return forgot_password
    end

    @found_user.initiate_password_reset_for_ip(request.remote_ip)

    flash.now[:success] = I18n.t('controllers.login_controllers.resetpassword')
    return index
  end

  def set_new_password
    @title = "Reset Password"

    if (m = params[:token].to_s.match(/^(\d+)-/)) &&
    (Time.now - Time.at(m[1].to_i)) < 24.hours
      @reset_user = User.where(:password_reset_token => params[:token].to_s).first
    end

    if @reset_user && !@reset_user.is_banned?
      if params[:password].present?
        @reset_user.password = params[:password]
        @reset_user.password_confirmation = params[:password_confirmation]
        @reset_user.password_reset_token = nil

        # this will get reset upon save
        @reset_user.session_token = nil

        if !@reset_user.is_active? && !@reset_user.is_banned?
          @reset_user.deleted_at = nil
        end

        if @reset_user.save && @reset_user.is_active?
          session[:u] = @reset_user.session_token
          return redirect_to "/"
        else
          flash[:error] = I18n.t('controllers.login_controllers.resetpasswordfailed')
        end
      end
    else
      flash[:error] = I18n.t('controllers.login_controllers.invalidtoken')
      return redirect_to forgot_password_path
    end
  end
end
