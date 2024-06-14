Return-Path: <io-uring+bounces-2214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6FD909058
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E8961C23F4D
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 16:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76811ABCC6;
	Fri, 14 Jun 2024 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WT59sI9z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gow4ef/x";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WT59sI9z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gow4ef/x"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09321AB90E;
	Fri, 14 Jun 2024 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382658; cv=none; b=jUPxLJSCVeFmUqYtGezgwT/eLFPRAX4DHu4vjoNO/c+FLGfJzUPxgVO36VLZjr9ZRyTU5KQDssAdT2gM5Zz3G6hkYgfA2j8WnTFxFxkLytF9NI+h7WOPCbKwnFhJNFMs5FaMjv9ILQOs9S2Qjvv5SNwQEl+7grFTLjOydJ/qtrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382658; c=relaxed/simple;
	bh=Cq1BPkY9jBEWEMd1nBIm2xXsuRH7ylDX1Amwb2/km9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfJtg+aBBPCBDrjIbtyVMDdhua1tBqBwnhGbUpUQSVQicBTjLHjPjvIXXu3HXNUplnybTKLGaAkhgbJ3DJ3UxdEyiq+Qz7kyaOr5e50R+WkUfHjyOynTr/f5sP0XjFRxaPMtWCRmd2IY3WR/fbpGQDD+eDUX5NLJiVSnnovihgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WT59sI9z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gow4ef/x; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WT59sI9z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gow4ef/x; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1236D206A5;
	Fri, 14 Jun 2024 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718382655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkvWK7HMvwX+vbndomN45roZNAsAKWXfV5+RfpP+YrU=;
	b=WT59sI9z8soI34bekZZ7f1XXgchQF/pIOZYYqUkwWOkv47TuWlcY6oYO89l2pj/dZnYSP0
	VXvJN8NegplQ0sA/wKwku7x9JLHyG/NWRP/YZETu3J1/gSAhub7aBIwbLSAbRjDCyPplqM
	ZY1qKr5XJ+Hnc+UrpWfladkQz7DBbQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718382655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkvWK7HMvwX+vbndomN45roZNAsAKWXfV5+RfpP+YrU=;
	b=gow4ef/x3PiwSmvw8Tu2Hqro3736QiTzRZY2zxIrMJmSHz/01mciudOyfh2zPlu/jF4Crd
	F8rdg40ba1OaxOAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718382655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkvWK7HMvwX+vbndomN45roZNAsAKWXfV5+RfpP+YrU=;
	b=WT59sI9z8soI34bekZZ7f1XXgchQF/pIOZYYqUkwWOkv47TuWlcY6oYO89l2pj/dZnYSP0
	VXvJN8NegplQ0sA/wKwku7x9JLHyG/NWRP/YZETu3J1/gSAhub7aBIwbLSAbRjDCyPplqM
	ZY1qKr5XJ+Hnc+UrpWfladkQz7DBbQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718382655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkvWK7HMvwX+vbndomN45roZNAsAKWXfV5+RfpP+YrU=;
	b=gow4ef/x3PiwSmvw8Tu2Hqro3736QiTzRZY2zxIrMJmSHz/01mciudOyfh2zPlu/jF4Crd
	F8rdg40ba1OaxOAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C94AC13AAF;
	Fri, 14 Jun 2024 16:30:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VpiHKj5wbGbGcwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 14 Jun 2024 16:30:54 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 3/4] io_uring: Introduce IORING_OP_BIND
Date: Fri, 14 Jun 2024 12:30:46 -0400
Message-ID: <20240614163047.31581-3-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240614163047.31581-1-krisman@suse.de>
References: <20240614163047.31581-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email];
	RCVD_TLS_ALL(0.00)[]

IORING_OP_BIND provides the semantic of bind(2) via io_uring.  While
this is an essentially synchronous system call, the main point is to
enable a network path to execute fully with io_uring registered and
descriptorless files.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
changes since v1:
- drop explocit error handling for move_addr_to_kernel (jens)
- Remove empty line ahead of return;
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/net.c                | 36 +++++++++++++++++++++++++++++++++++
 io_uring/net.h                |  3 +++
 io_uring/opdef.c              | 13 +++++++++++++
 4 files changed, 53 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 994bf7af0efe..4ef153d95c87 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -257,6 +257,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAITV,
 	IORING_OP_FIXED_FD_INSTALL,
 	IORING_OP_FTRUNCATE,
+	IORING_OP_BIND,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 0a48596429d9..8cbc29aff15c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -51,6 +51,11 @@ struct io_connect {
 	bool				seen_econnaborted;
 };
 
+struct io_bind {
+	struct file			*file;
+	int				addr_len;
+};
+
 struct io_sr_msg {
 	struct file			*file;
 	union {
@@ -1715,6 +1720,37 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
+	struct sockaddr __user *uaddr;
+	struct io_async_msghdr *io;
+
+	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
+		return -EINVAL;
+
+	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	bind->addr_len =  READ_ONCE(sqe->addr2);
+
+	io = io_msg_alloc_async(req);
+	if (unlikely(!io))
+		return -ENOMEM;
+	return move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
+}
+
+int io_bind(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
+	struct io_async_msghdr *io = req->async_data;
+	int ret;
+
+	ret = __sys_bind_socket(sock_from_file(req->file),  &io->addr, bind->addr_len);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return 0;
+}
+
 void io_netmsg_cache_free(const void *entry)
 {
 	struct io_async_msghdr *kmsg = (struct io_async_msghdr *) entry;
diff --git a/io_uring/net.h b/io_uring/net.h
index 0eb1c1920fc9..49f9a7bc1113 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -49,6 +49,9 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags);
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_send_zc_cleanup(struct io_kiocb *req);
 
+int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_bind(struct io_kiocb *req, unsigned int issue_flags);
+
 void io_netmsg_cache_free(const void *entry);
 #else
 static inline void io_netmsg_cache_free(const void *entry)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 2de5cca9504e..19ee9445f024 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -495,6 +495,16 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_ftruncate_prep,
 		.issue			= io_ftruncate,
 	},
+	[IORING_OP_BIND] = {
+#if defined(CONFIG_NET)
+		.needs_file		= 1,
+		.prep			= io_bind_prep,
+		.issue			= io_bind,
+		.async_size		= sizeof(struct io_async_msghdr),
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -711,6 +721,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FTRUNCATE] = {
 		.name			= "FTRUNCATE",
 	},
+	[IORING_OP_BIND] = {
+		.name			= "BIND",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.45.2


