function [x_opt, f_opt, iter] = revised_newton_method(fun, grad, hess, x0)
    % 修正牛顿法
    % 输入：
    %   fun: 目标函数
    %   grad: 梯度函数
    %   hess: 海森矩阵函数
    %   x0: 初始点
    % 输出：
    %   x_opt: 近似最优解
    %   f_opt: 最优解对应的函数值
    %   iter: 迭代次数

    n = length(x0); 
    max_iter = 1000; % 最大迭代次数
    rho = 0.55; % 线搜索参数
    sigma = 0.4; % Armijo条件系数
    tau = 0.0; % 修正因子
    iter = 0; % 迭代次数
    epsilon = 0.01; % 误差阈值

    % 初始化
    x = x0;

    while iter < max_iter
        % 计算当前点的梯度和海森矩阵
        g = feval(grad, x);
        H = feval(hess, x);

        % 计算修正因子
        mu = norm(g) ^ (1 + tau);

        % 构造修正后的海森矩阵
        A = H + mu * eye(n);

        % 计算搜索方向
        d = -A \ g;

        m = 0;
        mk = 0;

        % 线搜索
        while m < 100
            if feval(fun, x + rho^m * d) < feval(fun, x) + sigma * rho^m * g' * d
                mk = m; % 更新 mk
                break;
            end
            m = m + 1;
        end

        % 更新当前点
        x = x + rho^mk * d;
        iter = iter + 1;

        % 判断停止条件：梯度小于阈值
        if norm(g) < epsilon
            break;
        end
    end

    % 输出最优解和最优值
    x_opt = x;
    f_opt = feval(fun, x);
end
