Return-Path: <io-uring+bounces-3340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE9398AE99
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 22:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D412B23FC5
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C64319882F;
	Mon, 30 Sep 2024 20:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VyQhJaY1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8812199FAF
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 20:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727728832; cv=none; b=IQantSWaJuVB0jkL3i/r5IaMiLxgAf8d3IXPcehnSpsgTEvTo3eFyXBMiCviy4/BiBMrDlZ1rWn5ZqkjFo/LuCUPPKe3lcl20fQSpQUD+eTdLXB1KVhZQs9JB0vYNiW1oH0+TYOQN/6TLvr7ab+iqazpECXMgfyMYi1ElikXXRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727728832; c=relaxed/simple;
	bh=mCuQ4XeoaGOEiJ6kvrbrA3dMH2ptmBDDdJOaZeeZq4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4+XiabZAKnH5QKf5niSGio5nw17Kcc5thovu2SwTu17zJOI+p+3WXjzw5wVk11dy/LNPqqgYahn8KO28PdAuPIFTon7ccj5jnDcnhRC/dqbjR02oIw0P/RafaYOSztmJNOPMvJzfXqfrqD8sjV4SnHprgtwrHyJsINydOtel98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VyQhJaY1; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a3525ba6aaso5803545ab.2
        for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 13:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727728828; x=1728333628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUh7ByU+LqT2NJHz3+ivI+J6VF4Zj/o/zOLq9N3AmIY=;
        b=VyQhJaY1LXP3oU6XY3N3mNLbqnxBDXbxWia7T9zw1J6YMpG9xlZNaw4OR5WLWOHaWl
         FJGHH4W721X9epfXtwDvqXBjlZKOdw7hqDEv5H0ihz+NSlTdspuVOXCBuSQURr3CIANJ
         FuKyDJAVpMmf5UoDtHkX6Yl/JitQKsjVCl0Sjcq91WfLhvHJxm32b6HJ4AKxtst7118z
         33M+QobBiFqOVErDJ59EChlm5PDmi/4FnmIhjgLbGN6NgvcpyjF21sfRM2CFHeQo0Fc3
         0SFjrYz5m0m/uQ//w5wASrAUGO36tbfilZKBI6A5GmgW+YkkkN8DEKMxLk6Cp32awtAm
         o7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727728828; x=1728333628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GUh7ByU+LqT2NJHz3+ivI+J6VF4Zj/o/zOLq9N3AmIY=;
        b=Lj+fOKpf4dLFAb7P2AQu+/xCR1BSZzpJwXxLf4cYEzj3DRWpZ3b+SGu9WmoEEmpuw0
         eGEbilqY9x/zt99MiTYlDigu7kUMThfYaqB+8LktvzD7MlLEjNvg5sOlOZBZdQwBjIZ1
         0dfklmWaOPU17doYMQZTHIP1cWBnyT9qCh9iU8eY0xKHVyVJd7WzuMzL60ZvpTMmY8/s
         VtrMP+w0RQa7ucHeKXLH66fcHi89ZIC07UgDdHNBhS33wA9+8aizqYS3bdfmsyNryOZV
         fqv1wtlmklE1p17d7FbDxQjDL3ggSbtOmgqxChvPpP7w18omX3T8qI12cLf8IoiJKkAQ
         6XhA==
X-Gm-Message-State: AOJu0YxC8R0u8nfvpaaZMTfCa3yVE4GBuqSjPwanU57Q2qTlpyVGTTU1
	k8XUd1bKZxqlvcmW6UHBrinBssXtJ300TH8CKwpNI06jSZqgWKL4bW9BnAdFRq95T+30woPwHNe
	ghgg=
X-Google-Smtp-Source: AGHT+IHdcUcj0r4ScQgh7Ki0CDe8HpsuuKEHMjGPQ+q4R/LlRUfFwxofUMshYlhSoR0dHebp51WAEw==
X-Received: by 2002:a05:6e02:1a2c:b0:3a0:aac2:a0a4 with SMTP id e9e14a558f8ab-3a34515d38dmr100634725ab.9.1727728828463;
        Mon, 30 Sep 2024 13:40:28 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d60728sm26430175ab.2.2024.09.30.13.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 13:40:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring/poll: get rid of per-hashtable bucket locks
