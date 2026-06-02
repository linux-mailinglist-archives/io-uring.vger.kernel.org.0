Return-Path: <io-uring+bounces-13597-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id z3LjGahSH2rMkQAAu9opvQ
	(envelope-from <io-uring+bounces-13597-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 03 Jun 2026 00:01:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D55B46324DD
	for <lists+io-uring@lfdr.de>; Wed, 03 Jun 2026 00:01:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P9HOrtSu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WLsypxs4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P9HOrtSu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WLsypxs4;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13597-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13597-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7A06305BF98
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 21:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F56238B122;
	Tue,  2 Jun 2026 21:53:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B7E3019AA
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 21:53:46 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780437228; cv=none; b=vDq+0SqNj+rMPsyJN9HvVA5NWJKONu9Xf/GkVvJFbygFr3YNxcctCegRgIo5JKl/dRoEqz88Acm0gNfT0JdsHUm4llUQuxeoKz9ZqiagauYNLE/7BVK5+bdisBv3KmfCqUfXHfx8RxdzlpK4PJ4Wa4ljLAysHq9eWR3Fhar0xSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780437228; c=relaxed/simple;
	bh=7dfMttCY+dZL/FCSqedJPErUXUUGFeUJkf4yg7Y9Exo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux+5M6H47+g3OQ0l4St2FwUcYJuf5sHa065GZvEA6fg4JWJG+fuWHQLlvCSkB8c3eJzclxz2zSsc4n4zM5X6pqxti0roSUn/KMoRexl8XVZhTMRoJM5GXJxDs2l1dnPX0xwtuvN78jWFFYFOXOVYVV3luEHo5p9ymBuXlvLQm4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P9HOrtSu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WLsypxs4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P9HOrtSu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WLsypxs4; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5033A67532;
	Tue,  2 Jun 2026 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780437225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rcj+FuOkWClllrpPNmFQWDSijuSnDdkh91aRhl/t9oM=;
	b=P9HOrtSuDG2wcJi5/ecbFUu58NyQKMK73s2NS3sBsOTuXgaJi9izGGsbnPJ5IAI7nlAIOe
	Bn2RC3pCYjDJNyYCNyHOe7Zq4DghaoHn301GgWOr5YMSyeaHdV69BYli+XKu/m1MrzRGpF
	rnObdSC9dMEhIIwpEOIc7vd3nUGnJUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780437225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rcj+FuOkWClllrpPNmFQWDSijuSnDdkh91aRhl/t9oM=;
	b=WLsypxs4oSz7fvpjQ6f6lsGflEeYNJ53ajeMUHiJ3FnKvVXxccASU06BcSRh/y/ZU/pLmc
	/fM+1SQHut5s1FDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780437225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rcj+FuOkWClllrpPNmFQWDSijuSnDdkh91aRhl/t9oM=;
	b=P9HOrtSuDG2wcJi5/ecbFUu58NyQKMK73s2NS3sBsOTuXgaJi9izGGsbnPJ5IAI7nlAIOe
	Bn2RC3pCYjDJNyYCNyHOe7Zq4DghaoHn301GgWOr5YMSyeaHdV69BYli+XKu/m1MrzRGpF
	rnObdSC9dMEhIIwpEOIc7vd3nUGnJUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780437225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rcj+FuOkWClllrpPNmFQWDSijuSnDdkh91aRhl/t9oM=;
	b=WLsypxs4oSz7fvpjQ6f6lsGflEeYNJ53ajeMUHiJ3FnKvVXxccASU06BcSRh/y/ZU/pLmc
	/fM+1SQHut5s1FDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 012DC779A7;
	Tue,  2 Jun 2026 21:53:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2rtFNehQH2oNGAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 02 Jun 2026 21:53:44 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 1/3] io_uring/net: Avoid msghdr on op_connect/op_bind async data
