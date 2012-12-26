#require 'ox'
require 'httparty'
require 'rubygems'
require 'active_support/all'
require 'builder'
require 'app_utils'
require 'run_time_environment'
  
class CasusSvcs
  include HTTParty
  self.debug_output DEBUG_OUTPUT == 'STDOUT' ? $stderr : (RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null')
	#self.debug_output $stderr
  self.base_uri "https://app1.med-u.org/tools/app/webservices"

  if RunTimeEnvironment.is_test? || RunTimeEnvironment.is_development? || RunTimeEnvironment.is_staging?
    self.base_uri "http://testme.instruct.eu/servlets2/test2/app/webservices"
  end
  puts "CasusSvcs env: " + RunTimeEnvironment.get_runtime_environment  + " base uri: " +  self.base_uri

#  self.base_uri "https://app1.med-u.org/author/app/webservices"
#  self.base_uri "https://testme.instruct.eu/servlets2/test2/app/webservices"
  self.format :xml
#	self.class.http.ssl_version = :TLSv1 # so https certificates work??

  def initialize(key = "3WdKr1xlCts1iU5CvMVPVoPa1N2vVpn")
    @key = key
  end

	# in rails console, cs.class.debug_output returns #<IO:<STDERR>>.  How do you set it to null?
	def set_debug_output(stream)
		self.set_debug_output stream
	end

  def cs_uri=(sURI)
    @cs_uri = sURI
  end

  def cs_uri
    @cs_uri
  end

  def cs_get(uri, query)
    return self.class.get(uri, query: query)
  end

  def cs_post(uri, body)
    return self.class.post(uri,
      headers: {"Content-Type" => "text/xml"},
      query: {key: @key},
      format: :xml,
      body: body)
  end

  def cs_login(username, password)
    body = {
      :WHICH_ACTION => 'LOGIN',
  		:login => username,
  		:password => password,
  		:key => '138adlch3wdcas',
  		:Absenden => ''}
  	begin
      resp = self.class.post( "https://app1.med-u.org/player/app/loginwebservice.xml", #"https://testme.instruct.eu/servlets2/test2/app/loginwebservice.xml",
                              body: body)
      return resp.parsed_response['Response']
    rescue
      # see: http://www.assembla.com/code/analisis/git/nodes/web/vendor/plugins/twitter/lib/twitter.rb?rev=153d8b248880495a68f51bad0dc37d8c484cf802
      # for alternate way to handle HTTP error codes
      return "Login failed for user: "+ username
   end

  end


  def cs_getGroup(groupID)
    query = {
      key: @key,
  		casus_group_id: groupID
  		}
    cs_get("/group_service.xml", query)
  end

  def cs_setGroup(hGrp)
    cs_post("/group_service.xml", request(hGroup_to_xml(hGrp)))
  end

	def cs_getInstructorsByGroup(groupID)
		query = {
				key: @key,
				user_type: 'tutors,instructors',
				request_group_id: groupID
		}
		begin
			cs_get("/user_service.xml", query)
		rescue
			p 'getInstructorsByGroup failed'
		end
	end

  def cs_getUserByID(userID)
    query = {
      key: @key,
  		casus_user_id: userID
  		}
    cs_get("/user_service.xml", query)
  end

=begin
	def cs_getUser(userID)
		if userID.is_a?(Integer)
			hResp = cs_getUserByID(userID)
			userID = userID.to_s
		else
			hResp = cs_getUserByLogin(userID)
		end
		ub = UserBlob.new
		ub.query = userID
		ub.source = 'Casus'
		ub.errno = hResp['response']['result_error']['error_id'].to_i
		ub.error = hResp['response']['result_error']['error_text']
		unless 0 == ub.errno
			return ub
		end
		hUser = user_casus_to_local(hResp['response']['user'])
		ub.user = User.new(hUser)
		arAcls = parseCasusAclList(hResp['response']['acls']['acl'])
		ub.bookings = arAcls[:bookings]
		ub.tutors = arAcls[:tutors]

		return ub
	end
=end

  def cs_getUserByLogin(login)
    query = {
      key: @key,
  		login: login
  		}
  	begin
      cs_get("/user_service.xml", query)
    rescue
      p 'getUserByLogin failed'
    end

  end

  def cs_userToXML(hUser, hUserRole, hCGT, hCB)
    xUR = hUserRole_to_xml(hUserRole) unless hUserRole.nil?
    xCGT = hCGT_to_xml(hCGT) unless hCGT.nil?
    xCB = hCourseBooking_to_xml(hCB) unless hCB.nil?
    xAcls = ""
#    xAcls = hAcls_to_xml([xUR, xCGT, xCB])
    xRequest = request(hUser_to_xml(hUser)+xAcls)
    pp xRequest
  end

  def cs_setUser(xRequest)
    cs_post("/user_service.xml", xRequest) #request(hUser_to_xml(hUser))
  end

  def cs_getSub(groupID, courseID)
    query = {
      key: @key,
  		casus_group_id: groupID,
  		project_id: courseID
  		}
    cs_get("/subscription_service.xml", query)
  end

  def cs_setSub(hSub)
#    p hSub_to_xml(hSub)
    cs_post("/subscription_service.xml", request(hSub_to_xml(hSub)))
  end

  def group_casus_to_local(hGrp)
    # rename the hash keys to the local database columns
    swap_keys(hGrp, {'name' => 'account_name',
      'country' => 'shipping_country',
      'state' => 'shipping_state',
      'emaildomain' => 'email_domains',
      'group_id' => 'casus_group_id'})
    # local database doesn't store the description
    hGrp.delete('descr')
    return hGrp
  end

  def user_casus_to_local(hUser)
#    hUser = hResp['response']['user']
		if hUser['password'].is_a?(Hash)
			if 'MD5' == hUser['password']['encoding']
				swap_keys(hUser, {'password' => 'pwd_md5'})
				hUser['pwd_md5'] = hUser['pwd_md5']['__content__']
			elsif 'cleartext' == hUser['password']['encoding']
				swap_keys(hUser, {'password' => 'pwd_readable'})
				hUser['pwd_readable'] = hUser['pwd_readable']['__content__']
			end
		end
	  swap_keys(hUser, {'group_id' => 'casus_group_id', 'casus_user_id' => 'user_id', 'password' => 'pwd_readable'})
	  return hUser
  end

	def user_hash_to_object(hUser)
		oUser = User.new(hUser)
		hPwd = oUser.pwd_md5
		if hPwd.is_a?(Hash) && hPwd['__content__'] && hPwd['encoding'] == "MD5"
			oUser.pwd_md5 = hPwd['__content__']
		end
		return oUser
	end

	def buildCasus(user, cbs, cgts)
		xmlRequest = ""
		xmlb = ::Builder::XmlMarkup.new(target: xmlRequest, indent: 2)
		xmlb.instruct!
		xmlb.request {
			xmlb << user.to_casus_xml

			#now process ACLs
			unless cgts.empty? && cbs.empty? # urs.empty?
				xmlb.acls {
					#unless urs.empty? # CASUS is managing user_roles, we don't need them in the CRM
					#  xmlb << urs[0].to_casus_xml
					#end

					unless cgts.empty?
						cgts.each do | cgt |
							xmlb << cgt.to_casus_xml
						end
					end

					unless cbs.empty?
						cbs.each do | cb |
							next if cb.course_id < 100   # courses < 100 are Exam Scoring courses, CASUS knows nothing about these
							xmlb << cb.to_casus_xml
						end
					end

				}
			end # unless there are no acls

		}

		return xmlRequest
	end

	def parseCasusAclList(hAcl)
		cbs = []
		cgts = []
		arAcls = []

		if hAcl.is_a?(Hash)
			arAcls << hAcl
		else
			arAcls = hAcl
		end
		arAcls.each do |acl|
			#puts acl['type'], acl['type'].class
			if acl['type'] == '3'
				cb = CourseBooking.new
				cb.user_id = acl['user_id'].to_i
				cb.group_id = hAcl_param_select(acl,'group_id').to_i
				cb.course_id = hAcl_param_select(acl, 'course_id').to_i
				cb.is_reviewer = hAcl_param_select(acl, 'is_reviewer')
				cb.invited = hAcl_param_select(acl, 'invited').to_i
				cb.project_id = hAcl_param_select(acl, 'project_id').to_i
				cb.project_id_type = hAcl_param_select(acl, 'project_id_type').to_i
				cb.expiration_date = hAcl_param_select(acl, 'expiration_date')
				cbs << cb
			elsif acl['type'] == '2'
				cgt = CourseGroupTutor.new
				cgt.user_id = acl['user_id'].to_i
				cgt.group_id = hAcl_param_select(acl,'group_id').to_i
				cgt.course_id = hAcl_param_select(acl, 'course_id').to_i
				cgt.group_enabled = hAcl_param_select(acl, 'group_enabled')
				cgts << cgt
			end
		end
		# now sort by course_id
		cbs.sort_by { | hsh | hsh[:course_id]} unless cbs.nil? or cbs.empty?
		cgts.sort_by { | hsh | hsh[:course_id]} unless cgts.nil? or cgts.empty?

		hAcls = {bookings: cbs, tutors: cgts}
		return hAcls
	end

	# return the value for the key 'param' from the list of acl_parameters
	def hAcl_param_select(hAcl, param)
		unless hAcl['parameter_list']['acl_parameter'].select { |aclp| aclp['key'] == param}.empty?
			hAcl['parameter_list']['acl_parameter'].select { |aclp| aclp['key'] == param}[0]['value']
		end
	end

	def parseCasusUser(hUser)
		swap_keys(hUser, {'group_id' => 'casus_group_id', 'casus_user_id' => 'user_id', 'password' => 'pwd_md5'})
		return user_hash_to_object(hUser)
	end


	# @param [Object] casus_user_id_or_login
	def cs_getUserFromCasus(casus_user_id_or_login)
		if casus_user_id_or_login.is_a?(String)
			hResp = cs_getUserByLogin(casus_user_id_or_login)
		elsif casus_user_id_or_login.is_a?(Integer)
			hResp = cs_getUserByID(casus_user_id_or_login)
		end
		hResult = {error: hResp['response']['result_error']['error_id'].to_i}
		if hResult[:error] == 0
			hResult.merge! user: parseCasusUser(hResp['response']['user'])
			hResult.merge! parseCasusAclList(hResp['response']['acls']['acl']) unless hResp['response']['acls'].nil?
		else
			hResult.merge! error_text: hResp['response']['result_error']['error_text']
		end
		return hResult
	end

  private

  def request(xData)
    buffer = ""
    xmlb = Builder::XmlMarkup.new(target: buffer)
    xmlb.instruct!
    xmlb.request {
      xmlb << xData
    }
    return buffer
  end

  def hSub_to_xml(hSub)
    buffer= ""
    xmlb = Builder::XmlMarkup.new(target: buffer)
    xmlb.subscription(project_id: hSub[:project_id], group_id: hSub[:group_id], enabled: hSub[:enabled])
    return buffer
  end

  def hGroup_to_xml(hGrp)
    buffer = ""
    xmlb = Builder::XmlMarkup.new(target: buffer)
    xmlb.group(group_id: hGrp[:group_id]) {
      xmlb.name(hGrp[:name]) unless hGrp[:name].nil?
      xmlb.descr(hGrp[:descr]) unless hGrp[:descr].nil?
      xmlb.country(hGrp[:country]) unless hGrp[:country].nil?
      xmlb.state(hGrp[:state]) unless hGrp[:state].nil?
      email = hGrp[:emaildomain]
      unless email.nil?
        if email.is_a?(Array) # loop through the array of email domains if it's an array
          email.each do | emaildom |
            xmlb.emaildomain(emaildom.downcase)
          end
        else # just copy in the email domain
          xmlb.emaildomain(email.downcase)
        end
      end
    }

    return buffer
  end

  def hUser_to_xml(hUser)
    buffer = ""
    xmlb = Builder::XmlMarkup.new(target: buffer)
    xmlb.user(casus_user_id: hUser['casus_user_id']) {
      xmlb.group_id(hUser['group_id']) unless hUser['group_id'].nil?
      xmlb.login(hUser['login']) unless hUser['login'].nil?
      xmlb.name(hUser['name']) unless hUser['name'].nil?
      xmlb.firstname(hUser['firstname']) unless hUser['firstname'].nil?
      xmlb.email(hUser['email'].downcase) unless hUser['email'].nil?
      xmlb.password(hUser['password'], encoding: 'MD5') unless hUser['password'].nil?
    }
    return buffer
  end



  def hAcls_to_xml(aAcls)
    buffer = ""
    logger.debug "hAcls_to_xml: #{aAcls.class}, #{aAcls.size}"
    unless aAcls.nil?
      xmlb = Builder::XmlMarkup.new(target: buffer)
      xmlb.acls{
        aAcls.each do | acl |
          unless acl.nil?
            xmlb << acl
          end
        end
        }
      end
    return buffer
  end

  def hUserRole_to_xml(hUR)
    buffer = ""

    unless hUR.nil?
      # only build xml if hUR contains something
      xmlb = Builder::XmlMarkup.new(target: buffer)
      xmlb.acl(type: 1, readable_type: 'user_roles') {
        xmlb.user_id(hUR['user_id'])
        unless hUR['parameter_list']['acl_parameter'].nil?
          xmlb.parameter_list {
            hUR['parameter_list']['acl_parameter'].each do | aclp |
              p aclp
              xmlb.acl_parameter(key: aclp['key'], value: aclp['value'], type: aclp['type'])
            end
          }
        end
      }
    end # unless hUR.nil?

    return buffer
  end

  def hCGT_to_xml(hCGT)
    buffer = ""

    unless hCGT.nil?
      xmlb = Builder::XmlMarkup.new(target: buffer)
      xmlb.acl(type: 2, readable_type: 'course_group_tutor') {
        xmlb.user_id(hCGT['user_id'])
        unless hCGT['parameter_list']['acl_parameter'].size == 0
          xmlb.parameter_list {
            hCGT['parameter_list']['acl_parameter'].each do | aclp |
              xmlb.acl_parameter(key: aclp['key'], value: aclp['value'], type: aclp['type'])
            end
          }
        end

      }
    end # unless hCGT.nil?

    return buffer
  end

  def hCourseBooking_to_xml(hCB)
    buffer = ""

    unless hCB.nil?
      xmlb = Builder::XmlMarkup.new(target: buffer)
      xmlb.acl(type: 3, readable_type: 'course_booking') {
        xmlb.user_id(hCB['user_id'])
        unless hCB['parameter_list']['acl_parameter'].size == 0
          xmlb.parameter_list {
            hCB['parameter_list']['acl_parameter'].each do | aclp |
              xmlb.acl_parameter(key: aclp['key'], value: aclp['value'], type: aclp['type'])
            end
          }
        end
      }
    end # unless hCB.nil?

    return buffer
  end

  def parse_raw_get(raw, entry)
    return [] if raw['response']['result'].nil?
    rows = raw['response']['result'][entry]['row']
    rows = [rows] unless rows.class == Array
    return rows.map {|i|
      raw_to_hash i['FL']
    }
  end

  def parse_raw_post(raw)
    return [] if raw['response']['result'].nil?
    record = raw['response']['result']['recorddetail']
    return raw_to_hash record['FL']
  end


  def raw_to_hash(raw)
    raw.map! {|r| [r['val'], r['content']]}
    Hash[raw]
  end
  
end 

