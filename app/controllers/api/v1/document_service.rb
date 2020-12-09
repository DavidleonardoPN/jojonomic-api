module API
  module V1
    class DocumentService < Grape::API
      version 'v1', using: :path
      format :json

      before {
        @auth = Auth.decoded_token(headers)
        if @auth.is_a?(Array)
          @company_id = @auth.first["company_id"]
          @current_user = @auth.first["user_id"]
        elsif @auth.eql? "expired"
          error!("#{{ :response_type => 'error', :details => "Token expired" }.to_json}", 401)
        else
          error!("#{{ :response_type => 'error', :details => "Invalid token" }.to_json}", 401)
        end
      }

      resource :document_service do
        desc 'Return list of folder'
        get do
          @folders = Dsr.where(type_item: 0)
          @response = {:error => false, data: @folders}
          present @response
        end

        desc 'Insert folder'
        params do
          requires :id
          requires :name
          requires :timestamp
        end
        post '/folder' do
          @folder = Dsr.find_or_create_by(id: params[:id], name: params[:name], timestamp: params[:timestamp], owner_id: @current_user, company_id: @company_id, type_item: 0 )
          @response = {:error => false, :message => "folder created", data: @folder}
          present @response
        end

        desc 'Return list of document'
        get '/folder/:folder_id' do
          @documents = Dsr.where(folder_id: params[:folder_id], type_item: 1)
          @response = {:error => false, data: @documents}
          present @response
        end

        desc 'Delete folder'
        params do
          requires :id
        end
        delete '/folder' do
          Dsr.delete(id: params[:id])
          @response = {:error => false, :message => "Success delete folder"}
          present @response
        end

        desc 'Create document'
        params do
          requires :id
          requires :name
          requires :type_item
          requires :folder_id
          requires :content
          requires :share
          requires :timestamp
        end
        post '/document' do
          @document = Dsr.find_by(id: params[:id], folder_id: params[:folder_id])

          if @document
            @document.update(name: params[:name], timestamp: params[:timestamp], content: params[:content], folder_id: params[:folder_id], share: params[:share], owner_id: @current_user, company_id: @company_id, type_item: 1 )
          else
            @document = Dsr.create(id: params[:id], name: params[:name], timestamp: params[:timestamp], content: params[:content], folder_id: params[:folder_id], share: params[:share], owner_id: @current_user, company_id: @company_id, type_item: 1 )
          end
          @response = {:error => false, :message => "Success set document", data: @document}
          present @response
        end

        desc 'Detail document'
        get '/document/:document_id' do
          @document = Dsr.find_by(id: params[:document_id])
          @response = {:error => false, :message => "Success get document", data: @document}
          present @response
        end

        desc 'Delete document'
        params do
          requires :id
        end
        delete '/document' do
          @document = Dsr.delete(id: params[:id])
          @response = {:error => false, :message => "Success delete document"}
          present @response
        end
      end
    end
  end
end
