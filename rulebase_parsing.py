from xml.dom import minidom

#file = input("Please enter the Security policy you wish to parse: ")
#Security_xml = minidom.parse(file)
Security_xml = minidom.parse("vane-madi-us-clstr1_std_Security_Policy.xml")

fw_policiesTag = Security_xml.getElementsByTagName("fw_policies")[0]

fw_policieTag = fw_policiesTag.getElementsByTagName("fw_policie")[0]

outRuleTag = fw_policieTag.getElementsByTagName("rule")[0]

inRuleTag = outRuleTag.getElementsByTagName("rule")

for rule in inRuleTag:
    ruleNumElement = rule.getElementsByTagName("Rule_Number")[0]
    rulenum = ruleNumElement.firstChild.data
    #name = rule.getElementsByTagName("Name")
    #class_name = rule.getElementsByTagName("Class_Name")
    #color = service.getElementsByTagName("color")[0].firstChild.data
    #port = service.getElementsByTagName("port")
    #comm = service.getElementsByTagName("comments")[0].firstChild.data
    print(rulenum)
