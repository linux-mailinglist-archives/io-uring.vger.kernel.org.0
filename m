Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D143B52A099
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 13:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbiEQLl4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 07:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbiEQLlz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 07:41:55 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82012A705
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 04:41:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h14so4708347wrc.6
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 04:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=+DUMBwRnPHVrYaL6kEZ3uz/r3+Oyxm0IaH+DCCCsx84=;
        b=bPI4vSnBSP28/nUgUDtt2F89yLw1MwKVa2XySzXFHR4qocSzHDurBPILO+uPIUQsiI
         qrhMc6lhLiYs6BTSgWUgeULA9xgs0Dg0+8tVVmiSTMgj1FBbMOgJcWcImiMqoXUlciIF
         yMmrzgTf/JRsqnYDEkZfMQu17baaeziPNgfWgMmRWDRqF2UB5GqNImwwSV5xCc/JrPkP
         z+UsK1u5QSzJ0bY8dIxEFx3t4YY+coqz/OtOdmfrgrEyl+vdWD0NB7o2VidJXzEgWXea
         o0+nHm03qP7jTGpwo+E8sTtKzp8YnycO6MN7PkYlAsErKAIXhuivotwX9c0wWgHDIlbP
         wLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=+DUMBwRnPHVrYaL6kEZ3uz/r3+Oyxm0IaH+DCCCsx84=;
        b=SWdjIRbcCVPBeECMOfuhfmOjLjcTeFtYSsaD/8oYMQbLl4ahtvADwGMZPWJfqERG2Z
         CQX/8Q5IEK+lReTsG2lyX2+/8t9Sjci05G4CO9mVPCtEvQD8jk+7mUS7/qD59sywblRS
         rkZ6TyME+FdpULg6hQnD52IQXzKRe0ZamhaX1nysRhdZJqM5O6OKmK+aUEZ/gofD9q5q
         7oaE//X09Z2FawpU6T4hZXHD1DgwsTvBkuzSKE90t5Umjeiea6lAUFCUApV+/D5NeJSq
         0fqyR5hbNjI9Nqi9Pg+DlWA3bj3OxzTPBdo4WXqVYC2pOUL5nZTm+cXBMKKQs5SJQzDx
         dTgg==
X-Gm-Message-State: AOAM533PmClXCvV05D9SrQpbRbnnh0WSPKOVJ2+dYfEVAdyouClelxay
        5+1XANZylVh2pkfIa8DTua3uPwCV4abS1w==
X-Google-Smtp-Source: ABdhPJyWsqDkDnjgUydHlfprtuCEn64NfPwIVpRUETbc9yGZHtJEXgOTGwXN2fJY4jF6PrxA8woxMQ==
X-Received: by 2002:adf:f106:0:b0:20d:20a:96e8 with SMTP id r6-20020adff106000000b0020d020a96e8mr11919213wro.495.1652787711855;
        Tue, 17 May 2022 04:41:51 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id f26-20020a7bcd1a000000b003942a244ee2sm1599738wmj.39.2022.05.17.04.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 04:41:51 -0700 (PDT)
Date:   Tue, 17 May 2022 12:41:49 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Message-ID: <YoOJ/T4QRKC+fAZE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Good afternoon Jens, Pavel, et al.,

Not sure if you are presently aware, but there appears to be a
use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
in Stable v5.10.y.

The full sysbot report can be seen below [0].

The C-reproducer has been placed below that [1].

I had great success running this reproducer in an infinite loop.

My colleague reverse-bisected the fixing commit to:

  commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
  Author: Jens Axboe <axboe@kernel.dk>
  Date:   Fri Feb 26 09:47:20 2021 -0700

       io-wq: have manager wait for all workers to exit

       Instead of having to wait separately on workers and manager, just have
       the manager wait on the workers. We use an atomic_t for the reference
       here, as we need to start at 0 and allow increment from that. Since the
       number of workers is naturally capped by the allowed nr of processes,
       and that uses an int, there is no risk of overflow.

       Signed-off-by: Jens Axboe <axboe@kernel.dk>

    fs/io-wq.c | 30 ++++++++++++++++++++++--------
    1 file changed, 22 insertions(+), 8 deletions(-)

I've had a go at back-porting this to v5.10.y, but due to the fact
that the history has changed so much between v5.10 and the fixing
commit, the dependency list became too large.

As I'm sure you can imagine, v5.10.y is an important release.  Many
devices depend on it as their foundation.

Would you be able to help me solve this at all?

As always, any help would be gratefully received.

Kind regards,
Lee

[0]
Link: https://groups.google.com/g/syzkaller-android-bugs/c/AHlBaNqM5Ao/m/v505LkOzDgAJ

Hello,

syzbot found the following issue on:

