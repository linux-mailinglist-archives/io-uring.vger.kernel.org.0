Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE31403DF2
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350090AbhIHQxd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 12:53:33 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53344 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350124AbhIHQxd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 12:53:33 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631119942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5EPtDVyVzLxT15E52HQdw1eywPvZepjY6+SF1Ogzgk=;
        b=WcxcTwoxmq9agcrizLqac1Q7keJK6SWp57fGmeZoww4UbvCpmrxsWYuFabmTnQTvbGXObg
        t4FqAm0Nc+cpw+LR+DzWY3eyVXkhE2Tk7ixphk5KlqUkDAu1AQqoalewrI3HgWLE+0XIbf
        jei+lZftAL4SpdTpS8MewmZRmCvir6uvUvGIe6t6dUT64Y5+97UcTzkEKiT0LjzCNhoEhv
        c8H018SrOc2VEs1dTTIblipMsoaSxN8yJNJw/1XC15TEZva3Q8fJBlcyDDCC98nY3Ulc9s
        ZH2oEnI0gdHbuL4SahZmsJvWuws3eQ17bs0hHj0DA657Vc7Nlpci/FXdaSCcyQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631119942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5EPtDVyVzLxT15E52HQdw1eywPvZepjY6+SF1Ogzgk=;
        b=2B6VKByQz39IlDUUv9z+gQtL86BeNWs2/Kih5bpCIwBAbv+6FHdwkG98ljTzogQdWrBG8Q
        DcC6W3q36IZ2biDQ==
To:     syzbot <syzbot+89ee54915f0135ac38e0@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in
 timerqueue_del
In-Reply-To: <0000000000009b05a305cb511b76@google.com>
References: <0000000000009b05a305cb511b76@google.com>
Date:   Wed, 08 Sep 2021 18:52:22 +0200
Message-ID: <8735qff1rt.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 06 2021 at 03:28, syzbot wrote:
> HEAD commit:    b91db6a0b52e Merge tag 'for-5.15/io_uring-vfs-2021-08-30' ..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12a993fe300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=210537ff2ddcc232
> dashboard link: https://syzkaller.appspot.com/bug?extid=89ee54915f0135ac38e0
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> userspace arch: i386
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+89ee54915f0135ac38e0@syzkaller.appspotmail.com
>
> BUG: unable to handle page fault for address: ffffc9001bdbfd88
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 10800067 P4D 10800067 PUD 109ba067 PMD 136067 PTE 0
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 19707 Comm: syz-executor.1 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>
> RIP: 0010:__rb_change_child include/linux/rbtree_augmented.h:173 [inline]
> RIP: 0010:__rb_erase_augmented include/linux/rbtree_augmented.h:216 [inline]
> RIP: 0010:rb_erase+0x5f6/0x1210 lib/rbtree.c:443

So the RB tree is corrupted. In the previous report io_uring clearly was
using an uninitialized timer and in the console output of this one are
clearly io uring commands. Obviously I can't tell for sure, but there is
a pattern here.

