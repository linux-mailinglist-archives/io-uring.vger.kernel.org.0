Return-Path: <io-uring+bounces-9960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24AA4BCA68E
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 19:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D24FB4813FC
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 17:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844FB246762;
	Thu,  9 Oct 2025 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OKcCaC2j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01868245033
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760031714; cv=none; b=TnyuTJGXjKuFQpjq5r9eMeDDm/SeHklIMCKcVY3lpIkL5tegScBxpD8WbaJxIjZsYJqCYjOWRIa4d6Y/ypMVP6u1hyYqNTVJoBMa1rEXHk+CZhxFmaAc1B+0T1gQQCRl6WqAD6V9nE3DVCt02CRqXKarM5tDflqmY/JydqBu+RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760031714; c=relaxed/simple;
	bh=riN6MdzORXMfoRWOw0fANg6TZ1MX9azwtUMTNNT1Bus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5M5CY8rZOj/Ljh6avyA3upJIsgm5mmBSYH8Hk6PWaepphCKX1RJZkZLSQqVCWZz7gW94OX8Q6jUr3OFi+/BLF5eoGjVNmRXHwqmMe6B7V0YOx/ZNOyWOZ/yMOrXf1DHiPpXtIAnGtMaMSB5i1ttYpbQ6lEMaL5GhVyXzn5xmV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OKcCaC2j; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-42f3acb1744so5911055ab.0
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 10:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760031711; x=1760636511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sba628F35M6z229y/hglc1wm2eeyRJDVRwQATrqkdUE=;
        b=OKcCaC2jisf1jjxZylUUwi9JY4WvOYaPBYdBMeuTjBFHhomDd+U6e0wDw3ZPOQp0oZ
         5FlQxJytadYF8dS4V6SDjbLJ0kKXBAY1spxyzyi4FqROhdV4c05m3olzjKGwGk1KDFw/
         dX7/Qvv0VpNVFdpDWevDVY3vLyXAapwO/woETUvh97DO9vNnqAX7zovVkZGhvyD2O3F4
         MxX9Pc7ZPj0rVY03jhE27+uBv9laWKxuwFkHp5HZpzavtA+nlr1B9Uen9Ideq+xGqoUj
         0Ow0YF0m06DsxoNu+Sga1K+dxHuij7N9P+FFRpxyHF6sp8+MxmbixGNFfJMHWeb+JWBs
         /PCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760031711; x=1760636511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sba628F35M6z229y/hglc1wm2eeyRJDVRwQATrqkdUE=;
        b=kYJDMaKKlz/21MqFJQNFYzFXDzZPcVn7ivs5aP7PJtdnGt7D2qsWqhgIVmlyp1BUmo
         pfbSV6JJzTAp58VxBJFK4Z4MydarmIdUxgcazpiLmbM9HXPB2XHFiwNCIqw3yFeuoT/U
         e/qtAgyBZCNaMkduLomZvFaxDi6vVSj/MoxKJHCYbgGWUvTV+sIbvdu7M99KZvi2IfCb
         f/fdcJmdR3pNAwM06KQVCVC13gMHzUx7WfwTUp3vMnI/wfJ2AMUQJ+ORxapotjwjoFFT
         8MUBE8PtcAKu8ENCnbkt+7gz/0lXwNiHx3T/l4mbllEgM+reL3XFOACyKz0LVdq8M8iR
         TqAw==
X-Gm-Message-State: AOJu0YykVbeVWKdKnZhQb13D4fqNN/Ax0gRMIxvI/ubaGtWZrJcFjLM0
	WITssqLoq3/f7IMH0KFL9pjns9lHarM6ogIXjH/aWvl5h1wvk7nvjw7Y5yRGIMk0hLamAdCf0F0
	PEOU+5h4=