HEAD commit: 0347b1658399 Merge 5.10.93 into android12-5.10-lts
git tree: android12-5.10-lts
console output: https://syzkaller.appspot.com/x/log.txt?x=15c5013db00000
kernel config: https://syzkaller.appspot.com/x/.config?x=e0f3947457f8d2a4
dashboard link: https://syzkaller.appspot.com/bug?extid=569a9f38546d62a570d2
compiler: Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro: https://syzkaller.appspot.com/x/repro.syz?x=13ab16d0700000
C reproducer: https://syzkaller.appspot.com/x/repro.c?x=15ac697bb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+569a9f...@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in __fget_light fs/file.c:903 [inline]
BUG: KASAN: use-after-free in __fdget_raw+0x57/0x1e0 fs/file.c:923
Read of size 4 at addr ffff88811d4d0000 by task io_wqe_worker-0/374

CPU: 1 PID: 374 Comm: io_wqe_worker-0 Not tainted 5.10.93-syzkaller-01028-g0347b1658399 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
__dump_stack lib/dump_stack.c:77 [inline]
dump_stack_lvl+0x1e2/0x24b lib/dump_stack.c:118
print_address_description+0x8d/0x3d0 mm/kasan/report.c:233
__kasan_report+0x142/0x220 mm/kasan/report.c:419
kasan_report+0x51/0x70 mm/kasan/report.c:436
check_region_inline mm/kasan/generic.c:135 [inline]
kasan_check_range+0x2b6/0x2f0 mm/kasan/generic.c:186
__kasan_check_read+0x11/0x20 mm/kasan/shadow.c:31
instrument_atomic_read include/linux/instrumented.h:71 [inline]
atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
__fget_light fs/file.c:903 [inline]
__fdget_raw+0x57/0x1e0 fs/file.c:923
fdget_raw include/linux/file.h:70 [inline]
path_init+0x6aa/0x1130 fs/namei.c:2347
path_lookupat+0x2b/0x6c0 fs/namei.c:2403
filename_lookup+0x23f/0x6c0 fs/namei.c:2446
user_path_at_empty+0x40/0x50 fs/namei.c:2726
user_path_at include/linux/namei.h:59 [inline]
vfs_statx+0x10a/0x3f0 fs/stat.c:193
do_statx+0xec/0x170 fs/stat.c:588
io_statx fs/io_uring.c:4249 [inline]
io_issue_sqe+0x2541/0xfc10 fs/io_uring.c:6086
io_wq_submit_work+0x34c/0xf40 fs/io_uring.c:6155
io_worker_handle_work+0x1558/0x1d90 fs/io-wq.c:573
io_wqe_worker+0x39f/0xf20 fs/io-wq.c:615
kthread+0x371/0x390 kernel/kthread.c:313
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 365:
kasan_save_stack mm/kasan/common.c:38 [inline]
kasan_set_track mm/kasan/common.c:46 [inline]
set_alloc_info mm/kasan/common.c:428 [inline]
__kasan_slab_alloc+0xb2/0xe0 mm/kasan/common.c:461
kasan_slab_alloc include/linux/kasan.h:259 [inline]
slab_post_alloc_hook mm/slab.h:583 [inline]
slab_alloc_node mm/slub.c:2954 [inline]
slab_alloc mm/slub.c:2962 [inline]
kmem_cache_alloc+0x1a2/0x380 mm/slub.c:2967
dup_fd+0x71/0xc60 fs/file.c:293
copy_files kernel/fork.c:1517 [inline]
copy_process+0x12a6/0x5340 kernel/fork.c:2139
kernel_clone+0x21f/0x9a0 kernel/fork.c:2513
__do_sys_clone kernel/fork.c:2632 [inline]
__se_sys_clone kernel/fork.c:2616 [inline]
__x64_sys_clone+0x258/0x2d0 kernel/fork.c:2616
do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 366:
kasan_save_stack mm/kasan/common.c:38 [inline]
kasan_set_track+0x4c/0x80 mm/kasan/common.c:46
kasan_set_free_info+0x23/0x40 mm/kasan/generic.c:357
____kasan_slab_free+0x133/0x170 mm/kasan/common.c:360
__kasan_slab_free+0x11/0x20 mm/kasan/common.c:368
kasan_slab_free include/linux/kasan.h:235 [inline]
slab_free_hook mm/slub.c:1602 [inline]
slab_free_freelist_hook+0xcc/0x1a0 mm/slub.c:1628
slab_free mm/slub.c:3210 [inline]
kmem_cache_free+0xb5/0x1f0 mm/slub.c:3226
put_files_struct+0x318/0x350 fs/file.c:434
exit_files+0x80/0xa0 fs/file.c:458
do_exit+0x6d9/0x23a0 kernel/exit.c:808
do_group_exit+0x16a/0x2d0 kernel/exit.c:910
__do_sys_exit_group+0x17/0x20 kernel/exit.c:921
__se_sys_exit_group+0x14/0x20 kernel/exit.c:919
__x64_sys_exit_group+0x3b/0x40 kernel/exit.c:919
do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88811d4d0000
which belongs to the cache files_cache of size 704
The buggy address is located 0 bytes inside of
704-byte region [ffff88811d4d0000, ffff88811d4d02c0)
The buggy address belongs to the page:
page:ffffea0004753400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11d4d0
head:ffffea0004753400 order:2 compound_mapcount:0 compound_pincount:0
flags: 0x8000000000010200(slab|head)
raw: 8000000000010200 dead000000000100 dead000000000122 ffff888100066f00
raw: 0000000000000000 0000000080130013 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 357, ts 15953240908, free_ts 0
set_page_owner include/linux/page_owner.h:35 [inline]
post_alloc_hook mm/page_alloc.c:2385 [inline]
prep_new_page mm/page_alloc.c:2391 [inline]
get_page_from_freelist+0xa74/0xa90 mm/page_alloc.c:4063
__alloc_pages_nodemask+0x3c8/0x820 mm/page_alloc.c:5106
alloc_slab_page mm/slub.c:1813 [inline]
allocate_slab+0x6b/0x350 mm/slub.c:1815
new_slab mm/slub.c:1876 [inline]
new_slab_objects mm/slub.c:2635 [inline]
___slab_alloc+0x143/0x2f0 mm/slub.c:2798
__slab_alloc mm/slub.c:2838 [inline]
slab_alloc_node mm/slub.c:2920 [inline]
slab_alloc mm/slub.c:2962 [inline]
kmem_cache_alloc+0x26f/0x380 mm/slub.c:2967
dup_fd+0x71/0xc60 fs/file.c:293
copy_files kernel/fork.c:1517 [inline]
copy_process+0x12a6/0x5340 kernel/fork.c:2139
kernel_clone+0x21f/0x9a0 kernel/fork.c:2513
__do_sys_clone kernel/fork.c:2632 [inline]
__se_sys_clone kernel/fork.c:2616 [inline]
__x64_sys_clone+0x258/0x2d0 kernel/fork.c:2616
do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
entry_SYSCALL_64_after_hwframe+0x44/0xa9
page_owner free stack trace missing

