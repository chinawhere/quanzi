namespace :admin do 
  desc '建立后台管理账户'
  task :init_admin => :environment do
    realm = "Xiaojia"
    password = "xjdg99"
    ActiveRecord::Base.transaction do
      { 
        admin_owner: '管理员',
        senior_store: '商家'
      }.each do |role_name, description|
        Role.where(name: role_name, description: description).first_or_create
      end
      role = Role.find_by_name('senior_store')
      {
        'tangling' => '唐玲'
      }.each do |name, user_name|
        admin = Admin.find_by_name(name)
        if admin.blank?
          p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
          admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
          admin.role_assignments.create!(role_id: role.id)
        end
      end
    end
  end
end