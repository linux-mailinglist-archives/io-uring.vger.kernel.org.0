Return-Path: <io-uring+bounces-13211-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cqhWJqgM92lTbgIAu9opvQ
	(envelope-from <io-uring+bounces-13211-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F2D4B4F7B
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C25BB3013AAA
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 08:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B17B3AE198;
	Sun,  3 May 2026 08:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="OBCkbYsL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96712264A9
	for <io-uring@vger.kernel.org>; Sun,  3 May 2026 08:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798280; cv=none; b=HBf+ttrMla7uvf35JzAl2hX5I6qAckeoI7RMB562g/ga0XXQLfkmXsrERuGzN9sFDvjxNG45t5NL7qjIQ9cNSZF9IIOjxJn3DX6FQhdCR5OFekxHec9Ke24IYlRlftoMqVPbEaDigeNFLHFleIQLz2Eu/sTxpO3GluWpBEb7IEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798280; c=relaxed/simple;
	bh=Nc+WVvDte2mveIsO0K6wCo0rdU0u+HckbZJiXE1v2ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmmU8KY4fqZQnP4ATCRXawymQnkhSr/GnreirFztIXG3gqJhFtnZk6SA56gyRXQ7iMVl55gjw441ASkotDoFtNwK0sw8tEMIyzU8IZk08C5Ki+V9zBzn5uNFuSqVYmMEgs5m/aTWikLFhTlEjGSkqdC2QrxLlARxGlvdMr31brQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=OBCkbYsL; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so6174909a12.2
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 01:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777798277; x=1778403077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pe11u6t4Qq4bwvnqoZIg8PmIgRIRXQGcxkxrBifqzak=;
        b=OBCkbYsLIzspMeGCVjPRRJV/npyK0LGpmblHR5wgrUYm11zFe/p9PtZdyUHMykHtNr
         lXPOV7x66gZcS7S8eeDOWWTT8FqBVaQffEnlTVU5FjDK3x+AslUOtLG7noyYHM076DYH
         14v6GVzPas5T7ZkJbGGyT+jK6t68ZicX6F0ve3KkhRCJ7GDbnGUOYrzu/MKLPHP0HtSJ
         Sor6F0u1x97P7em2gl1Sr0I6cE6o/BiKnHAsL/QFvCMCAp7ZZnVG+VW0Y1hzZpT8oMLc
         yz+VR/3IKoIeWkCZ1A6OyebkpDC8MnikAC2OER3XImQbZfGRwLJBxZXCg7i26mcd3rNL
         X85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777798277; x=1778403077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pe11u6t4Qq4bwvnqoZIg8PmIgRIRXQGcxkxrBifqzak=;
        b=OZ5DqMXKGpWAGv/NV6O67jq6/bYEkiGPgIB9FqZfQVErLyJkN8FAsdwoEWQWvmxV6W
         WiSI/guTYx8Lz1GaHfxAZBEk4uJw1CpKqQNpXKRVX6NewetX3A6zZDKVFaQNxrRZFkFl
         otI0TuKi13yZ2QT0fmgv0ko8MoeOykyzJbAuKih3ZlXosdPRrK6nprqMqfjF4zpxTcPO
         8JGbhybx1G/F01jf3R3vnBf9DBGcgOtIlSyLjz1pOY54A2bQz06jjcNE+xR96UAK5r51
         JbyNw2bjGQq3C5Mm4mc8I3VrcBzXyxANDzy9oe4B1kDjQYrYxTcy34E70P7TYW8XkMFD
         5lsA==
X-Gm-Message-State: AOJu0YxxrlQHvSApWNhdanrPWdJo+YPcSMrr1F2RJ4BM+lKzGR1u7uJp
	eL3nNi/g9Z+dS6M4WfT+tiol1zJFAZpCGkuwAsmzvYvLxJSkiaaLZ4cVoNE1SKypXlN9Daz41+B
	h8Oa+I+emdw==
X-Gm-Gg: AeBDieszUWSF4aMEfBeFayVjnUF+flZ3bKoGGyrz6Cr889r8WsaSoOj8H1GDcAcR0VH
	Tt18adRZXEb8Vy5Bh4bVx7zQm0k3qP7vknUj9xR6TDIo4DRnMRfu0gfavZD+z5BOaSoqjEpQYlE
	cowc8xJm1l2KBNcdLf6xTislMm5p8DEkmVqmZUK7DvrABTwuPO+bfzlOx3ft46pyU50WClADGE+
	zTCw9UqyLGsku4lvsRlmj09JcjX6bAwxU3/HVn60fDQ0h9vCleLQFeUXYo+KClv2Hosr4/y7Obf
	qx0WEW1g8QFWiZAc8bXEU0UdL3Udmoxn/droSmb3zCi+98wY1FWHoxJkg8FLHsov2mvmYnFLmIv
	0Y/GBVLShmvzdOzRwRa8G2u6Nm2TvAxKOPJyM/mSq6g+D+fF+KTvcYHyI/6A6t2iMgD3Gznuu81
	U4Y4bET/00LdSwvKsILuERTR+e4J8ekbesuu7DW62ClW8oDDm+fuC0mVSpkTkbZhwZ5bDrJZDzH
	nDQXtOugQ==
X-Received: by 2002:a05:6402:21d2:b0:67c:1fd5:32ca with SMTP id 4fb4d7f45d1cf-67c1fd535d2mr1506693a12.21.1777798276822;
        Sun, 03 May 2026 01:51:16 -0700 (PDT)
Received: from m2max ([77.241.229.232])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b85e292c2sm2368936a12.1.2026.05.03.01.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 01:51:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] eventpoll: add file based control interface
Date: Sun,  3 May 2026 02:49:14 -0600
Message-ID: <20260503085101.112698-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260503085101.112698-1-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A7F2D4B4F7B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13211-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]

