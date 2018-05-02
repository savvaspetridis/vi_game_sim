import subprocess
import pygame as pg
from pygame.math import Vector2
from pygame.locals import *
import math


# video_folder = './results_savvas/trial_3_reverse.mov_output/';
video_folder = './Katy_Archive/katy_path_1_try_1.mov_output/';

# GET MATRIX FROM FILE:
frame_matrix = [];
matrix_file = open(video_folder + 'presence.txt','r');
matrix_file = matrix_file.read();
matrix_file = matrix_file.split('\n');
for line in matrix_file:
    if line != '':
        frame = map(int, line.split(','))
        frame_matrix.append(frame);

pg.init()
screen = pg.display.set_mode((900,400)); 
game_screen = pg.Surface((300,400), pg.SRCALPHA)
game_screen.fill((30, 40, 50));
game_screen_rect = game_screen.get_rect();
screen.blit(game_screen, (600,0));

# RED OBSTACLE
obstacle = pg.sprite.Sprite()
obst_img = pg.Surface((40, 40), pg.SRCALPHA)
obst_img.fill(pg.Color('red'))
obst = obst_img.get_rect(center=(750, 190));
obstacle.image = obst_img;
obstacle.rect = obst;
obstacle.mask = pg.mask.from_surface(obstacle.image);
screen.blit(obst_img, obst);


# RIGHT WALL: 
right_wall = pg.sprite.Sprite()
right_wall_img = pg.Surface((10, 400), pg.SRCALPHA)
right_wall_img.fill(pg.Color('white'));
right_wall_rect = right_wall_img.get_rect(center=(900,200));
right_wall.image = right_wall_img;
right_wall.rect = right_wall_rect;
right_wall.mask = pg.mask.from_surface(right_wall.image);
screen.blit(right_wall_img, right_wall_rect);

# LEFT WALL:
left_wall = pg.sprite.Sprite()
left_wall_img = pg.Surface((5, 400), pg.SRCALPHA)
left_wall_img.fill(pg.Color('white'));
left_wall_rect = left_wall_img.get_rect(center=(602,200));
left_wall.image = left_wall_img;
left_wall.rect = left_wall_rect;
left_wall.mask = pg.mask.from_surface(left_wall.image);
screen.blit(left_wall_img, left_wall_rect);

# BOTTOM WALL:
bott_wall = pg.sprite.Sprite()
bott_wall_img = pg.Surface((300, 10), pg.SRCALPHA)
bott_wall_img.fill(pg.Color('white'));
bott_wall_rect = bott_wall_img.get_rect(center=(750,400));
bott_wall.image = bott_wall_img;
bott_wall.rect = bott_wall_rect;
bott_wall.mask = pg.mask.from_surface(bott_wall.image);
screen.blit(bott_wall_img,bott_wall_rect);

FONT = pg.font.Font(None, 24);
time_to_wait = int(10000/float(len(frame_matrix)));

