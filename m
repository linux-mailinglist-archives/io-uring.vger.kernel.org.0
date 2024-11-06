Return-Path: <io-uring+bounces-4471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C189BDC6D
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 03:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61C1B1F269C0
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 02:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C4F1DF982;
	Wed,  6 Nov 2024 02:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOkMC0BF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF76B1DF97B;
	Wed,  6 Nov 2024 02:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730859137; cv=none; b=roI79DguZzSEaErRDk8x+JTxtCnKqo225hIjiwsnud5cujIIDNN9FVqcQu3RsAlHTvoeI29t/XEGYm9y4YRWqqsC0vzgvRuBT6Dv7295AoejHYlsoah97S9qsmSX/0uFQyx6jtaJnA608OBWAhuuobiRgoYwzU0EnstA4kiU59Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730859137; c=relaxed/simple;
	bh=W651HOHjGzMDsCgtNU4gYW/D1n71pQWGsOS7ffSj49I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a6br6Fspc+sZS/vUQd0vI/RKM5McOPwK3lr9NcNQDzf6GiNlFwO4IGWMUbRmdc/BfF6gxVRqEH3aie1++2zV3+YBer5eqEgpnjQHE2xfnyWXqZaac4Mfrm7/A37jolFAQmIqDNbYlMfjeN4Y3UiWXMb5asPNqw7yVI0DIg8SscI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOkMC0BF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082B7C4CECF;
	Wed,  6 Nov 2024 02:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730859136;
	bh=W651HOHjGzMDsCgtNU4gYW/D1n71pQWGsOS7ffSj49I=;
	h=From:To:Cc:Subject:Date:From;
	b=KOkMC0BFa78Sq+EZxLDfcW34TmRYjowgDmeAL0kLIC5zwesvehau0FzOxfRolgeXG
	 decXlwavcVeTmPWsnwnMBzPswFNbkUJ4lCfqQLHAkkcWmgS+cFnC2l54xRV7Ju8VZy
	 7sj+nEGJe+IqUv+8WgBQ4MFaz9IPpVNyJIydTqB6sULi1xoJOpyU5bapmK+VqBYp65
	 uRPVMzrCLe3eMtwx1HqS51H21OValeRLSrOAKu038xT9m1bdQVGdHZM9w1PoYSwY2Z
	 L6eEDROrv5tIUCGSHF+zdxEeaIr2PLdzTu6YTHHM38acMj5nAQ1yglGWoyCriDItLx
	 8xmYHaA2V8Jgw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	axboe@kernel.dk
Cc: Peter Mann <peter.mann@sh.cz>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "io_uring/rw: fix missing NOWAIT check for O_DIRECT start write" failed to apply to v5.15-stable tree
Date: Tue,  5 Nov 2024 21:12:14 -0500
Message-ID: <20241106021214.182779-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the v5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 1d60d74e852647255bd8e76f5a22dc42531e4389 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 31 Oct 2024 08:05:44 -0600
Subject: [PATCH] io_uring/rw: fix missing NOWAIT check for O_DIRECT start
 write

When io_uring starts a write, it'll call kiocb_start_write() to bump the
super block rwsem, preventing any freezes from happening while that
write is in-flight. The freeze side will grab that rwsem for writing,
excluding any new writers from happening and waiting for existing writes
to finish. But io_uring unconditionally uses kiocb_start_write(), which
will block if someone is currently attempting to freeze the mount point.
This causes a deadlock where freeze is waiting for previous writes to
complete, but the previous writes cannot complete, as the task that is
supposed to complete them is blocked waiting on starting a new write.
This results in the following stuck trace showing that dependency with
the write blocked starting a new write:

task:fio             state:D stack:0     pid:886   tgid:886   ppid:876
Call trace:
 __switch_to+0x1d8/0x348
 __schedule+0x8e8/0x2248
 schedule+0x110/0x3f0
 percpu_rwsem_wait+0x1e8/0x3f8
 __percpu_down_read+0xe8/0x500
 io_write+0xbb8/0xff8
 io_issue_sqe+0x10c/0x1020
 io_submit_sqes+0x614/0x2110
 __arm64_sys_io_uring_enter+0x524/0x1038
 invoke_syscall+0x74/0x268
 el0_svc_common.constprop.0+0x160/0x238
 do_el0_svc+0x44/0x60
 el0_svc+0x44/0xb0
 el0t_64_sync_handler+0x118/0x128
 el0t_64_sync+0x168/0x170
INFO: task fsfreeze:7364 blocked for more than 15 seconds.
      Not tainted 6.12.0-rc5-00063-g76aaf945701c #7963

with the attempting freezer stuck trying to grab the rwsem:

task:fsfreeze        state:D stack:0     pid:7364  tgid:7364  ppid:995
Call trace:
 __switch_to+0x1d8/0x348
 __schedule+0x8e8/0x2248
 schedule+0x110/0x3f0
 percpu_down_write+0x2b0/0x680
 freeze_super+0x248/0x8a8
 do_vfs_ioctl+0x149c/0x1b18
 __arm64_sys_ioctl+0xd0/0x1a0
 invoke_syscall+0x74/0x268
 el0_svc_common.constprop.0+0x160/0x238
 do_el0_svc+0x44/0x60
 el0_svc+0x44/0xb0
 el0t_64_sync_handler+0x118/0x128
 el0t_64_sync+0x168/0x170

Fix this by having the io_uring side honor IOCB_NOWAIT, and only attempt a
blocking grab of the super block rwsem if it isn't set. For normal issue
where IOCB_NOWAIT would always be set, this returns -EAGAIN which will
have io_uring core issue a blocking attempt of the write. That will in
turn also get completions run, ensuring forward progress.

Since freezing requires CAP_SYS_ADMIN in the first place, this isn't
something that can be triggered by a regular user.

Cc: stable@vger.kernel.org # 5.10+
Reported-by: Peter Mann <peter.mann@sh.cz>
Link: https://lore.kernel.org/io-uring/38c94aec-81c9-4f62-b44e-1d87f5597644@sh.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 354c4e175654c..155938f100931 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1014,6 +1014,25 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)
+{
+	struct inode *inode;
+	bool ret;
+
+	if (!(req->flags & REQ_F_ISREG))
+		return true;
+	if (!(kiocb->ki_flags & IOCB_NOWAIT)) {
+		kiocb_start_write(kiocb);
+		return true;
+	}
+
+	inode = file_inode(kiocb->ki_filp);
+	ret = sb_start_write_trylock(inode->i_sb);
+	if (ret)
+		__sb_writers_release(inode->i_sb, SB_FREEZE_WRITE);
+	return ret;
+}
+
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -1051,8 +1070,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	if (req->flags & REQ_F_ISREG)
-		kiocb_start_write(kiocb);
+	if (unlikely(!io_kiocb_start_write(req, kiocb)))
+		return -EAGAIN;
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (likely(req->file->f_op->write_iter))
-- 
2.43.0