Add do_epoll_ctl_file(), which takes a pre-resolved epoll file and a
struct epoll_filefd for the target rather than two integer file
descriptors. do_epoll_ctl() remains as a thin wrapper.

In preparation for using the file based interface from io_uring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c            | 62 ++++++++++++++++++++-------------------
 include/linux/eventpoll.h |  7 +++++
 2 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9ea6a2bd3d87..1c7001866340 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -99,11 +99,6 @@
 
 #define EP_ITEM_COST (sizeof(struct epitem) + sizeof(struct eppoll_entry))
 
-struct epoll_filefd {
-	struct file *file;
-	int fd;
-} __packed;
-
 /* Wait structure used by the poll hooks */
 struct eppoll_entry {
 	/* List header used to link this structure to the "struct epitem" */
@@ -2225,30 +2220,17 @@ static inline int epoll_mutex_lock(struct mutex *mutex, int depth,
 	return -EAGAIN;
 }
 
-int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
-		 bool nonblock)
+int do_epoll_ctl_file(struct file *f, int op, struct epoll_filefd *tf,
+		      struct epoll_event *epds, bool nonblock)
 {
 	int error;
 	int full_check = 0;
 	struct eventpoll *ep;
 	struct epitem *epi;
 	struct eventpoll *tep = NULL;
-	struct epoll_filefd efd;
-
-	CLASS(fd, f)(epfd);
-	if (fd_empty(f))
-		return -EBADF;
-
-	/* Get the "struct file *" for the target file */
-	CLASS(fd, tf)(fd);
-	if (fd_empty(tf))
-		return -EBADF;
-
-	efd.file = fd_file(tf);
-	efd.fd = fd;
 
 	/* The target file descriptor must support poll */
-	if (!file_can_poll(fd_file(tf)))
+	if (!file_can_poll(tf->file))
 		return -EPERM;
 
 	/* Check if EPOLLWAKEUP is allowed */
@@ -2261,7 +2243,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	 * adding an epoll file descriptor inside itself.
 	 */
 	error = -EINVAL;
-	if (fd_file(f) == fd_file(tf) || !is_file_epoll(fd_file(f)))
+	if (f == tf->file || !is_file_epoll(f))
 		goto error_tgt_fput;
 
 	/*
@@ -2272,7 +2254,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	if (ep_op_has_event(op) && (epds->events & EPOLLEXCLUSIVE)) {
 		if (op == EPOLL_CTL_MOD)
 			goto error_tgt_fput;
-		if (op == EPOLL_CTL_ADD && (is_file_epoll(fd_file(tf)) ||
+		if (op == EPOLL_CTL_ADD && (is_file_epoll(tf->file) ||
 				(epds->events & ~EPOLLEXCLUSIVE_OK_BITS)))
 			goto error_tgt_fput;
 	}
@@ -2281,7 +2263,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	 * At this point it is safe to assume that the "private_data" contains
 	 * our own data structure.
 	 */
-	ep = fd_file(f)->private_data;
+	ep = f->private_data;
 
 	/*
 	 * When we insert an epoll file descriptor inside another epoll file
@@ -2302,16 +2284,16 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	if (error)
 		goto error_tgt_fput;
 	if (op == EPOLL_CTL_ADD) {
-		if (READ_ONCE(fd_file(f)->f_ep) || ep->gen == loop_check_gen ||
-		    is_file_epoll(fd_file(tf))) {
+		if (READ_ONCE(f->f_ep) || ep->gen == loop_check_gen ||
+		    is_file_epoll(tf->file)) {
 			mutex_unlock(&ep->mtx);
 			error = epoll_mutex_lock(&epnested_mutex, 0, nonblock);
 			if (error)
 				goto error_tgt_fput;
 			loop_check_gen++;
 			full_check = 1;
-			if (is_file_epoll(fd_file(tf))) {
-				tep = fd_file(tf)->private_data;
+			if (is_file_epoll(tf->file)) {
+				tep = tf->file->private_data;
 				error = -ELOOP;
 				if (ep_loop_check(ep, tep) != 0)
 					goto error_tgt_fput;
@@ -2327,14 +2309,14 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	 * above, we can be sure to be able to use the item looked up by
 	 * ep_find() till we release the mutex.
 	 */
-	epi = ep_find(ep, &efd);
+	epi = ep_find(ep, tf);
 
 	error = -EINVAL;
 	switch (op) {
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds->events |= EPOLLERR | EPOLLHUP;
-			error = ep_insert(ep, epds, &efd, full_check);
+			error = ep_insert(ep, epds, tf, full_check);
 		} else
 			error = -EEXIST;
 		break;
@@ -2369,6 +2351,26 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 		mutex_unlock(&epnested_mutex);
 	}
 	return error;
+
+}
+
+int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
+		 bool nonblock)
+{
+	struct epoll_filefd efd;
+
+	CLASS(fd, f)(epfd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	/* Get the "struct file *" for the target file */
+	CLASS(fd, tf)(fd);
+	if (fd_empty(tf))
+		return -EBADF;
+
+	efd.file = fd_file(tf);
+	efd.fd = fd;
+	return do_epoll_ctl_file(fd_file(f), op, &efd, epds, nonblock);
 }
 
 /*
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 7bf30e9f90d7..4a6fe989810b 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -61,6 +61,13 @@ static inline void eventpoll_release(struct file *file)
 	eventpoll_release_file(file);
 }
 
+struct epoll_filefd {
+	struct file *file;
+	int fd;
+} __packed;
+
+int do_epoll_ctl_file(struct file *f, int op, struct epoll_filefd *tf,
+		      struct epoll_event *epds, bool nonblock);
 int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 		 bool nonblock);
 int is_file_epoll(struct file *f);
-- 
2.53.0


