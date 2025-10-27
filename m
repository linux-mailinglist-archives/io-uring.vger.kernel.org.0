Return-Path: <io-uring+bounces-10241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CA3C11B09
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B4F13B7A93
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3C62DF6EA;
	Mon, 27 Oct 2025 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="hz15wLEw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail3-165.sinamail.sina.com.cn (mail3-165.sinamail.sina.com.cn [202.108.3.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B3228313D
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603949; cv=none; b=SI7qE/twE71lZYEp48CL71AxxqXrXNNfh9SFeeN1wqXqPc8z0Rj4/zd9/dHMUGpCcsLDYf7HZjxJrvGHCpttQTC7Z0/OpWKGkxydN+BICVTnLgO4JHkRRTJlTJGavz/vZkCH2zA/eVW7c3Z8tvwbAsbC4GIzyzboZTmIMv0qcnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603949; c=relaxed/simple;
	bh=MELHpoyhMTTXFykzovF1NFj4Zq0xGpBjRy1THLoS1XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpEILQp646npdrLGoNKd1v0/TzPgVPlnFz40dYZyy8QXIIFoa3XMDam6tue/PUXo9lGJc1zjD2J/yNMm/RpCCTXH7MxLUjyF71ALyBsTCIFdPgO8xwhnzX+2oNyZKhgztHVB0R5WuC5UHTPenIA6AeDyD/HeonCHb+GNDBOp4uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=hz15wLEw; arc=none smtp.client-ip=202.108.3.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1761603945;
	bh=KU8eaWv3UWgjIS0haPDbDcSIMTD4VtMtuJtJYn2tKsI=;
	h=From:Subject:Date:Message-ID;
	b=hz15wLEwWMq7NAubfcMHmn4/HH2YflMAYN3yyzum4lOTtGlJA8hREU61xsauI0qXO
	 g9IvVDh1mC+KgELUQJaBgHiJ3y+UCZ5+cUCkz5WLfe4Tog7c274dwzPECiXGISneu3
	 1fJEaxQ4eXT0ZkHHKw6M4AW4ZyTjWjpVRw5lKf3A=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.33) with ESMTP
	id 68FFF1400000573B; Mon, 28 Oct 2025 06:25:06 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 5945856685317
X-SMAIL-UIID: 8575833BC49644AEBAC5C0D7E5682E20-20251028-062506-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node (5)
Date: Tue, 28 Oct 2025 06:24:53 +0800
Message-ID: <20251027222454.8795-1-hdanton@sina.com>
In-Reply-To: <68ffdf18.050a0220.3344a1.039e.GAE@google.com>
References: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 27 Oct 2025 16:04:05 -0600 Jens Axboe wrote:
> On 10/27/25 3:07 PM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    72fb0170ef1f Add linux-next specific files for 20251024
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13087be2580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
> > dashboard link: https://syzkaller.appspot.com/bug?extid=10a9b495f54a17b607a6
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14725d2f980000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11233b04580000
> 
> [snip]
> 
> > RAX: ffffffff82431501 RBX: 0000000000000018 RCX: ffffffff824315fd
> > RDX: 0000000000000001 RSI: 0000000000000018 RDI: ffffc9000383f880
> > RBP: 0000000000000000 R08: ffffc9000383f897 R09: 1ffff92000707f12
> > R10: dffffc0000000000 R11: fffff52000707f13 R12: 0000000000000003
> > R13: ffff888079527128 R14: fffff52000707f13 R15: 1ffff92000707f10
> > FS:  00007f4e567906c0(0000) GS:ffff888125cdc000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055db9a726918 CR3: 000000002ec48000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  __asan_memset+0x22/0x50 mm/kasan/shadow.c:84
> >  seq_printf+0xad/0x270 fs/seq_file.c:403
> >  __io_uring_show_fdinfo io_uring/fdinfo.c:142 [inline]
> >  io_uring_show_fdinfo+0x734/0x17d0 io_uring/fdinfo.c:256
> >  seq_show+0x5bc/0x730 fs/proc/fd.c:68
> >  seq_read_iter+0x4ef/0xe20 fs/seq_file.c:230
> >  seq_read+0x369/0x480 fs/seq_file.c:162
> >  vfs_read+0x200/0xa30 fs/read_write.c:570
> >  ksys_read+0x145/0x250 fs/read_write.c:715
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Keith, I'm pretty sure your change:
> 
> commit 1cba30bf9fdd6c982708f3587f609a30c370d889
> Author: Keith Busch <kbusch@kernel.org>
> Date:   Thu Oct 16 11:09:38 2025 -0700
> 
>     io_uring: add support for IORING_SETUP_SQE_MIXED
> 
> leaves fdinfo open up to being broken. Before, we had:
> 
> sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
> 
> as a cap for the loop, now you just have:
> 
> while (sq_head < sq_tail) {
> 
> which seems like a bad idea. It's also missing an sq_head increment if
> we hit this condition:
> 
> if (sq_idx > sq_mask)
> 	continue;
> 
> which is also something you can trigger, and which would also end up in
> an infinite loop.

Test Jens's fix.

#syz test

Totally untested, but how about something like the below:

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 7fb900f1d8f6..3f254ae0ad61 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -66,6 +66,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	unsigned int sq_shift = 0;
+	unsigned int sq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
 	unsigned int i;
@@ -88,17 +89,18 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
 	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
 	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
-	while (sq_head < sq_tail) {
+	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
+	for (i = 0; i < sq_entries; i++) {
+		unsigned int entry = i + sq_head;
 		struct io_uring_sqe *sqe;
 		unsigned int sq_idx;
 		bool sqe128 = false;
 		u8 opcode;
 
 		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
-			sq_idx = sq_head & sq_mask;
+			sq_idx = entry & sq_mask;
 		else
-			sq_idx = READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
-
+			sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
 
@@ -140,7 +142,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
-		sq_head++;
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
 	while (cq_head < cq_tail) {
-- 
Jens Axboe

