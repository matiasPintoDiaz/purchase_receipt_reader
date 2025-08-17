class PurchasesController < ApplicationController
  def new
    @purchase = Purchase.new
  end

  def create
    # 1. Crea una nueva instancia de Purchase con el archivo adjunto
    @purchase = Purchase.new(purchase_params)

    if @purchase.save
      # SI SE GUARDA CORRECTAMENTE:
      # TODO: Aquí es donde más adelante lanzaremos el background job.

      # 2. Redirige a la página de resultados (show)
      redirect_to @purchase, notice: "Boleta subida exitosamente. Procesando..."
    else
      # SI FALLA: Vuelve a mostrar el formulario
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  private

  def purchase_params
    # 3. Define los parámetros permitidos (solo el archivo por ahora)
    params.require(:purchase).permit(:receipt_file)
  end
end
