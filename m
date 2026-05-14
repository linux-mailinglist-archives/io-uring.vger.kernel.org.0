Return-Path: <io-uring+bounces-13333-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNr5GgbZBWpOcQIAu9opvQ
	(envelope-from <io-uring+bounces-13333-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B569542EBD
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8E8A930C753A
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31FD3FCB2B;
	Thu, 14 May 2026 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="kk7DGwKV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1023FBEB1
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778767715; cv=none; b=ulDx/pVomGyZw0zpjf7WmqkIyalgSxaV3G1Y/F0viZ+01D0f0ZCJYriSFXG5PG3H9RTGXMhcqXQgNLZZeLKTeoMwAquvm8yAaa1YsG3hnGR2V6Y82xUxuOtGd4Ln3EFR4j9oy00UHkB7uOmRijmtdpdufFWvJV8pioZK/jfaJuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778767715; c=relaxed/simple;
	bh=mGofTVBMLaO3SwuK3/vHb5n4xSUGiFi1EQXOYob1u64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e86QvIu83BJid4SIR04XryD2w9s/oFFZj91oTU/HlY//KaTnE3tRJRYANsBpDWGJyagTgfNN3mHs+1UPxlPBHBTobRhd+JxGZ+rwbe8aZF0/KfyIAziBPIDcsis0DLwBrQl1B+iqXgAtZ7DeMjjPVO5GiWCmWtokigeA4ivdeHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=kk7DGwKV; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-479d68a9063so3027987b6e.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778767704; x=1779372504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6YdvPNRh3rTXt0GrZkLf0D/oOpREg9FdkwWTXZhhJ4=;
        b=kk7DGwKVGhdcCPtLcRNEGptNYL0onyuHY03j/MEzfTCGM8Qq7lFq50ifCR0SzXHqD3
         lO/RV2ELxip7ycvypSPXqBwVU5RANSgn5ZKE5pw3S30Zz/p7xwFk0/D7wJ1omdQrkZOu
         ER/DA9UAQ64/rXneXOjK/fMAjDXkEhyEx8smXquh7LfJ6pUIkFMwNA9l33tPwGwSFAf2
         0A7iDWn9qR/zmhpzG1gOi/xAdzpnZk+uUPz0boQpax987RGZuBeXmLhIV7hG/fd9ddLN
         u6MTiZYG5RPqikETv8lm3+vP1BukAzU9/72y2VYrf7dhv6qTUhIiWj0c0ZSAGFr+LTHf
         OllA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778767704; x=1779372504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h6YdvPNRh3rTXt0GrZkLf0D/oOpREg9FdkwWTXZhhJ4=;
        b=TYsToHvGEGrxyLJTcn7apl+sQjMwEpUmiHadbfW7kdSvYAqECkj745feT+D3u0/ZmU
         p+Nqm8jCR4hQk1CzYGd2FHfALAlzZCFubcAW6YsJCkU/xKh2TZfGbJTMaw91qV4/HWMS
         dqQ3x+4iyYBB4dW3Wn3H0hP7C18a4xYZSL7k/v7OJCMrv8V8YPbVD36K+l5GuKJ/scY/
         BmxMAMP8W66sIF2be/z2j7hox7dBjAalBdi1gWkHStZyGiacFDxaoNByULwa+x1oDZW9
         ON0f/y5OL3jhbCiUIlBVYeI05iMjFcVR4OcSXpEA2F/3A+OOQQIv5q+wY9GxcFczLneG
         9loA==
X-Gm-Message-State: AOJu0Yy52+zUheN5ow8jYQWCTCwZZ8xME641HXkaH8Z+o5m4oOY54VOQ
	v7J86zCIZC0myBjGGeqxus66o+ykkqf3cZVSB/2nuujbOG+dWg6sAqZg17Y0aJpZ2I1yqNJeCfJ
	mbNWN
X-Gm-Gg: Acq92OESilQr3/eb4chWDxBtPWvKX2DJ6M/l0dWyLrUs9HHkH/JFdxi4/3X55+vp8sd
	XsNUVCCCvPOSQi7ufQkeUkbY/ZYWaCpbY7KWXlhWVz+ym6JxZ0AxBWSnMVg/P2YJPyYpF/qgcub
	ryiKkO+HYpBwU2UxKJVar9QZQjK/DpgcpNFyrALHkgX/dEzKtA+zRhM6J0YrxTklajMcrL/q+AU
	DzvTSHcWwiXZxMeoWCSNRkxo9TYa63/OcL014caIGJi7tO7R+oN+ZUGqSrJkc8cXpVxx7WAxw1J
	29mY9OQZl+631YAgZOmr41VT3I7tDYZj7q2HX/6XGVBg/E2v961OAAONeGiUeF5ZUKTp9mgrjBu
	QyiZ3xO+rCKPQfhu5xd1Bj2V9m539FjztSFDTrOwWJfrXbNE3oj07dtsN7Zw3oN0xBbM+/dGgfa
	kW3pG5Dxf+uBit54xgUDstLdV4Eg2mvB1M37gLqVPJvEQJmmEFfv3U6VdbZxj2paYSfhoO26L5O
	sPYPw==
X-Received: by 2002:a05:6808:6d86:b0:45f:8be:d983 with SMTP id 5614622812f47-482b2af40c0mr5228136b6e.12.1778767704119;
        Thu, 14 May 2026 07:08:24 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482d379f062sm1394956b6e.6.2026.05.14.07.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:08:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] eventpoll: pass struct epoll_filefd through ep_find() and ep_insert()
