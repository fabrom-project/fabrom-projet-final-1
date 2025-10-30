import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import fabromLogo from "@/assets/fabrom-logo.png";
import galaxyBg from "@/assets/galaxy-background.jpg";

const Landing = () => {
  const navigate = useNavigate();

  return (
    <div 
      className="min-h-screen flex flex-col bg-cover bg-center bg-no-repeat relative"
      style={{ backgroundImage: `url(${galaxyBg})` }}
    >
      {/* Dark overlay for better text readability */}
      <div className="absolute inset-0 bg-black/50" />
      
      {/* Header */}
      <header className="relative z-10 flex items-center justify-between px-6 py-4">
        <div className="flex items-center gap-3">
          <img 
            src={fabromLogo} 
            alt="FABROM" 
            className="h-12"
          />
          <span className="text-2xl font-bold text-foreground">FABROM</span>
        </div>
        <div className="flex gap-3">
          <Button 
            variant="outline"
            onClick={() => navigate("/auth")}
            className="bg-background/10 backdrop-blur-sm border-foreground/20 hover:bg-background/20"
          >
            Se connecter
          </Button>
          <Button 
            onClick={() => navigate("/auth")}
            className="bg-gradient-to-r from-destructive to-[hsl(45,100%,50%)] hover:opacity-90"
          >
            Créer un compte
          </Button>
        </div>
      </header>

      {/* Main Content */}
      <main className="relative z-10 flex-1 flex flex-col items-center justify-center px-4 text-center">
        <div className="max-w-4xl mx-auto space-y-8">
          <div className="flex items-center justify-center gap-4">
            <h1 className="text-5xl md:text-7xl font-bold text-foreground">
              Créer avec
            </h1>
            <img 
              src={fabromLogo} 
              alt="FABROM" 
              className="h-16 md:h-20"
            />
            <h1 className="text-5xl md:text-7xl font-bold text-foreground">
              FABROM
            </h1>
          </div>
          
          <p className="text-2xl md:text-3xl font-semibold text-foreground">
            Le vibe code Congolais
          </p>
          
          <div className="mt-12">
            <Button 
              size="lg" 
              onClick={() => navigate("/editor")}
              className="text-lg px-12 py-6 bg-gradient-to-r from-destructive to-[hsl(45,100%,50%)] hover:opacity-90 shadow-lg"
            >
              Commencer à coder
            </Button>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="relative z-10 text-center py-6 text-muted-foreground">
        <p>
          Fièrement conçu par{" "}
          <a 
            href="https://oredtech.com" 
            target="_blank" 
            rel="noopener noreferrer"
            className="text-foreground font-semibold hover:text-primary transition-colors"
          >
            Oredy TECHNOLOGIES
          </a>
        </p>
      </footer>
    </div>
  );
};

export default Landing;
