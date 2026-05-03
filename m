Return-Path: <io-uring+bounces-13209-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKCXBY4M92ktbgIAu9opvQ
	(envelope-from <io-uring+bounces-13209-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0954B4F5D
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B651B300CBE8
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 08:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D822F6904;
	Sun,  3 May 2026 08:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="mDjeIja9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDE51A0728
	for <io-uring@vger.kernel.org>; Sun,  3 May 2026 08:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798276; cv=none; b=ZFUeQ5FafmKZrffBmKQLj/M2w+yyXVOUop/9IE9W7eNhb/stFHgNOS4MR0z7oVAXElUnmKWSIXYb87mCYZfBZALkzf16LpFgsdaSDRgA6Jr22DMQJ/zrC85emN08nEbbtvQG6p3Qdx/sW5Os81lQoyDSC5APZWxPIINSIdoEQcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798276; c=relaxed/simple;
	bh=mGofTVBMLaO3SwuK3/vHb5n4xSUGiFi1EQXOYob1u64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCgJ6ALBtuZvI8YpXG3rmzaP+6i70lfgv0LAvD1u1wT5diTj50hrUay+qx1srQHi5NmIU4+VnvNR5m+jtkEshe2AHh9Ix4u/JfMsOR798iekPDJTC7pM0luaVjCEZKZBdU08JMOhoeSeakZeUYmeKmCPpGq50ycvfKTqSOCw/II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mDjeIja9; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-67b6a6bd7b8so4666619a12.0
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 01:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777798273; x=1778403073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6YdvPNRh3rTXt0GrZkLf0D/oOpREg9FdkwWTXZhhJ4=;
        b=mDjeIja9QU7WGKtSiwnhqn4m4qxkpnB9LPvUvx7ROQrGBJByMc1MZ5ifg6Dw5ec8gw
         byVIcR7/+PhXs6SVuw5rj2ynivtVK2VwSRe1GWSgp+CxVI7hZCP6x+vEcJp27S1gCT/A
         u83C/X34TRGScBmxVJJsISo41Js1F1q0RilD1c2ICUVox3ZrS1PMR+GPL0j8LqqHF1Ty
         KEkLTgTI1DAz7YU/mTGWRjCEqpa9jwZF29ih1BY253VtOzhpPMp6o95un819ADn+AccP
         2StGFOKVAWbEqj0Lk8g1wxTLhhh/53MW/TcsmHVFqWyBmRUaoZ/oJIcWbeAGSHYAYLIP
         O92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777798273; x=1778403073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h6YdvPNRh3rTXt0GrZkLf0D/oOpREg9FdkwWTXZhhJ4=;
        b=C4L4msscP0fE66BXX6CQQJH2RTf4JI3G4mD41iCbhXbqQeC1T6uOM/Hcf3F7BWC3Ka
         5rpysQwEUlW0AETFoQglyPumUoZE7/LLh0UoN8orYFJOZjd2V7MLTD4LjuHRumP24kWe
         ND6asTI2RjaqHZKMIbv8Mr4vDbBZ7Sxg8/Pen0ahe/Tfw7ZzejPB6ko5T7dapvNeP1vA
         mSHSBgxNTRXoWuojAPKsGQ6ziJt1vA7v2VgXw1t+HhY/URPYTUI96IBvCFUPm8SS0Ww/
         UlGnCfN4iw32lnXuG7gil/eUo9SGrcmORLIypr5l7WrnY+WDKDc0tpJ8ZI/xHQy0hT1C
         0YKw==
X-Gm-Message-State: AOJu0Yy8yEeKR2ZDdFthiZOB2H8zQpJOxDTJ+y49o6EetS+G3URbxuZr
	Kp/cC1crmJCeMxwB7y3aA2KSIEli9LmvK8xG3ipzloUPHWgbMCEH0sjD8iO8lT0ddbpVxDta8Va
	rRQz0mSH81A==
X-Gm-Gg: AeBDietncXDEzpEhsvQzcB3PeKpHxHDXxCE4xDzh7McvsUWlzJaNbxSnOLIOBt5iTEV
	fJ7fb3pjDjSpvRODaswrrzShA7X8QTQLKojNwVHxnXj0qa/XbDcYAudDJ1L0dG3bDTFxoHX6JJv
	OD2+0y0yqLIV40d1CKkuqYuqgaflh84BhqtCCG4HyDSa4o2mnVNsHIznA+iPBHwQHjG8uTRuS11
	X8FrXb1PbGuCnxspFy1L3FUMYQMWEBVaPkXzA1pn3h7fq3QR8rijcdlgqqcTtl/P+3FZapMOQNW
	gi0n+wDtuJ9tEplJz09MKgzwsp6toL81dicD2k4beqDQqgwlQgKf26z95IHf+mUGFrVkwQ7dttq
	BmoH24cQOLOTzhLZkAPLbYg00kGhWuSgEJWhCbLtainBv+EuP4/yxscpeHcoJUj2EZ77rzBzE17
	5UVHAQsIDdS0a6f5pChLzhjdHJA8WLDJ10VXYAscoDNi2P2x0E26+v+HcYE/5VoybT80SkjrrJy
	YNSpxKSVi8JACBjn65s
X-Received: by 2002:aa7:d798:0:b0:67b:f62c:b5a5 with SMTP id 4fb4d7f45d1cf-67bf62cb748mr1664158a12.3.1777798272450;
        Sun, 03 May 2026 01:51:12 -0700 (PDT)
Received: from m2max ([77.241.229.232])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b85e292c2sm2368936a12.1.2026.05.03.01.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 01:51:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] eventpoll: pass struct epoll_filefd through ep_find() and ep_insert()
Date: Sun,  3 May 2026 02:49:12 -0600
Message-ID: <20260503085101.112698-2-axboe@kernel.dk>
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
X-Rspamd-Queue-Id: AB0954B4F5D
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
	TAGGED_FROM(0.00)[bounces-13209-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:email]

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


