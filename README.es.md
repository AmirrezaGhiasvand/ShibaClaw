<p align="center">
  <img src="assets/shibaclaw_logo_readme.webp" width="800" alt="ShibaClaw">
</p>

<h1 align="center">ShibaClaw 🐕</h1>
<h3 align="center">El agente de IA que <b>simplemente funciona</b> — de forma segura, privada y sin supervisión.</h3>

> Traducción de [README.md](./README.md) — puede no estar actualizada (sincronizado a v0.9.4).

<p align="center">
  <a href="https://pypi.org/project/shibaclaw/"><img src="https://img.shields.io/pypi/v/shibaclaw.svg?style=flat-square&color=orange" alt="version"></a>   
  <a href="https://pepy.tech/projects/shibaclaw"><img src="https://static.pepy.tech/personalized-badge/shibaclaw?period=total&units=ABBREVIATION&left_color=YELLOWGREEN&right_color=ORANGE&left_text=downloads" alt="PyPI Downloads"></a>
  <img src="https://img.shields.io/badge/python-%3E%3D3.11-blue?style=flat-square&logo=python&logoColor=white" alt="python">
  <a href="https://github.com/RikyZ90/ShibaClaw/blob/main/LICENSE"><img src="https://img.shields.io/github/license/RikyZ90/ShibaClaw?style=flat-square&label=license&color=blue" alt="license"></a>
  <a href="https://deepwiki.com/RikyZ90/ShibaClaw"><img src="https://deepwiki.com/badge.svg" alt="Ask DeepWiki"></a>
</p>

<p align="center">
  <b>23 Proveedores · 11 Canales de Chat · WebUI Integrada · Núcleo con Seguridad Primero · Listo para MCP</b>
</p>

<h3 align="center">Construido sobre tres pilares: <b>Simplicidad · Seguridad · Privacidad</b></h3>

***

<details open>
<summary>📢 <b>Última versión: v0.9.4</b> — Haz clic para ver las novedades</summary>

- **Auto-actualización en Linux bloqueada en v0.9.2** — Se corrigió un bug donde `_get_version()` reportaba una versión obsoleta del manifiesto empaquetado incluso tras una actualización pip/pipx exitosa. La resolución de versión ahora prefiere los metadatos del paquete instalado, asegurando la convergencia correcta del actualizador.

Consulta el [Changelog](./CHANGELOG.md) para la historia completa de versiones.

</details>

***

<p align="center">
  <img src="assets/webui_chat.webp" width="380" height="250" alt="WebUI Chat with Agent">
  <img src="assets/webui_welcome.webp" width="380" height="250" alt="WebUI Welcome Screen">
  <img src="assets/settings.webp" width="420" height="250" alt="Settings">
</p>

***

## ⚡ Inicio Rápido

### 🚀 Instalador Automático (Recomendado)

La forma más sencilla de empezar. Un solo comando descarga la última versión, crea accesos directos e inicia la interfaz.

**Trae tu propio modelo**: Conéctate sin problemas a endpoints locales (Ollama, LM Studio) o usa niveles gratuitos de API vía OpenRouter para chatear a costo cero.

**Windows (PowerShell):**
```powershell
iwr -useb https://github.com/RikyZ90/ShibaClaw/releases/latest/download/install.ps1 | iex
```

**Linux / macOS (Terminal):**
```bash
curl -fsSL https://github.com/RikyZ90/ShibaClaw/releases/latest/download/install.sh | bash
```

> **Nota**: En Windows, esto descarga la aplicación de escritorio precompilada desde la última GitHub Release — no requiere Python. Se crean automáticamente accesos directos en el Escritorio y Menú Inicio, y la app aparece en Aplicaciones y características para una desinstalación limpia. En Linux/macOS, el script instala vía pip en un entorno virtual aislado.

### Docker

```bash
curl -fsSL https://raw.githubusercontent.com/RikyZ90/ShibaClaw/main/docker-compose.yml -o docker-compose.yml
docker compose up -d     # obtiene la imagen de Docker Hub
docker exec -it shibaclaw-gateway shibaclaw print-token
```

Abre **http://localhost:3000**, pega el token y sigue el asistente de inicio.

Expón `shibaclaw-web` en tu LAN (p. ej. vía proxy inverso) y abre la misma URL desde tu teléfono para chatear con tu agente en móvil.

### pip