Memory state around the buggy address:
ffff88811d4cff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff88811d4cff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88811d4d0000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
^
ffff88811d4d0080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
ffff88811d4d0100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
============================

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzk...@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches


[1]

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <sched.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <sys/shm.h>
#include "io_uring.h"

#ifndef __NR_io_uring_enter
#define __NR_io_uring_enter 426
#endif
#ifndef __NR_io_uring_setup
#define __NR_io_uring_setup 425
#endif

char filename[] = "./file0";

int trigger(void *data) {
	struct io_uring_params params = {};
	int io_uring_fd = syscall(SYS_io_uring_setup, 0x200, &params);
	if (io_uring_fd < 0) {
		printf("io_uring_setup failed:%d\n", io_uring_fd);
		exit(-1);
	}
	else {
		printf("io_uring_setup success:%d\n", io_uring_fd);
	}
	uint32_t sq_ring_sz = params.sq_off.array + params.sq_entries * sizeof(uint32_t);
	uint32_t cq_ring_sz = params.cq_off.cqes + params.cq_entries * sizeof(struct io_uring_cqe);
	uint32_t ring_sz = sq_ring_sz > cq_ring_sz ? sq_ring_sz : cq_ring_sz;
	unsigned char *sq_ring = mmap(NULL, ring_sz, PROT_READ | PROT_WRITE, MAP_SHARED, io_uring_fd,
						IORING_OFF_SQ_RING);
	uint32_t sqes_sz = params.sq_entries * sizeof(struct io_uring_sqe);
	struct io_uring_sqe *sqes = mmap(NULL, sqes_sz, PROT_READ | PROT_WRITE,
						MAP_SHARED, io_uring_fd, IORING_OFF_SQES);
	if (sqes == MAP_FAILED && sq_ring == MAP_FAILED) {
		perror("mmap");
		exit(-1);
	}
	sqes[0] = (struct io_uring_sqe) {
		.opcode = IORING_OP_MADVISE,
		.flags = IOSQE_IO_LINK,
		.addr = 0,
		.user_data = 0x4000,
	};
	sqes[1] = (struct io_uring_sqe) {
		.opcode = IORING_OP_STATX,
		.fd = -1,
		.addr = (unsigned long)filename,
		.len = 1,
		.rw_flags = 0x100,
	};
	((int *)(sq_ring + params.sq_off.array))[0] = 0;
	((int *)(sq_ring + params.sq_off.array))[1] = 1;
	for (int i = 2; i < 0x200; i++) {
		((int *)(sq_ring + params.sq_off.array))[i] = 1;
	}
	(*(int *)(sq_ring + params.sq_off.tail)) += 0x200;
	int submitted = syscall(SYS_io_uring_enter, io_uring_fd, 0x200, 0, 0, 0, 0);
	close(io_uring_fd);
	usleep(10000);
	puts("exit");
	exit(0);
	return 0;
}

#define STACK_SIZE 1024 * 1024

int main() {
	char *stack, *stacktop;
	pid_t pid;

	stack = mmap(NULL, STACK_SIZE, PROT_READ | PROT_WRITE, 
			MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
	if (stack == MAP_FAILED) {
		perror("mmap stack");
		exit(-1);
	}
	stacktop = stack + STACK_SIZE;
	pid = clone(trigger, stacktop, CLONE_VM, NULL);
	sleep(5);
	return 0;
}

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
