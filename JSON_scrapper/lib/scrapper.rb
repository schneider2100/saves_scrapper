class ScrappingMairie
  #methode qui récupère le mails des mairies
  def get_townhall_email(townhall_url)
    page = Nokogiri::HTML(open(townhall_url))   
    nom = page.xpath("//strong[1]/a").text
    mail = page.xpath("//tr[4]/td[2]")[0].text
    mail == "" ? {nom => "aucun mail disponible"} : {nom => mail}
  end

  #methode qui récupère toutes les url de la ville du val d'oise
  def get_townhall_urls
    page = Nokogiri::HTML(open("https://www.annuaire-des-mairies.com/val-d-oise.html"))
    page.xpath("//tr/td/p/a/@href").map {|get_townhall_urls| "https://www.annuaire-des-mairies.com" + get_townhall_urls.text.delete_prefix(".")}
  end

  #methode l'enregistrant dans un fichier JSON
  def save_as_JSON(scrap)
    File.open("db/emails.JSON","w") do |f|
      f.write(scrap.to_json)
    end
  end

  def perform
    scrap = []
    get_townhall_urls.each do |url|
      get_townhall_email(url)
      puts get_townhall_email(url)
      scrap << get_townhall_email(url)
    end
    save_as_JSON(scrap)
  end

end
