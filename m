Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5B1145A12
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 17:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAVQmu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 11:42:50 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35331 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgAVQmu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 11:42:50 -0500
Received: by mail-io1-f66.google.com with SMTP id h8so7306022iob.2
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 08:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BAFfS5OIp3jxEUeDeCIVOeYSwdTU3d0hKCDzqFsPnqo=;
        b=Io0n3sYNpwQM8CdCxWnopIOeOP5krysVQuURUiwa4PYvS+MRY9UCoyemshpeqG8KMn
         vs9QU5zcdwO/jeOblKk1AI0Fjw+m4RRBgp/A2x3AbG5QUDP9YrmoKycJyCO6Ar7q7K0A
         /uyBjTqChU0AKeEXfrZJJgg4HweZspeytK+aYzSR2F+5oI9Za7Cunmg73/0xAvs25ofk
         DV7O+eGbqrDlDjahQugG1jE23PST6ARM9Hs3r6qcvVIFklMX39AtdkecH3H0YzsY5gr2
         J8GtNB6Xr4WLPUipdJiRWH/N3mS2ebfKN5L6ycGOWHsm+u7ghka4j+XKXh+xA+BaUusa
         WSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BAFfS5OIp3jxEUeDeCIVOeYSwdTU3d0hKCDzqFsPnqo=;
        b=qUIcfNssR3h4zGToexVPY/ahiVUZHtsTeId7+uafbupr9GgX8brxM1CHpGP/8R6iCL
         JFmBRtGJQ1Jf35GGK4EE48cXq38gzk6j9fl+jCWrlZHQuw6VpzzpxJZ65W/TQa9mWSKo
         YGPabRYX5jq6mo5QxoTUEzEaH0DUbunjHx1n/Hip+CrFwIBRImG5q8wlKhKxTnwisVs/
         nNvasDm02mm1Sg0Usccyh3UFs7k/zIR82CW6xN5kNZREWLwKHiR/rWB6T9gGiXiM2p4b
         61MFlBfPkGYB3sdlByMEw6e09XilhZO6bvcjJchuutqNJ/dQjj5HRBTGQFBDKdnfHF50
         dFuw==
X-Gm-Message-State: APjAAAUp2JjF0V0vajhm9TpFLmE+W9jv+rMzXo5wC9Y37488UD/cmyAC
        lZMF4NLSlxmrGki7cVEFU5BdOx/VIac=
X-Google-Smtp-Source: APXvYqxu2DqtaxjVNoRDx51OWRR3Ym3l6DHf/aadfHj8lW0h1xOcIGJ1jzKSRUIa4u6hglBVJ/qxIQ==
X-Received: by 2002:a6b:ca43:: with SMTP id a64mr7366905iog.217.1579711368999;
        Wed, 22 Jan 2020 08:42:48 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o6sm14599681ilc.76.2020.01.22.08.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:42:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jannh@google.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] eventpoll: support non-blocking do_epoll_ctl() calls
Date:   Wed, 22 Jan 2020 09:42:43 -0700
Message-Id: <20200122164244.27799-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122164244.27799-1-axboe@kernel.dk>
References: <20200122164244.27799-1-axboe@kernel.dk>
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
 fs/eventpoll.c            | 46 ++++++++++++++++++++++++++++-----------
 include/linux/eventpoll.h |  9 ++++++++
 2 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cd848e8d08e2..b041b66002db 100644
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
+	if (mutex_trylock(mutex))
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
-			full_check = 1;
 			mutex_unlock(&ep->mtx);
-			mutex_lock(&epmutex);
+			error = epoll_mutex_lock(&epmutex, 0, nonblock);
+			if (error)
+				goto error_tgt_fput;
+			full_check = 1;
 			if (is_file_epoll(tf.file)) {
 				error = -ELOOP;
 				if (ep_loop_check(ep, tf.file) != 0) {
@@ -2161,10 +2172,19 @@ static int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds)
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
+				if (error) {
+					mutex_unlock(&ep->mtx);
+					goto out_del;
+				}
 			}
 		}
 	}
@@ -2233,7 +2253,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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

