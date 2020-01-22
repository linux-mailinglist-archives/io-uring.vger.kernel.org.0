Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6905A145939
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 17:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAVQCg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 11:02:36 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:45539 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgAVQCf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 11:02:35 -0500
Received: by mail-io1-f67.google.com with SMTP id i11so7091461ioi.12
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 08:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RfiRzl729pSQkcVcyHTXNJXLD8uT/Zh0KX5h0rH8OOE=;
        b=vakRRzM6mp5LxH8vKW6oHGZimpFSEsQFbGJ7T+Yxgu7ADDQz1a2vV9QRxGnAIwuLoy
         iky/5qRABzmD3qGnUTD8OfmZVFrDtThwmmZSEpfVP6VNmJbrwaBh1+qffK6ZMeeUgimm
         2uthoDB0PbAD66EImrovtlYMPIsE7cpsxSPXvaqhnlM1TjzbnC4huijpLCMOLGQX/Gk5
         mDhVuUTRaX7fJfdCMLBiL+i6KKtvu+v6sRvN7UsWJooUxZylTG5JU3GPT+esI4TQ7a49
         MqDavwfrCu3dNlOjXnJ7ws1Ng1Z1GDIXrQ8in4MdvrYO5YuMMck5n7ajzb4pkCBOdO/5
         pLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RfiRzl729pSQkcVcyHTXNJXLD8uT/Zh0KX5h0rH8OOE=;
        b=rpKiHoKkA2QJbKSVkYy/QY3Cr/mpNwNs9siZg9r4c38YANZjpbV9XAAYEJTi0aOF5p
         yFYOFvMpsa4lpyblDlk6VGAUak+xRJgFeidmv7uf6Fz9DeWN6WZETH/a2uKGAKunFEQt
         czs298uw6/jLaa5OPCRh+Vw16e/a7AtOr2KR3o/XeDtWSKqvZ+KpoLgNaltLpdG8gghp
         cET9DmHkK4Gp/H4Ux1sA10ViMljks/0zsq4GF9Hl7imYypOAIT2thTJB2O2w8nP7kY3S
         Cx5M9O2X6OIuNkBQbrfkOx4jA/GcucAMktN0VlH5RZYrsUDXjECZ9gBMM4Pp4/hCd0HL
         EgBQ==
X-Gm-Message-State: APjAAAWFUW20pKY66PYVaxRsn02KZM2mLQORAWkWFktg6KbAJcNXuM1n
        hqP9+NiUapVrIoCPOvGM0j9M8fOeBvM=
X-Google-Smtp-Source: APXvYqwcHbx14UU4Jim+53nQYlukexzLCZstfnvhUWW2VP4HMjmoJJnAF4utcX6rlK/FqwSe3zZ2yA==
X-Received: by 2002:a5d:9499:: with SMTP id v25mr7285079ioj.66.1579708954891;
        Wed, 22 Jan 2020 08:02:34 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v206sm796924iod.41.2020.01.22.08.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:02:34 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] eventpoll: abstract out epoll_ctl() handler
Date:   Wed, 22 Jan 2020 09:02:29 -0700
Message-Id: <20200122160231.11876-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122160231.11876-1-axboe@kernel.dk>
References: <20200122160231.11876-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 67a395039268..cd848e8d08e2 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2074,27 +2074,15 @@ SYSCALL_DEFINE1(epoll_create, int, size)
 	return do_epoll_create(0);
 }
 
-/*
- * The following function implements the controller interface for
- * the eventpoll file that enables the insertion/removal/change of
- * file descriptors inside the interest set.
- */
-SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
-		struct epoll_event __user *, event)
+static int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds)
 {
 	int error;
 	int full_check = 0;
 	struct fd f, tf;
 	struct eventpoll *ep;
 	struct epitem *epi;
-	struct epoll_event epds;
 	struct eventpoll *tep = NULL;
 
-	error = -EFAULT;
-	if (ep_op_has_event(op) &&
-	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
-		goto error_return;
-
 	error = -EBADF;
 	f = fdget(epfd);
 	if (!f.file)
@@ -2112,7 +2100,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 
 	/* Check if EPOLLWAKEUP is allowed */
 	if (ep_op_has_event(op))
-		ep_take_care_of_epollwakeup(&epds);
+		ep_take_care_of_epollwakeup(epds);
 
 	/*
 	 * We have to check that the file structure underneath the file descriptor
@@ -2128,11 +2116,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 * so EPOLLEXCLUSIVE is not allowed for a EPOLL_CTL_MOD operation.
 	 * Also, we do not currently supported nested exclusive wakeups.
 	 */
-	if (ep_op_has_event(op) && (epds.events & EPOLLEXCLUSIVE)) {
+	if (ep_op_has_event(op) && (epds->events & EPOLLEXCLUSIVE)) {
 		if (op == EPOLL_CTL_MOD)
 			goto error_tgt_fput;
 		if (op == EPOLL_CTL_ADD && (is_file_epoll(tf.file) ||
-				(epds.events & ~EPOLLEXCLUSIVE_OK_BITS)))
+				(epds->events & ~EPOLLEXCLUSIVE_OK_BITS)))
 			goto error_tgt_fput;
 	}
 
@@ -2192,8 +2180,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	switch (op) {
 	case EPOLL_CTL_ADD:
 		if (!epi) {
-			epds.events |= EPOLLERR | EPOLLHUP;
-			error = ep_insert(ep, &epds, tf.file, fd, full_check);
+			epds->events |= EPOLLERR | EPOLLHUP;
+			error = ep_insert(ep, epds, tf.file, fd, full_check);
 		} else
 			error = -EEXIST;
 		if (full_check)
@@ -2208,8 +2196,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	case EPOLL_CTL_MOD:
 		if (epi) {
 			if (!(epi->event.events & EPOLLEXCLUSIVE)) {
-				epds.events |= EPOLLERR | EPOLLHUP;
-				error = ep_modify(ep, epi, &epds);
+				epds->events |= EPOLLERR | EPOLLHUP;
+				error = ep_modify(ep, epi, epds);
 			}
 		} else
 			error = -ENOENT;
@@ -2231,6 +2219,23 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	return error;
 }
 
+/*
+ * The following function implements the controller interface for
+ * the eventpoll file that enables the insertion/removal/change of
+ * file descriptors inside the interest set.
+ */
+SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
+		struct epoll_event __user *, event)
+{
+	struct epoll_event epds;
+
+	if (ep_op_has_event(op) &&
+	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
+		return -EFAULT;
+
+	return do_epoll_ctl(epfd, op, fd, &epds);
+}
+
 /*
  * Implement the event wait interface for the eventpoll file. It is the kernel
  * part of the user space epoll_wait(2).
-- 
2.25.0

