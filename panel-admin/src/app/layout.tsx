import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Segusys · Panel Admin',
  description: 'Panel administrativo de control de guardias',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es" className="dark">
      <body className="bg-segusys-bg text-segusys-text font-sans antialiased">{children}</body>
    </html>
  );
}
