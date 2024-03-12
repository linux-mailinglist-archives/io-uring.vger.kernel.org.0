Return-Path: <io-uring+bounces-893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4752C879676
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 15:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2E13B24B94
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 14:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476D07C087;
	Tue, 12 Mar 2024 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="VrAepsAI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DDF7D065;
	Tue, 12 Mar 2024 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254036; cv=none; b=SK1DorCVKDGR7H3H9g93+BKJQ+TNVp40mfGZUytrRYcoxIHugGEWDO0XwDfi0+lXe+fhKMH7lCNyfBVJ3rq9b+GecNjXYGMC0WVhma7kI4kyARcEr/NnUJrjxD86UlPvcvEXTRfKgQFH3xxQrh7X9F6PHETWvkk/kOAiGWVlhoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254036; c=relaxed/simple;
	bh=QXKPqysuD6oO5l8ruAWIhkoOSvCJPcKxJiHgWWZSnpk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j/fjFVt7QogAUVojgoSMbY+4m9zoRLKaEycU9Op9DIwdI6k3qy//sXnW3dsb6v4oiWTXrKJfxpd3ytpSSKgtmx5BpAFC76ezWOrNRxG1ljfZfnu+F8LOkLPGFNRMnYDQqcxYQPdE0820exOAf8zCujGr0wSQGjjKR8v+ltDcXJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=VrAepsAI; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from localhost.ispras.ru (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id 45E7540AC4FD;
	Tue, 12 Mar 2024 14:23:41 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 45E7540AC4FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1710253421;
	bh=pAMT/TBWHWaIUciFurxSw62HZ6yTRhT83dDM+QxPhsA=;
	h=From:To:Cc:Subject:Date:From;
	b=VrAepsAI4ps0CYWkU7kRCb5S+JjriIcyBvaV3bmKcU+aZgDGjjrzrG4AJ5aOBqHiz
	 gAPaq0aIj/TdS2pOYETVqg9vZGyWG6e4eIGYG3AYRx7TZlw6gc+bIhMexc/WsnYBJS
	 pldWs9ToOaFxWU0rQFyTHNADhxtqSjqGk82IVVUg=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Roman Belyaev <belyaevrd@yandex.ru>
Subject: [PATCH 5.10/5.15] io_uring: fix registered files leak
Date: Tue, 12 Mar 2024 17:23:12 +0300
Message-ID: <20240312142313.3436-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No upstream commit exists for this patch.

Backport of commit 705318a99a13 ("io_uring/af_unix: disable sending
io_uring over sockets") introduced registered files leaks in 5.10/5.15
stable branches when CONFIG_UNIX is enabled.

The 5.10/5.15 backports removed io_sqe_file_register() calls from
io_install_fixed_file() and __io_sqe_files_update() so that newly added
files aren't passed to UNIX-related skbs and thus can't be put during
unregistering process. Skbs in the ring socket receive queue are released
but there is no skb having reference to the newly updated file.

In other words, when CONFIG_UNIX is enabled there would be no fput() when
files are unregistered for the corresponding fget() from
io_install_fixed_file() and __io_sqe_files_update().

Drop several code paths related to SCM_RIGHTS as a partial change from
commit 6e5e6d274956 ("io_uring: drop any code related to SCM_RIGHTS").
This code is useless in stable branches now, too, but is causing leaks in
5.10/5.15.

As stated above, the affected code was removed in upstream by
commit 6e5e6d274956 ("io_uring: drop any code related to SCM_RIGHTS").

Fresher stables from 6.1 have io_file_need_scm() stub function which
usage is effectively equivalent to dropping most of SCM-related code.

5.4 seems not to be affected with this problem since SCM-related
functions have been dropped there by the backport-patch.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 705318a99a13 ("io_uring/af_unix: disable sending io_uring over sockets")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
I feel io_uring-SCM related code should be dropped entirely from the
stable branches as the backports already differ greatly between versions
and some parts are still kept, some have been dropped in a non-consistent
order. Though this might contradict with stable kernel rules or be
inappropriate for some other reason.

 io_uring/io_uring.c | 177 --------------------------------------------
 1 file changed, 177 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 936abc6ee450..6ad078a3bf30 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -62,7 +62,6 @@
 #include <linux/net.h>
 #include <net/sock.h>
 #include <net/af_unix.h>
-#include <net/scm.h>
 #include <linux/anon_inodes.h>
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
@@ -7989,15 +7988,6 @@ static void io_free_file_tables(struct io_file_table *table)
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-#if defined(CONFIG_UNIX)
-	if (ctx->ring_sock) {
-		struct sock *sock = ctx->ring_sock->sk;
-		struct sk_buff *skb;
-
-		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
-			kfree_skb(skb);
-	}
-#else
 	int i;
 
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -8007,7 +7997,6 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		if (file)
 			fput(file);
 	}
-#endif
 	io_free_file_tables(&ctx->file_table);
 	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
