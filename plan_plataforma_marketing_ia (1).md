# Plan maestro — Plataforma híbrida de marketing digital con IA

> **Documento de contexto transferible a otro modelo de IA**  
> **Estado:** planeación preliminar, sin implementación autorizada  
> **Fecha de corte:** 17 de octubre de 2026  
> **Idioma de trabajo:** español  
> **Nombre del producto:** por definir

## 1. Contexto original y visión

El promotor del proyecto quiere desarrollar una **plataforma web de marketing digital** para múltiples clientes. Cada cliente ingresará información de su negocio, subirá un logotipo y definirá sus características de marca. La plataforma utilizará inicialmente diseños creados desde cero (con 2–3 ejemplos de referencia) y, posteriormente, podrá incorporar plantillas estandarizadas y un motor de IA conectado a **VectorCraft mediante MCP (Model Context Protocol)** para producir piezas de publicidad digital en varios formatos y plataformas.

La plataforma debe soportar campañas compuestas por varias piezas, por ejemplo **20 publicaciones, diapositivas o diseños editables**, adaptados a Facebook, Instagram, WhatsApp y X. El contenido también podría organizarse en un calendario de publicaciones y, en una etapa posterior, enviarse por correo electrónico o distribuirse a través de integraciones oficiales.

**Decisión tomada por el usuario:** la experiencia será **híbrida**: generación automatizada por instrucciones a la IA **más capacidad de edición visual por el usuario**. No se pretende decidir todavía todos los detalles de implementación; el objetivo actual es **planear, conservar el contexto y permitir cambios antes del desarrollo**.

### Objetivo de producto

Reducir el esfuerzo para crear campañas digitales coherentes con la identidad de cada marca, mediante un flujo de captura de datos, selección de plantillas, generación asistida por IA, revisión/edición y exportación; posteriormente, calendarización y publicación.

### Qué significa «híbrida» en esta planeación

- El usuario escribe un brief: «Crea 20 piezas para promover mi cafetería este mes».
- La IA propone textos, formatos, distribución de contenidos y diseños iniciales basados en el kit de marca y las plantillas.
- El usuario **puede editar** textos, imágenes, elementos y variantes de formato desde la interfaz web, según el alcance de cada fase.
- El usuario puede solicitar cambios en lenguaje natural y comparar versiones.
- El sistema permite exportar las piezas aprobadas.

No asumir que se construirá un editor de complejidad equivalente a Canva en el MVP; es una cuestión de alcance aún no decidida.

## 2. Alcance funcional previsto

### Módulo A. Clientes, cuentas y marcas

- Registro, inicio de sesión y administración de clientes.
- Cada cliente registra una o varias marcas (cantidad permitida por definir).
- Datos de marca: nombre comercial, descripción, rubro, público objetivo, tono de comunicación, paleta de colores, tipografías, logos y fotografías/productos.
- **Brand Kit** reutilizable en distintas campañas.
- Separación estricta de archivos y datos de clientes (multi-tenant).
- Roles: cliente y administrador(es) globales confirmados; permisos más finos por definir. Varios administradores pueden consultar y dar seguimiento a los clientes desde Astro.

### Módulo B. Plantillas y formatos digitales

- Biblioteca de plantillas por intención: promociones, lanzamientos, descuentos, efemérides, educación, testimonios, anuncios, etc.
- Formatos configurables según plataforma: feed, historias, publicaciones horizontales, anuncios y materiales para compartir en WhatsApp.
- Referencias de diseño iniciales: **1080×1080 px** para cuadrado, **1080×1920 px** para vertical. Son **ejemplos configurables, no una declaración de compatibilidad universal o permanente**.
- Cada plantilla debe identificar zonas editables, elementos bloqueados, dimensiones, proporción y reglas de diseño.
- Los estándares, áreas seguras y requisitos por plataforma **se verificarán** antes de publicar o desarrollar presets definitivos.

### Módulo C. Motor de generación con IA y VectorCraft MCP

- Traducir un brief publicitario a un plan de contenidos y luego a instrucciones de diseño.
- Generar varias piezas por lote a partir del Brand Kit y plantillas.
- Considerar capas y objetos editables siempre que el formato de origen/exportación lo permita.
- Mantener consistencia visual y generar variaciones, evitando publicaciones idénticas.
- Registrar estado de trabajos, errores, versiones, prompt y metadatos de cada resultado.
- Revisar calidad de texto, jerarquía visual, recortes, color y tamaño final antes de aprobar.
- Diseñar una **capa adaptadora** para VectorCraft a fin de no atar toda la plataforma a un único proveedor/motor.

### Módulo D. Editor y proceso de aprobación

- Vista previa en navegador.
- Edición visual por el cliente combinada con cambios solicitados por lenguaje natural.
- Alcance de edición por fases: primero textos, colores y sustitución de imágenes; después posición/tamaño de objetos, capas avanzadas, elementos vectoriales y otras funciones según validación.
- Estados propuestos: borrador, en revisión, cambios solicitados, aprobado, exportado, programado y publicado.
- Versiones y posibilidad de regresar a una variante anterior.
- Nota técnica: **MCP no equivale a un editor visual web**; el editor frontend deberá implementar sus propias capacidades o integrar un componente compatible con los formatos seleccionados.

### Módulo E. Calendario, exportación y distribución

