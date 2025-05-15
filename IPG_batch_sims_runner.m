% Define PID ranges
kp_values = 0:0.2:25;
ki_values = [0 0.0001 0.0005 0.001 0.005 0.01 0.05 0.1 0.5 1 5];
kd_subset = [0 0.0001 0.0005 0.001 0.005];

[X, Y] = meshgrid(kp_values, ki_values);
n_kp = length(kp_values);
n_ki = length(ki_values);

% Create figure for subplots
figure('Name', 'Yaw & Lat Acc Error Surf Plots', 'Position', [100, 100, 1600, 500]);

while true  % <-- infinite cycle
    for k = 1:length(kd_subset)
        kd_val = kd_subset(k);

        Z_avg_yaw = NaN(n_ki, n_kp);
        Z_peak_yaw = NaN(n_ki, n_kp);
        Z_avg_lat = NaN(n_ki, n_kp);

        for r = 1:length(results)
            if results(r).kd == kd_val
                kp = results(r).kp;
                ki = results(r).ki;

                % Indices
                i = find(abs(kp_values - kp) < 1e-6);
                j = find(abs(ki_values - ki) < 1e-8);

                % Yaw error
                yaw_error = abs(results(r).reference_yaw - results(r).actual_yaw);
                Z_avg_yaw(j, i) = mean(yaw_error);
                Z_peak_yaw(j, i) = max(yaw_error);

                % Lateral acceleration
                lat_error = abs(results(r).lat_acc);
                Z_avg_lat(j, i) = mean(lat_error);
            end
        end

        % Subplot 1: Avg Yaw Error
        subplot(1, 3, 1);
        surf(X, Y, Z_avg_yaw);
        xlabel('Kp'); ylabel('Ki'); zlabel('Avg Abs Yaw Error');
        title(['Avg Yaw Error | Kd = ', num2str(kd_val)]);
        zlim([0, nanmax(Z_avg_yaw(:))]);
        grid on;

        % Subplot 2: Peak Yaw Error
        subplot(1, 3, 2);
        surf(X, Y, Z_peak_yaw);
        xlabel('Kp'); ylabel('Ki'); zlabel('Peak Abs Yaw Error');
        title(['Peak Yaw Error | Kd = ', num2str(kd_val)]);
        zlim([0, nanmax(Z_peak_yaw(:))]);
        grid on;

        % Subplot 3: Avg Lat Acc
        subplot(1, 3, 3);
        surf(X, Y, Z_avg_lat);
        xlabel('Kp'); ylabel('Ki'); zlabel('Avg Abs Lat Acc');
        title(['Avg Lat Acc | Kd = ', num2str(kd_val)]);
        zlim([0, nanmax(Z_avg_lat(:))]);
        grid on;

        sgtitle(['PID Response Summary for Kd = ', num2str(kd_val)]);

        pause(2);
    end
end

