Return-Path: <io-uring+bounces-13592-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 4djrF684H2qSiwAAu9opvQ
	(envelope-from <io-uring+bounces-13592-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 22:10:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BD2631A8C
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 22:10:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=u47CLEvB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="yV/kxAgD";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=u47CLEvB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="yV/kxAgD";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13592-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13592-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4AA97306033D
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 20:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C0025B0B1;
	Tue,  2 Jun 2026 20:03:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C2725B088
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 20:03:36 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430617; cv=none; b=pPdQoYqciNpikM46mHuLdZ42SVanfVGeOkiA8XK4QVgZLPvNEXJL+MMwUEBU9Uuun1g58Bz/l9uLk0bqQpEMX9jVu8ilTYijC1v1+wNvqV0Cfg0Mv9Ar3Bl2xHIYJ/hq7ebG2nyr5QTbC9aezQDBIUWUflBAGnXHHWOUKFM9O+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430617; c=relaxed/simple;
	bh=Ln+skB/Ufz9JAVBmpLFCZVhVqgsYTaUvOuvuUH49otA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbVsHHhNqcN+p6Jd7yrS6w/hR9y1vPJKRdDu5fiJGNHBVJF2Pxp7vk8r2xASnpAqIr7VkVAl3QhK2rCUFYI/U2LR8eZB51nyIPiJjKEw35kaE4GfWSIo3LCw2D1USBJMsy+O0PZKG5QiDpVhnfNxG/TTOP4ZJYD991d5/BX+1WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u47CLEvB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yV/kxAgD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u47CLEvB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yV/kxAgD; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 573AB6ABFA;
	Tue,  2 Jun 2026 20:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780430611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYSHZsZSfbupWbWDsXGdZ2IpqQlTn0L42ie2wcQ0zz0=;
	b=u47CLEvBq/ky939gFKPP0cfDlflImve2ATIxZJZDH95AUw43+4AH6aLaHOsWSZ7M5u6CGG
	MI1dJLjJZB4lH4niAuHScoSpU9oq2iGelygtQFnmbRiAN/6M3J+Zbb949hiCNVa0vjrLNE
	Krt6JIh1XqM5fb0IU1c7esMghHPxsd4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780430611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYSHZsZSfbupWbWDsXGdZ2IpqQlTn0L42ie2wcQ0zz0=;
	b=yV/kxAgDLQ97WTTrpiHgDrxa/NIRdb27BO76SmiY/97je5PuEiRvM5fYP8RjQpaXPy4wST
	XrakVfsUxUs7ZrCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780430611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYSHZsZSfbupWbWDsXGdZ2IpqQlTn0L42ie2wcQ0zz0=;
	b=u47CLEvBq/ky939gFKPP0cfDlflImve2ATIxZJZDH95AUw43+4AH6aLaHOsWSZ7M5u6CGG
	MI1dJLjJZB4lH4niAuHScoSpU9oq2iGelygtQFnmbRiAN/6M3J+Zbb949hiCNVa0vjrLNE
	Krt6JIh1XqM5fb0IU1c7esMghHPxsd4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780430611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYSHZsZSfbupWbWDsXGdZ2IpqQlTn0L42ie2wcQ0zz0=;
	b=yV/kxAgDLQ97WTTrpiHgDrxa/NIRdb27BO76SmiY/97je5PuEiRvM5fYP8RjQpaXPy4wST
	XrakVfsUxUs7ZrCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18195779A7;
	Tue,  2 Jun 2026 20:03:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nesuNRI3H2pSMgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 02 Jun 2026 20:03:30 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 1/3] io_uring: Avoid msghdr on op_connect/op_bind async data
Date: Tue,  2 Jun 2026 16:03:13 -0400
Message-ID: <20260602200315.1761983-2-krisman@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602200315.1761983-1-krisman@suse.de>
References: <20260602200315.1761983-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -6.79
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13592-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,suse.de:mid,suse.de:dkim,suse.de:from_mime,suse.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A7BD2631A8C

Both IORING_OP_CONNECT and IORING_OP_BIND reuse the msghdr object for
just to store sockaddr.  Beyond allocating a much larger object than
needed, msghdr can also wrap an iovec, which will be recycled
unnecessarily.  This splits the sockaddr into an async type.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/net.c   | 15 +++++++--------
 io_uring/net.h   |  4 ++++
 io_uring/opdef.c |  4 ++--
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index cceb5c1409ca..1da811100132 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1677,7 +1677,7 @@ void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
 void io_connect_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
 {
 	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_msghdr *iomsg = req->async_data;
+	struct io_async_sockaddr *iomsg = req->async_data;
 	struct sockaddr_storage *ss = &iomsg->addr;
 
 	/*
@@ -1772,7 +1772,7 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_msghdr *io;
+	struct io_async_sockaddr *io;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1781,7 +1781,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	conn->addr_len =  READ_ONCE(sqe->addr2);
 	conn->in_progress = conn->seen_econnaborted = false;
 
-	io = io_msg_alloc_async(req);
+	io = io_uring_alloc_async_data(NULL, req);
 	if (unlikely(!io))
 		return -ENOMEM;
 
@@ -1791,7 +1791,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_msghdr *io = req->async_data;
+	struct io_async_sockaddr *io = req->async_data;
 	unsigned file_flags;
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -1835,7 +1835,6 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 out:
 	if (ret < 0)
 		req_set_fail(req);
-	io_req_msg_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
 	return IOU_COMPLETE;
 }
@@ -1844,7 +1843,7 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
 	struct sockaddr __user *uaddr;
-	struct io_async_msghdr *io;
+	struct io_async_sockaddr *io;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1852,7 +1851,7 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	bind->addr_len =  READ_ONCE(sqe->addr2);
 
-	io = io_msg_alloc_async(req);
+	io = io_uring_alloc_async_data(NULL, req);
 	if (unlikely(!io))
 		return -ENOMEM;
 	return move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
@@ -1861,7 +1860,7 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_bind(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
-	struct io_async_msghdr *io = req->async_data;
+	struct io_async_sockaddr *io = req->async_data;
 	struct socket *sock;
 	int ret;
 
diff --git a/io_uring/net.h b/io_uring/net.h
index 51fda715d3c0..b296ec4eefb2 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -5,6 +5,10 @@
 #include <linux/io_uring_types.h>
 #include <uapi/linux/io_uring/bpf_filter.h>
 
+struct io_async_sockaddr {
+	struct sockaddr_storage		addr;
+};
+
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
 	struct iou_vec				vec;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 8ea6bd274607..ffa28224cc8f 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -204,7 +204,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 #if defined(CONFIG_NET)
 		.filter_pdu_size	= sizeof_field(struct io_uring_bpf_ctx, connect),
-		.async_size		= sizeof(struct io_async_msghdr),
+		.async_size		= sizeof(struct io_async_sockaddr),
 		.prep			= io_connect_prep,
 		.issue			= io_connect,
 		.filter_populate	= io_connect_bpf_populate,
@@ -505,7 +505,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.prep			= io_bind_prep,
 		.issue			= io_bind,
-		.async_size		= sizeof(struct io_async_msghdr),
+		.async_size		= sizeof(struct io_async_sockaddr),
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.54.0


