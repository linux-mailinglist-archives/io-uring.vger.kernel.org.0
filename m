Return-Path: <io-uring+bounces-10190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E960EC0713A
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 17:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 31B8456520C
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2919F32ED2E;
	Fri, 24 Oct 2025 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D1Nspiox";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E680wRjH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D1Nspiox";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E680wRjH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21694328B4B
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761320959; cv=none; b=ueUu5xkWSV5O4rGZgBq5cV+UAdEC2GkdoI8OxkCzRwR9aSD/tJrvNSHjnI5zWif04IKCfjc84otgxhO0uwNRk2oc4OpmZKgTwVzqy/pjltnQU/5m8ZcfIytuWYNWDyxzWToUhiH/a/Qc9wh95dUL0gP+rBtMhLTP507V6/mnJRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761320959; c=relaxed/simple;
	bh=SGOSY1QqZ8xpitOI9PDuP2JmoZ+GHzjO6mdnpLBwOSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kk6V1VWHUeebfDeaWt9QK1uXrvHRnUtuZBHWCnHddU141MVUDpVcoKwbDtbZ/yNn++iHscZFAmMrA2cxSUARfSXuMs/iKV7JnRUePYKNng0zxAlShgzWit/DNH0iD2AGsB+PO+jr7hgb2zZM9oU07TooLWXbIokeL3UWxjjqHgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D1Nspiox; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E680wRjH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D1Nspiox; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E680wRjH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65BC01F390;
	Fri, 24 Oct 2025 15:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761320955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1HN/S0HWqT7U51N2x65OnccpLeIDHCWC1Ft2sK5pdg=;
	b=D1NspioxIewmLdxFYjJahFOsbvVxn7UHi89BBlPb7IWLkYDdummmA4PJzjGBuXZNtQ2nJ9
	ySBosEbtPiJhzyry7xMJniyXx3MAkn0hDFXON53yXY/rTdtD0cU6K4Ac1Xwuyvq0T54sal
	nOJhvh9+/0iEgWb2SUEcHBzc97eqNNg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761320955;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1HN/S0HWqT7U51N2x65OnccpLeIDHCWC1Ft2sK5pdg=;
	b=E680wRjHwS88GF4yEZkmN4C6GU4lgsJjOWOM3YEQ4J7njg1bYYG+4yPPi5AKgzi76UUHCb
	tPQ1xvLpt4p8BPCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761320955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1HN/S0HWqT7U51N2x65OnccpLeIDHCWC1Ft2sK5pdg=;
	b=D1NspioxIewmLdxFYjJahFOsbvVxn7UHi89BBlPb7IWLkYDdummmA4PJzjGBuXZNtQ2nJ9
	ySBosEbtPiJhzyry7xMJniyXx3MAkn0hDFXON53yXY/rTdtD0cU6K4Ac1Xwuyvq0T54sal
	nOJhvh9+/0iEgWb2SUEcHBzc97eqNNg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761320955;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1HN/S0HWqT7U51N2x65OnccpLeIDHCWC1Ft2sK5pdg=;
	b=E680wRjHwS88GF4yEZkmN4C6GU4lgsJjOWOM3YEQ4J7njg1bYYG+4yPPi5AKgzi76UUHCb
	tPQ1xvLpt4p8BPCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 263E3132C2;
	Fri, 24 Oct 2025 15:49:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id je+hOPqf+2gMEQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 24 Oct 2025 15:49:14 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	netdev@vger.kernel.org,
	io-uring@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH 2/3] socket: Split out a getsockname helper for io_uring
Date: Fri, 24 Oct 2025 11:48:59 -0400
Message-ID: <20251024154901.797262-3-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024154901.797262-1-krisman@suse.de>
References: <20251024154901.797262-1-krisman@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
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
 include/linux/socket.h |  2 ++
 net/socket.c           | 34 +++++++++++++++++++---------------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 937fe331ff1e..5afb5ef2990c 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -453,6 +453,8 @@ extern int __sys_connect(int fd, struct sockaddr __user *uservaddr,
 			 int addrlen);
 extern int __sys_listen(int fd, int backlog);
 extern int __sys_listen_socket(struct socket *sock, int backlog);
+extern int do_getsockname(struct socket *sock, struct sockaddr_storage *address,
+			  int peer, struct sockaddr __user *usockaddr, int __user *usockaddr_len);
 extern int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 			     int __user *usockaddr_len, int peer);
 extern int __sys_socketpair(int family, int type, int protocol,
diff --git a/net/socket.c b/net/socket.c
index ee438b9425da..9c110b529cdd 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2127,6 +2127,24 @@ SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
 	return __sys_connect(fd, uservaddr, addrlen);
 }
 
+int do_getsockname(struct socket *sock, struct sockaddr_storage *address, int peer,
+		   struct sockaddr __user *usockaddr, int __user *usockaddr_len)
+{
+	int err;
+
+	if (peer)
+		err = security_socket_getpeername(sock);
+	else
+		err = security_socket_getsockname(sock);
+	if (err)
+		return err;
+	err = READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)address, peer);
+	if (err < 0)
+		return err;
+	/* "err" is actually length in this case */
+	return move_addr_to_user(address, err, usockaddr, usockaddr_len);
+}
+
 /*
  *	Get the address (remote or local ('name')) of a socket object. Move the
  *	obtained name to user space.
@@ -2137,27 +2155,13 @@ int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 	struct socket *sock;
 	struct sockaddr_storage address;
 	CLASS(fd, f)(fd);
-	int err;
 
 	if (fd_empty(f))
 		return -EBADF;
 	sock = sock_from_file(fd_file(f));
 	if (unlikely(!sock))
 		return -ENOTSOCK;
-
-	if (peer)
-		err = security_socket_getpeername(sock);
-	else
-		err = security_socket_getsockname(sock);
-	if (err)
-		return err;
-
-	err = READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&address, peer);
-	if (err < 0)
-		return err;
-
-	/* "err" is actually length in this case */
-	return move_addr_to_user(&address, err, usockaddr, usockaddr_len);
+	return do_getsockname(sock, &address, peer, usockaddr, usockaddr_len);
 }
 
 SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockaddr,
-- 
2.51.0


