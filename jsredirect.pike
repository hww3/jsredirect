//
// This is a Roxen module.
//
// Written by Bill Welliver, <hww3@riverweb.com>
//
//

string cvs_version = "$Id: jsredirect.pike,v 1.3 1998-08-18 18:48:38 hww3 Exp $";

#include <module.h>
#include <process.h>
inherit "module";
inherit "roxenlib";

array register_module()
{
  return ({ MODULE_PARSER,
            "JavaScript Redirect",
            "Creates JavaScript powered dropdown redirect widgets.<p>\n"
		"&lt;JSRedirect&gt; takes the jsenabled option.<br>\n"
		"&lt;Option&gt; takes the url=destinationurl option."
		"&lt;/Option&gt;<br>\n"
		"&lt;/JSRedirect&gt;", ({}), 1
            });
}

void create()
{

}

string|void check_variable(string variable, mixed set_to)
{

}

string container_option(string tag_name, mapping arguments,
		string contents,object id, object file, mapping defines)
  {
  string retval="";
  if(arguments->_parsed) return retval;
  if(!id->misc->jsredirect) id->misc->jsredirect=({});
  if(!id->misc->jsrurls) id->misc->jsrurls=([]);
  contents=contents-"\n";
  id->misc->jsredirect+=({contents});
  id->misc->jsrurls+=([contents:(arguments->url||"")]);
  return retval;
  }

int i;
mixed container_jsredirect(string tag_name, mapping arguments,
			string contents, object id,
			mapping defines)
{
if(arguments->preparse)
contents = parse_rxml(contents, id);
contents = parse_html(contents,([]),([ "option":container_option ]), id );
   i++;
string retval="";
retval+="<script language=\"javascript\">\n<!--\n"
	"	function MakeArray() {\n"
        "	var lngth = MakeArray.arguments.length;\n"
        "	for ( i = 0 ; i < lngth ; i++ ) { this[i]=MakeArray.arguments[i] }\n"
	"	}\n"
	"function switch_page"+i+"()\n"
	"  {\n"
        "  var select = eval(document.jsredirect"+i+".jsredirect"+i+".selectedIndex);\n"

        "if( (select > 0) && (select < "+(sizeof(id->misc->jsredirect))
		+") )\n"
        "  {\n"
        "  var i=new MakeArray(";
for(int o=0; o<sizeof(id->misc->jsredirect); o++){
  	retval+="    '"+id->misc->jsrurls[id->misc->jsredirect[o]]+"'\n";
  if((o+1)!=sizeof(id->misc->jsredirect)) retval+=",";
  }

retval+="    )\n"
        "    location=i[document.jsredirect"+i+".jsredirect"+i+".selectedIndex];\n"
        "  }\n"
	"}\n"
	"// -->\n</script>\n";
retval+="<form name=jsredirect"+i+">\n";
retval+="<select name=\"jsredirect"+i+"\" onchange='switch_page"+i+"();'>\n";
for(int o=0; o<sizeof(id->misc->jsredirect); o++)
  retval+="<option _parsed=1>"+id->misc->jsredirect[o]+"\n";
retval+="</select>\n";
if(arguments->jsenabled) retval+="<font size=1>JavaScript Enabled</font>\n"; retval+="</form>\n";
return retval;

}

void start(){

  i=0;

}

mapping query_container_callers() { return (["jsredirect":container_jsredirect ]); }







