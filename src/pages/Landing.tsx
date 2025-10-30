import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import fabromLogo from "@/assets/fabrom-logo.png";

const Landing = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-primary via-accent to-destructive p-4">
      <div className="max-w-4xl mx-auto text-center space-y-8">
        <img 
          src={fabromLogo} 
          alt="FABROM" 
          className="h-16 mx-auto mb-8"
        />
        
        <h1 className="text-5xl md:text-7xl font-bold text-foreground">
          Créer avec l'IA
        </h1>
        
        <p className="text-xl md:text-2xl text-muted-foreground">
          Éditeur de code intelligent propulsé par l'intelligence artificielle
        </p>
        
        <div className="flex flex-col sm:flex-row gap-4 justify-center mt-12">
          <Button 
            size="lg" 
            onClick={() => navigate("/editor")}
            className="text-lg px-8 py-6"
          >
            Commencer à coder
          </Button>
          <Button 
            size="lg" 
            variant="outline"
            onClick={() => navigate("/auth")}
            className="text-lg px-8 py-6"
          >
            Se connecter
          </Button>
        </div>
      </div>
    </div>
  );
};

export default Landing;
