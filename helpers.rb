module Helpers
  def get_xpath(which)
    case which
    when 'top-level-definitions'
      i = "1"
    when 'alternatives'
      i = "4"
    when 'expressions'
      i = "7"
    else
      i = "1"
    end
    "//th[contains(text(),'Program Coverage Total')]/../td[#{i}]"
  end

  def get_coverage(html, which)
    doc = Nokogiri::HTML(html)
    case which
    when 'avg'
      x1, x2, x3 = get_xpath('top-level-definitions'), get_xpath('alternatives'), get_xpath('expressions')
      c1, c2, c3 = doc.xpath(x1).to_s, doc.xpath(x2).to_s, doc.xpath(x3).to_s
      covers = [/[0-9]{1,3}/.match(c1),
                /[0-9]{1,3}/.match(c2),
                /[0-9]{1,3}/.match(c3)].map{|i| i.to_s.to_f}
      cov = (covers.sum / 3).to_i
    else
      xpath = get_xpath(which)
      cov_html = doc.xpath(xpath).to_s
      cov = /[0-9]{1,3}/.match(cov_html).to_s.to_i
    end

    cov
  end

  def prepare_response(cov)
    case cov
    when 0..30
      color = "red"
    when 30..50
      color = "orange"
    when 50..70
      color = "yellow"
    when 70..80
      color = "yellowgreen"
    when 80..90
      color = "green"
    when 90..100
      color = "brightgreen"
    end

    content_type :json
    {
      schemaVersion: 1,
      label: "Coverage",
      message: "#{cov}%",
      color: color
    }.to_json
  end

end

# include Helpers
# require 'open-uri'
# require 'nokogiri'
# html = URI.open("https://input-output-hk.github.io/cardano-transactions/coverage/hpc_index.html").read
# cov = get_coverage html, 'avg'
# p cov
