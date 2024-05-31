Return-Path: <io-uring+bounces-2041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4E38D6B57
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABFD11F2AD97
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 21:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5363B7F7EF;
	Fri, 31 May 2024 21:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sNnEzSI7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LQMET5B9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sNnEzSI7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LQMET5B9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8E37D071;
	Fri, 31 May 2024 21:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717190012; cv=none; b=BNbgvm6URMoSH3Y+zdJH8vsfouknONlg0qYjuv3PEhjzfmLyWH10qPIXAWzTJasL0IV28IMZK17mT7ZjDBxU8B0Yyxvzx3vA1y5VZm1cr9gggGuXGTyhbq7P2Hic30yCKlp3s8sQxJTfxX7RJxc3hZbMU6zd8Ir/RxVRj19vtT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717190012; c=relaxed/simple;
	bh=yy0WGakJqZBI/XQi1xLky+DHESkXWVM0wo+2AWoMvUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLTcFWPrDviKxzU4jzggka/AP3hrHZ/KjNayjgTSDSNli+Bwu7Cb6Qpa8RmUm7vEqjrcuTAFyowr2uA+zni/zoN6MTGiQsz/V+pmgKcCs2ERiak5vIT1ziJnbTw6oqbOA02lZQ8aO0IRL6TieavkDjMtHXwvduLOEJZubpfGtzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sNnEzSI7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LQMET5B9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sNnEzSI7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LQMET5B9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B93C31F396;
	Fri, 31 May 2024 21:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717190008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wd8MFmGoUMKR6pTBfoN7/9oR8fdeIvf2Bmw6iPNZbU4=;
	b=sNnEzSI7eec0gwL7JnUbm868q8Paug6Qdp3vCQcvlKm8pvjxJA6IWBE2/es6Wb2BSrfW9U
	h6CnCG69NV+g4fBA9EkmJI/SDo1PgDDE9u/pv3siMZDkB5xrr/m7ncda4AU2zQdD95K16a
	+H4RITjZnCBiUglwVOFqEWer1r+LekU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717190008;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wd8MFmGoUMKR6pTBfoN7/9oR8fdeIvf2Bmw6iPNZbU4=;
	b=LQMET5B9LhEGdeFFQzq+6/DHu/WLyyxqsj257Vl09v1T7qFfNFCaebA57iN9+9XOh5gMfn
	LZibSwKNhb3b0ICA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717190008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wd8MFmGoUMKR6pTBfoN7/9oR8fdeIvf2Bmw6iPNZbU4=;
	b=sNnEzSI7eec0gwL7JnUbm868q8Paug6Qdp3vCQcvlKm8pvjxJA6IWBE2/es6Wb2BSrfW9U
	h6CnCG69NV+g4fBA9EkmJI/SDo1PgDDE9u/pv3siMZDkB5xrr/m7ncda4AU2zQdD95K16a
	+H4RITjZnCBiUglwVOFqEWer1r+LekU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717190008;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wd8MFmGoUMKR6pTBfoN7/9oR8fdeIvf2Bmw6iPNZbU4=;
	b=LQMET5B9LhEGdeFFQzq+6/DHu/WLyyxqsj257Vl09v1T7qFfNFCaebA57iN9+9XOh5gMfn
	LZibSwKNhb3b0ICA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8303B137C3;
	Fri, 31 May 2024 21:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mqb0GXg9Wma9agAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 31 May 2024 21:13:28 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 3/5] net: Split a __sys_listen helper for io_uring
Date: Fri, 31 May 2024 17:12:09 -0400
Message-ID: <20240531211211.12628-4-krisman@suse.de>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.80
X-Spam-Flag: NO

io_uring holds a reference to the file and maintains a sockaddr_storage
address.  Similarly to what was done to __sys_connect_file, split an
internal helper for __sys_listen in preparation to support an
io_uring listen command.

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
2.44.0


