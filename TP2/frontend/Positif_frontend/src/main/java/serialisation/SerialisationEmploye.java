package serialisation;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import metier.data.Employe;

public class SerialisationEmploye extends Serialisation {

    @Override
    public void serialiser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = getWriterWithJsonHeader(response);
        JsonObject jsonContainer = new JsonObject();
        HttpSession session = request.getSession();
        Employe employe = (Employe) session.getAttribute("personne");

        jsonContainer.addProperty("nom", employe.getNom());
        jsonContainer.addProperty("prenom", employe.getPrenom());

        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(jsonContainer);
        out.println(json);
    }

}
