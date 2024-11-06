Return-Path: <io-uring+bounces-4472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B31949BDC93
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 03:26:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EABA1F291BC
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 02:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89771F7579;
	Wed,  6 Nov 2024 02:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRO21QH0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB71F7574;
	Wed,  6 Nov 2024 02:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730859189; cv=none; b=ommP849U5jtpgezomRUJuTw9DknPJ+Um7hXpbmGF/p5ki7Ga1fZ1WAX69rCgaXi/LeDAaGSRJTPWoCP5y7y1E026Rbj5zyRRKvQ5vYGO7UlPui/iGWjPmn2FO9vjM/c58t57suHhfAakP2N1vu2mL1/MW2jafJis30id6MGtOQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730859189; c=relaxed/simple;
	bh=LK8O32ryrR36QBqT2i4Q5Z4wfcG6NDPXs6IKa66b5+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GtAukmG5MTjACCijmnnDbGzVwTClX+9Blnn7Zmc0FXMuwJ8WZk22B8UJqeq3VhysmsrK22SQGe3547LrdnW9cYJW88slVMOF7TD+vhGQ0Xi2Tx+0xzio7iRtPm9uKQF1ZfQwm93TwilkVJ81+kBjXf3nNbkdu+dmlHqbgI1E+Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRO21QH0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93676C4CECF;
	Wed,  6 Nov 2024 02:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730859189;
	bh=LK8O32ryrR36QBqT2i4Q5Z4wfcG6NDPXs6IKa66b5+I=;
	h=From:To:Cc:Subject:Date:From;
	b=rRO21QH0xfFTeP7bYnslEKVBxjjIJoiDbFByTo/ukFj3zOIDYV3VhH2fIUdyV91xn
	 7qyPJhk+lv4XIe5tw/Vq7fMkcppN1H8mWBg1C7TvkCqApLMcONQiIiQnCjwqNL7xFJ
	 VyFqj/dysm8MJpBQd+D4wmZyiRvUMv6yHGCbR+KNqJavpeIKwA2DoJmakBkHBIKu8M
	 wIVoiN5yI5onXOqO4Rv4pooegBe2vbsiCRpYlJcMUNOW99jQsEsjiuHBE2DhVK9hZk
	 WdSjpCYHxEajXQVZb1b1WwE+qgSYi8LerR2v7reVYV0BXBuLkD6gzWG1pkrnDf8+OE
	 +KjuYy6rjY+KQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	axboe@kernel.dk
Cc: Peter Mann <peter.mann@sh.cz>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "io_uring/rw: fix missing NOWAIT check for O_DIRECT start write" failed to apply to v5.10-stable tree
Date: Tue,  5 Nov 2024 21:13:06 -0500
Message-ID: <20241106021306.183371-1-sashal@kernel.org>
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

The patch below does not apply to the v5.10-stable tree.
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





