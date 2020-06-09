Cloudformation Templates para permutaprop
[//EC2](//ec2) [//RDS](//rds) MySQL & MSSQL [//VPC](//vpc) & R53

# Para crear a traves de Cloudformation un environment en una cuenta de AWS

## Pasos a seguir

Ingresar a Cloudformation y correr los templates en el orden mencionados. Estan creados de esta manera para ser llevados a la modularidad en el futuro.

### Caso de ejemplo permutaprop

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2a0efaf4-c226-460c-9754-a9d386ad54d1/permutaprop-diagram.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2a0efaf4-c226-460c-9754-a9d386ad54d1/permutaprop-diagram.png)

Como vemos en el diagrama el cliente necesita de un Active Directory con dos instancias (en dos zonas disponibles distintas) del tipo MD5 en un balanceador de AWS que a su vez tengan los recursos de MySQL, MSSQL y un FSX(NAS) para un servicio IIS escuchando y trabajando en ambos servers. Finalmente el usuario va a poder ingresar a sus servicios web a traves de un DNS configurado por R53 y que tenga attacheado el balanceador.

---

---

### Seccion tecnica de los templates de Cloudformation

### Modulo ad.json para crear el Active Directory definiendo los Campos de:

"VPCID":  Seleccionar la VPC id para el stack

"Subnets": Seleccionar dos subnets 

"Edition":  Standard o Enterprise

"DNSName":  Default "[corp.permutaprop.com](http://corp.permutaprop.com/)"

"NetBIOSName":  "Default": "CORP"

"AdminPassowrd":  Password del User Admin ("Default": "P@ssw0rd") Establecer un password seguro.

Copiar el Directory ID del nuevo Stack de AD sera util para el transcurso de este proceso.

### Modulo sg.json, este modulo nos permite crear todos los Security Groups que queramos (siguiendo el esquema que nos propone el template) y tiene los siguientes campos requeridos:

"VPCID": Indicar la VPC donde se va a encontrar

"Subnets":  Seleccionar dos Subnets ID

"ADID":  Insertar Directory ID

El output nos imprime el Security Group ID.

---

### Modulo fsx.json crea el NAS que luego se attachea a los servers

"VPCID":  Seleccionar la vpc id donde se esta creando el stack

"Subnets": Seleccionar las subnets que estan involucradas para 

"Subnetpre":  Selecciona y pega la subnet por default

"SGID":  Selecciona el ID de Security Group (va a necesitar el proporcionado por la creacion del AD)

"ADID": Pegar el directory ID del AD

Como salida el script nos da los detalles del NAS, la tarea de creacion tarda 30 minutos.

### Modulo MySql crea en RDS la DB MySql

Para este stack necesitamos los siguientes datos:

"DBInstanceID" : el ID de la DB

"DBName": el nombre de la DB

"DBInstanceClass" : el tipo de instancia que utilizara

"DBAllocatedStorage": el espacio que va a utilizar la DB

"DBUsername": usuario de la DB

"DBPassword": el password de la DB

Necesitamos crear un IAM role con acceso a 'enhanced monitoring' en este caso le coloque el nombre "MonitoringRoleArn": "arn:aws:iam::673501758087:role/rds-monitoring-role"

La version por default del engine es "EngineVersion": "8.0.16",

El output que nos da son los datos de la misma DB.

### Modulo mssql.json

Los parametros que necesita son:

"SqlServerInstanceName" : Nombre de la DB

"DatabaseUsername": usuario de la DB

"DatabasePassword": password de la DB

Create un SG para esta DB con el puerto de SQL 1433

El engine version es "EngineVersion": "12.00.4422.0.v1"

"MultiAZ" lo deje en false para este test,

"DBInstanceClass": por default dejamos la mas baja "db.m4.large"

"AllocatedStorage": en 50 GB

El output nos proporciona la Salida de los datos de esta DB en RDS

### Modulo instances.json

Provee la instancia ec2 con windows y tiene las siguientes particularidades:

.Se une al AD domain

.Se attachea al NAS fsx

.Instala IIS

.Se attachea a los Security Groups seleccionados

.Se conecta a las DB por ODBC

Crea por autoscaling los servers con la imagen seleccionada.