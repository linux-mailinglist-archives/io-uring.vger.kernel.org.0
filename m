Return-Path: <io-uring+bounces-5366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B02AD9EA308
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 825AC1881311
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F0F224899;
	Mon,  9 Dec 2024 23:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WC5PNoyc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ggxi3pgX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WC5PNoyc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ggxi3pgX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8899A2248A3
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787832; cv=none; b=XR2vwBnz03EzZbIC28B9myLPJ4espsPNa+K9JC9EJ4aVgezfuXqgqtDMMFthR1Hv0BuxxMWeS4f5RCxJ/9yy2cfsmBtuBBOrl9e8efqBxK0qf98x/kct6wri8LN57sg2ErIcnxNu+X5EVTouq+YCjB4GjIc9PQkjXElMQXXf5Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787832; c=relaxed/simple;
	bh=loAJJs7OumA/oMAvExcGKHWEbIpOm898MnZK9JnOI9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJInnLfJFRhfDpSeulDVh8D+0pz2DHPimlCQXjvIZi8iu+WLt+PaRu3+haZyttbctxlnh72YQujxxuSOPXWOHrkPGqFM62E2qWkS6+EWZMPpBVUGQNEbPOuUPhCepuCnTX7pZ4mATPcOnzUFKA6XvkAxS5WrLcYk2J5lZUHP2zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WC5PNoyc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ggxi3pgX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WC5PNoyc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ggxi3pgX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB38321169;
	Mon,  9 Dec 2024 23:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cvMPdj61XsjV2PYeWyD9EAQyCRDLmYOY/LtbA4cB5o=;
	b=WC5PNoyc4cSWz011qHysQ3wgrJw99tvQU0ysVlHmP1zATLGK4JJsknrS2BjV+WZmJhee1R
	M3ZRxjTO0zOt+niyvmxJgg398ZZOGBQ+zyoB/gtULXP6GCkSLDjYYeDFnUufhzyuk28Q9z
	XSYTHIAISDKhPLnxHm7O6fj+ATiXmP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cvMPdj61XsjV2PYeWyD9EAQyCRDLmYOY/LtbA4cB5o=;
	b=ggxi3pgXFECOYdKwR9CXe/tcVecO7uc84yO4QDROZf83mToKVyhs4HUCBvF6XKM5YtSgJu
	yLNTLxaWVbiBA+CQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cvMPdj61XsjV2PYeWyD9EAQyCRDLmYOY/LtbA4cB5o=;
	b=WC5PNoyc4cSWz011qHysQ3wgrJw99tvQU0ysVlHmP1zATLGK4JJsknrS2BjV+WZmJhee1R
	M3ZRxjTO0zOt+niyvmxJgg398ZZOGBQ+zyoB/gtULXP6GCkSLDjYYeDFnUufhzyuk28Q9z
	XSYTHIAISDKhPLnxHm7O6fj+ATiXmP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cvMPdj61XsjV2PYeWyD9EAQyCRDLmYOY/LtbA4cB5o=;
	b=ggxi3pgXFECOYdKwR9CXe/tcVecO7uc84yO4QDROZf83mToKVyhs4HUCBvF6XKM5YtSgJu
	yLNTLxaWVbiBA+CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FC6C138A5;
	Mon,  9 Dec 2024 23:43:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4TUIF7SAV2cUHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:48 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 7/9] io_uring: Introduce IORING_OP_CLONE
Date: Mon,  9 Dec 2024 18:43:09 -0500
Message-ID: <20241209234316.4132786-8-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>
References: <20241209234316.4132786-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-1.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Score: -1.80
X-Spam-Flag: NO

From: Josh Triplett <josh@joshtriplett.org>

This command spawns a short lived asynchronous context to execute
following linked operations.  Once the link is completed, the task
terminates.  This is specially useful to create new processes, by
linking an IORING_OP_EXEC at the end of the chain. In this case, the
task doesn't terminate, but returns to userspace, starting the new
process.

This is different from the existing io workqueues in a few ways: First,
it is completely separated from the io-wq code, and the task cannot be
reused by a future link; Second, the task doesn't share the FDT, and
other process structures with the rest of io_uring (except for the
memory map); Finally, because of the limited context, it doesn't support
executing requests asynchronously and requeing them. Every request must
complete at ->issue time, or fail.  It also doesn't support task_work
execution, for a similar reason.  The goal of this design allowing the
user to close file descriptors, release locks and do other cleanups
right before switching to a new process.

A big pitfall here, in my (Gabriel) opinion, is how this duplicates the
logic of io_uring linked request dispatching.  I'd suggest I merge this
into the io-wq code, as a special case of workqueue. But I'd like to get
feedback on this idea from the maintainers before moving further with the
implementation.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Co-developed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/Makefile             |   2 +-
 io_uring/io_uring.c           |   3 +-
 io_uring/io_uring.h           |   2 +
 io_uring/opdef.c              |   9 +++
 io_uring/spawn.c              | 140 ++++++++++++++++++++++++++++++++++
 io_uring/spawn.h              |  10 +++
 7 files changed, 165 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/spawn.c
 create mode 100644 io_uring/spawn.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 38f0d6b10eaf..82d8dae49645 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -278,6 +278,7 @@ enum io_uring_op {
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
+	IORING_OP_CLONE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 53167bef37d7..06ad15c07c57 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					sqpoll.o xattr.o nop.o fs.o splice.o \
 					sync.o msg_ring.o advise.o openclose.o \
 					epoll.o statx.o timeout.o fdinfo.o \
-					cancel.o waitid.o register.o \
+					cancel.o waitid.o register.o spawn.o \
 					truncate.o memmap.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0fd8709401fc..b82ea1cc393f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -97,6 +97,7 @@
 #include "uring_cmd.h"
 #include "msg_ring.h"
 #include "memmap.h"
+#include "spawn.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -1706,7 +1707,7 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 	return !!req->file;
 }
 