> Code: e3 fc 0f 84 0c 01 00 00 48 8d 7b 10 48 89 dd 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 84 0a 00 00 <4c> 3b 6b 10 0f 84 37 02 00 00 48 8d 7b 08 48 b8 00 00 00 00 00 fc
> RSP: 0018:ffffc90000007d88 EFLAGS: 00010046
> RAX: dffffc0000000000 RBX: ffffc9001bdbfd78 RCX: 0000000000000000
> RDX: 1ffff920037b7fb1 RSI: ffff8880b9c424d0 RDI: ffffc9001bdbfd88
> RBP: ffffc9001bdbfd78 R08: ffffc9001bdbfd79 R09: 0000000000000001
> R10: ffffffff83f38fdc R11: 0000000000000000 R12: ffffc9001bdbfd79
> R13: ffffc9000256fd78 R14: ffffc9001aa2fd78 R15: ffff8880b9c424d0
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0063) knlGS:00000000f55b7b40
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: ffffc9001bdbfd88 CR3: 000000008b5d9000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  rb_erase_cached include/linux/rbtree.h:126 [inline]
>  timerqueue_del+0x7f/0x140 lib/timerqueue.c:57
>  __remove_hrtimer+0xa1/0x2a0 kernel/time/hrtimer.c:1116
>  __run_hrtimer kernel/time/hrtimer.c:1665 [inline]
>  __hrtimer_run_queues+0x4ea/0xe50 kernel/time/hrtimer.c:1749
>  hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
>  __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
>  sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
> RIP: 0010:__sanitizer_cov_trace_const_cmp4+0xc/0x70 kernel/kcov.c:283
> Code: 00 00 00 48 89 7c 30 e8 48 89 4c 30 f0 4c 89 54 d8 20 48 89 10 5b c3 0f 1f 80 00 00 00 00 41 89 f8 bf 03 00 00 00 4c 8b 14 24 <89> f1 65 48 8b 34 25 40 f0 01 00 e8 54 f0 ff ff 84 c0 74 4b 48 8b
> RSP: 0018:ffffc90019797440 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: ffff8880001373e4 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000004 RDI: 0000000000000003
> RBP: ffff8881407c547c R08: 0000000000000000 R09: ffffffff840a6804
> R10: ffffffff840a69c5 R11: 0000000000000008 R12: 0000000000000004
> R13: 0000000000000047 R14: ffff8880001373e0 R15: dffffc0000000000
>  fast_imageblit drivers/video/fbdev/core/cfbimgblt.c:258 [inline]
>  cfb_imageblit+0x655/0x1240 drivers/video/fbdev/core/cfbimgblt.c:300
>  vga_imageblit_expand drivers/video/fbdev/vga16fb.c:1207 [inline]
>  vga16fb_imageblit+0x681/0x2200 drivers/video/fbdev/vga16fb.c:1260
>  bit_putcs_unaligned drivers/video/fbdev/core/bitblit.c:139 [inline]
>  bit_putcs+0x6e1/0xd20 drivers/video/fbdev/core/bitblit.c:188
>  fbcon_putcs+0x35a/0x450 drivers/video/fbdev/core/fbcon.c:1296
>  do_update_region+0x399/0x630 drivers/tty/vt/vt.c:676
>  redraw_screen+0x61f/0x740 drivers/tty/vt/vt.c:1035
>  vc_do_resize+0xe6f/0x1100 drivers/tty/vt/vt.c:1325
>  fbcon_modechanged+0x393/0x6d0 drivers/video/fbdev/core/fbcon.c:2640
>  fbcon_update_vcs+0x3a/0x50 drivers/video/fbdev/core/fbcon.c:2696
>  do_fb_ioctl+0x62e/0x690 drivers/video/fbdev/core/fbmem.c:1108
>  fb_compat_ioctl+0x17e/0x610 drivers/video/fbdev/core/fbmem.c:1307
>  __do_compat_sys_ioctl+0x1c7/0x290 fs/ioctl.c:964
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
> RIP: 0023:0xf7fbd549
> Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
> RSP: 002b:00000000f55b75fc EFLAGS: 00000296 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000004601
> RDX: 0000000020000280 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> CR2: ffffc9001bdbfd88
> ---[ end trace 573584e01bd36498 ]---
> RIP: 0010:__rb_change_child include/linux/rbtree_augmented.h:173 [inline]
> RIP: 0010:__rb_erase_augmented include/linux/rbtree_augmented.h:216 [inline]
> RIP: 0010:rb_erase+0x5f6/0x1210 lib/rbtree.c:443
> Code: e3 fc 0f 84 0c 01 00 00 48 8d 7b 10 48 89 dd 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 84 0a 00 00 <4c> 3b 6b 10 0f 84 37 02 00 00 48 8d 7b 08 48 b8 00 00 00 00 00 fc
> RSP: 0018:ffffc90000007d88 EFLAGS: 00010046
> RAX: dffffc0000000000 RBX: ffffc9001bdbfd78 RCX: 0000000000000000
> RDX: 1ffff920037b7fb1 RSI: ffff8880b9c424d0 RDI: ffffc9001bdbfd88
> RBP: ffffc9001bdbfd78 R08: ffffc9001bdbfd79 R09: 0000000000000001
> R10: ffffffff83f38fdc R11: 0000000000000000 R12: ffffc9001bdbfd79
> R13: ffffc9000256fd78 R14: ffffc9001aa2fd78 R15: ffff8880b9c424d0
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0063) knlGS:00000000f55b7b40
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: ffffc9001bdbfd88 CR3: 000000008b5d9000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	e3 fc                	jrcxz  0xfffffffe
>    2:	0f 84 0c 01 00 00    	je     0x114
>    8:	48 8d 7b 10          	lea    0x10(%rbx),%rdi
>    c:	48 89 dd             	mov    %rbx,%rbp
>    f:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>   16:	fc ff df
>   19:	48 89 fa             	mov    %rdi,%rdx
>   1c:	48 c1 ea 03          	shr    $0x3,%rdx
>   20:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
>   24:	0f 85 84 0a 00 00    	jne    0xaae
> * 2a:	4c 3b 6b 10          	cmp    0x10(%rbx),%r13 <-- trapping instruction
>   2e:	0f 84 37 02 00 00    	je     0x26b
>   34:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
>   38:	48                   	rex.W
>   39:	b8 00 00 00 00       	mov    $0x0,%eax
>   3e:	00 fc                	add    %bh,%ah
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
