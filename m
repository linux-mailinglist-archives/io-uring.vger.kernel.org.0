Return-Path: <io-uring+bounces-6590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC343A3EBD7
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 05:28:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD55F3A6CC3
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 04:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D0B1FAC38;
	Fri, 21 Feb 2025 04:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UvRAW7hF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03A23C3C;
	Fri, 21 Feb 2025 04:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740112013; cv=none; b=lenZ77hvmd0qzTBNU4cJWxfPDnGpo9W+CMyCpYY3xEXH5BMzbUarqeUGqzcqibpHJ4iqf40jx2oLBtGIbtBv16tIwY373t5WhScqr+sZqDKFq5pv0q3gEBZEfhLJclCLZnfL6vA6sriwEs7a6v27eQFWKOf4iXlA9iejfSPfIp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740112013; c=relaxed/simple;
	bh=8Mt6FHmscbecS4HWCKoB3mhPNsQqNqNkva5/wysqVnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUqWujKr7d/WNBDzr/DT1eeJo/96CNp6/cv23NekNS+awwRhl+261aNFNBvtVDTO8tixDpwAnmPCprBXGKDvbGElScWI9ndJlereAQCUoosYxcXcLbWLz2UI8h91EIyqOAT9yv53ko1laXm0tXkGMoVdzbrb+Y8dMdUaCR2glFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UvRAW7hF; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-220d132f16dso26162845ad.0;
        Thu, 20 Feb 2025 20:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740112011; x=1740716811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4a9IUU1712dSD2ALNafSIuGLe6LfOa8RVGjyEiqMDpE=;
        b=UvRAW7hFeFsTnXsZzT56fxp9T4Sh2bp2yX7KkEZzOtQ0f6lRjo48jGdDEmvhB2elSy
         OJMy9f6gC+TuaR6KQyM/3fqk4lHA2cx0BPFKBOgetV1AI8FNyLaNMTgI5eSKT6gqcqZS
         BXXF9uBE6neoWG6SY/kSmaKHNE23iwMqzlc4BKcZmwXQiooup4o6wGMDdEHlYP57KfOL
         50GM1Z+krFvyuOclkzNgufen2/ALzO12gAyT57QiPbrE5xfS9nIFaCF62hhOp04sB8aH
         R6ishFGXzdwmiHWWaJinRfKn7mMaq+LzHunUS8gVmxLwEddQVJX4FcL0EZy6w8B7s9iN
         vlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740112011; x=1740716811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4a9IUU1712dSD2ALNafSIuGLe6LfOa8RVGjyEiqMDpE=;
        b=TG6AoO6OV83haM+dzA1SdrVXYJN53jKBir8EJNE81p8ipbbVTdcZLhg4S1F0g1xuje
         ODaDY4VngpRGomjh0NNuz4P5nlbqzZOG/K8OnBXOseWk+6UEQpmsmdn1H9VyC0HKJmg/
         iWhZDhUcsIyKrD1FyiAJ5yrDLd4bmyPQ2z4DKKAJYa4WAlF4whjwjfspei74WR6ea+Aw
         I+Ztv8t/y0MYQUdh0fKWq6LTHNSmIbntZd2sogvWqI6X3HLgalrjIpDpB0ZvOGrrINK8
         nltpqiJy2HxlW5oq9gmEP+fX3+qebKa1VAqY8oW/PUuJCNu86y6IOGg1LiT3tUSC6gvV
         yeUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAadOW3xnLSQTS2DrbGfH+FQP1KNpNv/1tsdj19ZysICwFwycRZyBu+zJttY2zer37smEL71Vzpcj1k4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQmgTiFXy20zLwkAPUGE1f3Okm8pe/P/tZSs5cp9vyVAhs0pp8
	u4eJRfvUkI/m6C9EZibZn7e3Zl/tQIXbBfe6sxDQ6y4eQLtPW3PAxZGTqQ==
X-Gm-Gg: ASbGncsHaRGKC0OFFGvw5lT2eZNKEOX81CxfsG4VdF/PBkWWLgc6CbOQowRxpS4Fk71
	qJhrAWz3O0d8kqv054GpbO/cRy6+/dprxVCJwspQnn3nTFBfp3LGtKYx6yu1RfLMNsPgZ2qPSaW
	uTK6jeZln8XtXoxEU+XR+Mp39oxa86Jq1jejcnwNio7sp6ljakrTB0PvYt7bXxNW9wXkGYuayz0
	UKfwOxzVmwh9i9T8w5l4oAETvR9f7xS3Rci8q8/bTsPxu5EkWtyly67c1UcLgzXJGgXkQiQppcs
	tWVKwWypHhQoCFCARv+MMeCJz97n
X-Google-Smtp-Source: AGHT+IHvjk6ySgxxW1uWqkUPajK/eko4DUo6PZkbEPBWMzvlruzJbAphNapPAlaKLZ0tlOY7oa9iMA==
X-Received: by 2002:a17:902:d487:b0:215:b8c6:338a with SMTP id d9443c01a7336-2219ff32ffamr30271455ad.4.1740112010622;
        Thu, 20 Feb 2025 20:26:50 -0800 (PST)
Received: from minh.. ([2001:ee0:4f4d:ece0:cdf5:64ad:9d8c:d0ba])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-220d5586080sm128162165ad.229.2025.02.20.20.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 20:26:50 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-kernel@vger.kernel.org,
	Bui Quang Minh <minhquangbui99@gmail.com>
Subject: [RFC PATCH 1/2] io_uring: make io_req_normal_work_add accept a list of requests
Date: Fri, 21 Feb 2025 11:19:25 +0700
Message-ID: <20250221041927.8470-2-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250221041927.8470-1-minhquangbui99@gmail.com>
References: <20250221041927.8470-1-minhquangbui99@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make io_req_normal_work_add accept a list of requests to help with
batching multiple requests in one call and reducing the contention when
adding to tctx->task_list.

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 io_uring/io_uring.c | 13 ++++++++-----
 io_uring/io_uring.h |  2 ++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ceacf6230e34..0c111f7d7832 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1214,13 +1214,16 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
-static void io_req_normal_work_add(struct io_kiocb *req)
+void io_req_normal_work_add(struct io_kiocb *first_req,
+			    struct io_kiocb *last_req)
 {
-	struct io_uring_task *tctx = req->tctx;
-	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_task *tctx = first_req->tctx;
+	struct io_ring_ctx *ctx = first_req->ctx;
 
 	/* task_work already pending, we're done */
-	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
+	if (!llist_add_batch(&first_req->io_task_work.node,
+			     &last_req->io_task_work.node,
+			     &tctx->task_list))
 		return;
 
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
@@ -1243,7 +1246,7 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 		io_req_local_work_add(req, req->ctx, flags);
 	else
-		io_req_normal_work_add(req);
+		io_req_normal_work_add(req, req);
 }
 
 void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ab619e63ef39..bdd6407c14d0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -88,6 +88,8 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
 				 unsigned flags);
+void io_req_normal_work_add(struct io_kiocb *first_req,
+				   struct io_kiocb *last_req);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
-- 
2.43.0


