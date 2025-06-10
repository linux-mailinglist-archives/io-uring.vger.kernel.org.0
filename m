Return-Path: <io-uring+bounces-8290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0A7AD34CB
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 13:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A4CD3B3616
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 11:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E38922370F;
	Tue, 10 Jun 2025 11:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="har32Mju"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1831A5BB2;
	Tue, 10 Jun 2025 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749554265; cv=none; b=TSSuYsfgbK7qIA7pKQ41mbZxKO/iMUK37OJTEKCwe3kTN40gFk4o8Pd4sFkw/nRTl/lUDUiZZ/3c4Hy3p29dUTrQTD5Xjkoux+tC1FeMozJc/Tj+KIkM1yblkNDzPs7+86cHieNz9zC+FR3o7OpSci+fA+767X8DZmsWuq+nJQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749554265; c=relaxed/simple;
	bh=BiLNb+ymlxK5xBNq79TAjl8GuWj0orzj8EMKrnpSafI=;
	h=From:To:Cc:Subject:Date:Message-Id; b=VZH6KYMeAbcxCpPEfFDtiuP+Hs9Ll9v+9s7AS4ccXhXi1q6KFuMeTAkmuqtINfTLZn2QtWMb/yUlZ9T1nLxFRkbZLyh5H3Lvqqfkt7cGyThz28Tasr7D3MiFubNDxyhqHR5WUS6KDd5ZPE+Pzy1NO5TdBY6u6iT6MU0rL/lU33Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=har32Mju; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-236192f8770so17229195ad.0;
        Tue, 10 Jun 2025 04:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749554263; x=1750159063; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSMpqaqQSKTKeXR3v6vlDSkMoFFFsaz4CspAPT1bNR0=;
        b=har32MjuogtffBeJVS6ZmIW+aSsYCO6JosBF1el6Ljv+XbPIGPlIrJ1kN8wPEuC2Sd
         IUGcjhFEm583m8wqd2+uTvyuwJe6usN4Bhw8Rmmw8BMYqZ2yJtWevXHhm/FBwfOm3K6l
         AvGidPi14WiBmKm8jiuyxfcQJsHoDgT23aUITPZ7ZCSP9OrcJeo4Oeiu4z0NubCaq+IJ
         Z9IYHHfiptw5WrEBbnyzd93vsMBv0cnRmoWu0vrXrhlU6dtFxSYlHrk2WL/6QhTGuXHj
         AM432JAUhxnv9St15tjDL8QbLBxaUrq89BuCA65Qzzb7Jl47PncWVwbMf2i5NLhZTqDF
         SLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749554263; x=1750159063;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vSMpqaqQSKTKeXR3v6vlDSkMoFFFsaz4CspAPT1bNR0=;
        b=rqTuYFHH5gEaQE5wcasfgxmM0y2FAnWHhiF+ZPW5cbxQ44PSStgXnHSeH8v3qOV9Cc
         1lSPsFU1LOs0Zi29Qvk/zq3pujDu6Qeb9EjrrXRLep9iMx7hBysR8+iw7tDJmnGnf4pL
         IRvlMUIAFBnK5D4Z1mt19rQBvet+f1WpDFo2c15fO+v6mKwzoZexLLYzZLsJGu25T25W
         DZUKDP54abEnMFRHDPVvpa1WpEZbHEpbysXc2iEE94IiUOVR5uvNsqNh4fohMn9N61e3
         jG2d35vKlY2yxqyyXjBLoeUUr+noclC2Q/rFPYi+FFm/lC1XGb3zrU8JYDtX9OoRu3v4
         j6OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIowUniI+XhM62mWmy+Q20Fg7HO4KusFbiHU6KOvlCEUkPVZcYnzL7KW1Hola7vLDQdEBP2Rm1Vuk8Slk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcuqUcSXOa8m8Z9Kj0mwM0G7VoPvRcVQCoQGB/rOeNePW8Jh0t
	vCfe4C83OniOnHO+vveSIhyngXme2uyLsnMhH7/qgCzpcEYHAxTtU/cn
