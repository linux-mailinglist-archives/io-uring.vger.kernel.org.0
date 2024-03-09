Return-Path: <io-uring+bounces-881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F5F876E27
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 01:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 405D52830DE
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F41C7E5;
	Sat,  9 Mar 2024 00:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pw47fLOa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NmQdVxYB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pw47fLOa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NmQdVxYB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA57627
	for <io-uring@vger.kernel.org>; Sat,  9 Mar 2024 00:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709944389; cv=none; b=JVXxs7NwwF+HfCMCPiriSi6NuqA1ehxvHXudxQovvdsBWDUwKmobvp8WfIahjFFA+hejmMIJpmNyKv8Jfe5vUuffMDpfnp8YQsw5qTtQrChSHtzvDpzGLL6t12Z7x2jOQO4t/RbSUdAU4N1WYRG2L3zP9MFNaVx/yGNd5H+35h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709944389; c=relaxed/simple;
	bh=QDc4/qo5pSV8mN+Wh/y4MboZsW94ipDrHbrWmz94LiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HoxjoDeAFt5i/LUiIPJz8/wS0wx6bjuKYWLQ48Y2V/4DMB1BXcukF0amhoDMuLt+iydSTjCrJ2fTqH0WJQPnU897cKL3yfExb2iHjMU9QIS90f1zbTp7wr8yGpTptN2EoH4riBKtb/mmxbE8qGZIXbdY1DrMGcEqvB+CeW8cqtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pw47fLOa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NmQdVxYB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pw47fLOa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NmQdVxYB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 953E91F76B;
	Sat,  9 Mar 2024 00:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709944384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1oNGOssMz2KjqBMUjLL8d6aSRPRTEO3TW0CwgyV4KGE=;
	b=pw47fLOaL3x8iT0bVj7CY8TkX9fWyLGlotbQet8nMqjKz7BKqsIWWfYg1s+sVEO2R2kdOg
	/RQKBgDgHOTxmSOksBdJf5+ZRzX47bnJgVOz4pz0g0SZ8Oy+AwDAbLV/vb3jMtiEI3FL31
	aGzig+nfhVIVwolERGwru0WhvvkudqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709944384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1oNGOssMz2KjqBMUjLL8d6aSRPRTEO3TW0CwgyV4KGE=;
	b=NmQdVxYBm5N8ASEsf5dsBPtFl+60ndsdShuXShoXIYp1T8t+Okj7XHOZdRZ9l5NNS6ASqQ
	G5nGjmLAWP9XMjCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709944384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1oNGOssMz2KjqBMUjLL8d6aSRPRTEO3TW0CwgyV4KGE=;
	b=pw47fLOaL3x8iT0bVj7CY8TkX9fWyLGlotbQet8nMqjKz7BKqsIWWfYg1s+sVEO2R2kdOg
	/RQKBgDgHOTxmSOksBdJf5+ZRzX47bnJgVOz4pz0g0SZ8Oy+AwDAbLV/vb3jMtiEI3FL31
	aGzig+nfhVIVwolERGwru0WhvvkudqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709944384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1oNGOssMz2KjqBMUjLL8d6aSRPRTEO3TW0CwgyV4KGE=;
	b=NmQdVxYBm5N8ASEsf5dsBPtFl+60ndsdShuXShoXIYp1T8t+Okj7XHOZdRZ9l5NNS6ASqQ
	G5nGjmLAWP9XMjCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4CF9E133DC;
	Sat,  9 Mar 2024 00:33:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qqLHCkCu62X8ZgAAD6G6ig
	(envelope-from <krisman@suse.de>); Sat, 09 Mar 2024 00:33:04 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	xiaobing.li@samsung.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH for-next] io_uring: Fix sqpoll utilization check racing with dying sqpoll
