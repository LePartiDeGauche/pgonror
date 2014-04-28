# encoding: utf-8
# PGonror is the corporate web site framework of Le Parti de Gauche based on Ruby on Rails.
# 
# Copyright (C) 2013 Le Parti de Gauche
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# 
# See doc/COPYRIGHT.rdoc for more details.

# Defines online memberships to the association.
# All the information entered by users in the form are stored in system,
# but the payment of the membership fee is managed externally.
# Only references to the payment is tracked in the system.
class Membership < Payment
  include ActionView::Helpers::NumberHelper

  # Sex.
  GENDERS = ["Femme","Homme"]

  # List of French departments.
  DEPARTEMENTS = ["Ain (01)",
                  "Aisne (02)",
                  "Allier (03)",
                  "Alpes-de-Haute-Provence (04)",
                  "Hautes-Alpes (05)",
                  "Alpes-Maritimes (06)",
                  "Ardèche (07)",
                  "Ardennes (08)",
                  "Ariège (09)",
                  "Aube (10)",
                  "Aude (11)",
                  "Aveyron (12)",
                  "Bouches-du-Rhône (13)",
                  "Calvados (14)",
                  "Cantal (15)",
                  "Charente (16)",
                  "Charente-Maritime (17)",
                  "Cher (18)",
                  "Corrèze (19)",
                  "Corse-du-Sud (2A)",
                  "Haute-Corse (2B)",
                  "Côte-d'Or (21)",
                  "Côtes-d'Armor (22)",
                  "Creuse (23)",
                  "Dordogne (24)",
                  "Doubs (25)",
                  "Drôme (26)",
                  "Eure (27)",
                  "Eure-et-Loir (28)",
                  "Finistère (29)",
                  "Gard (30)",
                  "Haute-Garonne (31)",
                  "Gers (32)",
                  "Gironde (33)",
                  "Hérault (34)",
                  "Ille-et-Vilaine (35)",
                  "Indre (36)",
                  "Indre-et-Loire (37)",
                  "Isère (38)",
                  "Jura (39)",
                  "Landes (40)",
                  "Loir-et-Cher (41)",
                  "Loire (42)",
                  "Haute-Loire (43)",
                  "Loire-Atlantique (44)",
                  "Loiret (45)",
                  "Lot (46)",
                  "Lot-et-Garonne (47)",
                  "Lozère (48)",
                  "Maine-et-Loire (49)",
                  "Manche (50)",
                  "Marne (51)",
                  "Haute-Marne (52)",
                  "Mayenne (53)",
                  "Meurthe-et-Moselle (54)",
                  "Meuse (55)",
                  "Morbihan (56)",
                  "Moselle (57)",
                  "Nièvre (58)",
                  "Nord (59)",
                  "Oise (60)",
                  "Orne (61)",
                  "Pas-de-Calais (62)",
                  "Puy-de-Dôme (63)",
                  "Pyrénées-Atlantiques (64)",
                  "Hautes-Pyrénées (65)",
                  "Pyrénées-Orientales (66)",
                  "Bas-Rhin (67)",
                  "Haut-Rhin (68)",
                  "Rhône (69)",
                  "Haute-Saône (70)",
                  "Saône-et-Loire (71)",
                  "Sarthe (72)",
                  "Savoie (73)",
                  "Haute-Savoie (74)",
                  "Paris (75)",
                  "Seine-Maritime (76)",
                  "Seine-et-Marne (77)",
                  "Yvelines (78)",
                  "Deux-Sèvres (79)",
                  "Somme (80)",
                  "Tarn (81)",
                  "Tarn-et-Garonne (82)",
                  "Var (83)",
                  "Vaucluse (84)",
                  "Vendée (85)",
                  "Vienne (86)",
                  "Haute-Vienne (87)",
                  "Vosges (88)",
                  "Yonne (89)",
                  "Territoire de Belfort (90)",
                  "Essonne (91)",
                  "Hauts-de-Seine (92)",
                  "Seine-Saint-Denis (93)",
                  "Val-de-Marne (94)",
                  "Val-d'Oise (95)",
                  "Guadeloupe (971)",
                  "Martinique (972)",
                  "Guyane (973)",
                  "La Réunion (974)",
                  "Saint-Pierre et Miquelon (975)",
                  "Mayotte (976)",
                  "Étranger"]

  validates :department, :presence => true, :inclusion => { :in => DEPARTEMENTS }
  validates :committee, :presence => true, :if => :renew?
  validates :committee, :length => {:maximum => 30}
  validates :first_name, :length => {:minimum => 3, :maximum => 30}
  validates :last_name, :length => {:minimum => 3, :maximum => 30}
  validates :gender, :presence => true
  validates :gender, :inclusion => { :in => GENDERS }, :if => "gender.present?"
  validates :address, :presence => true, :length => {:maximum => 80}
  validates :zip_code, :presence => true, :length => {:maximum => 10}
  validates :birthdate, :presence => true
  validates :city, :presence => true, :length => {:maximum => 80}
  validates :phone, :presence => true, :unless => :mobile?
  validates :mobile, :presence => true, :unless => :phone?
  validates :phone, :length => {:maximum => 30}
  validates :job, :length => {:maximum => 80}
  validates :assoc, :length => {:maximum => 80}
  validates :union, :length => {:maximum => 80}
  validates :mandate, :length => {:maximum => 80}
  validates :mandate_place, :presence => true, :if => :mandate?
  validates :mobile, :length => {:maximum => 30}
  validates :email, :length => {:minimum => 3, :maximum => 50}, :email => true
  validate :amount_range_mini
  validate :amount_range
  validates :comment, :length => {:maximum => 3000}

  # Defines the miminum amount for the membership fee.
  MIN_AMOUNT = 36.0

  # Defines the maximum amount for the membership fee.
  MAX_AMOUNT = 99999.99

  # Valides the amount (fee) is entered and is greater or equal to the mimimum.
  def amount_range_mini
    if self.amount.present? and self.amount < MIN_AMOUNT
      errors.add(:amount, I18n.t('activerecord.attributes.membership.amount_error_min', :min => number_to_currency(MIN_AMOUNT)))
    end
  end

  # Valides the amount (fee) is entered and is less than the maximum.
  def amount_range
    if self.amount.present? and self.amount > MAX_AMOUNT
      errors.add(:amount, I18n.t('activerecord.attributes.membership.amount_error_max', :max => number_to_currency(MAX_AMOUNT)))
    end
  end

  # Returns the free-form amount as a string in order to select the appropriate item in the list of predefined amounts. 
  def predefined_amount
    self.amount.to_s
  end 

  # Selects the appropriate item in the list of predefined amounts based on the input.
  def predefined_amount=(amount)
    self.amount = amount.to_f if amount.present? and amount.to_f > 0.0
  end

  # Returns an array that contains the list of articles with the category 'departement'.  
  def self.comites
    articles = []
    for item in Article.find_published_order_by_title 'departement', 1, 999
      articles << [item.title, item.id]
    end
    articles
  end

  # List (array) of predefined amounts.
  def self.amounts
   [[I18n.t('activerecord.attributes.membership.select_amount'), "0"],
    [I18n.t('activerecord.attributes.membership.amount_band1'), "36.0"],
    [I18n.t('activerecord.attributes.membership.amount_band2'), "60.0"],
    [I18n.t('activerecord.attributes.membership.amount_band3'), "120.0"],
    [I18n.t('activerecord.attributes.membership.amount_band4'), "300.0"],
    [I18n.t('activerecord.attributes.membership.amount_band5'), "480.0"]
   ]
  end

  # List (array) of responsibilities.
  def self.responsibilities
   [[I18n.t('activerecord.attributes.membership.resp_option_local'), 'local'],
    [I18n.t('activerecord.attributes.membership.resp_option_dept'), 'dept'],
    [I18n.t('activerecord.attributes.membership.resp_option_nation'), 'nation']
   ]
  end

  # Returns a unique identifier used for payment identification.
  def payment_identifier
    clean_identifier((self.renew ? "R" : "A") + self.id.to_s + " " + self.last_name.strip + " " + self.first_name.strip).upcase
  end

  # Returns the confirmed payments
  def self.find_paid
    where('payment_error = ?', "00000")
  end

  # Returns the tentative of memberships that failed or were cancelled.
  def self.find_unpaid
    where('payment_error is null or payment_error != ?', "00000").
    where('not exists (
              select 1 from memberships paid 
              where paid.email = memberships.email 
              and paid.payment_error = ?
              and paid.created_at > memberships.created_at
            )', "00000")
  end

  # Returns the content as a string used for display.  
  def to_s
    "#{I18n.l(created_at)} : #{payment_identifier} (#{email}) #{number_to_currency(amount)} - #{payment_error_display} #{payment_authorization}"
  end

  # Formats phone number.
  def phone_format(phone)
    phone.nil? ? "" : phone.gsub(/\D/, "").gsub(/(\d{2,})(\d{2})(\d{2})(\d{2})(\d{2})/, "\\1 \\2 \\3 \\4 \\5")
  end

  # Returns the header of a file used for export (csv format).  
  def self.header_to_csv
    "Nom;" +
    "Prenom;" +
    "Naissance;" +
    "Sexe;" +
    "Adresse;" +
    "CodePostal;" +
    "Ville;" +
    "Pays;" +
    "ComiteLocal;" +
    "Departement;" +
    "TelephoneFixe;" +
    "TelephoneMobile;" +
    "Email;" +
    "Profession;" +
    "EngagementAsso;" +
    "ResponsabiliteAsso;" +
    "EngagementSyndical;" +
    "ResponsabiliteSyndicale;" +
    "MandatElectif;" +
    "LieuMandatElectif;" +
    "Montant;" +
    "Identifiant;" +
    "Commentaire"
  end

  # Returns the content as a string used for export (csv format).  
  def to_csv
    "#{clean_identifier last_name};" + 
    "#{clean_identifier first_name};" + 
    "#{birthdate.nil? ? '' : I18n.l(birthdate,:format => '%d/%m/%Y')};" + 
    "#{escape_csv gender};" +
    "#{escape_csv address};" +
    "#{escape_csv zip_code};" +
    "#{escape_csv city};" +
    "#{escape_csv country};" +
    "#{escape_csv committee};" +
    "#{escape_csv department};" +
    "#{phone_format phone};" +
    "#{phone_format mobile};" +
    "#{escape_csv email};" +
    "#{escape_csv job};" +
    "#{escape_csv assoc};" +
    "#{escape_csv assoc_resp};" +
    "#{escape_csv union};" +
    "#{escape_csv union_resp};" +
    "#{escape_csv mandate};" +
    "#{escape_csv mandate_place};" +
    "#{number_with_precision(amount, :precision => 2, :separator => '.')};" +
    "#{escape_csv payment_identifier};" +
    "#{escape_csv comment}"
  end

  # Triggers an email notification for a new membership.
  def email_notification
    recipients = User.notification_recipients "notification_membership"
    if not recipients.empty?
      Notification.notification_membership(self.email,
                                           recipients.join(', '),
                                           I18n.t(self.renew ?
                                                    'mailer.notification_membership_subject_renew' :
                                                    'mailer.notification_membership_subject'),
                                           self.first_name,
                                           self.last_name,
                                           self.gender,
                                           self.email,
                                           self.address,
                                           self.zip_code,
                                           self.city,
                                           self.country,
                                           self.phone,
                                           self.mobile,
                                           self.renew,
                                           self.department,
                                           self.committee,
                                           self.birthdate,
                                           self.job,
                                           self.mandate,
                                           self.union,
                                           self.union_resp,
                                           self.assoc,
                                           self.assoc_resp,
                                           self.mandate_place,
                                           self.comment,
                                           self.amount,
                                           self.payment_identifier).deliver
    end
    Receipt.receipt_membership(Devise.mailer_sender,
                               self.email,
                               I18n.t('mailer.receipt_membership_subject'),
                               self.first_name,
                               self.last_name).deliver
  end

  # For logs in Administration panel
  scope :logs, -> { order('created_at DESC') }
  scope :paid_logs, -> { Membership::find_paid.order('created_at DESC') }
  scope :unpaid_logs, -> { Membership::find_unpaid.order('created_at DESC') }
  scope :filtered_by, lambda { |search| where('lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(email) LIKE ?', "%#{search.downcase.strip}%", "%#{search.downcase.strip}%", "%#{search.downcase.strip}%") }
end