Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E605EF6F9
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 15:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiI2N4g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 09:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiI2N4f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 09:56:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC381280E1;
        Thu, 29 Sep 2022 06:56:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BFD581F8C3;
        Thu, 29 Sep 2022 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1664459787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7DelKGwFkSQ4s3mzBqlVHAud5sa8fOOKwLjcv4+YNyg=;
        b=eihp2gpAcIq9eWumUACtKCByKm8AbntBTxnWcUX+Qrhs6f216utk5wD3yW0Wk0WfopzGhz
        sPR8XS+SSIL0k1OWOw4KB7SWZJyyOTg8q8FBiPqQK2JTCh/w9cXFXzUsN+frvXNXqVViNS
        xrjuQBwWFcSQOE0SJ/ynAFHVwXYUzOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1664459787;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7DelKGwFkSQ4s3mzBqlVHAud5sa8fOOKwLjcv4+YNyg=;
        b=fIkYtO3qOdDorg2U3Q+rbTf9KVDcnGXLEcyJP5xOmk0BiA7rnPqzeTG8xVYFfmRl5uCf8E
        vCZpCHNuuAGfelAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A5D711348E;
        Thu, 29 Sep 2022 13:56:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8IV3KAukNWO4MwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 29 Sep 2022 13:56:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 3D5D8A0681; Thu, 29 Sep 2022 15:56:27 +0200 (CEST)
Date:   Thu, 29 Sep 2022 15:56:27 +0200
From:   Jan Kara <jack@suse.cz>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     syzbot <syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mhiramat@kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        Matthew Bobrowski <repnop@google.com>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [syzbot] inconsistent lock state in kmem_cache_alloc
Message-ID: <20220929135627.ykivmdks2w5vzrwg@quack3>
References: <00000000000074b50005e997178a@google.com>
 <edef9f69-4b29-4c00-8c1a-67c4b8f36af0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edef9f69-4b29-4c00-8c1a-67c4b8f36af0@suse.cz>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu 29-09-22 15:24:22, Vlastimil Babka wrote:
> On 9/26/22 18:33, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    105a36f3694e Merge tag 'kbuild-fixes-v6.0-3' of git://git...
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=152bf540880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7db7ad17eb14cb7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=dfcc5f4da15868df7d4d
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1020566c880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104819e4880000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com
> 
> +CC more folks
> 
> I'm not fully sure what this report means but I assume it's because there's
> a GFP_KERNEL kmalloc() allocation from softirq context? Should it perhaps
> use memalloc_nofs_save() at some well defined point?

Thanks for the CC. The problem really is that io_uring is calling into
fsnotify_access() from softirq context. That isn't going to work. The
allocation is just a tip of the iceberg. Fsnotify simply does not expect to
be called from softirq context. All the dcache locks are not IRQ safe, it
can even obtain some sleeping locks and call to userspace if there are
suitable watches set up.

So either io_uring needs to postpone fsnotify calls to a workqueue or we
need a way for io_uring code to tell iomap dio code that the completion
needs to always happen from a workqueue (as it currently does for writes).
Jens?

								Honza

