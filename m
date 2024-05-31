Return-Path: <io-uring+bounces-2040-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E598D6B55
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6E491F2AD45
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 21:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E68680635;
	Fri, 31 May 2024 21:13:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2063C7F7EF;
	Fri, 31 May 2024 21:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717190011; cv=none; b=uC9n36CkY9r9/DS4jMojaoH+JAYs1hVlVj+W7oaJDDQG8VLyHG6pE/3oLGkbgbl0nNmy0lHPbfWFX+EbGzt4n1atFeo8Fr4F5Mdd3DdzI/+RZkx77NVrl7WbDjeHumuiurALciCIr14EfihdagIrC7VmigIlR3TWGWEvoLdy7ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717190011; c=relaxed/simple;
	bh=q6piQfW6+Piik0pc5C0UIa73ns2svXjmzoHDl078HlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+kGRY7d3zZ92tFUbStjfiY+mKie5TRpCCR+TXteBl7M2p04hAiPCzNl9V0Xf8bvAzhX49zEbenhTQtoeHUwwG8J5gLib8Cy8d2kAc2wWDaeVobr8fS6s5jGImuBS8gcsALRVk8vrBUt3ZlAVj50yGOHB4R9NcE6FlxYrqBNayE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3527D21ABE;
	Fri, 31 May 2024 21:13:27 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F121B137C3;
	Fri, 31 May 2024 21:13:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UNffNHY9Wma6agAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 31 May 2024 21:13:26 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 2/5] net: Split a __sys_bind helper for io_uring
Date: Fri, 31 May 2024 17:12:08 -0400
Message-ID: <20240531211211.12628-3-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240531211211.12628-1-krisman@suse.de>
References: <20240531211211.12628-1-krisman@suse.de>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 3527D21ABE

io_uring holds a reference to the file and maintains a
sockaddr_storage address.  Similarly to what was done to
__sys_connect_file, split an internal helper for __sys_bind in
preparation to supporting an io_uring bind command.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/socket.h |  2 ++
 net/socket.c           | 25 ++++++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 89d16b90370b..b3000f49e9f5 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -442,6 +442,8 @@ extern int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 extern int __sys_socket(int family, int type, int protocol);
 extern struct file *__sys_socket_file(int family, int type, int protocol);
 extern int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen);
+extern int __sys_bind_socket(struct socket *sock, struct sockaddr_storage *address,
+			     int addrlen);
 extern int __sys_connect_file(struct file *file, struct sockaddr_storage *addr,
 			      int addrlen, int file_flags);
 extern int __sys_connect(int fd, struct sockaddr __user *uservaddr,
diff --git a/net/socket.c b/net/socket.c
index e416920e9399..fd0714e10ced 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1822,6 +1822,20 @@ SYSCALL_DEFINE4(socketpair, int, family, int, type, int, protocol,
 	return __sys_socketpair(family, type, protocol, usockvec);
 }
 
+int __sys_bind_socket(struct socket *sock, struct sockaddr_storage *address,
+		      int addrlen)
+{
+	int err;
+
+	err = security_socket_bind(sock, (struct sockaddr *)address,
+				   addrlen);
+	if (!err)
+		err = READ_ONCE(sock->ops)->bind(sock,
+						 (struct sockaddr *)address,
+						 addrlen);
+	return err;
+}
+
 /*
  *	Bind a name to a socket. Nothing much to do here since it's
  *	the protocol's responsibility to handle the local address.
@@ -1839,15 +1853,8 @@ int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
 		err = move_addr_to_kernel(umyaddr, addrlen, &address);
-		if (!err) {
-			err = security_socket_bind(sock,
-						   (struct sockaddr *)&address,
-						   addrlen);
-			if (!err)
-				err = READ_ONCE(sock->ops)->bind(sock,
-						      (struct sockaddr *)
-						      &address, addrlen);
-		}
+		if (!err)
+			err = __sys_bind_socket(sock, &address, addrlen);
 		fput_light(sock->file, fput_needed);
 	}
 	return err;
-- 
2.44.0


