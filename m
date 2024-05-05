Return-Path: <io-uring+bounces-1758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2438BC2F2
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 20:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88DCE1F2136A
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 18:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC6A5A788;
	Sun,  5 May 2024 18:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CZtZ4Kss"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA302B9BE;
	Sun,  5 May 2024 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714932004; cv=none; b=jPuvEXm/apwZQPPrqmjsIfHl/8jVpz6n0+cJ4PEgxx4lvHv7boUHKFE9vjOq840QVhBAbF7WNDEJWO2czM4lvMbcralLypXiGA8yH7eW3TD3fJbT1BnQFST6sxhAtuTaYAYVNeshHwO7I69D6kvM/53Ca7fSAQu7T+Ma7eJh7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714932004; c=relaxed/simple;
	bh=TsViQ/wYOfXwpC4HIbCA3YZAn4taAzdXrsvEgMW9B4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCp7q94XPEgHGEIXe0ONMZhPJPx+7I/2c70O4s9MLjdYuzJ+rqZtMfFsNbYK7axDf9FPwOeITYq/F9Ab+h8+c9qJkPOqUzvG7waW0YvNxeJGJTK5l+qbaZlbhPRJnYcOX2MXs9N/nCV9L8j0NPjoXPRI6BWXFH8V2s1H+IcOzWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CZtZ4Kss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563D9C113CC;
	Sun,  5 May 2024 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714932003;
	bh=TsViQ/wYOfXwpC4HIbCA3YZAn4taAzdXrsvEgMW9B4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZtZ4Kss4M1ugKJ7mNWZqHBV202HqoMwtZlcRjCpwHl674Vss/9EoYPFiv6Kb4FeD
	 tHC4/QlBc/TNWEyBH7IT/ScaeO/01P3qAeR+FGsapRFZT4Yn6EJc4pRu0BLRUe+fhe
	 9HecR26VCfGEdlB9PzGLrIhnvWf+OU1PPMzCB+EE=
From: Linus Torvalds <torvalds@linux-foundation.org>
To: torvalds@linux-foundation.org
Cc: axboe@kernel.dk,
	brauner@kernel.org,
	christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org,
	io-uring@vger.kernel.org,
	jack@suse.cz,
	keescook@chromium.org,
	laura@labbott.name,
	linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH v2] epoll: be better about file lifetimes
Date: Sun,  5 May 2024 10:55:57 -0700
Message-ID: <20240505175556.1213266-2-torvalds@linux-foundation.org>
X-Mailer: git-send-email 2.44.0.330.g4d18c88175
In-Reply-To: <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
References: <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

epoll can call out to vfs_poll() with a file pointer that may race with
the last 'fput()'. That would make f_count go down to zero, and while
the ep->mtx locking means that the resulting file pointer tear-down will
be blocked until the poll returns, it means that f_count is already
dead, and any use of it won't actually get a reference to the file any
more: it's dead regardless.

Make sure we have a valid ref on the file pointer before we call down to
vfs_poll() from the epoll routines.

Link: https://lore.kernel.org/lkml/0000000000002d631f0615918f1e@google.com/
Reported-by: syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

Changes since v1:

 - add Link, Reported-by, and Jens' reviewed-by. And sign off on it
   because it looks fine to me and we have some testing now.

 - move epi_fget() closer to the user

 - more comments about the background

 - remove the rcu_read_lock(), with the comment explaining why it's not
   needed

 - note about returning zero rather than something like EPOLLERR|POLLHUP
   for a file that is going away

 fs/eventpoll.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 882b89edc52a..a3f0f868adc4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -979,6 +979,37 @@ static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int dep
 	return res;
 }
 
+/*
+ * The ffd.file pointer may be in the process of
+ * being torn down due to being closed, but we
+ * may not have finished eventpoll_release() yet.
+ *
+ * Normally, even with the atomic_long_inc_not_zero,
+ * the file may have been free'd and then gotten
+ * re-allocated to something else (since files are
+ * not RCU-delayed, they are SLAB_TYPESAFE_BY_RCU).
+ *
+ * But for epoll, users hold the ep->mtx mutex, and
+ * as such any file in the process of being free'd
+ * will block in eventpoll_release_file() and thus
+ * the underlying file allocation will not be free'd,
+ * and the file re-use cannot happen.
+ *
+ * For the same reason we can avoid a rcu_read_lock()
+ * around the operation - 'ffd.file' cannot go away
+ * even if the refcount has reached zero (but we must
+ * still not call out to ->poll() functions etc).
+ */
+static struct file *epi_fget(const struct epitem *epi)
+{
+	struct file *file;
+
+	file = epi->ffd.file;
+	if (!atomic_long_inc_not_zero(&file->f_count))
+		file = NULL;
+	return file;
+}
+
 /*
  * Differs from ep_eventpoll_poll() in that internal callers already have
  * the ep->mtx so we need to start from depth=1, such that mutex_lock_nested()
@@ -987,14 +1018,23 @@ static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int dep
 static __poll_t ep_item_poll(const struct epitem *epi, poll_table *pt,
 				 int depth)
 {
-	struct file *file = epi->ffd.file;
+	struct file *file = epi_fget(epi);
 	__poll_t res;
 
+	/*
+	 * We could return EPOLLERR | EPOLLHUP or something,
+	 * but let's treat this more as "file doesn't exist,
+	 * poll didn't happen".
+	 */
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