- Calendario de campañas y organización por plataforma, fecha, hora y estado.
- En el MVP, exportación/descarga manual de archivos y visualización en calendario solo si el alcance lo permite.
- Posteriormente: publicación mediante API oficial de cada red donde sea viable, con permisos, autenticación y restricciones de las plataformas.
- WhatsApp se contempla como canal de **materiales promocionales y distribución autorizada**, no como mensajería masiva sin consentimiento.
- Envío por **correo electrónico** como posible función futura; no se trata de correo físico.
- Exportaciones candidatas: PNG y SVG; PDF u otros formatos sujetos a prueba técnica y necesidades comerciales.

## 3. Flujo ideal de usuario

1. Ingresar a la plataforma y crear cuenta.
2. Registrar una marca y cargar identidad visual, productos y objetivos.
3. Seleccionar el tipo de campaña y los canales digitales.
4. Elegir una plantilla o indicar el estilo deseado.
5. Redactar el brief, especificar número de piezas (por ejemplo, 5 o 20), llamado a la acción y fechas tentativas.
6. La IA estructura una propuesta de contenidos: tema y mensaje de cada pieza, copy, formato y recursos visuales.
7. El usuario revisa el plan y autoriza la generación (aprobación opcional, por definir).
8. El sistema genera las piezas mediante su motor de diseño y almacena las versiones.
9. El usuario visualiza, edita manualmente o solicita cambios a la IA.
10. Aprueba y exporta las piezas; opcionalmente, las acomoda en el calendario.
11. En etapas futuras, publica o envía automáticamente conforme a reglas y permisos.

## 4. Arquitectura conceptual **propuesta, no definitiva**

```text
[Navegador / Aplicación web]
       |
       v
[API backend / autenticación / administración]
       |---------------------> [Base de datos: cuentas, marcas, campañas, estados]
       |---------------------> [Almacenamiento: logos, imágenes y resultados]
       |
       v
[Orquestador de campañas / cola de trabajos]
       |
       +--> [Modelo IA: brief -> estrategia, copy e instrucciones]
       |
       +--> [Adaptador de diseño MCP] --> [VectorCraft CLI / MCP en entorno aislado]
       |                                              |
       |                                              v
       |                                    [Documento editable + exportaciones]
       v
[Validación / vista previa / versiones / aprobación]
       |
       +--> [Descarga]
       +--> [Calendario]
       +--> [Publicación y email: futura etapa]
```

### Stack candidato para evaluación

| Componente | Propuesta preliminar | Observaciones |
|---|---|---|
| Frontend | Astro (astro.build), HTML, CSS y TypeScript | Framework decidido; componentes interactivos según necesidad |
| Backend | Astro SSR + Node.js/TypeScript | Endpoints y orquestación local; trabajadores separados dentro de la misma máquina |
| Base de datos | PostgreSQL | Estructura relacional y estados |
| Almacenamiento | Sistema de archivos local por cliente | Archivos editables, recursos de marca y exportaciones; respaldos necesarios |
| Procesamiento diferido | Cola de trabajos + workers | Generar lotes sin bloquear la interfaz |
| IA | OpenCode con modelos configurables | Orquestación mediante API/servicio o proceso controlado; validar modo de integración |
| Diseño | VectorCraft CLI con MCP y capa adaptadora | Sujeto a pruebas funcionales y de rendimiento |
| Editor web | Por investigar | Evaluar Canvas/SVG y compatibilidad de capas/documentos |
| Integraciones externas | API oficiales, más adelante | Requieren permisos y cumplimiento de términos |

**Estos componentes no son compromisos tecnológicos definitivos.** Priorizar pruebas de concepto antes de fijar el stack.

## 5. Información verificada de VectorCraft (corte: 17-oct-2026)

Documentación consultada:

- Guía de MCP: https://vectorcraft.app/guides/vectorcraft-mcp-claude
- Descripción técnica: https://vectorcraft.run/mcp
- Repositorio: https://github.com/storytold/vectorcraft

Según la documentación disponible al momento de la consulta:

- VectorCraft proporciona un **servidor MCP mediante `vectorcraft-cli`**, accesible desde clientes compatibles con MCP.
- Puede crear, modificar y exportar arte vectorial; dispone de automatización con CLI.
- Documenta ejecución sin interfaz (`--headless`) y conexión a una aplicación local para control visible, según la versión.
- El **editor web no expone por sí mismo el servidor MCP**; el servicio que ejecute la generación debe tener el CLI/entorno correspondiente.
- Ofrece medidas para limitar acceso a directorios de lectura/escritura en la automatización.
- El formato editable `.vectorcraft` y las exportaciones SVG/PDF figuran en la documentación; verificar exportaciones raster y fidelidad para nuestras necesidades.

**Pendiente de validar por prototipo:** versión específica, instalación en el sistema operativo/servidor elegido, licencia para explotación comercial y despliegue, funcionamiento real de MCP, edición por capas, fuentes tipográficas, imágenes incrustadas, formatos, rendimiento de lotes, aislamiento entre clientes y renderizado correcto. No se afirma que la generación de 20 publicaciones esté ya demostrada en producción.

## 6. Modelo de datos conceptual (primer borrador)

- `User`: id, email, credenciales/identidad, estado.
- `Organization` / `Client`: id, propietario, nombre, plan.
- `Membership`: usuario, organización, rol.
- `Brand`: organización, nombre, descripción, audiencia, tono.
- `BrandAsset`: marca, tipo (logo/imagen/fuente), ubicación, metadatos.
- `BrandStyle`: paleta, tipografías, reglas.
- `Template`: id, categoría, formato, estructura editable, versión.
- `PlatformPreset`: canal, tamaño, área segura, requisitos, vigencia.
- `Campaign`: marca, brief, objetivo, fechas, estado.
- `CampaignItem`: campaña, canal, formato, texto, orden, estado.
- `GenerationJob`: ítem/lote, parámetros, estado, costos, errores.
- `DesignDocument`: ítem, archivo fuente editable, versión, ubicación.
- `ExportAsset`: documento, tipo, dimensiones, ubicación.
- `Review`: versión, comentario, aprobador, decisión.
- `ScheduleEntry`: ítem, canal, fecha y hora, estado.
- `Connection`: integración externa autorizada, alcance y estado (fase futura).

