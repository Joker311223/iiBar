#import <AppKit/AppKit.h>

static BOOL isOuterBackground(unsigned char *pixels, NSInteger bytesPerRow, NSInteger x, NSInteger y) {
    NSInteger offset = y * bytesPerRow + x * 4;
    unsigned char maximum = MAX(pixels[offset], MAX(pixels[offset + 1], pixels[offset + 2]));
    return maximum < 24;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        if (argc != 3) {
            fprintf(stderr, "Usage: prepare-app-icon <input.png> <output.png>\n");
            return 2;
        }

        NSString *inputPath = [NSString stringWithUTF8String:argv[1]];
        NSString *outputPath = [NSString stringWithUTF8String:argv[2]];
        NSImage *source = [[NSImage alloc] initWithContentsOfFile:inputPath];
        if (source == nil) {
            fprintf(stderr, "Unable to read input image.\n");
            return 1;
        }

        const NSInteger side = 1024;
        NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc]
            initWithBitmapDataPlanes:NULL
            pixelsWide:side
            pixelsHigh:side
            bitsPerSample:8
            samplesPerPixel:4
            hasAlpha:YES
            isPlanar:NO
            colorSpaceName:NSDeviceRGBColorSpace
            bytesPerRow:side * 4
            bitsPerPixel:32];
        if (bitmap == nil) {
            fprintf(stderr, "Unable to allocate output bitmap.\n");
            return 1;
        }

        [NSGraphicsContext saveGraphicsState];
        NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap];
        context.imageInterpolation = NSImageInterpolationHigh;
        [NSGraphicsContext setCurrentContext:context];
        [source drawInRect:NSMakeRect(0, 0, side, side)
                  fromRect:NSZeroRect
                 operation:NSCompositingOperationCopy
                  fraction:1.0];
        [NSGraphicsContext restoreGraphicsState];

        unsigned char *pixels = bitmap.bitmapData;
        NSInteger bytesPerRow = bitmap.bytesPerRow;
        NSInteger pixelCount = side * side;
        BOOL *visited = calloc((size_t)pixelCount, sizeof(BOOL));
        NSInteger *queueX = malloc((size_t)pixelCount * sizeof(NSInteger));
        NSInteger *queueY = malloc((size_t)pixelCount * sizeof(NSInteger));
        if (pixels == NULL || visited == NULL || queueX == NULL || queueY == NULL) {
            fprintf(stderr, "Unable to access output pixels.\n");
            return 1;
        }

        __block NSInteger head = 0;
        __block NSInteger tail = 0;
        void (^enqueue)(NSInteger, NSInteger) = ^(NSInteger x, NSInteger y) {
            if (x < 0 || x >= side || y < 0 || y >= side) return;
            NSInteger index = y * side + x;
            if (visited[index]) return;
            visited[index] = YES;
            if (!isOuterBackground(pixels, bytesPerRow, x, y)) return;
            queueX[tail] = x;
            queueY[tail] = y;
            tail += 1;
        };

        for (NSInteger coordinate = 0; coordinate < side; coordinate += 1) {
            enqueue(coordinate, 0);
            enqueue(coordinate, side - 1);
            enqueue(0, coordinate);
            enqueue(side - 1, coordinate);
        }

        while (head < tail) {
            NSInteger x = queueX[head];
            NSInteger y = queueY[head];
            head += 1;
            NSInteger offset = y * bytesPerRow + x * 4;
            pixels[offset + 3] = 0;
            enqueue(x - 1, y);
            enqueue(x + 1, y);
            enqueue(x, y - 1);
            enqueue(x, y + 1);
        }

        free(visited);
        free(queueX);
        free(queueY);

        NSData *png = [bitmap representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
        if (png == nil || ![png writeToFile:outputPath atomically:YES]) {
            fprintf(stderr, "Unable to write output image.\n");
            return 1;
        }
    }
    return 0;
}
