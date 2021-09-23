# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Welcome to Jila!' do
          para do
            text_node 'This is where you can administer the data for the'
            b 'Jila'
            text_node 'language application.'
          end
          para do
            text_node 'You can create, edit, and view '
            text_node link_to 'categories', admin_categories_path
            text_node ' and '
            text_node link_to 'entries', admin_entries_path
            text_node ' via the menu links above.'
          end
          para do
            text_node link_to 'Admin users', admin_admin_users_path
            text_node ' can also be managed from the links above.'
          end
        end
        panel 'State' do
          para do
            text_node 'There are'
            b Category.count, style: 'font-size: 1.5em'
            text_node 'categories in the dictionary.'
          end
          para do
            text_node 'There are'
            b Entry.count, style: 'font-size: 1.5em'
            text_node 'entries in the dictionary.'
          end
        end
        panel 'Brought to you by' do
          image_tag('/assets/tw_logo.png', width: '100%', style: 'margin-top: 15px;')
        end
      end
    end
  end
end
