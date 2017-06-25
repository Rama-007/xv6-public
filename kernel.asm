
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 2e 10 80       	mov    $0x80102ed0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 40 71 10 80       	push   $0x80107140
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 55 43 00 00       	call   801043b0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 71 10 80       	push   $0x80107147
80100097:	50                   	push   %eax
80100098:	e8 03 42 00 00       	call   801042a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 e7 42 00 00       	call   801043d0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 49 44 00 00       	call   801045b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 41 00 00       	call   801042e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 4d 1f 00 00       	call   801020d0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 4e 71 10 80       	push   $0x8010714e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 cd 41 00 00       	call   80104380 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 07 1f 00 00       	jmp    801020d0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 71 10 80       	push   $0x8010715f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 8c 41 00 00       	call   80104380 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 41 00 00       	call   80104340 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 c0 41 00 00       	call   801043d0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 4f 43 00 00       	jmp    801045b0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 71 10 80       	push   $0x80107166
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 bb 14 00 00       	call   80101740 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 3f 41 00 00       	call   801043d0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002a6:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 c0 ff 10 80       	push   $0x8010ffc0
801002bd:	e8 5e 3b 00 00       	call   80103e20 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(proc->killed){
801002d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002d8:	8b 40 24             	mov    0x24(%eax),%eax
801002db:	85 c0                	test   %eax,%eax
801002dd:	74 d1                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002df:	83 ec 0c             	sub    $0xc,%esp
801002e2:	68 20 a5 10 80       	push   $0x8010a520
801002e7:	e8 c4 42 00 00       	call   801045b0 <release>
        ilock(ip);
801002ec:	89 3c 24             	mov    %edi,(%esp)
801002ef:	e8 6c 13 00 00       	call   80101660 <ilock>
        return -1;
801002f4:	83 c4 10             	add    $0x10,%esp
801002f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002ff:	5b                   	pop    %ebx
80100300:	5e                   	pop    %esi
80100301:	5f                   	pop    %edi
80100302:	5d                   	pop    %ebp
80100303:	c3                   	ret    
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 ff 10 80 	movsbl -0x7fef00c0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 65 42 00 00       	call   801045b0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 0d 13 00 00       	call   80101660 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a1                	jmp    801002fc <consoleread+0x8c>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100379:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
8010037f:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100386:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100389:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010038c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010038f:	0f b6 00             	movzbl (%eax),%eax
80100392:	50                   	push   %eax
80100393:	68 6d 71 10 80       	push   $0x8010716d
80100398:	e8 c3 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039d:	58                   	pop    %eax
8010039e:	ff 75 08             	pushl  0x8(%ebp)
801003a1:	e8 ba 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a6:	c7 04 24 66 76 10 80 	movl   $0x80107666,(%esp)
801003ad:	e8 ae 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b2:	5a                   	pop    %edx
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	59                   	pop    %ecx
801003b7:	53                   	push   %ebx
801003b8:	50                   	push   %eax
801003b9:	e8 e2 40 00 00       	call   801044a0 <getcallerpcs>
801003be:	83 c4 10             	add    $0x10,%esp
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	ff 33                	pushl  (%ebx)
801003cd:	83 c3 04             	add    $0x4,%ebx
801003d0:	68 89 71 10 80       	push   $0x80107189
801003d5:	e8 86 02 00 00       	call   80100660 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003da:	83 c4 10             	add    $0x10,%esp
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 21 59 00 00       	call   80105d40 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 68 58 00 00       	call   80105d40 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 5c 58 00 00       	call   80105d40 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 50 58 00 00       	call   80105d40 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 97 41 00 00       	call   801046b0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 d2 40 00 00       	call   80104600 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 8d 71 10 80       	push   $0x8010718d
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 b8 71 10 80 	movzbl -0x7fef8e48(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 2c 11 00 00       	call   80101740 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 b0 3d 00 00       	call   801043d0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 64 3f 00 00       	call   801045b0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 0b 10 00 00       	call   80101660 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 9e 3e 00 00       	call   801045b0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 a0 71 10 80       	mov    $0x801071a0,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 03 3c 00 00       	call   801043d0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 a7 71 10 80       	push   $0x801071a7
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 c8 3b 00 00       	call   801043d0 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100836:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 43 3d 00 00       	call   801045b0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008f1:	68 c0 ff 10 80       	push   $0x8010ffc0
801008f6:	e8 f5 37 00 00       	call   801040f0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010090d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100934:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 64 38 00 00       	jmp    801041e0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 b0 71 10 80       	push   $0x801071b0
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 fb 39 00 00       	call   801043b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bc:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009c3:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c6:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009cd:	02 10 80 
  cons.locking = 1;
801009d0:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d7:	00 00 00 

  picenable(IRQ_KBD);
801009da:	e8 b1 28 00 00       	call   80103290 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009df:	58                   	pop    %eax
801009e0:	5a                   	pop    %edx
801009e1:	6a 00                	push   $0x0
801009e3:	6a 01                	push   $0x1
801009e5:	e8 a6 18 00 00       	call   80102290 <ioapicenable>
}
801009ea:	83 c4 10             	add    $0x10,%esp
801009ed:	c9                   	leave  
801009ee:	c3                   	ret    
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009fc:	e8 bf 21 00 00       	call   80102bc0 <begin_op>

  if((ip = namei(path)) == 0){
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	ff 75 08             	pushl  0x8(%ebp)
80100a07:	e8 84 14 00 00       	call   80101e90 <namei>
80100a0c:	83 c4 10             	add    $0x10,%esp
80100a0f:	85 c0                	test   %eax,%eax
80100a11:	0f 84 a3 01 00 00    	je     80100bba <exec+0x1ca>
    end_op();
    return -1;
  }
  ilock(ip);
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	89 c3                	mov    %eax,%ebx
80100a1c:	50                   	push   %eax
80100a1d:	e8 3e 0c 00 00       	call   80101660 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100a22:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a28:	6a 34                	push   $0x34
80100a2a:	6a 00                	push   $0x0
80100a2c:	50                   	push   %eax
80100a2d:	53                   	push   %ebx
80100a2e:	e8 ed 0e 00 00       	call   80101920 <readi>
80100a33:	83 c4 20             	add    $0x20,%esp
80100a36:	83 f8 33             	cmp    $0x33,%eax
80100a39:	77 25                	ja     80100a60 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a3b:	83 ec 0c             	sub    $0xc,%esp
80100a3e:	53                   	push   %ebx
80100a3f:	e8 8c 0e 00 00       	call   801018d0 <iunlockput>
    end_op();
80100a44:	e8 e7 21 00 00       	call   80102c30 <end_op>
80100a49:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a54:	5b                   	pop    %ebx
80100a55:	5e                   	pop    %esi
80100a56:	5f                   	pop    %edi
80100a57:	5d                   	pop    %ebp
80100a58:	c3                   	ret    
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 cf                	jne    80100a3b <exec+0x4b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 8f 60 00 00       	call   80106b00 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a79:	74 c0                	je     80100a3b <exec+0x4b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a82:	00 
80100a83:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a89:	0f 84 a1 02 00 00    	je     80100d30 <exec+0x340>
80100a8f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a96:	00 00 00 
80100a99:	31 ff                	xor    %edi,%edi
80100a9b:	eb 18                	jmp    80100ab5 <exec+0xc5>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
80100aa0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aa7:	83 c7 01             	add    $0x1,%edi
80100aaa:	83 c6 20             	add    $0x20,%esi
80100aad:	39 f8                	cmp    %edi,%eax
80100aaf:	0f 8e ab 00 00 00    	jle    80100b60 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ab5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100abb:	6a 20                	push   $0x20
80100abd:	56                   	push   %esi
80100abe:	50                   	push   %eax
80100abf:	53                   	push   %ebx
80100ac0:	e8 5b 0e 00 00       	call   80101920 <readi>
80100ac5:	83 c4 10             	add    $0x10,%esp
80100ac8:	83 f8 20             	cmp    $0x20,%eax
80100acb:	75 7b                	jne    80100b48 <exec+0x158>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100acd:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ad4:	75 ca                	jne    80100aa0 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ad6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100adc:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ae2:	72 64                	jb     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ae4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100aea:	72 5c                	jb     80100b48 <exec+0x158>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aec:	83 ec 04             	sub    $0x4,%esp
80100aef:	50                   	push   %eax
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100afc:	e8 8f 62 00 00       	call   80106d90 <allocuvm>
80100b01:	83 c4 10             	add    $0x10,%esp
80100b04:	85 c0                	test   %eax,%eax
80100b06:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b0c:	74 3a                	je     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b0e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b14:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b19:	75 2d                	jne    80100b48 <exec+0x158>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b1b:	83 ec 0c             	sub    $0xc,%esp
80100b1e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b24:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b2a:	53                   	push   %ebx
80100b2b:	50                   	push   %eax
80100b2c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b32:	e8 99 61 00 00       	call   80106cd0 <loaduvm>
80100b37:	83 c4 20             	add    $0x20,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 89 5e ff ff ff    	jns    80100aa0 <exec+0xb0>
80100b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b48:	83 ec 0c             	sub    $0xc,%esp
80100b4b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b51:	e8 6a 63 00 00       	call   80106ec0 <freevm>
80100b56:	83 c4 10             	add    $0x10,%esp
80100b59:	e9 dd fe ff ff       	jmp    80100a3b <exec+0x4b>
80100b5e:	66 90                	xchg   %ax,%ax
80100b60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100b6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100b72:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b78:	83 ec 0c             	sub    $0xc,%esp
80100b7b:	53                   	push   %ebx
80100b7c:	e8 4f 0d 00 00       	call   801018d0 <iunlockput>
  end_op();
80100b81:	e8 aa 20 00 00       	call   80102c30 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b86:	83 c4 0c             	add    $0xc,%esp
80100b89:	57                   	push   %edi
80100b8a:	56                   	push   %esi
80100b8b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b91:	e8 fa 61 00 00       	call   80106d90 <allocuvm>
80100b96:	83 c4 10             	add    $0x10,%esp
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	89 c6                	mov    %eax,%esi
80100b9d:	75 2a                	jne    80100bc9 <exec+0x1d9>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b9f:	83 ec 0c             	sub    $0xc,%esp
80100ba2:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba8:	e8 13 63 00 00       	call   80106ec0 <freevm>
80100bad:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb5:	e9 97 fe ff ff       	jmp    80100a51 <exec+0x61>
  pde_t *pgdir, *oldpgdir;

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bba:	e8 71 20 00 00       	call   80102c30 <end_op>
    return -1;
80100bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc4:	e9 88 fe ff ff       	jmp    80100a51 <exec+0x61>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bcf:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bd2:	31 ff                	xor    %edi,%edi
80100bd4:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd6:	50                   	push   %eax
80100bd7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bdd:	e8 5e 63 00 00       	call   80106f40 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bee:	8b 00                	mov    (%eax),%eax
80100bf0:	85 c0                	test   %eax,%eax
80100bf2:	74 71                	je     80100c65 <exec+0x275>
80100bf4:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100bfa:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c00:	eb 0b                	jmp    80100c0d <exec+0x21d>
80100c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
80100c08:	83 ff 20             	cmp    $0x20,%edi
80100c0b:	74 92                	je     80100b9f <exec+0x1af>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0d:	83 ec 0c             	sub    $0xc,%esp
80100c10:	50                   	push   %eax
80100c11:	e8 2a 3c 00 00       	call   80104840 <strlen>
80100c16:	f7 d0                	not    %eax
80100c18:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c1a:	58                   	pop    %eax
80100c1b:	8b 45 0c             	mov    0xc(%ebp),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c1e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c21:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c24:	e8 17 3c 00 00       	call   80104840 <strlen>
80100c29:	83 c0 01             	add    $0x1,%eax
80100c2c:	50                   	push   %eax
80100c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c30:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c33:	53                   	push   %ebx
80100c34:	56                   	push   %esi
80100c35:	e8 66 64 00 00       	call   801070a0 <copyout>
80100c3a:	83 c4 20             	add    $0x20,%esp
80100c3d:	85 c0                	test   %eax,%eax
80100c3f:	0f 88 5a ff ff ff    	js     80100b9f <exec+0x1af>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c45:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c48:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c4f:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c52:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c5b:	85 c0                	test   %eax,%eax
80100c5d:	75 a9                	jne    80100c08 <exec+0x218>
80100c5f:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c65:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c6c:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c6e:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c75:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c79:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c80:	ff ff ff 
  ustack[1] = argc;
80100c83:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c89:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c8b:	83 c0 0c             	add    $0xc,%eax
80100c8e:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c90:	50                   	push   %eax
80100c91:	52                   	push   %edx
80100c92:	53                   	push   %ebx
80100c93:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c99:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9f:	e8 fc 63 00 00       	call   801070a0 <copyout>
80100ca4:	83 c4 10             	add    $0x10,%esp
80100ca7:	85 c0                	test   %eax,%eax
80100ca9:	0f 88 f0 fe ff ff    	js     80100b9f <exec+0x1af>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100caf:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb2:	0f b6 10             	movzbl (%eax),%edx
80100cb5:	84 d2                	test   %dl,%dl
80100cb7:	74 1a                	je     80100cd3 <exec+0x2e3>
80100cb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbc:	83 c0 01             	add    $0x1,%eax
80100cbf:	90                   	nop
    if(*s == '/')
      last = s+1;
80100cc0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cc6:	0f 44 c8             	cmove  %eax,%ecx
80100cc9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccc:	84 d2                	test   %dl,%dl
80100cce:	75 f0                	jne    80100cc0 <exec+0x2d0>
80100cd0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd9:	83 ec 04             	sub    $0x4,%esp
80100cdc:	6a 10                	push   $0x10
80100cde:	ff 75 08             	pushl  0x8(%ebp)
80100ce1:	83 c0 6c             	add    $0x6c,%eax
80100ce4:	50                   	push   %eax
80100ce5:	e8 16 3b 00 00       	call   80104800 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100cf0:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cf6:	8b 78 04             	mov    0x4(%eax),%edi
  proc->pgdir = pgdir;
  proc->sz = sz;
80100cf9:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
80100cfb:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
80100cfe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d04:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d0a:	8b 50 18             	mov    0x18(%eax),%edx
80100d0d:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d10:	8b 50 18             	mov    0x18(%eax),%edx
80100d13:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d16:	89 04 24             	mov    %eax,(%esp)
80100d19:	e8 92 5e 00 00       	call   80106bb0 <switchuvm>
  freevm(oldpgdir);
80100d1e:	89 3c 24             	mov    %edi,(%esp)
80100d21:	e8 9a 61 00 00       	call   80106ec0 <freevm>
  return 0;
80100d26:	83 c4 10             	add    $0x10,%esp
80100d29:	31 c0                	xor    %eax,%eax
80100d2b:	e9 21 fd ff ff       	jmp    80100a51 <exec+0x61>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d30:	bf 00 20 00 00       	mov    $0x2000,%edi
80100d35:	31 f6                	xor    %esi,%esi
80100d37:	e9 3c fe ff ff       	jmp    80100b78 <exec+0x188>
80100d3c:	66 90                	xchg   %ax,%ax
80100d3e:	66 90                	xchg   %ax,%ax

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	68 c9 71 10 80       	push   $0x801071c9
80100d4b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d50:	e8 5b 36 00 00       	call   801043b0 <initlock>
}
80100d55:	83 c4 10             	add    $0x10,%esp
80100d58:	c9                   	leave  
80100d59:	c3                   	ret    
80100d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d69:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d6c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d71:	e8 5a 36 00 00       	call   801043d0 <acquire>
80100d76:	83 c4 10             	add    $0x10,%esp
80100d79:	eb 10                	jmp    80100d8b <filealloc+0x2b>
80100d7b:	90                   	nop
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d89:	74 25                	je     80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d9c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100da1:	e8 0a 38 00 00       	call   801045b0 <release>
      return f;
80100da6:	89 d8                	mov    %ebx,%eax
80100da8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dae:	c9                   	leave  
80100daf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100db0:	83 ec 0c             	sub    $0xc,%esp
80100db3:	68 e0 ff 10 80       	push   $0x8010ffe0
80100db8:	e8 f3 37 00 00       	call   801045b0 <release>
  return 0;
80100dbd:	83 c4 10             	add    $0x10,%esp
80100dc0:	31 c0                	xor    %eax,%eax
}
80100dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc5:	c9                   	leave  
80100dc6:	c3                   	ret    
80100dc7:	89 f6                	mov    %esi,%esi
80100dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 10             	sub    $0x10,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	68 e0 ff 10 80       	push   $0x8010ffe0
80100ddf:	e8 ec 35 00 00       	call   801043d0 <acquire>
  if(f->ref < 1)
80100de4:	8b 43 04             	mov    0x4(%ebx),%eax
80100de7:	83 c4 10             	add    $0x10,%esp
80100dea:	85 c0                	test   %eax,%eax
80100dec:	7e 1a                	jle    80100e08 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100df1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100df4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df7:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dfc:	e8 af 37 00 00       	call   801045b0 <release>
  return f;
}
80100e01:	89 d8                	mov    %ebx,%eax
80100e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e06:	c9                   	leave  
80100e07:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e08:	83 ec 0c             	sub    $0xc,%esp
80100e0b:	68 d0 71 10 80       	push   $0x801071d0
80100e10:	e8 5b f5 ff ff       	call   80100370 <panic>
80100e15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 28             	sub    $0x28,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e31:	e8 9a 35 00 00       	call   801043d0 <acquire>
  if(f->ref < 1)
80100e36:	8b 47 04             	mov    0x4(%edi),%eax
80100e39:	83 c4 10             	add    $0x10,%esp
80100e3c:	85 c0                	test   %eax,%eax
80100e3e:	0f 8e 9b 00 00 00    	jle    80100edf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e44:	83 e8 01             	sub    $0x1,%eax
80100e47:	85 c0                	test   %eax,%eax
80100e49:	89 47 04             	mov    %eax,0x4(%edi)
80100e4c:	74 1a                	je     80100e68 <fileclose+0x48>
    release(&ftable.lock);
80100e4e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e58:	5b                   	pop    %ebx
80100e59:	5e                   	pop    %esi
80100e5a:	5f                   	pop    %edi
80100e5b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e5c:	e9 4f 37 00 00       	jmp    801045b0 <release>
80100e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e68:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e6c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e6e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e71:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e74:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e7d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e80:	68 e0 ff 10 80       	push   $0x8010ffe0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e88:	e8 23 37 00 00       	call   801045b0 <release>

  if(ff.type == FD_PIPE)
80100e8d:	83 c4 10             	add    $0x10,%esp
80100e90:	83 fb 01             	cmp    $0x1,%ebx
80100e93:	74 13                	je     80100ea8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e95:	83 fb 02             	cmp    $0x2,%ebx
80100e98:	74 26                	je     80100ec0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e9d:	5b                   	pop    %ebx
80100e9e:	5e                   	pop    %esi
80100e9f:	5f                   	pop    %edi
80100ea0:	5d                   	pop    %ebp
80100ea1:	c3                   	ret    
80100ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eac:	83 ec 08             	sub    $0x8,%esp
80100eaf:	53                   	push   %ebx
80100eb0:	56                   	push   %esi
80100eb1:	e8 aa 25 00 00       	call   80103460 <pipeclose>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb df                	jmp    80100e9a <fileclose+0x7a>
80100ebb:	90                   	nop
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 fb 1c 00 00       	call   80102bc0 <begin_op>
    iput(ff.ip);
80100ec5:	83 ec 0c             	sub    $0xc,%esp
80100ec8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ecb:	e8 c0 08 00 00       	call   80101790 <iput>
    end_op();
80100ed0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed6:	5b                   	pop    %ebx
80100ed7:	5e                   	pop    %esi
80100ed8:	5f                   	pop    %edi
80100ed9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eda:	e9 51 1d 00 00       	jmp    80102c30 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edf:	83 ec 0c             	sub    $0xc,%esp
80100ee2:	68 d8 71 10 80       	push   $0x801071d8
80100ee7:	e8 84 f4 ff ff       	call   80100370 <panic>
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 04             	sub    $0x4,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	ff 73 10             	pushl  0x10(%ebx)
80100f05:	e8 56 07 00 00       	call   80101660 <ilock>
    stati(f->ip, st);
80100f0a:	58                   	pop    %eax
80100f0b:	5a                   	pop    %edx
80100f0c:	ff 75 0c             	pushl  0xc(%ebp)
80100f0f:	ff 73 10             	pushl  0x10(%ebx)
80100f12:	e8 d9 09 00 00       	call   801018f0 <stati>
    iunlock(f->ip);
80100f17:	59                   	pop    %ecx
80100f18:	ff 73 10             	pushl  0x10(%ebx)
80100f1b:	e8 20 08 00 00       	call   80101740 <iunlock>
    return 0;
80100f20:	83 c4 10             	add    $0x10,%esp
80100f23:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 0c             	sub    $0xc,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 60                	je     80100fb8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 41                	je     80100fa0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 5b                	jne    80100fbf <fileread+0x7f>
    ilock(f->ip);
80100f64:	83 ec 0c             	sub    $0xc,%esp
80100f67:	ff 73 10             	pushl  0x10(%ebx)
80100f6a:	e8 f1 06 00 00       	call   80101660 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	57                   	push   %edi
80100f70:	ff 73 14             	pushl  0x14(%ebx)
80100f73:	56                   	push   %esi
80100f74:	ff 73 10             	pushl  0x10(%ebx)
80100f77:	e8 a4 09 00 00       	call   80101920 <readi>
80100f7c:	83 c4 20             	add    $0x20,%esp
80100f7f:	85 c0                	test   %eax,%eax
80100f81:	89 c6                	mov    %eax,%esi
80100f83:	7e 03                	jle    80100f88 <fileread+0x48>
      f->off += r;
80100f85:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	ff 73 10             	pushl  0x10(%ebx)
80100f8e:	e8 ad 07 00 00       	call   80101740 <iunlock>
    return r;
80100f93:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f96:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9b:	5b                   	pop    %ebx
80100f9c:	5e                   	pop    %esi
80100f9d:	5f                   	pop    %edi
80100f9e:	5d                   	pop    %ebp
80100f9f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fa3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa9:	5b                   	pop    %ebx
80100faa:	5e                   	pop    %esi
80100fab:	5f                   	pop    %edi
80100fac:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fad:	e9 7e 26 00 00       	jmp    80103630 <piperead>
80100fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fbd:	eb d9                	jmp    80100f98 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	68 e2 71 10 80       	push   $0x801071e2
80100fc7:	e8 a4 f3 ff ff       	call   80100370 <panic>
80100fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 1c             	sub    $0x1c,%esp
80100fd9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fdf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fec:	0f 84 aa 00 00 00    	je     8010109c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 06                	mov    (%esi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 d8 00 00 00    	jne    801010de <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 ff                	xor    %edi,%edi
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 34                	jg     80101043 <filewrite+0x73>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101018:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010101b:	83 ec 0c             	sub    $0xc,%esp
8010101e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101021:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101024:	e8 17 07 00 00       	call   80101740 <iunlock>
      end_op();
80101029:	e8 02 1c 00 00       	call   80102c30 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101031:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101034:	39 d8                	cmp    %ebx,%eax
80101036:	0f 85 95 00 00 00    	jne    801010d1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010103c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010103e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101041:	7e 6d                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101043:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101046:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010104b:	29 fb                	sub    %edi,%ebx
8010104d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101053:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101056:	e8 65 1b 00 00       	call   80102bc0 <begin_op>
      ilock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
80101061:	e8 fa 05 00 00       	call   80101660 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101066:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101069:	53                   	push   %ebx
8010106a:	ff 76 14             	pushl  0x14(%esi)
8010106d:	01 f8                	add    %edi,%eax
8010106f:	50                   	push   %eax
80101070:	ff 76 10             	pushl  0x10(%esi)
80101073:	e8 a8 09 00 00       	call   80101a20 <writei>
80101078:	83 c4 20             	add    $0x20,%esp
8010107b:	85 c0                	test   %eax,%eax
8010107d:	7f 99                	jg     80101018 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	ff 76 10             	pushl  0x10(%esi)
80101085:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101088:	e8 b3 06 00 00       	call   80101740 <iunlock>
      end_op();
8010108d:	e8 9e 1b 00 00       	call   80102c30 <end_op>

      if(r < 0)
80101092:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101095:	83 c4 10             	add    $0x10,%esp
80101098:	85 c0                	test   %eax,%eax
8010109a:	74 98                	je     80101034 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010109c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010109f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010a4:	5b                   	pop    %ebx
801010a5:	5e                   	pop    %esi
801010a6:	5f                   	pop    %edi
801010a7:	5d                   	pop    %ebp
801010a8:	c3                   	ret    
801010a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010b0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010b3:	75 e7                	jne    8010109c <filewrite+0xcc>
  }
  panic("filewrite");
}
801010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b8:	89 f8                	mov    %edi,%eax
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 46 0c             	mov    0xc(%esi),%eax
801010c2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cc:	e9 2f 24 00 00       	jmp    80103500 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010d1:	83 ec 0c             	sub    $0xc,%esp
801010d4:	68 eb 71 10 80       	push   $0x801071eb
801010d9:	e8 92 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010de:	83 ec 0c             	sub    $0xc,%esp
801010e1:	68 f1 71 10 80       	push   $0x801071f1
801010e6:	e8 85 f2 ff ff       	call   80100370 <panic>
801010eb:	66 90                	xchg   %ax,%ax
801010ed:	66 90                	xchg   %ax,%ax
801010ef:	90                   	nop

801010f0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010f9:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101102:	85 c9                	test   %ecx,%ecx
80101104:	0f 84 85 00 00 00    	je     8010118f <balloc+0x9f>
8010110a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101111:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101114:	83 ec 08             	sub    $0x8,%esp
80101117:	89 f0                	mov    %esi,%eax
80101119:	c1 f8 0c             	sar    $0xc,%eax
8010111c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101122:	50                   	push   %eax
80101123:	ff 75 d8             	pushl  -0x28(%ebp)
80101126:	e8 a5 ef ff ff       	call   801000d0 <bread>
8010112b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010112e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101133:	83 c4 10             	add    $0x10,%esp
80101136:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101139:	31 c0                	xor    %eax,%eax
8010113b:	eb 2d                	jmp    8010116a <balloc+0x7a>
8010113d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101140:	89 c1                	mov    %eax,%ecx
80101142:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101147:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010114a:	83 e1 07             	and    $0x7,%ecx
8010114d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010114f:	89 c1                	mov    %eax,%ecx
80101151:	c1 f9 03             	sar    $0x3,%ecx
80101154:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101159:	85 d7                	test   %edx,%edi
8010115b:	74 43                	je     801011a0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010115d:	83 c0 01             	add    $0x1,%eax
80101160:	83 c6 01             	add    $0x1,%esi
80101163:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101168:	74 05                	je     8010116f <balloc+0x7f>
8010116a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010116d:	72 d1                	jb     80101140 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	ff 75 e4             	pushl  -0x1c(%ebp)
80101175:	e8 66 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010117a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101181:	83 c4 10             	add    $0x10,%esp
80101184:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101187:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
8010118d:	77 82                	ja     80101111 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	68 fb 71 10 80       	push   $0x801071fb
80101197:	e8 d4 f1 ff ff       	call   80100370 <panic>
8010119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a0:	09 fa                	or     %edi,%edx
801011a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011a5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011ac:	57                   	push   %edi
801011ad:	e8 ee 1b 00 00       	call   80102da0 <log_write>
        brelse(bp);
801011b2:	89 3c 24             	mov    %edi,(%esp)
801011b5:	e8 26 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ba:	58                   	pop    %eax
801011bb:	5a                   	pop    %edx
801011bc:	56                   	push   %esi
801011bd:	ff 75 d8             	pushl  -0x28(%ebp)
801011c0:	e8 0b ef ff ff       	call   801000d0 <bread>
801011c5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ca:	83 c4 0c             	add    $0xc,%esp
801011cd:	68 00 02 00 00       	push   $0x200
801011d2:	6a 00                	push   $0x0
801011d4:	50                   	push   %eax
801011d5:	e8 26 34 00 00       	call   80104600 <memset>
  log_write(bp);
801011da:	89 1c 24             	mov    %ebx,(%esp)
801011dd:	e8 be 1b 00 00       	call   80102da0 <log_write>
  brelse(bp);
801011e2:	89 1c 24             	mov    %ebx,(%esp)
801011e5:	e8 f6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ed:	89 f0                	mov    %esi,%eax
801011ef:	5b                   	pop    %ebx
801011f0:	5e                   	pop    %esi
801011f1:	5f                   	pop    %edi
801011f2:	5d                   	pop    %ebp
801011f3:	c3                   	ret    
801011f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101200 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101208:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010120f:	83 ec 28             	sub    $0x28,%esp
80101212:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101215:	68 00 0a 11 80       	push   $0x80110a00
8010121a:	e8 b1 31 00 00       	call   801043d0 <acquire>
8010121f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101222:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101225:	eb 1b                	jmp    80101242 <iget+0x42>
80101227:	89 f6                	mov    %esi,%esi
80101229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101230:	85 f6                	test   %esi,%esi
80101232:	74 44                	je     80101278 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101234:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010123a:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101240:	74 4e                	je     80101290 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101242:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101245:	85 c9                	test   %ecx,%ecx
80101247:	7e e7                	jle    80101230 <iget+0x30>
80101249:	39 3b                	cmp    %edi,(%ebx)
8010124b:	75 e3                	jne    80101230 <iget+0x30>
8010124d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101250:	75 de                	jne    80101230 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101252:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101255:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101258:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010125a:	68 00 0a 11 80       	push   $0x80110a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010125f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101262:	e8 49 33 00 00       	call   801045b0 <release>
      return ip;
80101267:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101278:	85 c9                	test   %ecx,%ecx
8010127a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101283:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101289:	75 b7                	jne    80101242 <iget+0x42>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 2d                	je     801012c1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
80101294:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101297:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101299:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010129c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012a3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012aa:	68 00 0a 11 80       	push   $0x80110a00
801012af:	e8 fc 32 00 00       	call   801045b0 <release>

  return ip;
801012b4:	83 c4 10             	add    $0x10,%esp
}
801012b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ba:	89 f0                	mov    %esi,%eax
801012bc:	5b                   	pop    %ebx
801012bd:	5e                   	pop    %esi
801012be:	5f                   	pop    %edi
801012bf:	5d                   	pop    %ebp
801012c0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	68 11 72 10 80       	push   $0x80107211
801012c9:	e8 a2 f0 ff ff       	call   80100370 <panic>
801012ce:	66 90                	xchg   %ax,%ax

801012d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c6                	mov    %eax,%esi
801012d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012db:	83 fa 0b             	cmp    $0xb,%edx
801012de:	77 18                	ja     801012f8 <bmap+0x28>
801012e0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012e3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012e6:	85 c0                	test   %eax,%eax
801012e8:	74 76                	je     80101360 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	5b                   	pop    %ebx
801012ee:	5e                   	pop    %esi
801012ef:	5f                   	pop    %edi
801012f0:	5d                   	pop    %ebp
801012f1:	c3                   	ret    
801012f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012f8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012fb:	83 fb 7f             	cmp    $0x7f,%ebx
801012fe:	0f 87 83 00 00 00    	ja     80101387 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101304:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010130a:	85 c0                	test   %eax,%eax
8010130c:	74 6a                	je     80101378 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010130e:	83 ec 08             	sub    $0x8,%esp
80101311:	50                   	push   %eax
80101312:	ff 36                	pushl  (%esi)
80101314:	e8 b7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101319:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010131d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101320:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101322:	8b 1a                	mov    (%edx),%ebx
80101324:	85 db                	test   %ebx,%ebx
80101326:	75 1d                	jne    80101345 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101328:	8b 06                	mov    (%esi),%eax
8010132a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010132d:	e8 be fd ff ff       	call   801010f0 <balloc>
80101332:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101335:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101338:	89 c3                	mov    %eax,%ebx
8010133a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010133c:	57                   	push   %edi
8010133d:	e8 5e 1a 00 00       	call   80102da0 <log_write>
80101342:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
80101348:	57                   	push   %edi
80101349:	e8 92 ee ff ff       	call   801001e0 <brelse>
8010134e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101351:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101354:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101356:	5b                   	pop    %ebx
80101357:	5e                   	pop    %esi
80101358:	5f                   	pop    %edi
80101359:	5d                   	pop    %ebp
8010135a:	c3                   	ret    
8010135b:	90                   	nop
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101360:	8b 06                	mov    (%esi),%eax
80101362:	e8 89 fd ff ff       	call   801010f0 <balloc>
80101367:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101378:	8b 06                	mov    (%esi),%eax
8010137a:	e8 71 fd ff ff       	call   801010f0 <balloc>
8010137f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101385:	eb 87                	jmp    8010130e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101387:	83 ec 0c             	sub    $0xc,%esp
8010138a:	68 21 72 10 80       	push   $0x80107221
8010138f:	e8 dc ef ff ff       	call   80100370 <panic>
80101394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010139a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013a0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	56                   	push   %esi
801013a4:	53                   	push   %ebx
801013a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013a8:	83 ec 08             	sub    $0x8,%esp
801013ab:	6a 01                	push   $0x1
801013ad:	ff 75 08             	pushl  0x8(%ebp)
801013b0:	e8 1b ed ff ff       	call   801000d0 <bread>
801013b5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ba:	83 c4 0c             	add    $0xc,%esp
801013bd:	6a 1c                	push   $0x1c
801013bf:	50                   	push   %eax
801013c0:	56                   	push   %esi
801013c1:	e8 ea 32 00 00       	call   801046b0 <memmove>
  brelse(bp);
801013c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013c9:	83 c4 10             	add    $0x10,%esp
}
801013cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013cf:	5b                   	pop    %ebx
801013d0:	5e                   	pop    %esi
801013d1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013d2:	e9 09 ee ff ff       	jmp    801001e0 <brelse>
801013d7:	89 f6                	mov    %esi,%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	56                   	push   %esi
801013e4:	53                   	push   %ebx
801013e5:	89 d3                	mov    %edx,%ebx
801013e7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013e9:	83 ec 08             	sub    $0x8,%esp
801013ec:	68 e0 09 11 80       	push   $0x801109e0
801013f1:	50                   	push   %eax
801013f2:	e8 a9 ff ff ff       	call   801013a0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013f7:	58                   	pop    %eax
801013f8:	5a                   	pop    %edx
801013f9:	89 da                	mov    %ebx,%edx
801013fb:	c1 ea 0c             	shr    $0xc,%edx
801013fe:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101404:	52                   	push   %edx
80101405:	56                   	push   %esi
80101406:	e8 c5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010140b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010140d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101413:	ba 01 00 00 00       	mov    $0x1,%edx
80101418:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141b:	c1 fb 03             	sar    $0x3,%ebx
8010141e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101421:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101423:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101428:	85 d1                	test   %edx,%ecx
8010142a:	74 27                	je     80101453 <bfree+0x73>
8010142c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010142e:	f7 d2                	not    %edx
80101430:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101432:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101435:	21 d0                	and    %edx,%eax
80101437:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143b:	56                   	push   %esi
8010143c:	e8 5f 19 00 00       	call   80102da0 <log_write>
  brelse(bp);
80101441:	89 34 24             	mov    %esi,(%esp)
80101444:	e8 97 ed ff ff       	call   801001e0 <brelse>
}
80101449:	83 c4 10             	add    $0x10,%esp
8010144c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5d                   	pop    %ebp
80101452:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101453:	83 ec 0c             	sub    $0xc,%esp
80101456:	68 34 72 10 80       	push   $0x80107234
8010145b:	e8 10 ef ff ff       	call   80100370 <panic>

80101460 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101469:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010146c:	68 47 72 10 80       	push   $0x80107247
80101471:	68 00 0a 11 80       	push   $0x80110a00
80101476:	e8 35 2f 00 00       	call   801043b0 <initlock>
8010147b:	83 c4 10             	add    $0x10,%esp
8010147e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	68 4e 72 10 80       	push   $0x8010724e
80101488:	53                   	push   %ebx
80101489:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010148f:	e8 0c 2e 00 00       	call   801042a0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101494:	83 c4 10             	add    $0x10,%esp
80101497:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
8010149d:	75 e1                	jne    80101480 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
8010149f:	83 ec 08             	sub    $0x8,%esp
801014a2:	68 e0 09 11 80       	push   $0x801109e0
801014a7:	ff 75 08             	pushl  0x8(%ebp)
801014aa:	e8 f1 fe ff ff       	call   801013a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014af:	ff 35 f8 09 11 80    	pushl  0x801109f8
801014b5:	ff 35 f4 09 11 80    	pushl  0x801109f4
801014bb:	ff 35 f0 09 11 80    	pushl  0x801109f0
801014c1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801014c7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801014cd:	ff 35 e4 09 11 80    	pushl  0x801109e4
801014d3:	ff 35 e0 09 11 80    	pushl  0x801109e0
801014d9:	68 a4 72 10 80       	push   $0x801072a4
801014de:	e8 7d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014e3:	83 c4 30             	add    $0x30,%esp
801014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e9:	c9                   	leave  
801014ea:	c3                   	ret    
801014eb:	90                   	nop
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014f0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	53                   	push   %ebx
801014f6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
80101503:	8b 75 08             	mov    0x8(%ebp),%esi
80101506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	0f 86 91 00 00 00    	jbe    801015a0 <ialloc+0xb0>
8010150f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101514:	eb 21                	jmp    80101537 <ialloc+0x47>
80101516:	8d 76 00             	lea    0x0(%esi),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101520:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101523:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101526:	57                   	push   %edi
80101527:	e8 b4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 c4 10             	add    $0x10,%esp
8010152f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101535:	76 69                	jbe    801015a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101537:	89 d8                	mov    %ebx,%eax
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	c1 e8 03             	shr    $0x3,%eax
8010153f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101545:	50                   	push   %eax
80101546:	56                   	push   %esi
80101547:	e8 84 eb ff ff       	call   801000d0 <bread>
8010154c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010154e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101550:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101553:	83 e0 07             	and    $0x7,%eax
80101556:	c1 e0 06             	shl    $0x6,%eax
80101559:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010155d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101561:	75 bd                	jne    80101520 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101563:	83 ec 04             	sub    $0x4,%esp
80101566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101569:	6a 40                	push   $0x40
8010156b:	6a 00                	push   $0x0
8010156d:	51                   	push   %ecx
8010156e:	e8 8d 30 00 00       	call   80104600 <memset>
      dip->type = type;
80101573:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101577:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010157a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010157d:	89 3c 24             	mov    %edi,(%esp)
80101580:	e8 1b 18 00 00       	call   80102da0 <log_write>
      brelse(bp);
80101585:	89 3c 24             	mov    %edi,(%esp)
80101588:	e8 53 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010158d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101590:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101593:	89 da                	mov    %ebx,%edx
80101595:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101597:	5b                   	pop    %ebx
80101598:	5e                   	pop    %esi
80101599:	5f                   	pop    %edi
8010159a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010159b:	e9 60 fc ff ff       	jmp    80101200 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015a0:	83 ec 0c             	sub    $0xc,%esp
801015a3:	68 54 72 10 80       	push   $0x80107254
801015a8:	e8 c3 ed ff ff       	call   80100370 <panic>
801015ad:	8d 76 00             	lea    0x0(%esi),%esi

801015b0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015be:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c1:	c1 e8 03             	shr    $0x3,%eax
801015c4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015ca:	50                   	push   %eax
801015cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ce:	e8 fd ea ff ff       	call   801000d0 <bread>
801015d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015dc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015df:	83 e0 07             	and    $0x7,%eax
801015e2:	c1 e0 06             	shl    $0x6,%eax
801015e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015f0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101603:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101607:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010160a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160d:	6a 34                	push   $0x34
8010160f:	53                   	push   %ebx
80101610:	50                   	push   %eax
80101611:	e8 9a 30 00 00       	call   801046b0 <memmove>
  log_write(bp);
80101616:	89 34 24             	mov    %esi,(%esp)
80101619:	e8 82 17 00 00       	call   80102da0 <log_write>
  brelse(bp);
8010161e:	89 75 08             	mov    %esi,0x8(%ebp)
80101621:	83 c4 10             	add    $0x10,%esp
}
80101624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101627:	5b                   	pop    %ebx
80101628:	5e                   	pop    %esi
80101629:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010162a:	e9 b1 eb ff ff       	jmp    801001e0 <brelse>
8010162f:	90                   	nop

80101630 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	83 ec 10             	sub    $0x10,%esp
80101637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010163a:	68 00 0a 11 80       	push   $0x80110a00
8010163f:	e8 8c 2d 00 00       	call   801043d0 <acquire>
  ip->ref++;
80101644:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101648:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010164f:	e8 5c 2f 00 00       	call   801045b0 <release>
  return ip;
}
80101654:	89 d8                	mov    %ebx,%eax
80101656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101659:	c9                   	leave  
8010165a:	c3                   	ret    
8010165b:	90                   	nop
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101668:	85 db                	test   %ebx,%ebx
8010166a:	0f 84 b4 00 00 00    	je     80101724 <ilock+0xc4>
80101670:	8b 43 08             	mov    0x8(%ebx),%eax
80101673:	85 c0                	test   %eax,%eax
80101675:	0f 8e a9 00 00 00    	jle    80101724 <ilock+0xc4>
    panic("ilock");

  acquiresleep(&ip->lock);
8010167b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	50                   	push   %eax
80101682:	e8 59 2c 00 00       	call   801042e0 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101687:	83 c4 10             	add    $0x10,%esp
8010168a:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
8010168e:	74 10                	je     801016a0 <ilock+0x40>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101690:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101693:	5b                   	pop    %ebx
80101694:	5e                   	pop    %esi
80101695:	5d                   	pop    %ebp
80101696:	c3                   	ret    
80101697:	89 f6                	mov    %esi,%esi
80101699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a0:	8b 43 04             	mov    0x4(%ebx),%eax
801016a3:	83 ec 08             	sub    $0x8,%esp
801016a6:	c1 e8 03             	shr    $0x3,%eax
801016a9:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016af:	50                   	push   %eax
801016b0:	ff 33                	pushl  (%ebx)
801016b2:	e8 19 ea ff ff       	call   801000d0 <bread>
801016b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016bc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bf:	83 e0 07             	and    $0x7,%eax
801016c2:	c1 e0 06             	shl    $0x6,%eax
801016c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016c9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016f1:	6a 34                	push   $0x34
801016f3:	50                   	push   %eax
801016f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016f7:	50                   	push   %eax
801016f8:	e8 b3 2f 00 00       	call   801046b0 <memmove>
    brelse(bp);
801016fd:	89 34 24             	mov    %esi,(%esp)
80101700:	e8 db ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101705:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
80101709:	83 c4 10             	add    $0x10,%esp
8010170c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101711:	0f 85 79 ff ff ff    	jne    80101690 <ilock+0x30>
      panic("ilock: no type");
80101717:	83 ec 0c             	sub    $0xc,%esp
8010171a:	68 6c 72 10 80       	push   $0x8010726c
8010171f:	e8 4c ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101724:	83 ec 0c             	sub    $0xc,%esp
80101727:	68 66 72 10 80       	push   $0x80107266
8010172c:	e8 3f ec ff ff       	call   80100370 <panic>
80101731:	eb 0d                	jmp    80101740 <iunlock>
80101733:	90                   	nop
80101734:	90                   	nop
80101735:	90                   	nop
80101736:	90                   	nop
80101737:	90                   	nop
80101738:	90                   	nop
80101739:	90                   	nop
8010173a:	90                   	nop
8010173b:	90                   	nop
8010173c:	90                   	nop
8010173d:	90                   	nop
8010173e:	90                   	nop
8010173f:	90                   	nop

80101740 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101748:	85 db                	test   %ebx,%ebx
8010174a:	74 28                	je     80101774 <iunlock+0x34>
8010174c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010174f:	83 ec 0c             	sub    $0xc,%esp
80101752:	56                   	push   %esi
80101753:	e8 28 2c 00 00       	call   80104380 <holdingsleep>
80101758:	83 c4 10             	add    $0x10,%esp
8010175b:	85 c0                	test   %eax,%eax
8010175d:	74 15                	je     80101774 <iunlock+0x34>
8010175f:	8b 43 08             	mov    0x8(%ebx),%eax
80101762:	85 c0                	test   %eax,%eax
80101764:	7e 0e                	jle    80101774 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101766:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101769:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010176c:	5b                   	pop    %ebx
8010176d:	5e                   	pop    %esi
8010176e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010176f:	e9 cc 2b 00 00       	jmp    80104340 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101774:	83 ec 0c             	sub    $0xc,%esp
80101777:	68 7b 72 10 80       	push   $0x8010727b
8010177c:	e8 ef eb ff ff       	call   80100370 <panic>
80101781:	eb 0d                	jmp    80101790 <iput>
80101783:	90                   	nop
80101784:	90                   	nop
80101785:	90                   	nop
80101786:	90                   	nop
80101787:	90                   	nop
80101788:	90                   	nop
80101789:	90                   	nop
8010178a:	90                   	nop
8010178b:	90                   	nop
8010178c:	90                   	nop
8010178d:	90                   	nop
8010178e:	90                   	nop
8010178f:	90                   	nop

80101790 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 28             	sub    $0x28,%esp
80101799:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010179c:	68 00 0a 11 80       	push   $0x80110a00
801017a1:	e8 2a 2c 00 00       	call   801043d0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017a6:	8b 46 08             	mov    0x8(%esi),%eax
801017a9:	83 c4 10             	add    $0x10,%esp
801017ac:	83 f8 01             	cmp    $0x1,%eax
801017af:	74 1f                	je     801017d0 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801017b1:	83 e8 01             	sub    $0x1,%eax
801017b4:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801017b7:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
801017be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017c1:	5b                   	pop    %ebx
801017c2:	5e                   	pop    %esi
801017c3:	5f                   	pop    %edi
801017c4:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
801017c5:	e9 e6 2d 00 00       	jmp    801045b0 <release>
801017ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017d0:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
801017d4:	74 db                	je     801017b1 <iput+0x21>
801017d6:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017db:	75 d4                	jne    801017b1 <iput+0x21>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
801017dd:	83 ec 0c             	sub    $0xc,%esp
801017e0:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801017e3:	8d be 8c 00 00 00    	lea    0x8c(%esi),%edi
801017e9:	68 00 0a 11 80       	push   $0x80110a00
801017ee:	e8 bd 2d 00 00       	call   801045b0 <release>
801017f3:	83 c4 10             	add    $0x10,%esp
801017f6:	eb 0f                	jmp    80101807 <iput+0x77>
801017f8:	90                   	nop
801017f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101800:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101803:	39 fb                	cmp    %edi,%ebx
80101805:	74 19                	je     80101820 <iput+0x90>
    if(ip->addrs[i]){
80101807:	8b 13                	mov    (%ebx),%edx
80101809:	85 d2                	test   %edx,%edx
8010180b:	74 f3                	je     80101800 <iput+0x70>
      bfree(ip->dev, ip->addrs[i]);
8010180d:	8b 06                	mov    (%esi),%eax
8010180f:	e8 cc fb ff ff       	call   801013e0 <bfree>
      ip->addrs[i] = 0;
80101814:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010181a:	eb e4                	jmp    80101800 <iput+0x70>
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101820:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101826:	85 c0                	test   %eax,%eax
80101828:	75 46                	jne    80101870 <iput+0xe0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010182a:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010182d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101834:	56                   	push   %esi
80101835:	e8 76 fd ff ff       	call   801015b0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
8010183a:	31 c0                	xor    %eax,%eax
8010183c:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
80101840:	89 34 24             	mov    %esi,(%esp)
80101843:	e8 68 fd ff ff       	call   801015b0 <iupdate>
    acquire(&icache.lock);
80101848:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010184f:	e8 7c 2b 00 00       	call   801043d0 <acquire>
    ip->flags = 0;
80101854:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010185b:	8b 46 08             	mov    0x8(%esi),%eax
8010185e:	83 c4 10             	add    $0x10,%esp
80101861:	e9 4b ff ff ff       	jmp    801017b1 <iput+0x21>
80101866:	8d 76 00             	lea    0x0(%esi),%esi
80101869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101870:	83 ec 08             	sub    $0x8,%esp
80101873:	50                   	push   %eax
80101874:	ff 36                	pushl  (%esi)
80101876:	e8 55 e8 ff ff       	call   801000d0 <bread>
8010187b:	83 c4 10             	add    $0x10,%esp
8010187e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101881:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101884:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
8010188a:	eb 0b                	jmp    80101897 <iput+0x107>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101890:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101893:	39 df                	cmp    %ebx,%edi
80101895:	74 0f                	je     801018a6 <iput+0x116>
      if(a[j])
80101897:	8b 13                	mov    (%ebx),%edx
80101899:	85 d2                	test   %edx,%edx
8010189b:	74 f3                	je     80101890 <iput+0x100>
        bfree(ip->dev, a[j]);
8010189d:	8b 06                	mov    (%esi),%eax
8010189f:	e8 3c fb ff ff       	call   801013e0 <bfree>
801018a4:	eb ea                	jmp    80101890 <iput+0x100>
    }
    brelse(bp);
801018a6:	83 ec 0c             	sub    $0xc,%esp
801018a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801018ac:	e8 2f e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018b1:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018b7:	8b 06                	mov    (%esi),%eax
801018b9:	e8 22 fb ff ff       	call   801013e0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018be:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018c5:	00 00 00 
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	e9 5a ff ff ff       	jmp    8010182a <iput+0x9a>

801018d0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	53                   	push   %ebx
801018d4:	83 ec 10             	sub    $0x10,%esp
801018d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018da:	53                   	push   %ebx
801018db:	e8 60 fe ff ff       	call   80101740 <iunlock>
  iput(ip);
801018e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018e3:	83 c4 10             	add    $0x10,%esp
}
801018e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018e9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018ea:	e9 a1 fe ff ff       	jmp    80101790 <iput>
801018ef:	90                   	nop

801018f0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	8b 55 08             	mov    0x8(%ebp),%edx
801018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018f9:	8b 0a                	mov    (%edx),%ecx
801018fb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101901:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101904:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101908:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010190b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010190f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101913:	8b 52 58             	mov    0x58(%edx),%edx
80101916:	89 50 10             	mov    %edx,0x10(%eax)
}
80101919:	5d                   	pop    %ebp
8010191a:	c3                   	ret    
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 1c             	sub    $0x1c,%esp
80101929:	8b 45 08             	mov    0x8(%ebp),%eax
8010192c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010192f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101932:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101937:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010193a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010193d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101940:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101943:	0f 84 a7 00 00 00    	je     801019f0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101949:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010194c:	8b 40 58             	mov    0x58(%eax),%eax
8010194f:	39 f0                	cmp    %esi,%eax
80101951:	0f 82 c1 00 00 00    	jb     80101a18 <readi+0xf8>
80101957:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010195a:	89 fa                	mov    %edi,%edx
8010195c:	01 f2                	add    %esi,%edx
8010195e:	0f 82 b4 00 00 00    	jb     80101a18 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101964:	89 c1                	mov    %eax,%ecx
80101966:	29 f1                	sub    %esi,%ecx
80101968:	39 d0                	cmp    %edx,%eax
8010196a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010196d:	31 ff                	xor    %edi,%edi
8010196f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101971:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101974:	74 6d                	je     801019e3 <readi+0xc3>
80101976:	8d 76 00             	lea    0x0(%esi),%esi
80101979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101980:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101983:	89 f2                	mov    %esi,%edx
80101985:	c1 ea 09             	shr    $0x9,%edx
80101988:	89 d8                	mov    %ebx,%eax
8010198a:	e8 41 f9 ff ff       	call   801012d0 <bmap>
8010198f:	83 ec 08             	sub    $0x8,%esp
80101992:	50                   	push   %eax
80101993:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101995:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010199a:	e8 31 e7 ff ff       	call   801000d0 <bread>
8010199f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019a4:	89 f1                	mov    %esi,%ecx
801019a6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019ac:	83 c4 0c             	add    $0xc,%esp
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019b2:	29 cb                	sub    %ecx,%ebx
801019b4:	29 f8                	sub    %edi,%eax
801019b6:	39 c3                	cmp    %eax,%ebx
801019b8:	0f 47 d8             	cmova  %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019bb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019bf:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c0:	01 df                	add    %ebx,%edi
801019c2:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019c4:	50                   	push   %eax
801019c5:	ff 75 e0             	pushl  -0x20(%ebp)
801019c8:	e8 e3 2c 00 00       	call   801046b0 <memmove>
    brelse(bp);
801019cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019d0:	89 14 24             	mov    %edx,(%esp)
801019d3:	e8 08 e8 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019db:	83 c4 10             	add    $0x10,%esp
801019de:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019e1:	77 9d                	ja     80101980 <readi+0x60>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019e9:	5b                   	pop    %ebx
801019ea:	5e                   	pop    %esi
801019eb:	5f                   	pop    %edi
801019ec:	5d                   	pop    %ebp
801019ed:	c3                   	ret    
801019ee:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019f0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019f4:	66 83 f8 09          	cmp    $0x9,%ax
801019f8:	77 1e                	ja     80101a18 <readi+0xf8>
801019fa:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a01:	85 c0                	test   %eax,%eax
80101a03:	74 13                	je     80101a18 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a05:	89 7d 10             	mov    %edi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0b:	5b                   	pop    %ebx
80101a0c:	5e                   	pop    %esi
80101a0d:	5f                   	pop    %edi
80101a0e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a0f:	ff e0                	jmp    *%eax
80101a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a1d:	eb c7                	jmp    801019e6 <readi+0xc6>
80101a1f:	90                   	nop

80101a20 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 1c             	sub    $0x1c,%esp
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a43:	0f 84 b7 00 00 00    	je     80101b00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a4f:	0f 82 eb 00 00 00    	jb     80101b40 <writei+0x120>
80101a55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a58:	89 f8                	mov    %edi,%eax
80101a5a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a5c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a61:	0f 87 d9 00 00 00    	ja     80101b40 <writei+0x120>
80101a67:	39 c6                	cmp    %eax,%esi
80101a69:	0f 87 d1 00 00 00    	ja     80101b40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a6f:	85 ff                	test   %edi,%edi
80101a71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a78:	74 78                	je     80101af2 <writei+0xd2>
80101a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a83:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a85:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a8a:	c1 ea 09             	shr    $0x9,%edx
80101a8d:	89 f8                	mov    %edi,%eax
80101a8f:	e8 3c f8 ff ff       	call   801012d0 <bmap>
80101a94:	83 ec 08             	sub    $0x8,%esp
80101a97:	50                   	push   %eax
80101a98:	ff 37                	pushl  (%edi)
80101a9a:	e8 31 e6 ff ff       	call   801000d0 <bread>
80101a9f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101aa4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101aa7:	89 f1                	mov    %esi,%ecx
80101aa9:	83 c4 0c             	add    $0xc,%esp
80101aac:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ab2:	29 cb                	sub    %ecx,%ebx
80101ab4:	39 c3                	cmp    %eax,%ebx
80101ab6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ab9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101abd:	53                   	push   %ebx
80101abe:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ac3:	50                   	push   %eax
80101ac4:	e8 e7 2b 00 00       	call   801046b0 <memmove>
    log_write(bp);
80101ac9:	89 3c 24             	mov    %edi,(%esp)
80101acc:	e8 cf 12 00 00       	call   80102da0 <log_write>
    brelse(bp);
80101ad1:	89 3c 24             	mov    %edi,(%esp)
80101ad4:	e8 07 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101adc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101adf:	83 c4 10             	add    $0x10,%esp
80101ae2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ae5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101ae8:	77 96                	ja     80101a80 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101aea:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aed:	3b 70 58             	cmp    0x58(%eax),%esi
80101af0:	77 36                	ja     80101b28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101af8:	5b                   	pop    %ebx
80101af9:	5e                   	pop    %esi
80101afa:	5f                   	pop    %edi
80101afb:	5d                   	pop    %ebp
80101afc:	c3                   	ret    
80101afd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b04:	66 83 f8 09          	cmp    $0x9,%ax
80101b08:	77 36                	ja     80101b40 <writei+0x120>
80101b0a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b11:	85 c0                	test   %eax,%eax
80101b13:	74 2b                	je     80101b40 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b15:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b1b:	5b                   	pop    %ebx
80101b1c:	5e                   	pop    %esi
80101b1d:	5f                   	pop    %edi
80101b1e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b1f:	ff e0                	jmp    *%eax
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b2b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b31:	50                   	push   %eax
80101b32:	e8 79 fa ff ff       	call   801015b0 <iupdate>
80101b37:	83 c4 10             	add    $0x10,%esp
80101b3a:	eb b6                	jmp    80101af2 <writei+0xd2>
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b45:	eb ae                	jmp    80101af5 <writei+0xd5>
80101b47:	89 f6                	mov    %esi,%esi
80101b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b56:	6a 0e                	push   $0xe
80101b58:	ff 75 0c             	pushl  0xc(%ebp)
80101b5b:	ff 75 08             	pushl  0x8(%ebp)
80101b5e:	e8 cd 2b 00 00       	call   80104730 <strncmp>
}
80101b63:	c9                   	leave  
80101b64:	c3                   	ret    
80101b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	57                   	push   %edi
80101b74:	56                   	push   %esi
80101b75:	53                   	push   %ebx
80101b76:	83 ec 1c             	sub    $0x1c,%esp
80101b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b81:	0f 85 80 00 00 00    	jne    80101c07 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b87:	8b 53 58             	mov    0x58(%ebx),%edx
80101b8a:	31 ff                	xor    %edi,%edi
80101b8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b8f:	85 d2                	test   %edx,%edx
80101b91:	75 0d                	jne    80101ba0 <dirlookup+0x30>
80101b93:	eb 5b                	jmp    80101bf0 <dirlookup+0x80>
80101b95:	8d 76 00             	lea    0x0(%esi),%esi
80101b98:	83 c7 10             	add    $0x10,%edi
80101b9b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101b9e:	76 50                	jbe    80101bf0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ba0:	6a 10                	push   $0x10
80101ba2:	57                   	push   %edi
80101ba3:	56                   	push   %esi
80101ba4:	53                   	push   %ebx
80101ba5:	e8 76 fd ff ff       	call   80101920 <readi>
80101baa:	83 c4 10             	add    $0x10,%esp
80101bad:	83 f8 10             	cmp    $0x10,%eax
80101bb0:	75 48                	jne    80101bfa <dirlookup+0x8a>
      panic("dirlink read");
    if(de.inum == 0)
80101bb2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bb7:	74 df                	je     80101b98 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bb9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bbc:	83 ec 04             	sub    $0x4,%esp
80101bbf:	6a 0e                	push   $0xe
80101bc1:	50                   	push   %eax
80101bc2:	ff 75 0c             	pushl  0xc(%ebp)
80101bc5:	e8 66 2b 00 00       	call   80104730 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	85 c0                	test   %eax,%eax
80101bcf:	75 c7                	jne    80101b98 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bd1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bd4:	85 c0                	test   %eax,%eax
80101bd6:	74 05                	je     80101bdd <dirlookup+0x6d>
        *poff = off;
80101bd8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bdb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bdd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101be1:	8b 03                	mov    (%ebx),%eax
80101be3:	e8 18 f6 ff ff       	call   80101200 <iget>
    }
  }

  return 0;
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
80101bef:	c3                   	ret    
80101bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101bf3:	31 c0                	xor    %eax,%eax
}
80101bf5:	5b                   	pop    %ebx
80101bf6:	5e                   	pop    %esi
80101bf7:	5f                   	pop    %edi
80101bf8:	5d                   	pop    %ebp
80101bf9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101bfa:	83 ec 0c             	sub    $0xc,%esp
80101bfd:	68 95 72 10 80       	push   $0x80107295
80101c02:	e8 69 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c07:	83 ec 0c             	sub    $0xc,%esp
80101c0a:	68 83 72 10 80       	push   $0x80107283
80101c0f:	e8 5c e7 ff ff       	call   80100370 <panic>
80101c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	89 cf                	mov    %ecx,%edi
80101c28:	89 c3                	mov    %eax,%ebx
80101c2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c2d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c33:	0f 84 53 01 00 00    	je     80101d8c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c3f:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c42:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c45:	68 00 0a 11 80       	push   $0x80110a00
80101c4a:	e8 81 27 00 00       	call   801043d0 <acquire>
  ip->ref++;
80101c4f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c53:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c5a:	e8 51 29 00 00       	call   801045b0 <release>
80101c5f:	83 c4 10             	add    $0x10,%esp
80101c62:	eb 07                	jmp    80101c6b <namex+0x4b>
80101c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c68:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c6b:	0f b6 03             	movzbl (%ebx),%eax
80101c6e:	3c 2f                	cmp    $0x2f,%al
80101c70:	74 f6                	je     80101c68 <namex+0x48>
    path++;
  if(*path == 0)
80101c72:	84 c0                	test   %al,%al
80101c74:	0f 84 e3 00 00 00    	je     80101d5d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c7a:	0f b6 03             	movzbl (%ebx),%eax
80101c7d:	89 da                	mov    %ebx,%edx
80101c7f:	84 c0                	test   %al,%al
80101c81:	0f 84 ac 00 00 00    	je     80101d33 <namex+0x113>
80101c87:	3c 2f                	cmp    $0x2f,%al
80101c89:	75 09                	jne    80101c94 <namex+0x74>
80101c8b:	e9 a3 00 00 00       	jmp    80101d33 <namex+0x113>
80101c90:	84 c0                	test   %al,%al
80101c92:	74 0a                	je     80101c9e <namex+0x7e>
    path++;
80101c94:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c97:	0f b6 02             	movzbl (%edx),%eax
80101c9a:	3c 2f                	cmp    $0x2f,%al
80101c9c:	75 f2                	jne    80101c90 <namex+0x70>
80101c9e:	89 d1                	mov    %edx,%ecx
80101ca0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ca2:	83 f9 0d             	cmp    $0xd,%ecx
80101ca5:	0f 8e 8d 00 00 00    	jle    80101d38 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cab:	83 ec 04             	sub    $0x4,%esp
80101cae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cb1:	6a 0e                	push   $0xe
80101cb3:	53                   	push   %ebx
80101cb4:	57                   	push   %edi
80101cb5:	e8 f6 29 00 00       	call   801046b0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cbd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cc0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cc5:	75 11                	jne    80101cd8 <namex+0xb8>
80101cc7:	89 f6                	mov    %esi,%esi
80101cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cd6:	74 f8                	je     80101cd0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cd8:	83 ec 0c             	sub    $0xc,%esp
80101cdb:	56                   	push   %esi
80101cdc:	e8 7f f9 ff ff       	call   80101660 <ilock>
    if(ip->type != T_DIR){
80101ce1:	83 c4 10             	add    $0x10,%esp
80101ce4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ce9:	0f 85 7f 00 00 00    	jne    80101d6e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101cef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101cf2:	85 d2                	test   %edx,%edx
80101cf4:	74 09                	je     80101cff <namex+0xdf>
80101cf6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101cf9:	0f 84 a3 00 00 00    	je     80101da2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101cff:	83 ec 04             	sub    $0x4,%esp
80101d02:	6a 00                	push   $0x0
80101d04:	57                   	push   %edi
80101d05:	56                   	push   %esi
80101d06:	e8 65 fe ff ff       	call   80101b70 <dirlookup>
80101d0b:	83 c4 10             	add    $0x10,%esp
80101d0e:	85 c0                	test   %eax,%eax
80101d10:	74 5c                	je     80101d6e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d12:	83 ec 0c             	sub    $0xc,%esp
80101d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d18:	56                   	push   %esi
80101d19:	e8 22 fa ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d1e:	89 34 24             	mov    %esi,(%esp)
80101d21:	e8 6a fa ff ff       	call   80101790 <iput>
80101d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d29:	83 c4 10             	add    $0x10,%esp
80101d2c:	89 c6                	mov    %eax,%esi
80101d2e:	e9 38 ff ff ff       	jmp    80101c6b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d33:	31 c9                	xor    %ecx,%ecx
80101d35:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d38:	83 ec 04             	sub    $0x4,%esp
80101d3b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d3e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d41:	51                   	push   %ecx
80101d42:	53                   	push   %ebx
80101d43:	57                   	push   %edi
80101d44:	e8 67 29 00 00       	call   801046b0 <memmove>
    name[len] = 0;
80101d49:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d4f:	83 c4 10             	add    $0x10,%esp
80101d52:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d56:	89 d3                	mov    %edx,%ebx
80101d58:	e9 65 ff ff ff       	jmp    80101cc2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d60:	85 c0                	test   %eax,%eax
80101d62:	75 54                	jne    80101db8 <namex+0x198>
80101d64:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d69:	5b                   	pop    %ebx
80101d6a:	5e                   	pop    %esi
80101d6b:	5f                   	pop    %edi
80101d6c:	5d                   	pop    %ebp
80101d6d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d6e:	83 ec 0c             	sub    $0xc,%esp
80101d71:	56                   	push   %esi
80101d72:	e8 c9 f9 ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 11 fa ff ff       	call   80101790 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d7f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d85:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d87:	5b                   	pop    %ebx
80101d88:	5e                   	pop    %esi
80101d89:	5f                   	pop    %edi
80101d8a:	5d                   	pop    %ebp
80101d8b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101d8c:	ba 01 00 00 00       	mov    $0x1,%edx
80101d91:	b8 01 00 00 00       	mov    $0x1,%eax
80101d96:	e8 65 f4 ff ff       	call   80101200 <iget>
80101d9b:	89 c6                	mov    %eax,%esi
80101d9d:	e9 c9 fe ff ff       	jmp    80101c6b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101da2:	83 ec 0c             	sub    $0xc,%esp
80101da5:	56                   	push   %esi
80101da6:	e8 95 f9 ff ff       	call   80101740 <iunlock>
      return ip;
80101dab:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101db1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db3:	5b                   	pop    %ebx
80101db4:	5e                   	pop    %esi
80101db5:	5f                   	pop    %edi
80101db6:	5d                   	pop    %ebp
80101db7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101db8:	83 ec 0c             	sub    $0xc,%esp
80101dbb:	56                   	push   %esi
80101dbc:	e8 cf f9 ff ff       	call   80101790 <iput>
    return 0;
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	31 c0                	xor    %eax,%eax
80101dc6:	eb 9e                	jmp    80101d66 <namex+0x146>
80101dc8:	90                   	nop
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dd0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 20             	sub    $0x20,%esp
80101dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ddc:	6a 00                	push   $0x0
80101dde:	ff 75 0c             	pushl  0xc(%ebp)
80101de1:	53                   	push   %ebx
80101de2:	e8 89 fd ff ff       	call   80101b70 <dirlookup>
80101de7:	83 c4 10             	add    $0x10,%esp
80101dea:	85 c0                	test   %eax,%eax
80101dec:	75 67                	jne    80101e55 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dee:	8b 7b 58             	mov    0x58(%ebx),%edi
80101df1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101df4:	85 ff                	test   %edi,%edi
80101df6:	74 29                	je     80101e21 <dirlink+0x51>
80101df8:	31 ff                	xor    %edi,%edi
80101dfa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dfd:	eb 09                	jmp    80101e08 <dirlink+0x38>
80101dff:	90                   	nop
80101e00:	83 c7 10             	add    $0x10,%edi
80101e03:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e06:	76 19                	jbe    80101e21 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e08:	6a 10                	push   $0x10
80101e0a:	57                   	push   %edi
80101e0b:	56                   	push   %esi
80101e0c:	53                   	push   %ebx
80101e0d:	e8 0e fb ff ff       	call   80101920 <readi>
80101e12:	83 c4 10             	add    $0x10,%esp
80101e15:	83 f8 10             	cmp    $0x10,%eax
80101e18:	75 4e                	jne    80101e68 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e1f:	75 df                	jne    80101e00 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e24:	83 ec 04             	sub    $0x4,%esp
80101e27:	6a 0e                	push   $0xe
80101e29:	ff 75 0c             	pushl  0xc(%ebp)
80101e2c:	50                   	push   %eax
80101e2d:	e8 6e 29 00 00       	call   801047a0 <strncpy>
  de.inum = inum;
80101e32:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e35:	6a 10                	push   $0x10
80101e37:	57                   	push   %edi
80101e38:	56                   	push   %esi
80101e39:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e3e:	e8 dd fb ff ff       	call   80101a20 <writei>
80101e43:	83 c4 20             	add    $0x20,%esp
80101e46:	83 f8 10             	cmp    $0x10,%eax
80101e49:	75 2a                	jne    80101e75 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e4b:	31 c0                	xor    %eax,%eax
}
80101e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e50:	5b                   	pop    %ebx
80101e51:	5e                   	pop    %esi
80101e52:	5f                   	pop    %edi
80101e53:	5d                   	pop    %ebp
80101e54:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e55:	83 ec 0c             	sub    $0xc,%esp
80101e58:	50                   	push   %eax
80101e59:	e8 32 f9 ff ff       	call   80101790 <iput>
    return -1;
80101e5e:	83 c4 10             	add    $0x10,%esp
80101e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e66:	eb e5                	jmp    80101e4d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	68 95 72 10 80       	push   $0x80107295
80101e70:	e8 fb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	68 62 78 10 80       	push   $0x80107862
80101e7d:	e8 ee e4 ff ff       	call   80100370 <panic>
80101e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e90 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101e90:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e91:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101e93:	89 e5                	mov    %esp,%ebp
80101e95:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e98:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e9e:	e8 7d fd ff ff       	call   80101c20 <namex>
}
80101ea3:	c9                   	leave  
80101ea4:	c3                   	ret    
80101ea5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101eb0:	55                   	push   %ebp
  return namex(path, 1, name);
80101eb1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101eb6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ebb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ebe:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101ebf:	e9 5c fd ff ff       	jmp    80101c20 <namex>
80101ec4:	66 90                	xchg   %ax,%ax
80101ec6:	66 90                	xchg   %ax,%ax
80101ec8:	66 90                	xchg   %ax,%ax
80101eca:	66 90                	xchg   %ax,%ax
80101ecc:	66 90                	xchg   %ax,%ax
80101ece:	66 90                	xchg   %ax,%ax

80101ed0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ed0:	55                   	push   %ebp
  if(b == 0)
80101ed1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ed3:	89 e5                	mov    %esp,%ebp
80101ed5:	56                   	push   %esi
80101ed6:	53                   	push   %ebx
  if(b == 0)
80101ed7:	0f 84 ad 00 00 00    	je     80101f8a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101edd:	8b 58 08             	mov    0x8(%eax),%ebx
80101ee0:	89 c1                	mov    %eax,%ecx
80101ee2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ee8:	0f 87 8f 00 00 00    	ja     80101f7d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101eee:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ef3:	90                   	nop
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ef9:	83 e0 c0             	and    $0xffffffc0,%eax
80101efc:	3c 40                	cmp    $0x40,%al
80101efe:	75 f8                	jne    80101ef8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f00:	31 f6                	xor    %esi,%esi
80101f02:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f07:	89 f0                	mov    %esi,%eax
80101f09:	ee                   	out    %al,(%dx)
80101f0a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f14:	ee                   	out    %al,(%dx)
80101f15:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f1a:	89 d8                	mov    %ebx,%eax
80101f1c:	ee                   	out    %al,(%dx)
80101f1d:	89 d8                	mov    %ebx,%eax
80101f1f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f24:	c1 f8 08             	sar    $0x8,%eax
80101f27:	ee                   	out    %al,(%dx)
80101f28:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f2d:	89 f0                	mov    %esi,%eax
80101f2f:	ee                   	out    %al,(%dx)
80101f30:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f34:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f39:	83 e0 01             	and    $0x1,%eax
80101f3c:	c1 e0 04             	shl    $0x4,%eax
80101f3f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f42:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f43:	f6 01 04             	testb  $0x4,(%ecx)
80101f46:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f4b:	75 13                	jne    80101f60 <idestart+0x90>
80101f4d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f52:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f56:	5b                   	pop    %ebx
80101f57:	5e                   	pop    %esi
80101f58:	5d                   	pop    %ebp
80101f59:	c3                   	ret    
80101f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f60:	b8 30 00 00 00       	mov    $0x30,%eax
80101f65:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f66:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f6b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f6e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f73:	fc                   	cld    
80101f74:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f79:	5b                   	pop    %ebx
80101f7a:	5e                   	pop    %esi
80101f7b:	5d                   	pop    %ebp
80101f7c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f7d:	83 ec 0c             	sub    $0xc,%esp
80101f80:	68 00 73 10 80       	push   $0x80107300
80101f85:	e8 e6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f8a:	83 ec 0c             	sub    $0xc,%esp
80101f8d:	68 f7 72 10 80       	push   $0x801072f7
80101f92:	e8 d9 e3 ff ff       	call   80100370 <panic>
80101f97:	89 f6                	mov    %esi,%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fa6:	68 12 73 10 80       	push   $0x80107312
80101fab:	68 80 a5 10 80       	push   $0x8010a580
80101fb0:	e8 fb 23 00 00       	call   801043b0 <initlock>
  picenable(IRQ_IDE);
80101fb5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101fbc:	e8 cf 12 00 00       	call   80103290 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fc1:	58                   	pop    %eax
80101fc2:	a1 80 2d 11 80       	mov    0x80112d80,%eax
80101fc7:	5a                   	pop    %edx
80101fc8:	83 e8 01             	sub    $0x1,%eax
80101fcb:	50                   	push   %eax
80101fcc:	6a 0e                	push   $0xe
80101fce:	e8 bd 02 00 00       	call   80102290 <ioapicenable>
80101fd3:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fd6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fdb:	90                   	nop
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fe0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fe1:	83 e0 c0             	and    $0xffffffc0,%eax
80101fe4:	3c 40                	cmp    $0x40,%al
80101fe6:	75 f8                	jne    80101fe0 <ideinit+0x40>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fe8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101ff2:	ee                   	out    %al,(%dx)
80101ff3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ff8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ffd:	eb 06                	jmp    80102005 <ideinit+0x65>
80101fff:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102000:	83 e9 01             	sub    $0x1,%ecx
80102003:	74 0f                	je     80102014 <ideinit+0x74>
80102005:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102006:	84 c0                	test   %al,%al
80102008:	74 f6                	je     80102000 <ideinit+0x60>
      havedisk1 = 1;
8010200a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102011:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102014:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102019:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010201e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010201f:	c9                   	leave  
80102020:	c3                   	ret    
80102021:	eb 0d                	jmp    80102030 <ideintr>
80102023:	90                   	nop
80102024:	90                   	nop
80102025:	90                   	nop
80102026:	90                   	nop
80102027:	90                   	nop
80102028:	90                   	nop
80102029:	90                   	nop
8010202a:	90                   	nop
8010202b:	90                   	nop
8010202c:	90                   	nop
8010202d:	90                   	nop
8010202e:	90                   	nop
8010202f:	90                   	nop

80102030 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102039:	68 80 a5 10 80       	push   $0x8010a580
8010203e:	e8 8d 23 00 00       	call   801043d0 <acquire>
  if((b = idequeue) == 0){
80102043:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102049:	83 c4 10             	add    $0x10,%esp
8010204c:	85 db                	test   %ebx,%ebx
8010204e:	74 34                	je     80102084 <ideintr+0x54>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102050:	8b 43 58             	mov    0x58(%ebx),%eax
80102053:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102058:	8b 33                	mov    (%ebx),%esi
8010205a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102060:	74 3e                	je     801020a0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102062:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102065:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102068:	83 ce 02             	or     $0x2,%esi
8010206b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010206d:	53                   	push   %ebx
8010206e:	e8 7d 20 00 00       	call   801040f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102073:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102078:	83 c4 10             	add    $0x10,%esp
8010207b:	85 c0                	test   %eax,%eax
8010207d:	74 05                	je     80102084 <ideintr+0x54>
    idestart(idequeue);
8010207f:	e8 4c fe ff ff       	call   80101ed0 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
80102084:	83 ec 0c             	sub    $0xc,%esp
80102087:	68 80 a5 10 80       	push   $0x8010a580
8010208c:	e8 1f 25 00 00       	call   801045b0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102094:	5b                   	pop    %ebx
80102095:	5e                   	pop    %esi
80102096:	5f                   	pop    %edi
80102097:	5d                   	pop    %ebp
80102098:	c3                   	ret    
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020a5:	8d 76 00             	lea    0x0(%esi),%esi
801020a8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a9:	89 c1                	mov    %eax,%ecx
801020ab:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ae:	80 f9 40             	cmp    $0x40,%cl
801020b1:	75 f5                	jne    801020a8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020b3:	a8 21                	test   $0x21,%al
801020b5:	75 ab                	jne    80102062 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020b7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020ba:	b9 80 00 00 00       	mov    $0x80,%ecx
801020bf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020c4:	fc                   	cld    
801020c5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020c7:	8b 33                	mov    (%ebx),%esi
801020c9:	eb 97                	jmp    80102062 <ideintr+0x32>
801020cb:	90                   	nop
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	53                   	push   %ebx
801020d4:	83 ec 10             	sub    $0x10,%esp
801020d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020da:	8d 43 0c             	lea    0xc(%ebx),%eax
801020dd:	50                   	push   %eax
801020de:	e8 9d 22 00 00       	call   80104380 <holdingsleep>
801020e3:	83 c4 10             	add    $0x10,%esp
801020e6:	85 c0                	test   %eax,%eax
801020e8:	0f 84 ad 00 00 00    	je     8010219b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020ee:	8b 03                	mov    (%ebx),%eax
801020f0:	83 e0 06             	and    $0x6,%eax
801020f3:	83 f8 02             	cmp    $0x2,%eax
801020f6:	0f 84 b9 00 00 00    	je     801021b5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801020fc:	8b 53 04             	mov    0x4(%ebx),%edx
801020ff:	85 d2                	test   %edx,%edx
80102101:	74 0d                	je     80102110 <iderw+0x40>
80102103:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102108:	85 c0                	test   %eax,%eax
8010210a:	0f 84 98 00 00 00    	je     801021a8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	68 80 a5 10 80       	push   $0x8010a580
80102118:	e8 b3 22 00 00       	call   801043d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010211d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102123:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102126:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010212d:	85 d2                	test   %edx,%edx
8010212f:	75 09                	jne    8010213a <iderw+0x6a>
80102131:	eb 58                	jmp    8010218b <iderw+0xbb>
80102133:	90                   	nop
80102134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102138:	89 c2                	mov    %eax,%edx
8010213a:	8b 42 58             	mov    0x58(%edx),%eax
8010213d:	85 c0                	test   %eax,%eax
8010213f:	75 f7                	jne    80102138 <iderw+0x68>
80102141:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102144:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102146:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010214c:	74 44                	je     80102192 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	74 23                	je     8010217b <iderw+0xab>
80102158:	90                   	nop
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102160:	83 ec 08             	sub    $0x8,%esp
80102163:	68 80 a5 10 80       	push   $0x8010a580
80102168:	53                   	push   %ebx
80102169:	e8 b2 1c 00 00       	call   80103e20 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 c4 10             	add    $0x10,%esp
80102173:	83 e0 06             	and    $0x6,%eax
80102176:	83 f8 02             	cmp    $0x2,%eax
80102179:	75 e5                	jne    80102160 <iderw+0x90>
    sleep(b, &idelock);
  }

  release(&idelock);
8010217b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102185:	c9                   	leave  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102186:	e9 25 24 00 00       	jmp    801045b0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102190:	eb b2                	jmp    80102144 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102192:	89 d8                	mov    %ebx,%eax
80102194:	e8 37 fd ff ff       	call   80101ed0 <idestart>
80102199:	eb b3                	jmp    8010214e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010219b:	83 ec 0c             	sub    $0xc,%esp
8010219e:	68 16 73 10 80       	push   $0x80107316
801021a3:	e8 c8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 41 73 10 80       	push   $0x80107341
801021b0:	e8 bb e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 2c 73 10 80       	push   $0x8010732c
801021bd:	e8 ae e1 ff ff       	call   80100370 <panic>
801021c2:	66 90                	xchg   %ax,%ax
801021c4:	66 90                	xchg   %ax,%ax
801021c6:	66 90                	xchg   %ax,%ax
801021c8:	66 90                	xchg   %ax,%ax
801021ca:	66 90                	xchg   %ax,%ax
801021cc:	66 90                	xchg   %ax,%ax
801021ce:	66 90                	xchg   %ax,%ax

801021d0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021d0:	a1 84 27 11 80       	mov    0x80112784,%eax
801021d5:	85 c0                	test   %eax,%eax
801021d7:	0f 84 a8 00 00 00    	je     80102285 <ioapicinit+0xb5>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021dd:	55                   	push   %ebp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021de:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801021e5:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021e8:	89 e5                	mov    %esp,%ebp
801021ea:	56                   	push   %esi
801021eb:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ec:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021f3:	00 00 00 
  return ioapic->data;
801021f6:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801021fc:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ff:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102205:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010220b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102212:	89 f0                	mov    %esi,%eax
80102214:	c1 e8 10             	shr    $0x10,%eax
80102217:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010221a:	8b 41 10             	mov    0x10(%ecx),%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010221d:	c1 e8 18             	shr    $0x18,%eax
80102220:	39 d0                	cmp    %edx,%eax
80102222:	74 16                	je     8010223a <ioapicinit+0x6a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102224:	83 ec 0c             	sub    $0xc,%esp
80102227:	68 60 73 10 80       	push   $0x80107360
8010222c:	e8 2f e4 ff ff       	call   80100660 <cprintf>
80102231:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102237:	83 c4 10             	add    $0x10,%esp
8010223a:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010223d:	ba 10 00 00 00       	mov    $0x10,%edx
80102242:	b8 20 00 00 00       	mov    $0x20,%eax
80102247:	89 f6                	mov    %esi,%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102250:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102252:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102258:	89 c3                	mov    %eax,%ebx
8010225a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102260:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102263:	89 59 10             	mov    %ebx,0x10(%ecx)
80102266:	8d 5a 01             	lea    0x1(%edx),%ebx
80102269:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102270:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102276:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227d:	75 d1                	jne    80102250 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010227f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102282:	5b                   	pop    %ebx
80102283:	5e                   	pop    %esi
80102284:	5d                   	pop    %ebp
80102285:	f3 c3                	repz ret 
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102290:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102296:	55                   	push   %ebp
80102297:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102299:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
8010229b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010229e:	74 2b                	je     801022cb <ioapicenable+0x3b>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a0:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022a6:	8d 50 20             	lea    0x20(%eax),%edx
801022a9:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ad:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022af:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022b8:	89 51 10             	mov    %edx,0x10(%ecx)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022bb:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022be:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022c0:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c5:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c8:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022cb:	5d                   	pop    %ebp
801022cc:	c3                   	ret    
801022cd:	66 90                	xchg   %ax,%ax
801022cf:	90                   	nop

801022d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 04             	sub    $0x4,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022e0:	75 70                	jne    80102352 <kfree+0x82>
801022e2:	81 fb 28 59 11 80    	cmp    $0x80115928,%ebx
801022e8:	72 68                	jb     80102352 <kfree+0x82>
801022ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022f5:	77 5b                	ja     80102352 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022f7:	83 ec 04             	sub    $0x4,%esp
801022fa:	68 00 10 00 00       	push   $0x1000
801022ff:	6a 01                	push   $0x1
80102301:	53                   	push   %ebx
80102302:	e8 f9 22 00 00       	call   80104600 <memset>

  if(kmem.use_lock)
80102307:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 d2                	test   %edx,%edx
80102312:	75 2c                	jne    80102340 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102314:	a1 98 26 11 80       	mov    0x80112698,%eax
80102319:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010231b:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102320:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102326:	85 c0                	test   %eax,%eax
80102328:	75 06                	jne    80102330 <kfree+0x60>
    release(&kmem.lock);
}
8010232a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010232d:	c9                   	leave  
8010232e:	c3                   	ret    
8010232f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102330:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010233b:	e9 70 22 00 00       	jmp    801045b0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 60 26 11 80       	push   $0x80112660
80102348:	e8 83 20 00 00       	call   801043d0 <acquire>
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	eb c2                	jmp    80102314 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102352:	83 ec 0c             	sub    $0xc,%esp
80102355:	68 92 73 10 80       	push   $0x80107392
8010235a:	e8 11 e0 ff ff       	call   80100370 <panic>
8010235f:	90                   	nop

80102360 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	56                   	push   %esi
80102364:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102365:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102368:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010236b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102371:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102377:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010237d:	39 de                	cmp    %ebx,%esi
8010237f:	72 23                	jb     801023a4 <freerange+0x44>
80102381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102388:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010238e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102391:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102397:	50                   	push   %eax
80102398:	e8 33 ff ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	39 f3                	cmp    %esi,%ebx
801023a2:	76 e4                	jbe    80102388 <freerange+0x28>
    kfree(p);
}
801023a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a7:	5b                   	pop    %ebx
801023a8:	5e                   	pop    %esi
801023a9:	5d                   	pop    %ebp
801023aa:	c3                   	ret    
801023ab:	90                   	nop
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023b0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023b8:	83 ec 08             	sub    $0x8,%esp
801023bb:	68 98 73 10 80       	push   $0x80107398
801023c0:	68 60 26 11 80       	push   $0x80112660
801023c5:	e8 e6 1f 00 00       	call   801043b0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023cd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023d0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801023d7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ec:	39 de                	cmp    %ebx,%esi
801023ee:	72 1c                	jb     8010240c <kinit1+0x5c>
    kfree(p);
801023f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023f6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023ff:	50                   	push   %eax
80102400:	e8 cb fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102405:	83 c4 10             	add    $0x10,%esp
80102408:	39 de                	cmp    %ebx,%esi
8010240a:	73 e4                	jae    801023f0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010240c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010240f:	5b                   	pop    %ebx
80102410:	5e                   	pop    %esi
80102411:	5d                   	pop    %ebp
80102412:	c3                   	ret    
80102413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102425:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010242b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102431:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102437:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243d:	39 de                	cmp    %ebx,%esi
8010243f:	72 23                	jb     80102464 <kinit2+0x44>
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102448:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010244e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102451:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102457:	50                   	push   %eax
80102458:	e8 73 fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 e4                	jae    80102448 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102464:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010246b:	00 00 00 
}
8010246e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102487:	a1 94 26 11 80       	mov    0x80112694,%eax
8010248c:	85 c0                	test   %eax,%eax
8010248e:	75 30                	jne    801024c0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102490:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102496:	85 db                	test   %ebx,%ebx
80102498:	74 1c                	je     801024b6 <kalloc+0x36>
    kmem.freelist = r->next;
8010249a:	8b 13                	mov    (%ebx),%edx
8010249c:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801024a2:	85 c0                	test   %eax,%eax
801024a4:	74 10                	je     801024b6 <kalloc+0x36>
    release(&kmem.lock);
801024a6:	83 ec 0c             	sub    $0xc,%esp
801024a9:	68 60 26 11 80       	push   $0x80112660
801024ae:	e8 fd 20 00 00       	call   801045b0 <release>
801024b3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024b6:	89 d8                	mov    %ebx,%eax
801024b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024bb:	c9                   	leave  
801024bc:	c3                   	ret    
801024bd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 60 26 11 80       	push   $0x80112660
801024c8:	e8 03 1f 00 00       	call   801043d0 <acquire>
  r = kmem.freelist;
801024cd:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	a1 94 26 11 80       	mov    0x80112694,%eax
801024db:	85 db                	test   %ebx,%ebx
801024dd:	75 bb                	jne    8010249a <kalloc+0x1a>
801024df:	eb c1                	jmp    801024a2 <kalloc+0x22>
801024e1:	66 90                	xchg   %ax,%ax
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024f0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f1:	ba 64 00 00 00       	mov    $0x64,%edx
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f9:	a8 01                	test   $0x1,%al
801024fb:	0f 84 af 00 00 00    	je     801025b0 <kbdgetc+0xc0>
80102501:	ba 60 00 00 00       	mov    $0x60,%edx
80102506:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102507:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010250a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102510:	74 7e                	je     80102590 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102512:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010251a:	79 24                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010251c:	f6 c1 40             	test   $0x40,%cl
8010251f:	75 05                	jne    80102526 <kbdgetc+0x36>
80102521:	89 c2                	mov    %eax,%edx
80102523:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102526:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
8010252d:	83 c8 40             	or     $0x40,%eax
80102530:	0f b6 c0             	movzbl %al,%eax
80102533:	f7 d0                	not    %eax
80102535:	21 c8                	and    %ecx,%eax
80102537:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010253e:	5d                   	pop    %ebp
8010253f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102540:	f6 c1 40             	test   $0x40,%cl
80102543:	74 09                	je     8010254e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102545:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102548:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010254e:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
80102555:	09 c1                	or     %eax,%ecx
80102557:	0f b6 82 c0 73 10 80 	movzbl -0x7fef8c40(%edx),%eax
8010255e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102560:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102562:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102568:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010256b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010256e:	8b 04 85 a0 73 10 80 	mov    -0x7fef8c60(,%eax,4),%eax
80102575:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102579:	74 c3                	je     8010253e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010257b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010257e:	83 fa 19             	cmp    $0x19,%edx
80102581:	77 1d                	ja     801025a0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102583:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102586:	5d                   	pop    %ebp
80102587:	c3                   	ret    
80102588:	90                   	nop
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102590:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102592:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102599:	5d                   	pop    %ebp
8010259a:	c3                   	ret    
8010259b:	90                   	nop
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025a3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025a6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025a7:	83 f9 19             	cmp    $0x19,%ecx
801025aa:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b5:	5d                   	pop    %ebp
801025b6:	c3                   	ret    
801025b7:	89 f6                	mov    %esi,%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025c0 <kbdintr>:

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025c6:	68 f0 24 10 80       	push   $0x801024f0
801025cb:	e8 20 e2 ff ff       	call   801007f0 <consoleintr>
}
801025d0:	83 c4 10             	add    $0x10,%esp
801025d3:	c9                   	leave  
801025d4:	c3                   	ret    
801025d5:	66 90                	xchg   %ax,%ax
801025d7:	66 90                	xchg   %ax,%ax
801025d9:	66 90                	xchg   %ax,%ax
801025db:	66 90                	xchg   %ax,%ax
801025dd:	66 90                	xchg   %ax,%ax
801025df:	90                   	nop

801025e0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801025e0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
801025e5:	55                   	push   %ebp
801025e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025e8:	85 c0                	test   %eax,%eax
801025ea:	0f 84 c8 00 00 00    	je     801026b8 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025fa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102604:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102607:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102611:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102614:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102617:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010261e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102621:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102624:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010262b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102631:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102638:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010263e:	8b 50 30             	mov    0x30(%eax),%edx
80102641:	c1 ea 10             	shr    $0x10,%edx
80102644:	80 fa 03             	cmp    $0x3,%dl
80102647:	77 77                	ja     801026c0 <lapicinit+0xe0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102649:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102650:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102653:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102656:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102660:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102663:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102677:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102691:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
80102697:	89 f6                	mov    %esi,%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026a6:	80 e6 10             	and    $0x10,%dh
801026a9:	75 f5                	jne    801026a0 <lapicinit+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026b8:	5d                   	pop    %ebp
801026b9:	c3                   	ret    
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
801026cd:	e9 77 ff ff ff       	jmp    80102649 <lapicinit+0x69>
801026d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
801026e4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801026e5:	9c                   	pushf  
801026e6:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801026e7:	f6 c4 02             	test   $0x2,%ah
801026ea:	74 12                	je     801026fe <cpunum+0x1e>
    static int n;
    if(n++ == 0)
801026ec:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801026f1:	8d 50 01             	lea    0x1(%eax),%edx
801026f4:	85 c0                	test   %eax,%eax
801026f6:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
801026fc:	74 4d                	je     8010274b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
801026fe:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102703:	85 c0                	test   %eax,%eax
80102705:	74 60                	je     80102767 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
80102707:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010270a:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102710:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102713:	85 f6                	test   %esi,%esi
80102715:	7e 59                	jle    80102770 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102717:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
8010271e:	39 c3                	cmp    %eax,%ebx
80102720:	74 45                	je     80102767 <cpunum+0x87>
80102722:	ba 5c 28 11 80       	mov    $0x8011285c,%edx
80102727:	31 c0                	xor    %eax,%eax
80102729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80102730:	83 c0 01             	add    $0x1,%eax
80102733:	39 f0                	cmp    %esi,%eax
80102735:	74 39                	je     80102770 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102737:	0f b6 0a             	movzbl (%edx),%ecx
8010273a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102740:	39 cb                	cmp    %ecx,%ebx
80102742:	75 ec                	jne    80102730 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102747:	5b                   	pop    %ebx
80102748:	5e                   	pop    %esi
80102749:	5d                   	pop    %ebp
8010274a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010274b:	83 ec 08             	sub    $0x8,%esp
8010274e:	ff 75 04             	pushl  0x4(%ebp)
80102751:	68 c0 75 10 80       	push   $0x801075c0
80102756:	e8 05 df ff ff       	call   80100660 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010275b:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102760:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80102763:	85 c0                	test   %eax,%eax
80102765:	75 a0                	jne    80102707 <cpunum+0x27>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102767:	8d 65 f8             	lea    -0x8(%ebp),%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010276a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010276c:	5b                   	pop    %ebx
8010276d:	5e                   	pop    %esi
8010276e:	5d                   	pop    %ebp
8010276f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102770:	83 ec 0c             	sub    $0xc,%esp
80102773:	68 ec 75 10 80       	push   $0x801075ec
80102778:	e8 f3 db ff ff       	call   80100370 <panic>
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102780:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	ba 70 00 00 00       	mov    $0x70,%edx
801027b6:	b8 0f 00 00 00       	mov    $0xf,%eax
801027bb:	89 e5                	mov    %esp,%ebp
801027bd:	53                   	push   %ebx
801027be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	ba 71 00 00 00       	mov    $0x71,%edx
801027ca:	b8 0a 00 00 00       	mov    $0xa,%eax
801027cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027d0:	31 c0                	xor    %eax,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027dd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027e0:	c1 e8 04             	shr    $0x4,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ee:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f9:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102803:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102809:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102810:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102813:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102816:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281c:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102828:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102831:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010283a:	5b                   	pop    %ebx
8010283b:	5d                   	pop    %ebp
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	b8 0b 00 00 00       	mov    $0xb,%eax
8010284b:	89 e5                	mov    %esp,%ebp
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	ba 71 00 00 00       	mov    $0x71,%edx
80102859:	ec                   	in     (%dx),%al
8010285a:	83 e0 04             	and    $0x4,%eax
8010285d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102860:	31 db                	xor    %ebx,%ebx
80102862:	88 45 b7             	mov    %al,-0x49(%ebp)
80102865:	bf 70 00 00 00       	mov    $0x70,%edi
8010286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102870:	89 d8                	mov    %ebx,%eax
80102872:	89 fa                	mov    %edi,%edx
80102874:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102875:	b9 71 00 00 00       	mov    $0x71,%ecx
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010287d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102880:	89 fa                	mov    %edi,%edx
80102882:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102885:	b8 02 00 00 00       	mov    $0x2,%eax
8010288a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288b:	89 ca                	mov    %ecx,%edx
8010288d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010288e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102891:	89 fa                	mov    %edi,%edx
80102893:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102896:	b8 04 00 00 00       	mov    $0x4,%eax
8010289b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	89 ca                	mov    %ecx,%edx
8010289e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010289f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a2:	89 fa                	mov    %edi,%edx
801028a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028a7:	b8 07 00 00 00       	mov    $0x7,%eax
801028ac:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ad:	89 ca                	mov    %ecx,%edx
801028af:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028b0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b3:	89 fa                	mov    %edi,%edx
801028b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028b8:	b8 08 00 00 00       	mov    $0x8,%eax
801028bd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028be:	89 ca                	mov    %ecx,%edx
801028c0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028c1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c4:	89 fa                	mov    %edi,%edx
801028c6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028c9:	b8 09 00 00 00       	mov    $0x9,%eax
801028ce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cf:	89 ca                	mov    %ecx,%edx
801028d1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028d2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d5:	89 fa                	mov    %edi,%edx
801028d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028da:	b8 0a 00 00 00       	mov    $0xa,%eax
801028df:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e0:	89 ca                	mov    %ecx,%edx
801028e2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028e3:	84 c0                	test   %al,%al
801028e5:	78 89                	js     80102870 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e7:	89 d8                	mov    %ebx,%eax
801028e9:	89 fa                	mov    %edi,%edx
801028eb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	89 ca                	mov    %ecx,%edx
801028ee:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028ef:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f2:	89 fa                	mov    %edi,%edx
801028f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028f7:	b8 02 00 00 00       	mov    $0x2,%eax
801028fc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fd:	89 ca                	mov    %ecx,%edx
801028ff:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102900:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102903:	89 fa                	mov    %edi,%edx
80102905:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102908:	b8 04 00 00 00       	mov    $0x4,%eax
8010290d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290e:	89 ca                	mov    %ecx,%edx
80102910:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102911:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102914:	89 fa                	mov    %edi,%edx
80102916:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102919:	b8 07 00 00 00       	mov    $0x7,%eax
8010291e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291f:	89 ca                	mov    %ecx,%edx
80102921:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102922:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102925:	89 fa                	mov    %edi,%edx
80102927:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010292a:	b8 08 00 00 00       	mov    $0x8,%eax
8010292f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102930:	89 ca                	mov    %ecx,%edx
80102932:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102933:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102936:	89 fa                	mov    %edi,%edx
80102938:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010293b:	b8 09 00 00 00       	mov    $0x9,%eax
80102940:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102941:	89 ca                	mov    %ecx,%edx
80102943:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102944:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102947:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010294a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010294d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102950:	6a 18                	push   $0x18
80102952:	56                   	push   %esi
80102953:	50                   	push   %eax
80102954:	e8 f7 1c 00 00       	call   80104650 <memcmp>
80102959:	83 c4 10             	add    $0x10,%esp
8010295c:	85 c0                	test   %eax,%eax
8010295e:	0f 85 0c ff ff ff    	jne    80102870 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102964:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102968:	75 78                	jne    801029e2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010296a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010296d:	89 c2                	mov    %eax,%edx
8010296f:	83 e0 0f             	and    $0xf,%eax
80102972:	c1 ea 04             	shr    $0x4,%edx
80102975:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102978:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010297e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102981:	89 c2                	mov    %eax,%edx
80102983:	83 e0 0f             	and    $0xf,%eax
80102986:	c1 ea 04             	shr    $0x4,%edx
80102989:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102992:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102995:	89 c2                	mov    %eax,%edx
80102997:	83 e0 0f             	and    $0xf,%eax
8010299a:	c1 ea 04             	shr    $0x4,%edx
8010299d:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029a9:	89 c2                	mov    %eax,%edx
801029ab:	83 e0 0f             	and    $0xf,%eax
801029ae:	c1 ea 04             	shr    $0x4,%edx
801029b1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029bd:	89 c2                	mov    %eax,%edx
801029bf:	83 e0 0f             	and    $0xf,%eax
801029c2:	c1 ea 04             	shr    $0x4,%edx
801029c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029d1:	89 c2                	mov    %eax,%edx
801029d3:	83 e0 0f             	and    $0xf,%eax
801029d6:	c1 ea 04             	shr    $0x4,%edx
801029d9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029dc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029df:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029e2:	8b 75 08             	mov    0x8(%ebp),%esi
801029e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029e8:	89 06                	mov    %eax,(%esi)
801029ea:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029ed:	89 46 04             	mov    %eax,0x4(%esi)
801029f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f3:	89 46 08             	mov    %eax,0x8(%esi)
801029f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029f9:	89 46 0c             	mov    %eax,0xc(%esi)
801029fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029ff:	89 46 10             	mov    %eax,0x10(%esi)
80102a02:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a05:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a08:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a12:	5b                   	pop    %ebx
80102a13:	5e                   	pop    %esi
80102a14:	5f                   	pop    %edi
80102a15:	5d                   	pop    %ebp
80102a16:	c3                   	ret    
80102a17:	66 90                	xchg   %ax,%ax
80102a19:	66 90                	xchg   %ax,%ax
80102a1b:	66 90                	xchg   %ax,%ax
80102a1d:	66 90                	xchg   %ax,%ax
80102a1f:	90                   	nop

80102a20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a20:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102a26:	85 c9                	test   %ecx,%ecx
80102a28:	0f 8e 85 00 00 00    	jle    80102ab3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a2e:	55                   	push   %ebp
80102a2f:	89 e5                	mov    %esp,%ebp
80102a31:	57                   	push   %edi
80102a32:	56                   	push   %esi
80102a33:	53                   	push   %ebx
80102a34:	31 db                	xor    %ebx,%ebx
80102a36:	83 ec 0c             	sub    $0xc,%esp
80102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a40:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a45:	83 ec 08             	sub    $0x8,%esp
80102a48:	01 d8                	add    %ebx,%eax
80102a4a:	83 c0 01             	add    $0x1,%eax
80102a4d:	50                   	push   %eax
80102a4e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102a54:	e8 77 d6 ff ff       	call   801000d0 <bread>
80102a59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5b:	58                   	pop    %eax
80102a5c:	5a                   	pop    %edx
80102a5d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102a64:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6d:	e8 5e d6 ff ff       	call   801000d0 <bread>
80102a72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a77:	83 c4 0c             	add    $0xc,%esp
80102a7a:	68 00 02 00 00       	push   $0x200
80102a7f:	50                   	push   %eax
80102a80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a83:	50                   	push   %eax
80102a84:	e8 27 1c 00 00       	call   801046b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 0f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a91:	89 3c 24             	mov    %edi,(%esp)
80102a94:	e8 47 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 3f d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102aa1:	83 c4 10             	add    $0x10,%esp
80102aa4:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102aaa:	7f 94                	jg     80102a40 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aaf:	5b                   	pop    %ebx
80102ab0:	5e                   	pop    %esi
80102ab1:	5f                   	pop    %edi
80102ab2:	5d                   	pop    %ebp
80102ab3:	f3 c3                	repz ret 
80102ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	53                   	push   %ebx
80102ac4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac7:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102acd:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102ad3:	e8 f8 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ad8:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ade:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ae1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ae3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ae5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ae8:	7e 1f                	jle    80102b09 <write_head+0x49>
80102aea:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102af1:	31 d2                	xor    %edx,%edx
80102af3:	90                   	nop
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102af8:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102afe:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102b02:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b05:	39 c2                	cmp    %eax,%edx
80102b07:	75 ef                	jne    80102af8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102b09:	83 ec 0c             	sub    $0xc,%esp
80102b0c:	53                   	push   %ebx
80102b0d:	e8 8e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b12:	89 1c 24             	mov    %ebx,(%esp)
80102b15:	e8 c6 d6 ff ff       	call   801001e0 <brelse>
}
80102b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b1d:	c9                   	leave  
80102b1e:	c3                   	ret    
80102b1f:	90                   	nop

80102b20 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	83 ec 2c             	sub    $0x2c,%esp
80102b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b2a:	68 fc 75 10 80       	push   $0x801075fc
80102b2f:	68 a0 26 11 80       	push   $0x801126a0
80102b34:	e8 77 18 00 00       	call   801043b0 <initlock>
  readsb(dev, &sb);
80102b39:	58                   	pop    %eax
80102b3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 5b e8 ff ff       	call   801013a0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b45:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b48:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b4b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b4c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b52:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b58:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 6b d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b65:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b6d:	89 0d e8 26 11 80    	mov    %ecx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b73:	7e 1c                	jle    80102b91 <initlog+0x71>
80102b75:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b7c:	31 d2                	xor    %edx,%edx
80102b7e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b84:	83 c2 04             	add    $0x4,%edx
80102b87:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b8d:	39 da                	cmp    %ebx,%edx
80102b8f:	75 ef                	jne    80102b80 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b91:	83 ec 0c             	sub    $0xc,%esp
80102b94:	50                   	push   %eax
80102b95:	e8 46 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b9a:	e8 81 fe ff ff       	call   80102a20 <install_trans>
  log.lh.n = 0;
80102b9f:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ba6:	00 00 00 
  write_head(); // clear the log
80102ba9:	e8 12 ff ff ff       	call   80102ac0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bb1:	c9                   	leave  
80102bb2:	c3                   	ret    
80102bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bc6:	68 a0 26 11 80       	push   $0x801126a0
80102bcb:	e8 00 18 00 00       	call   801043d0 <acquire>
80102bd0:	83 c4 10             	add    $0x10,%esp
80102bd3:	eb 18                	jmp    80102bed <begin_op+0x2d>
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bd8:	83 ec 08             	sub    $0x8,%esp
80102bdb:	68 a0 26 11 80       	push   $0x801126a0
80102be0:	68 a0 26 11 80       	push   $0x801126a0
80102be5:	e8 36 12 00 00       	call   80103e20 <sleep>
80102bea:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bed:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	75 e2                	jne    80102bd8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bf6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102bfb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102c01:	83 c0 01             	add    $0x1,%eax
80102c04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c0a:	83 fa 1e             	cmp    $0x1e,%edx
80102c0d:	7f c9                	jg     80102bd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c0f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c12:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102c17:	68 a0 26 11 80       	push   $0x801126a0
80102c1c:	e8 8f 19 00 00       	call   801045b0 <release>
      break;
    }
  }
}
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	c9                   	leave  
80102c25:	c3                   	ret    
80102c26:	8d 76 00             	lea    0x0(%esi),%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	57                   	push   %edi
80102c34:	56                   	push   %esi
80102c35:	53                   	push   %ebx
80102c36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c39:	68 a0 26 11 80       	push   $0x801126a0
80102c3e:	e8 8d 17 00 00       	call   801043d0 <acquire>
  log.outstanding -= 1;
80102c43:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c48:	8b 1d e0 26 11 80    	mov    0x801126e0,%ebx
80102c4e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c51:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c54:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c56:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c5b:	0f 85 23 01 00 00    	jne    80102d84 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c61:	85 c0                	test   %eax,%eax
80102c63:	0f 85 f7 00 00 00    	jne    80102d60 <end_op+0x130>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c69:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c6c:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c73:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c76:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c78:	68 a0 26 11 80       	push   $0x801126a0
80102c7d:	e8 2e 19 00 00       	call   801045b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c82:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c88:	83 c4 10             	add    $0x10,%esp
80102c8b:	85 c9                	test   %ecx,%ecx
80102c8d:	0f 8e 8a 00 00 00    	jle    80102d1d <end_op+0xed>
80102c93:	90                   	nop
80102c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c98:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c9d:	83 ec 08             	sub    $0x8,%esp
80102ca0:	01 d8                	add    %ebx,%eax
80102ca2:	83 c0 01             	add    $0x1,%eax
80102ca5:	50                   	push   %eax
80102ca6:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102cac:	e8 1f d4 ff ff       	call   801000d0 <bread>
80102cb1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cb3:	58                   	pop    %eax
80102cb4:	5a                   	pop    %edx
80102cb5:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102cbc:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cc2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cc5:	e8 06 d4 ff ff       	call   801000d0 <bread>
80102cca:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ccc:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ccf:	83 c4 0c             	add    $0xc,%esp
80102cd2:	68 00 02 00 00       	push   $0x200
80102cd7:	50                   	push   %eax
80102cd8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cdb:	50                   	push   %eax
80102cdc:	e8 cf 19 00 00       	call   801046b0 <memmove>
    bwrite(to);  // write the log
80102ce1:	89 34 24             	mov    %esi,(%esp)
80102ce4:	e8 b7 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ce9:	89 3c 24             	mov    %edi,(%esp)
80102cec:	e8 ef d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cf1:	89 34 24             	mov    %esi,(%esp)
80102cf4:	e8 e7 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cf9:	83 c4 10             	add    $0x10,%esp
80102cfc:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102d02:	7c 94                	jl     80102c98 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d04:	e8 b7 fd ff ff       	call   80102ac0 <write_head>
    install_trans(); // Now install writes to home locations
80102d09:	e8 12 fd ff ff       	call   80102a20 <install_trans>
    log.lh.n = 0;
80102d0e:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d15:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d18:	e8 a3 fd ff ff       	call   80102ac0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d1d:	83 ec 0c             	sub    $0xc,%esp
80102d20:	68 a0 26 11 80       	push   $0x801126a0
80102d25:	e8 a6 16 00 00       	call   801043d0 <acquire>
    log.committing = 0;
    wakeup(&log);
80102d2a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102d31:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d38:	00 00 00 
    wakeup(&log);
80102d3b:	e8 b0 13 00 00       	call   801040f0 <wakeup>
    release(&log.lock);
80102d40:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d47:	e8 64 18 00 00       	call   801045b0 <release>
80102d4c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d52:	5b                   	pop    %ebx
80102d53:	5e                   	pop    %esi
80102d54:	5f                   	pop    %edi
80102d55:	5d                   	pop    %ebp
80102d56:	c3                   	ret    
80102d57:	89 f6                	mov    %esi,%esi
80102d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80102d60:	83 ec 0c             	sub    $0xc,%esp
80102d63:	68 a0 26 11 80       	push   $0x801126a0
80102d68:	e8 83 13 00 00       	call   801040f0 <wakeup>
  }
  release(&log.lock);
80102d6d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d74:	e8 37 18 00 00       	call   801045b0 <release>
80102d79:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d7f:	5b                   	pop    %ebx
80102d80:	5e                   	pop    %esi
80102d81:	5f                   	pop    %edi
80102d82:	5d                   	pop    %ebp
80102d83:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d84:	83 ec 0c             	sub    $0xc,%esp
80102d87:	68 00 76 10 80       	push   $0x80107600
80102d8c:	e8 df d5 ff ff       	call   80100370 <panic>
80102d91:	eb 0d                	jmp    80102da0 <log_write>
80102d93:	90                   	nop
80102d94:	90                   	nop
80102d95:	90                   	nop
80102d96:	90                   	nop
80102d97:	90                   	nop
80102d98:	90                   	nop
80102d99:	90                   	nop
80102d9a:	90                   	nop
80102d9b:	90                   	nop
80102d9c:	90                   	nop
80102d9d:	90                   	nop
80102d9e:	90                   	nop
80102d9f:	90                   	nop

80102da0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db0:	83 fa 1d             	cmp    $0x1d,%edx
80102db3:	0f 8f 97 00 00 00    	jg     80102e50 <log_write+0xb0>
80102db9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102dbe:	83 e8 01             	sub    $0x1,%eax
80102dc1:	39 c2                	cmp    %eax,%edx
80102dc3:	0f 8d 87 00 00 00    	jge    80102e50 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dc9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	0f 8e 87 00 00 00    	jle    80102e5d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 ed 15 00 00       	call   801043d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102de3:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	83 fa 00             	cmp    $0x0,%edx
80102def:	7e 50                	jle    80102e41 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102df4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df6:	3b 0d ec 26 11 80    	cmp    0x801126ec,%ecx
80102dfc:	75 0b                	jne    80102e09 <log_write+0x69>
80102dfe:	eb 38                	jmp    80102e38 <log_write+0x98>
80102e00:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102e07:	74 2f                	je     80102e38 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e09:	83 c0 01             	add    $0x1,%eax
80102e0c:	39 d0                	cmp    %edx,%eax
80102e0e:	75 f0                	jne    80102e00 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e10:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e17:	83 c2 01             	add    $0x1,%edx
80102e1a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102e20:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e23:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102e2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e2e:	e9 7d 17 00 00       	jmp    801045b0 <release>
80102e33:	90                   	nop
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e38:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102e3f:	eb df                	jmp    80102e20 <log_write+0x80>
80102e41:	8b 43 08             	mov    0x8(%ebx),%eax
80102e44:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e49:	75 d5                	jne    80102e20 <log_write+0x80>
80102e4b:	eb ca                	jmp    80102e17 <log_write+0x77>
80102e4d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e50:	83 ec 0c             	sub    $0xc,%esp
80102e53:	68 0f 76 10 80       	push   $0x8010760f
80102e58:	e8 13 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e5d:	83 ec 0c             	sub    $0xc,%esp
80102e60:	68 25 76 10 80       	push   $0x80107625
80102e65:	e8 06 d5 ff ff       	call   80100370 <panic>
80102e6a:	66 90                	xchg   %ax,%ax
80102e6c:	66 90                	xchg   %ax,%ax
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e76:	e8 65 f8 ff ff       	call   801026e0 <cpunum>
80102e7b:	83 ec 08             	sub    $0x8,%esp
80102e7e:	50                   	push   %eax
80102e7f:	68 40 76 10 80       	push   $0x80107640
80102e84:	e8 d7 d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e89:	e8 b2 2a 00 00       	call   80105940 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e8e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e95:	b8 01 00 00 00       	mov    $0x1,%eax
80102e9a:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102ea1:	e8 8a 0c 00 00       	call   80103b30 <scheduler>
80102ea6:	8d 76 00             	lea    0x0(%esi),%esi
80102ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102eb0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102eb6:	e8 d5 3c 00 00       	call   80106b90 <switchkvm>
  seginit();
80102ebb:	e8 f0 3a 00 00       	call   801069b0 <seginit>
  lapicinit();
80102ec0:	e8 1b f7 ff ff       	call   801025e0 <lapicinit>
  mpmain();
80102ec5:	e8 a6 ff ff ff       	call   80102e70 <mpmain>
80102eca:	66 90                	xchg   %ax,%ax
80102ecc:	66 90                	xchg   %ax,%ax
80102ece:	66 90                	xchg   %ax,%ax

80102ed0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ed0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ed4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ed7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eda:	55                   	push   %ebp
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	53                   	push   %ebx
80102ede:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102edf:	83 ec 08             	sub    $0x8,%esp
80102ee2:	68 00 00 40 80       	push   $0x80400000
80102ee7:	68 28 59 11 80       	push   $0x80115928
80102eec:	e8 bf f4 ff ff       	call   801023b0 <kinit1>
  kvmalloc();      // kernel page table
80102ef1:	e8 7a 3c 00 00       	call   80106b70 <kvmalloc>
  mpinit();        // detect other processors
80102ef6:	e8 b5 01 00 00       	call   801030b0 <mpinit>
  lapicinit();     // interrupt controller
80102efb:	e8 e0 f6 ff ff       	call   801025e0 <lapicinit>
  seginit();       // segment descriptors
80102f00:	e8 ab 3a 00 00       	call   801069b0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102f05:	e8 d6 f7 ff ff       	call   801026e0 <cpunum>
80102f0a:	5a                   	pop    %edx
80102f0b:	59                   	pop    %ecx
80102f0c:	50                   	push   %eax
80102f0d:	68 51 76 10 80       	push   $0x80107651
80102f12:	e8 49 d7 ff ff       	call   80100660 <cprintf>
  picinit();       // another interrupt controller
80102f17:	e8 a4 03 00 00       	call   801032c0 <picinit>
  ioapicinit();    // another interrupt controller
80102f1c:	e8 af f2 ff ff       	call   801021d0 <ioapicinit>
  consoleinit();   // console hardware
80102f21:	e8 7a da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102f26:	e8 55 2d 00 00       	call   80105c80 <uartinit>
  pinit();         // process table
80102f2b:	e8 60 09 00 00       	call   80103890 <pinit>
  tvinit();        // trap vectors
80102f30:	e8 6b 29 00 00       	call   801058a0 <tvinit>
  binit();         // buffer cache
80102f35:	e8 06 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f3a:	e8 01 de ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk
80102f3f:	e8 5c f0 ff ff       	call   80101fa0 <ideinit>
  if(!ismp)
80102f44:	8b 1d 84 27 11 80    	mov    0x80112784,%ebx
80102f4a:	83 c4 10             	add    $0x10,%esp
80102f4d:	85 db                	test   %ebx,%ebx
80102f4f:	0f 84 ca 00 00 00    	je     8010301f <main+0x14f>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f55:	83 ec 04             	sub    $0x4,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80102f58:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f5d:	68 8a 00 00 00       	push   $0x8a
80102f62:	68 8c a4 10 80       	push   $0x8010a48c
80102f67:	68 00 70 00 80       	push   $0x80007000
80102f6c:	e8 3f 17 00 00       	call   801046b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f71:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f78:	00 00 00 
80102f7b:	83 c4 10             	add    $0x10,%esp
80102f7e:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f83:	39 d8                	cmp    %ebx,%eax
80102f85:	76 7c                	jbe    80103003 <main+0x133>
80102f87:	89 f6                	mov    %esi,%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == cpus+cpunum())  // We've started already.
80102f90:	e8 4b f7 ff ff       	call   801026e0 <cpunum>
80102f95:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f9b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fa0:	39 c3                	cmp    %eax,%ebx
80102fa2:	74 46                	je     80102fea <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fa4:	e8 d7 f4 ff ff       	call   80102480 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102fa9:	83 ec 08             	sub    $0x8,%esp

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fac:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fb1:	c7 05 f8 6f 00 80 b0 	movl   $0x80102eb0,0x80006ff8
80102fb8:	2e 10 80 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fbb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fc0:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fc7:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102fca:	68 00 70 00 00       	push   $0x7000
80102fcf:	0f b6 03             	movzbl (%ebx),%eax
80102fd2:	50                   	push   %eax
80102fd3:	e8 d8 f7 ff ff       	call   801027b0 <lapicstartap>
80102fd8:	83 c4 10             	add    $0x10,%esp
80102fdb:	90                   	nop
80102fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fe0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102fe6:	85 c0                	test   %eax,%eax
80102fe8:	74 f6                	je     80102fe0 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102fea:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102ff1:	00 00 00 
80102ff4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102ffa:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fff:	39 c3                	cmp    %eax,%ebx
80103001:	72 8d                	jb     80102f90 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103003:	83 ec 08             	sub    $0x8,%esp
80103006:	68 00 00 00 8e       	push   $0x8e000000
8010300b:	68 00 00 40 80       	push   $0x80400000
80103010:	e8 0b f4 ff ff       	call   80102420 <kinit2>
  userinit();      // first user process
80103015:	e8 96 08 00 00       	call   801038b0 <userinit>
  mpmain();        // finish this processor's setup
8010301a:	e8 51 fe ff ff       	call   80102e70 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
8010301f:	e8 1c 28 00 00       	call   80105840 <timerinit>
80103024:	e9 2c ff ff ff       	jmp    80102f55 <main+0x85>
80103029:	66 90                	xchg   %ax,%ax
8010302b:	66 90                	xchg   %ax,%ax
8010302d:	66 90                	xchg   %ax,%ax
8010302f:	90                   	nop

80103030 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103035:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010303b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010303c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010303f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103042:	39 de                	cmp    %ebx,%esi
80103044:	73 48                	jae    8010308e <mpsearch1+0x5e>
80103046:	8d 76 00             	lea    0x0(%esi),%esi
80103049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103050:	83 ec 04             	sub    $0x4,%esp
80103053:	8d 7e 10             	lea    0x10(%esi),%edi
80103056:	6a 04                	push   $0x4
80103058:	68 68 76 10 80       	push   $0x80107668
8010305d:	56                   	push   %esi
8010305e:	e8 ed 15 00 00       	call   80104650 <memcmp>
80103063:	83 c4 10             	add    $0x10,%esp
80103066:	85 c0                	test   %eax,%eax
80103068:	75 1e                	jne    80103088 <mpsearch1+0x58>
8010306a:	8d 7e 10             	lea    0x10(%esi),%edi
8010306d:	89 f2                	mov    %esi,%edx
8010306f:	31 c9                	xor    %ecx,%ecx
80103071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103078:	0f b6 02             	movzbl (%edx),%eax
8010307b:	83 c2 01             	add    $0x1,%edx
8010307e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103080:	39 fa                	cmp    %edi,%edx
80103082:	75 f4                	jne    80103078 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103084:	84 c9                	test   %cl,%cl
80103086:	74 10                	je     80103098 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103088:	39 fb                	cmp    %edi,%ebx
8010308a:	89 fe                	mov    %edi,%esi
8010308c:	77 c2                	ja     80103050 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010308e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103091:	31 c0                	xor    %eax,%eax
}
80103093:	5b                   	pop    %ebx
80103094:	5e                   	pop    %esi
80103095:	5f                   	pop    %edi
80103096:	5d                   	pop    %ebp
80103097:	c3                   	ret    
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309b:	89 f0                	mov    %esi,%eax
8010309d:	5b                   	pop    %ebx
8010309e:	5e                   	pop    %esi
8010309f:	5f                   	pop    %edi
801030a0:	5d                   	pop    %ebp
801030a1:	c3                   	ret    
801030a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	57                   	push   %edi
801030b4:	56                   	push   %esi
801030b5:	53                   	push   %ebx
801030b6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030c7:	c1 e0 08             	shl    $0x8,%eax
801030ca:	09 d0                	or     %edx,%eax
801030cc:	c1 e0 04             	shl    $0x4,%eax
801030cf:	85 c0                	test   %eax,%eax
801030d1:	75 1b                	jne    801030ee <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801030d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030e1:	c1 e0 08             	shl    $0x8,%eax
801030e4:	09 d0                	or     %edx,%eax
801030e6:	c1 e0 0a             	shl    $0xa,%eax
801030e9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801030ee:	ba 00 04 00 00       	mov    $0x400,%edx
801030f3:	e8 38 ff ff ff       	call   80103030 <mpsearch1>
801030f8:	85 c0                	test   %eax,%eax
801030fa:	89 c6                	mov    %eax,%esi
801030fc:	0f 84 66 01 00 00    	je     80103268 <mpinit+0x1b8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103102:	8b 5e 04             	mov    0x4(%esi),%ebx
80103105:	85 db                	test   %ebx,%ebx
80103107:	0f 84 d6 00 00 00    	je     801031e3 <mpinit+0x133>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010310d:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103113:	83 ec 04             	sub    $0x4,%esp
80103116:	6a 04                	push   $0x4
80103118:	68 6d 76 10 80       	push   $0x8010766d
8010311d:	50                   	push   %eax
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010311e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103121:	e8 2a 15 00 00       	call   80104650 <memcmp>
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	85 c0                	test   %eax,%eax
8010312b:	0f 85 b2 00 00 00    	jne    801031e3 <mpinit+0x133>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103131:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103138:	3c 01                	cmp    $0x1,%al
8010313a:	74 08                	je     80103144 <mpinit+0x94>
8010313c:	3c 04                	cmp    $0x4,%al
8010313e:	0f 85 9f 00 00 00    	jne    801031e3 <mpinit+0x133>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103144:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010314b:	85 ff                	test   %edi,%edi
8010314d:	74 1e                	je     8010316d <mpinit+0xbd>
8010314f:	31 d2                	xor    %edx,%edx
80103151:	31 c0                	xor    %eax,%eax
80103153:	90                   	nop
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103158:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010315f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103160:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103163:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103165:	39 c7                	cmp    %eax,%edi
80103167:	75 ef                	jne    80103158 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103169:	84 d2                	test   %dl,%dl
8010316b:	75 76                	jne    801031e3 <mpinit+0x133>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010316d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103170:	85 ff                	test   %edi,%edi
80103172:	74 6f                	je     801031e3 <mpinit+0x133>
    return;
  ismp = 1;
80103174:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010317b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010317e:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103184:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103189:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
80103190:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103196:	01 f9                	add    %edi,%ecx
80103198:	39 c8                	cmp    %ecx,%eax
8010319a:	0f 83 a0 00 00 00    	jae    80103240 <mpinit+0x190>
    switch(*p){
801031a0:	80 38 04             	cmpb   $0x4,(%eax)
801031a3:	0f 87 87 00 00 00    	ja     80103230 <mpinit+0x180>
801031a9:	0f b6 10             	movzbl (%eax),%edx
801031ac:	ff 24 95 74 76 10 80 	jmp    *-0x7fef898c(,%edx,4)
801031b3:	90                   	nop
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031b8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031bb:	39 c1                	cmp    %eax,%ecx
801031bd:	77 e1                	ja     801031a0 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
801031bf:	a1 84 27 11 80       	mov    0x80112784,%eax
801031c4:	85 c0                	test   %eax,%eax
801031c6:	75 78                	jne    80103240 <mpinit+0x190>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801031c8:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
801031cf:	00 00 00 
    lapic = 0;
801031d2:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
801031d9:	00 00 00 
    ioapicid = 0;
801031dc:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801031e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031e6:	5b                   	pop    %ebx
801031e7:	5e                   	pop    %esi
801031e8:	5f                   	pop    %edi
801031e9:	5d                   	pop    %ebp
801031ea:	c3                   	ret    
801031eb:	90                   	nop
801031ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801031f0:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
801031f6:	83 fa 07             	cmp    $0x7,%edx
801031f9:	7f 19                	jg     80103214 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031fb:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
801031ff:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
        ncpu++;
80103205:	83 c2 01             	add    $0x1,%edx
80103208:	89 15 80 2d 11 80    	mov    %edx,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010320e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
80103214:	83 c0 14             	add    $0x14,%eax
      continue;
80103217:	eb a2                	jmp    801031bb <mpinit+0x10b>
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103220:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103224:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103227:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
8010322d:	eb 8c                	jmp    801031bb <mpinit+0x10b>
8010322f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103230:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
80103237:	00 00 00 
      break;
8010323a:	e9 7c ff ff ff       	jmp    801031bb <mpinit+0x10b>
8010323f:	90                   	nop
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103240:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103244:	74 9d                	je     801031e3 <mpinit+0x133>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103246:	ba 22 00 00 00       	mov    $0x22,%edx
8010324b:	b8 70 00 00 00       	mov    $0x70,%eax
80103250:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103251:	ba 23 00 00 00       	mov    $0x23,%edx
80103256:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103257:	83 c8 01             	or     $0x1,%eax
8010325a:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010325b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325e:	5b                   	pop    %ebx
8010325f:	5e                   	pop    %esi
80103260:	5f                   	pop    %edi
80103261:	5d                   	pop    %ebp
80103262:	c3                   	ret    
80103263:	90                   	nop
80103264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103268:	ba 00 00 01 00       	mov    $0x10000,%edx
8010326d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103272:	e8 b9 fd ff ff       	call   80103030 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103277:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103279:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010327b:	0f 85 81 fe ff ff    	jne    80103102 <mpinit+0x52>
80103281:	e9 5d ff ff ff       	jmp    801031e3 <mpinit+0x133>
80103286:	66 90                	xchg   %ax,%ax
80103288:	66 90                	xchg   %ax,%ax
8010328a:	66 90                	xchg   %ax,%ax
8010328c:	66 90                	xchg   %ax,%ax
8010328e:	66 90                	xchg   %ax,%ax

80103290 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103290:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103291:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103296:	ba 21 00 00 00       	mov    $0x21,%edx
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
8010329b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010329d:	8b 4d 08             	mov    0x8(%ebp),%ecx
801032a0:	d3 c0                	rol    %cl,%eax
801032a2:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
801032a9:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
801032af:	ee                   	out    %al,(%dx)
801032b0:	ba a1 00 00 00       	mov    $0xa1,%edx
801032b5:	66 c1 e8 08          	shr    $0x8,%ax
801032b9:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
801032ba:	5d                   	pop    %ebp
801032bb:	c3                   	ret    
801032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032c0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801032c0:	55                   	push   %ebp
801032c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032c6:	89 e5                	mov    %esp,%ebp
801032c8:	57                   	push   %edi
801032c9:	56                   	push   %esi
801032ca:	53                   	push   %ebx
801032cb:	bb 21 00 00 00       	mov    $0x21,%ebx
801032d0:	89 da                	mov    %ebx,%edx
801032d2:	ee                   	out    %al,(%dx)
801032d3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801032d8:	89 ca                	mov    %ecx,%edx
801032da:	ee                   	out    %al,(%dx)
801032db:	bf 11 00 00 00       	mov    $0x11,%edi
801032e0:	be 20 00 00 00       	mov    $0x20,%esi
801032e5:	89 f8                	mov    %edi,%eax
801032e7:	89 f2                	mov    %esi,%edx
801032e9:	ee                   	out    %al,(%dx)
801032ea:	b8 20 00 00 00       	mov    $0x20,%eax
801032ef:	89 da                	mov    %ebx,%edx
801032f1:	ee                   	out    %al,(%dx)
801032f2:	b8 04 00 00 00       	mov    $0x4,%eax
801032f7:	ee                   	out    %al,(%dx)
801032f8:	b8 03 00 00 00       	mov    $0x3,%eax
801032fd:	ee                   	out    %al,(%dx)
801032fe:	bb a0 00 00 00       	mov    $0xa0,%ebx
80103303:	89 f8                	mov    %edi,%eax
80103305:	89 da                	mov    %ebx,%edx
80103307:	ee                   	out    %al,(%dx)
80103308:	b8 28 00 00 00       	mov    $0x28,%eax
8010330d:	89 ca                	mov    %ecx,%edx
8010330f:	ee                   	out    %al,(%dx)
80103310:	b8 02 00 00 00       	mov    $0x2,%eax
80103315:	ee                   	out    %al,(%dx)
80103316:	b8 03 00 00 00       	mov    $0x3,%eax
8010331b:	ee                   	out    %al,(%dx)
8010331c:	bf 68 00 00 00       	mov    $0x68,%edi
80103321:	89 f2                	mov    %esi,%edx
80103323:	89 f8                	mov    %edi,%eax
80103325:	ee                   	out    %al,(%dx)
80103326:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010332b:	89 c8                	mov    %ecx,%eax
8010332d:	ee                   	out    %al,(%dx)
8010332e:	89 f8                	mov    %edi,%eax
80103330:	89 da                	mov    %ebx,%edx
80103332:	ee                   	out    %al,(%dx)
80103333:	89 c8                	mov    %ecx,%eax
80103335:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103336:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010333d:	66 83 f8 ff          	cmp    $0xffff,%ax
80103341:	74 10                	je     80103353 <picinit+0x93>
80103343:	ba 21 00 00 00       	mov    $0x21,%edx
80103348:	ee                   	out    %al,(%dx)
80103349:	ba a1 00 00 00       	mov    $0xa1,%edx
8010334e:	66 c1 e8 08          	shr    $0x8,%ax
80103352:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
80103353:	5b                   	pop    %ebx
80103354:	5e                   	pop    %esi
80103355:	5f                   	pop    %edi
80103356:	5d                   	pop    %ebp
80103357:	c3                   	ret    
80103358:	66 90                	xchg   %ax,%ax
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
80103365:	53                   	push   %ebx
80103366:	83 ec 0c             	sub    $0xc,%esp
80103369:	8b 75 08             	mov    0x8(%ebp),%esi
8010336c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010336f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103375:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010337b:	e8 e0 d9 ff ff       	call   80100d60 <filealloc>
80103380:	85 c0                	test   %eax,%eax
80103382:	89 06                	mov    %eax,(%esi)
80103384:	0f 84 a8 00 00 00    	je     80103432 <pipealloc+0xd2>
8010338a:	e8 d1 d9 ff ff       	call   80100d60 <filealloc>
8010338f:	85 c0                	test   %eax,%eax
80103391:	89 03                	mov    %eax,(%ebx)
80103393:	0f 84 87 00 00 00    	je     80103420 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103399:	e8 e2 f0 ff ff       	call   80102480 <kalloc>
8010339e:	85 c0                	test   %eax,%eax
801033a0:	89 c7                	mov    %eax,%edi
801033a2:	0f 84 b0 00 00 00    	je     80103458 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033a8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801033ab:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033b2:	00 00 00 
  p->writeopen = 1;
801033b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033bc:	00 00 00 
  p->nwrite = 0;
801033bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033c6:	00 00 00 
  p->nread = 0;
801033c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033d0:	00 00 00 
  initlock(&p->lock, "pipe");
801033d3:	68 88 76 10 80       	push   $0x80107688
801033d8:	50                   	push   %eax
801033d9:	e8 d2 0f 00 00       	call   801043b0 <initlock>
  (*f0)->type = FD_PIPE;
801033de:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033e0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801033e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033e9:	8b 06                	mov    (%esi),%eax
801033eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033ef:	8b 06                	mov    (%esi),%eax
801033f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033f5:	8b 06                	mov    (%esi),%eax
801033f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033fa:	8b 03                	mov    (%ebx),%eax
801033fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103402:	8b 03                	mov    (%ebx),%eax
80103404:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103408:	8b 03                	mov    (%ebx),%eax
8010340a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010340e:	8b 03                	mov    (%ebx),%eax
80103410:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103413:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103416:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103418:	5b                   	pop    %ebx
80103419:	5e                   	pop    %esi
8010341a:	5f                   	pop    %edi
8010341b:	5d                   	pop    %ebp
8010341c:	c3                   	ret    
8010341d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103420:	8b 06                	mov    (%esi),%eax
80103422:	85 c0                	test   %eax,%eax
80103424:	74 1e                	je     80103444 <pipealloc+0xe4>
    fileclose(*f0);
80103426:	83 ec 0c             	sub    $0xc,%esp
80103429:	50                   	push   %eax
8010342a:	e8 f1 d9 ff ff       	call   80100e20 <fileclose>
8010342f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103432:	8b 03                	mov    (%ebx),%eax
80103434:	85 c0                	test   %eax,%eax
80103436:	74 0c                	je     80103444 <pipealloc+0xe4>
    fileclose(*f1);
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	50                   	push   %eax
8010343c:	e8 df d9 ff ff       	call   80100e20 <fileclose>
80103441:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103444:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103447:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010344c:	5b                   	pop    %ebx
8010344d:	5e                   	pop    %esi
8010344e:	5f                   	pop    %edi
8010344f:	5d                   	pop    %ebp
80103450:	c3                   	ret    
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103458:	8b 06                	mov    (%esi),%eax
8010345a:	85 c0                	test   %eax,%eax
8010345c:	75 c8                	jne    80103426 <pipealloc+0xc6>
8010345e:	eb d2                	jmp    80103432 <pipealloc+0xd2>

80103460 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	56                   	push   %esi
80103464:	53                   	push   %ebx
80103465:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103468:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010346b:	83 ec 0c             	sub    $0xc,%esp
8010346e:	53                   	push   %ebx
8010346f:	e8 5c 0f 00 00       	call   801043d0 <acquire>
  if(writable){
80103474:	83 c4 10             	add    $0x10,%esp
80103477:	85 f6                	test   %esi,%esi
80103479:	74 45                	je     801034c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010347b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103481:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103484:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010348b:	00 00 00 
    wakeup(&p->nread);
8010348e:	50                   	push   %eax
8010348f:	e8 5c 0c 00 00       	call   801040f0 <wakeup>
80103494:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103497:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010349d:	85 d2                	test   %edx,%edx
8010349f:	75 0a                	jne    801034ab <pipeclose+0x4b>
801034a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034a7:	85 c0                	test   %eax,%eax
801034a9:	74 35                	je     801034e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034b1:	5b                   	pop    %ebx
801034b2:	5e                   	pop    %esi
801034b3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034b4:	e9 f7 10 00 00       	jmp    801045b0 <release>
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801034c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034c6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801034c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034d0:	00 00 00 
    wakeup(&p->nwrite);
801034d3:	50                   	push   %eax
801034d4:	e8 17 0c 00 00       	call   801040f0 <wakeup>
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	eb b9                	jmp    80103497 <pipeclose+0x37>
801034de:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	53                   	push   %ebx
801034e4:	e8 c7 10 00 00       	call   801045b0 <release>
    kfree((char*)p);
801034e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034ec:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801034ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034f2:	5b                   	pop    %ebx
801034f3:	5e                   	pop    %esi
801034f4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801034f5:	e9 d6 ed ff ff       	jmp    801022d0 <kfree>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103500 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 28             	sub    $0x28,%esp
80103509:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350c:	57                   	push   %edi
8010350d:	e8 be 0e 00 00       	call   801043d0 <acquire>
  for(i = 0; i < n; i++){
80103512:	8b 45 10             	mov    0x10(%ebp),%eax
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	85 c0                	test   %eax,%eax
8010351a:	0f 8e c6 00 00 00    	jle    801035e6 <pipewrite+0xe6>
80103520:	8b 45 0c             	mov    0xc(%ebp),%eax
80103523:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
80103529:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
8010352f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103538:	03 45 10             	add    0x10(%ebp),%eax
8010353b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010353e:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103544:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010354a:	39 d1                	cmp    %edx,%ecx
8010354c:	0f 85 cf 00 00 00    	jne    80103621 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
80103552:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103558:	85 d2                	test   %edx,%edx
8010355a:	0f 84 a8 00 00 00    	je     80103608 <pipewrite+0x108>
80103560:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103567:	8b 42 24             	mov    0x24(%edx),%eax
8010356a:	85 c0                	test   %eax,%eax
8010356c:	74 25                	je     80103593 <pipewrite+0x93>
8010356e:	e9 95 00 00 00       	jmp    80103608 <pipewrite+0x108>
80103573:	90                   	nop
80103574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103578:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010357e:	85 c0                	test   %eax,%eax
80103580:	0f 84 82 00 00 00    	je     80103608 <pipewrite+0x108>
80103586:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010358c:	8b 40 24             	mov    0x24(%eax),%eax
8010358f:	85 c0                	test   %eax,%eax
80103591:	75 75                	jne    80103608 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103593:	83 ec 0c             	sub    $0xc,%esp
80103596:	56                   	push   %esi
80103597:	e8 54 0b 00 00       	call   801040f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010359c:	59                   	pop    %ecx
8010359d:	58                   	pop    %eax
8010359e:	57                   	push   %edi
8010359f:	53                   	push   %ebx
801035a0:	e8 7b 08 00 00       	call   80103e20 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035a5:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801035ab:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801035b1:	83 c4 10             	add    $0x10,%esp
801035b4:	05 00 02 00 00       	add    $0x200,%eax
801035b9:	39 c2                	cmp    %eax,%edx
801035bb:	74 bb                	je     80103578 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035c0:	8d 4a 01             	lea    0x1(%edx),%ecx
801035c3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801035c7:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035cd:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801035d3:	0f b6 00             	movzbl (%eax),%eax
801035d6:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
801035da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801035dd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
801035e0:	0f 85 58 ff ff ff    	jne    8010353e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035e6:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
801035ec:	83 ec 0c             	sub    $0xc,%esp
801035ef:	52                   	push   %edx
801035f0:	e8 fb 0a 00 00       	call   801040f0 <wakeup>
  release(&p->lock);
801035f5:	89 3c 24             	mov    %edi,(%esp)
801035f8:	e8 b3 0f 00 00       	call   801045b0 <release>
  return n;
801035fd:	83 c4 10             	add    $0x10,%esp
80103600:	8b 45 10             	mov    0x10(%ebp),%eax
80103603:	eb 14                	jmp    80103619 <pipewrite+0x119>
80103605:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103608:	83 ec 0c             	sub    $0xc,%esp
8010360b:	57                   	push   %edi
8010360c:	e8 9f 0f 00 00       	call   801045b0 <release>
        return -1;
80103611:	83 c4 10             	add    $0x10,%esp
80103614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010361c:	5b                   	pop    %ebx
8010361d:	5e                   	pop    %esi
8010361e:	5f                   	pop    %edi
8010361f:	5d                   	pop    %ebp
80103620:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103621:	89 ca                	mov    %ecx,%edx
80103623:	eb 98                	jmp    801035bd <pipewrite+0xbd>
80103625:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103630 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 18             	sub    $0x18,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010363c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010363f:	53                   	push   %ebx
80103640:	e8 8b 0d 00 00       	call   801043d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103654:	75 6a                	jne    801036c0 <piperead+0x90>
80103656:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010365c:	85 f6                	test   %esi,%esi
8010365e:	0f 84 cc 00 00 00    	je     80103730 <piperead+0x100>
80103664:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010366a:	eb 2d                	jmp    80103699 <piperead+0x69>
8010366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103670:	83 ec 08             	sub    $0x8,%esp
80103673:	53                   	push   %ebx
80103674:	56                   	push   %esi
80103675:	e8 a6 07 00 00       	call   80103e20 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103683:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103689:	75 35                	jne    801036c0 <piperead+0x90>
8010368b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103691:	85 d2                	test   %edx,%edx
80103693:	0f 84 97 00 00 00    	je     80103730 <piperead+0x100>
    if(proc->killed){
80103699:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801036a0:	8b 4a 24             	mov    0x24(%edx),%ecx
801036a3:	85 c9                	test   %ecx,%ecx
801036a5:	74 c9                	je     80103670 <piperead+0x40>
      release(&p->lock);
801036a7:	83 ec 0c             	sub    $0xc,%esp
801036aa:	53                   	push   %ebx
801036ab:	e8 00 0f 00 00       	call   801045b0 <release>
      return -1;
801036b0:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036b3:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801036b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036bb:	5b                   	pop    %ebx
801036bc:	5e                   	pop    %esi
801036bd:	5f                   	pop    %edi
801036be:	5d                   	pop    %ebp
801036bf:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036c0:	8b 45 10             	mov    0x10(%ebp),%eax
801036c3:	85 c0                	test   %eax,%eax
801036c5:	7e 69                	jle    80103730 <piperead+0x100>
    if(p->nread == p->nwrite)
801036c7:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036cd:	31 c9                	xor    %ecx,%ecx
801036cf:	eb 15                	jmp    801036e6 <piperead+0xb6>
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d8:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036de:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801036e4:	74 5a                	je     80103740 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036e6:	8d 72 01             	lea    0x1(%edx),%esi
801036e9:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036ef:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801036f5:	0f b6 54 13 34       	movzbl 0x34(%ebx,%edx,1),%edx
801036fa:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036fd:	83 c1 01             	add    $0x1,%ecx
80103700:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103703:	75 d3                	jne    801036d8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103705:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	52                   	push   %edx
8010370f:	e8 dc 09 00 00       	call   801040f0 <wakeup>
  release(&p->lock);
80103714:	89 1c 24             	mov    %ebx,(%esp)
80103717:	e8 94 0e 00 00       	call   801045b0 <release>
  return i;
8010371c:	8b 45 10             	mov    0x10(%ebp),%eax
8010371f:	83 c4 10             	add    $0x10,%esp
}
80103722:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103725:	5b                   	pop    %ebx
80103726:	5e                   	pop    %esi
80103727:	5f                   	pop    %edi
80103728:	5d                   	pop    %ebp
80103729:	c3                   	ret    
8010372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103730:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103737:	eb cc                	jmp    80103705 <piperead+0xd5>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103740:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103743:	eb c0                	jmp    80103705 <piperead+0xd5>
80103745:	66 90                	xchg   %ax,%ax
80103747:	66 90                	xchg   %ax,%ax
80103749:	66 90                	xchg   %ax,%ax
8010374b:	66 90                	xchg   %ax,%ax
8010374d:	66 90                	xchg   %ax,%ax
8010374f:	90                   	nop

80103750 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103754:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103759:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010375c:	68 a0 2d 11 80       	push   $0x80112da0
80103761:	e8 6a 0c 00 00       	call   801043d0 <acquire>
80103766:	83 c4 10             	add    $0x10,%esp
80103769:	eb 17                	jmp    80103782 <allocproc+0x32>
8010376b:	90                   	nop
8010376c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103770:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103776:	81 fb d4 50 11 80    	cmp    $0x801150d4,%ebx
8010377c:	0f 84 9e 00 00 00    	je     80103820 <allocproc+0xd0>
    if(p->state == UNUSED)
80103782:	8b 43 0c             	mov    0xc(%ebx),%eax
80103785:	85 c0                	test   %eax,%eax
80103787:	75 e7                	jne    80103770 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103789:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
8010378e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103791:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103798:	68 a0 2d 11 80       	push   $0x80112da0
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
8010379d:	8d 50 01             	lea    0x1(%eax),%edx
801037a0:	89 43 10             	mov    %eax,0x10(%ebx)
801037a3:	89 15 08 a0 10 80    	mov    %edx,0x8010a008

  release(&ptable.lock);
801037a9:	e8 02 0e 00 00       	call   801045b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037ae:	e8 cd ec ff ff       	call   80102480 <kalloc>
801037b3:	83 c4 10             	add    $0x10,%esp
801037b6:	85 c0                	test   %eax,%eax
801037b8:	89 43 08             	mov    %eax,0x8(%ebx)
801037bb:	74 7a                	je     80103837 <allocproc+0xe7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037bd:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037c3:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801037c6:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037cb:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801037ce:	c7 40 14 8e 58 10 80 	movl   $0x8010588e,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037d5:	6a 14                	push   $0x14
801037d7:	6a 00                	push   $0x0
801037d9:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801037da:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037dd:	e8 1e 0e 00 00       	call   80104600 <memset>
  p->context->eip = (uint)forkret;
801037e2:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->stime = ticks;         // start time
  p->etime = 0;             // end time
  p->rtime = 0;             // run time
  p->iotime = 0;            // I/O time

  return p;
801037e5:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801037e8:	c7 40 10 40 38 10 80 	movl   $0x80103840,0x10(%eax)

  // adding time fields
  p->stime = ticks;         // start time
801037ef:	a1 20 59 11 80       	mov    0x80115920,%eax
  p->etime = 0;             // end time
801037f4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801037fb:	00 00 00 
  p->rtime = 0;             // run time
801037fe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103805:	00 00 00 
  p->iotime = 0;            // I/O time
80103808:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
8010380f:	00 00 00 
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  // adding time fields
  p->stime = ticks;         // start time
80103812:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->etime = 0;             // end time
  p->rtime = 0;             // run time
  p->iotime = 0;            // I/O time

  return p;
80103815:	89 d8                	mov    %ebx,%eax
}
80103817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010381a:	c9                   	leave  
8010381b:	c3                   	ret    
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	68 a0 2d 11 80       	push   $0x80112da0
80103828:	e8 83 0d 00 00       	call   801045b0 <release>
  return 0;
8010382d:	83 c4 10             	add    $0x10,%esp
80103830:	31 c0                	xor    %eax,%eax
  p->etime = 0;             // end time
  p->rtime = 0;             // run time
  p->iotime = 0;            // I/O time

  return p;
}
80103832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103835:	c9                   	leave  
80103836:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103837:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010383e:	eb d7                	jmp    80103817 <allocproc+0xc7>

80103840 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103846:	68 a0 2d 11 80       	push   $0x80112da0
8010384b:	e8 60 0d 00 00       	call   801045b0 <release>

  if (first) {
80103850:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103855:	83 c4 10             	add    $0x10,%esp
80103858:	85 c0                	test   %eax,%eax
8010385a:	75 04                	jne    80103860 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010385c:	c9                   	leave  
8010385d:	c3                   	ret    
8010385e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103860:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103863:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010386a:	00 00 00 
    iinit(ROOTDEV);
8010386d:	6a 01                	push   $0x1
8010386f:	e8 ec db ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
80103874:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010387b:	e8 a0 f2 ff ff       	call   80102b20 <initlog>
80103880:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103883:	c9                   	leave  
80103884:	c3                   	ret    
80103885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103890 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103896:	68 8d 76 10 80       	push   $0x8010768d
8010389b:	68 a0 2d 11 80       	push   $0x80112da0
801038a0:	e8 0b 0b 00 00       	call   801043b0 <initlock>
}
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	c9                   	leave  
801038a9:	c3                   	ret    
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038b0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	53                   	push   %ebx
801038b4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801038b7:	e8 94 fe ff ff       	call   80103750 <allocproc>
801038bc:	89 c3                	mov    %eax,%ebx

  initproc = p;
801038be:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801038c3:	e8 38 32 00 00       	call   80106b00 <setupkvm>
801038c8:	85 c0                	test   %eax,%eax
801038ca:	89 43 04             	mov    %eax,0x4(%ebx)
801038cd:	0f 84 bd 00 00 00    	je     80103990 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038d3:	83 ec 04             	sub    $0x4,%esp
801038d6:	68 2c 00 00 00       	push   $0x2c
801038db:	68 60 a4 10 80       	push   $0x8010a460
801038e0:	50                   	push   %eax
801038e1:	e8 6a 33 00 00       	call   80106c50 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801038e6:	83 c4 0c             	add    $0xc,%esp

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801038e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038ef:	6a 4c                	push   $0x4c
801038f1:	6a 00                	push   $0x0
801038f3:	ff 73 18             	pushl  0x18(%ebx)
801038f6:	e8 05 0d 00 00       	call   80104600 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038fb:	8b 43 18             	mov    0x18(%ebx),%eax
801038fe:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103903:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103908:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010390b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010390f:	8b 43 18             	mov    0x18(%ebx),%eax
80103912:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103916:	8b 43 18             	mov    0x18(%ebx),%eax
80103919:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010391d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103921:	8b 43 18             	mov    0x18(%ebx),%eax
80103924:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103928:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010392c:	8b 43 18             	mov    0x18(%ebx),%eax
8010392f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103936:	8b 43 18             	mov    0x18(%ebx),%eax
80103939:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103940:	8b 43 18             	mov    0x18(%ebx),%eax
80103943:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010394a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010394d:	6a 10                	push   $0x10
8010394f:	68 ad 76 10 80       	push   $0x801076ad
80103954:	50                   	push   %eax
80103955:	e8 a6 0e 00 00       	call   80104800 <safestrcpy>
  p->cwd = namei("/");
8010395a:	c7 04 24 b6 76 10 80 	movl   $0x801076b6,(%esp)
80103961:	e8 2a e5 ff ff       	call   80101e90 <namei>
80103966:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103969:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103970:	e8 5b 0a 00 00       	call   801043d0 <acquire>

  p->state = RUNNABLE;
80103975:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010397c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103983:	e8 28 0c 00 00       	call   801045b0 <release>
}
80103988:	83 c4 10             	add    $0x10,%esp
8010398b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398e:	c9                   	leave  
8010398f:	c3                   	ret    

  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103990:	83 ec 0c             	sub    $0xc,%esp
80103993:	68 94 76 10 80       	push   $0x80107694
80103998:	e8 d3 c9 ff ff       	call   80100370 <panic>
8010399d:	8d 76 00             	lea    0x0(%esi),%esi

801039a0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 08             	sub    $0x8,%esp
  uint sz;

  sz = proc->sz;
801039a6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801039b0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801039b2:	83 f9 00             	cmp    $0x0,%ecx
801039b5:	7e 39                	jle    801039f0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801039b7:	83 ec 04             	sub    $0x4,%esp
801039ba:	01 c1                	add    %eax,%ecx
801039bc:	51                   	push   %ecx
801039bd:	50                   	push   %eax
801039be:	ff 72 04             	pushl  0x4(%edx)
801039c1:	e8 ca 33 00 00       	call   80106d90 <allocuvm>
801039c6:	83 c4 10             	add    $0x10,%esp
801039c9:	85 c0                	test   %eax,%eax
801039cb:	74 3b                	je     80103a08 <growproc+0x68>
801039cd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
801039d4:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
801039d6:	83 ec 0c             	sub    $0xc,%esp
801039d9:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
801039e0:	e8 cb 31 00 00       	call   80106bb0 <switchuvm>
  return 0;
801039e5:	83 c4 10             	add    $0x10,%esp
801039e8:	31 c0                	xor    %eax,%eax
}
801039ea:	c9                   	leave  
801039eb:	c3                   	ret    
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801039f0:	74 e2                	je     801039d4 <growproc+0x34>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801039f2:	83 ec 04             	sub    $0x4,%esp
801039f5:	01 c1                	add    %eax,%ecx
801039f7:	51                   	push   %ecx
801039f8:	50                   	push   %eax
801039f9:	ff 72 04             	pushl  0x4(%edx)
801039fc:	e8 8f 34 00 00       	call   80106e90 <deallocuvm>
80103a01:	83 c4 10             	add    $0x10,%esp
80103a04:	85 c0                	test   %eax,%eax
80103a06:	75 c5                	jne    801039cd <growproc+0x2d>
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103a0d:	c9                   	leave  
80103a0e:	c3                   	ret    
80103a0f:	90                   	nop

80103a10 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	53                   	push   %ebx
80103a16:	83 ec 0c             	sub    $0xc,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103a19:	e8 32 fd ff ff       	call   80103750 <allocproc>
80103a1e:	85 c0                	test   %eax,%eax
80103a20:	0f 84 d6 00 00 00    	je     80103afc <fork+0xec>
80103a26:	89 c3                	mov    %eax,%ebx
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103a28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a2e:	83 ec 08             	sub    $0x8,%esp
80103a31:	ff 30                	pushl  (%eax)
80103a33:	ff 70 04             	pushl  0x4(%eax)
80103a36:	e8 35 35 00 00       	call   80106f70 <copyuvm>
80103a3b:	83 c4 10             	add    $0x10,%esp
80103a3e:	85 c0                	test   %eax,%eax
80103a40:	89 43 04             	mov    %eax,0x4(%ebx)
80103a43:	0f 84 ba 00 00 00    	je     80103b03 <fork+0xf3>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103a4f:	8b 7b 18             	mov    0x18(%ebx),%edi
80103a52:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a57:	8b 00                	mov    (%eax),%eax
80103a59:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103a5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a61:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103a64:	8b 70 18             	mov    0x18(%eax),%esi
80103a67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a69:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a75:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103a80:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103a84:	85 c0                	test   %eax,%eax
80103a86:	74 17                	je     80103a9f <fork+0x8f>
      np->ofile[i] = filedup(proc->ofile[i]);
80103a88:	83 ec 0c             	sub    $0xc,%esp
80103a8b:	50                   	push   %eax
80103a8c:	e8 3f d3 ff ff       	call   80100dd0 <filedup>
80103a91:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103a95:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a9c:	83 c4 10             	add    $0x10,%esp
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a9f:	83 c6 01             	add    $0x1,%esi
80103aa2:	83 fe 10             	cmp    $0x10,%esi
80103aa5:	75 d9                	jne    80103a80 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103aa7:	83 ec 0c             	sub    $0xc,%esp
80103aaa:	ff 72 68             	pushl  0x68(%edx)
80103aad:	e8 7e db ff ff       	call   80101630 <idup>
80103ab2:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103ab5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103abb:	83 c4 0c             	add    $0xc,%esp
80103abe:	6a 10                	push   $0x10
80103ac0:	83 c0 6c             	add    $0x6c,%eax
80103ac3:	50                   	push   %eax
80103ac4:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ac7:	50                   	push   %eax
80103ac8:	e8 33 0d 00 00       	call   80104800 <safestrcpy>

  pid = np->pid;
80103acd:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103ad0:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ad7:	e8 f4 08 00 00       	call   801043d0 <acquire>

  np->state = RUNNABLE;
80103adc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103ae3:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103aea:	e8 c1 0a 00 00       	call   801045b0 <release>

  return pid;
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	89 f0                	mov    %esi,%eax
}
80103af4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103af7:	5b                   	pop    %ebx
80103af8:	5e                   	pop    %esi
80103af9:	5f                   	pop    %edi
80103afa:	5d                   	pop    %ebp
80103afb:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b01:	eb f1                	jmp    80103af4 <fork+0xe4>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103b03:	83 ec 0c             	sub    $0xc,%esp
80103b06:	ff 73 08             	pushl  0x8(%ebx)
80103b09:	e8 c2 e7 ff ff       	call   801022d0 <kfree>
    np->kstack = 0;
80103b0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b15:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b1c:	83 c4 10             	add    $0x10,%esp
80103b1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b24:	eb ce                	jmp    80103af4 <fork+0xe4>
80103b26:	8d 76 00             	lea    0x0(%esi),%esi
80103b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b30 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	53                   	push   %ebx
80103b34:	83 ec 04             	sub    $0x4,%esp
80103b37:	89 f6                	mov    %esi,%esi
80103b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b40:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b44:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b49:	68 a0 2d 11 80       	push   $0x80112da0
80103b4e:	e8 7d 08 00 00       	call   801043d0 <acquire>
80103b53:	83 c4 10             	add    $0x10,%esp
80103b56:	eb 16                	jmp    80103b6e <scheduler+0x3e>
80103b58:	90                   	nop
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b60:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103b66:	81 fb d4 50 11 80    	cmp    $0x801150d4,%ebx
80103b6c:	74 52                	je     80103bc0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103b6e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b72:	75 ec                	jne    80103b60 <scheduler+0x30>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b74:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103b77:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103b7e:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b7f:	81 c3 8c 00 00 00    	add    $0x8c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b85:	e8 26 30 00 00       	call   80106bb0 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103b8a:	58                   	pop    %eax
80103b8b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b91:	c7 43 80 04 00 00 00 	movl   $0x4,-0x80(%ebx)
      swtch(&cpu->scheduler, p->context);
80103b98:	5a                   	pop    %edx
80103b99:	ff 73 90             	pushl  -0x70(%ebx)
80103b9c:	83 c0 04             	add    $0x4,%eax
80103b9f:	50                   	push   %eax
80103ba0:	e8 b6 0c 00 00       	call   8010485b <swtch>
      switchkvm();
80103ba5:	e8 e6 2f 00 00       	call   80106b90 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103baa:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bad:	81 fb d4 50 11 80    	cmp    $0x801150d4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103bb3:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103bba:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bbe:	75 ae                	jne    80103b6e <scheduler+0x3e>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	68 a0 2d 11 80       	push   $0x80112da0
80103bc8:	e8 e3 09 00 00       	call   801045b0 <release>

  }
80103bcd:	83 c4 10             	add    $0x10,%esp
80103bd0:	e9 6b ff ff ff       	jmp    80103b40 <scheduler+0x10>
80103bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103be0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	53                   	push   %ebx
80103be4:	83 ec 10             	sub    $0x10,%esp
  int intena;

  if(!holding(&ptable.lock))
80103be7:	68 a0 2d 11 80       	push   $0x80112da0
80103bec:	e8 0f 09 00 00       	call   80104500 <holding>
80103bf1:	83 c4 10             	add    $0x10,%esp
80103bf4:	85 c0                	test   %eax,%eax
80103bf6:	74 4c                	je     80103c44 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103bf8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103bff:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103c06:	75 63                	jne    80103c6b <sched+0x8b>
    panic("sched locks");
  if(proc->state == RUNNING)
80103c08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c0e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103c12:	74 4a                	je     80103c5e <sched+0x7e>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c14:	9c                   	pushf  
80103c15:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103c16:	80 e5 02             	and    $0x2,%ch
80103c19:	75 36                	jne    80103c51 <sched+0x71>
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
80103c1b:	83 ec 08             	sub    $0x8,%esp
80103c1e:	83 c0 1c             	add    $0x1c,%eax
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
80103c21:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80103c27:	ff 72 04             	pushl  0x4(%edx)
80103c2a:	50                   	push   %eax
80103c2b:	e8 2b 0c 00 00       	call   8010485b <swtch>
  cpu->intena = intena;
80103c30:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103c36:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
80103c39:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c42:	c9                   	leave  
80103c43:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c44:	83 ec 0c             	sub    $0xc,%esp
80103c47:	68 b8 76 10 80       	push   $0x801076b8
80103c4c:	e8 1f c7 ff ff       	call   80100370 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c51:	83 ec 0c             	sub    $0xc,%esp
80103c54:	68 e4 76 10 80       	push   $0x801076e4
80103c59:	e8 12 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103c5e:	83 ec 0c             	sub    $0xc,%esp
80103c61:	68 d6 76 10 80       	push   $0x801076d6
80103c66:	e8 05 c7 ff ff       	call   80100370 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103c6b:	83 ec 0c             	sub    $0xc,%esp
80103c6e:	68 ca 76 10 80       	push   $0x801076ca
80103c73:	e8 f8 c6 ff ff       	call   80100370 <panic>
80103c78:	90                   	nop
80103c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c80 <exit>:
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c80:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c87:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c8d:	55                   	push   %ebp
80103c8e:	89 e5                	mov    %esp,%ebp
80103c90:	56                   	push   %esi
80103c91:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c92:	0f 84 34 01 00 00    	je     80103dcc <exit+0x14c>
80103c98:	31 db                	xor    %ebx,%ebx
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103ca0:	8d 73 08             	lea    0x8(%ebx),%esi
80103ca3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103ca7:	85 c0                	test   %eax,%eax
80103ca9:	74 1b                	je     80103cc6 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103cab:	83 ec 0c             	sub    $0xc,%esp
80103cae:	50                   	push   %eax
80103caf:	e8 6c d1 ff ff       	call   80100e20 <fileclose>
      proc->ofile[fd] = 0;
80103cb4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103cbb:	83 c4 10             	add    $0x10,%esp
80103cbe:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103cc5:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103cc6:	83 c3 01             	add    $0x1,%ebx
80103cc9:	83 fb 10             	cmp    $0x10,%ebx
80103ccc:	75 d2                	jne    80103ca0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103cce:	e8 ed ee ff ff       	call   80102bc0 <begin_op>
  iput(proc->cwd);
80103cd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cd9:	83 ec 0c             	sub    $0xc,%esp
80103cdc:	ff 70 68             	pushl  0x68(%eax)
80103cdf:	e8 ac da ff ff       	call   80101790 <iput>
  end_op();
80103ce4:	e8 47 ef ff ff       	call   80102c30 <end_op>
  proc->cwd = 0;
80103ce9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cef:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103cf6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103cfd:	e8 ce 06 00 00       	call   801043d0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d02:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103d09:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d0c:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d11:	8b 51 14             	mov    0x14(%ecx),%edx
80103d14:	eb 16                	jmp    80103d2c <exit+0xac>
80103d16:	8d 76 00             	lea    0x0(%esi),%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d20:	05 8c 00 00 00       	add    $0x8c,%eax
80103d25:	3d d4 50 11 80       	cmp    $0x801150d4,%eax
80103d2a:	74 1e                	je     80103d4a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
80103d2c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d30:	75 ee                	jne    80103d20 <exit+0xa0>
80103d32:	3b 50 20             	cmp    0x20(%eax),%edx
80103d35:	75 e9                	jne    80103d20 <exit+0xa0>
      p->state = RUNNABLE;
80103d37:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d3e:	05 8c 00 00 00       	add    $0x8c,%eax
80103d43:	3d d4 50 11 80       	cmp    $0x801150d4,%eax
80103d48:	75 e2                	jne    80103d2c <exit+0xac>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d4a:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103d50:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103d55:	eb 17                	jmp    80103d6e <exit+0xee>
80103d57:	89 f6                	mov    %esi,%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d60:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103d66:	81 fa d4 50 11 80    	cmp    $0x801150d4,%edx
80103d6c:	74 3a                	je     80103da8 <exit+0x128>
    if(p->parent == proc){
80103d6e:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103d71:	75 ed                	jne    80103d60 <exit+0xe0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d73:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d77:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d7a:	75 e4                	jne    80103d60 <exit+0xe0>
80103d7c:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103d81:	eb 11                	jmp    80103d94 <exit+0x114>
80103d83:	90                   	nop
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d88:	05 8c 00 00 00       	add    $0x8c,%eax
80103d8d:	3d d4 50 11 80       	cmp    $0x801150d4,%eax
80103d92:	74 cc                	je     80103d60 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80103d94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d98:	75 ee                	jne    80103d88 <exit+0x108>
80103d9a:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d9d:	75 e9                	jne    80103d88 <exit+0x108>
      p->state = RUNNABLE;
80103d9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103da6:	eb e0                	jmp    80103d88 <exit+0x108>

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;

  //updating end time
  proc->etime = ticks;
80103da8:	a1 20 59 11 80       	mov    0x80115920,%eax
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103dad:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)

  //updating end time
  proc->etime = ticks;
80103db4:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
  sched();
80103dba:	e8 21 fe ff ff       	call   80103be0 <sched>
  panic("zombie exit");
80103dbf:	83 ec 0c             	sub    $0xc,%esp
80103dc2:	68 05 77 10 80       	push   $0x80107705
80103dc7:	e8 a4 c5 ff ff       	call   80100370 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103dcc:	83 ec 0c             	sub    $0xc,%esp
80103dcf:	68 f8 76 10 80       	push   $0x801076f8
80103dd4:	e8 97 c5 ff ff       	call   80100370 <panic>
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103de0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103de6:	68 a0 2d 11 80       	push   $0x80112da0
80103deb:	e8 e0 05 00 00       	call   801043d0 <acquire>
  proc->state = RUNNABLE;
80103df0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103df6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103dfd:	e8 de fd ff ff       	call   80103be0 <sched>
  release(&ptable.lock);
80103e02:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e09:	e8 a2 07 00 00       	call   801045b0 <release>
}
80103e0e:	83 c4 10             	add    $0x10,%esp
80103e11:	c9                   	leave  
80103e12:	c3                   	ret    
80103e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
80103e20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e26:	55                   	push   %ebp
80103e27:	89 e5                	mov    %esp,%ebp
80103e29:	56                   	push   %esi
80103e2a:	53                   	push   %ebx
  if(proc == 0)
80103e2b:	85 c0                	test   %eax,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e2d:	8b 75 08             	mov    0x8(%ebp),%esi
80103e30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103e33:	0f 84 97 00 00 00    	je     80103ed0 <sleep+0xb0>
    panic("sleep");

  if(lk == 0)
80103e39:	85 db                	test   %ebx,%ebx
80103e3b:	0f 84 82 00 00 00    	je     80103ec3 <sleep+0xa3>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e41:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103e47:	74 57                	je     80103ea0 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e49:	83 ec 0c             	sub    $0xc,%esp
80103e4c:	68 a0 2d 11 80       	push   $0x80112da0
80103e51:	e8 7a 05 00 00       	call   801043d0 <acquire>
    release(lk);
80103e56:	89 1c 24             	mov    %ebx,(%esp)
80103e59:	e8 52 07 00 00       	call   801045b0 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103e5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e64:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e67:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e6e:	e8 6d fd ff ff       	call   80103be0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e79:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e80:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e87:	e8 24 07 00 00       	call   801045b0 <release>
    acquire(lk);
80103e8c:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e8f:	83 c4 10             	add    $0x10,%esp
  }
}
80103e92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e95:	5b                   	pop    %ebx
80103e96:	5e                   	pop    %esi
80103e97:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e98:	e9 33 05 00 00       	jmp    801043d0 <acquire>
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103ea0:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103ea3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103eaa:	e8 31 fd ff ff       	call   80103be0 <sched>

  // Tidy up.
  proc->chan = 0;
80103eaf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103eb5:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103ebc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ebf:	5b                   	pop    %ebx
80103ec0:	5e                   	pop    %esi
80103ec1:	5d                   	pop    %ebp
80103ec2:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103ec3:	83 ec 0c             	sub    $0xc,%esp
80103ec6:	68 17 77 10 80       	push   $0x80107717
80103ecb:	e8 a0 c4 ff ff       	call   80100370 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103ed0:	83 ec 0c             	sub    $0xc,%esp
80103ed3:	68 11 77 10 80       	push   $0x80107711
80103ed8:	e8 93 c4 ff ff       	call   80100370 <panic>
80103edd:	8d 76 00             	lea    0x0(%esi),%esi

80103ee0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103ee5:	83 ec 0c             	sub    $0xc,%esp
80103ee8:	68 a0 2d 11 80       	push   $0x80112da0
80103eed:	e8 de 04 00 00       	call   801043d0 <acquire>
80103ef2:	83 c4 10             	add    $0x10,%esp
80103ef5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103efb:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efd:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103f02:	eb 12                	jmp    80103f16 <wait+0x36>
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f08:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103f0e:	81 fb d4 50 11 80    	cmp    $0x801150d4,%ebx
80103f14:	74 22                	je     80103f38 <wait+0x58>
      if(p->parent != proc)
80103f16:	3b 43 14             	cmp    0x14(%ebx),%eax
80103f19:	75 ed                	jne    80103f08 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103f1b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f1f:	74 35                	je     80103f56 <wait+0x76>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f21:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103f27:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f2c:	81 fb d4 50 11 80    	cmp    $0x801150d4,%ebx
80103f32:	75 e2                	jne    80103f16 <wait+0x36>
80103f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103f38:	85 d2                	test   %edx,%edx
80103f3a:	74 70                	je     80103fac <wait+0xcc>
80103f3c:	8b 50 24             	mov    0x24(%eax),%edx
80103f3f:	85 d2                	test   %edx,%edx
80103f41:	75 69                	jne    80103fac <wait+0xcc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103f43:	83 ec 08             	sub    $0x8,%esp
80103f46:	68 a0 2d 11 80       	push   $0x80112da0
80103f4b:	50                   	push   %eax
80103f4c:	e8 cf fe ff ff       	call   80103e20 <sleep>
  }
80103f51:	83 c4 10             	add    $0x10,%esp
80103f54:	eb 9f                	jmp    80103ef5 <wait+0x15>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f56:	83 ec 0c             	sub    $0xc,%esp
80103f59:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f5c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f5f:	e8 6c e3 ff ff       	call   801022d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f64:	59                   	pop    %ecx
80103f65:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f68:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f6f:	e8 4c 2f 00 00       	call   80106ec0 <freevm>
        p->pid = 0;
80103f74:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f7b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f82:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f86:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f8d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f94:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f9b:	e8 10 06 00 00       	call   801045b0 <release>
        return pid;
80103fa0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103fa6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fa8:	5b                   	pop    %ebx
80103fa9:	5e                   	pop    %esi
80103faa:	5d                   	pop    %ebp
80103fab:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	68 a0 2d 11 80       	push   $0x80112da0
80103fb4:	e8 f7 05 00 00       	call   801045b0 <release>
      return -1;
80103fb9:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fc4:	5b                   	pop    %ebx
80103fc5:	5e                   	pop    %esi
80103fc6:	5d                   	pop    %ebp
80103fc7:	c3                   	ret    
80103fc8:	90                   	nop
80103fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fd0 <waitx>:

int
waitx(int *wtime, int *rtime)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103fd5:	83 ec 0c             	sub    $0xc,%esp
80103fd8:	68 a0 2d 11 80       	push   $0x80112da0
80103fdd:	e8 ee 03 00 00       	call   801043d0 <acquire>
80103fe2:	83 c4 10             	add    $0x10,%esp
80103fe5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80103feb:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fed:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103ff2:	eb 12                	jmp    80104006 <waitx+0x36>
80103ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103ffe:	81 fb d4 50 11 80    	cmp    $0x801150d4,%ebx
80104004:	74 22                	je     80104028 <waitx+0x58>
      if(p->parent != proc)
80104006:	39 43 14             	cmp    %eax,0x14(%ebx)
80104009:	75 ed                	jne    80103ff8 <waitx+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010400b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010400f:	74 3d                	je     8010404e <waitx+0x7e>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104011:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80104017:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401c:	81 fb d4 50 11 80    	cmp    $0x801150d4,%ebx
80104022:	75 e2                	jne    80104006 <waitx+0x36>
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104028:	85 d2                	test   %edx,%edx
8010402a:	0f 84 99 00 00 00    	je     801040c9 <waitx+0xf9>
80104030:	8b 50 24             	mov    0x24(%eax),%edx
80104033:	85 d2                	test   %edx,%edx
80104035:	0f 85 8e 00 00 00    	jne    801040c9 <waitx+0xf9>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010403b:	83 ec 08             	sub    $0x8,%esp
8010403e:	68 a0 2d 11 80       	push   $0x80112da0
80104043:	50                   	push   %eax
80104044:	e8 d7 fd ff ff       	call   80103e20 <sleep>
  }
80104049:	83 c4 10             	add    $0x10,%esp
8010404c:	eb 97                	jmp    80103fe5 <waitx+0x15>
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.

        // Added time field update, else same from wait system call
        *wtime = p->etime - p->stime - p->rtime - p->iotime;
8010404e:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104054:	2b 43 7c             	sub    0x7c(%ebx),%eax
        *rtime = p->rtime;

        // same as wait
        pid = p->pid;
        kfree(p->kstack);
80104057:	83 ec 0c             	sub    $0xc,%esp
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.

        // Added time field update, else same from wait system call
        *wtime = p->etime - p->stime - p->rtime - p->iotime;
8010405a:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104060:	8b 55 08             	mov    0x8(%ebp),%edx
80104063:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80104069:	89 02                	mov    %eax,(%edx)
        *rtime = p->rtime;
8010406b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010406e:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80104074:	89 10                	mov    %edx,(%eax)

        // same as wait
        pid = p->pid;
        kfree(p->kstack);
80104076:	ff 73 08             	pushl  0x8(%ebx)
        // Added time field update, else same from wait system call
        *wtime = p->etime - p->stime - p->rtime - p->iotime;
        *rtime = p->rtime;

        // same as wait
        pid = p->pid;
80104079:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010407c:	e8 4f e2 ff ff       	call   801022d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104081:	59                   	pop    %ecx
80104082:	ff 73 04             	pushl  0x4(%ebx)
        *rtime = p->rtime;

        // same as wait
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104085:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010408c:	e8 2f 2e 00 00       	call   80106ec0 <freevm>
        p->state = UNUSED;
80104091:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
80104098:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010409f:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040a6:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040aa:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        release(&ptable.lock);
801040b1:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801040b8:	e8 f3 04 00 00       	call   801045b0 <release>
        return pid;
801040bd:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
801040c3:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040c5:	5b                   	pop    %ebx
801040c6:	5e                   	pop    %esi
801040c7:	5d                   	pop    %ebp
801040c8:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
801040c9:	83 ec 0c             	sub    $0xc,%esp
801040cc:	68 a0 2d 11 80       	push   $0x80112da0
801040d1:	e8 da 04 00 00       	call   801045b0 <release>
      return -1;
801040d6:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
801040dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5d                   	pop    %ebp
801040e4:	c3                   	ret    
801040e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 10             	sub    $0x10,%esp
801040f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040fa:	68 a0 2d 11 80       	push   $0x80112da0
801040ff:	e8 cc 02 00 00       	call   801043d0 <acquire>
80104104:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104107:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010410c:	eb 0e                	jmp    8010411c <wakeup+0x2c>
8010410e:	66 90                	xchg   %ax,%ax
80104110:	05 8c 00 00 00       	add    $0x8c,%eax
80104115:	3d d4 50 11 80       	cmp    $0x801150d4,%eax
8010411a:	74 1e                	je     8010413a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010411c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104120:	75 ee                	jne    80104110 <wakeup+0x20>
80104122:	3b 58 20             	cmp    0x20(%eax),%ebx
80104125:	75 e9                	jne    80104110 <wakeup+0x20>
      p->state = RUNNABLE;
80104127:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010412e:	05 8c 00 00 00       	add    $0x8c,%eax
80104133:	3d d4 50 11 80       	cmp    $0x801150d4,%eax
80104138:	75 e2                	jne    8010411c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010413a:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80104141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104144:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104145:	e9 66 04 00 00       	jmp    801045b0 <release>
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
80104157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010415a:	68 a0 2d 11 80       	push   $0x80112da0
8010415f:	e8 6c 02 00 00       	call   801043d0 <acquire>
80104164:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104167:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010416c:	eb 0e                	jmp    8010417c <kill+0x2c>
8010416e:	66 90                	xchg   %ax,%ax
80104170:	05 8c 00 00 00       	add    $0x8c,%eax
80104175:	3d d4 50 11 80       	cmp    $0x801150d4,%eax
8010417a:	74 3c                	je     801041b8 <kill+0x68>
    if(p->pid == pid){
8010417c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010417f:	75 ef                	jne    80104170 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104181:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104185:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010418c:	74 1a                	je     801041a8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010418e:	83 ec 0c             	sub    $0xc,%esp
80104191:	68 a0 2d 11 80       	push   $0x80112da0
80104196:	e8 15 04 00 00       	call   801045b0 <release>
      return 0;
8010419b:	83 c4 10             	add    $0x10,%esp
8010419e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801041a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a3:	c9                   	leave  
801041a4:	c3                   	ret    
801041a5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801041a8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041af:	eb dd                	jmp    8010418e <kill+0x3e>
801041b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	68 a0 2d 11 80       	push   $0x80112da0
801041c0:	e8 eb 03 00 00       	call   801045b0 <release>
  return -1;
801041c5:	83 c4 10             	add    $0x10,%esp
801041c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d0:	c9                   	leave  
801041d1:	c3                   	ret    
801041d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041e9:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
801041ee:	83 ec 3c             	sub    $0x3c,%esp
801041f1:	eb 27                	jmp    8010421a <procdump+0x3a>
801041f3:	90                   	nop
801041f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 66 76 10 80       	push   $0x80107666
80104200:	e8 5b c4 ff ff       	call   80100660 <cprintf>
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010420e:	81 fb 40 51 11 80    	cmp    $0x80115140,%ebx
80104214:	0f 84 7e 00 00 00    	je     80104298 <procdump+0xb8>
    if(p->state == UNUSED)
8010421a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010421d:	85 c0                	test   %eax,%eax
8010421f:	74 e7                	je     80104208 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104221:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104224:	ba 28 77 10 80       	mov    $0x80107728,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104229:	77 11                	ja     8010423c <procdump+0x5c>
8010422b:	8b 14 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104232:	b8 28 77 10 80       	mov    $0x80107728,%eax
80104237:	85 d2                	test   %edx,%edx
80104239:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010423c:	53                   	push   %ebx
8010423d:	52                   	push   %edx
8010423e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104241:	68 2c 77 10 80       	push   $0x8010772c
80104246:	e8 15 c4 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010424b:	83 c4 10             	add    $0x10,%esp
8010424e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104252:	75 a4                	jne    801041f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104254:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104257:	83 ec 08             	sub    $0x8,%esp
8010425a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010425d:	50                   	push   %eax
8010425e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104261:	8b 40 0c             	mov    0xc(%eax),%eax
80104264:	83 c0 08             	add    $0x8,%eax
80104267:	50                   	push   %eax
80104268:	e8 33 02 00 00       	call   801044a0 <getcallerpcs>
8010426d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104270:	8b 17                	mov    (%edi),%edx
80104272:	85 d2                	test   %edx,%edx
80104274:	74 82                	je     801041f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104276:	83 ec 08             	sub    $0x8,%esp
80104279:	83 c7 04             	add    $0x4,%edi
8010427c:	52                   	push   %edx
8010427d:	68 89 71 10 80       	push   $0x80107189
80104282:	e8 d9 c3 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	39 f7                	cmp    %esi,%edi
8010428c:	75 e2                	jne    80104270 <procdump+0x90>
8010428e:	e9 65 ff ff ff       	jmp    801041f8 <procdump+0x18>
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010429b:	5b                   	pop    %ebx
8010429c:	5e                   	pop    %esi
8010429d:	5f                   	pop    %edi
8010429e:	5d                   	pop    %ebp
8010429f:	c3                   	ret    

801042a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 0c             	sub    $0xc,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042aa:	68 78 77 10 80       	push   $0x80107778
801042af:	8d 43 04             	lea    0x4(%ebx),%eax
801042b2:	50                   	push   %eax
801042b3:	e8 f8 00 00 00       	call   801043b0 <initlock>
  lk->name = name;
801042b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042c1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801042c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801042cb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801042ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d1:	c9                   	leave  
801042d2:	c3                   	ret    
801042d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	56                   	push   %esi
801042e4:	53                   	push   %ebx
801042e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	8d 73 04             	lea    0x4(%ebx),%esi
801042ee:	56                   	push   %esi
801042ef:	e8 dc 00 00 00       	call   801043d0 <acquire>
  while (lk->locked) {
801042f4:	8b 13                	mov    (%ebx),%edx
801042f6:	83 c4 10             	add    $0x10,%esp
801042f9:	85 d2                	test   %edx,%edx
801042fb:	74 16                	je     80104313 <acquiresleep+0x33>
801042fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104300:	83 ec 08             	sub    $0x8,%esp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	e8 16 fb ff ff       	call   80103e20 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010430a:	8b 03                	mov    (%ebx),%eax
8010430c:	83 c4 10             	add    $0x10,%esp
8010430f:	85 c0                	test   %eax,%eax
80104311:	75 ed                	jne    80104300 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104313:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
80104319:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431f:	8b 40 10             	mov    0x10(%eax),%eax
80104322:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104325:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104328:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010432b:	5b                   	pop    %ebx
8010432c:	5e                   	pop    %esi
8010432d:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
8010432e:	e9 7d 02 00 00       	jmp    801045b0 <release>
80104333:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104340 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
80104345:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	8d 73 04             	lea    0x4(%ebx),%esi
8010434e:	56                   	push   %esi
8010434f:	e8 7c 00 00 00       	call   801043d0 <acquire>
  lk->locked = 0;
80104354:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010435a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104361:	89 1c 24             	mov    %ebx,(%esp)
80104364:	e8 87 fd ff ff       	call   801040f0 <wakeup>
  release(&lk->lk);
80104369:	89 75 08             	mov    %esi,0x8(%ebp)
8010436c:	83 c4 10             	add    $0x10,%esp
}
8010436f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104372:	5b                   	pop    %ebx
80104373:	5e                   	pop    %esi
80104374:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104375:	e9 36 02 00 00       	jmp    801045b0 <release>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104380 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010438e:	53                   	push   %ebx
8010438f:	e8 3c 00 00 00       	call   801043d0 <acquire>
  r = lk->locked;
80104394:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104396:	89 1c 24             	mov    %ebx,(%esp)
80104399:	e8 12 02 00 00       	call   801045b0 <release>
  return r;
}
8010439e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a1:	89 f0                	mov    %esi,%eax
801043a3:	5b                   	pop    %ebx
801043a4:	5e                   	pop    %esi
801043a5:	5d                   	pop    %ebp
801043a6:	c3                   	ret    
801043a7:	66 90                	xchg   %ax,%ax
801043a9:	66 90                	xchg   %ax,%ax
801043ab:	66 90                	xchg   %ax,%ax
801043ad:	66 90                	xchg   %ax,%ax
801043af:	90                   	nop

801043b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801043bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801043c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043c9:	5d                   	pop    %ebp
801043ca:	c3                   	ret    
801043cb:	90                   	nop
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043d0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
801043d4:	83 ec 04             	sub    $0x4,%esp
801043d7:	9c                   	pushf  
801043d8:	5a                   	pop    %edx
}

static inline void
cli(void)
{
  asm volatile("cli");
801043d9:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801043da:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801043e1:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
801043e7:	85 c0                	test   %eax,%eax
801043e9:	75 0c                	jne    801043f7 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
801043eb:	81 e2 00 02 00 00    	and    $0x200,%edx
801043f1:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801043f7:	8b 55 08             	mov    0x8(%ebp),%edx

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
    cpu->intena = eflags & FL_IF;
  cpu->ncli += 1;
801043fa:	83 c0 01             	add    $0x1,%eax
801043fd:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104403:	8b 02                	mov    (%edx),%eax
80104405:	85 c0                	test   %eax,%eax
80104407:	74 05                	je     8010440e <acquire+0x3e>
80104409:	39 4a 08             	cmp    %ecx,0x8(%edx)
8010440c:	74 7a                	je     80104488 <acquire+0xb8>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010440e:	b9 01 00 00 00       	mov    $0x1,%ecx
80104413:	90                   	nop
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104418:	89 c8                	mov    %ecx,%eax
8010441a:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010441d:	85 c0                	test   %eax,%eax
8010441f:	75 f7                	jne    80104418 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104421:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104426:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104429:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010442f:	89 ea                	mov    %ebp,%edx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104431:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
80104434:	83 c1 0c             	add    $0xc,%ecx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104437:	31 c0                	xor    %eax,%eax
80104439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104440:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104446:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010444c:	77 1a                	ja     80104468 <acquire+0x98>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010444e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104451:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104454:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104457:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104459:	83 f8 0a             	cmp    $0xa,%eax
8010445c:	75 e2                	jne    80104440 <acquire+0x70>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  getcallerpcs(&lk, lk->pcs);
}
8010445e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104461:	c9                   	leave  
80104462:	c3                   	ret    
80104463:	90                   	nop
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104468:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010446f:	83 c0 01             	add    $0x1,%eax
80104472:	83 f8 0a             	cmp    $0xa,%eax
80104475:	74 e7                	je     8010445e <acquire+0x8e>
    pcs[i] = 0;
80104477:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010447e:	83 c0 01             	add    $0x1,%eax
80104481:	83 f8 0a             	cmp    $0xa,%eax
80104484:	75 e2                	jne    80104468 <acquire+0x98>
80104486:	eb d6                	jmp    8010445e <acquire+0x8e>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104488:	83 ec 0c             	sub    $0xc,%esp
8010448b:	68 83 77 10 80       	push   $0x80107783
80104490:	e8 db be ff ff       	call   80100370 <panic>
80104495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801044a4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801044aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801044ad:	31 c0                	xor    %eax,%eax
801044af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801044b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044bc:	77 1a                	ja     801044d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044be:	8b 5a 04             	mov    0x4(%edx),%ebx
801044c1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044c4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801044c7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044c9:	83 f8 0a             	cmp    $0xa,%eax
801044cc:	75 e2                	jne    801044b0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044ce:	5b                   	pop    %ebx
801044cf:	5d                   	pop    %ebp
801044d0:	c3                   	ret    
801044d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801044d8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801044df:	83 c0 01             	add    $0x1,%eax
801044e2:	83 f8 0a             	cmp    $0xa,%eax
801044e5:	74 e7                	je     801044ce <getcallerpcs+0x2e>
    pcs[i] = 0;
801044e7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801044ee:	83 c0 01             	add    $0x1,%eax
801044f1:	83 f8 0a             	cmp    $0xa,%eax
801044f4:	75 e2                	jne    801044d8 <getcallerpcs+0x38>
801044f6:	eb d6                	jmp    801044ce <getcallerpcs+0x2e>
801044f8:	90                   	nop
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104500 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104506:	8b 02                	mov    (%edx),%eax
80104508:	85 c0                	test   %eax,%eax
8010450a:	74 14                	je     80104520 <holding+0x20>
8010450c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104512:	39 42 08             	cmp    %eax,0x8(%edx)
}
80104515:	5d                   	pop    %ebp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104516:	0f 94 c0             	sete   %al
80104519:	0f b6 c0             	movzbl %al,%eax
}
8010451c:	c3                   	ret    
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
80104520:	31 c0                	xor    %eax,%eax
80104522:	5d                   	pop    %ebp
80104523:	c3                   	ret    
80104524:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010452a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104530 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104533:	9c                   	pushf  
80104534:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104535:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104536:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010453d:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104543:	85 c0                	test   %eax,%eax
80104545:	75 0c                	jne    80104553 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
80104547:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010454d:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
80104553:	83 c0 01             	add    $0x1,%eax
80104556:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
8010455c:	5d                   	pop    %ebp
8010455d:	c3                   	ret    
8010455e:	66 90                	xchg   %ax,%ax

80104560 <popcli>:

void
popcli(void)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104566:	9c                   	pushf  
80104567:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104568:	f6 c4 02             	test   $0x2,%ah
8010456b:	75 2c                	jne    80104599 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010456d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104574:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
8010457b:	78 0f                	js     8010458c <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
8010457d:	75 0b                	jne    8010458a <popcli+0x2a>
8010457f:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104585:	85 c0                	test   %eax,%eax
80104587:	74 01                	je     8010458a <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104589:	fb                   	sti    
    sti();
}
8010458a:	c9                   	leave  
8010458b:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
8010458c:	83 ec 0c             	sub    $0xc,%esp
8010458f:	68 a2 77 10 80       	push   $0x801077a2
80104594:	e8 d7 bd ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104599:	83 ec 0c             	sub    $0xc,%esp
8010459c:	68 8b 77 10 80       	push   $0x8010778b
801045a1:	e8 ca bd ff ff       	call   80100370 <panic>
801045a6:	8d 76 00             	lea    0x0(%esi),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	83 ec 08             	sub    $0x8,%esp
801045b6:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801045b9:	8b 10                	mov    (%eax),%edx
801045bb:	85 d2                	test   %edx,%edx
801045bd:	74 0c                	je     801045cb <release+0x1b>
801045bf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801045c6:	39 50 08             	cmp    %edx,0x8(%eax)
801045c9:	74 15                	je     801045e0 <release+0x30>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	68 a9 77 10 80       	push   $0x801077a9
801045d3:	e8 98 bd ff ff       	call   80100370 <panic>
801045d8:	90                   	nop
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  lk->pcs[0] = 0;
801045e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801045e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801045ee:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
801045f9:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801045fa:	e9 61 ff ff ff       	jmp    80104560 <popcli>
801045ff:	90                   	nop

80104600 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	53                   	push   %ebx
80104605:	8b 55 08             	mov    0x8(%ebp),%edx
80104608:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010460b:	f6 c2 03             	test   $0x3,%dl
8010460e:	75 05                	jne    80104615 <memset+0x15>
80104610:	f6 c1 03             	test   $0x3,%cl
80104613:	74 13                	je     80104628 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104615:	89 d7                	mov    %edx,%edi
80104617:	8b 45 0c             	mov    0xc(%ebp),%eax
8010461a:	fc                   	cld    
8010461b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010461d:	5b                   	pop    %ebx
8010461e:	89 d0                	mov    %edx,%eax
80104620:	5f                   	pop    %edi
80104621:	5d                   	pop    %ebp
80104622:	c3                   	ret    
80104623:	90                   	nop
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104628:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010462c:	c1 e9 02             	shr    $0x2,%ecx
8010462f:	89 fb                	mov    %edi,%ebx
80104631:	89 f8                	mov    %edi,%eax
80104633:	c1 e3 18             	shl    $0x18,%ebx
80104636:	c1 e0 10             	shl    $0x10,%eax
80104639:	09 d8                	or     %ebx,%eax
8010463b:	09 f8                	or     %edi,%eax
8010463d:	c1 e7 08             	shl    $0x8,%edi
80104640:	09 f8                	or     %edi,%eax
80104642:	89 d7                	mov    %edx,%edi
80104644:	fc                   	cld    
80104645:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104647:	5b                   	pop    %ebx
80104648:	89 d0                	mov    %edx,%eax
8010464a:	5f                   	pop    %edi
8010464b:	5d                   	pop    %ebp
8010464c:	c3                   	ret    
8010464d:	8d 76 00             	lea    0x0(%esi),%esi

80104650 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	56                   	push   %esi
80104655:	8b 45 10             	mov    0x10(%ebp),%eax
80104658:	53                   	push   %ebx
80104659:	8b 75 0c             	mov    0xc(%ebp),%esi
8010465c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010465f:	85 c0                	test   %eax,%eax
80104661:	74 29                	je     8010468c <memcmp+0x3c>
    if(*s1 != *s2)
80104663:	0f b6 13             	movzbl (%ebx),%edx
80104666:	0f b6 0e             	movzbl (%esi),%ecx
80104669:	38 d1                	cmp    %dl,%cl
8010466b:	75 2b                	jne    80104698 <memcmp+0x48>
8010466d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104670:	31 c0                	xor    %eax,%eax
80104672:	eb 14                	jmp    80104688 <memcmp+0x38>
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104678:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010467d:	83 c0 01             	add    $0x1,%eax
80104680:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104684:	38 ca                	cmp    %cl,%dl
80104686:	75 10                	jne    80104698 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104688:	39 f8                	cmp    %edi,%eax
8010468a:	75 ec                	jne    80104678 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010468c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010468d:	31 c0                	xor    %eax,%eax
}
8010468f:	5e                   	pop    %esi
80104690:	5f                   	pop    %edi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104698:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010469b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010469c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010469e:	5e                   	pop    %esi
8010469f:	5f                   	pop    %edi
801046a0:	5d                   	pop    %ebp
801046a1:	c3                   	ret    
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	8b 45 08             	mov    0x8(%ebp),%eax
801046b8:	8b 75 0c             	mov    0xc(%ebp),%esi
801046bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801046be:	39 c6                	cmp    %eax,%esi
801046c0:	73 2e                	jae    801046f0 <memmove+0x40>
801046c2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801046c5:	39 c8                	cmp    %ecx,%eax
801046c7:	73 27                	jae    801046f0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801046c9:	85 db                	test   %ebx,%ebx
801046cb:	8d 53 ff             	lea    -0x1(%ebx),%edx
801046ce:	74 17                	je     801046e7 <memmove+0x37>
      *--d = *--s;
801046d0:	29 d9                	sub    %ebx,%ecx
801046d2:	89 cb                	mov    %ecx,%ebx
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801046df:	83 ea 01             	sub    $0x1,%edx
801046e2:	83 fa ff             	cmp    $0xffffffff,%edx
801046e5:	75 f1                	jne    801046d8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046e7:	5b                   	pop    %ebx
801046e8:	5e                   	pop    %esi
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    
801046eb:	90                   	nop
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801046f0:	31 d2                	xor    %edx,%edx
801046f2:	85 db                	test   %ebx,%ebx
801046f4:	74 f1                	je     801046e7 <memmove+0x37>
801046f6:	8d 76 00             	lea    0x0(%esi),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104700:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104704:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104707:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010470a:	39 d3                	cmp    %edx,%ebx
8010470c:	75 f2                	jne    80104700 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010470e:	5b                   	pop    %ebx
8010470f:	5e                   	pop    %esi
80104710:	5d                   	pop    %ebp
80104711:	c3                   	ret    
80104712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104720 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104723:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104724:	eb 8a                	jmp    801046b0 <memmove>
80104726:	8d 76 00             	lea    0x0(%esi),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104738:	53                   	push   %ebx
80104739:	8b 7d 08             	mov    0x8(%ebp),%edi
8010473c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010473f:	85 c9                	test   %ecx,%ecx
80104741:	74 37                	je     8010477a <strncmp+0x4a>
80104743:	0f b6 17             	movzbl (%edi),%edx
80104746:	0f b6 1e             	movzbl (%esi),%ebx
80104749:	84 d2                	test   %dl,%dl
8010474b:	74 3f                	je     8010478c <strncmp+0x5c>
8010474d:	38 d3                	cmp    %dl,%bl
8010474f:	75 3b                	jne    8010478c <strncmp+0x5c>
80104751:	8d 47 01             	lea    0x1(%edi),%eax
80104754:	01 cf                	add    %ecx,%edi
80104756:	eb 1b                	jmp    80104773 <strncmp+0x43>
80104758:	90                   	nop
80104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104760:	0f b6 10             	movzbl (%eax),%edx
80104763:	84 d2                	test   %dl,%dl
80104765:	74 21                	je     80104788 <strncmp+0x58>
80104767:	0f b6 19             	movzbl (%ecx),%ebx
8010476a:	83 c0 01             	add    $0x1,%eax
8010476d:	89 ce                	mov    %ecx,%esi
8010476f:	38 da                	cmp    %bl,%dl
80104771:	75 19                	jne    8010478c <strncmp+0x5c>
80104773:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104775:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104778:	75 e6                	jne    80104760 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010477a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010477b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010477d:	5e                   	pop    %esi
8010477e:	5f                   	pop    %edi
8010477f:	5d                   	pop    %ebp
80104780:	c3                   	ret    
80104781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104788:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010478c:	0f b6 c2             	movzbl %dl,%eax
8010478f:	29 d8                	sub    %ebx,%eax
}
80104791:	5b                   	pop    %ebx
80104792:	5e                   	pop    %esi
80104793:	5f                   	pop    %edi
80104794:	5d                   	pop    %ebp
80104795:	c3                   	ret    
80104796:	8d 76 00             	lea    0x0(%esi),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	8b 45 08             	mov    0x8(%ebp),%eax
801047a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047ae:	89 c2                	mov    %eax,%edx
801047b0:	eb 19                	jmp    801047cb <strncpy+0x2b>
801047b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047b8:	83 c3 01             	add    $0x1,%ebx
801047bb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801047bf:	83 c2 01             	add    $0x1,%edx
801047c2:	84 c9                	test   %cl,%cl
801047c4:	88 4a ff             	mov    %cl,-0x1(%edx)
801047c7:	74 09                	je     801047d2 <strncpy+0x32>
801047c9:	89 f1                	mov    %esi,%ecx
801047cb:	85 c9                	test   %ecx,%ecx
801047cd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801047d0:	7f e6                	jg     801047b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801047d2:	31 c9                	xor    %ecx,%ecx
801047d4:	85 f6                	test   %esi,%esi
801047d6:	7e 17                	jle    801047ef <strncpy+0x4f>
801047d8:	90                   	nop
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801047e0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801047e4:	89 f3                	mov    %esi,%ebx
801047e6:	83 c1 01             	add    $0x1,%ecx
801047e9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801047eb:	85 db                	test   %ebx,%ebx
801047ed:	7f f1                	jg     801047e0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801047ef:	5b                   	pop    %ebx
801047f0:	5e                   	pop    %esi
801047f1:	5d                   	pop    %ebp
801047f2:	c3                   	ret    
801047f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104808:	8b 45 08             	mov    0x8(%ebp),%eax
8010480b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010480e:	85 c9                	test   %ecx,%ecx
80104810:	7e 26                	jle    80104838 <safestrcpy+0x38>
80104812:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104816:	89 c1                	mov    %eax,%ecx
80104818:	eb 17                	jmp    80104831 <safestrcpy+0x31>
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104820:	83 c2 01             	add    $0x1,%edx
80104823:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104827:	83 c1 01             	add    $0x1,%ecx
8010482a:	84 db                	test   %bl,%bl
8010482c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010482f:	74 04                	je     80104835 <safestrcpy+0x35>
80104831:	39 f2                	cmp    %esi,%edx
80104833:	75 eb                	jne    80104820 <safestrcpy+0x20>
    ;
  *s = 0;
80104835:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104838:	5b                   	pop    %ebx
80104839:	5e                   	pop    %esi
8010483a:	5d                   	pop    %ebp
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <strlen>:

int
strlen(const char *s)
{
80104840:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104841:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104843:	89 e5                	mov    %esp,%ebp
80104845:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104848:	80 3a 00             	cmpb   $0x0,(%edx)
8010484b:	74 0c                	je     80104859 <strlen+0x19>
8010484d:	8d 76 00             	lea    0x0(%esi),%esi
80104850:	83 c0 01             	add    $0x1,%eax
80104853:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104857:	75 f7                	jne    80104850 <strlen+0x10>
    ;
  return n;
}
80104859:	5d                   	pop    %ebp
8010485a:	c3                   	ret    

8010485b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010485b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010485f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104863:	55                   	push   %ebp
  pushl %ebx
80104864:	53                   	push   %ebx
  pushl %esi
80104865:	56                   	push   %esi
  pushl %edi
80104866:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104867:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104869:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010486b:	5f                   	pop    %edi
  popl %esi
8010486c:	5e                   	pop    %esi
  popl %ebx
8010486d:	5b                   	pop    %ebx
  popl %ebp
8010486e:	5d                   	pop    %ebp
  ret
8010486f:	c3                   	ret    

80104870 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104870:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104871:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104878:	89 e5                	mov    %esp,%ebp
8010487a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010487d:	8b 12                	mov    (%edx),%edx
8010487f:	39 c2                	cmp    %eax,%edx
80104881:	76 15                	jbe    80104898 <fetchint+0x28>
80104883:	8d 48 04             	lea    0x4(%eax),%ecx
80104886:	39 ca                	cmp    %ecx,%edx
80104888:	72 0e                	jb     80104898 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010488a:	8b 10                	mov    (%eax),%edx
8010488c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010488f:	89 10                	mov    %edx,(%eax)
  return 0;
80104891:	31 c0                	xor    %eax,%eax
}
80104893:	5d                   	pop    %ebp
80104894:	c3                   	ret    
80104895:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010489d:	5d                   	pop    %ebp
8010489e:	c3                   	ret    
8010489f:	90                   	nop

801048a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048a0:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
801048a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048a7:	89 e5                	mov    %esp,%ebp
801048a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
801048ac:	39 08                	cmp    %ecx,(%eax)
801048ae:	76 2c                	jbe    801048dc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801048b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801048b3:	89 c8                	mov    %ecx,%eax
801048b5:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801048b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048be:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801048c0:	39 d1                	cmp    %edx,%ecx
801048c2:	73 18                	jae    801048dc <fetchstr+0x3c>
    if(*s == 0)
801048c4:	80 39 00             	cmpb   $0x0,(%ecx)
801048c7:	75 0c                	jne    801048d5 <fetchstr+0x35>
801048c9:	eb 1d                	jmp    801048e8 <fetchstr+0x48>
801048cb:	90                   	nop
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048d0:	80 38 00             	cmpb   $0x0,(%eax)
801048d3:	74 13                	je     801048e8 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801048d5:	83 c0 01             	add    $0x1,%eax
801048d8:	39 c2                	cmp    %eax,%edx
801048da:	77 f4                	ja     801048d0 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
801048dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
801048e1:	5d                   	pop    %ebp
801048e2:	c3                   	ret    
801048e3:	90                   	nop
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
801048e8:	29 c8                	sub    %ecx,%eax
  return -1;
}
801048ea:	5d                   	pop    %ebp
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801048f0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048f7:	55                   	push   %ebp
801048f8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801048fa:	8b 42 18             	mov    0x18(%edx),%eax
801048fd:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104900:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104902:	8b 40 44             	mov    0x44(%eax),%eax
80104905:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104908:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010490b:	39 d1                	cmp    %edx,%ecx
8010490d:	73 19                	jae    80104928 <argint+0x38>
8010490f:	8d 48 08             	lea    0x8(%eax),%ecx
80104912:	39 ca                	cmp    %ecx,%edx
80104914:	72 12                	jb     80104928 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104916:	8b 50 04             	mov    0x4(%eax),%edx
80104919:	8b 45 0c             	mov    0xc(%ebp),%eax
8010491c:	89 10                	mov    %edx,(%eax)
  return 0;
8010491e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104920:	5d                   	pop    %ebp
80104921:	c3                   	ret    
80104922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010492d:	5d                   	pop    %ebp
8010492e:	c3                   	ret    
8010492f:	90                   	nop

80104930 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104930:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104936:	55                   	push   %ebp
80104937:	89 e5                	mov    %esp,%ebp
80104939:	56                   	push   %esi
8010493a:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010493b:	8b 48 18             	mov    0x18(%eax),%ecx
8010493e:	8b 5d 08             	mov    0x8(%ebp),%ebx
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104941:	8b 55 10             	mov    0x10(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104944:	8b 49 44             	mov    0x44(%ecx),%ecx
80104947:	8d 1c 99             	lea    (%ecx,%ebx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010494a:	8b 08                	mov    (%eax),%ecx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
8010494c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104951:	8d 73 04             	lea    0x4(%ebx),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104954:	39 ce                	cmp    %ecx,%esi
80104956:	73 1f                	jae    80104977 <argptr+0x47>
80104958:	8d 73 08             	lea    0x8(%ebx),%esi
8010495b:	39 f1                	cmp    %esi,%ecx
8010495d:	72 18                	jb     80104977 <argptr+0x47>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010495f:	85 d2                	test   %edx,%edx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104961:	8b 5b 04             	mov    0x4(%ebx),%ebx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104964:	78 11                	js     80104977 <argptr+0x47>
80104966:	39 cb                	cmp    %ecx,%ebx
80104968:	73 0d                	jae    80104977 <argptr+0x47>
8010496a:	01 da                	add    %ebx,%edx
8010496c:	39 ca                	cmp    %ecx,%edx
8010496e:	77 07                	ja     80104977 <argptr+0x47>
    return -1;
  *pp = (char*)i;
80104970:	8b 45 0c             	mov    0xc(%ebp),%eax
80104973:	89 18                	mov    %ebx,(%eax)
  return 0;
80104975:	31 c0                	xor    %eax,%eax
}
80104977:	5b                   	pop    %ebx
80104978:	5e                   	pop    %esi
80104979:	5d                   	pop    %ebp
8010497a:	c3                   	ret    
8010497b:	90                   	nop
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104980 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104980:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104986:	55                   	push   %ebp
80104987:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104989:	8b 50 18             	mov    0x18(%eax),%edx
8010498c:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010498f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104991:	8b 52 44             	mov    0x44(%edx),%edx
80104994:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104997:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010499a:	39 c1                	cmp    %eax,%ecx
8010499c:	73 07                	jae    801049a5 <argstr+0x25>
8010499e:	8d 4a 08             	lea    0x8(%edx),%ecx
801049a1:	39 c8                	cmp    %ecx,%eax
801049a3:	73 0b                	jae    801049b0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801049a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801049aa:	5d                   	pop    %ebp
801049ab:	c3                   	ret    
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801049b0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801049b3:	39 c1                	cmp    %eax,%ecx
801049b5:	73 ee                	jae    801049a5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
801049b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801049ba:	89 c8                	mov    %ecx,%eax
801049bc:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801049be:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049c5:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801049c7:	39 d1                	cmp    %edx,%ecx
801049c9:	73 da                	jae    801049a5 <argstr+0x25>
    if(*s == 0)
801049cb:	80 39 00             	cmpb   $0x0,(%ecx)
801049ce:	75 0d                	jne    801049dd <argstr+0x5d>
801049d0:	eb 1e                	jmp    801049f0 <argstr+0x70>
801049d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d8:	80 38 00             	cmpb   $0x0,(%eax)
801049db:	74 13                	je     801049f0 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801049dd:	83 c0 01             	add    $0x1,%eax
801049e0:	39 c2                	cmp    %eax,%edx
801049e2:	77 f4                	ja     801049d8 <argstr+0x58>
801049e4:	eb bf                	jmp    801049a5 <argstr+0x25>
801049e6:	8d 76 00             	lea    0x0(%esi),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(*s == 0)
      return s - *pp;
801049f0:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801049f2:	5d                   	pop    %ebp
801049f3:	c3                   	ret    
801049f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a00 <syscall>:
[SYS_waitx]   sys_waitx,
};

void
syscall(void)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	83 ec 04             	sub    $0x4,%esp
  int num;

  num = proc->tf->eax;
80104a07:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a0e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a11:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a14:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104a17:	83 f9 15             	cmp    $0x15,%ecx
80104a1a:	77 1c                	ja     80104a38 <syscall+0x38>
80104a1c:	8b 0c 85 e0 77 10 80 	mov    -0x7fef8820(,%eax,4),%ecx
80104a23:	85 c9                	test   %ecx,%ecx
80104a25:	74 11                	je     80104a38 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104a27:	ff d1                	call   *%ecx
80104a29:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104a2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a2f:	c9                   	leave  
80104a30:	c3                   	ret    
80104a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104a38:	50                   	push   %eax
            proc->pid, proc->name, num);
80104a39:	8d 42 6c             	lea    0x6c(%edx),%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104a3c:	50                   	push   %eax
80104a3d:	ff 72 10             	pushl  0x10(%edx)
80104a40:	68 b1 77 10 80       	push   $0x801077b1
80104a45:	e8 16 bc ff ff       	call   80100660 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104a4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a50:	83 c4 10             	add    $0x10,%esp
80104a53:	8b 40 18             	mov    0x18(%eax),%eax
80104a56:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104a5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a60:	c9                   	leave  
80104a61:	c3                   	ret    
80104a62:	66 90                	xchg   %ax,%ax
80104a64:	66 90                	xchg   %ax,%ax
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a76:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a79:	83 ec 44             	sub    $0x44,%esp
80104a7c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a82:	56                   	push   %esi
80104a83:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a84:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a87:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a8a:	e8 21 d4 ff ff       	call   80101eb0 <nameiparent>
80104a8f:	83 c4 10             	add    $0x10,%esp
80104a92:	85 c0                	test   %eax,%eax
80104a94:	0f 84 f6 00 00 00    	je     80104b90 <create+0x120>
    return 0;
  ilock(dp);
80104a9a:	83 ec 0c             	sub    $0xc,%esp
80104a9d:	89 c7                	mov    %eax,%edi
80104a9f:	50                   	push   %eax
80104aa0:	e8 bb cb ff ff       	call   80101660 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104aa5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104aa8:	83 c4 0c             	add    $0xc,%esp
80104aab:	50                   	push   %eax
80104aac:	56                   	push   %esi
80104aad:	57                   	push   %edi
80104aae:	e8 bd d0 ff ff       	call   80101b70 <dirlookup>
80104ab3:	83 c4 10             	add    $0x10,%esp
80104ab6:	85 c0                	test   %eax,%eax
80104ab8:	89 c3                	mov    %eax,%ebx
80104aba:	74 54                	je     80104b10 <create+0xa0>
    iunlockput(dp);
80104abc:	83 ec 0c             	sub    $0xc,%esp
80104abf:	57                   	push   %edi
80104ac0:	e8 0b ce ff ff       	call   801018d0 <iunlockput>
    ilock(ip);
80104ac5:	89 1c 24             	mov    %ebx,(%esp)
80104ac8:	e8 93 cb ff ff       	call   80101660 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104acd:	83 c4 10             	add    $0x10,%esp
80104ad0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ad5:	75 19                	jne    80104af0 <create+0x80>
80104ad7:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104adc:	89 d8                	mov    %ebx,%eax
80104ade:	75 10                	jne    80104af0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ae3:	5b                   	pop    %ebx
80104ae4:	5e                   	pop    %esi
80104ae5:	5f                   	pop    %edi
80104ae6:	5d                   	pop    %ebp
80104ae7:	c3                   	ret    
80104ae8:	90                   	nop
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104af0:	83 ec 0c             	sub    $0xc,%esp
80104af3:	53                   	push   %ebx
80104af4:	e8 d7 cd ff ff       	call   801018d0 <iunlockput>
    return 0;
80104af9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104aff:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b01:	5b                   	pop    %ebx
80104b02:	5e                   	pop    %esi
80104b03:	5f                   	pop    %edi
80104b04:	5d                   	pop    %ebp
80104b05:	c3                   	ret    
80104b06:	8d 76 00             	lea    0x0(%esi),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104b10:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b14:	83 ec 08             	sub    $0x8,%esp
80104b17:	50                   	push   %eax
80104b18:	ff 37                	pushl  (%edi)
80104b1a:	e8 d1 c9 ff ff       	call   801014f0 <ialloc>
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	85 c0                	test   %eax,%eax
80104b24:	89 c3                	mov    %eax,%ebx
80104b26:	0f 84 cc 00 00 00    	je     80104bf8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104b2c:	83 ec 0c             	sub    $0xc,%esp
80104b2f:	50                   	push   %eax
80104b30:	e8 2b cb ff ff       	call   80101660 <ilock>
  ip->major = major;
80104b35:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b39:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104b3d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b41:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104b45:	b8 01 00 00 00       	mov    $0x1,%eax
80104b4a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104b4e:	89 1c 24             	mov    %ebx,(%esp)
80104b51:	e8 5a ca ff ff       	call   801015b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104b56:	83 c4 10             	add    $0x10,%esp
80104b59:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104b5e:	74 40                	je     80104ba0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104b60:	83 ec 04             	sub    $0x4,%esp
80104b63:	ff 73 04             	pushl  0x4(%ebx)
80104b66:	56                   	push   %esi
80104b67:	57                   	push   %edi
80104b68:	e8 63 d2 ff ff       	call   80101dd0 <dirlink>
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	85 c0                	test   %eax,%eax
80104b72:	78 77                	js     80104beb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104b74:	83 ec 0c             	sub    $0xc,%esp
80104b77:	57                   	push   %edi
80104b78:	e8 53 cd ff ff       	call   801018d0 <iunlockput>

  return ip;
80104b7d:	83 c4 10             	add    $0x10,%esp
}
80104b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104b83:	89 d8                	mov    %ebx,%eax
}
80104b85:	5b                   	pop    %ebx
80104b86:	5e                   	pop    %esi
80104b87:	5f                   	pop    %edi
80104b88:	5d                   	pop    %ebp
80104b89:	c3                   	ret    
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104b90:	31 c0                	xor    %eax,%eax
80104b92:	e9 49 ff ff ff       	jmp    80104ae0 <create+0x70>
80104b97:	89 f6                	mov    %esi,%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104ba0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104ba5:	83 ec 0c             	sub    $0xc,%esp
80104ba8:	57                   	push   %edi
80104ba9:	e8 02 ca ff ff       	call   801015b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bae:	83 c4 0c             	add    $0xc,%esp
80104bb1:	ff 73 04             	pushl  0x4(%ebx)
80104bb4:	68 58 78 10 80       	push   $0x80107858
80104bb9:	53                   	push   %ebx
80104bba:	e8 11 d2 ff ff       	call   80101dd0 <dirlink>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	85 c0                	test   %eax,%eax
80104bc4:	78 18                	js     80104bde <create+0x16e>
80104bc6:	83 ec 04             	sub    $0x4,%esp
80104bc9:	ff 77 04             	pushl  0x4(%edi)
80104bcc:	68 57 78 10 80       	push   $0x80107857
80104bd1:	53                   	push   %ebx
80104bd2:	e8 f9 d1 ff ff       	call   80101dd0 <dirlink>
80104bd7:	83 c4 10             	add    $0x10,%esp
80104bda:	85 c0                	test   %eax,%eax
80104bdc:	79 82                	jns    80104b60 <create+0xf0>
      panic("create dots");
80104bde:	83 ec 0c             	sub    $0xc,%esp
80104be1:	68 4b 78 10 80       	push   $0x8010784b
80104be6:	e8 85 b7 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104beb:	83 ec 0c             	sub    $0xc,%esp
80104bee:	68 5a 78 10 80       	push   $0x8010785a
80104bf3:	e8 78 b7 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	68 3c 78 10 80       	push   $0x8010783c
80104c00:	e8 6b b7 ff ff       	call   80100370 <panic>
80104c05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
80104c15:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c17:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c1a:	89 d3                	mov    %edx,%ebx
80104c1c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c1f:	50                   	push   %eax
80104c20:	6a 00                	push   $0x0
80104c22:	e8 c9 fc ff ff       	call   801048f0 <argint>
80104c27:	83 c4 10             	add    $0x10,%esp
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	78 3a                	js     80104c68 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c31:	83 f8 0f             	cmp    $0xf,%eax
80104c34:	77 32                	ja     80104c68 <argfd.constprop.0+0x58>
80104c36:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c3d:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
80104c41:	85 d2                	test   %edx,%edx
80104c43:	74 23                	je     80104c68 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104c45:	85 f6                	test   %esi,%esi
80104c47:	74 02                	je     80104c4b <argfd.constprop.0+0x3b>
    *pfd = fd;
80104c49:	89 06                	mov    %eax,(%esi)
  if(pf)
80104c4b:	85 db                	test   %ebx,%ebx
80104c4d:	74 11                	je     80104c60 <argfd.constprop.0+0x50>
    *pf = f;
80104c4f:	89 13                	mov    %edx,(%ebx)
  return 0;
80104c51:	31 c0                	xor    %eax,%eax
}
80104c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c56:	5b                   	pop    %ebx
80104c57:	5e                   	pop    %esi
80104c58:	5d                   	pop    %ebp
80104c59:	c3                   	ret    
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104c60:	31 c0                	xor    %eax,%eax
80104c62:	eb ef                	jmp    80104c53 <argfd.constprop.0+0x43>
80104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104c68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c6d:	eb e4                	jmp    80104c53 <argfd.constprop.0+0x43>
80104c6f:	90                   	nop

80104c70 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104c70:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104c71:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104c73:	89 e5                	mov    %esp,%ebp
80104c75:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104c76:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104c79:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104c7c:	e8 8f ff ff ff       	call   80104c10 <argfd.constprop.0>
80104c81:	85 c0                	test   %eax,%eax
80104c83:	78 1b                	js     80104ca0 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104c8e:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104c90:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104c94:	85 c9                	test   %ecx,%ecx
80104c96:	74 18                	je     80104cb0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104c98:	83 c3 01             	add    $0x1,%ebx
80104c9b:	83 fb 10             	cmp    $0x10,%ebx
80104c9e:	75 f0                	jne    80104c90 <sys_dup+0x20>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca8:	c9                   	leave  
80104ca9:	c3                   	ret    
80104caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104cb0:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104cb3:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104cb7:	52                   	push   %edx
80104cb8:	e8 13 c1 ff ff       	call   80100dd0 <filedup>
  return fd;
80104cbd:	89 d8                	mov    %ebx,%eax
80104cbf:	83 c4 10             	add    $0x10,%esp
}
80104cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sys_read>:

int
sys_read(void)
{
80104cd0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cd1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cd8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cdb:	e8 30 ff ff ff       	call   80104c10 <argfd.constprop.0>
80104ce0:	85 c0                	test   %eax,%eax
80104ce2:	78 4c                	js     80104d30 <sys_read+0x60>
80104ce4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ce7:	83 ec 08             	sub    $0x8,%esp
80104cea:	50                   	push   %eax
80104ceb:	6a 02                	push   $0x2
80104ced:	e8 fe fb ff ff       	call   801048f0 <argint>
80104cf2:	83 c4 10             	add    $0x10,%esp
80104cf5:	85 c0                	test   %eax,%eax
80104cf7:	78 37                	js     80104d30 <sys_read+0x60>
80104cf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cfc:	83 ec 04             	sub    $0x4,%esp
80104cff:	ff 75 f0             	pushl  -0x10(%ebp)
80104d02:	50                   	push   %eax
80104d03:	6a 01                	push   $0x1
80104d05:	e8 26 fc ff ff       	call   80104930 <argptr>
80104d0a:	83 c4 10             	add    $0x10,%esp
80104d0d:	85 c0                	test   %eax,%eax
80104d0f:	78 1f                	js     80104d30 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104d11:	83 ec 04             	sub    $0x4,%esp
80104d14:	ff 75 f0             	pushl  -0x10(%ebp)
80104d17:	ff 75 f4             	pushl  -0xc(%ebp)
80104d1a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d1d:	e8 1e c2 ff ff       	call   80100f40 <fileread>
80104d22:	83 c4 10             	add    $0x10,%esp
}
80104d25:	c9                   	leave  
80104d26:	c3                   	ret    
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104d35:	c9                   	leave  
80104d36:	c3                   	ret    
80104d37:	89 f6                	mov    %esi,%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <sys_write>:

int
sys_write(void)
{
80104d40:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d41:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104d43:	89 e5                	mov    %esp,%ebp
80104d45:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d4b:	e8 c0 fe ff ff       	call   80104c10 <argfd.constprop.0>
80104d50:	85 c0                	test   %eax,%eax
80104d52:	78 4c                	js     80104da0 <sys_write+0x60>
80104d54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d57:	83 ec 08             	sub    $0x8,%esp
80104d5a:	50                   	push   %eax
80104d5b:	6a 02                	push   $0x2
80104d5d:	e8 8e fb ff ff       	call   801048f0 <argint>
80104d62:	83 c4 10             	add    $0x10,%esp
80104d65:	85 c0                	test   %eax,%eax
80104d67:	78 37                	js     80104da0 <sys_write+0x60>
80104d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d6c:	83 ec 04             	sub    $0x4,%esp
80104d6f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d72:	50                   	push   %eax
80104d73:	6a 01                	push   $0x1
80104d75:	e8 b6 fb ff ff       	call   80104930 <argptr>
80104d7a:	83 c4 10             	add    $0x10,%esp
80104d7d:	85 c0                	test   %eax,%eax
80104d7f:	78 1f                	js     80104da0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104d81:	83 ec 04             	sub    $0x4,%esp
80104d84:	ff 75 f0             	pushl  -0x10(%ebp)
80104d87:	ff 75 f4             	pushl  -0xc(%ebp)
80104d8a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d8d:	e8 3e c2 ff ff       	call   80100fd0 <filewrite>
80104d92:	83 c4 10             	add    $0x10,%esp
}
80104d95:	c9                   	leave  
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104da5:	c9                   	leave  
80104da6:	c3                   	ret    
80104da7:	89 f6                	mov    %esi,%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <sys_close>:

int
sys_close(void)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104db6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104db9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dbc:	e8 4f fe ff ff       	call   80104c10 <argfd.constprop.0>
80104dc1:	85 c0                	test   %eax,%eax
80104dc3:	78 2b                	js     80104df0 <sys_close+0x40>
    return -1;
  proc->ofile[fd] = 0;
80104dc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104dc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  fileclose(f);
80104dce:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  proc->ofile[fd] = 0;
80104dd1:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104dd8:	00 
  fileclose(f);
80104dd9:	ff 75 f4             	pushl  -0xc(%ebp)
80104ddc:	e8 3f c0 ff ff       	call   80100e20 <fileclose>
  return 0;
80104de1:	83 c4 10             	add    $0x10,%esp
80104de4:	31 c0                	xor    %eax,%eax
}
80104de6:	c9                   	leave  
80104de7:	c3                   	ret    
80104de8:	90                   	nop
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <sys_fstat>:

int
sys_fstat(void)
{
80104e00:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e01:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104e03:	89 e5                	mov    %esp,%ebp
80104e05:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e08:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e0b:	e8 00 fe ff ff       	call   80104c10 <argfd.constprop.0>
80104e10:	85 c0                	test   %eax,%eax
80104e12:	78 2c                	js     80104e40 <sys_fstat+0x40>
80104e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e17:	83 ec 04             	sub    $0x4,%esp
80104e1a:	6a 14                	push   $0x14
80104e1c:	50                   	push   %eax
80104e1d:	6a 01                	push   $0x1
80104e1f:	e8 0c fb ff ff       	call   80104930 <argptr>
80104e24:	83 c4 10             	add    $0x10,%esp
80104e27:	85 c0                	test   %eax,%eax
80104e29:	78 15                	js     80104e40 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104e2b:	83 ec 08             	sub    $0x8,%esp
80104e2e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e31:	ff 75 f0             	pushl  -0x10(%ebp)
80104e34:	e8 b7 c0 ff ff       	call   80100ef0 <filestat>
80104e39:	83 c4 10             	add    $0x10,%esp
}
80104e3c:	c9                   	leave  
80104e3d:	c3                   	ret    
80104e3e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104e45:	c9                   	leave  
80104e46:	c3                   	ret    
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	56                   	push   %esi
80104e55:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e56:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104e59:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e5c:	50                   	push   %eax
80104e5d:	6a 00                	push   $0x0
80104e5f:	e8 1c fb ff ff       	call   80104980 <argstr>
80104e64:	83 c4 10             	add    $0x10,%esp
80104e67:	85 c0                	test   %eax,%eax
80104e69:	0f 88 fb 00 00 00    	js     80104f6a <sys_link+0x11a>
80104e6f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e72:	83 ec 08             	sub    $0x8,%esp
80104e75:	50                   	push   %eax
80104e76:	6a 01                	push   $0x1
80104e78:	e8 03 fb ff ff       	call   80104980 <argstr>
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	0f 88 e2 00 00 00    	js     80104f6a <sys_link+0x11a>
    return -1;

  begin_op();
80104e88:	e8 33 dd ff ff       	call   80102bc0 <begin_op>
  if((ip = namei(old)) == 0){
80104e8d:	83 ec 0c             	sub    $0xc,%esp
80104e90:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e93:	e8 f8 cf ff ff       	call   80101e90 <namei>
80104e98:	83 c4 10             	add    $0x10,%esp
80104e9b:	85 c0                	test   %eax,%eax
80104e9d:	89 c3                	mov    %eax,%ebx
80104e9f:	0f 84 f3 00 00 00    	je     80104f98 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104ea5:	83 ec 0c             	sub    $0xc,%esp
80104ea8:	50                   	push   %eax
80104ea9:	e8 b2 c7 ff ff       	call   80101660 <ilock>
  if(ip->type == T_DIR){
80104eae:	83 c4 10             	add    $0x10,%esp
80104eb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eb6:	0f 84 c4 00 00 00    	je     80104f80 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104ebc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ec1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104ec4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104ec7:	53                   	push   %ebx
80104ec8:	e8 e3 c6 ff ff       	call   801015b0 <iupdate>
  iunlock(ip);
80104ecd:	89 1c 24             	mov    %ebx,(%esp)
80104ed0:	e8 6b c8 ff ff       	call   80101740 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104ed5:	58                   	pop    %eax
80104ed6:	5a                   	pop    %edx
80104ed7:	57                   	push   %edi
80104ed8:	ff 75 d0             	pushl  -0x30(%ebp)
80104edb:	e8 d0 cf ff ff       	call   80101eb0 <nameiparent>
80104ee0:	83 c4 10             	add    $0x10,%esp
80104ee3:	85 c0                	test   %eax,%eax
80104ee5:	89 c6                	mov    %eax,%esi
80104ee7:	74 5b                	je     80104f44 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104ee9:	83 ec 0c             	sub    $0xc,%esp
80104eec:	50                   	push   %eax
80104eed:	e8 6e c7 ff ff       	call   80101660 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ef2:	83 c4 10             	add    $0x10,%esp
80104ef5:	8b 03                	mov    (%ebx),%eax
80104ef7:	39 06                	cmp    %eax,(%esi)
80104ef9:	75 3d                	jne    80104f38 <sys_link+0xe8>
80104efb:	83 ec 04             	sub    $0x4,%esp
80104efe:	ff 73 04             	pushl  0x4(%ebx)
80104f01:	57                   	push   %edi
80104f02:	56                   	push   %esi
80104f03:	e8 c8 ce ff ff       	call   80101dd0 <dirlink>
80104f08:	83 c4 10             	add    $0x10,%esp
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	78 29                	js     80104f38 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104f0f:	83 ec 0c             	sub    $0xc,%esp
80104f12:	56                   	push   %esi
80104f13:	e8 b8 c9 ff ff       	call   801018d0 <iunlockput>
  iput(ip);
80104f18:	89 1c 24             	mov    %ebx,(%esp)
80104f1b:	e8 70 c8 ff ff       	call   80101790 <iput>

  end_op();
80104f20:	e8 0b dd ff ff       	call   80102c30 <end_op>

  return 0;
80104f25:	83 c4 10             	add    $0x10,%esp
80104f28:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f2d:	5b                   	pop    %ebx
80104f2e:	5e                   	pop    %esi
80104f2f:	5f                   	pop    %edi
80104f30:	5d                   	pop    %ebp
80104f31:	c3                   	ret    
80104f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104f38:	83 ec 0c             	sub    $0xc,%esp
80104f3b:	56                   	push   %esi
80104f3c:	e8 8f c9 ff ff       	call   801018d0 <iunlockput>
    goto bad;
80104f41:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104f44:	83 ec 0c             	sub    $0xc,%esp
80104f47:	53                   	push   %ebx
80104f48:	e8 13 c7 ff ff       	call   80101660 <ilock>
  ip->nlink--;
80104f4d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f52:	89 1c 24             	mov    %ebx,(%esp)
80104f55:	e8 56 c6 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80104f5a:	89 1c 24             	mov    %ebx,(%esp)
80104f5d:	e8 6e c9 ff ff       	call   801018d0 <iunlockput>
  end_op();
80104f62:	e8 c9 dc ff ff       	call   80102c30 <end_op>
  return -1;
80104f67:	83 c4 10             	add    $0x10,%esp
}
80104f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104f6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f72:	5b                   	pop    %ebx
80104f73:	5e                   	pop    %esi
80104f74:	5f                   	pop    %edi
80104f75:	5d                   	pop    %ebp
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104f80:	83 ec 0c             	sub    $0xc,%esp
80104f83:	53                   	push   %ebx
80104f84:	e8 47 c9 ff ff       	call   801018d0 <iunlockput>
    end_op();
80104f89:	e8 a2 dc ff ff       	call   80102c30 <end_op>
    return -1;
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f96:	eb 92                	jmp    80104f2a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104f98:	e8 93 dc ff ff       	call   80102c30 <end_op>
    return -1;
80104f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa2:	eb 86                	jmp    80104f2a <sys_link+0xda>
80104fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104fb0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	57                   	push   %edi
80104fb4:	56                   	push   %esi
80104fb5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104fb6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104fb9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104fbc:	50                   	push   %eax
80104fbd:	6a 00                	push   $0x0
80104fbf:	e8 bc f9 ff ff       	call   80104980 <argstr>
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	0f 88 82 01 00 00    	js     80105151 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104fcf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104fd2:	e8 e9 db ff ff       	call   80102bc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fd7:	83 ec 08             	sub    $0x8,%esp
80104fda:	53                   	push   %ebx
80104fdb:	ff 75 c0             	pushl  -0x40(%ebp)
80104fde:	e8 cd ce ff ff       	call   80101eb0 <nameiparent>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104feb:	0f 84 6a 01 00 00    	je     8010515b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104ff1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	56                   	push   %esi
80104ff8:	e8 63 c6 ff ff       	call   80101660 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ffd:	58                   	pop    %eax
80104ffe:	5a                   	pop    %edx
80104fff:	68 58 78 10 80       	push   $0x80107858
80105004:	53                   	push   %ebx
80105005:	e8 46 cb ff ff       	call   80101b50 <namecmp>
8010500a:	83 c4 10             	add    $0x10,%esp
8010500d:	85 c0                	test   %eax,%eax
8010500f:	0f 84 fc 00 00 00    	je     80105111 <sys_unlink+0x161>
80105015:	83 ec 08             	sub    $0x8,%esp
80105018:	68 57 78 10 80       	push   $0x80107857
8010501d:	53                   	push   %ebx
8010501e:	e8 2d cb ff ff       	call   80101b50 <namecmp>
80105023:	83 c4 10             	add    $0x10,%esp
80105026:	85 c0                	test   %eax,%eax
80105028:	0f 84 e3 00 00 00    	je     80105111 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010502e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105031:	83 ec 04             	sub    $0x4,%esp
80105034:	50                   	push   %eax
80105035:	53                   	push   %ebx
80105036:	56                   	push   %esi
80105037:	e8 34 cb ff ff       	call   80101b70 <dirlookup>
8010503c:	83 c4 10             	add    $0x10,%esp
8010503f:	85 c0                	test   %eax,%eax
80105041:	89 c3                	mov    %eax,%ebx
80105043:	0f 84 c8 00 00 00    	je     80105111 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105049:	83 ec 0c             	sub    $0xc,%esp
8010504c:	50                   	push   %eax
8010504d:	e8 0e c6 ff ff       	call   80101660 <ilock>

  if(ip->nlink < 1)
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010505a:	0f 8e 24 01 00 00    	jle    80105184 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105060:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105065:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105068:	74 66                	je     801050d0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010506a:	83 ec 04             	sub    $0x4,%esp
8010506d:	6a 10                	push   $0x10
8010506f:	6a 00                	push   $0x0
80105071:	56                   	push   %esi
80105072:	e8 89 f5 ff ff       	call   80104600 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105077:	6a 10                	push   $0x10
80105079:	ff 75 c4             	pushl  -0x3c(%ebp)
8010507c:	56                   	push   %esi
8010507d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105080:	e8 9b c9 ff ff       	call   80101a20 <writei>
80105085:	83 c4 20             	add    $0x20,%esp
80105088:	83 f8 10             	cmp    $0x10,%eax
8010508b:	0f 85 e6 00 00 00    	jne    80105177 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105091:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105096:	0f 84 9c 00 00 00    	je     80105138 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010509c:	83 ec 0c             	sub    $0xc,%esp
8010509f:	ff 75 b4             	pushl  -0x4c(%ebp)
801050a2:	e8 29 c8 ff ff       	call   801018d0 <iunlockput>

  ip->nlink--;
801050a7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050ac:	89 1c 24             	mov    %ebx,(%esp)
801050af:	e8 fc c4 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
801050b4:	89 1c 24             	mov    %ebx,(%esp)
801050b7:	e8 14 c8 ff ff       	call   801018d0 <iunlockput>

  end_op();
801050bc:	e8 6f db ff ff       	call   80102c30 <end_op>

  return 0;
801050c1:	83 c4 10             	add    $0x10,%esp
801050c4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801050c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5f                   	pop    %edi
801050cc:	5d                   	pop    %ebp
801050cd:	c3                   	ret    
801050ce:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050d4:	76 94                	jbe    8010506a <sys_unlink+0xba>
801050d6:	bf 20 00 00 00       	mov    $0x20,%edi
801050db:	eb 0f                	jmp    801050ec <sys_unlink+0x13c>
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
801050e0:	83 c7 10             	add    $0x10,%edi
801050e3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801050e6:	0f 83 7e ff ff ff    	jae    8010506a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050ec:	6a 10                	push   $0x10
801050ee:	57                   	push   %edi
801050ef:	56                   	push   %esi
801050f0:	53                   	push   %ebx
801050f1:	e8 2a c8 ff ff       	call   80101920 <readi>
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	83 f8 10             	cmp    $0x10,%eax
801050fc:	75 6c                	jne    8010516a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
801050fe:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105103:	74 db                	je     801050e0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	53                   	push   %ebx
80105109:	e8 c2 c7 ff ff       	call   801018d0 <iunlockput>
    goto bad;
8010510e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105111:	83 ec 0c             	sub    $0xc,%esp
80105114:	ff 75 b4             	pushl  -0x4c(%ebp)
80105117:	e8 b4 c7 ff ff       	call   801018d0 <iunlockput>
  end_op();
8010511c:	e8 0f db ff ff       	call   80102c30 <end_op>
  return -1;
80105121:	83 c4 10             	add    $0x10,%esp
}
80105124:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010512c:	5b                   	pop    %ebx
8010512d:	5e                   	pop    %esi
8010512e:	5f                   	pop    %edi
8010512f:	5d                   	pop    %ebp
80105130:	c3                   	ret    
80105131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105138:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010513b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010513e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105143:	50                   	push   %eax
80105144:	e8 67 c4 ff ff       	call   801015b0 <iupdate>
80105149:	83 c4 10             	add    $0x10,%esp
8010514c:	e9 4b ff ff ff       	jmp    8010509c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105156:	e9 6b ff ff ff       	jmp    801050c6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010515b:	e8 d0 da ff ff       	call   80102c30 <end_op>
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	e9 5c ff ff ff       	jmp    801050c6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010516a:	83 ec 0c             	sub    $0xc,%esp
8010516d:	68 7c 78 10 80       	push   $0x8010787c
80105172:	e8 f9 b1 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105177:	83 ec 0c             	sub    $0xc,%esp
8010517a:	68 8e 78 10 80       	push   $0x8010788e
8010517f:	e8 ec b1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105184:	83 ec 0c             	sub    $0xc,%esp
80105187:	68 6a 78 10 80       	push   $0x8010786a
8010518c:	e8 df b1 ff ff       	call   80100370 <panic>
80105191:	eb 0d                	jmp    801051a0 <sys_open>
80105193:	90                   	nop
80105194:	90                   	nop
80105195:	90                   	nop
80105196:	90                   	nop
80105197:	90                   	nop
80105198:	90                   	nop
80105199:	90                   	nop
8010519a:	90                   	nop
8010519b:	90                   	nop
8010519c:	90                   	nop
8010519d:	90                   	nop
8010519e:	90                   	nop
8010519f:	90                   	nop

801051a0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
801051a5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801051a9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051ac:	50                   	push   %eax
801051ad:	6a 00                	push   $0x0
801051af:	e8 cc f7 ff ff       	call   80104980 <argstr>
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	85 c0                	test   %eax,%eax
801051b9:	0f 88 9e 00 00 00    	js     8010525d <sys_open+0xbd>
801051bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801051c2:	83 ec 08             	sub    $0x8,%esp
801051c5:	50                   	push   %eax
801051c6:	6a 01                	push   $0x1
801051c8:	e8 23 f7 ff ff       	call   801048f0 <argint>
801051cd:	83 c4 10             	add    $0x10,%esp
801051d0:	85 c0                	test   %eax,%eax
801051d2:	0f 88 85 00 00 00    	js     8010525d <sys_open+0xbd>
    return -1;

  begin_op();
801051d8:	e8 e3 d9 ff ff       	call   80102bc0 <begin_op>

  if(omode & O_CREATE){
801051dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051e1:	0f 85 89 00 00 00    	jne    80105270 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801051e7:	83 ec 0c             	sub    $0xc,%esp
801051ea:	ff 75 e0             	pushl  -0x20(%ebp)
801051ed:	e8 9e cc ff ff       	call   80101e90 <namei>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	89 c7                	mov    %eax,%edi
801051f9:	0f 84 8e 00 00 00    	je     8010528d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801051ff:	83 ec 0c             	sub    $0xc,%esp
80105202:	50                   	push   %eax
80105203:	e8 58 c4 ff ff       	call   80101660 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105208:	83 c4 10             	add    $0x10,%esp
8010520b:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80105210:	0f 84 d2 00 00 00    	je     801052e8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105216:	e8 45 bb ff ff       	call   80100d60 <filealloc>
8010521b:	85 c0                	test   %eax,%eax
8010521d:	89 c6                	mov    %eax,%esi
8010521f:	74 2b                	je     8010524c <sys_open+0xac>
80105221:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105228:	31 db                	xor    %ebx,%ebx
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105230:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80105234:	85 c0                	test   %eax,%eax
80105236:	74 68                	je     801052a0 <sys_open+0x100>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105238:	83 c3 01             	add    $0x1,%ebx
8010523b:	83 fb 10             	cmp    $0x10,%ebx
8010523e:	75 f0                	jne    80105230 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105240:	83 ec 0c             	sub    $0xc,%esp
80105243:	56                   	push   %esi
80105244:	e8 d7 bb ff ff       	call   80100e20 <fileclose>
80105249:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	57                   	push   %edi
80105250:	e8 7b c6 ff ff       	call   801018d0 <iunlockput>
    end_op();
80105255:	e8 d6 d9 ff ff       	call   80102c30 <end_op>
    return -1;
8010525a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010525d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105265:	5b                   	pop    %ebx
80105266:	5e                   	pop    %esi
80105267:	5f                   	pop    %edi
80105268:	5d                   	pop    %ebp
80105269:	c3                   	ret    
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105276:	31 c9                	xor    %ecx,%ecx
80105278:	6a 00                	push   $0x0
8010527a:	ba 02 00 00 00       	mov    $0x2,%edx
8010527f:	e8 ec f7 ff ff       	call   80104a70 <create>
    if(ip == 0){
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105289:	89 c7                	mov    %eax,%edi
    if(ip == 0){
8010528b:	75 89                	jne    80105216 <sys_open+0x76>
      end_op();
8010528d:	e8 9e d9 ff ff       	call   80102c30 <end_op>
      return -1;
80105292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105297:	eb 43                	jmp    801052dc <sys_open+0x13c>
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052a0:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801052a3:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052a7:	57                   	push   %edi
801052a8:	e8 93 c4 ff ff       	call   80101740 <iunlock>
  end_op();
801052ad:	e8 7e d9 ff ff       	call   80102c30 <end_op>

  f->type = FD_INODE;
801052b2:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052bb:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801052be:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
801052c1:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
801052c8:	89 d0                	mov    %edx,%eax
801052ca:	83 e0 01             	and    $0x1,%eax
801052cd:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052d0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052d3:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052d6:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
801052da:	89 d8                	mov    %ebx,%eax
}
801052dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052df:	5b                   	pop    %ebx
801052e0:	5e                   	pop    %esi
801052e1:	5f                   	pop    %edi
801052e2:	5d                   	pop    %ebp
801052e3:	c3                   	ret    
801052e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801052e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801052eb:	85 d2                	test   %edx,%edx
801052ed:	0f 84 23 ff ff ff    	je     80105216 <sys_open+0x76>
801052f3:	e9 54 ff ff ff       	jmp    8010524c <sys_open+0xac>
801052f8:	90                   	nop
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105306:	e8 b5 d8 ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010530b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010530e:	83 ec 08             	sub    $0x8,%esp
80105311:	50                   	push   %eax
80105312:	6a 00                	push   $0x0
80105314:	e8 67 f6 ff ff       	call   80104980 <argstr>
80105319:	83 c4 10             	add    $0x10,%esp
8010531c:	85 c0                	test   %eax,%eax
8010531e:	78 30                	js     80105350 <sys_mkdir+0x50>
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105326:	31 c9                	xor    %ecx,%ecx
80105328:	6a 00                	push   $0x0
8010532a:	ba 01 00 00 00       	mov    $0x1,%edx
8010532f:	e8 3c f7 ff ff       	call   80104a70 <create>
80105334:	83 c4 10             	add    $0x10,%esp
80105337:	85 c0                	test   %eax,%eax
80105339:	74 15                	je     80105350 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010533b:	83 ec 0c             	sub    $0xc,%esp
8010533e:	50                   	push   %eax
8010533f:	e8 8c c5 ff ff       	call   801018d0 <iunlockput>
  end_op();
80105344:	e8 e7 d8 ff ff       	call   80102c30 <end_op>
  return 0;
80105349:	83 c4 10             	add    $0x10,%esp
8010534c:	31 c0                	xor    %eax,%eax
}
8010534e:	c9                   	leave  
8010534f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105350:	e8 db d8 ff ff       	call   80102c30 <end_op>
    return -1;
80105355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010535a:	c9                   	leave  
8010535b:	c3                   	ret    
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_mknod>:

int
sys_mknod(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105366:	e8 55 d8 ff ff       	call   80102bc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010536b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010536e:	83 ec 08             	sub    $0x8,%esp
80105371:	50                   	push   %eax
80105372:	6a 00                	push   $0x0
80105374:	e8 07 f6 ff ff       	call   80104980 <argstr>
80105379:	83 c4 10             	add    $0x10,%esp
8010537c:	85 c0                	test   %eax,%eax
8010537e:	78 60                	js     801053e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105380:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105383:	83 ec 08             	sub    $0x8,%esp
80105386:	50                   	push   %eax
80105387:	6a 01                	push   $0x1
80105389:	e8 62 f5 ff ff       	call   801048f0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	85 c0                	test   %eax,%eax
80105393:	78 4b                	js     801053e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105395:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105398:	83 ec 08             	sub    $0x8,%esp
8010539b:	50                   	push   %eax
8010539c:	6a 02                	push   $0x2
8010539e:	e8 4d f5 ff ff       	call   801048f0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	78 36                	js     801053e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801053aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801053ae:	83 ec 0c             	sub    $0xc,%esp
801053b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801053b5:	ba 03 00 00 00       	mov    $0x3,%edx
801053ba:	50                   	push   %eax
801053bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053be:	e8 ad f6 ff ff       	call   80104a70 <create>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	74 16                	je     801053e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	50                   	push   %eax
801053ce:	e8 fd c4 ff ff       	call   801018d0 <iunlockput>
  end_op();
801053d3:	e8 58 d8 ff ff       	call   80102c30 <end_op>
  return 0;
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	31 c0                	xor    %eax,%eax
}
801053dd:	c9                   	leave  
801053de:	c3                   	ret    
801053df:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801053e0:	e8 4b d8 ff ff       	call   80102c30 <end_op>
    return -1;
801053e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801053ea:	c9                   	leave  
801053eb:	c3                   	ret    
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_chdir>:

int
sys_chdir(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	53                   	push   %ebx
801053f4:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053f7:	e8 c4 d7 ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ff:	83 ec 08             	sub    $0x8,%esp
80105402:	50                   	push   %eax
80105403:	6a 00                	push   $0x0
80105405:	e8 76 f5 ff ff       	call   80104980 <argstr>
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	85 c0                	test   %eax,%eax
8010540f:	78 7f                	js     80105490 <sys_chdir+0xa0>
80105411:	83 ec 0c             	sub    $0xc,%esp
80105414:	ff 75 f4             	pushl  -0xc(%ebp)
80105417:	e8 74 ca ff ff       	call   80101e90 <namei>
8010541c:	83 c4 10             	add    $0x10,%esp
8010541f:	85 c0                	test   %eax,%eax
80105421:	89 c3                	mov    %eax,%ebx
80105423:	74 6b                	je     80105490 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105425:	83 ec 0c             	sub    $0xc,%esp
80105428:	50                   	push   %eax
80105429:	e8 32 c2 ff ff       	call   80101660 <ilock>
  if(ip->type != T_DIR){
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105436:	75 38                	jne    80105470 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	53                   	push   %ebx
8010543c:	e8 ff c2 ff ff       	call   80101740 <iunlock>
  iput(proc->cwd);
80105441:	58                   	pop    %eax
80105442:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105448:	ff 70 68             	pushl  0x68(%eax)
8010544b:	e8 40 c3 ff ff       	call   80101790 <iput>
  end_op();
80105450:	e8 db d7 ff ff       	call   80102c30 <end_op>
  proc->cwd = ip;
80105455:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
8010545b:	83 c4 10             	add    $0x10,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
8010545e:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
80105461:	31 c0                	xor    %eax,%eax
}
80105463:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105466:	c9                   	leave  
80105467:	c3                   	ret    
80105468:	90                   	nop
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	53                   	push   %ebx
80105474:	e8 57 c4 ff ff       	call   801018d0 <iunlockput>
    end_op();
80105479:	e8 b2 d7 ff ff       	call   80102c30 <end_op>
    return -1;
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105486:	eb db                	jmp    80105463 <sys_chdir+0x73>
80105488:	90                   	nop
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105490:	e8 9b d7 ff ff       	call   80102c30 <end_op>
    return -1;
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549a:	eb c7                	jmp    80105463 <sys_chdir+0x73>
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
801054a5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801054ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054b2:	50                   	push   %eax
801054b3:	6a 00                	push   $0x0
801054b5:	e8 c6 f4 ff ff       	call   80104980 <argstr>
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	85 c0                	test   %eax,%eax
801054bf:	78 7f                	js     80105540 <sys_exec+0xa0>
801054c1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801054c7:	83 ec 08             	sub    $0x8,%esp
801054ca:	50                   	push   %eax
801054cb:	6a 01                	push   $0x1
801054cd:	e8 1e f4 ff ff       	call   801048f0 <argint>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	85 c0                	test   %eax,%eax
801054d7:	78 67                	js     80105540 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801054d9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054df:	83 ec 04             	sub    $0x4,%esp
801054e2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801054e8:	68 80 00 00 00       	push   $0x80
801054ed:	6a 00                	push   $0x0
801054ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054f5:	50                   	push   %eax
801054f6:	31 db                	xor    %ebx,%ebx
801054f8:	e8 03 f1 ff ff       	call   80104600 <memset>
801054fd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105500:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105506:	83 ec 08             	sub    $0x8,%esp
80105509:	57                   	push   %edi
8010550a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010550d:	50                   	push   %eax
8010550e:	e8 5d f3 ff ff       	call   80104870 <fetchint>
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	78 26                	js     80105540 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010551a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105520:	85 c0                	test   %eax,%eax
80105522:	74 2c                	je     80105550 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105524:	83 ec 08             	sub    $0x8,%esp
80105527:	56                   	push   %esi
80105528:	50                   	push   %eax
80105529:	e8 72 f3 ff ff       	call   801048a0 <fetchstr>
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	85 c0                	test   %eax,%eax
80105533:	78 0b                	js     80105540 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105535:	83 c3 01             	add    $0x1,%ebx
80105538:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010553b:	83 fb 20             	cmp    $0x20,%ebx
8010553e:	75 c0                	jne    80105500 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105540:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105548:	5b                   	pop    %ebx
80105549:	5e                   	pop    %esi
8010554a:	5f                   	pop    %edi
8010554b:	5d                   	pop    %ebp
8010554c:	c3                   	ret    
8010554d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105550:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105556:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105559:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105560:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105564:	50                   	push   %eax
80105565:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010556b:	e8 80 b4 ff ff       	call   801009f0 <exec>
80105570:	83 c4 10             	add    $0x10,%esp
}
80105573:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105576:	5b                   	pop    %ebx
80105577:	5e                   	pop    %esi
80105578:	5f                   	pop    %edi
80105579:	5d                   	pop    %ebp
8010557a:	c3                   	ret    
8010557b:	90                   	nop
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_pipe>:

int
sys_pipe(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105586:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105589:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010558c:	6a 08                	push   $0x8
8010558e:	50                   	push   %eax
8010558f:	6a 00                	push   $0x0
80105591:	e8 9a f3 ff ff       	call   80104930 <argptr>
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	85 c0                	test   %eax,%eax
8010559b:	78 48                	js     801055e5 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010559d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055a0:	83 ec 08             	sub    $0x8,%esp
801055a3:	50                   	push   %eax
801055a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055a7:	50                   	push   %eax
801055a8:	e8 b3 dd ff ff       	call   80103360 <pipealloc>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	78 31                	js     801055e5 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801055b7:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801055be:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
801055c0:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
801055c4:	85 d2                	test   %edx,%edx
801055c6:	74 28                	je     801055f0 <sys_pipe+0x70>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801055c8:	83 c0 01             	add    $0x1,%eax
801055cb:	83 f8 10             	cmp    $0x10,%eax
801055ce:	75 f0                	jne    801055c0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	53                   	push   %ebx
801055d4:	e8 47 b8 ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
801055d9:	58                   	pop    %eax
801055da:	ff 75 e4             	pushl  -0x1c(%ebp)
801055dd:	e8 3e b8 ff ff       	call   80100e20 <fileclose>
    return -1;
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ea:	eb 45                	jmp    80105631 <sys_pipe+0xb1>
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055f0:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801055f6:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801055f8:	89 5e 28             	mov    %ebx,0x28(%esi)
801055fb:	90                   	nop
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105600:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80105605:	74 19                	je     80105620 <sys_pipe+0xa0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105607:	83 c2 01             	add    $0x1,%edx
8010560a:	83 fa 10             	cmp    $0x10,%edx
8010560d:	75 f1                	jne    80105600 <sys_pipe+0x80>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
8010560f:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
80105616:	eb b8                	jmp    801055d0 <sys_pipe+0x50>
80105618:	90                   	nop
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105620:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105624:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105627:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105629:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010562c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010562f:	31 c0                	xor    %eax,%eax
}
80105631:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105634:	5b                   	pop    %ebx
80105635:	5e                   	pop    %esi
80105636:	5f                   	pop    %edi
80105637:	5d                   	pop    %ebp
80105638:	c3                   	ret    
80105639:	66 90                	xchg   %ax,%ax
8010563b:	66 90                	xchg   %ax,%ax
8010563d:	66 90                	xchg   %ax,%ax
8010563f:	90                   	nop

80105640 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105643:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105644:	e9 c7 e3 ff ff       	jmp    80103a10 <fork>
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_exit>:
}

int
sys_exit(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 08             	sub    $0x8,%esp
  exit();
80105656:	e8 25 e6 ff ff       	call   80103c80 <exit>
  return 0;  // not reached
}
8010565b:	31 c0                	xor    %eax,%eax
8010565d:	c9                   	leave  
8010565e:	c3                   	ret    
8010565f:	90                   	nop

80105660 <sys_wait>:

int
sys_wait(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105663:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105664:	e9 77 e8 ff ff       	jmp    80103ee0 <wait>
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_waitx>:
}

// Added sys_waitx call to load parameters and calling waitx
int
sys_waitx(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime;
  int *rtime;

  if(argptr(0, (char**)&wtime, sizeof(int)) < 0)
80105676:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105679:	6a 04                	push   $0x4
8010567b:	50                   	push   %eax
8010567c:	6a 00                	push   $0x0
8010567e:	e8 ad f2 ff ff       	call   80104930 <argptr>
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	85 c0                	test   %eax,%eax
80105688:	78 2e                	js     801056b8 <sys_waitx+0x48>
    return -1;

  if(argptr(1, (char**)&rtime, sizeof(int)) < 0)
8010568a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568d:	83 ec 04             	sub    $0x4,%esp
80105690:	6a 04                	push   $0x4
80105692:	50                   	push   %eax
80105693:	6a 01                	push   $0x1
80105695:	e8 96 f2 ff ff       	call   80104930 <argptr>
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	85 c0                	test   %eax,%eax
8010569f:	78 17                	js     801056b8 <sys_waitx+0x48>
    return -1;

  return waitx(wtime, rtime);
801056a1:	83 ec 08             	sub    $0x8,%esp
801056a4:	ff 75 f4             	pushl  -0xc(%ebp)
801056a7:	ff 75 f0             	pushl  -0x10(%ebp)
801056aa:	e8 21 e9 ff ff       	call   80103fd0 <waitx>
801056af:	83 c4 10             	add    $0x10,%esp
}
801056b2:	c9                   	leave  
801056b3:	c3                   	ret    
801056b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int *wtime;
  int *rtime;

  if(argptr(0, (char**)&wtime, sizeof(int)) < 0)
    return -1;
801056b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char**)&rtime, sizeof(int)) < 0)
    return -1;

  return waitx(wtime, rtime);
}
801056bd:	c9                   	leave  
801056be:	c3                   	ret    
801056bf:	90                   	nop

801056c0 <sys_kill>:

int
sys_kill(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801056c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	6a 00                	push   $0x0
801056cc:	e8 1f f2 ff ff       	call   801048f0 <argint>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	78 18                	js     801056f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801056d8:	83 ec 0c             	sub    $0xc,%esp
801056db:	ff 75 f4             	pushl  -0xc(%ebp)
801056de:	e8 6d ea ff ff       	call   80104150 <kill>
801056e3:	83 c4 10             	add    $0x10,%esp
}
801056e6:	c9                   	leave  
801056e7:	c3                   	ret    
801056e8:	90                   	nop
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105700:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105706:	55                   	push   %ebp
80105707:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105709:	8b 40 10             	mov    0x10(%eax),%eax
}
8010570c:	5d                   	pop    %ebp
8010570d:	c3                   	ret    
8010570e:	66 90                	xchg   %ax,%ax

80105710 <sys_sbrk>:

int
sys_sbrk(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105714:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return proc->pid;
}

int
sys_sbrk(void)
{
80105717:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010571a:	50                   	push   %eax
8010571b:	6a 00                	push   $0x0
8010571d:	e8 ce f1 ff ff       	call   801048f0 <argint>
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	85 c0                	test   %eax,%eax
80105727:	78 27                	js     80105750 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105729:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
8010572f:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105732:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105734:	ff 75 f4             	pushl  -0xc(%ebp)
80105737:	e8 64 e2 ff ff       	call   801039a0 <growproc>
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	85 c0                	test   %eax,%eax
80105741:	78 0d                	js     80105750 <sys_sbrk+0x40>
    return -1;
  return addr;
80105743:	89 d8                	mov    %ebx,%eax
}
80105745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105748:	c9                   	leave  
80105749:	c3                   	ret    
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105755:	eb ee                	jmp    80105745 <sys_sbrk+0x35>
80105757:	89 f6                	mov    %esi,%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105760 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105767:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010576a:	50                   	push   %eax
8010576b:	6a 00                	push   $0x0
8010576d:	e8 7e f1 ff ff       	call   801048f0 <argint>
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	85 c0                	test   %eax,%eax
80105777:	0f 88 8a 00 00 00    	js     80105807 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010577d:	83 ec 0c             	sub    $0xc,%esp
80105780:	68 e0 50 11 80       	push   $0x801150e0
80105785:	e8 46 ec ff ff       	call   801043d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010578a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010578d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105790:	8b 1d 20 59 11 80    	mov    0x80115920,%ebx
  while(ticks - ticks0 < n){
80105796:	85 d2                	test   %edx,%edx
80105798:	75 27                	jne    801057c1 <sys_sleep+0x61>
8010579a:	eb 54                	jmp    801057f0 <sys_sleep+0x90>
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057a0:	83 ec 08             	sub    $0x8,%esp
801057a3:	68 e0 50 11 80       	push   $0x801150e0
801057a8:	68 20 59 11 80       	push   $0x80115920
801057ad:	e8 6e e6 ff ff       	call   80103e20 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057b2:	a1 20 59 11 80       	mov    0x80115920,%eax
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	29 d8                	sub    %ebx,%eax
801057bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801057bf:	73 2f                	jae    801057f0 <sys_sleep+0x90>
    if(proc->killed){
801057c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057c7:	8b 40 24             	mov    0x24(%eax),%eax
801057ca:	85 c0                	test   %eax,%eax
801057cc:	74 d2                	je     801057a0 <sys_sleep+0x40>
      release(&tickslock);
801057ce:	83 ec 0c             	sub    $0xc,%esp
801057d1:	68 e0 50 11 80       	push   $0x801150e0
801057d6:	e8 d5 ed ff ff       	call   801045b0 <release>
      return -1;
801057db:	83 c4 10             	add    $0x10,%esp
801057de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801057e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057e6:	c9                   	leave  
801057e7:	c3                   	ret    
801057e8:	90                   	nop
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	68 e0 50 11 80       	push   $0x801150e0
801057f8:	e8 b3 ed ff ff       	call   801045b0 <release>
  return 0;
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	31 c0                	xor    %eax,%eax
}
80105802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105805:	c9                   	leave  
80105806:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580c:	eb d5                	jmp    801057e3 <sys_sleep+0x83>
8010580e:	66 90                	xchg   %ax,%ax

80105810 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	53                   	push   %ebx
80105814:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105817:	68 e0 50 11 80       	push   $0x801150e0
8010581c:	e8 af eb ff ff       	call   801043d0 <acquire>
  xticks = ticks;
80105821:	8b 1d 20 59 11 80    	mov    0x80115920,%ebx
  release(&tickslock);
80105827:	c7 04 24 e0 50 11 80 	movl   $0x801150e0,(%esp)
8010582e:	e8 7d ed ff ff       	call   801045b0 <release>
  return xticks;
}
80105833:	89 d8                	mov    %ebx,%eax
80105835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105838:	c9                   	leave  
80105839:	c3                   	ret    
8010583a:	66 90                	xchg   %ax,%ax
8010583c:	66 90                	xchg   %ax,%ax
8010583e:	66 90                	xchg   %ax,%ax

80105840 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105840:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105841:	ba 43 00 00 00       	mov    $0x43,%edx
80105846:	b8 34 00 00 00       	mov    $0x34,%eax
8010584b:	89 e5                	mov    %esp,%ebp
8010584d:	83 ec 14             	sub    $0x14,%esp
80105850:	ee                   	out    %al,(%dx)
80105851:	ba 40 00 00 00       	mov    $0x40,%edx
80105856:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
8010585b:	ee                   	out    %al,(%dx)
8010585c:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105861:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105862:	6a 00                	push   $0x0
80105864:	e8 27 da ff ff       	call   80103290 <picenable>
}
80105869:	83 c4 10             	add    $0x10,%esp
8010586c:	c9                   	leave  
8010586d:	c3                   	ret    

8010586e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010586e:	1e                   	push   %ds
  pushl %es
8010586f:	06                   	push   %es
  pushl %fs
80105870:	0f a0                	push   %fs
  pushl %gs
80105872:	0f a8                	push   %gs
  pushal
80105874:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105875:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105879:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010587b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010587d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105881:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105883:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105885:	54                   	push   %esp
  call trap
80105886:	e8 e5 00 00 00       	call   80105970 <trap>
  addl $4, %esp
8010588b:	83 c4 04             	add    $0x4,%esp

8010588e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010588e:	61                   	popa   
  popl %gs
8010588f:	0f a9                	pop    %gs
  popl %fs
80105891:	0f a1                	pop    %fs
  popl %es
80105893:	07                   	pop    %es
  popl %ds
80105894:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105895:	83 c4 08             	add    $0x8,%esp
  iret
80105898:	cf                   	iret   
80105899:	66 90                	xchg   %ax,%ax
8010589b:	66 90                	xchg   %ax,%ax
8010589d:	66 90                	xchg   %ax,%ax
8010589f:	90                   	nop

801058a0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801058a0:	31 c0                	xor    %eax,%eax
801058a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058a8:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
801058af:	b9 08 00 00 00       	mov    $0x8,%ecx
801058b4:	c6 04 c5 24 51 11 80 	movb   $0x0,-0x7feeaedc(,%eax,8)
801058bb:	00 
801058bc:	66 89 0c c5 22 51 11 	mov    %cx,-0x7feeaede(,%eax,8)
801058c3:	80 
801058c4:	c6 04 c5 25 51 11 80 	movb   $0x8e,-0x7feeaedb(,%eax,8)
801058cb:	8e 
801058cc:	66 89 14 c5 20 51 11 	mov    %dx,-0x7feeaee0(,%eax,8)
801058d3:	80 
801058d4:	c1 ea 10             	shr    $0x10,%edx
801058d7:	66 89 14 c5 26 51 11 	mov    %dx,-0x7feeaeda(,%eax,8)
801058de:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801058df:	83 c0 01             	add    $0x1,%eax
801058e2:	3d 00 01 00 00       	cmp    $0x100,%eax
801058e7:	75 bf                	jne    801058a8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058e9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058ea:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058ef:	89 e5                	mov    %esp,%ebp
801058f1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058f4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
801058f9:	68 9d 78 10 80       	push   $0x8010789d
801058fe:	68 e0 50 11 80       	push   $0x801150e0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105903:	66 89 15 22 53 11 80 	mov    %dx,0x80115322
8010590a:	c6 05 24 53 11 80 00 	movb   $0x0,0x80115324
80105911:	66 a3 20 53 11 80    	mov    %ax,0x80115320
80105917:	c1 e8 10             	shr    $0x10,%eax
8010591a:	c6 05 25 53 11 80 ef 	movb   $0xef,0x80115325
80105921:	66 a3 26 53 11 80    	mov    %ax,0x80115326

  initlock(&tickslock, "time");
80105927:	e8 84 ea ff ff       	call   801043b0 <initlock>
}
8010592c:	83 c4 10             	add    $0x10,%esp
8010592f:	c9                   	leave  
80105930:	c3                   	ret    
80105931:	eb 0d                	jmp    80105940 <idtinit>
80105933:	90                   	nop
80105934:	90                   	nop
80105935:	90                   	nop
80105936:	90                   	nop
80105937:	90                   	nop
80105938:	90                   	nop
80105939:	90                   	nop
8010593a:	90                   	nop
8010593b:	90                   	nop
8010593c:	90                   	nop
8010593d:	90                   	nop
8010593e:	90                   	nop
8010593f:	90                   	nop

80105940 <idtinit>:

void
idtinit(void)
{
80105940:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105941:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105946:	89 e5                	mov    %esp,%ebp
80105948:	83 ec 10             	sub    $0x10,%esp
8010594b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010594f:	b8 20 51 11 80       	mov    $0x80115120,%eax
80105954:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105958:	c1 e8 10             	shr    $0x10,%eax
8010595b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010595f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105962:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	56                   	push   %esi
80105975:	53                   	push   %ebx
80105976:	83 ec 0c             	sub    $0xc,%esp
80105979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010597c:	8b 43 30             	mov    0x30(%ebx),%eax
8010597f:	83 f8 40             	cmp    $0x40,%eax
80105982:	0f 84 f8 00 00 00    	je     80105a80 <trap+0x110>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105988:	83 e8 20             	sub    $0x20,%eax
8010598b:	83 f8 1f             	cmp    $0x1f,%eax
8010598e:	77 68                	ja     801059f8 <trap+0x88>
80105990:	ff 24 85 44 79 10 80 	jmp    *-0x7fef86bc(,%eax,4)
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
801059a0:	e8 3b cd ff ff       	call   801026e0 <cpunum>
801059a5:	85 c0                	test   %eax,%eax
801059a7:	0f 84 b3 01 00 00    	je     80105b60 <trap+0x1f0>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
801059ad:	e8 ce cd ff ff       	call   80102780 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801059b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059b8:	85 c0                	test   %eax,%eax
801059ba:	74 2d                	je     801059e9 <trap+0x79>
801059bc:	8b 50 24             	mov    0x24(%eax),%edx
801059bf:	85 d2                	test   %edx,%edx
801059c1:	0f 85 86 00 00 00    	jne    80105a4d <trap+0xdd>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801059c7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059cb:	0f 84 ef 00 00 00    	je     80105ac0 <trap+0x150>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801059d1:	8b 40 24             	mov    0x24(%eax),%eax
801059d4:	85 c0                	test   %eax,%eax
801059d6:	74 11                	je     801059e9 <trap+0x79>
801059d8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059dc:	83 e0 03             	and    $0x3,%eax
801059df:	66 83 f8 03          	cmp    $0x3,%ax
801059e3:	0f 84 c1 00 00 00    	je     80105aaa <trap+0x13a>
    exit();
}
801059e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059ec:	5b                   	pop    %ebx
801059ed:	5e                   	pop    %esi
801059ee:	5f                   	pop    %edi
801059ef:	5d                   	pop    %ebp
801059f0:	c3                   	ret    
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801059f8:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801059ff:	85 c9                	test   %ecx,%ecx
80105a01:	0f 84 bf 01 00 00    	je     80105bc6 <trap+0x256>
80105a07:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a0b:	0f 84 b5 01 00 00    	je     80105bc6 <trap+0x256>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a11:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a14:	8b 73 38             	mov    0x38(%ebx),%esi
80105a17:	e8 c4 cc ff ff       	call   801026e0 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105a1c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
80105a25:	50                   	push   %eax
80105a26:	ff 73 34             	pushl  0x34(%ebx)
80105a29:	ff 73 30             	pushl  0x30(%ebx)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105a2c:	8d 42 6c             	lea    0x6c(%edx),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a2f:	50                   	push   %eax
80105a30:	ff 72 10             	pushl  0x10(%edx)
80105a33:	68 00 79 10 80       	push   $0x80107900
80105a38:	e8 23 ac ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80105a3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a43:	83 c4 20             	add    $0x20,%esp
80105a46:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105a4d:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105a51:	83 e2 03             	and    $0x3,%edx
80105a54:	66 83 fa 03          	cmp    $0x3,%dx
80105a58:	0f 85 69 ff ff ff    	jne    801059c7 <trap+0x57>
    exit();
80105a5e:	e8 1d e2 ff ff       	call   80103c80 <exit>
80105a63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105a69:	85 c0                	test   %eax,%eax
80105a6b:	0f 85 56 ff ff ff    	jne    801059c7 <trap+0x57>
80105a71:	e9 73 ff ff ff       	jmp    801059e9 <trap+0x79>
80105a76:	8d 76 00             	lea    0x0(%esi),%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105a80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a86:	8b 70 24             	mov    0x24(%eax),%esi
80105a89:	85 f6                	test   %esi,%esi
80105a8b:	0f 85 bf 00 00 00    	jne    80105b50 <trap+0x1e0>
      exit();
    proc->tf = tf;
80105a91:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105a94:	e8 67 ef ff ff       	call   80104a00 <syscall>
    if(proc->killed)
80105a99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a9f:	8b 58 24             	mov    0x24(%eax),%ebx
80105aa2:	85 db                	test   %ebx,%ebx
80105aa4:	0f 84 3f ff ff ff    	je     801059e9 <trap+0x79>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aad:	5b                   	pop    %ebx
80105aae:	5e                   	pop    %esi
80105aaf:	5f                   	pop    %edi
80105ab0:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105ab1:	e9 ca e1 ff ff       	jmp    80103c80 <exit>
80105ab6:	8d 76 00             	lea    0x0(%esi),%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105ac0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ac4:	0f 85 07 ff ff ff    	jne    801059d1 <trap+0x61>
    yield();
80105aca:	e8 11 e3 ff ff       	call   80103de0 <yield>
80105acf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	0f 85 f4 fe ff ff    	jne    801059d1 <trap+0x61>
80105add:	e9 07 ff ff ff       	jmp    801059e9 <trap+0x79>
80105ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105ae8:	e8 d3 ca ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80105aed:	e8 8e cc ff ff       	call   80102780 <lapiceoi>
    break;
80105af2:	e9 bb fe ff ff       	jmp    801059b2 <trap+0x42>
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105b00:	e8 6b 02 00 00       	call   80105d70 <uartintr>
80105b05:	e9 a3 fe ff ff       	jmp    801059ad <trap+0x3d>
80105b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b10:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b14:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b17:	e8 c4 cb ff ff       	call   801026e0 <cpunum>
80105b1c:	57                   	push   %edi
80105b1d:	56                   	push   %esi
80105b1e:	50                   	push   %eax
80105b1f:	68 a8 78 10 80       	push   $0x801078a8
80105b24:	e8 37 ab ff ff       	call   80100660 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105b29:	e8 52 cc ff ff       	call   80102780 <lapiceoi>
    break;
80105b2e:	83 c4 10             	add    $0x10,%esp
80105b31:	e9 7c fe ff ff       	jmp    801059b2 <trap+0x42>
80105b36:	8d 76 00             	lea    0x0(%esi),%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      }
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105b40:	e8 eb c4 ff ff       	call   80102030 <ideintr>
    lapiceoi();
80105b45:	e8 36 cc ff ff       	call   80102780 <lapiceoi>
    break;
80105b4a:	e9 63 fe ff ff       	jmp    801059b2 <trap+0x42>
80105b4f:	90                   	nop
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105b50:	e8 2b e1 ff ff       	call   80103c80 <exit>
80105b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b5b:	e9 31 ff ff ff       	jmp    80105a91 <trap+0x121>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	68 e0 50 11 80       	push   $0x801150e0
80105b68:	e8 63 e8 ff ff       	call   801043d0 <acquire>
      ticks++;
      wakeup(&ticks);
80105b6d:	c7 04 24 20 59 11 80 	movl   $0x80115920,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105b74:	83 05 20 59 11 80 01 	addl   $0x1,0x80115920
      wakeup(&ticks);
80105b7b:	e8 70 e5 ff ff       	call   801040f0 <wakeup>
      release(&tickslock);
80105b80:	c7 04 24 e0 50 11 80 	movl   $0x801150e0,(%esp)
80105b87:	e8 24 ea ff ff       	call   801045b0 <release>


      // Update time fields
      if(proc)
80105b8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b92:	83 c4 10             	add    $0x10,%esp
80105b95:	85 c0                	test   %eax,%eax
80105b97:	0f 84 10 fe ff ff    	je     801059ad <trap+0x3d>
      {
        if(proc->state == RUNNING)
80105b9d:	8b 50 0c             	mov    0xc(%eax),%edx
80105ba0:	83 fa 04             	cmp    $0x4,%edx
80105ba3:	74 15                	je     80105bba <trap+0x24a>
          proc->rtime++;
        else if(proc->state == SLEEPING)
80105ba5:	83 fa 02             	cmp    $0x2,%edx
80105ba8:	0f 85 ff fd ff ff    	jne    801059ad <trap+0x3d>
          proc->iotime++;
80105bae:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
80105bb5:	e9 f3 fd ff ff       	jmp    801059ad <trap+0x3d>

      // Update time fields
      if(proc)
      {
        if(proc->state == RUNNING)
          proc->rtime++;
80105bba:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
80105bc1:	e9 e7 fd ff ff       	jmp    801059ad <trap+0x3d>
80105bc6:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bc9:	8b 73 38             	mov    0x38(%ebx),%esi
80105bcc:	e8 0f cb ff ff       	call   801026e0 <cpunum>
80105bd1:	83 ec 0c             	sub    $0xc,%esp
80105bd4:	57                   	push   %edi
80105bd5:	56                   	push   %esi
80105bd6:	50                   	push   %eax
80105bd7:	ff 73 30             	pushl  0x30(%ebx)
80105bda:	68 cc 78 10 80       	push   $0x801078cc
80105bdf:	e8 7c aa ff ff       	call   80100660 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105be4:	83 c4 14             	add    $0x14,%esp
80105be7:	68 a2 78 10 80       	push   $0x801078a2
80105bec:	e8 7f a7 ff ff       	call   80100370 <panic>
80105bf1:	66 90                	xchg   %ax,%ax
80105bf3:	66 90                	xchg   %ax,%ax
80105bf5:	66 90                	xchg   %ax,%ax
80105bf7:	66 90                	xchg   %ax,%ax
80105bf9:	66 90                	xchg   %ax,%ax
80105bfb:	66 90                	xchg   %ax,%ax
80105bfd:	66 90                	xchg   %ax,%ax
80105bff:	90                   	nop

80105c00 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c00:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105c05:	55                   	push   %ebp
80105c06:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c08:	85 c0                	test   %eax,%eax
80105c0a:	74 1c                	je     80105c28 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c0c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c11:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c12:	a8 01                	test   $0x1,%al
80105c14:	74 12                	je     80105c28 <uartgetc+0x28>
80105c16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c1b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c1c:	0f b6 c0             	movzbl %al,%eax
}
80105c1f:	5d                   	pop    %ebp
80105c20:	c3                   	ret    
80105c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105c2d:	5d                   	pop    %ebp
80105c2e:	c3                   	ret    
80105c2f:	90                   	nop

80105c30 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	89 c7                	mov    %eax,%edi
80105c38:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c42:	83 ec 0c             	sub    $0xc,%esp
80105c45:	eb 1b                	jmp    80105c62 <uartputc.part.0+0x32>
80105c47:	89 f6                	mov    %esi,%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	6a 0a                	push   $0xa
80105c55:	e8 46 cb ff ff       	call   801027a0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c5a:	83 c4 10             	add    $0x10,%esp
80105c5d:	83 eb 01             	sub    $0x1,%ebx
80105c60:	74 07                	je     80105c69 <uartputc.part.0+0x39>
80105c62:	89 f2                	mov    %esi,%edx
80105c64:	ec                   	in     (%dx),%al
80105c65:	a8 20                	test   $0x20,%al
80105c67:	74 e7                	je     80105c50 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c69:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c6e:	89 f8                	mov    %edi,%eax
80105c70:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c74:	5b                   	pop    %ebx
80105c75:	5e                   	pop    %esi
80105c76:	5f                   	pop    %edi
80105c77:	5d                   	pop    %ebp
80105c78:	c3                   	ret    
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c80 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105c80:	55                   	push   %ebp
80105c81:	31 c9                	xor    %ecx,%ecx
80105c83:	89 c8                	mov    %ecx,%eax
80105c85:	89 e5                	mov    %esp,%ebp
80105c87:	57                   	push   %edi
80105c88:	56                   	push   %esi
80105c89:	53                   	push   %ebx
80105c8a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105c8f:	89 da                	mov    %ebx,%edx
80105c91:	83 ec 0c             	sub    $0xc,%esp
80105c94:	ee                   	out    %al,(%dx)
80105c95:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105c9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c9f:	89 fa                	mov    %edi,%edx
80105ca1:	ee                   	out    %al,(%dx)
80105ca2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ca7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cac:	ee                   	out    %al,(%dx)
80105cad:	be f9 03 00 00       	mov    $0x3f9,%esi
80105cb2:	89 c8                	mov    %ecx,%eax
80105cb4:	89 f2                	mov    %esi,%edx
80105cb6:	ee                   	out    %al,(%dx)
80105cb7:	b8 03 00 00 00       	mov    $0x3,%eax
80105cbc:	89 fa                	mov    %edi,%edx
80105cbe:	ee                   	out    %al,(%dx)
80105cbf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105cc4:	89 c8                	mov    %ecx,%eax
80105cc6:	ee                   	out    %al,(%dx)
80105cc7:	b8 01 00 00 00       	mov    $0x1,%eax
80105ccc:	89 f2                	mov    %esi,%edx
80105cce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ccf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cd4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105cd5:	3c ff                	cmp    $0xff,%al
80105cd7:	74 5a                	je     80105d33 <uartinit+0xb3>
    return;
  uart = 1;
80105cd9:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105ce0:	00 00 00 
80105ce3:	89 da                	mov    %ebx,%edx
80105ce5:	ec                   	in     (%dx),%al
80105ce6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ceb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105cec:	83 ec 0c             	sub    $0xc,%esp
80105cef:	6a 04                	push   $0x4
80105cf1:	e8 9a d5 ff ff       	call   80103290 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105cf6:	59                   	pop    %ecx
80105cf7:	5b                   	pop    %ebx
80105cf8:	6a 00                	push   $0x0
80105cfa:	6a 04                	push   $0x4
80105cfc:	bb c4 79 10 80       	mov    $0x801079c4,%ebx
80105d01:	e8 8a c5 ff ff       	call   80102290 <ioapicenable>
80105d06:	83 c4 10             	add    $0x10,%esp
80105d09:	b8 78 00 00 00       	mov    $0x78,%eax
80105d0e:	eb 0a                	jmp    80105d1a <uartinit+0x9a>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d10:	83 c3 01             	add    $0x1,%ebx
80105d13:	0f be 03             	movsbl (%ebx),%eax
80105d16:	84 c0                	test   %al,%al
80105d18:	74 19                	je     80105d33 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105d1a:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105d20:	85 d2                	test   %edx,%edx
80105d22:	74 ec                	je     80105d10 <uartinit+0x90>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d24:	83 c3 01             	add    $0x1,%ebx
80105d27:	e8 04 ff ff ff       	call   80105c30 <uartputc.part.0>
80105d2c:	0f be 03             	movsbl (%ebx),%eax
80105d2f:	84 c0                	test   %al,%al
80105d31:	75 e7                	jne    80105d1a <uartinit+0x9a>
    uartputc(*p);
}
80105d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d36:	5b                   	pop    %ebx
80105d37:	5e                   	pop    %esi
80105d38:	5f                   	pop    %edi
80105d39:	5d                   	pop    %ebp
80105d3a:	c3                   	ret    
80105d3b:	90                   	nop
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d40 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105d40:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105d46:	55                   	push   %ebp
80105d47:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105d49:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105d4e:	74 10                	je     80105d60 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105d50:	5d                   	pop    %ebp
80105d51:	e9 da fe ff ff       	jmp    80105c30 <uartputc.part.0>
80105d56:	8d 76 00             	lea    0x0(%esi),%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d60:	5d                   	pop    %ebp
80105d61:	c3                   	ret    
80105d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d76:	68 00 5c 10 80       	push   $0x80105c00
80105d7b:	e8 70 aa ff ff       	call   801007f0 <consoleintr>
}
80105d80:	83 c4 10             	add    $0x10,%esp
80105d83:	c9                   	leave  
80105d84:	c3                   	ret    

80105d85 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d85:	6a 00                	push   $0x0
  pushl $0
80105d87:	6a 00                	push   $0x0
  jmp alltraps
80105d89:	e9 e0 fa ff ff       	jmp    8010586e <alltraps>

80105d8e <vector1>:
.globl vector1
vector1:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $1
80105d90:	6a 01                	push   $0x1
  jmp alltraps
80105d92:	e9 d7 fa ff ff       	jmp    8010586e <alltraps>

80105d97 <vector2>:
.globl vector2
vector2:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $2
80105d99:	6a 02                	push   $0x2
  jmp alltraps
80105d9b:	e9 ce fa ff ff       	jmp    8010586e <alltraps>

80105da0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105da0:	6a 00                	push   $0x0
  pushl $3
80105da2:	6a 03                	push   $0x3
  jmp alltraps
80105da4:	e9 c5 fa ff ff       	jmp    8010586e <alltraps>

80105da9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $4
80105dab:	6a 04                	push   $0x4
  jmp alltraps
80105dad:	e9 bc fa ff ff       	jmp    8010586e <alltraps>

80105db2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $5
80105db4:	6a 05                	push   $0x5
  jmp alltraps
80105db6:	e9 b3 fa ff ff       	jmp    8010586e <alltraps>

80105dbb <vector6>:
.globl vector6
vector6:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $6
80105dbd:	6a 06                	push   $0x6
  jmp alltraps
80105dbf:	e9 aa fa ff ff       	jmp    8010586e <alltraps>

80105dc4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $7
80105dc6:	6a 07                	push   $0x7
  jmp alltraps
80105dc8:	e9 a1 fa ff ff       	jmp    8010586e <alltraps>

80105dcd <vector8>:
.globl vector8
vector8:
  pushl $8
80105dcd:	6a 08                	push   $0x8
  jmp alltraps
80105dcf:	e9 9a fa ff ff       	jmp    8010586e <alltraps>

80105dd4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $9
80105dd6:	6a 09                	push   $0x9
  jmp alltraps
80105dd8:	e9 91 fa ff ff       	jmp    8010586e <alltraps>

80105ddd <vector10>:
.globl vector10
vector10:
  pushl $10
80105ddd:	6a 0a                	push   $0xa
  jmp alltraps
80105ddf:	e9 8a fa ff ff       	jmp    8010586e <alltraps>

80105de4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105de4:	6a 0b                	push   $0xb
  jmp alltraps
80105de6:	e9 83 fa ff ff       	jmp    8010586e <alltraps>

80105deb <vector12>:
.globl vector12
vector12:
  pushl $12
80105deb:	6a 0c                	push   $0xc
  jmp alltraps
80105ded:	e9 7c fa ff ff       	jmp    8010586e <alltraps>

80105df2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105df2:	6a 0d                	push   $0xd
  jmp alltraps
80105df4:	e9 75 fa ff ff       	jmp    8010586e <alltraps>

80105df9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105df9:	6a 0e                	push   $0xe
  jmp alltraps
80105dfb:	e9 6e fa ff ff       	jmp    8010586e <alltraps>

80105e00 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $15
80105e02:	6a 0f                	push   $0xf
  jmp alltraps
80105e04:	e9 65 fa ff ff       	jmp    8010586e <alltraps>

80105e09 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $16
80105e0b:	6a 10                	push   $0x10
  jmp alltraps
80105e0d:	e9 5c fa ff ff       	jmp    8010586e <alltraps>

80105e12 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e12:	6a 11                	push   $0x11
  jmp alltraps
80105e14:	e9 55 fa ff ff       	jmp    8010586e <alltraps>

80105e19 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $18
80105e1b:	6a 12                	push   $0x12
  jmp alltraps
80105e1d:	e9 4c fa ff ff       	jmp    8010586e <alltraps>

80105e22 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $19
80105e24:	6a 13                	push   $0x13
  jmp alltraps
80105e26:	e9 43 fa ff ff       	jmp    8010586e <alltraps>

80105e2b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $20
80105e2d:	6a 14                	push   $0x14
  jmp alltraps
80105e2f:	e9 3a fa ff ff       	jmp    8010586e <alltraps>

80105e34 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $21
80105e36:	6a 15                	push   $0x15
  jmp alltraps
80105e38:	e9 31 fa ff ff       	jmp    8010586e <alltraps>

80105e3d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $22
80105e3f:	6a 16                	push   $0x16
  jmp alltraps
80105e41:	e9 28 fa ff ff       	jmp    8010586e <alltraps>

80105e46 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $23
80105e48:	6a 17                	push   $0x17
  jmp alltraps
80105e4a:	e9 1f fa ff ff       	jmp    8010586e <alltraps>

80105e4f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $24
80105e51:	6a 18                	push   $0x18
  jmp alltraps
80105e53:	e9 16 fa ff ff       	jmp    8010586e <alltraps>

80105e58 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $25
80105e5a:	6a 19                	push   $0x19
  jmp alltraps
80105e5c:	e9 0d fa ff ff       	jmp    8010586e <alltraps>

80105e61 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $26
80105e63:	6a 1a                	push   $0x1a
  jmp alltraps
80105e65:	e9 04 fa ff ff       	jmp    8010586e <alltraps>

80105e6a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $27
80105e6c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e6e:	e9 fb f9 ff ff       	jmp    8010586e <alltraps>

80105e73 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $28
80105e75:	6a 1c                	push   $0x1c
  jmp alltraps
80105e77:	e9 f2 f9 ff ff       	jmp    8010586e <alltraps>

80105e7c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $29
80105e7e:	6a 1d                	push   $0x1d
  jmp alltraps
80105e80:	e9 e9 f9 ff ff       	jmp    8010586e <alltraps>

80105e85 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $30
80105e87:	6a 1e                	push   $0x1e
  jmp alltraps
80105e89:	e9 e0 f9 ff ff       	jmp    8010586e <alltraps>

80105e8e <vector31>:
.globl vector31
vector31:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $31
80105e90:	6a 1f                	push   $0x1f
  jmp alltraps
80105e92:	e9 d7 f9 ff ff       	jmp    8010586e <alltraps>

80105e97 <vector32>:
.globl vector32
vector32:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $32
80105e99:	6a 20                	push   $0x20
  jmp alltraps
80105e9b:	e9 ce f9 ff ff       	jmp    8010586e <alltraps>

80105ea0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $33
80105ea2:	6a 21                	push   $0x21
  jmp alltraps
80105ea4:	e9 c5 f9 ff ff       	jmp    8010586e <alltraps>

80105ea9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $34
80105eab:	6a 22                	push   $0x22
  jmp alltraps
80105ead:	e9 bc f9 ff ff       	jmp    8010586e <alltraps>

80105eb2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $35
80105eb4:	6a 23                	push   $0x23
  jmp alltraps
80105eb6:	e9 b3 f9 ff ff       	jmp    8010586e <alltraps>

80105ebb <vector36>:
.globl vector36
vector36:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $36
80105ebd:	6a 24                	push   $0x24
  jmp alltraps
80105ebf:	e9 aa f9 ff ff       	jmp    8010586e <alltraps>

80105ec4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $37
80105ec6:	6a 25                	push   $0x25
  jmp alltraps
80105ec8:	e9 a1 f9 ff ff       	jmp    8010586e <alltraps>

80105ecd <vector38>:
.globl vector38
vector38:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $38
80105ecf:	6a 26                	push   $0x26
  jmp alltraps
80105ed1:	e9 98 f9 ff ff       	jmp    8010586e <alltraps>

80105ed6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $39
80105ed8:	6a 27                	push   $0x27
  jmp alltraps
80105eda:	e9 8f f9 ff ff       	jmp    8010586e <alltraps>

80105edf <vector40>:
.globl vector40
vector40:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $40
80105ee1:	6a 28                	push   $0x28
  jmp alltraps
80105ee3:	e9 86 f9 ff ff       	jmp    8010586e <alltraps>

80105ee8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $41
80105eea:	6a 29                	push   $0x29
  jmp alltraps
80105eec:	e9 7d f9 ff ff       	jmp    8010586e <alltraps>

80105ef1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $42
80105ef3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ef5:	e9 74 f9 ff ff       	jmp    8010586e <alltraps>

80105efa <vector43>:
.globl vector43
vector43:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $43
80105efc:	6a 2b                	push   $0x2b
  jmp alltraps
80105efe:	e9 6b f9 ff ff       	jmp    8010586e <alltraps>

80105f03 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $44
80105f05:	6a 2c                	push   $0x2c
  jmp alltraps
80105f07:	e9 62 f9 ff ff       	jmp    8010586e <alltraps>

80105f0c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $45
80105f0e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f10:	e9 59 f9 ff ff       	jmp    8010586e <alltraps>

80105f15 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $46
80105f17:	6a 2e                	push   $0x2e
  jmp alltraps
80105f19:	e9 50 f9 ff ff       	jmp    8010586e <alltraps>

80105f1e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $47
80105f20:	6a 2f                	push   $0x2f
  jmp alltraps
80105f22:	e9 47 f9 ff ff       	jmp    8010586e <alltraps>

80105f27 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $48
80105f29:	6a 30                	push   $0x30
  jmp alltraps
80105f2b:	e9 3e f9 ff ff       	jmp    8010586e <alltraps>

80105f30 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $49
80105f32:	6a 31                	push   $0x31
  jmp alltraps
80105f34:	e9 35 f9 ff ff       	jmp    8010586e <alltraps>

80105f39 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $50
80105f3b:	6a 32                	push   $0x32
  jmp alltraps
80105f3d:	e9 2c f9 ff ff       	jmp    8010586e <alltraps>

80105f42 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $51
80105f44:	6a 33                	push   $0x33
  jmp alltraps
80105f46:	e9 23 f9 ff ff       	jmp    8010586e <alltraps>

80105f4b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $52
80105f4d:	6a 34                	push   $0x34
  jmp alltraps
80105f4f:	e9 1a f9 ff ff       	jmp    8010586e <alltraps>

80105f54 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $53
80105f56:	6a 35                	push   $0x35
  jmp alltraps
80105f58:	e9 11 f9 ff ff       	jmp    8010586e <alltraps>

80105f5d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $54
80105f5f:	6a 36                	push   $0x36
  jmp alltraps
80105f61:	e9 08 f9 ff ff       	jmp    8010586e <alltraps>

80105f66 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $55
80105f68:	6a 37                	push   $0x37
  jmp alltraps
80105f6a:	e9 ff f8 ff ff       	jmp    8010586e <alltraps>

80105f6f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $56
80105f71:	6a 38                	push   $0x38
  jmp alltraps
80105f73:	e9 f6 f8 ff ff       	jmp    8010586e <alltraps>

80105f78 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $57
80105f7a:	6a 39                	push   $0x39
  jmp alltraps
80105f7c:	e9 ed f8 ff ff       	jmp    8010586e <alltraps>

80105f81 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $58
80105f83:	6a 3a                	push   $0x3a
  jmp alltraps
80105f85:	e9 e4 f8 ff ff       	jmp    8010586e <alltraps>

80105f8a <vector59>:
.globl vector59
vector59:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $59
80105f8c:	6a 3b                	push   $0x3b
  jmp alltraps
80105f8e:	e9 db f8 ff ff       	jmp    8010586e <alltraps>

80105f93 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $60
80105f95:	6a 3c                	push   $0x3c
  jmp alltraps
80105f97:	e9 d2 f8 ff ff       	jmp    8010586e <alltraps>

80105f9c <vector61>:
.globl vector61
vector61:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $61
80105f9e:	6a 3d                	push   $0x3d
  jmp alltraps
80105fa0:	e9 c9 f8 ff ff       	jmp    8010586e <alltraps>

80105fa5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $62
80105fa7:	6a 3e                	push   $0x3e
  jmp alltraps
80105fa9:	e9 c0 f8 ff ff       	jmp    8010586e <alltraps>

80105fae <vector63>:
.globl vector63
vector63:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $63
80105fb0:	6a 3f                	push   $0x3f
  jmp alltraps
80105fb2:	e9 b7 f8 ff ff       	jmp    8010586e <alltraps>

80105fb7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $64
80105fb9:	6a 40                	push   $0x40
  jmp alltraps
80105fbb:	e9 ae f8 ff ff       	jmp    8010586e <alltraps>

80105fc0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $65
80105fc2:	6a 41                	push   $0x41
  jmp alltraps
80105fc4:	e9 a5 f8 ff ff       	jmp    8010586e <alltraps>

80105fc9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $66
80105fcb:	6a 42                	push   $0x42
  jmp alltraps
80105fcd:	e9 9c f8 ff ff       	jmp    8010586e <alltraps>

80105fd2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $67
80105fd4:	6a 43                	push   $0x43
  jmp alltraps
80105fd6:	e9 93 f8 ff ff       	jmp    8010586e <alltraps>

80105fdb <vector68>:
.globl vector68
vector68:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $68
80105fdd:	6a 44                	push   $0x44
  jmp alltraps
80105fdf:	e9 8a f8 ff ff       	jmp    8010586e <alltraps>

80105fe4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $69
80105fe6:	6a 45                	push   $0x45
  jmp alltraps
80105fe8:	e9 81 f8 ff ff       	jmp    8010586e <alltraps>

80105fed <vector70>:
.globl vector70
vector70:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $70
80105fef:	6a 46                	push   $0x46
  jmp alltraps
80105ff1:	e9 78 f8 ff ff       	jmp    8010586e <alltraps>

80105ff6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $71
80105ff8:	6a 47                	push   $0x47
  jmp alltraps
80105ffa:	e9 6f f8 ff ff       	jmp    8010586e <alltraps>

80105fff <vector72>:
.globl vector72
vector72:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $72
80106001:	6a 48                	push   $0x48
  jmp alltraps
80106003:	e9 66 f8 ff ff       	jmp    8010586e <alltraps>

80106008 <vector73>:
.globl vector73
vector73:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $73
8010600a:	6a 49                	push   $0x49
  jmp alltraps
8010600c:	e9 5d f8 ff ff       	jmp    8010586e <alltraps>

80106011 <vector74>:
.globl vector74
vector74:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $74
80106013:	6a 4a                	push   $0x4a
  jmp alltraps
80106015:	e9 54 f8 ff ff       	jmp    8010586e <alltraps>

8010601a <vector75>:
.globl vector75
vector75:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $75
8010601c:	6a 4b                	push   $0x4b
  jmp alltraps
8010601e:	e9 4b f8 ff ff       	jmp    8010586e <alltraps>

80106023 <vector76>:
.globl vector76
vector76:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $76
80106025:	6a 4c                	push   $0x4c
  jmp alltraps
80106027:	e9 42 f8 ff ff       	jmp    8010586e <alltraps>

8010602c <vector77>:
.globl vector77
vector77:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $77
8010602e:	6a 4d                	push   $0x4d
  jmp alltraps
80106030:	e9 39 f8 ff ff       	jmp    8010586e <alltraps>

80106035 <vector78>:
.globl vector78
vector78:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $78
80106037:	6a 4e                	push   $0x4e
  jmp alltraps
80106039:	e9 30 f8 ff ff       	jmp    8010586e <alltraps>

8010603e <vector79>:
.globl vector79
vector79:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $79
80106040:	6a 4f                	push   $0x4f
  jmp alltraps
80106042:	e9 27 f8 ff ff       	jmp    8010586e <alltraps>

80106047 <vector80>:
.globl vector80
vector80:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $80
80106049:	6a 50                	push   $0x50
  jmp alltraps
8010604b:	e9 1e f8 ff ff       	jmp    8010586e <alltraps>

80106050 <vector81>:
.globl vector81
vector81:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $81
80106052:	6a 51                	push   $0x51
  jmp alltraps
80106054:	e9 15 f8 ff ff       	jmp    8010586e <alltraps>

80106059 <vector82>:
.globl vector82
vector82:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $82
8010605b:	6a 52                	push   $0x52
  jmp alltraps
8010605d:	e9 0c f8 ff ff       	jmp    8010586e <alltraps>

80106062 <vector83>:
.globl vector83
vector83:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $83
80106064:	6a 53                	push   $0x53
  jmp alltraps
80106066:	e9 03 f8 ff ff       	jmp    8010586e <alltraps>

8010606b <vector84>:
.globl vector84
vector84:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $84
8010606d:	6a 54                	push   $0x54
  jmp alltraps
8010606f:	e9 fa f7 ff ff       	jmp    8010586e <alltraps>

80106074 <vector85>:
.globl vector85
vector85:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $85
80106076:	6a 55                	push   $0x55
  jmp alltraps
80106078:	e9 f1 f7 ff ff       	jmp    8010586e <alltraps>

8010607d <vector86>:
.globl vector86
vector86:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $86
8010607f:	6a 56                	push   $0x56
  jmp alltraps
80106081:	e9 e8 f7 ff ff       	jmp    8010586e <alltraps>

80106086 <vector87>:
.globl vector87
vector87:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $87
80106088:	6a 57                	push   $0x57
  jmp alltraps
8010608a:	e9 df f7 ff ff       	jmp    8010586e <alltraps>

8010608f <vector88>:
.globl vector88
vector88:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $88
80106091:	6a 58                	push   $0x58
  jmp alltraps
80106093:	e9 d6 f7 ff ff       	jmp    8010586e <alltraps>

80106098 <vector89>:
.globl vector89
vector89:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $89
8010609a:	6a 59                	push   $0x59
  jmp alltraps
8010609c:	e9 cd f7 ff ff       	jmp    8010586e <alltraps>

801060a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $90
801060a3:	6a 5a                	push   $0x5a
  jmp alltraps
801060a5:	e9 c4 f7 ff ff       	jmp    8010586e <alltraps>

801060aa <vector91>:
.globl vector91
vector91:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $91
801060ac:	6a 5b                	push   $0x5b
  jmp alltraps
801060ae:	e9 bb f7 ff ff       	jmp    8010586e <alltraps>

801060b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $92
801060b5:	6a 5c                	push   $0x5c
  jmp alltraps
801060b7:	e9 b2 f7 ff ff       	jmp    8010586e <alltraps>

801060bc <vector93>:
.globl vector93
vector93:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $93
801060be:	6a 5d                	push   $0x5d
  jmp alltraps
801060c0:	e9 a9 f7 ff ff       	jmp    8010586e <alltraps>

801060c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $94
801060c7:	6a 5e                	push   $0x5e
  jmp alltraps
801060c9:	e9 a0 f7 ff ff       	jmp    8010586e <alltraps>

801060ce <vector95>:
.globl vector95
vector95:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $95
801060d0:	6a 5f                	push   $0x5f
  jmp alltraps
801060d2:	e9 97 f7 ff ff       	jmp    8010586e <alltraps>

801060d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $96
801060d9:	6a 60                	push   $0x60
  jmp alltraps
801060db:	e9 8e f7 ff ff       	jmp    8010586e <alltraps>

801060e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $97
801060e2:	6a 61                	push   $0x61
  jmp alltraps
801060e4:	e9 85 f7 ff ff       	jmp    8010586e <alltraps>

801060e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $98
801060eb:	6a 62                	push   $0x62
  jmp alltraps
801060ed:	e9 7c f7 ff ff       	jmp    8010586e <alltraps>

801060f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $99
801060f4:	6a 63                	push   $0x63
  jmp alltraps
801060f6:	e9 73 f7 ff ff       	jmp    8010586e <alltraps>

801060fb <vector100>:
.globl vector100
vector100:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $100
801060fd:	6a 64                	push   $0x64
  jmp alltraps
801060ff:	e9 6a f7 ff ff       	jmp    8010586e <alltraps>

80106104 <vector101>:
.globl vector101
vector101:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $101
80106106:	6a 65                	push   $0x65
  jmp alltraps
80106108:	e9 61 f7 ff ff       	jmp    8010586e <alltraps>

8010610d <vector102>:
.globl vector102
vector102:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $102
8010610f:	6a 66                	push   $0x66
  jmp alltraps
80106111:	e9 58 f7 ff ff       	jmp    8010586e <alltraps>

80106116 <vector103>:
.globl vector103
vector103:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $103
80106118:	6a 67                	push   $0x67
  jmp alltraps
8010611a:	e9 4f f7 ff ff       	jmp    8010586e <alltraps>

8010611f <vector104>:
.globl vector104
vector104:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $104
80106121:	6a 68                	push   $0x68
  jmp alltraps
80106123:	e9 46 f7 ff ff       	jmp    8010586e <alltraps>

80106128 <vector105>:
.globl vector105
vector105:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $105
8010612a:	6a 69                	push   $0x69
  jmp alltraps
8010612c:	e9 3d f7 ff ff       	jmp    8010586e <alltraps>

80106131 <vector106>:
.globl vector106
vector106:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $106
80106133:	6a 6a                	push   $0x6a
  jmp alltraps
80106135:	e9 34 f7 ff ff       	jmp    8010586e <alltraps>

8010613a <vector107>:
.globl vector107
vector107:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $107
8010613c:	6a 6b                	push   $0x6b
  jmp alltraps
8010613e:	e9 2b f7 ff ff       	jmp    8010586e <alltraps>

80106143 <vector108>:
.globl vector108
vector108:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $108
80106145:	6a 6c                	push   $0x6c
  jmp alltraps
80106147:	e9 22 f7 ff ff       	jmp    8010586e <alltraps>

8010614c <vector109>:
.globl vector109
vector109:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $109
8010614e:	6a 6d                	push   $0x6d
  jmp alltraps
80106150:	e9 19 f7 ff ff       	jmp    8010586e <alltraps>

80106155 <vector110>:
.globl vector110
vector110:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $110
80106157:	6a 6e                	push   $0x6e
  jmp alltraps
80106159:	e9 10 f7 ff ff       	jmp    8010586e <alltraps>

8010615e <vector111>:
.globl vector111
vector111:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $111
80106160:	6a 6f                	push   $0x6f
  jmp alltraps
80106162:	e9 07 f7 ff ff       	jmp    8010586e <alltraps>

80106167 <vector112>:
.globl vector112
vector112:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $112
80106169:	6a 70                	push   $0x70
  jmp alltraps
8010616b:	e9 fe f6 ff ff       	jmp    8010586e <alltraps>

80106170 <vector113>:
.globl vector113
vector113:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $113
80106172:	6a 71                	push   $0x71
  jmp alltraps
80106174:	e9 f5 f6 ff ff       	jmp    8010586e <alltraps>

80106179 <vector114>:
.globl vector114
vector114:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $114
8010617b:	6a 72                	push   $0x72
  jmp alltraps
8010617d:	e9 ec f6 ff ff       	jmp    8010586e <alltraps>

80106182 <vector115>:
.globl vector115
vector115:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $115
80106184:	6a 73                	push   $0x73
  jmp alltraps
80106186:	e9 e3 f6 ff ff       	jmp    8010586e <alltraps>

8010618b <vector116>:
.globl vector116
vector116:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $116
8010618d:	6a 74                	push   $0x74
  jmp alltraps
8010618f:	e9 da f6 ff ff       	jmp    8010586e <alltraps>

80106194 <vector117>:
.globl vector117
vector117:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $117
80106196:	6a 75                	push   $0x75
  jmp alltraps
80106198:	e9 d1 f6 ff ff       	jmp    8010586e <alltraps>

8010619d <vector118>:
.globl vector118
vector118:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $118
8010619f:	6a 76                	push   $0x76
  jmp alltraps
801061a1:	e9 c8 f6 ff ff       	jmp    8010586e <alltraps>

801061a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $119
801061a8:	6a 77                	push   $0x77
  jmp alltraps
801061aa:	e9 bf f6 ff ff       	jmp    8010586e <alltraps>

801061af <vector120>:
.globl vector120
vector120:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $120
801061b1:	6a 78                	push   $0x78
  jmp alltraps
801061b3:	e9 b6 f6 ff ff       	jmp    8010586e <alltraps>

801061b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $121
801061ba:	6a 79                	push   $0x79
  jmp alltraps
801061bc:	e9 ad f6 ff ff       	jmp    8010586e <alltraps>

801061c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $122
801061c3:	6a 7a                	push   $0x7a
  jmp alltraps
801061c5:	e9 a4 f6 ff ff       	jmp    8010586e <alltraps>

801061ca <vector123>:
.globl vector123
vector123:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $123
801061cc:	6a 7b                	push   $0x7b
  jmp alltraps
801061ce:	e9 9b f6 ff ff       	jmp    8010586e <alltraps>

801061d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $124
801061d5:	6a 7c                	push   $0x7c
  jmp alltraps
801061d7:	e9 92 f6 ff ff       	jmp    8010586e <alltraps>

801061dc <vector125>:
.globl vector125
vector125:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $125
801061de:	6a 7d                	push   $0x7d
  jmp alltraps
801061e0:	e9 89 f6 ff ff       	jmp    8010586e <alltraps>

801061e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $126
801061e7:	6a 7e                	push   $0x7e
  jmp alltraps
801061e9:	e9 80 f6 ff ff       	jmp    8010586e <alltraps>

801061ee <vector127>:
.globl vector127
vector127:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $127
801061f0:	6a 7f                	push   $0x7f
  jmp alltraps
801061f2:	e9 77 f6 ff ff       	jmp    8010586e <alltraps>

801061f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $128
801061f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801061fe:	e9 6b f6 ff ff       	jmp    8010586e <alltraps>

80106203 <vector129>:
.globl vector129
vector129:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $129
80106205:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010620a:	e9 5f f6 ff ff       	jmp    8010586e <alltraps>

8010620f <vector130>:
.globl vector130
vector130:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $130
80106211:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106216:	e9 53 f6 ff ff       	jmp    8010586e <alltraps>

8010621b <vector131>:
.globl vector131
vector131:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $131
8010621d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106222:	e9 47 f6 ff ff       	jmp    8010586e <alltraps>

80106227 <vector132>:
.globl vector132
vector132:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $132
80106229:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010622e:	e9 3b f6 ff ff       	jmp    8010586e <alltraps>

80106233 <vector133>:
.globl vector133
vector133:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $133
80106235:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010623a:	e9 2f f6 ff ff       	jmp    8010586e <alltraps>

8010623f <vector134>:
.globl vector134
vector134:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $134
80106241:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106246:	e9 23 f6 ff ff       	jmp    8010586e <alltraps>

8010624b <vector135>:
.globl vector135
vector135:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $135
8010624d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106252:	e9 17 f6 ff ff       	jmp    8010586e <alltraps>

80106257 <vector136>:
.globl vector136
vector136:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $136
80106259:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010625e:	e9 0b f6 ff ff       	jmp    8010586e <alltraps>

80106263 <vector137>:
.globl vector137
vector137:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $137
80106265:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010626a:	e9 ff f5 ff ff       	jmp    8010586e <alltraps>

8010626f <vector138>:
.globl vector138
vector138:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $138
80106271:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106276:	e9 f3 f5 ff ff       	jmp    8010586e <alltraps>

8010627b <vector139>:
.globl vector139
vector139:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $139
8010627d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106282:	e9 e7 f5 ff ff       	jmp    8010586e <alltraps>

80106287 <vector140>:
.globl vector140
vector140:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $140
80106289:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010628e:	e9 db f5 ff ff       	jmp    8010586e <alltraps>

80106293 <vector141>:
.globl vector141
vector141:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $141
80106295:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010629a:	e9 cf f5 ff ff       	jmp    8010586e <alltraps>

8010629f <vector142>:
.globl vector142
vector142:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $142
801062a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062a6:	e9 c3 f5 ff ff       	jmp    8010586e <alltraps>

801062ab <vector143>:
.globl vector143
vector143:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $143
801062ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062b2:	e9 b7 f5 ff ff       	jmp    8010586e <alltraps>

801062b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $144
801062b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062be:	e9 ab f5 ff ff       	jmp    8010586e <alltraps>

801062c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $145
801062c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062ca:	e9 9f f5 ff ff       	jmp    8010586e <alltraps>

801062cf <vector146>:
.globl vector146
vector146:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $146
801062d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062d6:	e9 93 f5 ff ff       	jmp    8010586e <alltraps>

801062db <vector147>:
.globl vector147
vector147:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $147
801062dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801062e2:	e9 87 f5 ff ff       	jmp    8010586e <alltraps>

801062e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $148
801062e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801062ee:	e9 7b f5 ff ff       	jmp    8010586e <alltraps>

801062f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $149
801062f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801062fa:	e9 6f f5 ff ff       	jmp    8010586e <alltraps>

801062ff <vector150>:
.globl vector150
vector150:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $150
80106301:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106306:	e9 63 f5 ff ff       	jmp    8010586e <alltraps>

8010630b <vector151>:
.globl vector151
vector151:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $151
8010630d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106312:	e9 57 f5 ff ff       	jmp    8010586e <alltraps>

80106317 <vector152>:
.globl vector152
vector152:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $152
80106319:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010631e:	e9 4b f5 ff ff       	jmp    8010586e <alltraps>

80106323 <vector153>:
.globl vector153
vector153:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $153
80106325:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010632a:	e9 3f f5 ff ff       	jmp    8010586e <alltraps>

8010632f <vector154>:
.globl vector154
vector154:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $154
80106331:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106336:	e9 33 f5 ff ff       	jmp    8010586e <alltraps>

8010633b <vector155>:
.globl vector155
vector155:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $155
8010633d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106342:	e9 27 f5 ff ff       	jmp    8010586e <alltraps>

80106347 <vector156>:
.globl vector156
vector156:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $156
80106349:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010634e:	e9 1b f5 ff ff       	jmp    8010586e <alltraps>

80106353 <vector157>:
.globl vector157
vector157:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $157
80106355:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010635a:	e9 0f f5 ff ff       	jmp    8010586e <alltraps>

8010635f <vector158>:
.globl vector158
vector158:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $158
80106361:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106366:	e9 03 f5 ff ff       	jmp    8010586e <alltraps>

8010636b <vector159>:
.globl vector159
vector159:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $159
8010636d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106372:	e9 f7 f4 ff ff       	jmp    8010586e <alltraps>

80106377 <vector160>:
.globl vector160
vector160:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $160
80106379:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010637e:	e9 eb f4 ff ff       	jmp    8010586e <alltraps>

80106383 <vector161>:
.globl vector161
vector161:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $161
80106385:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010638a:	e9 df f4 ff ff       	jmp    8010586e <alltraps>

8010638f <vector162>:
.globl vector162
vector162:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $162
80106391:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106396:	e9 d3 f4 ff ff       	jmp    8010586e <alltraps>

8010639b <vector163>:
.globl vector163
vector163:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $163
8010639d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063a2:	e9 c7 f4 ff ff       	jmp    8010586e <alltraps>

801063a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $164
801063a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063ae:	e9 bb f4 ff ff       	jmp    8010586e <alltraps>

801063b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $165
801063b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063ba:	e9 af f4 ff ff       	jmp    8010586e <alltraps>

801063bf <vector166>:
.globl vector166
vector166:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $166
801063c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063c6:	e9 a3 f4 ff ff       	jmp    8010586e <alltraps>

801063cb <vector167>:
.globl vector167
vector167:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $167
801063cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063d2:	e9 97 f4 ff ff       	jmp    8010586e <alltraps>

801063d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $168
801063d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063de:	e9 8b f4 ff ff       	jmp    8010586e <alltraps>

801063e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $169
801063e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801063ea:	e9 7f f4 ff ff       	jmp    8010586e <alltraps>

801063ef <vector170>:
.globl vector170
vector170:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $170
801063f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801063f6:	e9 73 f4 ff ff       	jmp    8010586e <alltraps>

801063fb <vector171>:
.globl vector171
vector171:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $171
801063fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106402:	e9 67 f4 ff ff       	jmp    8010586e <alltraps>

80106407 <vector172>:
.globl vector172
vector172:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $172
80106409:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010640e:	e9 5b f4 ff ff       	jmp    8010586e <alltraps>

80106413 <vector173>:
.globl vector173
vector173:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $173
80106415:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010641a:	e9 4f f4 ff ff       	jmp    8010586e <alltraps>

8010641f <vector174>:
.globl vector174
vector174:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $174
80106421:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106426:	e9 43 f4 ff ff       	jmp    8010586e <alltraps>

8010642b <vector175>:
.globl vector175
vector175:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $175
8010642d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106432:	e9 37 f4 ff ff       	jmp    8010586e <alltraps>

80106437 <vector176>:
.globl vector176
vector176:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $176
80106439:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010643e:	e9 2b f4 ff ff       	jmp    8010586e <alltraps>

80106443 <vector177>:
.globl vector177
vector177:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $177
80106445:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010644a:	e9 1f f4 ff ff       	jmp    8010586e <alltraps>

8010644f <vector178>:
.globl vector178
vector178:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $178
80106451:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106456:	e9 13 f4 ff ff       	jmp    8010586e <alltraps>

8010645b <vector179>:
.globl vector179
vector179:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $179
8010645d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106462:	e9 07 f4 ff ff       	jmp    8010586e <alltraps>

80106467 <vector180>:
.globl vector180
vector180:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $180
80106469:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010646e:	e9 fb f3 ff ff       	jmp    8010586e <alltraps>

80106473 <vector181>:
.globl vector181
vector181:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $181
80106475:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010647a:	e9 ef f3 ff ff       	jmp    8010586e <alltraps>

8010647f <vector182>:
.globl vector182
vector182:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $182
80106481:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106486:	e9 e3 f3 ff ff       	jmp    8010586e <alltraps>

8010648b <vector183>:
.globl vector183
vector183:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $183
8010648d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106492:	e9 d7 f3 ff ff       	jmp    8010586e <alltraps>

80106497 <vector184>:
.globl vector184
vector184:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $184
80106499:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010649e:	e9 cb f3 ff ff       	jmp    8010586e <alltraps>

801064a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $185
801064a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064aa:	e9 bf f3 ff ff       	jmp    8010586e <alltraps>

801064af <vector186>:
.globl vector186
vector186:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $186
801064b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064b6:	e9 b3 f3 ff ff       	jmp    8010586e <alltraps>

801064bb <vector187>:
.globl vector187
vector187:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $187
801064bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064c2:	e9 a7 f3 ff ff       	jmp    8010586e <alltraps>

801064c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $188
801064c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064ce:	e9 9b f3 ff ff       	jmp    8010586e <alltraps>

801064d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $189
801064d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064da:	e9 8f f3 ff ff       	jmp    8010586e <alltraps>

801064df <vector190>:
.globl vector190
vector190:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $190
801064e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801064e6:	e9 83 f3 ff ff       	jmp    8010586e <alltraps>

801064eb <vector191>:
.globl vector191
vector191:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $191
801064ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801064f2:	e9 77 f3 ff ff       	jmp    8010586e <alltraps>

801064f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $192
801064f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801064fe:	e9 6b f3 ff ff       	jmp    8010586e <alltraps>

80106503 <vector193>:
.globl vector193
vector193:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $193
80106505:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010650a:	e9 5f f3 ff ff       	jmp    8010586e <alltraps>

8010650f <vector194>:
.globl vector194
vector194:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $194
80106511:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106516:	e9 53 f3 ff ff       	jmp    8010586e <alltraps>

8010651b <vector195>:
.globl vector195
vector195:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $195
8010651d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106522:	e9 47 f3 ff ff       	jmp    8010586e <alltraps>

80106527 <vector196>:
.globl vector196
vector196:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $196
80106529:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010652e:	e9 3b f3 ff ff       	jmp    8010586e <alltraps>

80106533 <vector197>:
.globl vector197
vector197:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $197
80106535:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010653a:	e9 2f f3 ff ff       	jmp    8010586e <alltraps>

8010653f <vector198>:
.globl vector198
vector198:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $198
80106541:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106546:	e9 23 f3 ff ff       	jmp    8010586e <alltraps>

8010654b <vector199>:
.globl vector199
vector199:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $199
8010654d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106552:	e9 17 f3 ff ff       	jmp    8010586e <alltraps>

80106557 <vector200>:
.globl vector200
vector200:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $200
80106559:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010655e:	e9 0b f3 ff ff       	jmp    8010586e <alltraps>

80106563 <vector201>:
.globl vector201
vector201:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $201
80106565:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010656a:	e9 ff f2 ff ff       	jmp    8010586e <alltraps>

8010656f <vector202>:
.globl vector202
vector202:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $202
80106571:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106576:	e9 f3 f2 ff ff       	jmp    8010586e <alltraps>

8010657b <vector203>:
.globl vector203
vector203:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $203
8010657d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106582:	e9 e7 f2 ff ff       	jmp    8010586e <alltraps>

80106587 <vector204>:
.globl vector204
vector204:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $204
80106589:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010658e:	e9 db f2 ff ff       	jmp    8010586e <alltraps>

80106593 <vector205>:
.globl vector205
vector205:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $205
80106595:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010659a:	e9 cf f2 ff ff       	jmp    8010586e <alltraps>

8010659f <vector206>:
.globl vector206
vector206:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $206
801065a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065a6:	e9 c3 f2 ff ff       	jmp    8010586e <alltraps>

801065ab <vector207>:
.globl vector207
vector207:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $207
801065ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065b2:	e9 b7 f2 ff ff       	jmp    8010586e <alltraps>

801065b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $208
801065b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065be:	e9 ab f2 ff ff       	jmp    8010586e <alltraps>

801065c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $209
801065c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065ca:	e9 9f f2 ff ff       	jmp    8010586e <alltraps>

801065cf <vector210>:
.globl vector210
vector210:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $210
801065d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065d6:	e9 93 f2 ff ff       	jmp    8010586e <alltraps>

801065db <vector211>:
.globl vector211
vector211:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $211
801065dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801065e2:	e9 87 f2 ff ff       	jmp    8010586e <alltraps>

801065e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $212
801065e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801065ee:	e9 7b f2 ff ff       	jmp    8010586e <alltraps>

801065f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $213
801065f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801065fa:	e9 6f f2 ff ff       	jmp    8010586e <alltraps>

801065ff <vector214>:
.globl vector214
vector214:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $214
80106601:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106606:	e9 63 f2 ff ff       	jmp    8010586e <alltraps>

8010660b <vector215>:
.globl vector215
vector215:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $215
8010660d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106612:	e9 57 f2 ff ff       	jmp    8010586e <alltraps>

80106617 <vector216>:
.globl vector216
vector216:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $216
80106619:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010661e:	e9 4b f2 ff ff       	jmp    8010586e <alltraps>

80106623 <vector217>:
.globl vector217
vector217:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $217
80106625:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010662a:	e9 3f f2 ff ff       	jmp    8010586e <alltraps>

8010662f <vector218>:
.globl vector218
vector218:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $218
80106631:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106636:	e9 33 f2 ff ff       	jmp    8010586e <alltraps>

8010663b <vector219>:
.globl vector219
vector219:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $219
8010663d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106642:	e9 27 f2 ff ff       	jmp    8010586e <alltraps>

80106647 <vector220>:
.globl vector220
vector220:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $220
80106649:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010664e:	e9 1b f2 ff ff       	jmp    8010586e <alltraps>

80106653 <vector221>:
.globl vector221
vector221:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $221
80106655:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010665a:	e9 0f f2 ff ff       	jmp    8010586e <alltraps>

8010665f <vector222>:
.globl vector222
vector222:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $222
80106661:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106666:	e9 03 f2 ff ff       	jmp    8010586e <alltraps>

8010666b <vector223>:
.globl vector223
vector223:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $223
8010666d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106672:	e9 f7 f1 ff ff       	jmp    8010586e <alltraps>

80106677 <vector224>:
.globl vector224
vector224:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $224
80106679:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010667e:	e9 eb f1 ff ff       	jmp    8010586e <alltraps>

80106683 <vector225>:
.globl vector225
vector225:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $225
80106685:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010668a:	e9 df f1 ff ff       	jmp    8010586e <alltraps>

8010668f <vector226>:
.globl vector226
vector226:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $226
80106691:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106696:	e9 d3 f1 ff ff       	jmp    8010586e <alltraps>

8010669b <vector227>:
.globl vector227
vector227:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $227
8010669d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066a2:	e9 c7 f1 ff ff       	jmp    8010586e <alltraps>

801066a7 <vector228>:
.globl vector228
vector228:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $228
801066a9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066ae:	e9 bb f1 ff ff       	jmp    8010586e <alltraps>

801066b3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $229
801066b5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066ba:	e9 af f1 ff ff       	jmp    8010586e <alltraps>

801066bf <vector230>:
.globl vector230
vector230:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $230
801066c1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066c6:	e9 a3 f1 ff ff       	jmp    8010586e <alltraps>

801066cb <vector231>:
.globl vector231
vector231:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $231
801066cd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066d2:	e9 97 f1 ff ff       	jmp    8010586e <alltraps>

801066d7 <vector232>:
.globl vector232
vector232:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $232
801066d9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066de:	e9 8b f1 ff ff       	jmp    8010586e <alltraps>

801066e3 <vector233>:
.globl vector233
vector233:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $233
801066e5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801066ea:	e9 7f f1 ff ff       	jmp    8010586e <alltraps>

801066ef <vector234>:
.globl vector234
vector234:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $234
801066f1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801066f6:	e9 73 f1 ff ff       	jmp    8010586e <alltraps>

801066fb <vector235>:
.globl vector235
vector235:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $235
801066fd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106702:	e9 67 f1 ff ff       	jmp    8010586e <alltraps>

80106707 <vector236>:
.globl vector236
vector236:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $236
80106709:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010670e:	e9 5b f1 ff ff       	jmp    8010586e <alltraps>

80106713 <vector237>:
.globl vector237
vector237:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $237
80106715:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010671a:	e9 4f f1 ff ff       	jmp    8010586e <alltraps>

8010671f <vector238>:
.globl vector238
vector238:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $238
80106721:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106726:	e9 43 f1 ff ff       	jmp    8010586e <alltraps>

8010672b <vector239>:
.globl vector239
vector239:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $239
8010672d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106732:	e9 37 f1 ff ff       	jmp    8010586e <alltraps>

80106737 <vector240>:
.globl vector240
vector240:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $240
80106739:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010673e:	e9 2b f1 ff ff       	jmp    8010586e <alltraps>

80106743 <vector241>:
.globl vector241
vector241:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $241
80106745:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010674a:	e9 1f f1 ff ff       	jmp    8010586e <alltraps>

8010674f <vector242>:
.globl vector242
vector242:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $242
80106751:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106756:	e9 13 f1 ff ff       	jmp    8010586e <alltraps>

8010675b <vector243>:
.globl vector243
vector243:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $243
8010675d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106762:	e9 07 f1 ff ff       	jmp    8010586e <alltraps>

80106767 <vector244>:
.globl vector244
vector244:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $244
80106769:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010676e:	e9 fb f0 ff ff       	jmp    8010586e <alltraps>

80106773 <vector245>:
.globl vector245
vector245:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $245
80106775:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010677a:	e9 ef f0 ff ff       	jmp    8010586e <alltraps>

8010677f <vector246>:
.globl vector246
vector246:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $246
80106781:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106786:	e9 e3 f0 ff ff       	jmp    8010586e <alltraps>

8010678b <vector247>:
.globl vector247
vector247:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $247
8010678d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106792:	e9 d7 f0 ff ff       	jmp    8010586e <alltraps>

80106797 <vector248>:
.globl vector248
vector248:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $248
80106799:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010679e:	e9 cb f0 ff ff       	jmp    8010586e <alltraps>

801067a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $249
801067a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067aa:	e9 bf f0 ff ff       	jmp    8010586e <alltraps>

801067af <vector250>:
.globl vector250
vector250:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $250
801067b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067b6:	e9 b3 f0 ff ff       	jmp    8010586e <alltraps>

801067bb <vector251>:
.globl vector251
vector251:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $251
801067bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067c2:	e9 a7 f0 ff ff       	jmp    8010586e <alltraps>

801067c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $252
801067c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067ce:	e9 9b f0 ff ff       	jmp    8010586e <alltraps>

801067d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $253
801067d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067da:	e9 8f f0 ff ff       	jmp    8010586e <alltraps>

801067df <vector254>:
.globl vector254
vector254:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $254
801067e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801067e6:	e9 83 f0 ff ff       	jmp    8010586e <alltraps>

801067eb <vector255>:
.globl vector255
vector255:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $255
801067ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801067f2:	e9 77 f0 ff ff       	jmp    8010586e <alltraps>
801067f7:	66 90                	xchg   %ax,%ax
801067f9:	66 90                	xchg   %ax,%ax
801067fb:	66 90                	xchg   %ax,%ax
801067fd:	66 90                	xchg   %ax,%ax
801067ff:	90                   	nop

80106800 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
80106805:	53                   	push   %ebx
80106806:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106808:	c1 ea 16             	shr    $0x16,%edx
8010680b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010680e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106811:	8b 07                	mov    (%edi),%eax
80106813:	a8 01                	test   $0x1,%al
80106815:	74 29                	je     80106840 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106817:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010681c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106822:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106825:	c1 eb 0a             	shr    $0xa,%ebx
80106828:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010682e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106831:	5b                   	pop    %ebx
80106832:	5e                   	pop    %esi
80106833:	5f                   	pop    %edi
80106834:	5d                   	pop    %ebp
80106835:	c3                   	ret    
80106836:	8d 76 00             	lea    0x0(%esi),%esi
80106839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106840:	85 c9                	test   %ecx,%ecx
80106842:	74 2c                	je     80106870 <walkpgdir+0x70>
80106844:	e8 37 bc ff ff       	call   80102480 <kalloc>
80106849:	85 c0                	test   %eax,%eax
8010684b:	89 c6                	mov    %eax,%esi
8010684d:	74 21                	je     80106870 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010684f:	83 ec 04             	sub    $0x4,%esp
80106852:	68 00 10 00 00       	push   $0x1000
80106857:	6a 00                	push   $0x0
80106859:	50                   	push   %eax
8010685a:	e8 a1 dd ff ff       	call   80104600 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010685f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106865:	83 c4 10             	add    $0x10,%esp
80106868:	83 c8 07             	or     $0x7,%eax
8010686b:	89 07                	mov    %eax,(%edi)
8010686d:	eb b3                	jmp    80106822 <walkpgdir+0x22>
8010686f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106870:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106873:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106875:	5b                   	pop    %ebx
80106876:	5e                   	pop    %esi
80106877:	5f                   	pop    %edi
80106878:	5d                   	pop    %ebp
80106879:	c3                   	ret    
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106880 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106886:	89 d3                	mov    %edx,%ebx
80106888:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010688e:	83 ec 1c             	sub    $0x1c,%esp
80106891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106894:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106898:	8b 7d 08             	mov    0x8(%ebp),%edi
8010689b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801068a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801068a6:	29 df                	sub    %ebx,%edi
801068a8:	83 c8 01             	or     $0x1,%eax
801068ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068ae:	eb 15                	jmp    801068c5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801068b0:	f6 00 01             	testb  $0x1,(%eax)
801068b3:	75 45                	jne    801068fa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801068b5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801068b8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801068bb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801068bd:	74 31                	je     801068f0 <mappages+0x70>
      break;
    a += PGSIZE;
801068bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068c8:	b9 01 00 00 00       	mov    $0x1,%ecx
801068cd:	89 da                	mov    %ebx,%edx
801068cf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801068d2:	e8 29 ff ff ff       	call   80106800 <walkpgdir>
801068d7:	85 c0                	test   %eax,%eax
801068d9:	75 d5                	jne    801068b0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801068db:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801068de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801068e3:	5b                   	pop    %ebx
801068e4:	5e                   	pop    %esi
801068e5:	5f                   	pop    %edi
801068e6:	5d                   	pop    %ebp
801068e7:	c3                   	ret    
801068e8:	90                   	nop
801068e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801068f3:	31 c0                	xor    %eax,%eax
}
801068f5:	5b                   	pop    %ebx
801068f6:	5e                   	pop    %esi
801068f7:	5f                   	pop    %edi
801068f8:	5d                   	pop    %ebp
801068f9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801068fa:	83 ec 0c             	sub    $0xc,%esp
801068fd:	68 cc 79 10 80       	push   $0x801079cc
80106902:	e8 69 9a ff ff       	call   80100370 <panic>
80106907:	89 f6                	mov    %esi,%esi
80106909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106910 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106916:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010691c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010691e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106924:	83 ec 1c             	sub    $0x1c,%esp
80106927:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010692a:	39 d3                	cmp    %edx,%ebx
8010692c:	73 60                	jae    8010698e <deallocuvm.part.0+0x7e>
8010692e:	89 d6                	mov    %edx,%esi
80106930:	eb 3d                	jmp    8010696f <deallocuvm.part.0+0x5f>
80106932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106938:	8b 10                	mov    (%eax),%edx
8010693a:	f6 c2 01             	test   $0x1,%dl
8010693d:	74 26                	je     80106965 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010693f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106945:	74 52                	je     80106999 <deallocuvm.part.0+0x89>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106947:	83 ec 0c             	sub    $0xc,%esp
8010694a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106950:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106953:	52                   	push   %edx
80106954:	e8 77 b9 ff ff       	call   801022d0 <kfree>
      *pte = 0;
80106959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010695c:	83 c4 10             	add    $0x10,%esp
8010695f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106965:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010696b:	39 f3                	cmp    %esi,%ebx
8010696d:	73 1f                	jae    8010698e <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010696f:	31 c9                	xor    %ecx,%ecx
80106971:	89 da                	mov    %ebx,%edx
80106973:	89 f8                	mov    %edi,%eax
80106975:	e8 86 fe ff ff       	call   80106800 <walkpgdir>
    if(!pte)
8010697a:	85 c0                	test   %eax,%eax
8010697c:	75 ba                	jne    80106938 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
8010697e:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106984:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010698a:	39 f3                	cmp    %esi,%ebx
8010698c:	72 e1                	jb     8010696f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010698e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106994:	5b                   	pop    %ebx
80106995:	5e                   	pop    %esi
80106996:	5f                   	pop    %edi
80106997:	5d                   	pop    %ebp
80106998:	c3                   	ret    
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106999:	83 ec 0c             	sub    $0xc,%esp
8010699c:	68 92 73 10 80       	push   $0x80107392
801069a1:	e8 ca 99 ff ff       	call   80100370 <panic>
801069a6:	8d 76 00             	lea    0x0(%esi),%esi
801069a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069b0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	53                   	push   %ebx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069b4:	31 db                	xor    %ebx,%ebx

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801069b6:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801069b9:	e8 22 bd ff ff       	call   801026e0 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069be:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801069c4:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
801069c9:	8d 90 a0 27 11 80    	lea    -0x7feed860(%eax),%edx
801069cf:	c6 80 1d 28 11 80 9a 	movb   $0x9a,-0x7feed7e3(%eax)
801069d6:	c6 80 1e 28 11 80 cf 	movb   $0xcf,-0x7feed7e2(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069dd:	c6 80 25 28 11 80 92 	movb   $0x92,-0x7feed7db(%eax)
801069e4:	c6 80 26 28 11 80 cf 	movb   $0xcf,-0x7feed7da(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069eb:	66 89 4a 78          	mov    %cx,0x78(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069ef:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069f4:	66 89 5a 7a          	mov    %bx,0x7a(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069f8:	66 89 8a 80 00 00 00 	mov    %cx,0x80(%edx)
801069ff:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a01:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a06:	66 89 9a 82 00 00 00 	mov    %bx,0x82(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a0d:	66 89 8a 90 00 00 00 	mov    %cx,0x90(%edx)
80106a14:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a16:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a1b:	66 89 9a 92 00 00 00 	mov    %bx,0x92(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a22:	31 db                	xor    %ebx,%ebx
80106a24:	66 89 8a 98 00 00 00 	mov    %cx,0x98(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a2b:	8d 88 54 28 11 80    	lea    -0x7feed7ac(%eax),%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a31:	66 89 9a 9a 00 00 00 	mov    %bx,0x9a(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a38:	31 db                	xor    %ebx,%ebx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a3a:	c6 80 35 28 11 80 fa 	movb   $0xfa,-0x7feed7cb(%eax)
80106a41:	c6 80 36 28 11 80 cf 	movb   $0xcf,-0x7feed7ca(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a48:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
80106a4f:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
80106a56:	89 cb                	mov    %ecx,%ebx
80106a58:	c1 e9 18             	shr    $0x18,%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a5b:	c6 80 3d 28 11 80 f2 	movb   $0xf2,-0x7feed7c3(%eax)
80106a62:	c6 80 3e 28 11 80 cf 	movb   $0xcf,-0x7feed7c2(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a69:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
80106a6f:	c6 80 2d 28 11 80 92 	movb   $0x92,-0x7feed7d3(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106a76:	b9 37 00 00 00       	mov    $0x37,%ecx
80106a7b:	c6 80 2e 28 11 80 c0 	movb   $0xc0,-0x7feed7d2(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80106a82:	05 10 28 11 80       	add    $0x80112810,%eax
80106a87:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a8b:	c1 eb 10             	shr    $0x10,%ebx
  pd[1] = (uint)p;
80106a8e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a92:	c1 e8 10             	shr    $0x10,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a95:	c6 42 7c 00          	movb   $0x0,0x7c(%edx)
80106a99:	c6 42 7f 00          	movb   $0x0,0x7f(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a9d:	c6 82 84 00 00 00 00 	movb   $0x0,0x84(%edx)
80106aa4:	c6 82 87 00 00 00 00 	movb   $0x0,0x87(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106aab:	c6 82 94 00 00 00 00 	movb   $0x0,0x94(%edx)
80106ab2:	c6 82 97 00 00 00 00 	movb   $0x0,0x97(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ab9:	c6 82 9c 00 00 00 00 	movb   $0x0,0x9c(%edx)
80106ac0:	c6 82 9f 00 00 00 00 	movb   $0x0,0x9f(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106ac7:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
80106acd:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106ad1:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ad4:	0f 01 10             	lgdtl  (%eax)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106ad7:	b8 18 00 00 00       	mov    $0x18,%eax
80106adc:	8e e8                	mov    %eax,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106ade:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106ae5:	00 00 00 00 

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106ae9:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}
80106af0:	83 c4 14             	add    $0x14,%esp
80106af3:	5b                   	pop    %ebx
80106af4:	5d                   	pop    %ebp
80106af5:	c3                   	ret    
80106af6:	8d 76 00             	lea    0x0(%esi),%esi
80106af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b00 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	56                   	push   %esi
80106b04:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106b05:	e8 76 b9 ff ff       	call   80102480 <kalloc>
80106b0a:	85 c0                	test   %eax,%eax
80106b0c:	74 52                	je     80106b60 <setupkvm+0x60>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106b0e:	83 ec 04             	sub    $0x4,%esp
80106b11:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b13:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106b18:	68 00 10 00 00       	push   $0x1000
80106b1d:	6a 00                	push   $0x0
80106b1f:	50                   	push   %eax
80106b20:	e8 db da ff ff       	call   80104600 <memset>
80106b25:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106b28:	8b 43 04             	mov    0x4(%ebx),%eax
80106b2b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106b2e:	83 ec 08             	sub    $0x8,%esp
80106b31:	8b 13                	mov    (%ebx),%edx
80106b33:	ff 73 0c             	pushl  0xc(%ebx)
80106b36:	50                   	push   %eax
80106b37:	29 c1                	sub    %eax,%ecx
80106b39:	89 f0                	mov    %esi,%eax
80106b3b:	e8 40 fd ff ff       	call   80106880 <mappages>
80106b40:	83 c4 10             	add    $0x10,%esp
80106b43:	85 c0                	test   %eax,%eax
80106b45:	78 19                	js     80106b60 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b47:	83 c3 10             	add    $0x10,%ebx
80106b4a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b50:	75 d6                	jne    80106b28 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106b52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b55:	89 f0                	mov    %esi,%eax
80106b57:	5b                   	pop    %ebx
80106b58:	5e                   	pop    %esi
80106b59:	5d                   	pop    %ebp
80106b5a:	c3                   	ret    
80106b5b:	90                   	nop
80106b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106b63:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5d                   	pop    %ebp
80106b68:	c3                   	ret    
80106b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b70 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106b76:	e8 85 ff ff ff       	call   80106b00 <setupkvm>
80106b7b:	a3 24 59 11 80       	mov    %eax,0x80115924
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b80:	05 00 00 00 80       	add    $0x80000000,%eax
80106b85:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106b88:	c9                   	leave  
80106b89:	c3                   	ret    
80106b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b90 <switchkvm>:
80106b90:	a1 24 59 11 80       	mov    0x80115924,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106b95:	55                   	push   %ebp
80106b96:	89 e5                	mov    %esp,%ebp
80106b98:	05 00 00 00 80       	add    $0x80000000,%eax
80106b9d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106ba0:	5d                   	pop    %ebp
80106ba1:	c3                   	ret    
80106ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bb0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	53                   	push   %ebx
80106bb4:	83 ec 04             	sub    $0x4,%esp
80106bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106bba:	e8 71 d9 ff ff       	call   80104530 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106bbf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106bc5:	b9 67 00 00 00       	mov    $0x67,%ecx
80106bca:	8d 50 08             	lea    0x8(%eax),%edx
80106bcd:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106bd4:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106bdb:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106be2:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106be9:	89 d1                	mov    %edx,%ecx
80106beb:	c1 ea 18             	shr    $0x18,%edx
80106bee:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106bf4:	ba 10 00 00 00       	mov    $0x10,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106bf9:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106bfc:	66 89 50 10          	mov    %dx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106c00:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106c07:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106c0d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106c12:	8b 52 08             	mov    0x8(%edx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106c15:	66 89 48 6e          	mov    %cx,0x6e(%eax)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106c19:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106c1f:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106c22:	b8 30 00 00 00       	mov    $0x30,%eax
80106c27:	0f 00 d8             	ltr    %ax
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
80106c2a:	8b 43 04             	mov    0x4(%ebx),%eax
80106c2d:	85 c0                	test   %eax,%eax
80106c2f:	74 11                	je     80106c42 <switchuvm+0x92>
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c31:	05 00 00 00 80       	add    $0x80000000,%eax
80106c36:	0f 22 d8             	mov    %eax,%cr3
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106c39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106c3c:	c9                   	leave  
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106c3d:	e9 1e d9 ff ff       	jmp    80104560 <popcli>
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106c42:	83 ec 0c             	sub    $0xc,%esp
80106c45:	68 d2 79 10 80       	push   $0x801079d2
80106c4a:	e8 21 97 ff ff       	call   80100370 <panic>
80106c4f:	90                   	nop

80106c50 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
80106c59:	8b 75 10             	mov    0x10(%ebp),%esi
80106c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106c62:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106c68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106c6b:	77 49                	ja     80106cb6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106c6d:	e8 0e b8 ff ff       	call   80102480 <kalloc>
  memset(mem, 0, PGSIZE);
80106c72:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106c75:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c77:	68 00 10 00 00       	push   $0x1000
80106c7c:	6a 00                	push   $0x0
80106c7e:	50                   	push   %eax
80106c7f:	e8 7c d9 ff ff       	call   80104600 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c84:	58                   	pop    %eax
80106c85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c8b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c90:	5a                   	pop    %edx
80106c91:	6a 06                	push   $0x6
80106c93:	50                   	push   %eax
80106c94:	31 d2                	xor    %edx,%edx
80106c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c99:	e8 e2 fb ff ff       	call   80106880 <mappages>
  memmove(mem, init, sz);
80106c9e:	89 75 10             	mov    %esi,0x10(%ebp)
80106ca1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106ca4:	83 c4 10             	add    $0x10,%esp
80106ca7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cad:	5b                   	pop    %ebx
80106cae:	5e                   	pop    %esi
80106caf:	5f                   	pop    %edi
80106cb0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106cb1:	e9 fa d9 ff ff       	jmp    801046b0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106cb6:	83 ec 0c             	sub    $0xc,%esp
80106cb9:	68 e6 79 10 80       	push   $0x801079e6
80106cbe:	e8 ad 96 ff ff       	call   80100370 <panic>
80106cc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106cd9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ce0:	0f 85 91 00 00 00    	jne    80106d77 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106ce6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ce9:	31 db                	xor    %ebx,%ebx
80106ceb:	85 f6                	test   %esi,%esi
80106ced:	75 1a                	jne    80106d09 <loaduvm+0x39>
80106cef:	eb 6f                	jmp    80106d60 <loaduvm+0x90>
80106cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cf8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cfe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106d04:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106d07:	76 57                	jbe    80106d60 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d09:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0f:	31 c9                	xor    %ecx,%ecx
80106d11:	01 da                	add    %ebx,%edx
80106d13:	e8 e8 fa ff ff       	call   80106800 <walkpgdir>
80106d18:	85 c0                	test   %eax,%eax
80106d1a:	74 4e                	je     80106d6a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d1c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106d21:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d2b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d31:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d34:	01 d9                	add    %ebx,%ecx
80106d36:	05 00 00 00 80       	add    $0x80000000,%eax
80106d3b:	57                   	push   %edi
80106d3c:	51                   	push   %ecx
80106d3d:	50                   	push   %eax
80106d3e:	ff 75 10             	pushl  0x10(%ebp)
80106d41:	e8 da ab ff ff       	call   80101920 <readi>
80106d46:	83 c4 10             	add    $0x10,%esp
80106d49:	39 c7                	cmp    %eax,%edi
80106d4b:	74 ab                	je     80106cf8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106d55:	5b                   	pop    %ebx
80106d56:	5e                   	pop    %esi
80106d57:	5f                   	pop    %edi
80106d58:	5d                   	pop    %ebp
80106d59:	c3                   	ret    
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106d63:	31 c0                	xor    %eax,%eax
}
80106d65:	5b                   	pop    %ebx
80106d66:	5e                   	pop    %esi
80106d67:	5f                   	pop    %edi
80106d68:	5d                   	pop    %ebp
80106d69:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106d6a:	83 ec 0c             	sub    $0xc,%esp
80106d6d:	68 00 7a 10 80       	push   $0x80107a00
80106d72:	e8 f9 95 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106d77:	83 ec 0c             	sub    $0xc,%esp
80106d7a:	68 a4 7a 10 80       	push   $0x80107aa4
80106d7f:	e8 ec 95 ff ff       	call   80100370 <panic>
80106d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d90 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 0c             	sub    $0xc,%esp
80106d99:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106d9c:	85 ff                	test   %edi,%edi
80106d9e:	0f 88 ca 00 00 00    	js     80106e6e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106da4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106daa:	0f 82 82 00 00 00    	jb     80106e32 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106db0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106db6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106dbc:	39 df                	cmp    %ebx,%edi
80106dbe:	77 43                	ja     80106e03 <allocuvm+0x73>
80106dc0:	e9 bb 00 00 00       	jmp    80106e80 <allocuvm+0xf0>
80106dc5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106dc8:	83 ec 04             	sub    $0x4,%esp
80106dcb:	68 00 10 00 00       	push   $0x1000
80106dd0:	6a 00                	push   $0x0
80106dd2:	50                   	push   %eax
80106dd3:	e8 28 d8 ff ff       	call   80104600 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106dd8:	58                   	pop    %eax
80106dd9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ddf:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106de4:	5a                   	pop    %edx
80106de5:	6a 06                	push   $0x6
80106de7:	50                   	push   %eax
80106de8:	89 da                	mov    %ebx,%edx
80106dea:	8b 45 08             	mov    0x8(%ebp),%eax
80106ded:	e8 8e fa ff ff       	call   80106880 <mappages>
80106df2:	83 c4 10             	add    $0x10,%esp
80106df5:	85 c0                	test   %eax,%eax
80106df7:	78 47                	js     80106e40 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106df9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dff:	39 df                	cmp    %ebx,%edi
80106e01:	76 7d                	jbe    80106e80 <allocuvm+0xf0>
    mem = kalloc();
80106e03:	e8 78 b6 ff ff       	call   80102480 <kalloc>
    if(mem == 0){
80106e08:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106e0a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106e0c:	75 ba                	jne    80106dc8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106e0e:	83 ec 0c             	sub    $0xc,%esp
80106e11:	68 1e 7a 10 80       	push   $0x80107a1e
80106e16:	e8 45 98 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e1b:	83 c4 10             	add    $0x10,%esp
80106e1e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e21:	76 4b                	jbe    80106e6e <allocuvm+0xde>
80106e23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e26:	8b 45 08             	mov    0x8(%ebp),%eax
80106e29:	89 fa                	mov    %edi,%edx
80106e2b:	e8 e0 fa ff ff       	call   80106910 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106e30:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e35:	5b                   	pop    %ebx
80106e36:	5e                   	pop    %esi
80106e37:	5f                   	pop    %edi
80106e38:	5d                   	pop    %ebp
80106e39:	c3                   	ret    
80106e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106e40:	83 ec 0c             	sub    $0xc,%esp
80106e43:	68 36 7a 10 80       	push   $0x80107a36
80106e48:	e8 13 98 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e4d:	83 c4 10             	add    $0x10,%esp
80106e50:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e53:	76 0d                	jbe    80106e62 <allocuvm+0xd2>
80106e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e58:	8b 45 08             	mov    0x8(%ebp),%eax
80106e5b:	89 fa                	mov    %edi,%edx
80106e5d:	e8 ae fa ff ff       	call   80106910 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106e62:	83 ec 0c             	sub    $0xc,%esp
80106e65:	56                   	push   %esi
80106e66:	e8 65 b4 ff ff       	call   801022d0 <kfree>
      return 0;
80106e6b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106e71:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106e73:	5b                   	pop    %ebx
80106e74:	5e                   	pop    %esi
80106e75:	5f                   	pop    %edi
80106e76:	5d                   	pop    %ebp
80106e77:	c3                   	ret    
80106e78:	90                   	nop
80106e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106e83:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e90 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e99:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e9c:	39 d1                	cmp    %edx,%ecx
80106e9e:	73 10                	jae    80106eb0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ea0:	5d                   	pop    %ebp
80106ea1:	e9 6a fa ff ff       	jmp    80106910 <deallocuvm.part.0>
80106ea6:	8d 76 00             	lea    0x0(%esi),%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106eb0:	89 d0                	mov    %edx,%eax
80106eb2:	5d                   	pop    %ebp
80106eb3:	c3                   	ret    
80106eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ec0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 0c             	sub    $0xc,%esp
80106ec9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ecc:	85 f6                	test   %esi,%esi
80106ece:	74 59                	je     80106f29 <freevm+0x69>
80106ed0:	31 c9                	xor    %ecx,%ecx
80106ed2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ed7:	89 f0                	mov    %esi,%eax
80106ed9:	e8 32 fa ff ff       	call   80106910 <deallocuvm.part.0>
80106ede:	89 f3                	mov    %esi,%ebx
80106ee0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ee6:	eb 0f                	jmp    80106ef7 <freevm+0x37>
80106ee8:	90                   	nop
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ef0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ef3:	39 fb                	cmp    %edi,%ebx
80106ef5:	74 23                	je     80106f1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ef7:	8b 03                	mov    (%ebx),%eax
80106ef9:	a8 01                	test   $0x1,%al
80106efb:	74 f3                	je     80106ef0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106efd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f02:	83 ec 0c             	sub    $0xc,%esp
80106f05:	83 c3 04             	add    $0x4,%ebx
80106f08:	05 00 00 00 80       	add    $0x80000000,%eax
80106f0d:	50                   	push   %eax
80106f0e:	e8 bd b3 ff ff       	call   801022d0 <kfree>
80106f13:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f16:	39 fb                	cmp    %edi,%ebx
80106f18:	75 dd                	jne    80106ef7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106f1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f20:	5b                   	pop    %ebx
80106f21:	5e                   	pop    %esi
80106f22:	5f                   	pop    %edi
80106f23:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106f24:	e9 a7 b3 ff ff       	jmp    801022d0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106f29:	83 ec 0c             	sub    $0xc,%esp
80106f2c:	68 52 7a 10 80       	push   $0x80107a52
80106f31:	e8 3a 94 ff ff       	call   80100370 <panic>
80106f36:	8d 76 00             	lea    0x0(%esi),%esi
80106f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f41:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f43:	89 e5                	mov    %esp,%ebp
80106f45:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f4e:	e8 ad f8 ff ff       	call   80106800 <walkpgdir>
  if(pte == 0)
80106f53:	85 c0                	test   %eax,%eax
80106f55:	74 05                	je     80106f5c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f5a:	c9                   	leave  
80106f5b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f5c:	83 ec 0c             	sub    $0xc,%esp
80106f5f:	68 63 7a 10 80       	push   $0x80107a63
80106f64:	e8 07 94 ff ff       	call   80100370 <panic>
80106f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f79:	e8 82 fb ff ff       	call   80106b00 <setupkvm>
80106f7e:	85 c0                	test   %eax,%eax
80106f80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f83:	0f 84 b2 00 00 00    	je     8010703b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f8c:	85 c9                	test   %ecx,%ecx
80106f8e:	0f 84 9c 00 00 00    	je     80107030 <copyuvm+0xc0>
80106f94:	31 f6                	xor    %esi,%esi
80106f96:	eb 4a                	jmp    80106fe2 <copyuvm+0x72>
80106f98:	90                   	nop
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
80106fa3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106fa9:	68 00 10 00 00       	push   $0x1000
80106fae:	57                   	push   %edi
80106faf:	50                   	push   %eax
80106fb0:	e8 fb d6 ff ff       	call   801046b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106fb5:	58                   	pop    %eax
80106fb6:	5a                   	pop    %edx
80106fb7:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106fbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fc0:	ff 75 e4             	pushl  -0x1c(%ebp)
80106fc3:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fc8:	52                   	push   %edx
80106fc9:	89 f2                	mov    %esi,%edx
80106fcb:	e8 b0 f8 ff ff       	call   80106880 <mappages>
80106fd0:	83 c4 10             	add    $0x10,%esp
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	78 3e                	js     80107015 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fd7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106fdd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106fe0:	76 4e                	jbe    80107030 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe5:	31 c9                	xor    %ecx,%ecx
80106fe7:	89 f2                	mov    %esi,%edx
80106fe9:	e8 12 f8 ff ff       	call   80106800 <walkpgdir>
80106fee:	85 c0                	test   %eax,%eax
80106ff0:	74 5a                	je     8010704c <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106ff2:	8b 18                	mov    (%eax),%ebx
80106ff4:	f6 c3 01             	test   $0x1,%bl
80106ff7:	74 46                	je     8010703f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106ff9:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106ffb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107001:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107004:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010700a:	e8 71 b4 ff ff       	call   80102480 <kalloc>
8010700f:	85 c0                	test   %eax,%eax
80107011:	89 c3                	mov    %eax,%ebx
80107013:	75 8b                	jne    80106fa0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107015:	83 ec 0c             	sub    $0xc,%esp
80107018:	ff 75 e0             	pushl  -0x20(%ebp)
8010701b:	e8 a0 fe ff ff       	call   80106ec0 <freevm>
  return 0;
80107020:	83 c4 10             	add    $0x10,%esp
80107023:	31 c0                	xor    %eax,%eax
}
80107025:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107028:	5b                   	pop    %ebx
80107029:	5e                   	pop    %esi
8010702a:	5f                   	pop    %edi
8010702b:	5d                   	pop    %ebp
8010702c:	c3                   	ret    
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107030:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107033:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107036:	5b                   	pop    %ebx
80107037:	5e                   	pop    %esi
80107038:	5f                   	pop    %edi
80107039:	5d                   	pop    %ebp
8010703a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010703b:	31 c0                	xor    %eax,%eax
8010703d:	eb e6                	jmp    80107025 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010703f:	83 ec 0c             	sub    $0xc,%esp
80107042:	68 87 7a 10 80       	push   $0x80107a87
80107047:	e8 24 93 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010704c:	83 ec 0c             	sub    $0xc,%esp
8010704f:	68 6d 7a 10 80       	push   $0x80107a6d
80107054:	e8 17 93 ff ff       	call   80100370 <panic>
80107059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107060 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107060:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107061:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107063:	89 e5                	mov    %esp,%ebp
80107065:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107068:	8b 55 0c             	mov    0xc(%ebp),%edx
8010706b:	8b 45 08             	mov    0x8(%ebp),%eax
8010706e:	e8 8d f7 ff ff       	call   80106800 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107073:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107075:	89 c2                	mov    %eax,%edx
80107077:	83 e2 05             	and    $0x5,%edx
8010707a:	83 fa 05             	cmp    $0x5,%edx
8010707d:	75 11                	jne    80107090 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010707f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107084:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107085:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010708a:	c3                   	ret    
8010708b:	90                   	nop
8010708c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107090:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107092:	c9                   	leave  
80107093:	c3                   	ret    
80107094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010709a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
801070a6:	83 ec 1c             	sub    $0x1c,%esp
801070a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801070ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801070af:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070b2:	85 db                	test   %ebx,%ebx
801070b4:	75 40                	jne    801070f6 <copyout+0x56>
801070b6:	eb 70                	jmp    80107128 <copyout+0x88>
801070b8:	90                   	nop
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070c3:	89 f1                	mov    %esi,%ecx
801070c5:	29 d1                	sub    %edx,%ecx
801070c7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801070cd:	39 d9                	cmp    %ebx,%ecx
801070cf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070d2:	29 f2                	sub    %esi,%edx
801070d4:	83 ec 04             	sub    $0x4,%esp
801070d7:	01 d0                	add    %edx,%eax
801070d9:	51                   	push   %ecx
801070da:	57                   	push   %edi
801070db:	50                   	push   %eax
801070dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801070df:	e8 cc d5 ff ff       	call   801046b0 <memmove>
    len -= n;
    buf += n;
801070e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070e7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801070ea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801070f0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070f2:	29 cb                	sub    %ecx,%ebx
801070f4:	74 32                	je     80107128 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801070f6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801070f8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801070fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801070fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107104:	56                   	push   %esi
80107105:	ff 75 08             	pushl  0x8(%ebp)
80107108:	e8 53 ff ff ff       	call   80107060 <uva2ka>
    if(pa0 == 0)
8010710d:	83 c4 10             	add    $0x10,%esp
80107110:	85 c0                	test   %eax,%eax
80107112:	75 ac                	jne    801070c0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107114:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107117:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010711c:	5b                   	pop    %ebx
8010711d:	5e                   	pop    %esi
8010711e:	5f                   	pop    %edi
8010711f:	5d                   	pop    %ebp
80107120:	c3                   	ret    
80107121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107128:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010712b:	31 c0                	xor    %eax,%eax
}
8010712d:	5b                   	pop    %ebx
8010712e:	5e                   	pop    %esi
8010712f:	5f                   	pop    %edi
80107130:	5d                   	pop    %ebp
80107131:	c3                   	ret    
