<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="css/main.css">
<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300&display=swap" rel="stylesheet">
<title>Asiakkaat</title>
</head>
<body onkeydown="tutkiKey(event)">
<table id="listaus">
	<thead>
		<tr>
			<th colspan="4"></th>
			<th><a id="uusiAsiakas" href="lisaaasiakas.jsp">Lisää uusi asiakas</a></th>
		</tr>
		<tr>
			<th colspan="2"></th>
			<th class="oikealle">Hakusana:</th>
			<th><input type="text" id="hakusana"></th>
			<th><input type="button" value="Hae" id="hakunappi" onClick="haeAsiakkaat()"></th> 
		</tr>
		<tr>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelinnumero</th>
			<th>Sähköposti</th>
			<th></th>
		</tr>
	</thead>
	<tbody id="tbody">
	</tbody>
</table>
<script>
haeAsiakkaat();
document.getElementById("hakusana").focus(); //viedään kursori hakusana-kenttään

function tutkiKey(event){
	if(event.keyCode==13){//Enter
		haeAsiakkaat();
	}		
}

// funktio tietojen hakemista varten
function haeAsiakkaat(){
	document.getElementById("tbody").innerHTML = "";
	fetch("asiakkaat/" + document.getElementById("hakusana").value,{//Lähetetään kutsu backendiin
		method: 'GET'
	})
	.then(function(response) { //Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json()
	})
	.then(function(responseJson){ //Otetaan vastaan objekti responseJson-parametrissa
		var asiakkaat = responseJson.asiakkaat;
		var htmlStr="";
		for(var i=0; i<asiakkaat.length; i++){
			htmlStr+="<tr>";
			htmlStr+="<td>"+asiakkaat[i].etunimi+"</td>";
			htmlStr+="<td>"+asiakkaat[i].sukunimi+"</td>";
			htmlStr+="<td>"+asiakkaat[i].puhelin+"</td>";
			htmlStr+="<td>"+asiakkaat[i].sposti+"</td>";
			htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+asiakkaat[i].asiakas_id+"'>Muuta</a>&nbsp;";
			htmlStr+="<span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"')>Poista</span></td>";
			htmlStr+="</tr>";
		}
		document.getElementById("tbody").innerHTML = htmlStr;
	})
}

// funktio tietojen poistamista varten. Kutsutaan backin DELETE-metodia ja välitetään poistettavan tiedon id.
// DELETE /asiakkaat/id
function poista(asiakas_id, etunimi, sukunimi){
	if(confirm("Poista asiakas "+asiakas_id+"?")){
		fetch("asiakkaat/"+asiakas_id,{
			method: 'DELETE'
		})
		.then(function(response){ //Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()
		})
		.then(function(responseJson){
			var vastaus = responseJson.response;
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Asiakkaan poisto epäonnistui.";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmo").innerHTML="Asiakkaan " + asiakas_id +" poisto onnistui.";
				haeAsiakkaat();
			}
			setTimeout(function(){document.getElementById("ilmo").innerHTML="";}, 5000);
		})
	}
}

</script>
</body>
</html>