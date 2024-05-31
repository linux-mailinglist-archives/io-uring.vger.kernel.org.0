Return-Path: <io-uring+bounces-2043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 094F58D6B5C
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF5031F2AD5D
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 21:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079E98248C;
	Fri, 31 May 2024 21:13:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C8F823AC;
	Fri, 31 May 2024 21:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717190018; cv=none; b=tFjQJpS9vrebmFi5B081E4kkt2IcqhIxkOISPAmjMToq/m08ZHmkt+/zoLNxgsYwG2Dp/yM8zmpXk22dxx26armhEptC92GEj7wM2wpA0Toiz5pzdnsdkJ9zRxxYMlYY5t1eNlM9Fan4/shInNTnc+/aQZAXVs1AdxpGgUyBPhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717190018; c=relaxed/simple;
	bh=iYC2RM9s4UFMlkKNvkzOEVzmmoU8jDCrIh59wCBa/vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOzzDJtoui+lM0j27bWfgqZ9+l/eWEoIXvh6LL4ezpXSSrkK4dOj1POrTOqidhowxhIvbHr8KxVfmFEv+ZlrvTFXW5p7XBuE3Pi41AhKXXExbgxyaReiFrwL1PEoIpBx8q+y4t2pdv7E9homZmGdkjBVAuAlaJCcRRcqZsh8qXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E4BB11F396;
	Fri, 31 May 2024 21:13:35 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB695137C3;
	Fri, 31 May 2024 21:13:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L/S6I389WmbEagAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 31 May 2024 21:13:35 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 5/5] io_uring: Introduce IORING_OP_LISTEN
Date: Fri, 31 May 2024 17:12:11 -0400
Message-ID: <20240531211211.12628-6-krisman@suse.de>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: E4BB11F396

IORING_OP_LISTEN provides the semantic of listen(2) via io_uring.  While
this is an essentially synchronous system call, the main point is to
enable a network path to execute fully with io_uring registered and
descriptorless files.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/net.c                | 30 ++++++++++++++++++++++++++++++
 io_uring/net.h                |  3 +++
 io_uring/opdef.c              | 13 +++++++++++++
 4 files changed, 47 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4ef153d95c87..2aaf7ee256ac 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -258,6 +258,7 @@ enum io_uring_op {
 	IORING_OP_FIXED_FD_INSTALL,
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
+	IORING_OP_LISTEN,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 1ac193f92ff6..e39754b5278f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -56,6 +56,11 @@ struct io_bind {
 	int				addr_len;
 };
 
+struct io_listen {
+	struct file			*file;
+	int				backlog;
+};
+
 struct io_sr_msg {
 	struct file			*file;
 	union {
@@ -1761,6 +1766,31 @@ int io_bind(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+int io_listen_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_listen *listen = io_kiocb_to_cmd(req, struct io_listen);
+
+	if (sqe->addr || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in || sqe->addr2)
+		return -EINVAL;
+
+	listen->backlog = READ_ONCE(sqe->len);
+
+	return 0;
+}
+
+int io_listen(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_listen *listen = io_kiocb_to_cmd(req, struct io_listen);
+	int ret;
+
+	ret = __sys_listen_socket(sock_from_file(req->file), listen->backlog);
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
index 49f9a7bc1113..52bfee05f06a 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -52,6 +52,9 @@ void io_send_zc_cleanup(struct io_kiocb *req);
 int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_bind(struct io_kiocb *req, unsigned int issue_flags);
 
+int io_listen_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_listen(struct io_kiocb *req, unsigned int issue_flags);
+
 void io_netmsg_cache_free(const void *entry);
 #else
 static inline void io_netmsg_cache_free(const void *entry)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 19ee9445f024..7d5c51fb8e6e 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -503,6 +503,16 @@ const struct io_issue_def io_issue_defs[] = {
 		.async_size		= sizeof(struct io_async_msghdr),
 #else
 		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_LISTEN] = {
+#if defined(CONFIG_NET)
+		.needs_file		= 1,
+		.prep			= io_listen_prep,
+		.issue			= io_listen,
+		.async_size		= sizeof(struct io_async_msghdr),
+#else
+		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 };
@@ -724,6 +734,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_BIND] = {
 		.name			= "BIND",
 	},
+	[IORING_OP_LISTEN] = {
+		.name			= "LISTEN",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.44.0


