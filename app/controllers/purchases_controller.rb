class PurchasesController < ApplicationController
  def new
    @purchase = Purchase.new
    @purchases = Purchase.order(created_at: :desc)
  end

  def create
    # Crea una nueva instancia de Purchase con el archivo adjunto
    @purchase = Purchase.new(purchase_params_for_create)

    if @purchase.save
      ProcessReceiptJob.perform_later(@purchase)

      redirect_to @purchase, notice: "Boleta subida exitosamente. Procesando..."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  def edit
    @purchase = Purchase.find(params[:id])
  end

  def update
    @purchase = Purchase.find(params[:id])
    if @purchase.update(purchase_params_for_update)
      redirect_to @purchase, notice: "¡Compra actualizada exitosamente!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def status
    purchase = Purchase.find(params[:id])
    render json: { status: purchase.status }
  end

  private

  def purchase_params_for_create
    params.require(:purchase).permit(:receipt_file)
  end

  def purchase_params_for_update
    params[:purchase][:items] = JSON.parse(params[:purchase][:items]) if params[:purchase][:items].is_a?(String)

    params.require(:purchase).permit(
      :store_name,
      :store_rut,
      :purchase_date,
      :total_amount,
      items: [ :name, :quantity, :price ]
    )
  rescue JSON::ParserError
    # Si el JSON es inválido, le pasamos un string vacío para que falle la validación
    params[:purchase][:items] = ""
    params.require(:purchase).permit(:store_name, :store_rut, :purchase_date, :total_amount, :items)
  end
end
