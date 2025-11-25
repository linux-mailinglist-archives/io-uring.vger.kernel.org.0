Return-Path: <io-uring+bounces-10778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDADC82EE8
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 01:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 505BF4E66B8
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 00:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2CB1F1302;
	Tue, 25 Nov 2025 00:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KuCVkGy6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QcBMoWTU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KuCVkGy6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QcBMoWTU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332D1F09A8
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 00:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764030262; cv=none; b=PdTENyCgW/jP7INPI10iBdcsufWp99oRVgMrAiWzac0PaUIrYPx7A/UdSYXpyTk/FN+MWGwCdmXMc3uGyU1WFC7NwMPBSv7e3L9f0m6wzYpgL8tPc7gSoRqDovtf69Ak+qTi3pW89akW/XtAVYLjG9pkNtLfrem42YLkJYoy3S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764030262; c=relaxed/simple;
	bh=pBDuqWSUAV5CQXlD4a0gOcbODDo911yfJNfYTpSPgUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frb0ATNdvRryKUz06GvZNNjimZLhHQJUKJLuepxvHO18xza3fRM0YZdOPhSOG9EOCchfe0MMWBQBytcLvLrfdEKox+HbFj9+NhsED+eaqfcs29OaowaJ0Gvr20Da7zo9jtlrbdcN8N03zJJaVzZn9HZxzZinzqcDOV9wRB2k95M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KuCVkGy6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QcBMoWTU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KuCVkGy6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QcBMoWTU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2752521991;
	Tue, 25 Nov 2025 00:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764030252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eamxE4yvuCok4gJU/VuyRNytLm+bMfQx6OYz8J49fNo=;
	b=KuCVkGy62tDhGWZy+b+v7LwE8X66Q7Zp+v3YC11yT6Oi4raRHRcp9ShDZ+pECC6mFdOGqF
	DefMluN2T+qL5txEBWruAht2ew9y/EfTczsUZsmCj0lKoeA1D95S47t1z3+fug9GfQuari
	ccWDBEUWV8Dg6mwgbKsT20kvUSBi87I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764030252;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eamxE4yvuCok4gJU/VuyRNytLm+bMfQx6OYz8J49fNo=;
	b=QcBMoWTUSxo0LSlKjFiVgllnbuXdiVOy+ui5ALvgjc77CpihMVl54LxFt2c2xyDBUJeWOR
	TERfOEGTmYqQeiAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764030252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eamxE4yvuCok4gJU/VuyRNytLm+bMfQx6OYz8J49fNo=;
	b=KuCVkGy62tDhGWZy+b+v7LwE8X66Q7Zp+v3YC11yT6Oi4raRHRcp9ShDZ+pECC6mFdOGqF
	DefMluN2T+qL5txEBWruAht2ew9y/EfTczsUZsmCj0lKoeA1D95S47t1z3+fug9GfQuari
	ccWDBEUWV8Dg6mwgbKsT20kvUSBi87I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764030252;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eamxE4yvuCok4gJU/VuyRNytLm+bMfQx6OYz8J49fNo=;
	b=QcBMoWTUSxo0LSlKjFiVgllnbuXdiVOy+ui5ALvgjc77CpihMVl54LxFt2c2xyDBUJeWOR
	TERfOEGTmYqQeiAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB7FC3EA63;
	Tue, 25 Nov 2025 00:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IPKlJSv3JGmGQQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 00:24:11 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	netdev@vger.kernel.org,
	io-uring@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v3 2/3] socket: Split out a getsockname helper for io_uring
Date: Mon, 24 Nov 2025 19:23:42 -0500
Message-ID: <20251125002345.2130897-3-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251125002345.2130897-1-krisman@suse.de>
References: <20251125002345.2130897-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Similar to getsockopt, split out a helper to check security and issue
the operation from the main handler that can be used by io_uring.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
v2 -> v3:
- Move sockaddr_storage parameter into do_getsockname(Kuniyuki)
---
 include/linux/socket.h |  2 ++
 net/socket.c           | 36 ++++++++++++++++++++----------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 937fe331ff1e..8d580074ddea 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -453,6 +453,8 @@ extern int __sys_connect(int fd, struct sockaddr __user *uservaddr,
 			 int addrlen);
 extern int __sys_listen(int fd, int backlog);
 extern int __sys_listen_socket(struct socket *sock, int backlog);
+extern int do_getsockname(struct socket *sock, int peer,
+			  struct sockaddr __user *usockaddr, int __user *usockaddr_len);
 extern int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 			     int __user *usockaddr_len, int peer);
 extern int __sys_socketpair(int family, int type, int protocol,
diff --git a/net/socket.c b/net/socket.c
index 208d92ccf0fb..89bac0a17e5a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2127,39 +2127,43 @@ SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
 	return __sys_connect(fd, uservaddr, addrlen);
 }
 
-/*
- *	Get the remote or local address ('name') of a socket object. Move the
- *	obtained name to user space.
- */
-int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
-		      int __user *usockaddr_len, int peer)
+int do_getsockname(struct socket *sock, int peer,
+		   struct sockaddr __user *usockaddr, int __user *usockaddr_len)
 {
-	struct socket *sock;
 	struct sockaddr_storage address;
-	CLASS(fd, f)(fd);
 	int err;
 
-	if (fd_empty(f))
-		return -EBADF;
-	sock = sock_from_file(fd_file(f));
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-
 	if (peer)
 		err = security_socket_getpeername(sock);
 	else
 		err = security_socket_getsockname(sock);
 	if (err)
 		return err;
-
 	err = READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&address, peer);
 	if (err < 0)
 		return err;
-
 	/* "err" is actually length in this case */
 	return move_addr_to_user(&address, err, usockaddr, usockaddr_len);
 }
 
+/*
+ *	Get the remote or local address ('name') of a socket object. Move the
+ *	obtained name to user space.
+ */
+int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
+		      int __user *usockaddr_len, int peer)
+{
+	struct socket *sock;
+	CLASS(fd, f)(fd);
+
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+	return do_getsockname(sock, peer, usockaddr, usockaddr_len);
+}
+
 SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockaddr,
 		int __user *, usockaddr_len)
 {
-- 
2.51.0


