Return-Path: <io-uring+bounces-10776-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A65DC82ED9
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 01:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 19A9634ABB5
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 00:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F211531C1;
	Tue, 25 Nov 2025 00:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0sc0r0ix";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6aNiMPDc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0sc0r0ix";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6aNiMPDc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F6C1C862E
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 00:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764030255; cv=none; b=dECkOHtaVxFD2qQIwKxSDF1Jj0vr/GT07MYK7gEQ3D93D9yLU3a/20VDhPG8YldC652DnpdUDMDzd5RtelmzLL1FrPNDL/TCaoOrd4Pf+lA2/IERU9wIIMlg5mA8cyLP7XyjdOZZBB0MMYyBqShLDEfHf9tAdr8LqYHyuhA4xaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764030255; c=relaxed/simple;
	bh=ZwmencY2dlnVskYleAzIX9TCp9MRAZOD1rrw1GOpE5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P37dNWU5DyNkqz2O6NSjRdbbhliOZZOaE8iMQpjVCN+HyCOsSC5yGe4JiVVAUK021r4yogAVEaphVd+jBLH62DxgU4B+x7GvnzfetSO9kQBbMvIWqqlRk4YTf9GmWZeHy1jXKsD/63ULFuSeKma0nOAXf8k6nf8QFT2jv5OXye4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0sc0r0ix; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6aNiMPDc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0sc0r0ix; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6aNiMPDc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9645A21244;
	Tue, 25 Nov 2025 00:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764030245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELzcXLBoxV2gyTNzeze4ZZZ6rO7/G+FtykrFjH6nfi8=;
	b=0sc0r0ixa7qrR0VpMajwviFnYcy5d1mK6wmGX+s/r8thGSpoH/WutgyCadC+gfAUPxats3
	oAr49x77xb2/1Byif2cRdzAumSQ1DlhZjrY1ZfT+S+zBlmf/Gx3sKAfzpp4Q6gYBibZdky
	G9oPebDH5RaR+q4TSxsOHcYCSlfn01c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764030245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELzcXLBoxV2gyTNzeze4ZZZ6rO7/G+FtykrFjH6nfi8=;
	b=6aNiMPDcEILeVZ7yKBcwaMlg76s8y6ZYenMyJuxBATIdcFgysJol5xyA5hWrMtD1lJrgph
	GeXPsNrjSoLB2mAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0sc0r0ix;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6aNiMPDc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764030245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELzcXLBoxV2gyTNzeze4ZZZ6rO7/G+FtykrFjH6nfi8=;
	b=0sc0r0ixa7qrR0VpMajwviFnYcy5d1mK6wmGX+s/r8thGSpoH/WutgyCadC+gfAUPxats3
	oAr49x77xb2/1Byif2cRdzAumSQ1DlhZjrY1ZfT+S+zBlmf/Gx3sKAfzpp4Q6gYBibZdky
	G9oPebDH5RaR+q4TSxsOHcYCSlfn01c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764030245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELzcXLBoxV2gyTNzeze4ZZZ6rO7/G+FtykrFjH6nfi8=;
	b=6aNiMPDcEILeVZ7yKBcwaMlg76s8y6ZYenMyJuxBATIdcFgysJol5xyA5hWrMtD1lJrgph
	GeXPsNrjSoLB2mAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 449823EA63;
	Tue, 25 Nov 2025 00:24:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oaKMBCX3JGmDQQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 00:24:05 +0000
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
Subject: [PATCH v3 1/3] socket: Unify getsockname and getpeername implementation
Date: Mon, 24 Nov 2025 19:23:41 -0500
Message-ID: <20251125002345.2130897-2-krisman@suse.de>
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
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 9645A21244
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01

They are already implemented by the same get_name hook in the protocol
level.  Bring the unification one level up to reduce code duplication
in preparation to supporting these as io_uring operations.

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
v2 to v3:
- Adjust comment (Kuniyuki)
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
index e8892b218708..208d92ccf0fb 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2128,12 +2128,11 @@ SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
 }
 
 /*
- *	Get the local address ('name') of a socket object. Move the obtained
- *	name to user space.
+ *	Get the remote or local address ('name') of a socket object. Move the
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


