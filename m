Return-Path: <io-uring+bounces-10706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9B3C76731
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 23:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 35A0E4E3A1D
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 21:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30BF2F90CA;
	Thu, 20 Nov 2025 21:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e0WLFop2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qhN91ZHO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e0WLFop2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qhN91ZHO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E9E2EAB6E
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 21:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675939; cv=none; b=BpNJzk5GZu6OPteZOgji4Wc/04jVrvrBrB8vQ9TcB9RHCARvDlvM7Yw4KeSgv4qQ0mONlTkTOlLrfkkQONEl8P0sY7tI9ObQrxOgh3690C7/M3/sbbyuVh8Pni4bqGp2NhVOOnAVz8TaTXTGYdVVrPDj2croYbkKzI04WC7uIog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675939; c=relaxed/simple;
	bh=S+B+s7hm5Wuem3j8mdHcpPKEefGrKqATR/MAAwqqXkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgr20zGUPxIp2JZm+KSD3zheXuPz3Jw7WdAyZn7nnI6eTIQzs8qYCSD//QhFsxQL9dIQCbPl9MlOpQZYOYWW+6d/E8PV8hKNnEtaj7xAxz/gMVRL9mBEeDNW0/HfVGPRTCtVuO6bhoYPxsAX+fXDUkoTu3/yE+fAPPC2s+E02S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e0WLFop2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qhN91ZHO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e0WLFop2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qhN91ZHO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4FE3C218B1;
	Thu, 20 Nov 2025 21:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763675936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aqqMk8NwWZOMEyDAVjJgagkCwcgrm8g9qfE3A2bR5A4=;
	b=e0WLFop2hNdY4MzSScJvO5wctf3/i2x0q4PSclK8WAgmybUZCsZseB3xbFYCGMVHy2jMpo
	6x8zez2/MVdiKsHHRrG4XK5SLvkGUObq0stddnWEWRa3vvkf02grv9iY+O9yBU70kVpQNR
	htwMlRD2DARQ4HKqZp3veV7dcmeX9mM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763675936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aqqMk8NwWZOMEyDAVjJgagkCwcgrm8g9qfE3A2bR5A4=;
	b=qhN91ZHOIxATiNfLrsHfzAQ70SpIwWEua2x3O5bvAU8vH9GEkSV5lchwwXh+8eCKODzPvL
	kRst12RaT6lmXYDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763675936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aqqMk8NwWZOMEyDAVjJgagkCwcgrm8g9qfE3A2bR5A4=;
	b=e0WLFop2hNdY4MzSScJvO5wctf3/i2x0q4PSclK8WAgmybUZCsZseB3xbFYCGMVHy2jMpo
	6x8zez2/MVdiKsHHRrG4XK5SLvkGUObq0stddnWEWRa3vvkf02grv9iY+O9yBU70kVpQNR
	htwMlRD2DARQ4HKqZp3veV7dcmeX9mM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763675936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aqqMk8NwWZOMEyDAVjJgagkCwcgrm8g9qfE3A2bR5A4=;
	b=qhN91ZHOIxATiNfLrsHfzAQ70SpIwWEua2x3O5bvAU8vH9GEkSV5lchwwXh+8eCKODzPvL
	kRst12RaT6lmXYDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11A003EA61;
	Thu, 20 Nov 2025 21:58:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cMLwOB+PH2lvdgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 20 Nov 2025 21:58:55 +0000
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
Subject: [PATCH v2 1/3] socket: Unify getsockname and getpeername implementation
Date: Thu, 20 Nov 2025 16:58:12 -0500
Message-ID: <20251120215816.3787271-2-krisman@suse.de>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

They are already implemented by the same get_name hook in the protocol
level.  Bring the unification one level up to reduce code duplication
in preparation to supporting these as io_uring operations.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/socket.h |  4 +--
 net/compat.c           |  4 +--
 net/socket.c           | 55 ++++++++++--------------------------------
 3 files changed, 16 insertions(+), 47 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 3b262487ec06..937fe331ff1e 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -454,9 +454,7 @@ extern int __sys_connect(int fd, struct sockaddr __user *uservaddr,
 extern int __sys_listen(int fd, int backlog);
 extern int __sys_listen_socket(struct socket *sock, int backlog);
 extern int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
-			     int __user *usockaddr_len);
-extern int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
-			     int __user *usockaddr_len);
+			     int __user *usockaddr_len, int peer);
 extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
 extern int __sys_shutdown_sock(struct socket *sock, int how);
