"""Проверка реального вывода ncurses в псевдотерминале Linux."""

import fcntl
import os
import pty
import select
import struct
import subprocess
import termios
import time

import pyte
from pyte.graphics import BG_ANSI
from PIL import Image, ImageDraw, ImageFont

ROWS, COLS = 9, 52
WHITE, YELLOW = BG_ANSI[47], BG_ANSI[43]
COLORS = {WHITE: '#efefef', YELLOW: '#f2d253', 'black': '#191919'}


def save_frame(screen, name):
    font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 17)
    w, h, pad = 11, 24, 14
    image = Image.new('RGB', (COLS*w+2*pad, ROWS*h+2*pad), '#191919')
    draw = ImageDraw.Draw(image)
    for row in range(ROWS):
        for col in range(COLS):
            cell = screen.buffer[row][col]
            x, y = pad+col*w, pad+row*h
            draw.rectangle((x, y, x+w-1, y+h-1), fill=COLORS.get(cell.bg, '#191919'))
            if cell.data != ' ':
                draw.text((x, y+1), cell.data, font=font, fill=COLORS.get(cell.fg, '#efefef'))
    x, y = pad+screen.cursor.x*w, pad+screen.cursor.y*h
    draw.rectangle((x, y, x+w-1, y+h-1), outline='#888888')
    image.save(name)


def main():
    master, slave = pty.openpty()
    fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack('HHHH', ROWS, COLS, 0, 0))
    original_mode = termios.tcgetattr(slave)
    env = dict(os.environ, TERM='xterm-256color', LC_ALL='C')
    for key in ('LINES', 'COLUMNS', 'NCURSES_NO_UTF8_ACS'):
        env.pop(key, None)
    process = subprocess.Popen(['./spiral'], stdin=slave, stdout=slave, stderr=slave, env=env)
    screen = pyte.Screen(COLS, ROWS)
    stream = pyte.ByteStream(screen)

    def cells(color):
        return {(r, c) for r in range(1, ROWS) for c in range(COLS)
                if screen.buffer[r][c].bg == color}

    def wait_for(predicate):
        end = time.monotonic() + 8
        while time.monotonic() < end:
            if predicate():
                return
            if select.select([master], [], [], 0.05)[0]:
                stream.feed(os.read(master, 65536))
            if process.poll() is not None:
                break
        raise AssertionError(f'Expected frame not found: {screen.display!r}')

    try:
        # Первые восемь клеток по схеме варианта, включая центральную.
        first = {(4, 26), (5, 26), (5, 27), (4, 27), (3, 27), (3, 26), (3, 25), (4, 25)}
        wait_for(lambda: cells(WHITE) == first)
        assert (screen.cursor.y, screen.cursor.x) == (4, 25)
        print('Движение №8: первые восемь клеток и положение курсора — OK')
        assert '90 ms | pass 1' in screen.display[0]
        os.write(master, b'l')
        wait_for(lambda: '30 ms | pass 1' in screen.display[0] and len(cells(WHITE)) >= 25)
        save_frame(screen, 'white.png')
        os.write(master, b'l')
        wait_for(lambda: '5 ms | pass 2' in screen.display[0] and len(cells(YELLOW)) >= 17)
        assert (4, 26) in cells(YELLOW)
        assert any(r in (1, ROWS-1) or c in (0, COLS-1) for r, c in cells(WHITE))
        save_frame(screen, 'yellow.png')
        print('Граница достигнута: следующий проход начался в центре жёлтым — OK')
        os.write(master, b'l')
        wait_for(lambda: '90 ms | pass' in screen.display[0])
        print('l: задержка меняется 90 → 30 → 5 → 90 мс — OK')
        os.write(master, b'j')
        assert process.wait(timeout=3) == 0
        assert termios.tcgetattr(slave) == original_mode
        print('j: выход с кодом 0, настройки терминала восстановлены — OK')
    finally:
        if process.poll() is None:
            process.kill()
            process.wait()
        os.close(slave)
        os.close(master)


if __name__ == '__main__':
    main()