**Nota:** entidad y nomenclatura son orientativas. Diseñar relaciones, cardinalidades, claves e índices después de concretar alcance y permisos.

## 7. Propuesta de MVP (primera versión validable)

**Meta:** probar un flujo extremo a extremo que permita crear una campaña breve a partir de una identidad de marca y obtener diseños útiles.

### Incluye

1. Registro e inicio de sesión de un cliente.
2. Alta de una marca y carga de logo, colores y descripción.
3. Dos o tres diseños de ejemplo; generación principalmente desde cero.
4. Formulario de brief de campaña.
5. Generación de **5 piezas** mediante IA + motor VectorCraft, si la prueba de concepto confirma que es viable.
6. Vista previa de resultados y estados de generación.
7. **Edición híbrida básica**: cambios manuales a texto, color e imagen, más solicitud de regeneración en lenguaje natural. La implementación exacta dependerá de la compatibilidad de documentos.
8. Descarga de las piezas aprobadas (priorizar PNG; SVG si es viable).

### No incluir inicialmente (salvo nueva decisión)

- Editor equivalente a Canva en funciones avanzadas.
- Publicación automática multicanal.
- Envíos masivos de WhatsApp o email.
- Analítica completa del rendimiento de campañas.
- Automatizaciones complejas de calendario.
- Facturación, suscripciones y cobro.

### Criterios de aceptación propuestos

- La información de una marca se aplica consistentemente a una campaña.
- El sistema genera cinco diseños descargables con formatos válidos.
- Un usuario puede corregir al menos el texto y los colores de una pieza sin reiniciar toda la campaña.
- Los archivos del cliente A no pueden verse ni modificarse desde el cliente B.
- Los procesos fallidos presentan un error recuperable y no corrompen otros diseños.
- El sistema conserva una versión previa a la edición.

Estos son **objetivos del MVP**, no resultados ya conseguidos.

## 8. Fases de trabajo sugeridas

| Fase | Objetivo | Entregables sugeridos |
|---|---|---|
| 0. Descubrimiento | Aclarar necesidades y prioridades | Brief de producto, casos de uso, actores, restricciones, alcance MVP |
| 1. Factibilidad | Verificar VectorCraft MCP y formatos | PoC CLI/MCP con logo, texto, capas, exportación; benchmark pequeño |
| 2. Diseño de producto | Definir la experiencia híbrida | Flujos, wireframes, reglas de edición y aprobación |
| 3. Arquitectura y datos | Diseñar componentes y seguridad | ADRs, esquema de datos, contratos API, estrategia de archivos |
| 4. Desarrollo MVP | Implementar flujo completo | Gestión de marca, brief, plantillas, generación de 5 diseños, editor básico, exportación |
| 5. Evaluación | Validar calidad y utilidad | Pruebas técnicas, usabilidad, medición de costos y tiempo |
| 6. Ampliación | Campañas de 20 diseños, calendario y canales | Lotes ampliados, programación y conectores autorizados |

No se han establecido presupuesto, fechas límite, tamaño del equipo ni duración estimada: evitar inventarlos.

## 9. Riesgos y mitigaciones iniciales

| Riesgo | Impacto | Mitigación propuesta |
|---|---|---|
| MCP de VectorCraft no cumple requerimientos de edición o escala | Alto | PoC temprana, abstracción del motor, formato intermedio |
| Pérdida de capas al pasar al editor web | Alto | Probar round-trip del documento; elegir subconjunto editable y guardar fuente original |
| Tamaños/requisitos de redes cambian | Medio | Presets versionados, actualización periódica |
| Contenido generado con errores comerciales u ortográficos | Alto | Validación de copy, vista previa y aprobación humana |
| Derechos de imágenes/logos/fuentes | Alto | Registrar procedencia, permisos y términos de uso |
| Datos de clientes mezclados o expuestos | Alto | Aislamiento por tenant, autenticación, autorización y directorios segregados |
| Costos y tiempos elevados por lote | Medio/alto | Cola, límites por cliente, caching, medición y reintentos |
| Restricciones API para publicar/enviar mensajes | Alto | Integraciones por plataforma y consentimiento; descarga manual como alternativa |
| Diseño generado inconsistente con la marca | Medio/alto | Brand Kit estructurado, plantillas, reglas y revisión |

## 10. Decisiones confirmadas, hipótesis y preguntas pendientes

### Confirmado explícitamente por el usuario

- Es un proyecto de **desarrollo de plataforma web**.
- El mercado/propósito es **marketing digital**.
- La plataforma atenderá **varios clientes** con su propia información e identidad.
- Debe trabajar con **plantillas estandarizadas para redes sociales**.
- Se quiere explorar **VectorCraft mediante MCP** como motor de diseño.
- Debe permitir **generación de lotes**, con ejemplo de **20 piezas**.
- Debe ser **híbrida: automatización por IA + edición por el usuario**.
- Se contemplan **calendarización**, distribución y **correo electrónico** más adelante.
- **La prioridad actual es planeación**, no empezar a programar.
- El usuario quiere el contexto completo en un **archivo `.md` reutilizable con otro modelo**.

