# written by Savvas Petridis

import pygame as pg
from pygame.math import Vector2
from pygame.locals import *
import math

pg.init()
screen = pg.display.set_mode((300, 400))
screen_rect = screen.get_rect()


# RED OBSTACLE
obstacle = pg.sprite.Sprite()
obst_img = pg.Surface((40, 40), pg.SRCALPHA)
obst_img.fill(pg.Color('red'))
obst = obst_img.get_rect(center=(150, 190));
obstacle.image = obst_img;
obstacle.rect = obst;
obstacle.mask = pg.mask.from_surface(obstacle.image);
screen.blit(obst_img, obst);

# RIGHT WALL: 
right_wall = pg.sprite.Sprite()
right_wall_img = pg.Surface((10, 400), pg.SRCALPHA)
right_wall_img.fill(pg.Color('white'));
right_wall_rect = right_wall_img.get_rect(center=(300,200));
right_wall.image = right_wall_img;
right_wall.rect = right_wall_rect;
right_wall.mask = pg.mask.from_surface(right_wall.image);

# LEFT WALL:
left_wall = pg.sprite.Sprite()
left_wall_img = pg.Surface((10, 400), pg.SRCALPHA)
left_wall_img.fill(pg.Color('white'));
left_wall_rect = left_wall_img.get_rect(center=(0,200));
left_wall.image = left_wall_img;
left_wall.rect = left_wall_rect;
left_wall.mask = pg.mask.from_surface(left_wall.image);

# BOTTOM WALL:
bott_wall = pg.sprite.Sprite()
bott_wall_img = pg.Surface((300, 10), pg.SRCALPHA)
bott_wall_img.fill(pg.Color('white'));
bott_wall_rect = bott_wall_img.get_rect(center=(150,400));
bott_wall.image = bott_wall_img;
bott_wall.rect = bott_wall_rect;
bott_wall.mask = pg.mask.from_surface(bott_wall.image);

FONT = pg.font.Font(None, 24)

def main():
    clock = pg.time.Clock()
    cannon_img = pg.Surface((40, 20), pg.SRCALPHA)
    cannon_img.fill(pg.Color('aquamarine3'))
    cannon = cannon_img.get_rect(center=(140, 350))
    angle = 0

    while True:
        new_center = cannon.center;

        for event in pg.event.get():
            
            if event.type == KEYDOWN:
                if event.key == K_w:
                    vec = Vector2(1, 0).rotate(angle) * 10;
                    new_center = (cannon.center[0] + vec[0], cannon.center[1] + vec[1]);
                elif event.key == K_s:
                    vec = Vector2(1, 0).rotate(angle) * 10;
                    new_center = (cannon.center[0] - vec[0], cannon.center[1] - vec[1]);
                if event.key == K_a:
                    angle -= 1
                    if angle < 0:
                        angle = 360;
                elif event.key == K_d:
                    angle += 1
                    if angle > 360:
                        angle = 0;
            if event.type == pg.QUIT:
                return

        cannon.center = new_center;

        # Rotate the cannon image.
        rotated_cannon_img = pg.transform.rotate(cannon_img, -angle)
        cannon = rotated_cannon_img.get_rect(center=cannon.center)

        cannon_sprite = pg.sprite.Sprite()
        cannon_sprite.image = rotated_cannon_img
        cannon_sprite.rect = cannon
        cannon_sprite.mask = pg.mask.from_surface(cannon_sprite.image);

        # Draw
        screen.fill((30, 40, 50))
        screen.blit(rotated_cannon_img, cannon)
        screen.blit(obst_img, obst);
        screen.blit(right_wall_img,right_wall_rect);
        screen.blit(left_wall_img,left_wall_rect);
        screen.blit(bott_wall_img,bott_wall_rect);
        pg.draw.line(screen, (255,255,255), (0,50), (300,50), 2)

        txt = '';
        # txt = FONT.render('angle {:.1f}'.format(angle), True, (150, 150, 170))
        #  ============== COLLISIONS ==============
        # RED CENTER SQUARE
        if pg.sprite.collide_mask(cannon_sprite,obstacle):
            x_change = obst.center[0] - cannon.center[0];
            y_change = obst.center[1] - cannon.center[1];
            magnitude = math.sqrt((x_change * x_change) + (y_change * y_change));
            x_change = (x_change / magnitude) * 3;
            y_change = (y_change / magnitude) * 3;
            new_center = (cannon.center[0] - x_change, cannon.center[1] - y_change);
            cannon.center = new_center;
            screen.blit(rotated_cannon_img, cannon);
        # LEFT WALL 
        if pg.sprite.collide_mask(cannon_sprite,left_wall):
            x_change = left_wall_rect.center[0] - cannon.center[0];
            y_change = left_wall_rect.center[1] - cannon.center[1];
            new_center = (cannon.center[0] - (x_change/5), cannon.center[1]);
            cannon.center = new_center;
            screen.blit(rotated_cannon_img, cannon);
        # RIGHT WALL 
        if pg.sprite.collide_mask(cannon_sprite,right_wall):
            x_change = right_wall_rect.center[0] - cannon.center[0];
            y_change = right_wall_rect.center[1] - cannon.center[1];
            new_center = (cannon.center[0] - (x_change/5), cannon.center[1]);
            cannon.center = new_center;
            screen.blit(rotated_cannon_img, cannon);
        # BOTTOM WALL 
        if pg.sprite.collide_mask(cannon_sprite,bott_wall):
            x_change = bott_wall_rect.center[0] - cannon.center[0];
            y_change = bott_wall_rect.center[1] - cannon.center[1];
            new_center = (cannon.center[0], cannon.center[1] - (y_change/5));
            cannon.center = new_center;
            screen.blit(rotated_cannon_img, cannon);

        if cannon.center[1] < 60:
            txt = FONT.render('Success!', True, (150, 150, 170));
        else:
            txt = FONT.render('Not yet...', True, (150, 150, 170));

        screen.blit(txt, (10, 10))
        pg.display.update()

        clock.tick(30)

main()