Date: Mon, 30 Sep 2024 14:37:48 -0600
Message-ID: <20240930204018.109617-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930204018.109617-1-axboe@kernel.dk>
References: <20240930204018.109617-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Any access to the table is protected by ctx->uring_lock now anyway, the
per-bucket locking doesn't buy us anything.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 -
 io_uring/cancel.c              |  4 +---
 io_uring/poll.c                | 39 +++++++++-------------------------
 3 files changed, 11 insertions(+), 33 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d8ca27da1341..9c7e1d3f06e5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -67,7 +67,6 @@ struct io_file_table {
 };
 
 struct io_hash_bucket {
-	spinlock_t		lock;
 	struct hlist_head	list;
 } ____cacheline_aligned_in_smp;
 
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index a6e58a20efdd..755dd5506a5f 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -236,10 +236,8 @@ void init_hash_table(struct io_hash_table *table, unsigned size)
 {
 	unsigned int i;
 
-	for (i = 0; i < size; i++) {
-		spin_lock_init(&table->hbs[i].lock);
+	for (i = 0; i < size; i++)
 		INIT_HLIST_HEAD(&table->hbs[i].list);
-	}
 }
 
 static int __io_sync_cancel(struct io_uring_task *tctx,
diff --git a/io_uring/poll.c b/io_uring/poll.c
index a7d7fa844729..63f9461aa9b6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -728,7 +728,6 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	for (i = 0; i < nr_buckets; i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 
-		spin_lock(&hb->lock);
 		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
 			if (io_match_task_safe(req, tsk, cancel_all)) {
 				hlist_del_init(&req->hash_node);
@@ -736,22 +735,17 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 				found = true;
 			}
 		}
-		spin_unlock(&hb->lock);
 	}
 	return found;
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
-				     struct io_cancel_data *cd,
-				     struct io_hash_bucket **out_bucket)
+				     struct io_cancel_data *cd)
 {
 	struct io_kiocb *req;
 	u32 index = hash_long(cd->data, ctx->cancel_table.hash_bits);
 	struct io_hash_bucket *hb = &ctx->cancel_table.hbs[index];
 
-	*out_bucket = NULL;
-
-	spin_lock(&hb->lock);
 	hlist_for_each_entry(req, &hb->list, hash_node) {
 		if (cd->data != req->cqe.user_data)
 			continue;
@@ -761,34 +755,25 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 			if (io_cancel_match_sequence(req, cd->seq))
 				continue;
 		}
-		*out_bucket = hb;
 		return req;
 	}
-	spin_unlock(&hb->lock);
 	return NULL;
 }
 
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
-					  struct io_cancel_data *cd,
-					  struct io_hash_bucket **out_bucket)
+					  struct io_cancel_data *cd)
 {
 	unsigned nr_buckets = 1U << ctx->cancel_table.hash_bits;
 	struct io_kiocb *req;
 	int i;
 
-	*out_bucket = NULL;
-
 	for (i = 0; i < nr_buckets; i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 
-		spin_lock(&hb->lock);
 		hlist_for_each_entry(req, &hb->list, hash_node) {
-			if (io_cancel_req_match(req, cd)) {
-				*out_bucket = hb;
+			if (io_cancel_req_match(req, cd))
 				return req;
-			}
 		}
-		spin_unlock(&hb->lock);
 	}
 	return NULL;
 }
@@ -806,20 +791,19 @@ static int io_poll_disarm(struct io_kiocb *req)
 
 static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 {
-	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
 
 	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
 			 IORING_ASYNC_CANCEL_ANY))
-		req = io_poll_file_find(ctx, cd, &bucket);
+		req = io_poll_file_find(ctx, cd);
 	else
-		req = io_poll_find(ctx, false, cd, &bucket);
+		req = io_poll_find(ctx, false, cd);
 
-	if (req)
+	if (req) {
 		io_poll_cancel_req(req);
-	if (bucket)
-		spin_unlock(&bucket->lock);
-	return req ? 0 : -ENOENT;
+		return 0;
+	}
+	return -ENOENT;
 }
 
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
@@ -918,15 +902,12 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_cancel_data cd = { .ctx = ctx, .data = poll_update->old_user_data, };
-	struct io_hash_bucket *bucket;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	preq = io_poll_find(ctx, true, &cd, &bucket);
+	preq = io_poll_find(ctx, true, &cd);
 	ret2 = io_poll_disarm(preq);
-	if (bucket)
-		spin_unlock(&bucket->lock);
 	if (!ret2)
 		goto found;
 	if (ret2) {
-- 
2.45.2