Date: Fri,  8 Mar 2024 19:32:56 -0500
Message-ID: <20240309003256.358-1-krisman@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pw47fLOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NmQdVxYB
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.51 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 TO_DN_SOME(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 MID_CONTAINS_FROM(1.00)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Score: -1.51
X-Rspamd-Queue-Id: 953E91F76B
X-Spam-Flag: NO

Commit 3fcb9d17206e ("io_uring/sqpoll: statistics of the true
utilization of sq threads"), currently in Jens for-next branch, peeks at
io_sq_data->thread to report utilization statistics. But, If
io_uring_show_fdinfo races with sqpoll terminating, even though we hold
the ctx lock, sqd->thread might be NULL and we hit the Oops below.

Note that we could technically just protect the getrusage() call and the
sq total/work time calculations.  But showing some sq
information (pid/cpu) and not other information (utilization) is more
confusing than not reporting anything, IMO.  So let's hide it all if we
happen to race with a dying sqpoll.

This can be triggered consistently in my vm setup running
sqpoll-cancel-hang.t in a loop.

BUG: kernel NULL pointer dereference, address: 00000000000007b0
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 16587 Comm: systemd-coredum Not tainted 6.8.0-rc3-g3fcb9d17206e-dirty #69
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 2/2/2022
RIP: 0010:getrusage+0x21/0x3e0
Code: 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 89 d1 48 89 e5 41 57 41 56 41 55 41 54 49 89 fe 41 52 53 48 89 d3 48 83 ec 30 <4c> 8b a7 b0 07 00 00 48 8d 7a 08 65 48 8b 04 25 28 00 00 00 48 89
RSP: 0018:ffffa166c671bb80 EFLAGS: 00010282
RAX: 00000000000040ca RBX: ffffa166c671bc60 RCX: ffffa166c671bc60
RDX: ffffa166c671bc60 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffa166c671bbe0 R08: ffff9448cc3930c0 R09: 0000000000000000
R10: ffffa166c671bd50 R11: ffffffff9ee89260 R12: 0000000000000000
R13: ffff9448ce099480 R14: 0000000000000000 R15: ffff9448cff5b000
FS:  00007f786e225900(0000) GS:ffff94493bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000007b0 CR3: 000000010d39c000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body+0x1a/0x60
 ? page_fault_oops+0x154/0x440
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_user_addr_fault+0x174/0x7c0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? exc_page_fault+0x63/0x140
 ? asm_exc_page_fault+0x22/0x30
 ? getrusage+0x21/0x3e0
 ? seq_printf+0x4e/0x70
 io_uring_show_fdinfo+0x9db/0xa10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? vsnprintf+0x101/0x4d0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? seq_vprintf+0x34/0x50
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? seq_printf+0x4e/0x70
 ? seq_show+0x16b/0x1d0
 ? __pfx_io_uring_show_fdinfo+0x10/0x10
 seq_show+0x16b/0x1d0
 seq_read_iter+0xd7/0x440
 seq_read+0x102/0x140
 vfs_read+0xae/0x320
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __do_sys_newfstat+0x35/0x60
 ksys_read+0xa5/0xe0
 do_syscall_64+0x50/0x110
 entry_SYSCALL_64_after_hwframe+0x6e/0x76
RIP: 0033:0x7f786ec1db4d
Code: e8 46 e3 01 00 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 80 3d d9 ce 0e 00 00 74 17 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 5b c3 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec
RSP: 002b:00007ffcb361a4b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 000055a4c8fe42f0 RCX: 00007f786ec1db4d
RDX: 0000000000000400 RSI: 000055a4c8fe48a0 RDI: 0000000000000006
RBP: 00007f786ecfb0b0 R08: 00007f786ecfb2a8 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f786ecfaf60
R13: 000055a4c8fe42f0 R14: 0000000000000000 R15: 00007ffcb361a628
 </TASK>
Modules linked in:
CR2: 00000000000007b0
---[ end trace 0000000000000000 ]---
RIP: 0010:getrusage+0x21/0x3e0
Code: 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 89 d1 48 89 e5 41 57 41 56 41 55 41 54 49 89 fe 41 52 53 48 89 d3 48 83 ec 30 <4c> 8b a7 b0 07 00 00 48 8d 7a 08 65 48 8b 04 25 28 00 00 00 48 89
RSP: 0018:ffffa166c671bb80 EFLAGS: 00010282
RAX: 00000000000040ca RBX: ffffa166c671bc60 RCX: ffffa166c671bc60
RDX: ffffa166c671bc60 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffa166c671bbe0 R08: ffff9448cc3930c0 R09: 0000000000000000
R10: ffffa166c671bd50 R11: ffffffff9ee89260 R12: 0000000000000000
R13: ffff9448ce099480 R14: 0000000000000000 R15: ffff9448cff5b000
FS:  00007f786e225900(0000) GS:ffff94493bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000007b0 CR3: 000000010d39c000 CR4: 0000000000750ef0
PKRU: 55555554
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x1ce00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Fixes: 3fcb9d17206e ("io_uring/sqpoll: statistics of the true utilization of sq threads")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/fdinfo.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 37afc5bac279..8d444dd1b0a7 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -147,11 +147,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
 		struct io_sq_data *sq = ctx->sq_data;
 
-		sq_pid = sq->task_pid;
-		sq_cpu = sq->sq_cpu;
-		getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
-		sq_total_time = sq_usage.ru_stime.tv_sec * 1000000 + sq_usage.ru_stime.tv_usec;
-		sq_work_time = sq->work_time;
+		/*
+		 * sq->thread might be NULL if we raced with the sqpoll
+		 * thread termination.
+		 */
+		if (sq->thread) {
+			sq_pid = sq->task_pid;
+			sq_cpu = sq->sq_cpu;
+			getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
+			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
+					 + sq_usage.ru_stime.tv_usec);
+			sq_work_time = sq->work_time;
+		}
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
-- 
2.43.0


