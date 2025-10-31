Return-Path: <io-uring+bounces-10313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA86C26E81
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 21:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 493D01A2875C
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 20:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367EC32BF55;
	Fri, 31 Oct 2025 20:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MWl47O7y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f225.google.com (mail-lj1-f225.google.com [209.85.208.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D6C328B55
	for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 20:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761942884; cv=none; b=BpnfPMc9EaWdhADJrQxlHY6vPVKYq4FZZBjS6ufKGPm5makUrKMu3i84n6FyvtUl4ZqxbjwALFxuVNlZHm9F1m7MvELuBw7QqFOp6TKkdeXVh+Yxc2GbrKzQNRmBVFSbuVtkzQtj1j1Gte/ZYxm/Dcy7kn7bwIkCeKzupXCJbNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761942884; c=relaxed/simple;
	bh=5xCi96Wi/8C0iMkGQmzSQ15P1Ao51HlxcXEoMZua5Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq9B1zt0i4aXfTi1I4oilU4bkw0jnbZqMhAeQmHWcG3xM/XkVbTStRBMb6E5v3gWOXYx3H2pMvfzedq3XDzLlLgC3gEdlsejRiafvyN2cCBE65G6IN3X8m0dpMGdrKDvs9RbNOocTIYBHNcr1oDUOJvt8/u7BUTVzM3QWpwaEac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=MWl47O7y; arc=none smtp.client-ip=209.85.208.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lj1-f225.google.com with SMTP id 38308e7fff4ca-378e14952fbso3847631fa.2
        for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 13:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761942878; x=1762547678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rPF2gMp/CLkbmJumCkFzneZgEurALeKCpbInih+HpRI=;
        b=MWl47O7yOu7URO+y3PgoNe9if60QLd9ifoJAFPNqkSPpmBhbJwZY2fepGGmwi77gZ/
         XlEIETMFTEymDy6Fm6cc25AAWL30RrVfjwoOtsRDAdyCcEq2AQiiF92xJBus0cf2zlvD
         OfitbCt1Ff8urvoFVXh3ot4DNjn5Ox6dZ7dnmleJ2CrMvBxulUzn3J47tbcV9QOrOHGc
         HAzRbDfxV1Zp5k6fRFFVldCbQOpV+yIT18Rl2+D0+cvk9BzLYBhdFLjNMYVis6oeRAOc
         bzx3zUWak+GFf53tqd46hJQCx/CVw8vj0nZ3wo0WcHPknD4PlkOhLfQTi0LgPkvoBDn/
         Yz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761942878; x=1762547678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rPF2gMp/CLkbmJumCkFzneZgEurALeKCpbInih+HpRI=;
        b=ulmGT1W0msAQFVUqmlmwGNe0xglrKvw4UrSeKdh2oc6hxIdO/NaSmtqLtbpeHWNd7C
         AdhNbfEFORrtRJpax7wDFXx+nMseGIDIw4oh2x61PNg2evYQu6JvDNvGut1gDVJ79far
         IUvSAswNdXjqi+OJcAuWzoBPrc3sL82JAORWCxwU6abEaQ8aF5OBOOmuTyaNnn2sWhWK
         U7sUiJ5BkVVmECMk5E0PCq5rF2L0Fb6q6kK4j1vj7SA9ytDhBXt3dqHeOxuDTtw61pzB
         aayDkYs1A6jf7Cq26n7xoW/erBBRe5/V84sJzalpr49TAmNUyGnQGqyoufYpkt5NIXSu
         el+Q==
X-Gm-Message-State: AOJu0YylHONfgQKGRwMHI4wyI2ZkcH5OxcCaJmg52kH8XPMuRMl/CPwh
	LpZrVBEEgxsoj3/3YzoHnG0o/mAZVNHSQ3iwO3+XoZUfe/sGD5LkuoiUmm6weHqedHmTjbDVcrP
	b7lR1YQYBqWivWw5Z7HidqDXBZQtOpjzIDvBl
X-Gm-Gg: ASbGncurBoM927fdnACXAaQlTDcYTR7N62Pp8h1uEcT0m478Kbxg1xvngI7oSK+nCEF
	Ehs2LPHWA3V31cqAgLmPr8+826ausfOWPnxAR0aM5cMR0pSeXpBr3MAXXEV6h8C3SOKThKIg8hb
	jibXUDWCxVrhV3slUtVIg4jVpVsgUt2iywqxW5yBX6AOtburO5EQ+br1mbJlFgMPGEi2DgO8GSY
	EYpv4MjGE1+31wOA8janJ+TS0jkv6OwpkVzeYyCuLd1iP6urA/dAho9sfb3KxPJZRsD+9bAST/V
	o1BHWL8hrJRaRnHng2aGevk/i5cqOeka7P0D3Di1m1MgHo25v4ZYVulUDxqP3Ki+yoF//KqA3Ot
	jRK/GR6hGD/4+cl3dcFHkKdnegBKEORI=
X-Google-Smtp-Source: AGHT+IH9ddq9FZzSrhoHLOk/g28sBbPQk2jmSsLukD+J51Emqfk7owum1B6Ubv/srpylzJsB617REd2THj41
X-Received: by 2002:a05:6512:1112:b0:592:f3c8:39d8 with SMTP id 2adb3069b0e04-5941d53a565mr945652e87.5.1761942878261;
        Fri, 31 Oct 2025 13:34:38 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-5941f39da5csm286489e87.26.2025.10.31.13.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 13:34:38 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 86988341F2A;
	Fri, 31 Oct 2025 14:34:36 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 83350E41255; Fri, 31 Oct 2025 14:34:36 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 2/3] io_uring: add wrapper type for io_req_tw_func_t arg
Date: Fri, 31 Oct 2025 14:34:29 -0600
Message-ID: <20251031203430.3886957-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251031203430.3886957-1-csander@purestorage.com>
References: <20251031203430.3886957-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for uring_cmd implementations to implement functions
with the io_req_tw_func_t signature, introduce a wrapper struct
io_tw_req to hide the struct io_kiocb * argument. The intention is for
only the io_uring core to access the inner struct io_kiocb *. uring_cmd
implementations should instead call a helper from io_uring/cmd.h to
convert struct io_tw_req to struct io_uring_cmd *.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring_types.h |  6 +++++-
 io_uring/futex.c               | 16 +++++++++-------
 io_uring/io_uring.c            | 21 ++++++++++++---------
 io_uring/io_uring.h            |  4 ++--
 io_uring/msg_ring.c            |  3 ++-
 io_uring/notif.c               |  5 +++--
 io_uring/poll.c                | 11 ++++++-----
 io_uring/poll.h                |  2 +-
 io_uring/rw.c                  |  5 +++--
 io_uring/rw.h                  |  2 +-
 io_uring/timeout.c             | 18 +++++++++++-------
 io_uring/uring_cmd.c           |  3 ++-
 io_uring/waitid.c              |  7 ++++---
 13 files changed, 61 insertions(+), 42 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 25ee982eb435..f064a438ce43 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -613,11 +613,15 @@ enum {
 	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
 	/* ->sqe_copy() has been called, if necessary */
 	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
 };
 
-typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
+struct io_tw_req {
+	struct io_kiocb *req;
+};
+
+typedef void (*io_req_tw_func_t)(struct io_tw_req tw_req, io_tw_token_t tw);
 
 struct io_task_work {
 	struct llist_node		node;
 	io_req_tw_func_t		func;
 };
diff --git a/io_uring/futex.c b/io_uring/futex.c
index 64f3bd51c84c..4e022c76236d 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -39,28 +39,30 @@ bool io_futex_cache_init(struct io_ring_ctx *ctx)
 void io_futex_cache_free(struct io_ring_ctx *ctx)
 {
 	io_alloc_cache_free(&ctx->futex_cache, kfree);
 }
 
-static void __io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void __io_futex_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
-	hlist_del_init(&req->hash_node);
-	io_req_task_complete(req, tw);
+	hlist_del_init(&tw_req.req->hash_node);
+	io_req_task_complete(tw_req, tw);
 }
 