```bash
pip install shibaclaw
shibaclaw web --with-gateway   # inicia WebUI + motor del agente en :3000
```

Abre **http://localhost:3000** y sigue el asistente de inicio.  
¿Prefieres la CLI? `shibaclaw onboard` ejecuta la misma configuración guiada desde la terminal.

***

## ✨ Todo en un Solo Agente

<table>
<tr>
<td align="center" width="33%">

### 🛡️ Seguridad Primero
Auditoría CVE, envoltura de<br>inyección de prompts, guarda SSRF — <b>activado por defecto</b>

</td>
<td align="center" width="33%">

### 🧠 Memoria Inteligente
Sistema de 3 niveles con aprendizaje<br>proactivo y auto-compactación

</td>
<td align="center" width="33%">

### 🌐 23 Proveedores
SDK nativos, sin proxy LiteLLM<br>OpenAI · Anthropic · Gemini · DeepSeek...

</td>
</tr>
<tr>
<td align="center" width="33%">

### 📱 Web y Móvil
Expón la WebUI en tu LAN y<br>usa el mismo agente desde el móvil

</td>
<td align="center" width="33%">

### 🖥️ App de Escritorio
Lanzador nativo de Windows con bandeja,<br>combinación perfecta con la WebUI

</td>
<td align="center" width="33%">

### 🔌 Listo para MCP
Conecta cualquier servidor MCP,<br>herramientas auto-registradas

</td>
</tr>
</table>

***

## ¿Por qué ShibaClaw? Simplemente funciona. 🐕

> **¿Cansado de agentes que requieren más supervisión que tu propio trabajo?**  
> ShibaClaw se diseña en torno a un principio: <b>simplemente funciona</b> — de forma segura, fiable y sin mantenimiento constante.

La mayoría de los frameworks de agentes de IA tratan la seguridad como una ocurrencia tardía, te dejan luchando con la compatibilidad de proveedores o te obligan a supervisar configuraciones. ShibaClaw cambia el guion: la seguridad no es un complemento, es <b>la base</b>.

Lo que hace diferente a ShibaClaw:
- **Capas de seguridad integradas en el núcleo** — auditoría CVE en instalación, envoltura de inyección de prompts en cada resultado de herramienta, protección SSRF/reenlace DNS
- **Soporte nativo de proveedores** — 23 proveedores vía sus SDK oficiales, sin capa proxy que depurar
- **Configuración en un comando** — Docker o pip, sigue el asistente, chateas en unos minutos
- **Funciona en todas partes** — Terminal, WebUI, Discord, Telegram, WhatsApp, app de escritorio Windows y más

***

## 🛡️ Seguridad, Integrada

Defensas que normalmente están dispersas en el código de unión de la app o en proxies externos — en ShibaClaw se incluyen en el núcleo, <b>activadas por defecto</b>.

### Capas de Seguridad del Núcleo

| Capa | Qué hace |
|---|---|
| 🔍 Auditoría en instalación | Audita `pip` y `npm` antes de ejecutar — bloquea CVE críticos/altos antes de que lleguen |
| 🛡️ Envoltura de inyección de prompts y pre-escaneo | Envuelve cada resultado de herramienta en un límite `<tool_output_...>` aleatorio. Aplica pre-escaneo regex para jailbreaks y **codificación Base64** para cargas no confiables |
| 🔒 Endurecimiento de shell | 20+ patrones de denegación, normalización de escape (`\x..`, `\u....`), detección de URLs internas |
| ⚡ Motor Local-First | Emulador de comandos nativo (`ls`, `cat`) evita sobrecarga de subprocesos; respaldo `tiktoken` offline-first para ejecución aislada |
| 🌐 Guarda de red | Filtrado SSRF, revalidación de redirecciones, resolución segura contra reenlace DNS |
| 📁 Sandbox de espacio de trabajo | Herramientas de archivo y navegador bloqueados al espacio de trabajo configurado |
| 🔑 Control de acceso | Auth Bearer token, verificaciones de tiempo constante, listas blancas de canales, límite de tasa opcional |
| 🧠 Motor Distribuido | UI (≈128 MB) desacoplada del cerebro del agente (≈256 MB+) — huella mínima por proceso |

### 🛡️ Envoltura de Inyección de Prompts (Sandbox de Herramientas)

