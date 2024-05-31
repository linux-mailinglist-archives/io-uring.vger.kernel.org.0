Return-Path: <io-uring+bounces-2042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B124A8D6B5A
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 656FF282597
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 21:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07CA823CC;
	Fri, 31 May 2024 21:13:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A407D071;
	Fri, 31 May 2024 21:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717190017; cv=none; b=Gt9MeZeTY3pq3vGMrqWw6gt0KnJhEvvUttA5GV7BWryWbLNk3trxOAlG3TbSBBipZQJba8I6TlwNBVJdr3OOmgak6sLI1cEZIg4ObmS25Ud14qUKPbKY+e89ncPyDYUIBpkcjmSbYTASAYvmO5gFxbSvVYnxwGQzeLf3z34A22A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717190017; c=relaxed/simple;
	bh=CWaMZB7BN5Ymns9y/n+BaWkb9y3oWfZMo5A7x+tVjyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+z0Jo5KILSPu5/Q43C/bdhaBn1BfqrIsUDjLlutTyytdOnLp6fmr66hfG3RuBjewe6OiIPrSODYyiMzVCQDxExWFI7J1PyWziLzzzJ7BlqLh7h0qxjEtmDIb5HaXLpV7thpIE9GmDRwQiIAXLZoj55UexwBE1l1A+CIStkOK3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 568C21F393;
	Fri, 31 May 2024 21:13:34 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BC0C137C3;
	Fri, 31 May 2024 21:13:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YGx5AH49WmbAagAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 31 May 2024 21:13:34 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 4/5] io_uring: Introduce IORING_OP_BIND
Date: Fri, 31 May 2024 17:12:10 -0400
Message-ID: <20240531211211.12628-5-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240531211211.12628-1-krisman@suse.de>
References: <20240531211211.12628-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 568C21F393
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

IORING_OP_BIND provides the semantic of bind(2) via io_uring.  While
this is an essentially synchronous system call, the main point is to
enable a network path to execute fully with io_uring registered and
descriptorless files.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/net.c                | 42 +++++++++++++++++++++++++++++++++++
 io_uring/net.h                |  3 +++
 io_uring/opdef.c              | 13 +++++++++++
 4 files changed, 59 insertions(+)

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
index c3377e70aeeb..1ac193f92ff6 100644
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
@@ -1719,6 +1724,43 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
+	struct sockaddr __user *uaddr;
+	struct io_async_msghdr *io;
+	int ret;
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
+
+	ret = move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
+	if (ret)
+		io_req_msg_cleanup(req, 0);
+	return ret;
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
+
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
2.44.0


