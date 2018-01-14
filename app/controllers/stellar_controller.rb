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
      stellar_address: 'aaron+test*gran.do',
      account_id: 'GD4EWVJQ4GROFIVXKR6GK4J4J6XIOXLJRYML3RHLAC46SWX2TBCEXSCA'
    }]
  end
  
end