### Propuestas hechas por el asistente, todavía por decidir o validar

- PostgreSQL como base de datos (propuesta aceptada para planeación, aún sin implementación). Astro, Node.js/TypeScript y almacenamiento local por cliente sustituyen a Next.js/FastAPI/S3 como stack de partida.
- MVP de **5 piezas** antes de escalar a 20.
- Editor visual de alcance básico para el MVP.
- Exportación inicial preferente PNG y SVG.
- Separar el generador mediante cola de trabajos y un adaptador de VectorCraft.

### Preguntas abiertas que el próximo modelo deberá priorizar, sin asumir respuestas

1. ¿Quién es el comprador/usuario principal: agencia, pyme, profesional independiente o equipo de marketing?
2. ¿Qué partes de la edición manual deben funcionar desde el MVP: texto y colores, o manipulación completa de objetos/capas?
3. ¿Las 20 piezas son de una campaña, un mes, un calendario editorial o una mezcla de formatos?
4. ¿Se requiere crear el copy de la campaña automáticamente o el cliente debe proporcionar todos los textos?
5. ¿Se usarán imágenes proporcionadas por el cliente, banco de recursos, generación de imágenes con IA o combinación?
6. ¿Qué debe ser plantilla rígida y qué puede cambiar libremente?
7. ¿Se necesitan múltiples marcas por cliente y aprobación por varios usuarios?
8. ¿En qué mercado, idioma y condiciones regulatorias operará inicialmente?
9. ¿Habrá conexión con cuentas de redes sociales en el MVP o solo descarga?
10. ¿Qué formato editable se conservará como fuente canónica y cómo se sincronizará con el editor web?
11. ¿Qué límites de costo, rendimiento, número de usuarios y presupuesto existen?
12. ¿Qué licencia y condiciones comerciales permiten operar VectorCraft desde la estación de trabajo designada?

## 11. Próximo paso recomendado de planeación

**No empezar escribiendo código.** Elaborar primero:

1. Documento de requisitos de producto (PRD) resumido: problema, usuarios, casos de uso, requisitos funcionales y no funcionales, exclusiones y métricas de éxito.
2. Mapa de pantallas del flujo híbrido y wireframes de baja fidelidad.
3. Matriz de prioridades **MVP / siguiente versión / futuro**.
4. Plan de prueba de concepto VectorCraft: iniciar CLI/MCP, generar una pieza con logo/texto, editar texto y colores, exportar, reabrir y medir tiempos; repetir para lote pequeño.
5. Decisión de formato editable y límites del editor web después de observar la PoC.
6. Backlog inicial solo cuando las decisiones anteriores estén suficientemente claras.

## 12. Instrucciones para otro modelo que retome el proyecto

> Eres un consultor de arquitectura de software y producto. Continúa la **planeación** de una plataforma web híbrida de marketing digital que utiliza IA y potencialmente VectorCraft mediante MCP. Usa este documento como la fuente de contexto. Respeta las decisiones confirmadas y distingue claramente las propuestas de las cuestiones pendientes. No supongas que existe código, infraestructura ni un prototipo funcional. No comiences a implementar sin petición explícita. Prioriza definir requisitos, MVP, flujo de edición híbrida, arquitectura flexible, riesgos y pruebas de factibilidad del MCP. Si hace falta información, formula preguntas concretas y de alto impacto, sin repetir lo ya decidido. Cuando se te pida, actualiza este Markdown como registro vivo de decisiones y cambios.

## 13. Resumen ejecutivo para retomar rápidamente

**Producto:** aplicación web multi-cliente para generar campañas digitales con identidad visual propia.  
**Canales:** Facebook, Instagram, WhatsApp y X; email previsto para fase posterior.  
**Interacción:** IA por instrucciones + editor visual (experiencia híbrida).  
**Motor de diseño candidato:** VectorCraft CLI/MCP, sujeto a validación real.  
**Entradas:** logos, colores, datos de negocio, imágenes, brief, plantilla, canales y cantidad de piezas.  
**Salidas:** piezas editables y exportaciones; más adelante, calendario y publicación.  
**Escala objetivo ilustrativa:** campañas de 20 piezas; **MVP propuesto:** 5.  
**Estado:** únicamente planeación.  
**Principal incertidumbre técnica:** interoperabilidad VectorCraft–OpenCode–MCP–Astro, persistencia de documentos/capas y generación a escala.


## 14. Actualización de decisiones técnicas y operativas (17-oct-2026, sesión posterior)

> **Precedencia:** esta sección actualiza expresamente cualquier recomendación anterior que entre en conflicto con ella. Las referencias a Next.js, FastAPI, S3 o plantillas prediseñadas en apartados anteriores deben leerse como antecedentes, **no como stack o alcance actualmente elegidos**. Todo continúa en **fase de planeación**.

### 14.1 Plataforma web y ejecución local