X-Gm-Gg: ASbGncuND6MhLSl9XjHxi8q5HxesNC5ayFETbHt7Ve0xM8qAM2dQQPIqNmcgK8oKxuX
	ULYogxTD1SVGUjtbJ21saBDvUzkFPMUC6wTv79/7Qp7ERjns4oYr3GPZkhBIP8HuWQ1yYG+aYkR
	pNB2LfkXIIkeDFR1PQXCjE58Ahz+d7kqlywVGvnIwscshnRMuhtTN1vUFxo7Y4P4/twrlPF+qGr
	nx3TTwLE1/i8ycKcBQfNzH8Fe/cs72kJGMdy3AjYw2G38YPp7v0WnPKdTWSqmPPqm/6XDjeB7a3
	Knus8ZNWW1RqhnEpQB8TwRs4Skfa0MHUa9vK/4k/3AuKs3ZUpzOxsKgGsp+txBhReU67tAVzdab
	I2yva1iHhVw376U4gF+NJxs2p3BnVPayKjKKB8Dxo
X-Google-Smtp-Source: AGHT+IH+J2ksJWHE9wlc2DdApkCSzyuDKZhDPfgkFsW73ReYak7Yp4rEXJCgBW3utDTobFtFs7m3rA==
X-Received: by 2002:a05:6e02:1fed:b0:42d:876e:61bd with SMTP id e9e14a558f8ab-42f87418fa6mr68540705ab.28.1760031710501;
        Thu, 09 Oct 2025 10:41:50 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f9037c631sm12955045ab.33.2025.10.09.10.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 10:41:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/waitid: use io_waitid_remove_wq() consistently
Date: Thu,  9 Oct 2025 11:39:26 -0600
Message-ID: <20251009174145.2209946-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009174145.2209946-1-axboe@kernel.dk>
References: <20251009174145.2209946-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use it everywhere that the wait_queue_entry is removed from the head,
and be a bit more cautious in zeroing out iw->head whenever the entry is
removed from the list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/waitid.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index ebe3769c54dc..c5e0d979903a 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -179,18 +179,18 @@ bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 static inline bool io_waitid_drop_issue_ref(struct io_kiocb *req)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	struct io_waitid_async *iwa = req->async_data;
 
 	if (!atomic_sub_return(1, &iw->refs))
 		return false;
 
+	io_waitid_remove_wq(req);
+
 	/*
 	 * Wakeup triggered, racing with us. It was prevented from
 	 * completing because of that, queue up the tw to do that.
 	 */
 	req->io_task_work.func = io_waitid_cb;
 	io_req_task_work_add(req);
-	remove_wait_queue(iw->head, &iwa->wo.child_wait);
 	return true;
 }
 
@@ -245,6 +245,7 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 		return 0;
 
 	list_del_init(&wait->entry);
+	iw->head = NULL;
 
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
@@ -271,6 +272,7 @@ int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	iw->which = READ_ONCE(sqe->len);
 	iw->upid = READ_ONCE(sqe->fd);
 	iw->options = READ_ONCE(sqe->file_index);
+	iw->head = NULL;
 	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	return 0;
 }
@@ -301,11 +303,16 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	 * callback.
 	 */
 	io_ring_submit_lock(ctx, issue_flags);
+
+	/*
+	 * iw->head is valid under the ring lock, and as long as the request
+	 * is on the waitid_list where cancelations may find it.
+	 */
+	iw->head = &current->signal->wait_chldexit;
 	hlist_add_head(&req->hash_node, &ctx->waitid_list);
 
 	init_waitqueue_func_entry(&iwa->wo.child_wait, io_waitid_wait);
 	iwa->wo.child_wait.private = req->tctx->task;
-	iw->head = &current->signal->wait_chldexit;
 	add_wait_queue(iw->head, &iwa->wo.child_wait);
 
 	ret = __do_wait(&iwa->wo);
@@ -328,7 +335,7 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	hlist_del_init(&req->hash_node);
-	remove_wait_queue(iw->head, &iwa->wo.child_wait);
+	io_waitid_remove_wq(req);
 	ret = io_waitid_finish(req, ret);
 
 	io_ring_submit_unlock(ctx, issue_flags);
-- 
2.51.0


