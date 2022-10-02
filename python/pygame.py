import pygame

pg = pygame;

maxIterations = 100
size = 512

pygame.init()

pygame.display.set_caption('mandelbrot')
window_surface = pygame.display.set_mode((size, size))

background = pygame.Surface((size, size))
background.fill(pygame.Color('#234234'))

pixarray = pg.PixelArray(window_surface)

for x in range(0, len(pixarray)):
    for y in range(0, len(pixarray[x])):
        a = (x / size - 0.5) * 4.5
        b = (y / size - 0.5) * 4.5

        aa = a
        bb = b
        za = a
        zb = b

        iterations = 0
        while iterations < maxIterations:
            aa = za*za - zb*zb
            bb = 2 * (za * zb)

            za = aa + a
            zb = bb + b
            
            iterations += 1
            if za*za + zb*zb > 4:
                break

        g = (iterations/maxIterations) * 255
        c = (g, g, g)

        if(iterations == maxIterations):
            c = (0, 0, 0)

        pixarray[x,y] = c

pygame.display.update()


is_running = True

while is_running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
             is_running = False

    pygame.display.update()
