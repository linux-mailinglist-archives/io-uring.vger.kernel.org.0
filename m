Return-Path: <io-uring+bounces-2212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F366790904F
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D16A91C2518F
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 16:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C088D180A62;
	Fri, 14 Jun 2024 16:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WpfI1Oke";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2NZ3Ygj5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WpfI1Oke";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2NZ3Ygj5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB91D1A2FDF;
	Fri, 14 Jun 2024 16:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382655; cv=none; b=VVE8JFNeUmsgOkRW+vZwouiUMGGIu4Igzy5dvtbdVPD4fYOHOkJe9uZOXk1W08s+nDTPXr8vvKbJXwqyLFZrWtLFGCVuAxaeg6dOXUc0wPX/9i05M9ONvEY91Y7Y4g6SdoKZuuLN7VP7a+/vn843I83ZCPRQt8MZ/2Rmg8RKKUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382655; c=relaxed/simple;
	bh=KJUTQ5e5knyD5SNwjIzJ1iA9VAbMzTa8qYYjBswQIPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uyI1Xv8bIK2jH/J1xB3tiTRcsiMkqyMO5q1hxqmzxlI583J5BqVLoft8H25WMvM3efMek4bCAwardfEWpgxqiviY1kGqXGvMm0Uf4kMyjLzVI0QQrb8eFToRoWykIYLWN5cVw80Ia2RaabxQT45Klvfy71sirvj5+B0XHQKcsZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WpfI1Oke; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2NZ3Ygj5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WpfI1Oke; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2NZ3Ygj5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AB750206A0;
	Fri, 14 Jun 2024 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718382651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mDenGiS4mqkZjRoBJtdVazrDHVboB46YT+YEJgnd3hc=;
	b=WpfI1OkeL+SwhCF7JVwhBZHQHFWk+YYuSy7TRfwIT+T7RQBGhk9UvzUPACqEBID9RbLWf/
	ghS6I3jetgf4DMkPgGC/HH5tio+NPfBG9pi86dCrKmSwod7Tk8nJPol5e3tQY3Q3ikqKPx
	axnH/3M5ZxpEu1N+5oIJDu1D1sUOeBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718382651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mDenGiS4mqkZjRoBJtdVazrDHVboB46YT+YEJgnd3hc=;
	b=2NZ3Ygj5aCpxI/PSa/jPzgVOz9ZDhOd7sbc2q00JwODs9az/3xdMPCVmi/Xp1TLqPHNKen
	AB8h5fkgGYMJIYCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WpfI1Oke;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2NZ3Ygj5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718382651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mDenGiS4mqkZjRoBJtdVazrDHVboB46YT+YEJgnd3hc=;
	b=WpfI1OkeL+SwhCF7JVwhBZHQHFWk+YYuSy7TRfwIT+T7RQBGhk9UvzUPACqEBID9RbLWf/
	ghS6I3jetgf4DMkPgGC/HH5tio+NPfBG9pi86dCrKmSwod7Tk8nJPol5e3tQY3Q3ikqKPx
	axnH/3M5ZxpEu1N+5oIJDu1D1sUOeBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718382651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mDenGiS4mqkZjRoBJtdVazrDHVboB46YT+YEJgnd3hc=;
	b=2NZ3Ygj5aCpxI/PSa/jPzgVOz9ZDhOd7sbc2q00JwODs9az/3xdMPCVmi/Xp1TLqPHNKen
	AB8h5fkgGYMJIYCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7095613AAF;
	Fri, 14 Jun 2024 16:30:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IM8uFTtwbGa7cwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 14 Jun 2024 16:30:51 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
Date: Fri, 14 Jun 2024 12:30:44 -0400
Message-ID: <20240614163047.31581-1-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB750206A0
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spam-Flag: NO
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
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

io_uring holds a reference to the file and maintains a
sockaddr_storage address.  Similarly to what was done to
__sys_connect_file, split an internal helper for __sys_bind in
preparation to supporting an io_uring bind command.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
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
2.45.2


