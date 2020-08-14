class ScrappingMairie
  #methode qui récupère le mails des mairies
  def get_townhall_email(townhall_url)
    townhall_page = Nokogiri::HTML(open(townhall_url))
    townhall_page.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").each do |node|
      return node.text
    end
  end

  #methode qui récupère toutes les url de la ville du val d'oise
  def get_townhall_list_and_url
    townhall_list_page = Nokogiri::HTML(open("https://annuaire-des-mairies.com/val-d-oise.html"))
    town_list = townhall_list_page.xpath("//td/p/a").map{|node| node.text}
    town_url = townhall_list_page.xpath("//td/p/a/@href").map{|node| "https://annuaire-des-mairies.com/#{node.text[2..-1]}"}
    return town_list.zip(town_url)
  end
  
  #methode qui donne l'array de chaque ville avec l'email correspondant
  def get_email_list
    return get_townhall_list_and_url.map{|town, url| {town => get_townhall_email(url)}}
  end

  #methode l'enregistrant dans un fichier CSV
  def save_as_csv
    temp = get_email_list.map{|hash| hash.map{|k, v| [k, v]}}
    temp = temp.map { |data| data.join(",") }.join("\n")
    File.open("db/emails.csv", "w") do |csv|
      csv.write(temp)
    end
  end

  def perform
    save_as_csv
  end

end
