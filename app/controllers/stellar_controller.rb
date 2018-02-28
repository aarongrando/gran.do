class StellarController < ApplicationController
  
  def federation
    headers['Access-Control-Allow-Origin'] = '*'
    
    if params[:q].present? && params[:type].present?
      if params[:type] != 'name'
        response = {detail: 'type not allowed'}.to_json
        status = 200
      else
        address_match = addresses.select {|address| address[:stellar_address].gsub('+',' ') == params[:q].downcase}
        if address_match.present?
          response = address_match[0].to_json
          status = 200
        else
          response = {error: 'not-found'}.to_json
          status = 404
        end
      end
    else
      response = {detail: 'request parameters missing'}.to_json
      status = 200
    end
    
    render json: response, status: status
  end
  
  def stellar
    headers['Access-Control-Allow-Origin'] = '*'
    
    respond_to do |format| 
      format.toml
    end
  end
  
  def addresses
    [{
      stellar_address: 'aaron*gran.do',
      account_id: 'GASDAFBKX2F7BL7TE3R4BLCKZZRWKGPKIXFNCIQVJRF7QOJHPDXV4WR6'
    }, {
      stellar_address: 'test*gran.do',
      account_id: 'GDCAIP4WBYM4X4MI3MYGSXW2WXBFAUDTQ2OTB5OZAOFC467Y6Z7LU6GT'
    }]
  end
  
end