@@ -8159,170 +8148,10 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 	return sqd;
 }
 
-#if defined(CONFIG_UNIX)
-/*
- * Ensure the UNIX gc is aware of our file set, so we are certain that
- * the io_uring can be safely unregistered on process exit, even if we have
- * loops in the file referencing.
- */
-static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
-{
-	struct sock *sk = ctx->ring_sock->sk;
-	struct scm_fp_list *fpl;
-	struct sk_buff *skb;
-	int i, nr_files;
-
-	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
-	if (!fpl)
-		return -ENOMEM;
-
-	skb = alloc_skb(0, GFP_KERNEL);
-	if (!skb) {
-		kfree(fpl);
-		return -ENOMEM;
-	}
-
-	skb->sk = sk;
-	skb->scm_io_uring = 1;
-
-	nr_files = 0;
-	fpl->user = get_uid(current_user());
-	for (i = 0; i < nr; i++) {
-		struct file *file = io_file_from_index(ctx, i + offset);
-
-		if (!file)
-			continue;
-		fpl->fp[nr_files] = get_file(file);
-		unix_inflight(fpl->user, fpl->fp[nr_files]);
-		nr_files++;
-	}
-
-	if (nr_files) {
-		fpl->max = SCM_MAX_FD;
-		fpl->count = nr_files;
-		UNIXCB(skb).fp = fpl;
-		skb->destructor = unix_destruct_scm;
-		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
-		skb_queue_head(&sk->sk_receive_queue, skb);
-
-		for (i = 0; i < nr; i++) {
-			struct file *file = io_file_from_index(ctx, i + offset);
-
-			if (file)
-				fput(file);
-		}
-	} else {
-		kfree_skb(skb);
-		free_uid(fpl->user);
-		kfree(fpl);
-	}
-
-	return 0;
-}
-
-/*
- * If UNIX sockets are enabled, fd passing can cause a reference cycle which
- * causes regular reference counting to break down. We rely on the UNIX
- * garbage collection to take care of this problem for us.
- */
-static int io_sqe_files_scm(struct io_ring_ctx *ctx)
-{
-	unsigned left, total;
-	int ret = 0;
-
-	total = 0;
-	left = ctx->nr_user_files;
-	while (left) {
-		unsigned this_files = min_t(unsigned, left, SCM_MAX_FD);
-
-		ret = __io_sqe_files_scm(ctx, this_files, total);
-		if (ret)
-			break;
-		left -= this_files;
-		total += this_files;
-	}
-
-	if (!ret)
-		return 0;
-
-	while (total < ctx->nr_user_files) {
-		struct file *file = io_file_from_index(ctx, total);
-
-		if (file)
-			fput(file);
-		total++;
-	}
-
-	return ret;
-}
-#else
-static int io_sqe_files_scm(struct io_ring_ctx *ctx)
-{
-	return 0;
-}
-#endif
-
 static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
 	struct file *file = prsrc->file;
-#if defined(CONFIG_UNIX)
-	struct sock *sock = ctx->ring_sock->sk;
-	struct sk_buff_head list, *head = &sock->sk_receive_queue;
-	struct sk_buff *skb;
-	int i;
-
-	__skb_queue_head_init(&list);
-
-	/*
-	 * Find the skb that holds this file in its SCM_RIGHTS. When found,
-	 * remove this entry and rearrange the file array.
-	 */
-	skb = skb_dequeue(head);
-	while (skb) {
-		struct scm_fp_list *fp;
-
-		fp = UNIXCB(skb).fp;
-		for (i = 0; i < fp->count; i++) {
-			int left;
-
-			if (fp->fp[i] != file)
-				continue;
-
-			unix_notinflight(fp->user, fp->fp[i]);
-			left = fp->count - 1 - i;
-			if (left) {
-				memmove(&fp->fp[i], &fp->fp[i + 1],
-						left * sizeof(struct file *));
-			}
-			fp->count--;
-			if (!fp->count) {
-				kfree_skb(skb);
-				skb = NULL;
-			} else {
-				__skb_queue_tail(&list, skb);
-			}
-			fput(file);
-			file = NULL;
-			break;
-		}
-
-		if (!file)
-			break;
-
-		__skb_queue_tail(&list, skb);
-
-		skb = skb_dequeue(head);
-	}
-
-	if (skb_peek(&list)) {
-		spin_lock_irq(&head->lock);
-		while ((skb = __skb_dequeue(&list)) != NULL)
-			__skb_queue_tail(head, skb);
-		spin_unlock_irq(&head->lock);
-	}
-#else
 	fput(file);
-#endif
 }
 
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
@@ -8433,12 +8262,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
 	}
 
-	ret = io_sqe_files_scm(ctx);
-	if (ret) {
-		__io_sqe_files_unregister(ctx);
-		return ret;
-	}
-
 	io_rsrc_node_switch(ctx, NULL);
 	return ret;
 out_fput:
-- 
2.44.0


