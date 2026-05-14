Return-Path: <io-uring+bounces-13335-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNqnFRHZBWoncQIAu9opvQ
	(envelope-from <io-uring+bounces-13335-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 56BBE542ED2
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F355A305A7AD
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C0E3FA5E9;
	Thu, 14 May 2026 14:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="VIpR1JYE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6741D3FA5D6
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778767718; cv=none; b=DE5fC0RVF9N0wihdHCsGOfUBpKR75UAyTKBGOrrbSjf9IBnsQXuFSRru/5f52pFfRYBnHf9yrfO5A+LonTYb8oSl0hP8wWq7GH2RiLUgFHDP5+8EFIC1GgIBGELFw9E08TpzeZ/eoHX/LVB1C+ZwvrsDsgzoN38Xk8L6cijB29k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778767718; c=relaxed/simple;
	bh=Nc+WVvDte2mveIsO0K6wCo0rdU0u+HckbZJiXE1v2ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFBcIKbuccZbRkOEowoFuZwj7bZUDVv3ABWKwe9uJeXqXlPlh/kK1kklMWycXuXz63arqZVxY0aR1vMr8B5FdN0bh85DSjktSwfYmEUqXsmYLbqnglCLbGRmdOwp34tz0Yqw3MyWysqe7JSQ1r8MWPq91TuiQGIuWqv+t9Q84PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=VIpR1JYE; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-47c7b282d73so4635420b6e.3
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778767707; x=1779372507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pe11u6t4Qq4bwvnqoZIg8PmIgRIRXQGcxkxrBifqzak=;
        b=VIpR1JYEdqbWvSiSOIPhuU7CchI8ZbZzDY+AoRHbtCxqTn45NiAPkfK6qCCSwVkJMF
         q3I8jh6ntoC9Rtwla6TwubzsUWSH8504VPA7cjIcnu4yKJV9ndLVByB2lGrkYFYqYNJ4
         wQiDAe5vOLN6VGS72QsqTc+KmG/A+qvn9GJsXGVBUFpdKIlCQG22O78XRn1gZgpc3/q+
         EuolwU4XYn2uyPOu2zdpfeIA7O1g0Dm4BVE9bRn/MXbs6ST5jVbzLh57NRnVf10UAkh+
         0K7MtJj3dzHN6dmkSbIXUcPVi1yTpxEavd1dwZ1pZjYPrT0agkUFeTICpwGFjCmeJxjW
         gM9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778767707; x=1779372507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pe11u6t4Qq4bwvnqoZIg8PmIgRIRXQGcxkxrBifqzak=;
        b=gMUdfK8V7y+4ZaAtkZ2lWvOF9XnPe5tcsIvFpg8a4vl2caYYHIY/6XK1d1zHzqDg+4
         dDsPUOz7/zaK/A8MUFOrAmLk+n9Lc69d4EKn0h9fC0X5lXMlcmYeWPhYfVOq92/i/frM
         ZnIe/dQV+qodMdr64tYEWE9OwUBG927JXzxR/Bfs9+CsqMnf96QeaYH6vOc/EDFfkJDj
         BeAloUgqzfGuKKATgVvCDMY+Z+zlRRVYISfALAOXgYfHcTrbbt3iDqk10sLX5MxHtT2N
         8smbSqANWHpMaLzhMx+PAFF9DgIOyojAiNahvT9sookU9pMH5BJ1fqtBipsUVLqv5Pkc
         uHMQ==
X-Gm-Message-State: AOJu0YwmCy4q4XlMkvUbbrHWDMoI1USDFvBe8KDGppIN44QBjBDGs0r9
	GPG1Wjo1PgC/DGaHihP2BIIsjDz/RFG4QFVIAvj/+eYqjSz/qomd5seLzlAx4VjBn7ujfTFY3ok
	dfAyK
X-Gm-Gg: Acq92OEv0Ak2g6NUZAnvrtAdiNqG5moTCgkns6waYQmUip7n5kXRNMOfDe3cuUcVpsT
	gHncfBYfvJQButNW5CSxXDupPRl06ZNt336nRYAwkxLkVJjMXdiczXbKjyJ1M908bSxcmOJa62r
	c1jKG/mzaPwQom2x4Dy9Z0Dp2o9e5MYCqk/qQrNRa3uXTubadFlCbcKkDzVzV4IdoGOPb0VQQmH
	n48AbDcAycC67HdhqjECCFDFsyTal92Yh7dOHivSRESse2j9psZJKMEH4AkKErdZuTHGkiPcDQ2
	xpvqeRw0k7y+3CMcgfc9AXP14MpBTlaI0X28j4orqzxC9IxGiDDDVQU1By+uf99B8F5Hv14e0Ae
	xOuJjOPhouTCdB0uxtmpwFuo8CmuoyDqejVdhYXTbern4B4yeDL96jaPRNE6ME1fnKt1dX+ZAyv
	gNpbS2uyIqOdf424G/VsnVki7KdFJD79KxiED7z1Gn2VPix1OD5skdJS36EVNOyVXYU/CK03Zu7
	aJZFQ==
X-Received: by 2002:a05:6808:1816:b0:479:ffcf:52d7 with SMTP id 5614622812f47-482b2dd218bmr5026680b6e.46.1778767706744;
        Thu, 14 May 2026 07:08:26 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482d379f062sm1394956b6e.6.2026.05.14.07.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:08:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] eventpoll: add file based control interface
Date: Thu, 14 May 2026 08:07:19 -0600
Message-ID: <20260514140817.623026-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514140817.623026-1-axboe@kernel.dk>
References: <20260514140817.623026-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 56BBE542ED2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13335-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:email,kernel.dk:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

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