-static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
+int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	const struct cred *creds = NULL;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4dd051d29cb0..302c8f92b812 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -497,4 +497,6 @@ static inline bool io_has_work(struct io_ring_ctx *ctx)
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
 	       io_local_work_pending(ctx);
 }
+
+int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags);
 #endif
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3de75eca1c92..1bab2e517e55 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -36,6 +36,7 @@
 #include "waitid.h"
 #include "futex.h"
 #include "truncate.h"
+#include "spawn.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -515,6 +516,11 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_CLONE] = {
+		.audit_skip		= 1,
+		.prep			= io_clone_prep,
+		.issue			= io_clone,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -744,6 +750,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_LISTEN] = {
 		.name			= "LISTEN",
 	},
+	[IORING_OP_CLONE] = {
+		.name			= "CLONE",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/spawn.c b/io_uring/spawn.c
new file mode 100644
index 000000000000..1cd069bb6f59
--- /dev/null
+++ b/io_uring/spawn.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Spawning a linked series of operations onto a dedicated task.
+ *
+ * Copyright (C) 2022 Josh Triplett
+ */
+
+#include <linux/binfmts.h>
+#include <linux/nospec.h>
+#include <linux/syscalls.h>
+
+#include "io_uring.h"
+#include "rsrc.h"
+#include "spawn.h"
+
+struct io_clone {
+	struct file *file_unused;
+	struct io_kiocb *link;
+};
+
+static void fail_link(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt;
+
+	while (req) {
+		req_fail_link_node(req, -ECANCELED);
+		io_req_complete_defer(req);
+
+		nxt = req->link;
+		req->link = NULL;
+		req = nxt;
+	}
+}
+
+static int io_uring_spawn_task(void *data)
+{
+	struct io_kiocb *head = data;
+	struct io_clone *c = io_kiocb_to_cmd(head, struct io_clone);
+	struct io_ring_ctx *ctx = head->ctx;
+	struct io_kiocb *req, *next;
+	int err;
+
+	set_task_comm(current, "iou-spawn");
+
+	mutex_lock(&ctx->uring_lock);
+
+	for (req = c->link; req; req = next) {
+		int hardlink = req->flags & REQ_F_HARDLINK;
+
+		next = req->link;
+		req->link = NULL;
+		req->flags &= ~(REQ_F_HARDLINK | REQ_F_LINK);
+
+		if (!(req->flags & REQ_F_FAIL)) {
+			err = io_issue_sqe(req, IO_URING_F_COMPLETE_DEFER);
+			/*
+			 * We can't requeue a request from the spawn
+			 * context.  Fail the whole chain.
+			 */
+			if (err) {
+				req_fail_link_node(req, -ECANCELED);
+				io_req_complete_defer(req);
+			}
+		}
+		if (req->flags & REQ_F_FAIL) {
+			if (!hardlink) {
+				fail_link(next);
+				break;
+			}
+		}
+	}
+
+	io_submit_flush_completions(ctx);
+	percpu_ref_put(&ctx->refs);
+
+	mutex_unlock(&ctx->uring_lock);
+
+	force_exit_sig(SIGKILL);
+	return 0;
+}
+
+int io_clone_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	if (unlikely(sqe->fd || sqe->ioprio || sqe->addr2 || sqe->addr
+		     || sqe->len || sqe->rw_flags || sqe->buf_index
+		     || sqe->optlen || sqe->addr3))
+		return -EINVAL;
+
+	if (unlikely(!(req->flags & (REQ_F_HARDLINK|REQ_F_LINK))))
+		return -EINVAL;
+
+	if (unlikely(req->ctx->submit_state.link.head))
+		return -EINVAL;
+
+	return 0;
+}
+
+int io_clone(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_clone *c = io_kiocb_to_cmd(req, struct io_clone);
+	struct task_struct *tsk;
+
+	/* It is possible that we don't have any linked requests, depite
+	 * checking during ->prep().  It would be harmless to continue,
+	 * but we don't need even to create the worker thread in this
+	 * case.
+	 */
+	if (!req->link)
+		return IOU_OK;
+
+	/*
+	 * Prevent the context from going away before the spawned task
+	 * has had a chance to execute.  Dropped by io_uring_spawn_task.
+	 */
+	percpu_ref_get(&req->ctx->refs);
+
+	tsk = create_io_uring_spawn_task(io_uring_spawn_task, req);
+	if (IS_ERR(tsk)) {
+		percpu_ref_put(&req->ctx->refs);
+
+		req_set_fail(req);
+		io_req_set_res(req, PTR_ERR(tsk), 0);
+		return PTR_ERR(tsk);
+	}
+
+	/*
+	 * Steal the link from the io_uring dispatcher to have them
+	 * submitted through the new thread.  Note we can no longer fail
+	 * the clone, so the spawned task is responsible for completing
+	 * these requests.
+	 */
+	c->link = req->link;
+	req->flags &= ~(REQ_F_HARDLINK | REQ_F_LINK);
+	req->link = NULL;
+
+	wake_up_new_task(tsk);
+
+	return IOU_OK;
+
+}
diff --git a/io_uring/spawn.h b/io_uring/spawn.h
new file mode 100644
index 000000000000..9b7ddb776d1e
--- /dev/null
+++ b/io_uring/spawn.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/*
+ * Spawning a linked series of operations onto a dedicated task.
+ *
+ * Copyright © 2022 Josh Triplett
+ */
+
+int io_clone_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_clone(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.47.0


