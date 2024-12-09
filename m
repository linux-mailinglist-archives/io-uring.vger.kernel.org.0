Return-Path: <io-uring+bounces-5368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6AC9EA30A
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:44:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D509282438
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5133119F489;
	Mon,  9 Dec 2024 23:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yhrSH15v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+8eRL7iD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yhrSH15v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+8eRL7iD"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B63223C6B
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787840; cv=none; b=pBS6c55EVwJyDqgg3OuYF/fTlOFi5xzHPD/YsfqkVG1E7L7TADKhBTIkzAKT8ePF1VtK99vu6Q07Be/pCEuwD4a8DbQS+XrPbks417FK6SNOqrHjV7XXbD4saeatAQcOtOIMhbCan+Gi2i6FA/Mit9aGPcelRqv2Wj1zVWRJRZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787840; c=relaxed/simple;
	bh=c6r6SgHO2yPFJ8di4Ia0OkS7OPY0CJmNb/LdKyabWBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfHJamF4wfogVKb55N5PxtfZd0cW35QbybdeHudvgPUa0XgrDWdgjkFLA44jWzrxNPunRC371rna1tXptG4EwJfwxdPCeD8XalqaFkA63u3kIms7OJvX3aHdUwfg8zSTpqNRgq0LPoeM3DKFpWqtIWRd5LugkEFv5nbE8aonjPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yhrSH15v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+8eRL7iD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yhrSH15v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+8eRL7iD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 913C91F44F;
	Mon,  9 Dec 2024 23:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4vKWu3lX6cgt031RV91VF6tDX+5ssZxtk3ymo9j/qy8=;
	b=yhrSH15vSyS4BNQ79i5C7R4YWEF7dTHrBOCnLeXrrsDW/hmPs0YkMme6JE7BmTCKHNKNvu
	JG4HDZyyNB2AzP4mdtP8Zl6KFdBECOslprsj5fTncY+ma/BkzPqxNHnGOReCuq+ugoaa5Q
	jahT+exFJBHFwpvrMLYhuTfdx4mGHW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4vKWu3lX6cgt031RV91VF6tDX+5ssZxtk3ymo9j/qy8=;
	b=+8eRL7iDKaBOHeT5KXwkD9lipFppK0L2Kwja/KUpAFebMHWGRwQ8DpQ4btlYtHuhNcF2G2
	aRtEdAH94jYJ6sAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yhrSH15v;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+8eRL7iD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4vKWu3lX6cgt031RV91VF6tDX+5ssZxtk3ymo9j/qy8=;
	b=yhrSH15vSyS4BNQ79i5C7R4YWEF7dTHrBOCnLeXrrsDW/hmPs0YkMme6JE7BmTCKHNKNvu
	JG4HDZyyNB2AzP4mdtP8Zl6KFdBECOslprsj5fTncY+ma/BkzPqxNHnGOReCuq+ugoaa5Q
	jahT+exFJBHFwpvrMLYhuTfdx4mGHW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4vKWu3lX6cgt031RV91VF6tDX+5ssZxtk3ymo9j/qy8=;
	b=+8eRL7iDKaBOHeT5KXwkD9lipFppK0L2Kwja/KUpAFebMHWGRwQ8DpQ4btlYtHuhNcF2G2
	aRtEdAH94jYJ6sAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 405F7138A5;
	Mon,  9 Dec 2024 23:43:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Lj96A7yAV2cgHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:56 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 9/9] io_uring: Introduce IORING_OP_EXEC command
Date: Mon,  9 Dec 2024 18:43:11 -0500
Message-ID: <20241209234316.4132786-10-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>
References: <20241209234316.4132786-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 913C91F44F
X-Spam-Level: 
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -1.51
X-Spam-Flag: NO

From: Josh Triplett <josh@joshtriplett.org>

This command executes the equivalent of an execveat(2) in a previously
spawned io_uring context, causing the execution to return to a new
program indicated by the SQE.

As an io_uring command, it is special in a few ways, requiring some
quirks. First, it can only be executed from the spawned context linked
after the IORING_OP_CLONE command; In addition, the first successful
IORING_OP_EXEC command will terminate the link chain, causing
further operations to fail with -ECANCELED.

There are a few reason for the first limitation: First, it wouldn't make
much sense to execute IORING_OP_EXEC in an io-wq, as it would simply
mean "stealing" the worker thread from io_uring; It would also be
questionable to execute inline or in a task work, as it would terminate
the execution of the ring.  Another technical reason is that we'd
immediately deadlock (fixable), because we'd need to complete the
command and release the reference after returning from the execve, but
the context has already been invalidated by terminating the process.
All in all, considering io_uring's purpose to provide an asynchronous
interface, I'd (Gabriel) like to focus on the simple use-case first,
limiting it to the cloned context for now.

