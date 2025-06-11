<%@page import="java.sql.*"%>
<%@page import="java.time.*"%>
<%@page import="java.time.format.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
class Veiculo {
    String placa;
    Timestamp dataEntrada;
    Time horaEntrada;
    Timestamp dataSaida;
    Time horaSaida;
    int valorTotal;

    Veiculo(String placa, Timestamp dataEntrada, Time horaEntrada, Timestamp dataSaida, Time horaSaida, int valorTotal) {
        this.placa = placa;
        this.dataEntrada = dataEntrada;
        this.horaEntrada = horaEntrada;
        this.dataSaida = dataSaida;
        this.horaSaida = horaSaida;
        this.valorTotal = valorTotal;
    }

    String getPlaca() { return placa; }
    Timestamp getDataEntrada() { return dataEntrada; }
    Time getHoraEntrada() { return horaEntrada; }
    Timestamp getDataSaida() { return dataSaida; }
    Time getHoraSaida() { return horaSaida; }
    int getValorTotal() { return valorTotal; }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Consulta de Veículos</title>
</head>
<body>
<%
    String data_inicioStr = request.getParameter("data_inicio");
    String data_fimStr = request.getParameter("data_fim");

    Connection cnx = null;
    PreparedStatement st = null;
    ResultSet rs = null;

    int cont = 0;
    int valorTotal = 0;
    ArrayList<Veiculo> listaVeiculos = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/senai_autopark2";
        String user = "root";
        String password = "root";

        cnx = DriverManager.getConnection(url, user, password);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate data_inicio = LocalDate.parse(data_inicioStr, formatter);
        LocalDate data_fim = LocalDate.parse(data_fimStr, formatter);

        LocalDateTime data_inicio_dt = data_inicio.atStartOfDay();
        LocalDateTime data_fim_dt = data_fim.atTime(23, 59, 59);

        String sql = "SELECT * FROM carros WHERE data_entrada >= ? AND data_saida <= ? ORDER BY data_entrada DESC";
        st = cnx.prepareStatement(sql);
        st.setTimestamp(1, Timestamp.valueOf(data_inicio_dt));
        st.setTimestamp(2, Timestamp.valueOf(data_fim_dt));

        rs = st.executeQuery();

        while (rs.next()) {
            cont++;
            int valor = rs.getInt("valor_total");
            valorTotal += valor;

            Veiculo v = new Veiculo(
                rs.getString("placa"),
                rs.getDate("data_entrada"),
                rs.getTime("horario_entrada"),
                rs.getDate("data_saida"),
                rs.getTime("horario_saida"),
                valor
            );

            listaVeiculos.add(v);
        }

        // Salvar na session
        session.setAttribute("listaVeiculos", listaVeiculos);

    } catch (Exception e) {
        out.println("Erro: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (st != null) st.close();
        if (cnx != null) cnx.close();
    }
%>

<h2>Relatório de Veículos</h2>
<table border="1">
    <tr>
        <th>Total de Veículos</th>
        <th>Valor Total</th>
    </tr>
    <tr>
        <td><%= cont %></td>
        <td>R$ <%= valorTotal %></td>
    </tr>
</table>

<!-- Botão para ir à outra página -->
<form action="exibirveiculos.jsp" method="get">
    <button type="submit">Ver Detalhes dos Veículos</button>
</form>

</body>
</html>
