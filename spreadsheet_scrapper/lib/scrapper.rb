class ScrappingMairie

  def get_townhall_email(townhall_url)
    page = Nokogiri::HTML(open(townhall_url))   
    nom = page.xpath("//strong[1]/a").text
    mail = page.xpath("//tr[4]/td[2]")[0].text
    mail == "" ? {nom => "aucun mail disponible"} : {nom => mail}
  end

  def get_townhall_urls
    page = Nokogiri::HTML(open("https://www.annuaire-des-mairies.com/val-d-oise.html"))
    page.xpath("//tr/td/p/a/@href").map {|get_townhall_urls| "https://www.annuaire-des-mairies.com" + get_townhall_urls.text.delete_prefix(".")}
  end

  def save_as_spreadsheet(scrap)
    session = GoogleDrive::Session.from_config("config.json")
    ws = session.spreadsheet_by_key("1Il-cReJk4sGRdeHGPVukt10t9VDwaj-_-Cenq6Og8RU").worksheets[0]
    k = 2
    ws[1, 1] = "Nom"
    ws[1, 2] = "Email"
    scrap.each do |i|
      ws[k, 1] = i.keys.join(', ')
      ws[k, 2] = i.values.join(', ')
      ws.save
      k += 1
    end
  end

  def perform
    scrap = []
    get_townhall_urls.each do |url|
      get_townhall_email(url)
      puts get_townhall_email(url)
      scrap << get_townhall_email(url)
    end
    save_as_spreadsheet(scrap)
  end

end
