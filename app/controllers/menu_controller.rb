class MenuController < ApplicationController
	before_filter :check_login
	layout "admin_layout"
	def index
		@nama_btn = "Simpan"
		@nama_form = " - Buat Menu"
		@aksi_form = "save_menu"
		@records_role = TUsertype.order('created_at ASC')
		@menu_query = TMenu.order('created_at ASC').paginate(:page => params[:page], :per_page => 15)
		if params[:page].to_i > 1
			@hhh = 15 * params[:page].to_i - 15
		end
	end

	def save_menu
		@a = params[:name_menu]
		@b = params[:menu_url]
		@d = params[:role_id]
		@d = (@d.blank?) ? "0" : params[:role_id].join(',')
		@c = session[:cur_id]
		simpen = TMenu.create({:menu_name => @a, :url => @b, :t_user_id => @c, :visible_to =>","+@d+","})
		if simpen.valid?
			flash[:notice_success] = "<b>Alhamdulillah!</b> Data berhasil disimpan.".html_safe
		else
			flash[:notice_failed] = "<b>Terdapat kesalahan pada pengisian form.</b>".html_safe
		end

		if params[:page]
			redirect_to "/menu_cfg?page="+params[:page]
		else
			redirect_to "/menu_cfg"
		end
	end

	def edit_menu
		# Dynamic Variables
		@nama_btn = "Perbaharui"
		@nama_form = " - Perbaharui Menu"
		@aksi_form = params[:id] + "/update_menu"
		@records_role = TUsertype.order('created_at ASC')
		menu_dtl = TMenu.find(params[:id])
		@aa = menu_dtl.menu_name.to_s
		@bb = menu_dtl.url.to_s
		@cc = menu_dtl.visible_to.split(',')
		@menu_query = TMenu.order('created_at ASC').paginate(:page => params[:page], :per_page => 15)
		render :index
	end

	def search
		@a = params[:search_form]
		@nama_btn = "Simpan"
		@nama_form = " - Buat Menu"
		@aksi_form = "save_menu"
		@records_role = TUsertype.order('created_at ASC')
		@menu_query = TMenu.where("menu_name LIKE ?","%"+@a+"%").order('created_at ASC').paginate(:page => params[:page], :per_page => 15)
		if params[:page].to_i > 1
			@hhh = 15 * params[:page].to_i - 15
		end
		render :index
	end

	def update_menu
		idmenu = TMenu.find(params[:id])
		idmenu.menu_name = params[:name_menu]
		idmenu.url = params[:menu_url]
		@d = params[:role_id]
		@d = (@d.blank?) ? "0" : params[:role_id].join(',')
		idmenu.visible_to = ','+@d+','

		unless idmenu.save
			flash[:notice_failed] = "<b>Terdapat kesalahan pada pengisian form.</b>".html_safe
		else
			flash[:notice_success] = "<b>Alhamdulillah!</b> Data berhasil disimpan.".html_safe
		end

		redirect_to "/menu_cfg/", :notice_success => "<b>Alhamdulillah!</b> Data berhasil diperbaharui.".html_safe
	end

	def delete_menu
		idmenu = TMenu.find(params[:id])
		idmenu.destroy
		redirect_to "/menu_cfg/", :notice_success => "<b>Alhamdulillah!</b> Data berhasil dihapus.".html_safe
	end
end
