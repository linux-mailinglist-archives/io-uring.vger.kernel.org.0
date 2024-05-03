Return-Path: <io-uring+bounces-1723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 476FF8BB569
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 034ED284FD6
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27DD358AA7;
	Fri,  3 May 2024 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BVKMnAK5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C968A53E16;
	Fri,  3 May 2024 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714770886; cv=none; b=qmNyj09XWsgJ4RMaYxdMS1jYaBkZg2etiMW7LRjM268nwfpEoosrrS8WnjDbERwRwXNkZzINvLiAVL7pBz7RR5isTiI+Ju/whWURAC7kJNr6z9ZWhtOEBHlI2rN3IbrrV6ZsWiEINj0aXuAw/c86KQhddypGAGKsgLUJwq0HxQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714770886; c=relaxed/simple;
	bh=t2ekic1Ld48bCYtZJHBOk19intmuyfbk5wIBifLYucs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otP6nbY6hhxS1vaqw7S2T541FecKKM//x719RHVzrb1NY7hVzCTn5xXORZjnQq7GmIfttvPFbsFa9j2lE9V/p+ShBiVlRm26YkiYTKQ353saiDOhnevguVSHU8oIdoN1QRizznZP/o+cJ9i/+giKx7c8IXcJbgIY5nJ7iaNjr5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BVKMnAK5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CC8C116B1;
	Fri,  3 May 2024 21:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714770885;
	bh=t2ekic1Ld48bCYtZJHBOk19intmuyfbk5wIBifLYucs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVKMnAK5TKy0dyDdE4060f5p1OqBzeHGS8SvDl2+/8iTGFzv5LnNPIT9vRV724q3y
	 z+oNYqMJVYyvqVjEcctu6QfzEcc4r+WYFrBprlzLn61HrW5Z7Zyhn2o6j0oV76F6jw
	 MEwwgAQOa8Xdv4DIYY62xpBdPYOFbnKxzrL09yBY=
From: Linus Torvalds <torvalds@linux-foundation.org>
To: keescook@chromium.org
Cc: axboe@kernel.dk,
	brauner@kernel.org,
	christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org,
	io-uring@vger.kernel.org,
	jack@suse.cz,
	laura@labbott.name,
	linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	viro@zeniv.linux.org.uk,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Date: Fri,  3 May 2024 14:11:30 -0700
Message-ID: <20240503211129.679762-2-torvalds@linux-foundation.org>
X-Mailer: git-send-email 2.44.0.330.g4d18c88175
In-Reply-To: <202405031110.6F47982593@keescook>
References: <202405031110.6F47982593@keescook>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

epoll is a mess, and does various invalid things in the name of
performance.

Let's try to rein it in a bit. Something like this, perhaps?

Not-yet-signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

This is entirely untested, thus the "Not-yet-signed-off-by".  But I
think this may be kind of the right path forward. 

I suspect the ->poll() call is the main case that matters, but there are
other places where eventpoll just looks up the file pointer without then
being very careful about it.  The sock_from_file(epi->ffd.file) uses in
particular should probably also use this to look up the file. 

Comments?

 fs/eventpoll.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 882b89edc52a..bffa8083ff36 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -285,6 +285,30 @@ static inline void free_ephead(struct epitems_head *head)
 		kmem_cache_free(ephead_cache, head);
 }
 
+/*
+ * The ffd.file pointer may be in the process of
+ * being torn down due to being closed, but we
+ * may not have finished eventpoll_release() yet.
+ *
+ * Technically, even with the atomic_long_inc_not_zero,
+ * the file may have been free'd and then gotten
+ * re-allocated to something else (since files are
+ * not RCU-delayed, they are SLAB_TYPESAFE_BY_RCU).
+ *
+ * But for epoll, we don't much care.
+ */
+static struct file *epi_fget(const struct epitem *epi)
+{
+	struct file *file;
+
+	rcu_read_lock();
+	file = epi->ffd.file;
+	if (!atomic_long_inc_not_zero(&file->f_count))
+		file = NULL;
+	rcu_read_unlock();
+	return file;
+}
+
 static void list_file(struct file *file)
 {
 	struct epitems_head *head;
@@ -987,14 +1011,18 @@ static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int dep
 static __poll_t ep_item_poll(const struct epitem *epi, poll_table *pt,
 				 int depth)
 {
-	struct file *file = epi->ffd.file;
+	struct file *file = epi_fget(epi);
 	__poll_t res;
 
+	if (!file)
+		return 0;
+
 	pt->_key = epi->event.events;
 	if (!is_file_epoll(file))
 		res = vfs_poll(file, pt);
 	else
 		res = __ep_eventpoll_poll(file, pt, depth);
+	fput(file);
 	return res & epi->event.events;
 }
 
-- 
2.44.0.330.g4d18c88175