X-Gm-Gg: ASbGncuTHOwv6sNLpvew+qgvIFAVGmm1Z2/jkCSM/gezaw8zMUpGaxKRoO4UVI9r+xp
	pOq6CB6tTKOEPvi1VRbL5MMOAZdXYVTISfDo/zBABBOXvYROkiiuM363Wo4GXyWK0GNWsMl7kqJ
	mxwwQBCq8dNPoSkCYBBYGFkySLLCbu2kqdQftSlRMsofwdsFED5lKG3b7CyAcpKHzLLlwI+rOf2
	C1WT9GZ8udpcs68a03y4JiZfcZtktCfNTm9LGOXvRjFndQtWFPQPak4zkl+iWvFBRxGl8iZxgbP
	yXI9rHn7hdj8ieuYtBi4nAfgwry+u9dWyghmQnuHp7KHqj/77j8urfCqBbZtvO3GT1u50TAz/JB
	kcuQ2MCE=
X-Google-Smtp-Source: AGHT+IHeQaiZJcuMI7UTdSc4MBhKsNfgT3sNZPNCGdEh0zYYFEf3DwwxVQ9rzB8yO/kXDnXPthO5bA==
X-Received: by 2002:a17:902:ccd0:b0:236:15b7:62e3 with SMTP id d9443c01a7336-23635bb9896mr44866805ad.9.1749554262425;
        Tue, 10 Jun 2025 04:17:42 -0700 (PDT)
