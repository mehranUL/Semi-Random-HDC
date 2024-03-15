% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
% _    _ _        _               ______  __     ________ _______ _______ ______ 
%| |  | | |      | |        /\   |  ____/\\ \   / /  ____|__   __|__   __|  ____|
%| |  | | |      | |       /  \  | |__ /  \\ \_/ /| |__     | |     | |  | |__   
%| |  | | |      | |      / /\ \ |  __/ /\ \\   / |  __|    | |     | |  |  __|  
%| |__| | |____  | |____ / ____ \| | / ____ \| |  | |____   | |     | |  | |____ 
% \____/|______| |______/_/    \_\_|/_/    \_\_|  |______|  |_|     |_|  |______|
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

% The code was composed in UL Lafayette by research scientist Sercan Aygun
% The supervisor Asst. Prof. Dr. M. Hassan Najafi
% version-1.1 12/12/2021

function Q_out = JK_behaviour(J, K, N)

Q = true; %(resetting/setting initially)

for i = 1:1:N
    
    if J(i) == 0 && K(i) == 0
        if i == 1
            Q_out(i) = Q;
        end
        if i ~= 1
            Q_out(i) = Q_out(i-1);
        end
    end
    
    if J(i) == 1 && K(i) == 1
        if i == 1
            Q_out(i) = ~Q;
        end
        if i ~= 1
            Q_out(i) = ~Q_out(i-1);
        end
    end
    
    if J(i) == 0 && K(i) == 1
        Q_out(i) = false;
    end
    if J(i) == 1 && K(i) == 0
        Q_out(i) = true;
    end
    
end

end
