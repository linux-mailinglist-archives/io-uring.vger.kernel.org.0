Return-Path: <io-uring+bounces-10795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 53307C87341
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 22:19:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 95F4035077E
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 21:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA792FB0BA;
	Tue, 25 Nov 2025 21:18:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102152F7ADC
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 21:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764105515; cv=none; b=ozZvNsTXVSjOFRGpVNYmDwDVZxyTglulUcU4eGVxZdM+PyjsHoXLnMreOazRrWSm+VphxTcudvuCUl8LwUSxJpnTtoXjn7La2aFKpers4VnA6DfGVZhM3DDkn2lzERlNyspCfeePvP5VPG55HwJCPSROXfkG5SOiGaxIxGESAdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764105515; c=relaxed/simple;
	bh=pBDuqWSUAV5CQXlD4a0gOcbODDo911yfJNfYTpSPgUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsHR4hMKloUVk0qwQUJX6g7eupusbOM5uNuI5ON4rj+aTdk+dqnabh4Qu4iLBp5L5MqFcs8teKZYIQgD3h6VkfSwg9Ekvi6SvAZeDf4R/+aD9WAwb2mPnvScveDyOfEb5n7YkGO1dKIGD63UhAtWQbQ6mtt5spjSXn3XhUHS6/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47E435BD61;
	Tue, 25 Nov 2025 21:18:29 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 01F943EA63;
	Tue, 25 Nov 2025 21:18:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F4SDNSQdJml7bwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 21:18:28 +0000
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
Subject: [PATCH v4 2/3] socket: Split out a getsockname helper for io_uring
Date: Tue, 25 Nov 2025 16:18:00 -0500
Message-ID: <20251125211806.2673912-3-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251125211806.2673912-1-krisman@suse.de>
References: <20251125211806.2673912-1-krisman@suse.de>
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
X-Rspamd-Queue-Id: 47E435BD61
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

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


