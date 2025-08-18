require "rtesseract"
require "mini_magick"
require "openai"

class ProcessReceiptJob < ApplicationJob
  queue_as :default

  def perform(purchase)
    p "--- Iniciando job boleta ##{purchase.id}..."
    return unless purchase.receipt_file.attached?

    extracted_text = extract_text_from_receipt(purchase)
    return if extracted_text.blank?

    p "--- Texto extraído."

    # client = OpenAI::Client.new(access_token: Rails.application.credentials.groq[:api_key], uri_base: "https://api.groq.com/openai/v1")
    # response = client.chat(
    #   parameters: {
    #     model: "llama3-8b-8192",
    #     messages: [ { role: "user", content: build_prompt(extracted_text) } ],
    #     temperature: 0.1 # Poca creatividad para que sea preciso
    #   }
    # )

    # json_response = response.dig("choices", 0, "message", "content")
    json_response = {
      "store_name": "Tienda de Prueba",
      "store_rut": "77.777.777-7",
      "purchase_date": "2025-08-17",
      "total_amount": 12345,
      "items": [
        { "name": "Producto de Prueba 1", "quantity": 2, "price": 5000 },
        { "name": "Producto de Prueba 2", "quantity": 1, "price": 2345 }
      ]
    }.to_json

    if json_response
      begin
        parsed_data = JSON.parse(json_response)

        p "**************************************"
        p "--- PARSED_DATAS::"
        p parsed_data

        purchase.update!(
          store_name: parsed_data["store_name"],
          store_rut: parsed_data["store_rut"],
          purchase_date: parsed_data["purchase_date"],
          total_amount: parsed_data["total_amount"],
          items: parsed_data["items"],
          status: "completed"
        )
        p "Boleta ##{purchase.id} procesada y guardada."
      rescue JSON::ParserError => e
        p "Error: No es un JSON válido. #{e.message}"
        purchase.update(status: "failed")
      rescue => e
        p "Al actualizar la boleta: #{e.message}"
        purchase.update(status: "failed")
      end
    else
      p "Error: No devolvió contenido."
      purchase.update(status: "failed")
    end
  end

  private

  def extract_text_from_receipt(purchase)
    purchase.receipt_file.blob.open do |temp_file|
      image_path = if purchase.receipt_file.content_type == "application/pdf"
        MiniMagick::Image.open(temp_file.path).format("jpg").path
      else
        temp_file.path
      end

      RTesseract.new(image_path, lang: "spa").to_s
    end
  end

  def build_prompt(text)
    <<~PROMPT
    Eres un asistente experto en procesar boletas de compra chilenas. A continuación te entrego el texto extraído de una boleta usando OCR.
    Tu única tarea es analizarlo y devolverme exclusivamente un objeto JSON. No incluyas explicaciones, comentarios ni la palabra "json" al principio.

    La estructura del JSON debe ser la siguiente:
    {
      "store_name": "Nombre del local comercial",
      "store_rut": "RUT del local en formato XX.XXX.XXX-X",
      "purchase_date": "Fecha de la compra en formato AAAA-MM-DD",
      "total_amount": 15590 (debe ser un número, sin comas ni puntos de miles),
      "items": [
        { "name": "Descripción del producto", "quantity": 1 (debe ser un número, si no aparece, asume 1), "price": 2990 (debe ser un número) }
      ]
    }

    Si no puedes encontrar un campo, déjalo con el valor null, pero mantén la estructura.

    Aquí está el texto de la boleta:
    ---
    #{text}
    ---
    PROMPT
  end
end