En lugar de simplemente devolver salidas crudas de herramientas al LLM, ShibaClaw envuelve cada resultado en un límite tipo XML generado dinámicamente con un <b>nonce aleatorio</b> (p. ej., `<tool_output_a1b2c3d4>`).

> 💡 <b>Defensa Independiente</b>: Este mecanismo central de seguridad (Envoltura Aleatoria de Salida de Herramientas) se ha desacoplado y empaquetado como una biblioteca Python independiente sin dependencias llamada [Muzzle](https://github.com/RikyZ90/Muzzle). Puedes usar Muzzle para proteger cualquier framework de agentes (LangChain, LlamaIndex, CrewAI, AutoGen o bucles LLM personalizados) con esta misma técnica.

Por qué importa: los atacantes a menudo intentan cerrar prematuramente etiquetas o inyectar falsas instrucciones de sistema dentro de salidas de herramientas (como contenido web). Usando un límite aleatorio generado por iteración, el agente puede distinguir de forma fiable entre instrucciones de sistema reales y cargas inyectadas. Además, cualquier intento de inyectar la etiqueta de cierre específica dentro del contenido se sanea y escapa automáticamente, asegurando que el sandbox permanezca hermético y el prompt del sistema original tenga prioridad.

### 🔍 Auto-escaneo de Paquetes en Instalación

Antes de ejecutar cualquier comando `pip`, `npm` o `apt`, ShibaClaw intercepta la acción y analiza las dependencias. Ejecuta herramientas como `pip-audit` o `npm audit --json` para escanear vulnerabilidades conocidas contra bases de datos CVE antes de aplicar cambios.

Por qué importa: desplaza la seguridad totalmente a la izquierda. En lugar de bloquear ciegamente gestores de paquetes o depender de escaneos post-instalación, evalúa el árbol de dependencias exacto <i>antes</i> de la ejecución. Si un paquete contiene CVE críticos/altos, o si se detectan banderas sospechosas (como `--allow-unauthenticated` para `apt`), se bloquea la instalación. Esto permite a la IA construir software de forma autónoma sin convertir el host en un pasivo.

Política de divulgación completa y versiones soportadas: [SECURITY.md](./SECURITY.md).

***

## 🖥️ App de Escritorio Nativa (Windows)

ShibaClaw incluye un **Lanzador de Escritorio Windows** totalmente integrado, construido con `pywebview`.  
Ofrece una experiencia local sin necesidad de gestionar ventanas de terminal en segundo plano.

- **Integración con Bandeja del Sistema**: Cierra la ventana para minimizar ShibaClaw silenciosamente a la bandeja. Clic derecho en el icono Shiba para reabrir la UI, acceder a registros, visitar el sitio o salir del motor con elegancia.
- **Auto-Login**: Al usar el Lanzador localmente, la autenticación WebUI se omite por defecto para una experiencia local más fluida.
- **WebUI Integrada**: No necesitas abrir tu navegador; la WebUI corre en un marco de ventana nativa dedicada.
- **Portátil y Ligera**: Empaquetada como una carpeta independiente con PyInstaller para ejecutarse al instante sin requerir Python en el host.

Si instalaste vía `pip`:
```bash
shibaclaw desktop
```

O descarga el ejecutable de Windows precompilado directamente desde la última versión:

> **[⬇ Descargar ShibaClaw.exe (última)](https://github.com/RikyZ90/ShibaClaw/releases/latest/download/ShibaClaw-windows.zip)**  
> Notas completas → [github.com/RikyZ90/ShibaClaw/releases/latest](https://github.com/RikyZ90/ShibaClaw/releases/latest)

***

## 🌐 WebUI

<p align="center">
  <img src="assets/settings.webp" width="420" height="250" alt="Settings">
  <img src="assets/webui_welcome.webp" width="380" height="250" alt="WebUI Welcome Screen">
  <img src="assets/webui_chat.webp" width="380" height="250" alt="WebUI Chat with Agent">
</p>

La WebUI está integrada — no requiere frontend separado ni Node.js.

Expónla en tu red local y abre la misma URL desde el móvil o tablet — sin apps extra, solo un navegador.

- **Chat** — conversaciones multi-sesión con streaming en vivo de llamadas a herramientas, bloques de pensamiento, tiempo transcurrido y cambio de modelo por sesión desde el pie del chat
- **RAG Local y Bases de Conocimiento** — arrastra o sube documentos (PDF, CSV, HTML, TXT) para crear colecciones locales, consúltalas vía búsqueda semántica y fija colecciones activas a sesiones
- **Menciones de Contexto (@)** — autocompleta y vincula bases de conocimiento, servidores MCP y apps conectadas en tus mensajes usando `@`
- **Búsqueda de modelos multi-proveedor** — un selector unificable fusiona modelos de todos los proveedores configurados, muestra etiquetas y cambia el proveedor en tiempo real
- **Perfiles de Agente** — cambia personalidades por sesión (Hacker, Builder, Planner, Reviewer) con avatares dinámicos
- **Explorador de archivos** — navega, ve y edita archivos del espacio de trabajo en el navegador (sandbox)
- **Voz** — texto a voz vía APIs de audio compatibles con OpenAI y TTS nativo del navegador
- **Ajustes** — configura modelo de sesión, memoria, proveedores, herramientas, servidores MCP, canales, skills y OAuth desde un panel
- **Asistente de inicio** — configuración guiada: elige proveedor, ingresa API key o inicia OAuth, elige modelo
- **Visor de contexto** — inspecciona el prompt del sistema y el desglose de tokens
- **Monitor de gateway** — chequeo de salud y reinicio con un clic
- **Flujos OAuth** — GitHub Copilot, OpenAI Codex y OpenRouter configurables desde ajustes; OpenRouter guarda la API key devuelta
- **Renderizado endurecido** — Markdown escapa HTML crudo, nombres de archivo vía DOM seguro, auth expirada vuelve a login sin bucles
- **Auto-actualización** — comprueba GitHub cada 12h, notifica en UI y canales
- **Centro de Notificaciones (WIP)** — campana con badge, push WebSocket en tiempo real, deep-link por notificación
- **Responsivo** — funciona en escritorio y móvil

### ⚡ Selección Dinámica de Modelo

<p align="center">
  <img src="assets/model_sel.webp" width="600" alt="Dynamic Model Selector">
</p>

Cambia de modelo por sesión — ya no un modelo global, sino una elección flexible por conversación.

- **Búsqueda Multi-Proveedor**: Busca todos los modelos de todos tus proveedores en un solo desplegable.
- **Enrutamiento Consciente de Sesión**: Cada sesión recuerda su modelo. Puedes tener una sesión de código con `Claude 3.5 Sonnet` y una de investigación con `Gemma 4` a la vez.
- **Cambio en Tiempo de Ejecución**: Cambia modelos al instante sin reiniciar; el gateway resuelve el endpoint correcto.
- **Modelo de Memoria Dedicado**: Configura un modelo y proveedor separados para consolidación y aprendizaje proactivo.
- **Por Defecto Primero**: Las nuevas sesiones inician con el modelo por defecto.

### 🤖 Perfiles de Agente

Cambia la personalidad del agente sobre la marcha sin perder contexto. Cada perfil sobreescribe el prompt del sistema (SOUL.md) compartiendo modelo, memoria y herramientas. Perfiles por sesión.

Perfiles integrados: Default · Builder · Planner · Reviewer · <b>Hacker</b> (experto en seguridad con 50+ recomendaciones de herramientas, metodologías OWASP/MITRE/NIST, puntuación CVSS y avatar cyber-shiba).

Crea tus propios perfiles de forma interactiva.

***

## 🧠 Sistema Avanzado de Memoria de 3 Niveles

La memoria de ShibaClaw no es solo un búfer de chat; es un sistema proactivo estructurado para continuidad operativa a largo plazo.

- **`USER.md` (Identidad y Preferencias):** Hechos personales duraderos, estilos de comunicación y preferencias de idioma.
- **`MEMORY.md` (Estado Operativo):** Conocimiento de trabajo del agente. Rastrea detalles del entorno, entidades recurrentes y estado del proyecto.
- **`HISTORY.md` (Archivo de Sesiones):** Registro solo-añadir, buscable, con resúmenes etiquetados y con marca de tiempo.

En lugar de inflar el prompt con miles de mensajes, ShibaClaw cuenta con un **bucle de Aprendizaje Proactivo**. Cada N mensajes, un proceso LLM en segundo plano extrae hechos nuevos y actualiza `USER.md` y `MEMORY.md` sin interrumpir. Cuando `MEMORY.md` crece demasiado, una rutina de auto-compactación resume y deduplica, priorizando el estado reciente. Cuando el agente necesita contexto antiguo, puede buscar `HISTORY.md` usando TF-IDF y puntuación de recencia.

***

## 🛠️ Funciones

### Flujo de Trabajo y Razonamiento

- **Enrutamiento de sesión modelo-primero** — cada sesión guarda su modelo y ShibaClaw resuelve el proveedor en tiempo de ejecución
- **Delegación de fondo enfocada** — la herramienta `spawn` descarga una tarea y reporta de vuelta
- **Razonamiento avanzado** — pensamiento extendido (Anthropic), esfuerzo de razonamiento (OpenAI o-series) y cadenas DeepSeek-R1

### Herramientas

| Herramienta | Qué hace |
|------|-------------|
| `exec` | Comandos shell con 20+ patrones de denegación, normalización de codificación y escaneo CVE |
| `read_file` / `write_file` / `edit_file` | Lecturas paginadas, reemplazo difuso, directorios padre auto-creados |
| `web_search` | Brave, Tavily, SearXNG, Jina o DuckDuckGo (fallback sin key) |
| `web_fetch` | HTTP con protección SSRF, defensa reenlace DNS y validación de redirección |
| `memory_search` | Búsqueda rankeada sobre historial (TF-IDF + recencia + importancia) |
| `knowledge_search` | Búsqueda semántica sobre colecciones locales (FAISS) |
| `message` | Mensajería multi-canal con adjuntos |
| `automation` | Gestiona o programa tareas (cron, intervalos, fechas ISO, zona horaria) |
| `spawn` | Worker de fondo opcional para una tarea enfocada |
| MCP | Conecta cualquier servidor MCP (stdio, SSE o HTTP) — herramientas auto-registradas como `mcp_<server>_<tool>` |

### Canales

Telegram · Discord · Slack · WhatsApp · Matrix · Email · DingTalk · Feishu · QQ · WeCom · MoChat

Todos los canales enrutan por el mismo bus de mensajes. WhatsApp usa un bridge Node.js (Baileys) para vinculación por QR.

### Skills

8 skills integradas (GitHub, weather, summarize, tmux, automation, memory guide, skill-creator, ClawHub browser). Son archivos Markdown con frontmatter YAML y scripts opcionales — crea los tuyos o instala desde [ClawHub](https://clawhub.ai/).

### Automatización

- **Motor de Automatizaciones** — tareas programadas persistentes y rutinas en segundo plano, gestionadas vía UI y guardadas en `automation.json`. Soporta `every`, `cron` y `at`. Las tareas perdidas se adelantan al inicio.
- **Integración TASK.md** — el motor usa `TASK.md` como fuente de verdad; omite el LLM cuando está vacío.

Si actualizas desde una versión antigua, `HEARTBEAT.md` quedó obsoleto. Migra a `TASK.md` y la nueva UI de Automatizaciones.

### 🔌 Plugins y TTS

- **Sistema de Plugins Instalables** — Extiende el agente con plugins Python dinámicos gestionados desde la WebUI. Ver [`docs/PLUGINS_DEVELOPMENT_GUIDE.md`](./docs/PLUGINS_DEVELOPMENT_GUIDE.md).
- **TTS Local Offline Gratuito (Supertonic)** — Síntesis de voz ONNX de alta calidad, cero costo, totalmente offline. Soporta 31 idiomas, voces personalizadas (`F1`/`M1`) y velocidad ajustable.
- **Reproductor de Audio en Navegador** — reproduce mensajes de voz en la UI con un widget glassmorphic.

***

## 🔌 Ecosistema MCP

ShibaClaw es totalmente compatible con el **Model Context Protocol (MCP)**, transformando el agente en un hub de IA conecta y usa.

En lugar de depender solo de skills integradas, ShibaClaw puede conectar a cualquier servidor MCP, otorgando acceso a fuentes de datos externas sin modificar el núcleo.

Por qué importa:
- **Extensibilidad Instantánea**: Conecta servidores MCP de la comunidad para Google Drive, Slack, GitHub, PostgreSQL y más.
- **Herramientas Estandarizadas**: Un protocolo universal para comunicación IA-herramienta.
- **Arquitectura Desacoplada**: Mantén el agente ligero mientras escalas capacidades.

Configura tus servidores MCP en el panel **Ajustes**.

### 🌐 Apps (Integración Klavis)

Para simplificar la configuración de herramientas SaaS populares (Gmail, Google Drive, Slack, GitHub, Outlook, etc.), ShibaClaw se integra con **Klavis** (`klavis.ai`).

En lugar de crear credenciales manualmente por servicio, gestiona todo vía **Connected Apps**:
- **Una sola API Key**: Obtén una key de [klavis.ai](https://klavis.ai) y guárdala en ajustes.
- **Conexiones con un Clic**: Conecta o desconecta servicios vía OAuth seguro gestionado por Klavis.
- **Servidores MCP Auto-Generados**: Al conectar, ShibaClaw configura el servidor MCP adecuado y registra sus herramientas.

***

## 🌐 Proveedores Soportados

ShibaClaw usa SDK nativos (sin proxy LiteLLM) y resuelve el proveedor activo desde el modelo seleccionado o ID canónico con prefijo. En la WebUI, todos los catálogos se fusionan en una lista buscable.

### API Key

| Proveedor | Variable de Entorno |
|----------|-------------|
| OpenAI | `OPENAI_API_KEY` |
| Anthropic | `ANTHROPIC_API_KEY` |
| DeepSeek | `DEEPSEEK_API_KEY` |
| Google Gemini | `GEMINI_API_KEY` ¹ |
| Groq | `GROQ_API_KEY` |
| Moonshot | `MOONSHOT_API_KEY` |
| MiniMax | `MINIMAX_API_KEY` |
| Zhipu AI | `ZAI_API_KEY` |
| DashScope | `DASHSCOPE_API_KEY` |

¹ Configurar `GEMINI_API_KEY` en el entorno es suficiente. El endpoint OpenAI-compatible de Google está preconfigurado.

### Gateway / Proxy

OpenRouter · AiHubMix · SiliconFlow · VolcEngine · BytePlus — auto-detectados por prefijo de key o `api_base`.

### Local

Ollama (`http://localhost:11434`) · LM Studio · llama.cpp · vLLM · cualquier endpoint OpenAI-compatible (`http://localhost:1234/v1`)

> **Nota para Docker:** Si ejecutas vía Docker Compose, `localhost` apunta dentro del contenedor. Para conectar a un servidor local en el host usa `http://host.docker.internal:1234/v1` (o `11434` para Ollama). En Linux nativo usa `http://172.17.0.1:port`.

### OAuth

| Proveedor | Flujo | Configuración |
|----------|------|-------|
| OpenRouter | Flujo PKCE navegador, guarda la API key devuelta | Ajustes WebUI |
| GitHub Copilot | Flujo dispositivo, refresco automático | `shibaclaw provider login github-copilot` o Ajustes |
| OpenAI Codex | Flujo PKCE navegador | `shibaclaw provider login openai-codex` o Ajustes |

Para OpenRouter, el callback reusa la URL/puerto de la WebUI por defecto. Si expones detrás de un proxy inverso, define `SHIBACLAW_OPENROUTER_CALLBACK_BASE_URL=https://your-public-webui-host` antes de iniciar.

### 💡 Tip Pro: Modelos Económicos y Premium

- **Modelos Gratis/Abrir:** Recomendamos **OpenRouter** para modelos gratuitos como `nvidia/nemotron-3-super-120b-a12b:free` o `gemma-4-31b-it:free`.
- **Premium Ilimitado:** Con **GitHub Copilot** OAuth obtienes modelos premium como `raptor` (`oswe-vscode-prime`) a costo cero.

***

## 📊 Comparativa de ShibaClaw (Seguridad Primero)

> Esta tabla es una **instantánea aproximada centrada en seguridad**, basada solo en lo documentado públicamente hasta mayo de 2026.  
> `❓` significa "no documentado claramente / no verificado", <b>no</b> "no existe".

| Característica de Seguridad | ShibaClaw | OpenClaw | Hermes Agent | Nanobot | ZeroClaw |
|---|:---:|:---:|:---:|:---:|:---:|
| Auditoría CVE en instalación (pip, npm, apt) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Envoltura de inyección de prompts en cada resultado | ✅ | ❌ | ❌ | ❌ | ❌ |
| Protección SSRF + reenlace DNS integrada | ✅ | ❌ | ❌ | ❌ | ❌ |

ShibaClaw se enfoca en enviar estas defensas en el núcleo, activadas por defecto.

***

## 🏗️ Arquitectura

<p align="center">
  <img src="assets/arch.png" width="800" alt="ShibaClaw Architecture">
</p>

### Docker Compose

| Servicio | Rol | Puerto por defecto |
|---------|------|--------------|
| `shibaclaw-gateway` | Bucle del agente, bus de mensajes, integraciones de canal | 19999 (HTTP) · 19998 (WS) |
| `shibaclaw-web` | WebUI (Starlette + WebSocket nativo), servicio de automatizaciones | 3000 |

Ambos comparten el volumen `~/.shibaclaw/` (config, workspace, memoria, trabajos, caché).

### Modo de un solo proceso

`shibaclaw web` ejecuta agente + WebUI + automatizaciones en un proceso — sin contenedor gateway.

### Stack

| Capa | Tecnología |
|-------|-----------|
| Servidor | Uvicorn → Starlette (ASGI) |
| Tiempo real | WebSocket nativo (`/ws` en WebUI, puerto `19998` en gateway) |
| Frontend | Vanilla JS · Marked.js · Highlight.js |
| Sesiones | JSONL solo-añadir por sesión |

### Uso de recursos

| Componente | Idle | Pico (instalar/compilar) |
|-----------|------|------------------------|
| Gateway | ~120 MB | ~350 MB |
| WebUI | ~120 MB | ~350 MB |

Docker Compose fija límite de 512 MB / 256 MB de reserva por contenedor. La salida de herramientas se transmite con buffers acotados.

***

## 🔧 Referencia CLI

```bash
shibaclaw web               # Inicia WebUI (agente + automatizaciones en proceso)
shibaclaw gateway           # Inicia solo gateway (para Docker dividido)
shibaclaw onboard           # Asistente de configuración por CLI
shibaclaw agent -m "Hello"  # Mensaje único vía terminal
shibaclaw agent             # REPL interactivo con historial
shibaclaw status            # Chequeo de proveedor, workspace, OAuth
shibaclaw print-token       # Muestra el token de auth WebUI
shibaclaw channels status   # Lista canales habilitados
shibaclaw provider login <p># Login OAuth (github-copilot, openai-codex)
shibaclaw desktop           # Lanza la app de escritorio Windows
```

***

## 🐛 Solución de Problemas

| Problema | Prueba |
|---------|-----|
| Chequeo general | `shibaclaw status` |
| Logs de contenedor | `docker logs shibaclaw-gateway` / `docker logs shibaclaw-web` |
| WebUI no conecta | Verifica token con `shibaclaw print-token`, comprueba puerto |
| Errores de proveedor | `shibaclaw status` muestra API key y estado OAuth |
| Política de seguridad | [`SECURITY.md`](./SECURITY.md) |

***

## 🤝 Contribuir

Ver [`CONTRIBUTING.md`](./CONTRIBUTING.md) — PRs bienvenidos.

Los plugins (canales y motores TTS) se extienden vía Python entry points. Ver [`docs/PLUGINS_DEVELOPMENT_GUIDE.md`](./docs/PLUGINS_DEVELOPMENT_GUIDE.md). Creación de skills en [`docs/CHANNEL_PLUGIN_GUIDE.md`](./docs/CHANNEL_PLUGIN_GUIDE.md) y el skill integrado `skill-creator`.

Integradores de gateway: ver [`docs/GATEWAY_PROTOCOL.md`](./docs/GATEWAY_PROTOCOL.md) para el contrato WebSocket en el puerto `19998`.

***

## 🌟 Únete a la Manada ShibaClaw

ShibaClaw es construido por un desarrollador, mantenido por la comunidad y creciendo rápido.  
Si te ahorró tiempo, protegió tu flujo o simplemente te hizo sonreír — <b>deja una estrella</b> ⭐

> "El agente de IA que simplemente funciona. Sin supervisión." 🐕

<p align="center">
  ⭐ <a href="https://github.com/RikyZ90/ShibaClaw">Da una estrella</a> &nbsp;·&nbsp;
  ☕ <a href="https://buymeacoffee.com/rikyz90f">Invítame un café</a> &nbsp;·&nbsp;
  🐛 <a href="https://github.com/RikyZ90/ShibaClaw/issues">Abre un issue</a> &nbsp;·&nbsp;
  🔧 <a href="https://github.com/RikyZ90/ShibaClaw/pulls">Envía un PR</a>
</p>