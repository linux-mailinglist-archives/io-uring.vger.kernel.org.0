Return-Path: <io-uring+bounces-2213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 659A290907B
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F1A2B2BBE3
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 16:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE7C1AB916;
	Fri, 14 Jun 2024 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hSjM9aTT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+5ApCs4Q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hSjM9aTT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+5ApCs4Q"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD071AB53D;
	Fri, 14 Jun 2024 16:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382657; cv=none; b=HHqelC5CGQCdQAWJLWPW8WR0rVBiwR4/TZ92WQk8W8oA7kWwce67gmlT+2QCKic79QFo98cc8V6qhiZVpyxECoJQPwaAPtqBrptu/7VSajAMMsJUX06nHYiFn37hB1HndfndX5ZFuj5RYXf4SP0k4w11ETJsULFxmF2JZ8Wp7cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382657; c=relaxed/simple;
	bh=8OQaVnOf6Lrs8SXGQx+ICnX7DrUjQ/CEO83HF+rrb/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RskApCwQ843dvQ7x2T5DxB+QBueT79BQcZATsYq5hP+NKguuRFbHCBTp6dx6fqrj7jnWWf+MhmY6rj6EavuoxB/anKpCXGo7M0W68tavBLBuHIUCl39bhCR338kX2JLs+3ODzy7AfucankTJknvpQ7kkLSbulP2lzoTHTZoOsRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hSjM9aTT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+5ApCs4Q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hSjM9aTT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+5ApCs4Q; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 607F433972;
	Fri, 14 Jun 2024 16:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718382653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cx8yWo9oN9pFHj/SsQFr91uiuZoriXFK39ouBxCXtRU=;
	b=hSjM9aTTx0kfTSUhkdU/JI9erRkwTwvTsW4fTLqtJvdd9eagjFnnOMzIyOy8dMBlK3wdMb
	w1OZm1cmw0o4NmqNwN7WjZydrsun70N42SLzqdqI5vpd508rGB9Obk87tl12Qy+2htuEye
	o9fMu3kK5FH9m5Xbp4X/986beupNlcg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718382653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cx8yWo9oN9pFHj/SsQFr91uiuZoriXFK39ouBxCXtRU=;
	b=+5ApCs4Qx7FtQXu7UjSsWjZVDiC8NMtj5RTVpr/QnZEhWXduSEdYB58qgV21WGK6LNzZ94
	HLYzlKiBZxm2lhAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hSjM9aTT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+5ApCs4Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718382653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cx8yWo9oN9pFHj/SsQFr91uiuZoriXFK39ouBxCXtRU=;
	b=hSjM9aTTx0kfTSUhkdU/JI9erRkwTwvTsW4fTLqtJvdd9eagjFnnOMzIyOy8dMBlK3wdMb
	w1OZm1cmw0o4NmqNwN7WjZydrsun70N42SLzqdqI5vpd508rGB9Obk87tl12Qy+2htuEye
	o9fMu3kK5FH9m5Xbp4X/986beupNlcg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718382653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cx8yWo9oN9pFHj/SsQFr91uiuZoriXFK39ouBxCXtRU=;
	b=+5ApCs4Qx7FtQXu7UjSsWjZVDiC8NMtj5RTVpr/QnZEhWXduSEdYB58qgV21WGK6LNzZ94
	HLYzlKiBZxm2lhAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22A6713AAF;
	Fri, 14 Jun 2024 16:30:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JlCsAT1wbGa/cwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 14 Jun 2024 16:30:53 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 2/4] net: Split a __sys_listen helper for io_uring
Date: Fri, 14 Jun 2024 12:30:45 -0400
Message-ID: <20240614163047.31581-2-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240614163047.31581-1-krisman@suse.de>
References: <20240614163047.31581-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 607F433972
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

io_uring holds a reference to the file and maintains a sockaddr_storage
address.  Similarly to what was done to __sys_connect_file, split an
internal helper for __sys_listen in preparation to support an
io_uring listen command.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/socket.h |  1 +
 net/socket.c           | 23 ++++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index b3000f49e9f5..c1f16cdab677 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -449,6 +449,7 @@ extern int __sys_connect_file(struct file *file, struct sockaddr_storage *addr,
 extern int __sys_connect(int fd, struct sockaddr __user *uservaddr,
 			 int addrlen);
 extern int __sys_listen(int fd, int backlog);
+extern int __sys_listen_socket(struct socket *sock, int backlog);
 extern int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 			     int __user *usockaddr_len);
 extern int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
diff --git a/net/socket.c b/net/socket.c
index fd0714e10ced..fcbdd5bc47ac 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1870,23 +1870,28 @@ SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *, umyaddr, int, addrlen)
  *	necessary for a listen, and if that works, we mark the socket as
  *	ready for listening.
  */
+int __sys_listen_socket(struct socket *sock, int backlog)
+{
+	int somaxconn, err;
+
+	somaxconn = READ_ONCE(sock_net(sock->sk)->core.sysctl_somaxconn);
+	if ((unsigned int)backlog > somaxconn)
+		backlog = somaxconn;
+
+	err = security_socket_listen(sock, backlog);
+	if (!err)
+		err = READ_ONCE(sock->ops)->listen(sock, backlog);
+	return err;
+}
 
 int __sys_listen(int fd, int backlog)
 {
 	struct socket *sock;
 	int err, fput_needed;
-	int somaxconn;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
-		somaxconn = READ_ONCE(sock_net(sock->sk)->core.sysctl_somaxconn);
-		if ((unsigned int)backlog > somaxconn)
-			backlog = somaxconn;
-
-		err = security_socket_listen(sock, backlog);
-		if (!err)
-			err = READ_ONCE(sock->ops)->listen(sock, backlog);
-
+		err = __sys_listen_socket(sock, backlog);
 		fput_light(sock->file, fput_needed);
 	}
 	return err;
-- 
2.45.2


