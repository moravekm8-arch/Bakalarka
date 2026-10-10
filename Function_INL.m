function INL = Function_INL(dnl)
    
    d = dnl(:);              %dnl na sloupcový vektor
    platne = ~isnan(d);      %vytvoření vektoru pro platné hodnoty
    d(~platne) = 0;          %nan nahradí nulou 
    INL_raw = cumsum(d);     %výpočet sumy dnl

    
    kod = (0:numel(INL_raw)-1).'; %proměnná x pro proložení

    
    p = polyfit(kod(platne), INL_raw(platne), 1);   % p(1)=smernice, p(2)=posun
    primka = polyval(p, kod);                       %určení přímky

    
    INL = INL_raw - primka;                         %výpočet inl jako rozdíl ideální -reálné přímky
    INL(~platne) = NaN;                             %vrácení nan na neplatné body

    % Graf
    figure;
    plot(kod, INL, 'b.', 'MarkerSize', 6);
    xlabel('Kod ADC');
    ylabel('INL [LSB]');
    title('INL ');
    grid on;

    ylim([-1 1])
end
