%% Grafik 1: AWGN Kanalı için Shannon Kapasite Eğrisi
SNR_dB = -10:1:20; % snr aralığı -10 dan 20 db e kadar 1er 1er arttırılıyor
SNR_lin = 10.^(SNR_dB/10); % vektörel üs alıyoruz
Shannon_Capacity = log2(1 + SNR_lin); % shannon kapasite formülü
markerPoints_dB = [11.74,0]; % işaretlenen desibel değerleri x ekseni seçimi
markerCapacity = log2(1 + 10.^(markerPoints_dB/10)); % işaretlenen desibel değerlerine göre kapasite noktasının belirlenmesi y ekseni seçimi

figure; %grafik penceresi
plot(SNR_dB, Shannon_Capacity, 'b-', 'LineWidth', 2); % snr değerlerine göre shannon kapasite eğrisinin çizimi
hold on; % yeni çizimler eklenmesine izin verme kodu
plot(markerPoints_dB, markerCapacity, 'ro', 'MarkerSize', 8, 'LineWidth', 2); % özel işaretlenecek db noktaları ve kapasite değerlerinin işaretlenmesi
text(markerPoints_dB(1)+0.5, markerCapacity(1), sprintf('  (%.1f dB, %.1f bps/Hz)', markerPoints_dB(1), markerCapacity(1))); % 1. işaretlenmiş yere 0.5 sağa kaydırılmış yazı eklenmesi
text(markerPoints_dB(2)+0.5, markerCapacity(2), sprintf('  (%.1f dB, %.1f bps/Hz)', markerPoints_dB(2), markerCapacity(2))); % 2. işaretlenmiş yere 0.5 sağa kaydırılmış yazı eklenmesi
xlabel('SNR (dB)');
ylabel('Kapasite (bps/Hz)');
title('AWGN Kanalı için Shannon Kapasite Eğrisi');
grid on; % kılavuz çizgileri
hold off;

%% Grafik 2: Shannon kapasitesi eğrisine göre modülasyonların konumu

M_values = [2, 4, 16, 64]; % BPSK=2, QPSK=4, 16QAM=16, 64QAM=64 modülasyon seviye
colors = ['r','g','m','b'];
figure;
plot(SNR_dB, Shannon_Capacity, 'b-', 'LineWidth', 2);
hold on;
for i = 1:length(M_values)
    spectral_eff = log2(M_values(i)); % burada M_values değerleri tek bir sayı olup bit(sembol) değeri bulunuyor
    SNR_req = 10*log10((2^spectral_eff - 1)); % tek sayı olmasından kaynaklı skaler üs
    plot([SNR_req, SNR_req], [0, spectral_eff], [colors(i) '--'], 'LineWidth', 1.5);
    plot(SNR_req, spectral_eff, [colors(i) 'o'], 'MarkerSize', 6);
    text(SNR_req-2, spectral_eff+0.2, sprintf('%d-QAM', M_values(i)));
end
xlabel('SNR (dB)');
ylabel('Kapasite / Verimlilik (bps/Hz)'); % bu eksende hem modülasyonların spektral verimliliği hem de shannon kapasitesi bulunmaktadır
title('Shannon kapasite eğrisine göre modülasyonların konumu');
legend('Shannon Sınırı');
grid on;
hold off;
%% Grafik 3: Kodlama oranlı modülasyonların shannon kapasite eğrisine göre konumu

SNR_dB = -10:1:20;
SNR_lin = 10.^(SNR_dB/10);
Shannon_Capacity = log2(1 + SNR_lin);

M_values = [2, 4, 16, 64];
M_labels = {'BPSK', 'QPSK', '16-QAM', '64-QAM'};
CR_values = [1/2, 5/6];
CR_labels = {'R=1/2', 'R=5/6'};

colorList = lines(length(M_values) * length(CR_values)); % 8 farklı renk kullanımı

figure;
hold on;

h_main = plot(SNR_dB, Shannon_Capacity, 'b-', 'LineWidth', 2); % shannon kapasite eğrisi çizimi
legendHandles = [h_main];  % her çizgi doğru açıklama ile eşleştirilmek için yazıldı
legendEntries = {'Shannon Kapasite Eğrisi'};

idx = 1;
for i = 1:length(M_values)
    for r = 1:length(CR_values)
        M = M_values(i);
        CR = CR_values(r);
        spec_raw_eff = log2(M);
        spec_eff = CR * spec_raw_eff;
        SNR_req = 10*log10(2^spec_eff - 1);

        thisColor = colorList(idx, :);

        % Çizgi ve marker ve grafiğe alınması
        h = plot([SNR_req, SNR_req], [0, spec_eff], '--', 'Color', thisColor, 'LineWidth', 2);
        plot(SNR_req, spec_eff, 'o', 'Color', thisColor, 'MarkerFaceColor', thisColor, 'MarkerSize', 5);

        % Handle ve etiket eklenmesi
        legendHandles(end+1) = h;
        legendEntries{end+1} = sprintf('%s, %s', M_labels{i}, CR_labels{r});
        idx = idx + 1;
    end
end

xlabel('SNR (dB)');
ylabel('Kapasite / Verimlilik (bps/Hz)');
title('Kodlama oranlı modülasyonların shannon kapasite eğrisine konumu');
legend(legendHandles, legendEntries, 'Location', 'northeast');
grid on;
hold off;
