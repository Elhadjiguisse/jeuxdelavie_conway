require 'gosu'

class Jeudelavie < Gosu::Window
  def initialize(width, height)
    super(width, height, false)
    self.caption = 'Jeu de la Vie de Conway'

    @taille_cell = 10
    @grille_l = width / @taille_cell
    @grille_h = height / @taille_cell

    @grille = Array.new(@grille_l) { Array.new(@grille_h, 0) }

    # Initialisation aléatoire
    @grille.each_index do |i|
      @grille[i].each_index do |j|
        @grille[i][j] = rand(2)
      end
    end

    @generation_interval = 0.5  # en secondes
    @last_generation = Time.now
  end

  def update
    if Time.now - @last_generation > @generation_interval
      update_generation
      @last_generation = Time.now
    end
  end

  def draw
    @grille.each_with_index do |column, i|
      column.each_with_index do |cell, j|
        if cell == 1
          draw_cell(i, j, Gosu::Color::WHITE)
        else
          draw_cell(i, j, Gosu::Color::BLACK)
        end
      end
    end
  end

  def draw_cell(i, j, color)
    draw_quad(
      i * @taille_cell, j * @taille_cell, color,
      i * @taille_cell + @taille_cell, j * @taille_cell, color,
      i * @taille_cell, j * @taille_cell + @taille_cell, color,
      i * @taille_cell + @taille_cell, j * @taille_cell + @taille_cell, color
    )
  end

  def update_generation
    new_grille = Array.new(@grille_l) { Array.new(@grille_h, 0) }

    @grille.each_with_index do |column, i|
      column.each_with_index do |cell, j|
        neighbors = count_neighbors(i, j)
        if cell == 1
          new_grille[i][j] = (neighbors == 2 || neighbors == 3) ? 1 : 0
        else
          new_grille[i][j] = (neighbors == 3) ? 1 : 0
        end
      end
    end

    @grille = new_grille
  end

  def count_neighbors(x, y)
    count = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        next if i == 0 && j == 0
        nx, ny = x + i, y + j
        count += @grille[nx % @grille_l][ny % @grille_h]
      end
    end
    count
  end
end

width = 800
height = 600
game = Jeudelavie.new(width, height)
game.show