The second limitation is obvious.  We reject further operations on the
link after a successful exec because that is the boundary of the new
program.

There is a very interesting usecase that Josh mentioned for this
feature.  One can issue a series of hardlinked IORING_OP_EXEC using the
different $PATH components to search for the binary and try them in
sequence without returning to userspace.  This is exemplified in
the liburing testcase accompanying the patchset.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Co-developed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/opdef.c              |  9 ++++++
 io_uring/spawn.c              | 57 ++++++++++++++++++++++++++++++++++-
 io_uring/spawn.h              |  3 ++
 4 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 82d8dae49645..1116ff8b5018 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -73,6 +73,7 @@ struct io_uring_sqe {
 		__u32		futex_flags;
 		__u32		install_fd_flags;
 		__u32		nop_flags;
+		__u32		execve_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -279,6 +280,7 @@ enum io_uring_op {
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
 	IORING_OP_CLONE,
+	IORING_OP_EXEC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 1bab2e517e55..8cca077641d5 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -521,6 +521,12 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_clone_prep,
 		.issue			= io_clone,
 	},
+	[IORING_OP_EXEC] = {
+		.audit_skip		= 1,
+		.ignore_creds		= 1,
+		.prep			= io_exec_prep,
+		.issue			= io_exec,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -753,6 +759,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_CLONE] = {
 		.name			= "CLONE",
 	},
+	[IORING_OP_EXEC] = {
+		.name			= "EXEC",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/spawn.c b/io_uring/spawn.c
index 59d6ccf96f45..d6d649f78906 100644
--- a/io_uring/spawn.c
+++ b/io_uring/spawn.c
@@ -18,6 +18,16 @@ struct io_clone {
 	struct io_kiocb *link;
 };
 
+struct io_exec {
+	struct file *file_unused;
+	const char __user *filename;
+	const char __user *const __user *argv;
+	const char __user *const __user *envp;
+
+	int dfd;
+	u32 flags;
+};
+
 static void fail_link(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt;
@@ -38,6 +48,7 @@ static int io_uring_spawn_task(void *data)
 	struct io_clone *c = io_kiocb_to_cmd(head, struct io_clone);
 	struct io_ring_ctx *ctx = head->ctx;
 	struct io_kiocb *req, *next;
+	bool return_to_user = false;
 	int err;
 
 	set_task_comm(current, "iou-spawn");
@@ -67,6 +78,15 @@ static int io_uring_spawn_task(void *data)
 				fail_link(next);
 				break;
 			}
+		} else if (req->opcode == IORING_OP_EXEC) {
+			/*
+			 * Don't execute anything after the first
+			 * successful IORING_OP_EXEC.  Cancel the rest
+			 * of the link and allow userspace to return
+			 */
+			fail_link(next);
+			return_to_user = true;
+			break;
 		}
 	}
 
@@ -75,7 +95,9 @@ static int io_uring_spawn_task(void *data)
 
 	mutex_unlock(&ctx->uring_lock);
 
-	force_exit_sig(SIGKILL);
+	/* If there wasn't a successful exec, terminate the thread. */
+	if (!return_to_user)
+		force_exit_sig(SIGKILL);
 	return 0;
 }
 
@@ -138,3 +160,36 @@ int io_clone(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 
 }
+
+int io_exec_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_exec *e = io_kiocb_to_cmd(req, typeof(*e));
+
+	if (unlikely(sqe->buf_index || sqe->len || sqe->file_index))
+		return -EINVAL;
+
+	e->dfd = READ_ONCE(sqe->fd);
+	e->filename = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	e->argv = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	e->envp = u64_to_user_ptr(READ_ONCE(sqe->addr3));
+	e->flags = READ_ONCE(sqe->execve_flags);
+	return 0;
+}
+
+int io_exec(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_exec *e = io_kiocb_to_cmd(req, typeof(*e));
+	int ret;
+
+	if (!(issue_flags & IO_URING_F_SPAWN))
+		return -EINVAL;
+
+	ret = do_execveat(e->dfd, getname(e->filename),
+			  e->argv, e->envp, e->flags);
+	if (ret < 0) {
+		req_set_fail(req);
+		io_req_set_res(req, ret, 0);
+	}
+	return IOU_OK;
+
+}
diff --git a/io_uring/spawn.h b/io_uring/spawn.h
index 9b7ddb776d1e..93d9f0ae378c 100644
--- a/io_uring/spawn.h
+++ b/io_uring/spawn.h
@@ -8,3 +8,6 @@
 
 int io_clone_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_clone(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_exec_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_exec(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.47.0