def main():
    i = 1;
    success = False;
    final_center = 0;
    final_angle = 0;
    clock = pg.time.Clock()
    cannon_img = pg.Surface((40, 20), pg.SRCALPHA)
    cannon_img.fill(pg.Color('aquamarine3'))
    cannon = cannon_img.get_rect(center=(740, 350))
    angle = 0

    for frame in frame_matrix:
        # print i
        image  = pg.image.load(video_folder + 'Frame_' + str(i) + '.jpg') 
        image = pg.transform.scale(image, (600, 400))
        screen.blit(image, (0,0)) 
        pg.display.flip()
        i = i + 1;

        new_center = cannon.center;

        smile = frame[0];
        o_mouth = frame[1];
        leb = frame[5];
        reb = frame[6];

        symbol_txt = '';

        is_moving = False;

        if smile == 1: 
            vec = Vector2(1, 0).rotate(angle) * 10;
            new_center = (cannon.center[0] + vec[0], cannon.center[1] + vec[1]);
            symbol_txt = symbol_txt + 'Smile';
            is_moving = True;
        elif o_mouth == 1:
            vec = Vector2(1, 0).rotate(angle) * 10;
            new_center = (cannon.center[0] - vec[0], cannon.center[1] - vec[1]);
            symbol_txt = symbol_txt + 'O-mouth';
            is_moving = True;
        if leb == 1:
            if is_moving:
                symbol_txt = symbol_txt + ' + l.e.b.';
            else:
                symbol_txt = symbol_txt + 'l.e.b.';
            # angle -= 10
            angle -= 1
            if angle < 0:
                angle = 360;
        elif reb == 1:
            if is_moving:
                symbol_txt = symbol_txt + ' + r.e.b.';
            else:
                symbol_txt = symbol_txt + 'r.e.b.';
            # angle += 10
            angle += 1
            if angle > 360:
                angle = 0;

        if success != True:
            cannon.center = new_center;
        else:
            cannon.center = final_center;

        # Rotate the cannon image.
        rotated_cannon_img = pg.transform.rotate(cannon_img, -angle)
        cannon = rotated_cannon_img.get_rect(center=cannon.center)

        cannon_sprite = pg.sprite.Sprite()
        cannon_sprite.image = rotated_cannon_img
        cannon_sprite.rect = cannon
        cannon_sprite.mask = pg.mask.from_surface(cannon_sprite.image);

        # Draw
        game_screen.fill((30, 40, 50));
        screen.blit(game_screen, (600,0));
        screen.blit(rotated_cannon_img, cannon)
        screen.blit(obst_img, obst);
        screen.blit(right_wall_img,right_wall_rect);
        screen.blit(left_wall_img,left_wall_rect);
        screen.blit(bott_wall_img,bott_wall_rect);
        pg.draw.line(screen, (255,255,255), (600,50), (900,50), 2)

        txt = '';
        # txt = FONT.render('angle {:.1f}'.format(angle), True, (150, 150, 170))
        #  ============== COLLISIONS ==============
        # RED CENTER SQUARE
        if pg.sprite.collide_mask(cannon_sprite,obstacle):
            x_change = obst.center[0] - cannon.center[0];
            y_change = obst.center[1] - cannon.center[1];
            magnitude = math.sqrt((x_change * x_change) + (y_change * y_change));
            x_change = (x_change / magnitude) * 19;
            y_change = (y_change / magnitude) * 19;
            new_center = (cannon.center[0] - x_change, cannon.center[1] - y_change);
            cannon.center = new_center;
            screen.blit(rotated_cannon_img, cannon);
        # LEFT WALL 
        if pg.sprite.collide_mask(cannon_sprite,left_wall):
            x_change = left_wall_rect.center[0] - cannon.center[0];
            y_change = left_wall_rect.center[1] - cannon.center[1];
            new_center = (cannon.center[0] - (x_change/2), cannon.center[1]);
            cannon.center = new_center;
            screen.blit(rotated_cannon_img, cannon);
        # RIGHT WALL 
        if pg.sprite.collide_mask(cannon_sprite,right_wall):
            x_change = right_wall_rect.center[0] - cannon.center[0];
            y_change = right_wall_rect.center[1] - cannon.center[1];
            new_center = (cannon.center[0] - (x_change/2), cannon.center[1]);
            cannon.center = new_center;
            screen.blit(rotated_cannon_img, cannon);
        # BOTTOM WALL 
        if pg.sprite.collide_mask(cannon_sprite,bott_wall):
            x_change = bott_wall_rect.center[0] - cannon.center[0];
            y_change = bott_wall_rect.center[1] - cannon.center[1];
            new_center = (cannon.center[0], cannon.center[1] - (y_change/2));
            cannon.center = new_center;
            screen.blit(rotated_cannon_img, cannon);

        if cannon.center[1] < 60:
            txt = FONT.render('Success!', True, (150, 150, 170));
            if success == False: 
                print 'SUCCESS!';
                final_center = cannon.center; 
                final_cannon_img = cannon_img;
            success = True;
            # print 'SUCCESS!';
            # break;
        else:
            txt = FONT.render('Not yet...', True, (150, 150, 170));

        symbol_txt = FONT.render(symbol_txt, True, (150, 150, 170));
        screen.blit(symbol_txt, (790,10));

        screen.blit(txt, (610, 10))
        pg.display.update()

        # clock.tick(30)
        # time_to_wait = int(1000/float(len(frame_matrix)));
        # pg.time.wait(int(1000/float(len(frame_matrix))));
main()