Received: from ubuntu.localdomain ([39.86.156.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2360351423bsm69024335ad.250.2025.06.10.04.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 04:17:42 -0700 (PDT)
From: Penglei Jiang <superman.xpt@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+531502bbbe51d2f769f4@syzkaller.appspotmail.com,
	Penglei Jiang <superman.xpt@gmail.com>
Subject: [PATCH] io_uring: fix use-after-free of sq->thread in __io_uring_show_fdinfo()
Date: Tue, 10 Jun 2025 04:17:21 -0700
Message-Id: <20250610111721.37036-1-superman.xpt@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

[BUG]

[   84.375406] ==================================================================
[   84.378543] BUG: KASAN: slab-use-after-free in getrusage+0x1109/0x1a60
[   84.381058] Read of size 8 at addr ffff88810de2d2c8 by task a.out/304
[   84.382977] 
[   84.383767] CPU: 0 UID: 0 PID: 304 Comm: a.out Not tainted 6.16.0-rc1 #1 PREEMPT(voluntary) 
[   84.383788] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   84.383819] Call Trace:
[   84.383841]  <TASK>
[   84.383842]  dump_stack_lvl+0x53/0x70
[   84.383957]  print_report+0xd0/0x670
[   84.384008]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[   84.384057]  ? getrusage+0x1109/0x1a60
[   84.384060]  kasan_report+0xce/0x100
[   84.384063]  ? getrusage+0x1109/0x1a60
[   84.384066]  getrusage+0x1109/0x1a60
[   84.384070]  ? __pfx_getrusage+0x10/0x10
[   84.384073]  __io_uring_show_fdinfo+0x9fe/0x1790
[   84.384117]  ? ksys_read+0xf7/0x1c0
[   84.384133]  ? do_syscall_64+0xa4/0x260
[   84.384144]  ? vsnprintf+0x591/0x1100
[   84.384155]  ? __pfx___io_uring_show_fdinfo+0x10/0x10
[   84.384157]  ? __pfx_vsnprintf+0x10/0x10
[   84.384175]  ? mutex_trylock+0xcf/0x130
[   84.384185]  ? __pfx_mutex_trylock+0x10/0x10
[   84.384198]  ? __pfx_show_fd_locks+0x10/0x10
[   84.384219]  ? io_uring_show_fdinfo+0x57/0x80
[   84.384222]  io_uring_show_fdinfo+0x57/0x80
[   84.384224]  seq_show+0x38c/0x690
[   84.384257]  seq_read_iter+0x3f7/0x1180
[   84.384279]  ? inode_set_ctime_current+0x160/0x4b0
[   84.384296]  seq_read+0x271/0x3e0
[   84.384298]  ? __pfx_seq_read+0x10/0x10
[   84.384300]  ? __pfx__raw_spin_lock+0x10/0x10
[   84.384303]  ? __mark_inode_dirty+0x402/0x810
[   84.384313]  ? selinux_file_permission+0x368/0x500
[   84.384385]  ? file_update_time+0x10f/0x160
[   84.384388]  vfs_read+0x177/0xa40
[   84.384393]  ? __pfx___handle_mm_fault+0x10/0x10
[   84.384440]  ? __pfx_vfs_read+0x10/0x10
[   84.384443]  ? mutex_lock+0x81/0xe0
[   84.384446]  ? __pfx_mutex_lock+0x10/0x10
[   84.384449]  ? fdget_pos+0x24d/0x4b0
[   84.384452]  ksys_read+0xf7/0x1c0
[   84.384455]  ? __pfx_ksys_read+0x10/0x10
[   84.384458]  ? do_user_addr_fault+0x43b/0x9c0
[   84.384486]  do_syscall_64+0xa4/0x260
[   84.384489]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   84.384528] RIP: 0033:0x7f0f74170fc9
[   84.384560] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 8
[   84.384563] RSP: 002b:00007fffece049e8 EFLAGS: 00000206 ORIG_RAX: 0000000000000000
[   84.384588] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0f74170fc9
[   84.384611] RDX: 0000000000001000 RSI: 00007fffece049f0 RDI: 0000000000000004
[   84.384613] RBP: 00007fffece05ad0 R08: 0000000000000000 R09: 00007fffece04d90
[   84.384615] R10: 0000000000000000 R11: 0000000000000206 R12: 00005651720a1100
[   84.384617] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   84.384619]  </TASK>
[   84.384620] 
[   84.461314] Allocated by task 298:
[   84.462019]  kasan_save_stack+0x33/0x60
[   84.462598]  kasan_save_track+0x14/0x30
[   84.463213]  __kasan_slab_alloc+0x6e/0x70
[   84.463853]  kmem_cache_alloc_node_noprof+0xe8/0x330
[   84.465483]  copy_process+0x376/0x5e00
[   84.466798]  create_io_thread+0xab/0xf0
[   84.468355]  io_sq_offload_create+0x9ed/0xf20
[   84.470323]  io_uring_setup+0x12b0/0x1cc0
[   84.471830]  do_syscall_64+0xa4/0x260
[   84.473255]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   84.474952] 
[   84.475758] Freed by task 22:
[   84.476878]  kasan_save_stack+0x33/0x60
[   84.478400]  kasan_save_track+0x14/0x30
[   84.479709]  kasan_save_free_info+0x3b/0x60
[   84.480777]  __kasan_slab_free+0x37/0x50
[   84.481299]  kmem_cache_free+0xc4/0x360
[   84.481945]  rcu_core+0x5ff/0x19f0
[   84.483038]  handle_softirqs+0x18c/0x530
[   84.485407]  run_ksoftirqd+0x20/0x30
[   84.487146]  smpboot_thread_fn+0x287/0x6c0
[   84.488552]  kthread+0x30d/0x630
[   84.489856]  ret_from_fork+0xef/0x1a0
[   84.491239]  ret_from_fork_asm+0x1a/0x30
[   84.492366] 
[   84.493099] Last potentially related work creation:
[   84.495175]  kasan_save_stack+0x33/0x60
[   84.496416]  kasan_record_aux_stack+0x8c/0xa0
[   84.498060]  __call_rcu_common.constprop.0+0x68/0x940
[   84.499326]  __schedule+0xff2/0x2930
[   84.499970]  __cond_resched+0x4c/0x80
[   84.501305]  mutex_lock+0x5c/0xe0
[   84.502374]  io_uring_del_tctx_node+0xe1/0x2b0
[   84.504251]  io_uring_clean_tctx+0xb7/0x160
[   84.505377]  io_uring_cancel_generic+0x34e/0x760
[   84.507126]  do_exit+0x240/0x2350
[   84.508667]  do_group_exit+0xab/0x220
[   84.509927]  __x64_sys_exit_group+0x39/0x40
[   84.511223]  x64_sys_call+0x1243/0x1840
[   84.512795]  do_syscall_64+0xa4/0x260
[   84.514044]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   84.515792] 
[   84.516374] The buggy address belongs to the object at ffff88810de2cb00
[   84.516374]  which belongs to the cache task_struct of size 3712
[   84.521449] The buggy address is located 1992 bytes inside of
[   84.521449]  freed 3712-byte region [ffff88810de2cb00, ffff88810de2d980)
[   84.524996] 
[   84.525514] The buggy address belongs to the physical page:
[   84.527383] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10de28
[   84.530907] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   84.533573] flags: 0x200000000000040(head|node=0|zone=2)
[   84.535366] page_type: f5(slab)
[   84.536410] raw: 0200000000000040 ffff8881001acdc0 dead000000000122 0000000000000000
[   84.538807] raw: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
[   84.542033] head: 0200000000000040 ffff8881001acdc0 dead000000000122 0000000000000000
[   84.545121] head: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
[   84.547663] head: 0200000000000003 ffffea0004378a01 00000000ffffffff 00000000ffffffff
[   84.549959] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   84.552180] page dumped because: kasan: bad access detected
[   84.554098] 
[   84.554798] Memory state around the buggy address:
[   84.556798]  ffff88810de2d180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   84.559258]  ffff88810de2d200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   84.562112] >ffff88810de2d280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   84.564710]                                               ^
[   84.567076]  ffff88810de2d300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   84.569900]  ffff88810de2d380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   84.573018] ==================================================================