- **Frontend y framework elegidos:** **Astro** (https://astro.build), con HTML, CSS y JavaScript/TypeScript. Usar renderizado del lado del servidor y endpoints donde se requiera, con adaptador de Node.js sujeto a prueba.
- **Lenguaje recomendado para integración y automatización:** **TypeScript sobre Node.js**. No introducir C# o C++ en el MVP salvo que aparezca un cuello de botella medido o una necesidad de integración nativa que los justifique.
- **Máquina de ejecución:** **estación de trabajo profesional propia**, no VPS ni servidor contratado por ahora. Cuenta con GPU; no asumir que toda tarea MCP o VectorCraft usará aceleración gráfica: comprobar dependencias y rendimiento.
- **Proceso lógico:** Astro recibe peticiones autenticadas → capa de servicios TypeScript valida y crea trabajo → worker local utiliza OpenCode → OpenCode, mediante herramientas autorizadas/MCP, solicita operaciones a VectorCraft → se validan, registran y almacenan los resultados → Astro ofrece vista previa, edición y descarga.
- El servidor web **no concede acceso arbitrario al sistema operativo** a usuarios del navegador. Ejecutar procesos con permisos restringidos, rutas predefinidas, límites de tiempo y recursos, auditoría y cola de tareas; el aislamiento entre clientes sigue siendo esencial aunque todo resida en una sola computadora.
- **Modalidad dual de OpenCode:** ejecución desatendida en segundo plano para trabajos y acceso avanzado mediante **chat sencillo en Astro**. La terminal de OpenCode se puede utilizar localmente por operadores; una consola web de comandos completa **no** forma parte del MVP.
- **Integración específica OpenCode/VectorCraft:** contrato concreto, endpoints, capacidades de control, semántica de sesiones, manejo de archivos y permisos deben verificarse en una prueba de concepto; no asumir que una terminal interactiva equivale a una API estable.

### 14.2 Cuentas, administración y operación

- Cada **cliente tiene una cuenta** propia; los datos, campañas, chats, archivos y tareas se aíslan por cliente.
- Existen **una o varias cuentas de administrador**, capaces de ingresar a **la misma plataforma Astro** mediante un panel administrativo para consultar a todos los clientes, seguir proyectos y realizar cambios según privilegios.
- La administración local fuera de Astro (por **CLI en TypeScript**) es una **opción prevista**, no un sustituto del panel web. CLI y panel deberán aplicar las mismas reglas de negocio y registrar cambios.
- Se recomienda modelo de permisos basado en roles (RBAC), sesiones seguras, operaciones auditables (actor, acción, fecha, cliente, entidad y resultado) y protecciones ante accesos cruzados.

### 14.3 Biblioteca de marca y organización física

- Por cada cliente se conserva una **carpeta raíz identificada por ID interno**, junto con registros estructurados en **PostgreSQL** (propuesto), para identidad corporativa, requisitos, campañas, resultados y trazabilidad.
- Entre los recursos de la marca pueden figurar logotipos, variaciones, paletas, tipografías con licencia, imágenes, catálogos, documentos, referentes de estilo y reglas de uso.
- Evitar usar exclusivamente nombres de clientes como rutas; usar identificadores inmutables y almacenar rutas relativas en la base de datos. Nunca permitir que un cliente controle directamente rutas del sistema.
- **Diseños:** inicialmente **generados desde cero**, utilizando **2 o 3 ejemplos** para validar capacidad, estilo y consistencia; una biblioteca extensa de plantillas no es requisito del MVP.

Ejemplo de jerarquía orientativa (no implementada):

```text
workspace/
  clients/
    <client-id>/
      brand/
        originals/
        imported/
        generated/
        brand-kit.json
      campaigns/
        <campaign-id>/
          campaign-manifest.json
          audit-log.jsonl
          design/
            part-001.vectorcraft
            part-002.vectorcraft
          exports/
          previews/
      imports/
        <import-job-id>/
          candidates.json
```

### 14.4 Adquisición supervisada de assets por URL o catálogo

**Nuevo módulo funcional: adquisición/importación de recursos.** Caso principal: el usuario o administrador proporciona una URL de página, catálogo u otra fuente que contenga recursos que podrían servir para una campaña.

**Flujo confirmado:**

1. **Ingresar URL** o proporcionar el documento autorizado.
2. **Analizar** el contenido y obtener un inventario preliminar de imágenes/documentos/otros assets accesibles, registrando URL de origen, metadatos y tipo.
3. **Previsualizar** los candidatos; mostrar nombre, miniatura (cuando sea posible), procedencia, formato y tamaño conocido.
4. **Seleccionar y aprobar** explícitamente qué elementos interesan. **No guardar de forma definitiva ni incorporar a la biblioteca sin esa selección.**
5. **Descargar los recursos aprobados**, validar contenido, deduplicar cuando proceda y vincularlos al cliente y, opcionalmente, a la campaña.
6. **Registrar** URL original, fecha, archivo local, huella digital, licencias/permisos cuando se conozcan y usuario que aprobó.

**Implementación candidata:** HTTP/parsing para sitios simples; Playwright en Node.js para páginas que requieran renderizado. Su uso está sujeto a restricciones técnicas y permisos de cada sitio. Respetar autenticación, robots y términos aplicables, copyright, tasa de consultas, acceso legítimo y límites de tamaño. Proteger frente a SSRF (URLs internas y redes privadas), redirecciones maliciosas y descargas ejecutables; no eludir barreras de acceso. Este módulo es **una capacidad avanzada o servicio adicional**, con un subconjunto sencillo candidato al MVP.

### 14.5 Regla de tamaño de archivos editables y particionamiento

**Decisión confirmada:** umbral de **80 MB por archivo de diseño editable individual**. **No** computar en ese límite los recursos externos asociados (fotos, tipografías, logos y otros assets), ni el peso total de la carpeta o campaña; esos recursos tendrán políticas de almacenamiento independientes.

- Si un proyecto cabe en un solo documento editable de hasta **80 MB**, mantenerlo íntegro aunque contenga muchas variaciones ligeras, como 20 invitaciones que reutilizan una composición.
- Si el archivo editable supera el umbral o se prevé que lo supere, **dividir por unidades lógicas completas** (por ejemplo, conjuntos de piezas, escenas o páginas) en `part-001`, `part-002`, etc.; **no cortar bytes arbitrariamente** ni destruir grupos de capas.
- Conservar **un identificador de proyecto/campaña único**, un kit de marca común, las reglas de composición, dimensiones, nomenclatura, referencias a recursos y versiones compartidas. Para el usuario, presentar **un solo proyecto**, aunque internamente contenga varios documentos.
- Usar **un manifiesto JSON** como índice canónico y **una bitácora** de eventos/ediciones. Registrar cada parte, qué piezas y capas lógicas contiene, dependencia de assets, ruta relativa, tamaño, versión, orden, vínculos y hash; cambios y autor se registran de forma auditada.
- Especificar un margen de seguridad o comprobación previa a la escritura para impedir partes que terminen sobrepasando 80 MB. La partición efectiva y reapertura deben **probarse con el formato nativo real de VectorCraft**.
- Si el formato nativo no admite reorganizar partes automáticamente sin perder edición, proponer divisiones **antes de crear** los archivos editables y revalidar cada exportación. No afirmar particionamiento nativo hasta completar PoC.

Ejemplo conceptual de `campaign-manifest.json` (los campos son diseño propuesto, no interfaz real de VectorCraft):

```json
{
  "schemaVersion": 1,
  "campaignId": "campaign-001",
  "clientId": "client-001",
  "editableFileLimitBytes": 83886080,
  "brandKitRef": "../../brand/brand-kit.json",
  "assetsPolicy": "external-assets-excluded",
  "revision": 3,
  "parts": [
    {
      "partId": "part-001",
      "path": "design/part-001.vectorcraft",
      "items": ["piece-001", "piece-002"],
      "sizeBytes": 24576000,
      "revision": 2,
      "sha256": "<calcular-al-guardar>"
    },
    {
      "partId": "part-002",
      "path": "design/part-002.vectorcraft",
      "items": ["piece-003"],
      "sizeBytes": 42112000,
      "revision": 1,
      "sha256": "<calcular-al-guardar>"
    }
  ]
}
```

> Convención propuesta: **80 MiB = 83,886,080 bytes** para que el límite sea inequívoco en software. Si comercialmente se quieren **80 MB decimales = 80,000,000 bytes**, cambiar la constante antes de desarrollar; el usuario únicamente fijó «80 megas» como límite conceptual.

Ejemplo de `audit-log.jsonl` (un registro JSON por línea):

```jsonl
{"timestamp":"2026-10-17T21:00:00-06:00","actorId":"admin-001","action":"campaign.created","campaignId":"campaign-001","revision":1}
{"timestamp":"2026-10-17T21:10:00-06:00","actorId":"worker-001","action":"design.part.created","campaignId":"campaign-001","partId":"part-001","revision":2}
```

### 14.6 Estado revisado del MVP

**Incluido o prioritario para validación:** interfaz Astro, autenticación de clientes y administradores, ficha de marca y biblioteca local, brief, chat avanzado simple con OpenCode, PoC de MCP VectorCraft, 2–3 ejemplos iniciales generados desde cero, ejecución asíncrona y vista previa, recuperación de trabajos, exportación y manifiesto/bitácora de proyectos.

**Potencialmente MVP si la PoC lo permite:** importación supervisada de recursos desde **una URL** con vista previa y selección antes de descargar; fraccionamiento de documentos editables en partes bajo el límite de 80 MB.

**Posterior o aún no comprometido:** editor visual exhaustivo, consola administrativa completa, decenas de plantillas prediseñadas, scraping complejo de catálogos, publicación programada automática, correo, pagos y servicios externos.

### 14.7 Decisiones y verificaciones pendientes (no repetir decisiones ya resueltas)

1. Especificar si «80 megas» significa **80 MB** decimales o **80 MiB**; dejarlo configurable.
2. Validar el **formato editable real** generado por VectorCraft, manejo de capas y cómo partir diseños sin perder consistencia.
3. Comprobar el control de OpenCode mediante un proceso o servicio estable, manejo de sesiones y MCP; definir límites de permisos por cliente.
4. Determinar sistema operativo y recursos de la estación de trabajo, concurrencia máxima, continuidad operativa y respaldos.
5. Definir qué acciones puede realizar cada tipo de administrador y cliente; evaluar usuarios múltiples por organización.
6. Determinar formatos permitidos para importación, dimensiones máximas, derechos de uso y retención de originales.
7. Decidir si la aprobación de recursos adquiridos es exclusiva del administrador o también del propietario de la cuenta.
8. Definir el nivel de edición manual del MVP y formatos de exportación realmente soportados.
9. Planificar acceso externo seguro a la estación local si clientes ingresarán por Internet (dominio, HTTPS, proxy, firewall, actualizaciones, credenciales, backups y disponibilidad).

### 14.8 Contexto de transferencia a otro modelo (actualizado)

> Estamos **planeando**, no programando, una plataforma **Astro** de marketing digital para múltiples clientes. El backend será **Node.js/TypeScript** en una **estación de trabajo profesional propia con GPU**, con **OpenCode** como agente multimodelo y **VectorCraft mediante MCP** como motor candidato de diseño. Habrá modo automático y **chat simple avanzado**. Cada cliente tendrá cuenta, biblioteca local separada y Brand Kit; varios administradores accederán al **panel de Astro** para consultar clientes y dar seguimiento, con posible CLI local complementaria. Se comienza con **diseños creados desde cero**, probando **2–3 ejemplos**. Se prevé importación supervisada de assets: **URL → análisis → vista previa → selección/aprobación → descarga → almacenamiento**. Un proyecto puede agrupar varios documentos editables; **cada archivo editable se limita aproximadamente a 80 MB**, sin contar recursos externos. Si necesita dividirse, usar partes lógicas, **manifiesto JSON y bitácora** manteniendo identidad, relaciones y versiones. El usuario desea conservar este plan en Markdown para reutilizarlo con otros modelos. No se debe asumir que MCP o OpenCode ya están integrados ni comenzar implementación sin nueva autorización.

## 15. Registro de avance — Fase 1 PoC VectorCraft (18-oct-2026)


> **Estado:** PoC en curso. La fuente de detalle viva es `poc-vectorcraft/README.md`; este apartado resume decisiones y avances.

### Confirmado mediante pruebas locales (Windows, estación de trabajo)

- VectorCraft **ya está instalado** en la estación: desktop + `vectorcraft-cli.exe` **0.3.1** en `C:\Program Files\VectorCraft\` (no está en PATH).
- **Headless funciona** de extremo a extremo: documento 1080×1080 (`file.new`), formas (`shape.rectangle/ellipse`), pintado (`paint.setFill`), **texto** (`text.create`, renderiza con fuente del sistema) y exportación PNG.
- **Round-trip editable validado**: `document.save` a `.vectorcraft` → reabrir con `run --in` → edición selectiva por `id` (`paint.setFill {ids}`, `text.setText`) → re-exportación correcta sin pérdida de capas.
- **Imagen incrustada** con `file.place` (pagina PNG vinculado, `linked: true`) y exportación dual PNG+SVG sin warnings.
- ✅ **Servidor MCP real operativo**: `vectorcraft-cli mcp --headless` sobre stdio JSON-RPC; `initialize`, `tools/list` (**25 herramientas**), `run_command`, `draw_shape`, `add_text`, `export` responden sin errores (script `test5_mcp.cmd`).
- ✅ **Flujo prompt→pieza completo**: prompt descompuesto en operaciones → engine headless → póster 1080×1080 con taza estilizada (paths), tipografía y banda promocional (`test6_prompt_flujo.cmd`, resultado en `results/flujo_poster_amanecer.png/svg/.vectorcraft`).
- ✅ **Encoding español validado por la vía correcta**: MCP stdio (JSON-RPC, UTF-8) conserva acentos intactos ("Café" ✅). Los batches `.cmd` corrompen acentos (é→®) — se documentó como limitación del arnés de PoC, no del producto.
- ✅ **Repo local VectorCraft (v0.13.1) revisado**: arquitectura por capas (engine L5, MCP ui L6-L7); el CLI instalado (0.3.1) y el repo comparten el mismo modelo de conexión MCP (`--headless` in-proceso / `--connect 7979` a app con `--control`). No se requiere compilar el repo para esta fase.
- ✅ **Ruta del flujo documentada** en `poc-vectorcraft/FLUJO.md` (diagrama, vocabulary MCP↔motor, modo de conexión elegido, qué falta).
- **Rendimiento**: ~75–170 ms por pieza 1080×1080 headless; lote de 5 piezas en **372 ms**; proyección a 20 piezas ~1.5–2 s de CPU. `bench`: 8.8 ms/frame para documento de prueba. Los ítems "OVER" de `perf` corresponden a un documento sintético de 50 000 paths (10³ × tamaño real) — no afectan al alcance del producto.
- **Aislamiento del agente**: flags `--automation-read-root / --automation-write-root` confinan lectura/escritura por carpeta; base técnica candidata para multi-tenant local.

### Hallazgos técnicos a respetar en el diseño

- Dos vocabularios: herramientas MCP (`draw_shape`, `add_text`) vs comandos de motor (`shape.rectangle`, `text.create`). La capa adaptadora debe mapear uno u otro (catálogo de 659 comandos guardado en `poc-vectorcraft/scripts/commands_catalog.json`).
- Rutas dentro de `--params` JSON deben usar `/`. PowerShell 5.1 corrompe comillas anidadas al invocar EXEs: los scripts de PoC van en archivos `.cmd`.
- `file.place` **vincula** la imagen por defecto: decidir embebido (`link:`) y validar al mover carpetas entre clientes.
- MCP de VectorCraft ejecuta exportaciones **síncronas** y no soporta progreso/cancelación asíncrona — encaja con cola de jobs simple en el orquestador.

### Tareas pendientes Fase 1 (detalle en poc-vectorcraft/README.md)

- ✅ Puente OpenCode ↔ MCP VALIDADO (19-oct-2026): formato V2 `mcp.servers` en `opencode.json`; 25 tools disponibles en el agente; pieza generada end-to-end vía código (`mcp_opencode_pieza.png/svg/.vectorcraft`) sin warnings, acentos intactos. Deuda del puente: CLI 0.3.1 no soporta raíles `--automation-*-root`; compilar CLI de repo (v0.13.1) o esperar release para aislamiento nativo.
- ⬜ Lote de 20 piezas con manifiesto JSON y bitácora, simulando campaña real (ahora ya puede ejecutarse vía MCP).
- ⬜ Fuente tipográfica custom (cargar y persistir).
- ⬜ Apertura del `.vectorcraft` generado en la app de escritorio (validar edición híbrida manual).
- ⬜ Aislamiento multi-tenant con raíces por cliente + prueba de escape (requiere CLI con raíles).
- ✅ Modo de integración del worker DECIDIDO: `mcp --headless` persistente (proceso stdio hijo) speak de JSON-RPC — es exactamente el lazo que OpenCode usa en producción.
- ✅ **Paso 7b VALIDADO (19-oct-2026)**: campaña de 20 piezas para client-001 en `poc-vectorcraft/clients/client-001/campaign-001/` — un solo documento editable de 647 KB con 20 artboards (regla §14.5: cabe bajo 80MiB → mantener íntegro), dibujadas en 389 ms vía tools MCP, exportadas 20 PNG finales + 20 previews 270px, manifiesto con hashes sha256 y bitácora JSONL. Confirma: el formato del §14.5 (manifiesto + partes + límite) es operativo con VectorCraft tal cual estaba especulado.
- ⬜ Nota menor de implementación: `artboard.new` no cubre la primera artboard (la crea `file.new`); renombrarla exigió `artboard.setProps {index:0}` después. El worker futuro debe renombrar al crear, no después.
- ⬜ Regla de mapeo para el worker: pieceId=N ↔ artboard índice N-1 ↔ boardName "pieza-NNN" ↔ export "campaign-001-pieza-NNN.png". Documentar el caso pieza-017 (artboard 16) para evitar off-by-one en producción.

## 16. Cambio de enfoque — Fase 2 como visor navegable (msd-visualizer, 19-oct-2026)

**Decisión del usuario:** antes de redactar el PRD formal y sin auth/roles, se construye una **maqueta navegable del flujo** para validarlo visualmente.

- **Proyecto:** msd-visualizer (Astro 7 static + islas Svelte 5 runes + Tailwind 4), ruta en el repo del proyecto.
- **Datos reales:** consume el manifiesto y las previews 270×270 de la PoC (poc-vectorcraft/clients/client-001/campaign-001/), embebidos en src/data y public/demo/previews.
- **Pantallas y su relación con el flujo del §3:**
  - / dashboard de flujo + resumen de campaña real (20 piezas, 647 KB, límite 80 MiB).
  - /campana galería interactiva (filtros paleta/tema, modal de pieza con stepper borrador→en revisión→cambios solicitados→aprobado→exportado y caja de "solicitar cambios" en lenguaje natural — mock del editor híbrido).
  - /brief brand kit + canales + brief y **plan de contenidos simulado** equivalente al paso 6 del flujo.
  - /manifiesto visor del §14.5 real: strategy del part, uso del límite, sha256 de design y exports, tabla de 20 piezas y la bitácora JSONL.
- **Regla técnica de maquetación (lección):** en Astro el template es JSX-like (map()), NO nativo reactivo (sin \{#each as}\ Svelte); toda interactividad va en **islas Svelte** (\client:load\). Este mismo criterio aplica al MVP futuro.
- **Estado:** build OK, 4 rutas servidas por dev server (localhost:4321, pid 38632). README del repo define el rol del proyecto y reglas de maquetación.
- **Qué NO es:** no es el MVP ni sustituye el PRD; los estados y comentarios son locales a sesión. Su valor: Thailand de contratos (manifiesto, estados, plan→lote) ya visualizable y discutible antes del desarrollo real.
- **Siguiente con este visor:** (a) persistir estados de pieza en localStorage; (b) pantalla "resumen de campaña" con selección de favoritos; (c) conectar la generación REAL vía endpoint Astro + MCP headless como PoC de integración backend (opcional, Fase 3).

## 17. Prueba 9 — brief real de marca "El Búho Nocturno" (19-oct-2026)

Primera prueba con un brief auténtico del usuario (no sintético): cafetería de **cenas coreanas y asiáticas**, logo **búho**, paleta **morada nocturna**.

- **Brief:** logo búho arriba-izquierda de cada card; promo uniforme \$120 · 2×1 los lunes después de las 10 pm\.
- **Artefacto:** \poc-vectorcraft/clients/client-001/campaigns/campaign-002/\ — 1 doc \.vectorcraft\ (349 KB, 0.43% del límite) con 4 artboards (buho-001..004), themes: Ramen de medianoche / Tteokbokki nocturno / Postres asiáticos / Bánh mì nocturno. PNG 1080×1080 + previews + manifest v1 con sha256 + audit-log (7 eventos).
- **Generado íntegramente desde el agente** vía Code Mode → MCP (\	ools.vectorcraft.*\): file.new → artboards → dibujo programático (gradiente nocturno, luna creciente por pathfinder minusFront, búho por primitivas, bowl+palillos por paths) → save + export dual.
- **Hallazgos nuevos:**
  - **Hangul renderiza**: \dd_text { font: "Malgun Gothic" }\ con \월요일\ (lunes) sale perfecto — las fuentes del sistema están disponibles en headless. Importante para clientes coreanos/asiáticos.
  - **Iteración visual v1→v2**: la v1 tenía baselines tipográficas desalineadas (texto del chip saliéndose, kicker pegado al titular). Corrección: baseline ≈ centro_del_bloque + 0.35×tamaño. El loop agéntico "dibujar→leer PNG→corregir→regenerar" funciona y es rápido (~1 ciclo).
  - **pathfinder minusFront vía MCP** confirmado para figuras compuestas (luna creciente).
  - Logo repetido = re-dibujo programático por artboard (para plantillas reales con logo embebido, usar \ile.place\ del asset del cliente — ya validado en PASO 4).
- **Valor para el producto:** confirma que el flujo brief→plan→lote→QA visual→manifiesto puede correr 100% agéntico; el visualizador (\msd-visualizer\) es el espejo UI de este mismo flujo.