Date: Tue,  2 Jun 2026 17:53:24 -0400
Message-ID: <20260602215327.1885109-2-krisman@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602215327.1885109-1-krisman@suse.de>
References: <20260602215327.1885109-1-krisman@suse.de>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13597-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.de:mid,suse.de:dkim,suse.de:from_mime,suse.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D55B46324DD

Both IORING_OP_CONNECT and IORING_OP_BIND reuse the msghdr object just
to store the sockaddr.  Beyond allocating a much larger object than
needed, msghdr can also wrap an iovec, which will be recycled
unnecessarily.  This uses the sockaddr directly.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
Since v1:
  - use sockaddr directly
---
 io_uring/net.c   | 30 ++++++++++++++----------------
 io_uring/opdef.c |  4 ++--
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index cceb5c1409ca..7ff5975e118b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1677,8 +1677,7 @@ void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
 void io_connect_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
 {
 	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_msghdr *iomsg = req->async_data;
-	struct sockaddr_storage *ss = &iomsg->addr;
+	struct sockaddr_storage *ss = req->async_data;
 
 	/*
 	 * move_addr_to_kernel() skips the copy for addr_len == 0, so
@@ -1772,7 +1771,7 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_msghdr *io;
+	struct sockaddr_storage *addr;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1781,17 +1780,17 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	conn->addr_len =  READ_ONCE(sqe->addr2);
 	conn->in_progress = conn->seen_econnaborted = false;
 
-	io = io_msg_alloc_async(req);
-	if (unlikely(!io))
+	addr = io_uring_alloc_async_data(NULL, req);
+	if (unlikely(!addr))
 		return -ENOMEM;
 
-	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->addr);
+	return move_addr_to_kernel(conn->addr, conn->addr_len, addr);
 }
 
 int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_msghdr *io = req->async_data;
+	struct sockaddr_storage *addr = req->async_data;
 	unsigned file_flags;
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -1805,8 +1804,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 
-	ret = __sys_connect_file(req->file, &io->addr, connect->addr_len,
-				 file_flags);
+	ret = __sys_connect_file(req->file, addr, connect->addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS || ret == -ECONNABORTED)
 	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
@@ -1835,7 +1833,6 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 out:
 	if (ret < 0)
 		req_set_fail(req);
-	io_req_msg_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
 	return IOU_COMPLETE;
 }
@@ -1844,7 +1841,7 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
 	struct sockaddr __user *uaddr;
-	struct io_async_msghdr *io;
+	struct sockaddr_storage *addr;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1852,16 +1849,17 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	bind->addr_len =  READ_ONCE(sqe->addr2);
 
-	io = io_msg_alloc_async(req);
-	if (unlikely(!io))
+	addr = io_uring_alloc_async_data(NULL, req);
+	if (unlikely(!addr))
 		return -ENOMEM;
-	return move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
+	return move_addr_to_kernel(uaddr, bind->addr_len, addr);
 }
 
+
 int io_bind(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
-	struct io_async_msghdr *io = req->async_data;
+	struct sockaddr_storage *addr = req->async_data;
 	struct socket *sock;
 	int ret;
 
@@ -1869,7 +1867,7 @@ int io_bind(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = __sys_bind_socket(sock, &io->addr, bind->addr_len);
+	ret = __sys_bind_socket(sock, addr, bind->addr_len);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 8ea6bd274607..517bad015505 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -204,7 +204,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 #if defined(CONFIG_NET)
 		.filter_pdu_size	= sizeof_field(struct io_uring_bpf_ctx, connect),
-		.async_size		= sizeof(struct io_async_msghdr),
+		.async_size		= sizeof(struct sockaddr_storage),
 		.prep			= io_connect_prep,
 		.issue			= io_connect,
 		.filter_populate	= io_connect_bpf_populate,
@@ -505,7 +505,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.prep			= io_bind_prep,
 		.issue			= io_bind,
-		.async_size		= sizeof(struct io_async_msghdr),
+		.async_size		= sizeof(struct sockaddr_storage),
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.54.0


