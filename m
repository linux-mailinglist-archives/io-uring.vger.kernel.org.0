Return-Path: <io-uring+bounces-10725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E173C7AC9D
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 17:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EA328358FEA
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 16:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49819351FB5;
	Fri, 21 Nov 2025 16:10:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8334934F245
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763741419; cv=none; b=rs12KyjtdzChTXClv3ikQbyIJm1m9mCzQSEEn+xkwuAt0T9q9gwxb6KuFq25ax8KXk3uGVbbEo36vaJ7piQfmump5umn2zbVyNtMPGiceVvpoNLkugpTmujcShYs8wx+TSAobs8aKx1+zPiC/pXWkO9SfUByg38l3XylKYAqjzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763741419; c=relaxed/simple;
	bh=SGOSY1QqZ8xpitOI9PDuP2JmoZ+GHzjO6mdnpLBwOSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk2a1pwEC385i2LDPEmSDRfyQ4XyuKmLVqvpALDnp9T5Q+tjV3Vn+dX3V2yORnNI+Rzu9Q8cjxBZLSdFVn5l6KDVpTYyPLUUfr9vIf7QiCBQwWeQGVKIdRdziHkZgs+w+Wi1j37PojneKgoCRMIkikdO0cpcNaypgvQiNN55+4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19020219B6;
	Fri, 21 Nov 2025 16:10:12 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDBDD3EA61;
	Fri, 21 Nov 2025 16:10:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s+4FIuOOIGmPeAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 21 Nov 2025 16:10:11 +0000
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
Subject: [PATCH v2 2/3] socket: Split out a getsockname helper for io_uring
Date: Fri, 21 Nov 2025 11:09:47 -0500
Message-ID: <20251121160954.88038-3-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251121160954.88038-1-krisman@suse.de>
References: <20251121160954.88038-1-krisman@suse.de>
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
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 19020219B6
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

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