-static void io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void io_futex_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, tw);
 	io_cache_free(&ctx->futex_cache, req->async_data);
 	io_req_async_data_clear(req, 0);
-	__io_futex_complete(req, tw);
+	__io_futex_complete(tw_req, tw);
 }
 
-static void io_futexv_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void io_futexv_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct futex_vector *futexv = req->async_data;
 
 	io_tw_lock(req->ctx, tw);
 
@@ -71,11 +73,11 @@ static void io_futexv_complete(struct io_kiocb *req, io_tw_token_t tw)
 		if (res != -1)
 			io_req_set_res(req, res, 0);
 	}
 
 	io_req_async_data_free(req);
-	__io_futex_complete(req, tw);
+	__io_futex_complete(tw_req, tw);
 }
 
 static bool io_futexv_claim(struct io_futex *iof)
 {
 	if (test_bit(0, &iof->futexv_owned) ||
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4e6676ac4662..01631b6ff442 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -289,11 +289,11 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
 	ts.cancel = io_should_terminate_tw(ctx);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
-		req->io_task_work.func(req, ts);
+		req->io_task_work.func((struct io_tw_req){req}, ts);
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -537,13 +537,13 @@ static void io_queue_iowq(struct io_kiocb *req)
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
 }
 
-static void io_req_queue_iowq_tw(struct io_kiocb *req, io_tw_token_t tw)
+static void io_req_queue_iowq_tw(struct io_tw_req tw_req, io_tw_token_t tw)
 {
-	io_queue_iowq(req);
+	io_queue_iowq(tw_req.req);
 }
 
 void io_req_queue_iowq(struct io_kiocb *req)
 {
 	req->io_task_work.func = io_req_queue_iowq_tw;
@@ -1164,11 +1164,11 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 			percpu_ref_get(&ctx->refs);
 			ts.cancel = io_should_terminate_tw(ctx);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
-				req, ts);
+				(struct io_tw_req){req}, ts);
 		node = next;
 		(*count)++;
 		if (unlikely(need_resched())) {
 			ctx_flush_and_put(ctx, ts);
 			ctx = NULL;
@@ -1387,11 +1387,11 @@ static int __io_run_local_work_loop(struct llist_node **node,
 		struct llist_node *next = (*node)->next;
 		struct io_kiocb *req = container_of(*node, struct io_kiocb,
 						    io_task_work.node);
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
-				req, tw);
+				(struct io_tw_req){req}, tw);
 		*node = next;
 		if (++ret >= events)
 			break;
 	}
 
