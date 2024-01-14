require_relative '../models/article' # Add import statement for Article model
require_relative '../models/search_log' # Add import statement for SearchLog model
require 'ipaddr' # Add import statement for IPAddr

class ArticlesController < ApplicationController
  def index
    if params[:search].present?
      @articles = Article.where('lower(title) LIKE ?', "%#{params[:search].downcase}%")
      if @articles.exists?
        @articles.each { |article| log_search(article.title, request) }
      else
        @no_results_message = "No articles found with the title '#{params[:search]}'"
      end
    else
      @articles = Article.all
    end
  
    respond_to do |format|
      format.html
      format.json { render json: @articles }
    end

  end
  def record_search
    query = params[:search]
  
    if valid_search?(query)
      log_search(query, request)
      render json: { success: true, message: "Search recorded successfully" }
    else
      render json: { success: false, message: "Invalid or repetitive search query" }
    end
  end

  private

  def valid_search?(query)
    !query.blank? && !SearchLog.exists?(query: query)
  end

  def log_search(article_title, request)
    ip_address = extract_ipv4(request.remote_ip)
    country = request.location.country
    operating_system = extract_os(request.user_agent)
  
    search_log = SearchLog.find_or_initialize_by(query: article_title)
    search_log.ip_address = ip_address
    search_log.country = country
    search_log.operating_system = operating_system
  
    search_log.search_count = search_log.search_count.to_i + 1
    search_log.last_searched = Time.current
    search_log.save
  end  

  def extract_ipv4(ip)
    ip_addr = IPAddr.new(ip)
    ip_addr.ipv4_mapped? ? ip_addr.native.to_s : ip
  rescue IPAddr::InvalidAddressError
    ip
  end

  def extract_os(user_agent)
    os = case user_agent
         when /Windows NT 10.0/ then 'Windows 10'
         when /Windows NT 6.3/ then 'Windows 8.1'
         when /Windows NT 6.2/ then 'Windows 8'
         when /Windows NT 6.1/ then 'Windows 7'
         when /Windows NT 6.0/ then 'Windows Vista'
         when /Windows NT 5.1/ then 'Windows XP'
         when /Macintosh|Mac OS X/ then 'Mac OS X'
         when /Linux/ then 'Linux'
         when /X11/ then 'UNIX'
         else 'Unknown'
         end
    os
  end
end