[CAUSE]

The task_struct pointed to by sq->thread is released while it is being
used in the function __io_uring_show_fdinfo(), because holding the lock
ctx->uring_lock does not prevent the release of sq->thread.

[FIX]

The fix is to increase the reference count of the task_struct pointed
to by sq->thread and to use RCU to ensure that it is not released while
being used.


Reported-by: syzbot+531502bbbe51d2f769f4@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/682b06a5.a70a0220.3849cf.00b3.GAE@google.com
Fixes: a0d45c3f596b ("io_uring/fdinfo: remove need for sqpoll lock for thread/pid retrieval")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
---
 io_uring/fdinfo.c | 8 ++++++--
 io_uring/sqpoll.c | 9 ++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index e9355276ab5d..2911352bbae1 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -141,19 +141,23 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sq = ctx->sq_data;
+		struct task_struct *tsk;
 
+		rcu_read_lock();
+		tsk = rcu_dereference(sq->thread);
 		/*
 		 * sq->thread might be NULL if we raced with the sqpoll
 		 * thread termination.
 		 */
-		if (sq->thread) {
+		if (tsk) {
 			sq_pid = sq->task_pid;
 			sq_cpu = sq->sq_cpu;
-			getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
+			getrusage(tsk, RUSAGE_SELF, &sq_usage);
 			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
 					 + sq_usage.ru_stime.tv_usec);
 			sq_work_time = sq->work_time;
 		}
+		rcu_read_unlock();
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 03c699493b5a..0625a421626f 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -270,7 +270,8 @@ static int io_sq_thread(void *data)
 	/* offload context creation failed, just exit */
 	if (!current->io_uring) {
 		mutex_lock(&sqd->lock);
-		sqd->thread = NULL;
+		rcu_assign_pointer(sqd->thread, NULL);
+		put_task_struct(current);
 		mutex_unlock(&sqd->lock);
 		goto err_out;
 	}
@@ -379,7 +380,8 @@ static int io_sq_thread(void *data)
 		io_sq_tw(&retry_list, UINT_MAX);
 
 	io_uring_cancel_generic(true, sqd);
-	sqd->thread = NULL;
+	rcu_assign_pointer(sqd->thread, NULL);
+	put_task_struct(current);
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		atomic_or(IORING_SQ_NEED_WAKEUP, &ctx->rings->sq_flags);
 	io_run_task_work();
@@ -495,9 +497,6 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 		ret = -EINVAL;
 		goto err;
 	}
-
-	if (task_to_put)
-		put_task_struct(task_to_put);
 	return 0;
 err_sqpoll:
 	complete(&ctx->sq_data->exited);
-- 
2.17.1


