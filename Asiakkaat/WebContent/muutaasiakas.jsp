<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Muuta asiakas</title>
</head>
<body onkeydown="tutkiKey(event)">
<form id="tiedot">
	<table>
		<thead>
			<tr>
				<th colspan="4"></th>
				<th class="oikealle"><a href="listaaasiakkaat.jsp" id="takaisin">Listaukseen</a></th>
			</tr>
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelinnumero</th>
				<th>Sähköposti</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td>
				<td><input type="button" id="tallenna" value="Muuta" onclick="vieTiedot()"></td>
			</tr>
		</tbody>
	</table>
	<input type="hidden" name="asiakas_id" id="asiakas_id">
</form>
<span id="ilmo"></span>
</body>
<script>

function tutkiKey(event){
	if(event.keyCode==13){
		vieTiedot();
	}
}

document.getElementById("etunimi").focus();

//Haetaan muutettavan asiakkaan tiedot. Kutsutaan backin GET-metodia ja välitetään kutsun mukana muutettavan tiedon id
//GET /asiakkaat/haeyksi/id
var asiakas_id = requestURLParam("asiakas_id");
fetch("asiakkaat/haeyksi/" + asiakas_id,{ //Lähetetään kutsu backendiin
		method: 'GET'
	})
.then(function(response) { //Odotetaan vastausta ja muutetaan JSON-vastausteksti objektiksi
	return response.json()
})
.then(function(responseJson){ //Otetaan vastaan objekti responseJson-parametrissa
	console.log(responseJson);
	document.getElementById("etunimi").value=responseJson.etunimi;
	document.getElementById("sukunimi").value=responseJson.sukunimi;
	document.getElementById("puhelin").value=responseJson.puhelin;
	document.getElementById("sposti").value=responseJson.sposti;
	document.getElementById("asiakas_id").value=responseJson.asiakas_id;
});

//Funktio tietojen muuttamista varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana muutetut tiedot json-stringinä
//PUT /asiakkaat/
function vieTiedot(){
	var ilmo="";
	var puh= new RegExp("[0-9]");
	var meili= new RegExp("@");
	if(document.getElementById("etunimi").value.length<2){
		ilmo="Etunimi on liian lyhyt.";
	}else if(document.getElementById("sukunimi").value.length<2){
		ilmo="Sukunimi on liian lyhyt.";
	}//else if(puh.test(document.getElementById("puhelin"))==false){
	//	ilmo="Puhelinnumero ei kelpaa.";
	//}
	//else if(meili.test(document.getElementById("sposti"))==false){
	//	ilmo="Sähköposti ei kelpaa.";
	//}
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);
	
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	console.log(formJsonStr);
	//Lähetetään muutetut tiedot backendiin
	fetch("asiakkaat",{ //Lähetetään kutsu backendiin
		method: 'PUT',
		body: formJsonStr
	})
	.then(function (response){ //Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json();	
	})
	.then(function (responseJson){ //Otetaan vastaan objekti responseJson-parametrissa
		var vastaus = responseJson.response;
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Tietojen päivitys epäonnistui.";
		} else if(vastaus==1){
			document.getElementById("ilmo").innerHTML= "Tietojen päivitys onnistui.";
		}
		setTimeout(function(){document.getElementById("ilmo").innerHTML=""; }, 5000);
	});
	document.getElementById("tiedot").reset(); //Tyhjennetään tiedot-lomake
}
</script>
</html>