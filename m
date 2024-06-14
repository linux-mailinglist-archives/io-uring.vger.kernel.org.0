Return-Path: <io-uring+bounces-2215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A23DB909059
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 233AC2880A9
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 16:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5543B1AB90E;
	Fri, 14 Jun 2024 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cj8FmAYj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DaOjhVSX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cj8FmAYj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DaOjhVSX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BDD1ABCBE;
	Fri, 14 Jun 2024 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382660; cv=none; b=q4mJHm2hwmdYfl9ZzTXYajHlsG0SGySQFZy9CICvuiy/10MK/8RrEV+C0sXuY1kcYmzXUho0se1b/0E1G0cke+oHu+EDDU3e0M7gFYYO9UiYMNncFbZ/1P8pF2xln6JKmpRakbjKS9XeMgEj+Rmd8ocCrEj5jgdq6A0FcjC3Ri0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382660; c=relaxed/simple;
	bh=XKkvYpzilvAEE/2RfdhRbhpL5cY/9xwiyRLEwPWPwIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRhQMarCJmnxi+Igt8zjrd+k4QcL+rekIimnt+2V+uIdLteqc7jXBYVi5FXA+4jngzZjz88tbK7lkKaMTLZ1KOFB8SotiQmC/30qoomusX5Cg8q9qDpYiCoKep1Nknxj9uiC5l7kRp1bVjH9QSXOxpWP5265hnHUxhGBuy1EqTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cj8FmAYj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DaOjhVSX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cj8FmAYj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DaOjhVSX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AF0AF2069E;
	Fri, 14 Jun 2024 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718382656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kwq8WeoOYXAFfq4ENmQXheUFFriDONAIFF1ZwyrMatE=;
	b=Cj8FmAYjfaJwgcUep2VvZi+ZdpumPDMSTCD18DcxK2BlvzK2uqrcoi/2FwY1xzlQtIXCNB
	3a3ld8ERwsvsVzVR2loEl04dGgQy49pte6dVZRao7WlADbO/++1kovfQ/zUHRp5evxTdw9
	p/SGqdl+Y00UKy29r7Agg4o5GxgNn1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718382656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kwq8WeoOYXAFfq4ENmQXheUFFriDONAIFF1ZwyrMatE=;
	b=DaOjhVSXyK5C5nsgHnlqok6wipuPy8d1+0Gl1xN0i3uqozvBxYGbWj2kjRcqXd21VVSun9
	YlKFkP3BQEBmQeDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Cj8FmAYj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DaOjhVSX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718382656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kwq8WeoOYXAFfq4ENmQXheUFFriDONAIFF1ZwyrMatE=;
	b=Cj8FmAYjfaJwgcUep2VvZi+ZdpumPDMSTCD18DcxK2BlvzK2uqrcoi/2FwY1xzlQtIXCNB
	3a3ld8ERwsvsVzVR2loEl04dGgQy49pte6dVZRao7WlADbO/++1kovfQ/zUHRp5evxTdw9
	p/SGqdl+Y00UKy29r7Agg4o5GxgNn1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718382656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kwq8WeoOYXAFfq4ENmQXheUFFriDONAIFF1ZwyrMatE=;
	b=DaOjhVSXyK5C5nsgHnlqok6wipuPy8d1+0Gl1xN0i3uqozvBxYGbWj2kjRcqXd21VVSun9
	YlKFkP3BQEBmQeDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73D2813AAF;
	Fri, 14 Jun 2024 16:30:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sT3IFUBwbGbIcwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 14 Jun 2024 16:30:56 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 4/4] io_uring: Introduce IORING_OP_LISTEN
Date: Fri, 14 Jun 2024 12:30:47 -0400
Message-ID: <20240614163047.31581-4-krisman@suse.de>
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
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: AF0AF2069E
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

IORING_OP_LISTEN provides the semantic of listen(2) via io_uring.  While
this is an essentially synchronous system call, the main point is to
enable a network path to execute fully with io_uring registered and
descriptorless files.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
changes since v1:
- Drop empty lines ahead of return (Jens).
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/net.c                | 28 ++++++++++++++++++++++++++++
 io_uring/net.h                |  3 +++
 io_uring/opdef.c              | 13 +++++++++++++
 4 files changed, 45 insertions(+)

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
index 8cbc29aff15c..028e126ab30c 100644
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
@@ -1751,6 +1756,29 @@ int io_bind(struct io_kiocb *req, unsigned int issue_flags)
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
2.45.2


