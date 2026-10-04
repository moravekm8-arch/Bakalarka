function dnl = Function_DNL(U_vzor, Vmin, Vmax, n_bit);

    N   = 2^n_bit;                           %výpočet množství kodu
    LSB = (Vmax - Vmin) / N;                 %výpočet LSB
    U_vzor = U_vzor(:);                      %předělání hodnot z U_vzor na sloupcový vektor


    du_ideal = U_vzor(2) - U_vzor(1);       %ideální napětový skok mezi dvěma vzorky
   
    
    edges  = Vmin + (0:N) * LSB;            %výpočet histogramové metody, rozdělení oblastí
    counts = histcounts(U_vzor, edges).';   % kolikrát se trefíme do dané oblasti

    
    H_ideal = LSB / du_ideal;                % Ocekavany pocet vzorku v jednom kodu pri ideal. linearni rampe

  
    dnl = counts / H_ideal - 1;

    
    k_max = floor((max(U_vzor) - Vmin) / LSB);  % DEFINOVÁNÍ POČTU BODU, PROTOŽE NA POSLEDNÍM BODĚ SE dnl NEPROJEVÍ
    k_max = min(k_max, N) - 1;                  % kontrola, aby se nepřekročil počet N a aby projel kod dokonce
    platne = false(N,1);
    if k_max >= 1                               %zkontroluje, zda prošel jedním kodovým intervalem alespon a když jo, tak přiřadí hodnot, když třeba se začne moc brzo nebo pozdě a nějaké hodnoty jsou vynechány                    
        platne(1:k_max) = true;                 
    end
    dnl(~platne) = NaN;                         %neplatným hodnotám přiřadí Nan

    % --- Graf
    figure;
    plot(0:N-1, dnl, '.', 'Color', 'b', 'MarkerSize', 6);
    grid on;
    xlabel('Kod ADC');
    ylabel('DNL [LSB]');
    title('Diferencialni nelinearita ADC (DNL)');

    ylim([-1 1]);
end