diff --git a/net/compat.c b/net/compat.c
index 485db8ee9b28..2c9bd0edac99 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -460,10 +460,10 @@ COMPAT_SYSCALL_DEFINE2(socketcall, int, call, u32 __user *, args)
 		ret = __sys_accept4(a0, compat_ptr(a1), compat_ptr(a[2]), 0);
 		break;
 	case SYS_GETSOCKNAME:
-		ret = __sys_getsockname(a0, compat_ptr(a1), compat_ptr(a[2]));
+		ret = __sys_getsockname(a0, compat_ptr(a1), compat_ptr(a[2]), 0);
 		break;
 	case SYS_GETPEERNAME:
-		ret = __sys_getpeername(a0, compat_ptr(a1), compat_ptr(a[2]));
+		ret = __sys_getsockname(a0, compat_ptr(a1), compat_ptr(a[2]), 1);
 		break;
 	case SYS_SOCKETPAIR:
 		ret = __sys_socketpair(a0, a1, a[2], compat_ptr(a[3]));
diff --git a/net/socket.c b/net/socket.c
index e8892b218708..ee438b9425da 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2128,12 +2128,11 @@ SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
 }
 
 /*
- *	Get the local address ('name') of a socket object. Move the obtained
- *	name to user space.
+ *	Get the address (remote or local ('name')) of a socket object. Move the
+ *	obtained name to user space.
  */
-
 int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
-		      int __user *usockaddr_len)
+		      int __user *usockaddr_len, int peer)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
@@ -2146,11 +2145,14 @@ int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	err = security_socket_getsockname(sock);
+	if (peer)
+		err = security_socket_getpeername(sock);
+	else
+		err = security_socket_getsockname(sock);
 	if (err)
 		return err;
 
-	err = READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&address, 0);
+	err = READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&address, peer);
 	if (err < 0)
 		return err;
 
@@ -2161,44 +2163,13 @@ int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockaddr,
 		int __user *, usockaddr_len)
 {
-	return __sys_getsockname(fd, usockaddr, usockaddr_len);
-}
-
-/*
- *	Get the remote address ('name') of a socket object. Move the obtained
- *	name to user space.
- */
-
-int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
-		      int __user *usockaddr_len)
-{
-	struct socket *sock;
-	struct sockaddr_storage address;
-	CLASS(fd, f)(fd);
-	int err;
-
-	if (fd_empty(f))
-		return -EBADF;
-	sock = sock_from_file(fd_file(f));
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-
-	err = security_socket_getpeername(sock);
-	if (err)
-		return err;
-
-	err = READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&address, 1);
-	if (err < 0)
-		return err;
-
-	/* "err" is actually length in this case */
-	return move_addr_to_user(&address, err, usockaddr, usockaddr_len);
+	return __sys_getsockname(fd, usockaddr, usockaddr_len, 0);
 }
 
 SYSCALL_DEFINE3(getpeername, int, fd, struct sockaddr __user *, usockaddr,
 		int __user *, usockaddr_len)
 {
-	return __sys_getpeername(fd, usockaddr, usockaddr_len);
+	return __sys_getsockname(fd, usockaddr, usockaddr_len, 1);
 }
 
 /*
@@ -3162,12 +3133,12 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 	case SYS_GETSOCKNAME:
 		err =
 		    __sys_getsockname(a0, (struct sockaddr __user *)a1,
-				      (int __user *)a[2]);
+				      (int __user *)a[2], 0);
 		break;
 	case SYS_GETPEERNAME:
 		err =
-		    __sys_getpeername(a0, (struct sockaddr __user *)a1,
-				      (int __user *)a[2]);
+		    __sys_getsockname(a0, (struct sockaddr __user *)a1,
+				      (int __user *)a[2], 1);
 		break;
 	case SYS_SOCKETPAIR:
 		err = __sys_socketpair(a0, a1, a[2], (int __user *)a[3]);
-- 
2.51.0


