%MAE 8 Group Project Game of Life, Justin A, Partners: Myra G, Angelica N, Jorge G


clear all; clc; close all;
m = 15;
n = 15;  
%m is the number of rows of cells
%n is the number of columns of cells
while true
close(gcf);
figure;
drawCells(m, n);
[Rnew, Cnew] = evolveState(R, C, m, n); 
while ~isequal([R; C], [Rnew; Cnew])
   
   R = Rnew;
   C = Cnew;
  
    [Rnew, Cnew] = evolveState(R, C, m, n);
  
    drawCells(m, n);
  
   hold on;
   for k = 1:length(R)
       rectangle('Position', [C(k)-1, m-R(k), 1, 1], 'FaceColor', 'k', 'EdgeColor', 'k');
   end
   hold off;
   pause(0.3); 
end

title('Life');
disp('Pattern has reached a stable state.');
mode = menu('Want to repeat', 'Yes', 'No');
  if mode ~= 1
close(gcf);
      break;
  end
end
function drawCells(m, n)
 hold on;
 for i = 1:m
     for j = 1:n
         rectangle('Position', [j-1, m-i, 1, 1], 'FaceColor', 'w', 'EdgeColor', 'k');
     end
 end
 axis equal;
 axis([0 n 0 m]);
 set(gca, 'XTick', [], 'YTick', []);
 hold off;
end
function [R, C] = inputLiveCells(m, n)
 R = [];
 C = [];
 title('Click on cells to make them live. Press <Enter> when done.');
 while true
     try
     [x, y] = ginput(1);
     if isempty(x)
         break;
     end
     i = m - floor(y);
     j = ceil(x);
     if i >= 1 && i <= m && j >= 1 && j <= n
             if any(R == i & C == j)
                 idx = find(R == i & C == j, 1);
                 R(idx) = []; C(idx) = [];
                 rectangle('Position', [j-1, m-i, 1, 1], 'FaceColor', 'w', 'EdgeColor', 'k');
             else
                 R = [R; i];
                 C = [C; j];
                 rectangle('Position', [j-1, m-i, 1, 1], 'FaceColor', 'k', 'EdgeColor', 'k');
             end
         end
     catch ME
         disp('Input interrupted or invalid. Exiting input mode.');
         disp(getReport(ME));
         break;
     end
 end
end
function [Rnew, Cnew] = evolveState(R, C, m, n)
   % Initialize grid and mark live cells
   grid = zeros(m, n);
   grid(sub2ind(size(grid), R, C)) = 1;
  
   % Create a new grid for updates
   updatedGrid = zeros(m, n);
  
    for row = 1:m
       for col = 1:n
           
           neighbors = countLiveNeighbors(grid, row, col, m, n);
          
           % Apply the Game of Life rules
           if grid(row, col) == 1 
               updatedGrid(row, col) = (neighbors == 2 || neighbors == 3);
           else 
               updatedGrid(row, col) = (neighbors == 3);
           end
       end
   end
   [Rnew, Cnew] = find(updatedGrid);
end
  
  clf; 
  imshow(1 - newGrid, 'InitialMagnification', 'fit');  
  title('Evolved State'); 
  gridSize = max(n);
  hold on
  for i = 1:gridSize-1
      plot([i+0.5, i+0.5], [0.5, gridSize+0.5], 'Color', [0.5, 0.5, 0.5]);
      plot([0.5, gridSize+0.5], [i+0.5, i+0.5], 'Color', [0.5, 0.5, 0.5]);
  end
  hold on
  [Rnew, Cnew] = find(newGrid); 
  Rnew=Rnew';Cnew=Cnew';

function neighbors = countLiveNeighbors(grid, row, col, m, n)
   
   offsets = [-1, -1; -1, 0; -1, 1;
               0, -1;        0, 1;
               1, -1;  1, 0;  1, 1];
   neighbors = 0; 
  
   for k = 1:size(offsets, 1)
       r = row + offsets(k, 1); % Calculate neighbor row index
       c = col + offsets(k, 2); % Calculate neighbor column index
       % Check if the indices are within grid boundaries
       if r >= 1 && r <= m && c >= 1 && c <= n
           neighbors = neighbors + grid(r, c); % Add to count if within bounds
       end
   end
end         

