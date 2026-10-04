function INL = Function_INL(dnl)                   %začátek funkce
    INL = cumsum(dnl);                             %výpočet INL, protože INL je suma DNL
    
    kod = 0:(length(INL) - 1);                     % určení délky kodu(osa x ) od 0 do délkyINL-1
    
    figure;
    plot(kod, INL, 'b.-', 'LineWidth', 1.5, 'MarkerSize', 10);
    xlabel('Kód');
    ylabel('INL [LSB]');
    title('INL');
    grid on;
    
  ylim([-1 1]);
end