Date: Thu, 14 May 2026 08:07:17 -0600
Message-ID: <20260514140817.623026-2-axboe@kernel.dk>
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
X-Rspamd-Queue-Id: 2B569542EBD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13333-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

Have ep_find() and ep_insert() take a struct epoll_filefd rather
than a file/fd tuple. Kill off ep_set_ffd() as it's now no longer
needed.

No functional change. This is a prep patch for adding a file based
do_epoll_ctl() variant.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a3090b446af1..f464f2f39e0e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -339,14 +339,6 @@ static inline int is_file_epoll(struct file *f)
 	return f->f_op == &eventpoll_fops;
 }
 
-/* Setup the structure that is used as key for the RB tree */
-static inline void ep_set_ffd(struct epoll_filefd *ffd,
-			      struct file *file, int fd)
-{
-	ffd->file = file;
-	ffd->fd = fd;
-}
-
 /* Compare RB tree keys */
 static inline int ep_cmp_ffd(struct epoll_filefd *p1,
 			     struct epoll_filefd *p2)
@@ -1173,17 +1165,15 @@ static int ep_alloc(struct eventpoll **pep)
  * are protected by the "mtx" mutex, and ep_find() must be called with
  * "mtx" held.
  */
-static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
+static struct epitem *ep_find(struct eventpoll *ep, struct epoll_filefd *tf)
 {
 	int kcmp;
 	struct rb_node *rbp;
 	struct epitem *epi, *epir = NULL;
-	struct epoll_filefd ffd;
 
-	ep_set_ffd(&ffd, file, fd);
 	for (rbp = ep->rbr.rb_root.rb_node; rbp; ) {
 		epi = rb_entry(rbp, struct epitem, rbn);
-		kcmp = ep_cmp_ffd(&ffd, &epi->ffd);
+		kcmp = ep_cmp_ffd(tf, &epi->ffd);
 		if (kcmp > 0)
 			rbp = rbp->rb_right;
 		else if (kcmp < 0)
@@ -1564,7 +1554,7 @@ static int attach_epitem(struct file *file, struct epitem *epi)
  * Must be called with "mtx" held.
  */
 static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
-		     struct file *tfile, int fd, int full_check)
+		     struct epoll_filefd *tf, int full_check)
 {
 	int error, pwake = 0;
 	__poll_t revents;
@@ -1572,8 +1562,8 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	struct ep_pqueue epq;
 	struct eventpoll *tep = NULL;
 
-	if (is_file_epoll(tfile))
-		tep = tfile->private_data;
+	if (is_file_epoll(tf->file))
+		tep = tf->file->private_data;
 
 	lockdep_assert_irqs_enabled();
 
@@ -1590,14 +1580,14 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	/* Item initialization follow here ... */
 	INIT_LIST_HEAD(&epi->rdllink);
 	epi->ep = ep;
-	ep_set_ffd(&epi->ffd, tfile, fd);
+	epi->ffd = *tf;
 	epi->event = *event;
 	epi->next = EP_UNACTIVE_PTR;
 
 	if (tep)
 		mutex_lock_nested(&tep->mtx, 1);
 	/* Add the current item to the list of active epoll hook for this file */
-	if (unlikely(attach_epitem(tfile, epi) < 0)) {
+	if (unlikely(attach_epitem(tf->file, epi) < 0)) {
 		if (tep)
 			mutex_unlock(&tep->mtx);
 		kmem_cache_free(epi_cache, epi);
@@ -1606,7 +1596,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	}
 
 	if (full_check && !tep)
-		list_file(tfile);
+		list_file(tf->file);
 
 	/*
 	 * Add the current item to the RB tree. All RB tree operations are
@@ -2243,6 +2233,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	struct eventpoll *ep;
 	struct epitem *epi;
 	struct eventpoll *tep = NULL;
+	struct epoll_filefd efd;
 
 	CLASS(fd, f)(epfd);
 	if (fd_empty(f))
@@ -2253,6 +2244,9 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	if (fd_empty(tf))
 		return -EBADF;
 
+	efd.file = fd_file(tf);
+	efd.fd = fd;
+
 	/* The target file descriptor must support poll */
 	if (!file_can_poll(fd_file(tf)))
 		return -EPERM;
@@ -2333,14 +2327,14 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	 * above, we can be sure to be able to use the item looked up by
 	 * ep_find() till we release the mutex.
 	 */
-	epi = ep_find(ep, fd_file(tf), fd);
+	epi = ep_find(ep, &efd);
 
 	error = -EINVAL;
 	switch (op) {
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds->events |= EPOLLERR | EPOLLHUP;
-			error = ep_insert(ep, epds, fd_file(tf), fd, full_check);
+			error = ep_insert(ep, epds, &efd, full_check);
 		} else
 			error = -EEXIST;
 		break;
-- 
2.53.0


