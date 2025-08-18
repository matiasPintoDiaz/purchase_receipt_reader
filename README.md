# README

# 📄 Procesador Inteligente de Boletas con IA

Una aplicación web full-stack que automatiza la tediosa tarea de digitalizar boletas de compra. Sube una foto o un PDF y deja que el OCR y la Inteligencia Artificial hagan el trabajo pesado.

---
## 🌟 Descripción General

Este proyecto es una solución completa construida en **Ruby on Rails** para extraer y estructurar información de boletas de compra chilenas. La aplicación utiliza una cadena de procesamiento asíncrono que combina un motor de **OCR (Tesseract)** para leer el texto y una **API de IA (Groq con Llama 3)** para interpretar, estructurar y devolver los datos en un formato limpio y utilizable (JSON).

El resultado se presenta al usuario en un formulario pre-rellenado, permitiéndole revisar, corregir y guardar la información de forma definitiva en una base de datos **PostgreSQL**.



## ✨ Características Principales

* **Subida de Archivos Flexibles:** Soporta imágenes (`JPG`, `PNG`) y documentos `PDF`.
* **Procesamiento Asíncrono:** Gracias a **GoodJob**, el procesamiento de archivos se realiza en segundo plano, proporcionando una experiencia de usuario fluida y sin esperas.
* **Extracción de Texto (OCR):** Integra **Tesseract** para una precisa conversión de imagen a texto, optimizado para el idioma español.
* **Conversión de PDF:** Usa **ImageMagick** y **Ghostscript** para convertir PDFs a imágenes antes del análisis OCR.
* **Estructuración con IA:** Se conecta a una API de IA de alta velocidad para interpretar el texto desestructurado y devolverlo en un formato JSON limpio.
* **Formulario de Revisión:** Permite al usuario validar y corregir fácilmente los datos extraídos por la IA.
* **Actualización en Tiempo Real:** La página de resultados usa **Polling con JavaScript** y **Turbo** para refrescarse automáticamente cuando el procesamiento ha finalizado.
* **Historial de Compras:** Muestra una lista de todas las boletas procesadas en la página principal.

## 🛠️ Tech Stack

| Área                    | Tecnología                                         |
| :---------------------- | :------------------------------------------------- |
| **Backend** | Ruby on Rails, PostgreSQL, Puma                    |
| **Jobs en Segundo Plano** | GoodJob                                            |
| **Subida de Archivos** | Active Storage                                     |
| **Procesamiento de Archivos**| Tesseract, ImageMagick, Ghostscript                |
| **Inteligencia Artificial**| API de Groq (Llama 3), Gema `ruby-openai`          |
| **Frontend** | ERB, CSS, JavaScript (Vanilla JS)                  |

## ⚙️ Prerrequisitos

Antes de empezar, asegúrate de tener instalado el siguiente software en tu sistema (instrucciones enfocadas en **Windows**):

* [Ruby](https://rubyinstaller.org/) (versión 3.4.0+ recomendada)
* [Bundler](https://bundler.io/) (`gem install bundler`)
* [Node.js](https://nodejs.org/en) y [Yarn](https://classic.yarnpkg.com/en/docs/install#windows-stable)
* [PostgreSQL](https://www.postgresql.org/download/)
* [Tesseract OCR](https://github.com/UB-Mannheim/tesseract/wiki)
    * *Importante:* Durante la instalación, **incluir los datos de idioma para Español (`spa`)**.
* [ImageMagick](https://imagemagick.org/script/download.php#windows)
    * *Importante:* Durante la instalación, marcar la casilla para **añadirlo al PATH del sistema**.
* [Ghostscript](https://ghostscript.com/releases/gsdnld.html)

## 🚀 Instalación y Puesta en Marcha

Sigue estos pasos para poner a correr el proyecto en tu máquina local.

**1. Clonar el Repositorio**
```bash
git clone [https://github.com/tu-usuario/tu-repositorio.git](https://github.com/tu-usuario/tu-repositorio.git)
cd tu-repositorio
```

**2. Instalar Dependencias de Ruby**
```bash
bundle install
```

**3. Configurar Variables de Entorno (¡Crítico para Windows!)**

Para que la aplicación pueda encontrar Tesseract e ImageMagick, debes configurar las variables de entorno de tu sistema:

* **Añadir Tesseract al PATH:**
    * Añade la ruta `C:\Program Files\Tesseract-OCR` a tu variable de entorno `PATH`.
* **Crear `TESSDATA_PREFIX`:**
    * Crea una **nueva** variable de entorno del sistema llamada `TESSDATA_PREFIX`.
    * Asígnale el valor `C:\Program Files\Tesseract-OCR\tessdata`.

**Importante:** Después de cambiar las variables de entorno, **debes reiniciar tu terminal** (o incluso el computador) para que los cambios surtan efecto.

**4. Configurar la Base de Datos**
```bash
rails db:create
rails db:migrate
```

**5. Configurar las Credenciales de la IA**

La aplicación necesita una API key para funcionar. Usamos el proveedor **Groq** que ofrece una capa gratuita generosa.

1.  **Obtén tu API Key:** Crea una cuenta gratis en [GroqCloud](https://console.groq.com/keys) y genera una clave.
2.  **Edita las credenciales de Rails:**
    ```bash
    rails credentials:edit
    ```
3.  En el archivo que se abra, pega tu clave con la siguiente estructura:
    ```yaml
    groq:
      api_key: "pega-aqui-tu-clave-secreta-de-groq"
    ```
4.  Guarda y cierra el editor.

**6. Iniciar la Aplicación**
```bash
rails s
```
En el entorno de desarrollo, GoodJob se ejecuta automáticamente dentro del proceso del servidor Rails, por lo que no necesitas iniciar un trabajador por separado. ¡Visita `http://localhost:3000` en tu navegador y listo!