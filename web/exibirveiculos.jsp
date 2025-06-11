<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalhes dos Veículos</title>
</head>
<body>

<h2>Lista de Veículos Encontrados</h2>

<%
    ArrayList<Veiculo> lista = (ArrayList<Veiculo>) session.getAttribute("listaVeiculos");

    if (lista == null || lista.isEmpty()) {
%>
    <p>Nenhum veículo encontrado no período informado.</p>
<%
    } else {
%>
    <table border="1">
        <tr>
            <th>Placa</th>
            <th>Data Entrada</th>
            <th>Hora Entrada</th>
            <th>Data Saída</th>
            <th>Hora Saída</th>
            <th>Valor Total (R$)</th>
        </tr>
        <%
            for (Veiculo v : lista) {
        %>
            <tr>
                <td><%= v.getplaca() %></td>
                <td><%= v.getdataEntrada().toLocalDateTime().toLocalDate() %></td>
                <td><%= v.gethoraEntrada() %></td>
                <td><%= v.getdataSaida().toLocalDateTime().toLocalDate() %></td>
                <td><%= v.gethoraSaida() %></td>
                <td>R$ <%= v.getvalorTotal() %></td>
            </tr>
        <%
            }
        %>
    </table>
<%
    }
%>

<!-- Botão para voltar -->
<br>
<form action="consultaVeiculos.jsp" method="get">
    <button type="submit">Voltar</button>
</form>

</body>
</html>