> > ================================
> > WARNING: inconsistent lock state
> > 6.0.0-rc6-syzkaller-00321-g105a36f3694e #0 Not tainted
> > --------------------------------
> > inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> > swapper/1/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> > ffffffff8c0be7e0 (fs_reclaim){+.?.}-{0:0}, at: might_alloc include/linux/sched/mm.h:271 [inline]
> > ffffffff8c0be7e0 (fs_reclaim){+.?.}-{0:0}, at: slab_pre_alloc_hook mm/slab.h:700 [inline]
> > ffffffff8c0be7e0 (fs_reclaim){+.?.}-{0:0}, at: slab_alloc mm/slab.c:3278 [inline]
> > ffffffff8c0be7e0 (fs_reclaim){+.?.}-{0:0}, at: __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
> > ffffffff8c0be7e0 (fs_reclaim){+.?.}-{0:0}, at: kmem_cache_alloc+0x39/0x520 mm/slab.c:3491
> > {SOFTIRQ-ON-W} state was registered at:
> >   lock_acquire kernel/locking/lockdep.c:5666 [inline]
> >   lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
> >   __fs_reclaim_acquire mm/page_alloc.c:4674 [inline]
> >   fs_reclaim_acquire+0x115/0x160 mm/page_alloc.c:4688
> >   might_alloc include/linux/sched/mm.h:271 [inline]
> >   slab_pre_alloc_hook mm/slab.h:700 [inline]
> >   slab_alloc mm/slab.c:3278 [inline]
> >   kmem_cache_alloc_trace+0x38/0x460 mm/slab.c:3557
> >   kmalloc include/linux/slab.h:600 [inline]
> >   kzalloc include/linux/slab.h:733 [inline]
> >   alloc_workqueue_attrs+0x39/0xc0 kernel/workqueue.c:3394
> >   wq_numa_init kernel/workqueue.c:5964 [inline]
> >   workqueue_init+0x12f/0x8ae kernel/workqueue.c:6091
> >   kernel_init_freeable+0x3fb/0x73a init/main.c:1607
> >   kernel_init+0x1a/0x1d0 init/main.c:1512
> >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> > irq event stamp: 96654
> > hardirqs last  enabled at (96654): [<ffffffff81c6581b>] kfree+0x25b/0x390 mm/slab.c:3787
> > hardirqs last disabled at (96653): [<ffffffff81c65811>] kfree+0x251/0x390 mm/slab.c:3776
> > softirqs last  enabled at (96624): [<ffffffff814841f3>] invoke_softirq kernel/softirq.c:445 [inline]
> > softirqs last  enabled at (96624): [<ffffffff814841f3>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> > softirqs last disabled at (96649): [<ffffffff814841f3>] invoke_softirq kernel/softirq.c:445 [inline]
> > softirqs last disabled at (96649): [<ffffffff814841f3>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> > 
> > other info that might help us debug this:
> >  Possible unsafe locking scenario:
> > 
> >        CPU0
> >        ----
> >   lock(fs_reclaim);
> >   <Interrupt>
> >     lock(fs_reclaim);
> > 
> >  *** DEADLOCK ***
> > 
> > 1 lock held by swapper/1/0:
> >  #0: ffffffff91227508 (&fsnotify_mark_srcu){....}-{0:0}, at: fsnotify+0x2f4/0x1680 fs/notify/fsnotify.c:544
> > 
> > stack backtrace:
> > CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  print_usage_bug kernel/locking/lockdep.c:3961 [inline]
> >  valid_state kernel/locking/lockdep.c:3973 [inline]
> >  mark_lock_irq kernel/locking/lockdep.c:4176 [inline]
> >  mark_lock.part.0.cold+0x18/0xd8 kernel/locking/lockdep.c:4632
> >  mark_lock kernel/locking/lockdep.c:4596 [inline]
> >  mark_usage kernel/locking/lockdep.c:4527 [inline]
> >  __lock_acquire+0x11d9/0x56d0 kernel/locking/lockdep.c:5007
> >  lock_acquire kernel/locking/lockdep.c:5666 [inline]
> >  lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
> >  __fs_reclaim_acquire mm/page_alloc.c:4674 [inline]
> >  fs_reclaim_acquire+0x115/0x160 mm/page_alloc.c:4688
> >  might_alloc include/linux/sched/mm.h:271 [inline]
> >  slab_pre_alloc_hook mm/slab.h:700 [inline]
> >  slab_alloc mm/slab.c:3278 [inline]
> >  __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
> >  kmem_cache_alloc+0x39/0x520 mm/slab.c:3491
> >  fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
> >  fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
> >  fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
> >  send_to_group fs/notify/fsnotify.c:360 [inline]
> >  fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
> >  __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
> >  fsnotify_parent include/linux/fsnotify.h:77 [inline]
> >  fsnotify_file include/linux/fsnotify.h:99 [inline]
> >  fsnotify_access include/linux/fsnotify.h:309 [inline]
> >  __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
> >  io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
> >  iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
> >  iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
> >  bio_endio+0x5f9/0x780 block/bio.c:1564
> >  req_bio_endio block/blk-mq.c:695 [inline]
> >  blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
> >  scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
> >  scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
> >  scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
> >  blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
> >  __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
> >  invoke_softirq kernel/softirq.c:445 [inline]
> >  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> >  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> >  common_interrupt+0xa9/0xc0 arch/x86/kernel/irq.c:240
> >  </IRQ>
> >  <TASK>
> >  asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
> > RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
> > RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
> > RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
> > RIP: 0010:acpi_safe_halt+0x6f/0xb0 drivers/acpi/processor_idle.c:113
> > Code: f7 84 db 74 06 5b e9 a0 26 f8 f7 e8 9b 26 f8 f7 e8 f6 9d fe f7 66 90 e8 8f 26 f8 f7 0f 00 2d c8 a5 d1 00 e8 83 26 f8 f7 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 4e 23 f8 f7 48 85 db
> > RSP: 0018:ffffc9000038fd20 EFLAGS: 00000293
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: ffff8880121f0200 RSI: ffffffff8983119d RDI: 0000000000000000
> > RBP: ffff8880178c9064 R08: 0000000000000001 R09: 0000000000000001
> > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
> > R13: 0000000000000001 R14: ffff8880178c9000 R15: ffff888146aa7804
> >  acpi_idle_do_entry drivers/acpi/processor_idle.c:555 [inline]
> >  acpi_idle_enter+0x524/0x6a0 drivers/acpi/processor_idle.c:692
> >  cpuidle_enter_state+0x1ab/0xd30 drivers/cpuidle/cpuidle.c:239
> >  cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:356
> >  call_cpuidle kernel/sched/idle.c:155 [inline]
> >  cpuidle_idle_call kernel/sched/idle.c:236 [inline]
> >  do_idle+0x3e8/0x590 kernel/sched/idle.c:303
> >  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
> >  start_secondary+0x21d/0x2b0 arch/x86/kernel/smpboot.c:262
> >  secondary_startup_64_no_verify+0xce/0xdb
> >  </TASK>
> > BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
> > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/1
> > preempt_count: 101, expected: 0
> > RCU nest depth: 0, expected: 0
> > INFO: lockdep is turned off.
> > Preemption disabled at:
> > [<0000000000000000>] 0x0
> > CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9892
> >  might_alloc include/linux/sched/mm.h:274 [inline]
> >  slab_pre_alloc_hook mm/slab.h:700 [inline]
> >  slab_alloc mm/slab.c:3278 [inline]
> >  __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
> >  kmem_cache_alloc+0x381/0x520 mm/slab.c:3491
> >  fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
> >  fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
> >  fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
> >  send_to_group fs/notify/fsnotify.c:360 [inline]
> >  fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
> >  __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
> >  fsnotify_parent include/linux/fsnotify.h:77 [inline]
> >  fsnotify_file include/linux/fsnotify.h:99 [inline]
> >  fsnotify_access include/linux/fsnotify.h:309 [inline]
> >  __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
> >  io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
> >  iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
> >  iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
> >  bio_endio+0x5f9/0x780 block/bio.c:1564
> >  req_bio_endio block/blk-mq.c:695 [inline]
> >  blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
> >  scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
> >  scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
> >  scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
> >  blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
> >  __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
> >  invoke_softirq kernel/softirq.c:445 [inline]
> >  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> >  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> >  common_interrupt+0xa9/0xc0 arch/x86/kernel/irq.c:240
> >  </IRQ>
> >  <TASK>
> >  asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
> > RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
> > RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
> > RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
> > RIP: 0010:acpi_safe_halt+0x6f/0xb0 drivers/acpi/processor_idle.c:113
> > Code: f7 84 db 74 06 5b e9 a0 26 f8 f7 e8 9b 26 f8 f7 e8 f6 9d fe f7 66 90 e8 8f 26 f8 f7 0f 00 2d c8 a5 d1 00 e8 83 26 f8 f7 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 4e 23 f8 f7 48 85 db
> > RSP: 0018:ffffc9000038fd20 EFLAGS: 00000293
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: ffff8880121f0200 RSI: ffffffff8983119d RDI: 0000000000000000
> > RBP: ffff8880178c9064 R08: 0000000000000001 R09: 0000000000000001
> > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
> > R13: 0000000000000001 R14: ffff8880178c9000 R15: ffff888146aa7804
> >  acpi_idle_do_entry drivers/acpi/processor_idle.c:555 [inline]
> >  acpi_idle_enter+0x524/0x6a0 drivers/acpi/processor_idle.c:692
> >  cpuidle_enter_state+0x1ab/0xd30 drivers/cpuidle/cpuidle.c:239
> >  cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:356
> >  call_cpuidle kernel/sched/idle.c:155 [inline]
> >  cpuidle_idle_call kernel/sched/idle.c:236 [inline]
> >  do_idle+0x3e8/0x590 kernel/sched/idle.c:303
> >  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
> >  start_secondary+0x21d/0x2b0 arch/x86/kernel/smpboot.c:262
> >  secondary_startup_64_no_verify+0xce/0xdb
> >  </TASK>
> > BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
> > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3675, name: syz-executor284
> > preempt_count: 100, expected: 0
> > RCU nest depth: 0, expected: 0
> > INFO: lockdep is turned off.
> > Preemption disabled at:
> > [<ffffffff89c000e1>] softirq_handle_begin kernel/softirq.c:409 [inline]
> > [<ffffffff89c000e1>] __do_softirq+0xe1/0x9c6 kernel/softirq.c:547
> > CPU: 1 PID: 3675 Comm: syz-executor284 Tainted: G        W          6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9892
> >  might_alloc include/linux/sched/mm.h:274 [inline]
> >  slab_pre_alloc_hook mm/slab.h:700 [inline]
> >  slab_alloc mm/slab.c:3278 [inline]
> >  __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
> >  kmem_cache_alloc+0x381/0x520 mm/slab.c:3491
> >  fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
> >  fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
> >  fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
> >  send_to_group fs/notify/fsnotify.c:360 [inline]
> >  fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
> >  __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
> >  fsnotify_parent include/linux/fsnotify.h:77 [inline]
> >  fsnotify_file include/linux/fsnotify.h:99 [inline]
> >  fsnotify_access include/linux/fsnotify.h:309 [inline]
> >  __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
> >  io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
> >  iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
> >  iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
> >  bio_endio+0x5f9/0x780 block/bio.c:1564
> >  req_bio_endio block/blk-mq.c:695 [inline]
> >  blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
> >  scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
> >  scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
> >  scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
> >  blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
> >  __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
> >  invoke_softirq kernel/softirq.c:445 [inline]
> >  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> >  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> >  common_interrupt+0xa9/0xc0 arch/x86/kernel/irq.c:240
> >  </IRQ>
> >  <TASK>
> >  asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
> > RIP: 0010:kmem_cache_free.part.0+0x141/0x2e0 mm/slab.c:3727
> > Code: 4c 89 ea 4c 89 e7 e8 ee c0 ff ff 48 85 db 0f 85 a3 00 00 00 9c 58 f6 c4 02 0f 85 7e 01 00 00 48 85 db 74 01 fb 48 8b 44 24 08 <65> 48 2b 04 25 28 00 00 00 0f 85 7c 01 00 00 48 83 c4 10 5b 5d 41
> > RSP: 0018:ffffc90002f578a0 EFLAGS: 00000206
> > RAX: 90e611cb37c35f00 RBX: 0000000000000200 RCX: 1ffffffff1bbcead
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81c691b3
> > RBP: ffffea0001f3fe40 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000080000000 R11: 000000000008c07c R12: ffff888011853000
> > R13: ffffffff8136bf10 R14: ffff88807cf5e8a8 R15: 00007f457e2d9000
> >  pmd_ptlock_free include/linux/mm.h:2355 [inline]
> >  pgtable_pmd_page_dtor include/linux/mm.h:2392 [inline]
> >  ___pmd_free_tlb+0x70/0x220 arch/x86/mm/pgtable.c:72
> >  __pmd_free_tlb arch/x86/include/asm/pgalloc.h:93 [inline]
> >  free_pmd_range mm/memory.c:269 [inline]
> >  free_pud_range mm/memory.c:287 [inline]
> >  free_p4d_range mm/memory.c:321 [inline]
> >  free_pgd_range+0x9a1/0xbe0 mm/memory.c:401
> >  free_pgtables+0x230/0x2f0 mm/memory.c:433
> >  exit_mmap+0x1c7/0x490 mm/mmap.c:3117
> >  __mmput+0x122/0x4b0 kernel/fork.c:1187
> >  mmput+0x56/0x60 kernel/fork.c:1208
> >  exit_mm kernel/exit.c:510 [inline]
> >  do_exit+0x9e2/0x29b0 kernel/exit.c:782
> >  do_group_exit+0xd2/0x2f0 kernel/exit.c:925
> >  get_signal+0x238c/0x2610 kernel/signal.c:2857
> >  arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
> >  exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
> >  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
> >  __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
> >  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
> >  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f457e24abe9
> > Code: Unable to access opcode bytes at RIP 0x7f457e24abbf.
> > RSP: 002b:00007f457e1fc308 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> > RAX: fffffffffffffe00 RBX: 00007f457e2d2428 RCX: 00007f457e24abe9
> > RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f457e2d2428
> > RBP: 00007f457e2d2420 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007f457e2a0064
> > R13: 0000000000000004 R14: 00007f457e1fc400 R15: 0000000000022000
> >  </TASK>
> > BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
> > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3603, name: strace-static-x
> > preempt_count: 100, expected: 0
> > RCU nest depth: 0, expected: 0
> > INFO: lockdep is turned off.
> > Preemption disabled at:
> > [<ffffffff89c000e1>] softirq_handle_begin kernel/softirq.c:409 [inline]
> > [<ffffffff89c000e1>] __do_softirq+0xe1/0x9c6 kernel/softirq.c:547
> > CPU: 1 PID: 3603 Comm: strace-static-x Tainted: G        W          6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9892
> >  might_alloc include/linux/sched/mm.h:274 [inline]
> >  slab_pre_alloc_hook mm/slab.h:700 [inline]
> >  slab_alloc mm/slab.c:3278 [inline]
> >  __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
> >  kmem_cache_alloc+0x381/0x520 mm/slab.c:3491
> >  fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
> >  fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
> >  fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
> >  send_to_group fs/notify/fsnotify.c:360 [inline]
> >  fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
> >  __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
> >  fsnotify_parent include/linux/fsnotify.h:77 [inline]
> >  fsnotify_file include/linux/fsnotify.h:99 [inline]
> >  fsnotify_access include/linux/fsnotify.h:309 [inline]
> >  __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
> >  io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
> >  iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
> >  iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
> >  bio_endio+0x5f9/0x780 block/bio.c:1564
> >  req_bio_endio block/blk-mq.c:695 [inline]
> >  blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
> >  scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
> >  scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
> >  scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
> >  blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
> >  __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
> >  invoke_softirq kernel/softirq.c:445 [inline]
> >  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> >  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> >  common_interrupt+0x52/0xc0 arch/x86/kernel/irq.c:240
> >  asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
> > RIP: 0033:0x485e00
> > Code: 0f 86 de 17 00 00 48 89 8d 08 fb ff ff 48 89 ca 4c 89 d6 4c 89 e7 44 89 8d 00 fb ff ff ff 53 38 48 8b 8d 08 fb ff ff 48 39 c1 <0f> 85 92 f5 ff ff 44 8b 8d 00 fb ff ff b8 ff ff ff 7f 44 29 c8 48
> > RSP: 002b:00007fff73e2c5f0 EFLAGS: 00000246
> > RAX: 0000000000000001 RBX: 0000000000619460 RCX: 0000000000000001
> > RDX: 0000000000000001 RSI: 00007fff73e2cb07 RDI: 0000000000989041
> > RBP: 00007fff73e2cb40 R08: 0000000000000000 R09: 0000000000000000
> > R10: 00007fff73e2cb07 R11: 0000000000000000 R12: 0000000000617480
> > R13: 0000000000534349 R14: 00007fff73e2cb58 R15: 0000000000000064
> >  </TASK>
> > BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
> > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/1
> > preempt_count: 102, expected: 0
> > RCU nest depth: 0, expected: 0
> > INFO: lockdep is turned off.
> > Preemption disabled at:
> > [<0000000000000000>] 0x0
> > CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W          6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9892
> >  might_alloc include/linux/sched/mm.h:274 [inline]
> >  slab_pre_alloc_hook mm/slab.h:700 [inline]
> >  slab_alloc mm/slab.c:3278 [inline]
> >  __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
> >  kmem_cache_alloc+0x381/0x520 mm/slab.c:3491
> >  fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
> >  fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
> >  fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
> >  send_to_group fs/notify/fsnotify.c:360 [inline]
> >  fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
> >  __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
> >  fsnotify_parent include/linux/fsnotify.h:77 [inline]
> >  fsnotify_file include/linux/fsnotify.h:99 [inline]
> >  fsnotify_access include/linux/fsnotify.h:309 [inline]
> >  __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
> >  io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
> >  iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
> >  iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
> >  bio_endio+0x5f9/0x780 block/bio.c:1564
> >  req_bio_endio block/blk-mq.c:695 [inline]
> >  blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
> >  scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
> >  scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
> >  scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
> >  blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
> >  __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
> >  invoke_softirq kernel/softirq.c:445 [inline]
> >  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> >  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> >  common_interrupt+0xa9/0xc0 arch/x86/kernel/irq.c:240
> >  </IRQ>
> >  <TASK>
> >  asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
> > RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:30 [inline]
> > RIP: 0010:__orc_find+0x6f/0xf0 arch/x86/kernel/unwind_orc.c:52
> > Code: 72 4d 4c 89 e0 48 29 e8 48 89 c2 48 c1 e8 3f 48 c1 fa 02 48 01 d0 48 d1 f8 48 8d 5c 85 00 48 89 d8 48 c1 e8 03 42 0f b6 14 38 <48> 89 d8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 48 48 63 03 48 01
> > RSP: 0018:ffffc9000038f840 EFLAGS: 00000a03
> > RAX: 1ffffffff1bda94f RBX: ffffffff8ded4a7c RCX: ffffffff81595532
> > RDX: 0000000000000000 RSI: ffffffff8e5f3a12 RDI: ffffffff8ded4a6c
> > RBP: ffffffff8ded4a6c R08: ffffffff8be023e0 R09: ffffc9000038f92c
> > R10: fffff52000071f2a R11: 000000000008c07c R12: ffffffff8ded4a8c
> > R13: ffffffff8ded4a6c R14: ffffffff8ded4a6c R15: dffffc0000000000
> >  orc_find arch/x86/kernel/unwind_orc.c:178 [inline]
> >  unwind_next_frame+0x2a3/0x1cc0 arch/x86/kernel/unwind_orc.c:448
> >  arch_stack_walk+0x7d/0xe0 arch/x86/kernel/stacktrace.c:25
> >  stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:122
> >  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> >  __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
> >  call_rcu+0x99/0x790 kernel/rcu/tree.c:2793
> >  put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:183
> >  context_switch kernel/sched/core.c:5185 [inline]
> >  __schedule+0xae7/0x52b0 kernel/sched/core.c:6494
> >  schedule_idle+0x57/0x90 kernel/sched/core.c:6598
> >  do_idle+0x303/0x590 kernel/sched/idle.c:331
> >  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
> >  start_secondary+0x21d/0x2b0 arch/x86/kernel/smpboot.c:262
> >  secondary_startup_64_no_verify+0xce/0xdb
> >  </TASK>
> > BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
> > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/1
> > preempt_count: 101, expected: 0
> > RCU nest depth: 0, expected: 0
> > INFO: lockdep is turned off.
> > Preemption disabled at:
> > [<0000000000000000>] 0x0
> > CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W          6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9892
> >  might_alloc include/linux/sched/mm.h:274 [inline]
> >  slab_pre_alloc_hook mm/slab.h:700 [inline]
> >  slab_alloc mm/slab.c:3278 [inline]
> >  __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
> >  kmem_cache_alloc+0x381/0x520 mm/slab.c:3491
> >  fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
> >  fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
> >  fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
> >  send_to_group fs/notify/fsnotify.c:360 [inline]
> >  fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
> >  __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
> >  fsnotify_parent include/linux/fsnotify.h:77 [inline]
> >  fsnotify_file include/linux/fsnotify.h:99 [inline]
> >  fsnotify_access include/linux/fsnotify.h:309 [inline]
> >  __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
> >  io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
> >  iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
> >  iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
> >  bio_endio+0x5f9/0x780 block/bio.c:1564
> >  req_bio_endio block/blk-mq.c:695 [inline]
> >  blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
> >  scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
> >  scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
> >  scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
> >  blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
> >  __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
> >  invoke_softirq kernel/softirq.c:445 [inline]
> >  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> >  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> >  common_interrupt+0xa9/0xc0 arch/x86/kernel/irq.c:240
> >  </IRQ>
> >  <TASK>
> >  asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
> > RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
> > RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
> > RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
> > RIP: 0010:acpi_safe_halt+0x6f/0xb0 drivers/acpi/processor_idle.c:113
> > Code: f7 84 db 74 06 5b e9 a0 26 f8 f7 e8 9b 26 f8 f7 e8 f6 9d fe f7 66 90 e8 8f 26 f8 f7 0f 00 2d c8 a5 d1 00 e8 83 26 f8 f7 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 4e 23 f8 f7 48 85 db
> > RSP: 0018:ffffc9000038fd20 EFLAGS: 00000293
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: ffff8880121f0200 RSI: ffffffff8983119d RDI: ffffffff8983118a
> > RBP: ffff8880178c9064 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
> > R13: 0000000000000001 R14: ffff8880178c9000 R15: ffff888146aa7804
> >  acpi_idle_do_entry drivers/acpi/processor_idle.c:555 [inline]
> >  acpi_idle_enter+0x524/0x6a0 drivers/acpi/processor_idle.c:692
> >  cpuidle_enter_state+0x1ab/0xd30 drivers/cpuidle/cpuidle.c:239
> >  cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:356
> >  call_cpuidle kernel/sched/idle.c:155 [inline]
> >  cpuidle_idle_call kernel/sched/idle.c:236 [inline]
> >  do_idle+0x3e8/0x590 kernel/sched/idle.c:303
> >  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
> >  start_secondary+0x21d/0x2b0 arch/x86/kernel/smpboot.c:262
> >  secondary_startup_64_no_verify+0xce/0xdb
> >  </TASK>
> > ------------[ cut here ]------------
> > do not call blocking ops when !TASK_RUNNING; state=8 set at [<ffffffff814ad360>] ptrace_stop.part.0+0x0/0xa80 kernel/signal.c:2172
> > WARNING: CPU: 1 PID: 3606 at kernel/sched/core.c:9815 __might_sleep+0x105/0x150 kernel/sched/core.c:9815
> > Modules linked in:
> > CPU: 1 PID: 3606 Comm: syz-executor284 Tainted: G        W          6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> > RIP: 0010:__might_sleep+0x105/0x150 kernel/sched/core.c:9815
> > Code: 6f 02 00 48 8d bb 08 17 00 00 48 89 fa 48 c1 ea 03 80 3c 02 00 75 34 48 8b 93 08 17 00 00 48 c7 c7 00 1e ec 89 e8 7d c6 e8 07 <0f> 0b e9 75 ff ff ff e8 cf d5 74 00 e9 26 ff ff ff 89 34 24 e8 d2
> > RSP: 0018:ffffc900003f8810 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: ffff88807dd3c080 RCX: 0000000000000000
> > RDX: ffff88807dd3c080 RSI: ffffffff81611da8 RDI: fffff5200007f0f4
> > RBP: ffffffff8b840617 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000080000102 R11: 6320746f6e206f64 R12: 0000000000000112
> > R13: 0000000000404cc0 R14: 0000000000000048 R15: 0000000000000200
> > FS:  0000555555731300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020000010 CR3: 00000000743dd000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <IRQ>
> >  might_alloc include/linux/sched/mm.h:274 [inline]
> >  slab_pre_alloc_hook mm/slab.h:700 [inline]
> >  slab_alloc mm/slab.c:3278 [inline]
> >  __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
> >  kmem_cache_alloc+0x381/0x520 mm/slab.c:3491
> >  fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
> >  fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
> >  fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
> >  send_to_group fs/notify/fsnotify.c:360 [inline]
> >  fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
> >  __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
> >  fsnotify_parent include/linux/fsnotify.h:77 [inline]
> >  fsnotify_file include/linux/fsnotify.h:99 [inline]
> >  fsnotify_access include/linux/fsnotify.h:309 [inline]
> >  __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
> >  io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
> >  iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
> >  iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
> >  bio_endio+0x5f9/0x780 block/bio.c:1564
> >  req_bio_endio block/blk-mq.c:695 [inline]
> >  blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
> >  scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
> >  scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
> >  scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
> >  blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
> >  __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
> >  invoke_softirq kernel/softirq.c:445 [inline]
> >  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> >  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> >  common_interrupt+0xa9/0xc0 arch/x86/kernel/irq.c:240
> >  </IRQ>
> >  <TASK>
> >  asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
> > RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
> > RIP: 0010:_raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:194
> > Code: 74 24 10 e8 5a 76 db f7 48 89 ef e8 e2 f7 db f7 81 e3 00 02 00 00 75 25 9c 58 f6 c4 02 75 2d 48 85 db 74 01 fb bf 01 00 00 00 <e8> 23 b9 ce f7 65 8b 05 ac 45 7f 76 85 c0 74 0a 5b 5d c3 e8 e0 85
> > RSP: 0018:ffffc90003067c88 EFLAGS: 00000206
> > RAX: 0000000000000046 RBX: 0000000000000200 RCX: 1ffffffff1bbcead
> > RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000001
> > RBP: ffff888026549640 R08: 0000000000000000 R09: 0000000000000000
> > R10: ffffed1004ca92c8 R11: 0000000000000001 R12: ffff88807e924040
> > R13: ffff888026549640 R14: ffffc90003067d20 R15: 0000000000000246
> >  spin_unlock_irqrestore include/linux/spinlock.h:404 [inline]
> >  do_notify_parent_cldstop+0x569/0xa40 kernel/signal.c:2190
> >  ptrace_stop.part.0+0x834/0xa80 kernel/signal.c:2293
> >  ptrace_stop kernel/signal.c:2232 [inline]
> >  ptrace_do_notify+0x215/0x2b0 kernel/signal.c:2344
> >  ptrace_notify+0xc4/0x140 kernel/signal.c:2356
> >  ptrace_report_syscall include/linux/ptrace.h:420 [inline]
> >  ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
> >  syscall_exit_work kernel/entry/common.c:249 [inline]
> >  syscall_exit_to_user_mode_prepare+0x129/0x280 kernel/entry/common.c:276
> >  __syscall_exit_to_user_mode_work kernel/entry/common.c:281 [inline]
> >  syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:294
> >  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f457e2494f6
> > Code: 0f 1f 40 00 31 c9 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 90 48 83 ec 28 89 54 24 14 48 89 74 24
> > RSP: 002b:00007ffd6ecf35c8 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
> > RAX: 0000000000000000 RBX: 000000000000d707 RCX: 00007f457e2494f6
> > RDX: 0000000040000001 RSI: 00007ffd6ecf35f4 RDI: 00000000ffffffff
> > RBP: 0000000000000f02 R08: 0000000000000037 R09: 00007ffd6ed54080
> > R10: 0000000000000000 R11: 0000000000000246 R12: 431bde82d7b634db
> > R13: 00007ffd6ecf35f4 R14: 0000000000000000 R15: 0000000000000000
> >  </TASK>
> > ----------------
> > Code disassembly (best guess):
> >    0:	f7 84 db 74 06 5b e9 	testl  $0xf7f826a0,-0x16a4f98c(%rbx,%rbx,8)
> >    7:	a0 26 f8 f7
> >    b:	e8 9b 26 f8 f7       	callq  0xf7f826ab
> >   10:	e8 f6 9d fe f7       	callq  0xf7fe9e0b
> >   15:	66 90                	xchg   %ax,%ax
> >   17:	e8 8f 26 f8 f7       	callq  0xf7f826ab
> >   1c:	0f 00 2d c8 a5 d1 00 	verw   0xd1a5c8(%rip)        # 0xd1a5eb
> >   23:	e8 83 26 f8 f7       	callq  0xf7f826ab
> >   28:	fb                   	sti
> >   29:	f4                   	hlt
> > * 2a:	9c                   	pushfq <-- trapping instruction
> >   2b:	5b                   	pop    %rbx
> >   2c:	81 e3 00 02 00 00    	and    $0x200,%ebx
> >   32:	fa                   	cli
> >   33:	31 ff                	xor    %edi,%edi
> >   35:	48 89 de             	mov    %rbx,%rsi
> >   38:	e8 4e 23 f8 f7       	callq  0xf7f8238b
> >   3d:	48 85 db             	test   %rbx,%rbx
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