@@ -1457,18 +1457,21 @@ static int io_run_local_work(struct io_ring_ctx *ctx, int min_events,
 	ret = __io_run_local_work(ctx, ts, min_events, max_events);
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
 
-static void io_req_task_cancel(struct io_kiocb *req, io_tw_token_t tw)
+static void io_req_task_cancel(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
+
 	io_tw_lock(req->ctx, tw);
 	io_req_defer_failed(req, req->cqe.res);
 }
 
-void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw)
+void io_req_task_submit(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, tw);
 	if (unlikely(tw.cancel))
 		io_req_defer_failed(req, -EFAULT);
@@ -1700,13 +1703,13 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 	} while (nr_events < min_events);
 
 	return 0;
 }
 
-void io_req_task_complete(struct io_kiocb *req, io_tw_token_t tw)
+void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
-	io_req_complete_defer(req);
+	io_req_complete_defer(tw_req.req);
 }
 
 /*
  * After the iocb has been issued, it's safe to be found on the poll list.
  * Adding the kiocb to the list AFTER submission ensures that we don't
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 44b8091c7fcd..f97356ce29d0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -147,13 +147,13 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags);
 void io_req_task_queue(struct io_kiocb *req);
-void io_req_task_complete(struct io_kiocb *req, io_tw_token_t tw);
+void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
-void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw);
+void io_req_task_submit(struct io_tw_req tw_req, io_tw_token_t tw);
 struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
 struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 5e5b94236d72..7063ea7964e7 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -68,12 +68,13 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 {
 	return target_ctx->task_complete;
 }
 
-static void io_msg_tw_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void io_msg_tw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
 	kfree_rcu(req, rcu_head);
 	percpu_ref_put(&ctx->refs);
diff --git a/io_uring/notif.c b/io_uring/notif.c
index d8ba1165c949..9960bb2a32d5 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,12 +9,13 @@
 #include "notif.h"
 #include "rsrc.h"
 
 static const struct ubuf_info_ops io_ubuf_ops;
 
-static void io_notif_tw_complete(struct io_kiocb *notif, io_tw_token_t tw)
+static void io_notif_tw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *notif = tw_req.req;
 	struct io_notif_data *nd = io_notif_to_data(notif);
 	struct io_ring_ctx *ctx = notif->ctx;
 
 	lockdep_assert_held(&ctx->uring_lock);
 
@@ -32,11 +33,11 @@ static void io_notif_tw_complete(struct io_kiocb *notif, io_tw_token_t tw)
 			__io_unaccount_mem(notif->ctx->user, nd->account_pages);
 			nd->account_pages = 0;
 		}
 
 		nd = nd->next;
-		io_req_task_complete(notif, tw);
+		io_req_task_complete((struct io_tw_req){notif}, tw);
 	} while (nd);
 }
 
 void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
 			 bool success)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index c403e751841a..8aa4e3a31e73 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -308,12 +308,13 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;
 }
 
-void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
+void io_poll_task_func(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	int ret;
 
 	ret = io_poll_check_events(req, tw);
 	if (ret == IOU_POLL_NO_ACTION) {
 		return;
@@ -330,26 +331,26 @@ void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 			struct io_poll *poll;
 
 			poll = io_kiocb_to_cmd(req, struct io_poll);
 			req->cqe.res = mangle_poll(req->cqe.res & poll->events);
 		} else if (ret == IOU_POLL_REISSUE) {
-			io_req_task_submit(req, tw);
+			io_req_task_submit(tw_req, tw);
 			return;
 		} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
 			req->cqe.res = ret;
 			req_set_fail(req);
 		}
 
 		io_req_set_res(req, req->cqe.res, 0);
-		io_req_task_complete(req, tw);
+		io_req_task_complete(tw_req, tw);
 	} else {
 		io_tw_lock(req->ctx, tw);
 
 		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
-			io_req_task_complete(req, tw);
+			io_req_task_complete(tw_req, tw);
 		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
-			io_req_task_submit(req, tw);
+			io_req_task_submit(tw_req, tw);
 		else
 			io_req_defer_failed(req, ret);
 	}
 }
 
diff --git a/io_uring/poll.h b/io_uring/poll.h
index c8438286dfa0..5647c5138932 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -44,6 +44,6 @@ int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask);
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			bool cancel_all);
 
-void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw);
+void io_poll_task_func(struct io_tw_req tw_req, io_tw_token_t tw);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5b2241a5813c..828ac4f902b4 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -562,12 +562,13 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 			res += io->bytes_done;
 	}
 	return res;
 }
 
-void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
+void io_req_rw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
 
 	if ((kiocb->ki_flags & IOCB_DIO_CALLER_COMP) && kiocb->dio_complete) {
 		long res = kiocb->dio_complete(rw->kiocb.private);
@@ -579,11 +580,11 @@ void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
 		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, NULL);
 
 	io_req_rw_cleanup(req, 0);
-	io_req_task_complete(req, tw);
+	io_req_task_complete(tw_req, tw);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 129a53fe5482..9bd7fbf70ea9 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -44,9 +44,9 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
 int io_read_fixed(struct io_kiocb *req, unsigned int issue_flags);
 int io_write_fixed(struct io_kiocb *req, unsigned int issue_flags);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
-void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw);
+void io_req_rw_complete(struct io_tw_req tw_req, io_tw_token_t tw);
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);
 void io_rw_cache_free(const void *entry);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 444142ba9d04..d8fbbaf31cf3 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -66,12 +66,13 @@ static inline bool io_timeout_finish(struct io_timeout *timeout,
 	return true;
 }
 
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer);
 
-static void io_timeout_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void io_timeout_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!io_timeout_finish(timeout, data)) {
@@ -83,11 +84,11 @@ static void io_timeout_complete(struct io_kiocb *req, io_tw_token_t tw)
 			raw_spin_unlock_irq(&ctx->timeout_lock);
 			return;
 		}
 	}
 
-	io_req_task_complete(req, tw);
+	io_req_task_complete(tw_req, tw);
 }
 
 static __cold bool io_flush_killed_timeouts(struct list_head *list, int err)
 {
 	if (list_empty(list))
@@ -155,22 +156,24 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	ctx->cq_last_tm_flush = seq;
 	raw_spin_unlock_irq(&ctx->timeout_lock);
 	io_flush_killed_timeouts(&list, 0);
 }
 
-static void io_req_tw_fail_links(struct io_kiocb *link, io_tw_token_t tw)
+static void io_req_tw_fail_links(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *link = tw_req.req;
+
 	io_tw_lock(link->ctx, tw);
 	while (link) {
 		struct io_kiocb *nxt = link->link;
 		long res = -ECANCELED;
 
 		if (link->flags & REQ_F_FAIL)
 			res = link->cqe.res;
 		link->link = NULL;
 		io_req_set_res(link, res, 0);
-		io_req_task_complete(link, tw);
+		io_req_task_complete((struct io_tw_req){link}, tw);
 		link = nxt;
 	}
 }
 
 static void io_fail_links(struct io_kiocb *req)
@@ -315,12 +318,13 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 		return PTR_ERR(req);
 	io_req_task_queue_fail(req, -ECANCELED);
 	return 0;
 }
 
-static void io_req_task_link_timeout(struct io_kiocb *req, io_tw_token_t tw)
+static void io_req_task_link_timeout(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_kiocb *prev = timeout->prev;
 	int ret;
 
 	if (prev) {
@@ -333,15 +337,15 @@ static void io_req_task_link_timeout(struct io_kiocb *req, io_tw_token_t tw)
 			ret = io_try_cancel(req->tctx, &cd, 0);
 		} else {
 			ret = -ECANCELED;
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
-		io_req_task_complete(req, tw);
+		io_req_task_complete(tw_req, tw);
 		io_put_req(prev);
 	} else {
 		io_req_set_res(req, -ETIME, 0);
-		io_req_task_complete(req, tw);
+		io_req_task_complete(tw_req, tw);
 	}
 }
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 9d67a2a721aa..c09b99e91c86 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -111,12 +111,13 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
-static void io_uring_cmd_work(struct io_kiocb *req, io_tw_token_t tw)
+static void io_uring_cmd_work(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
 	if (unlikely(tw.cancel))
 		flags |= IO_URING_F_TASK_DEAD;
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index c5e0d979903a..62f7f1f004a5 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -14,11 +14,11 @@
 #include "io_uring.h"
 #include "cancel.h"
 #include "waitid.h"
 #include "../kernel/exit.h"
 
-static void io_waitid_cb(struct io_kiocb *req, io_tw_token_t tw);
+static void io_waitid_cb(struct io_tw_req tw_req, io_tw_token_t tw);
 
 #define IO_WAITID_CANCEL_FLAG	BIT(31)
 #define IO_WAITID_REF_MASK	GENMASK(30, 0)
 
 struct io_waitid {
@@ -192,12 +192,13 @@ static inline bool io_waitid_drop_issue_ref(struct io_kiocb *req)
 	req->io_task_work.func = io_waitid_cb;
 	io_req_task_work_add(req);
 	return true;
 }
 
-static void io_waitid_cb(struct io_kiocb *req, io_tw_token_t tw)
+static void io_waitid_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_waitid_async *iwa = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	io_tw_lock(ctx, tw);
@@ -227,11 +228,11 @@ static void io_waitid_cb(struct io_kiocb *req, io_tw_token_t tw)
 			/* fall through to complete, will kill waitqueue */
 		}
 	}
 
 	io_waitid_complete(req, ret);
-	io_req_task_complete(req, tw);
+	io_req_task_complete(tw_req, tw);
 }
 
 static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 			  int sync, void *key)
 {
-- 
2.45.2


