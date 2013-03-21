from xml.dom import minidom

services_xml = minidom.parse("services.xml")

ServicesTag = services_xml.getElementsByTagName("services")[0]

# Pull individual network objects
ServiceObjectTag = ServicesTag.getElementsByTagName("service")

for service in ServiceObjectTag:
    name = service.getElementsByTagName("Name")[0].firstChild.data
    class_name = service.getElementsByTagName("Class_Name")[0].firstChild.data
    color = service.getElementsByTagName("color")[0].firstChild.data
    portElement = service.getElementsByTagName("port")
    port = portElement.firstChild.data
    p = int(port[0])
    #comm = service.getElementsByTagName("comments")[0].firstChild.data
    print(name,class_name,p,color)
    
    
