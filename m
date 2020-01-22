Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C65C14593D
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 17:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgAVQCh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 11:02:37 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33546 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAVQCg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 11:02:36 -0500
Received: by mail-il1-f193.google.com with SMTP id v15so5562857iln.0
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 08:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AA0wwvnZ0n7WrhC9fHpAGgP3kCVdarewU7fTNKHf4vo=;
        b=0H/shxhDH59wMOxesQPvrDjl4FFa3J+m4nL2lmrNnii35gnausf6qcIR1qKVyzVQla
         PYNxtpP1C7/+l2tphwffssWW/Q0vGMFwDSPhXC3vsaazpFg2veEUYPiOhlx3NPln4jDZ
         TVB/ZG+CNBGX3priGF4NMP2ShNa8rdk24z7mkGPlc5HX3USTp5/9aaPfXwijftQW7c01
         NsF6pxF5ScY8hSZhjZ6Eq4NYpX7FJiRHQfA6gNeKAgGrVz/DOa9VjsN0klyJQTedOsN7
         LYNRD+/CIhPRe/S52R1Yv2GbiGd97uxMwCoWgKPskjngNYVNaKt13jq1yfjaeuHd7u0x
         ZeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AA0wwvnZ0n7WrhC9fHpAGgP3kCVdarewU7fTNKHf4vo=;
        b=UO42hlC1sMXaSxseOMtJYf6xNwZc+jue5Jnqvb2WNWtG+vTxQPm8LEo/JVJd65NbD8
         w4ccXlX30RFiVRef++Kf4o49f5h52eDV8kT6XU5SCsQ+WRplwUYqiSFbDkVv3B/vDqI4
         p/EIUxwl3srXaeRBUxbXM4iI0aq5unomnQuCsUnfsSpDsKCd2Q4r/NK1LKvTKCS/6q6J
         cdUVLU+k8GBFpQPvjAy5ILuUSqvspwIlXqT0jGZ+SMsB6PNx8wY4ifMRgTwqZHQgWSdt
         WxGg93jy3QT8yr7gzXPpM8AEvkdzdHgjelNk92ViRd+s+KKY6FkPH3XvKTRfyDmm1e11
         TeHw==
X-Gm-Message-State: APjAAAVcIJId2sMx34hJ+/DWAb73n7IQEdm6ai2KQYgmPaEbv3VyzW8o
        qvobfgIMBwloNWDtPHQ4cvOFO0I9ZDE=
X-Google-Smtp-Source: APXvYqyxzuH48HGZqrrug9el5aUKeMAz9hgaD7zTffei2y597qUlMlA4wHMTMSSmUeNtc91J/df1Sg==
X-Received: by 2002:a05:6e02:f0f:: with SMTP id x15mr8446354ilj.298.1579708955822;
        Wed, 22 Jan 2020 08:02:35 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v206sm796924iod.41.2020.01.22.08.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:02:35 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] eventpoll: support non-blocking do_epoll_ctl() calls
Date:   Wed, 22 Jan 2020 09:02:30 -0700
Message-Id: <20200122160231.11876-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122160231.11876-1-axboe@kernel.dk>
References: <20200122160231.11876-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Also make it available outside of epoll, along with the helper that
decides if we need to copy the passed in epoll_event.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c            | 42 ++++++++++++++++++++++++++++-----------
 include/linux/eventpoll.h |  9 +++++++++
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cd848e8d08e2..162af749ea50 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -354,12 +354,6 @@ static inline struct epitem *ep_item_from_epqueue(poll_table *p)
 	return container_of(p, struct ep_pqueue, pt)->epi;
 }
 
-/* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
-static inline int ep_op_has_event(int op)
-{
-	return op != EPOLL_CTL_DEL;
-}
-
 /* Initialize the poll safe wake up structure */
 static void ep_nested_calls_init(struct nested_calls *ncalls)
 {
@@ -2074,7 +2068,20 @@ SYSCALL_DEFINE1(epoll_create, int, size)
 	return do_epoll_create(0);
 }
 
-static int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds)
+static inline int epoll_mutex_lock(struct mutex *mutex, int depth,
+				   bool nonblock)
+{
+	if (!nonblock) {
+		mutex_lock_nested(mutex, depth);
+		return 0;
+	}
+	if (!mutex_trylock(mutex))
+		return 0;
+	return -EAGAIN;
+}
+
+int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
+		 bool nonblock)
 {
 	int error;
 	int full_check = 0;
@@ -2145,13 +2152,17 @@ static int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds)
 	 * deep wakeup paths from forming in parallel through multiple
 	 * EPOLL_CTL_ADD operations.
 	 */
-	mutex_lock_nested(&ep->mtx, 0);
+	error = epoll_mutex_lock(&ep->mtx, 0, nonblock);
+	if (error)
+		goto error_tgt_fput;
 	if (op == EPOLL_CTL_ADD) {
 		if (!list_empty(&f.file->f_ep_links) ||
 						is_file_epoll(tf.file)) {
 			full_check = 1;
 			mutex_unlock(&ep->mtx);
-			mutex_lock(&epmutex);
+			error = epoll_mutex_lock(&epmutex, 0, nonblock);
+			if (error)
+				goto error_tgt_fput;
 			if (is_file_epoll(tf.file)) {
 				error = -ELOOP;
 				if (ep_loop_check(ep, tf.file) != 0) {
@@ -2161,10 +2172,17 @@ static int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds)
 			} else
 				list_add(&tf.file->f_tfile_llink,
 							&tfile_check_list);
-			mutex_lock_nested(&ep->mtx, 0);
+			error = epoll_mutex_lock(&ep->mtx, 0, nonblock);
+			if (error) {
+out_del:
+				list_del(&tf.file->f_tfile_llink);
+				goto error_tgt_fput;
+			}
 			if (is_file_epoll(tf.file)) {
 				tep = tf.file->private_data;
-				mutex_lock_nested(&tep->mtx, 1);
+				error = epoll_mutex_lock(&tep->mtx, 1, nonblock);
+				if (error)
+					goto out_del;
 			}
 		}
 	}
@@ -2233,7 +2251,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
 		return -EFAULT;
 
-	return do_epoll_ctl(epfd, op, fd, &epds);
+	return do_epoll_ctl(epfd, op, fd, &epds, false);
 }
 
 /*
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index bc6d79b00c4e..8f000fada5a4 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -61,6 +61,15 @@ static inline void eventpoll_release(struct file *file)
 	eventpoll_release_file(file);
 }
 
+int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
+		 bool nonblock);
+
+/* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
+static inline int ep_op_has_event(int op)
+{
+	return op != EPOLL_CTL_DEL;
+}
+
 #else
 
 static inline void eventpoll_init_file(struct file *file) {}
-- 
2.25.0

