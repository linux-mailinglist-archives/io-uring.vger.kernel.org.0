Return-Path: <io-uring+bounces-10707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF00C7672E
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 23:00:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0B21435BBD1
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 21:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730CD3115AE;
	Thu, 20 Nov 2025 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="08X+9XWH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LinZrC7/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="08X+9XWH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LinZrC7/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BAC275844
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 21:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675946; cv=none; b=HMSPb0B+Oek5kEC2pHXjp41eWpt3HEs6389edOe8upVhj/YZ7L3cUU9v+bdvJ48mapWTUbm9vBZJoPNkyfMLl9vwWRzo+QIKTm0z8trUz/sHXuxcxT3wEA/M+14bP6Rf37NXhmxSPs7tCe0XEqbi9Jt3dWzE2NAHBTxZF9gwIOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675946; c=relaxed/simple;
	bh=SGOSY1QqZ8xpitOI9PDuP2JmoZ+GHzjO6mdnpLBwOSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=himFKrBfoRLqzKOuOutr4e9ON0NbR3gU9tIEuzTsMDBrDzyI3vJoMq/+d2yOtbA1tleW2bYL5vdYr0hAUvx+5n6J+mtsMdTnwMsLmJodWGt1K+VeDpkNhm/A+rMju0te7sIkDZd/eqgz/5LbdsRFGAKmpmxMM3FDLAIbBqRBdlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=08X+9XWH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LinZrC7/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=08X+9XWH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LinZrC7/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5006C20C59;
	Thu, 20 Nov 2025 21:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763675941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1HN/S0HWqT7U51N2x65OnccpLeIDHCWC1Ft2sK5pdg=;
	b=08X+9XWH/UnKXiSAxTged/PtRgapRpEWRbeMD/2MVbJ6McK3yPX8Daj5m6SsE4M71+1wpE
	BSI349peMxZKLLHt4BcDbJqqXp/PAgPlRYPZohAMvErUuYiJWnbu3cqCiCp6v3dChaTCO7
	a7ffvGnvU+7EX/sDT+yk3t9lQIiZgnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763675941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1HN/S0HWqT7U51N2x65OnccpLeIDHCWC1Ft2sK5pdg=;
	b=LinZrC7/2IG8lfQWx0+90f9faZ+Am7nxJAevGJ4F3oFzMZrq/IOS9GMLAyrHmbv2+ze2Pa
	PqgcaJ5XZeUGqKAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=08X+9XWH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="LinZrC7/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763675941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1HN/S0HWqT7U51N2x65OnccpLeIDHCWC1Ft2sK5pdg=;
	b=08X+9XWH/UnKXiSAxTged/PtRgapRpEWRbeMD/2MVbJ6McK3yPX8Daj5m6SsE4M71+1wpE
	BSI349peMxZKLLHt4BcDbJqqXp/PAgPlRYPZohAMvErUuYiJWnbu3cqCiCp6v3dChaTCO7
	a7ffvGnvU+7EX/sDT+yk3t9lQIiZgnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763675941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1HN/S0HWqT7U51N2x65OnccpLeIDHCWC1Ft2sK5pdg=;
	b=LinZrC7/2IG8lfQWx0+90f9faZ+Am7nxJAevGJ4F3oFzMZrq/IOS9GMLAyrHmbv2+ze2Pa
	PqgcaJ5XZeUGqKAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 129073EA61;
	Thu, 20 Nov 2025 21:59:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id psX8MySPH2l0dgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 20 Nov 2025 21:59:00 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: 
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
Subject: [PATCH v2 2/3] socket: Split out a getsockname helper for io_uring
Date: Thu, 20 Nov 2025 16:58:13 -0500
Message-ID: <20251120215816.3787271-3-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251120215816.3787271-1-krisman@suse.de>
References: <20251120215816.3787271-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5006C20C59
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

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


