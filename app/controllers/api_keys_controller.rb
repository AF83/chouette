class ApiKeysController < ChouetteController
  defaults :resource_class => Api::V1::ApiKey

  belongs_to :referential

  def create
    create! { referential_path(@referential) }
  end
  def update
    update! { referential_path(@referential) }
  end
  def destroy
    destroy! { referential_path(@referential) }
  end
  
end

