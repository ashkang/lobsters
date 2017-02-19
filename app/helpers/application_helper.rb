module ApplicationHelper
  MAX_PAGES = 15

  def break_long_words(str, len = 30)
    safe_join(str.split(" ").map{|w|
      if w.length > len
        safe_join(w.split(/(.{#{len}})/), "<wbr>".html_safe)
      else
        w
      end
    }, " ")
  end

  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class=\"flash-error\">\n"
      object.errors.full_messages.each do |error|
        html << error << "<br>"
      end
      html << "</div>\n"
    end

    raw(html)
  end

  def page_numbers_for_pagination(max, cur)
    if max <= MAX_PAGES
      return (1 .. max).to_a
    end

    pages = (cur - (MAX_PAGES / 2) + 1 .. cur + (MAX_PAGES / 2) - 1).to_a

    while pages[0] < 1
      pages.push (pages.last + 1)
      pages.shift
    end

    while pages.last > max
      if pages[0] > 1
        pages.unshift (pages[0] - 1)
      end
      pages.pop
    end

    if pages[0] != 1
      if pages[0] != 2
        pages.unshift "..."
      end
      pages.unshift 1
    end

    if pages.last != max
      if pages.last != max - 1
        pages.push "..."
      end
      pages.push max
    end

    pages
  end

  def time_ago_in_words_label(time, options = {})
    ago = ""
    secs = (Time.now - time).to_i
    if secs <= 5
      ago = I18n.t('helpers.time.now')
    elsif secs < 60
      ago = I18n.t('helpers.time.minute')
    elsif secs < (60 * 60)
      mins = (secs / 60.0).floor
      ago = I18n.t('helpers.time.mins', :mins => mins)
    elsif secs < (60 * 60 * 48)
      hours = (secs / 60.0 / 60.0).floor
      ago = I18n.t('helpers.time.hours', :hours => hours)
    elsif secs < (60 * 60 * 24 * 30)
      days = (secs / 60.0 / 60.0 / 24.0).floor
      I18n.t('helpers.time.days', :days => days)
    elsif secs < (60 * 60 * 24 * 365)
      months = (secs / 60.0 / 60.0 / 24.0 / 30.0).floor
      I18n.t('helpers.time.months', :months => months)
    else
      years = (secs / 60.0 / 60.0 / 24.0 / 365.0).floor
      I18n.t('helpers.time.years', :years => years)
    end

    raw(content_tag(:span, to_farsi_number(ago), :title => time.strftime("%F %T %z")))
  end

  def to_farsi_number(string)
    string.gsub! '0', '۰'
    string.gsub! '1', '۱'
    string.gsub! '2', '۲'
    string.gsub! '3', '۳'
    string.gsub! '4', '۴'
    string.gsub! '5', '۵'
    string.gsub! '6', '۶'
    string.gsub! '7', '۷'
    string.gsub! '8', '۸'
    string.gsub! '9', '۹'

    string
  end

end
