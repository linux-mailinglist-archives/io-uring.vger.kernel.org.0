Return-Path: <io-uring+bounces-10389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09310C37A14
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 21:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7373F3AC40E
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 20:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA40280CD5;
	Wed,  5 Nov 2025 20:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LpYng92y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BDA126C02
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762373000; cv=none; b=I0Uo/UEXmVt4w4bIsZI6VxQCJVX95pcRYatWvznDQ+jfeS+j+B9te98hrqjRqVhmFif4vT/oHOE2cjYZHBo0X8ZbWQZQjOQRPwxXMFfPhl9Leop5ypvQUjuFCMUjLCN6rozwGkLFh1J4juoEkkVUUDpyL2sdk2V946BhjBq2/8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762373000; c=relaxed/simple;
	bh=IuqzBaRDi9RltXOyW3ytMzQ1DCQbKzuPXDj5p7jftOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKrDLiy6PLnBErHBYEVwNsbX0UWKr4RFuxPoVUHSVYtTwQsJcHo3ZHgBqZ1MAMB6Ccez5xRL+L36PrSoLG8eSjATpe2kwF63c1+sJ1oxdvszJY0nLXmEgwWPAFGPpcXfrgzoeR9Lbrlb1GwQmCS3fliyvK723ymxFeXzijxijNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LpYng92y; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-433101f2032so769605ab.1
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 12:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762372996; x=1762977796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hA1WLdD6ZlF3Bd7iyTsGvpgc5JcvOH0yNSmA7W22cS0=;
        b=LpYng92yqE/qPGBULZmKuUgLmSHPW2EUixkVdZwi7mbmifWKmSFdHA4t/v/yqwBvFO
         i1SfVtNCaR44nciDzL5Qr5rxhsSVQXBRbdsOhzt3WMhv4FKCM4pB4DV159LotpZRC0cY
         rVU5AOYrO/sl4Dto2RcrPx+fwMGoxzcXmmdBmlWSpmVI5R/Koo65DyA0dTjRLgJb+YlZ
         ZFcv38czos71DDLBORtOBNJozolYUANlzl/gy1PvNcVQZUk6Y1pI1HzB6mpPBijEJ6/v
         m6im9JGcX9L/NQtn1AZc9dBmuZ5RP3CY2j/dXAEXJxFm7oxBlI1HEa0qmoXlXiQwt5ln
         +79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762372996; x=1762977796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hA1WLdD6ZlF3Bd7iyTsGvpgc5JcvOH0yNSmA7W22cS0=;
        b=TRk42ZHq2sgrmcuzJmM4q6SaTHIEWhO5J2QlluGk1P5Lfq7qG/dMovk2MjP8gtlmCN
         c5Uo3sUiybbqeuIc8agLdNOtO3OBXlpxgrJPM8kgg98eNsyqF1LTa++lAccNfXt9t53r
         ET/MgkchmtbD9UXFGFyj9C8Gcf03B0oiwV4lWNsHDm6ChxBSfggIlp5y1tiEoT4s/zAO
         on6GnImaCrArVLBpLWP3Llk/8H6ktYmHJ2J8cmdERWIv5RNBARfc98hvFYruGaUokAn7
         IgqUcuq8/yi70ywzUxepEFhR3FtdAEZgHiYOzFjBwluW43lDqZwaP/D2tAHdUDWLmUY8
         g65g==
X-Gm-Message-State: AOJu0YxTDG6OTyKj28Auoh/W0WGX6CJN8ibS8Ac9lsSd5SiR9o6x9OXw
	HSrh70iai8d/BDQtdW0uQP2jdDoIlIbwWNlik8endLZZf0Yz+0STP7OJBt4HZ2SZEQSw/LgyceZ
	e366h
X-Gm-Gg: ASbGncvNrxkI7FrG62eOLms08LFzT4birSBL9Vrqt6yh2JF2dEC6F8LTGTwHo6J0a5z
	Mo9uiynXy4+r7xc5xv7iZs63Hnn5vIH/EfIIh0PiafZU4iwgifcy9UL9wTe0GR2Sd4QQRxqAdRC
	HaX4j2YXyMj9lUHTgy7fHYDWal3JoyJmgPcQ7F851z0OmJIbgvI1obM0Q+aNzwwzP2B5e2mFMzY
	+v+23A42ejGo4adNY2yfPZg5kPnsL5JwFSxQULZMTIDQ0ZXkIwbkmw4xv8FmOSA7/b1ADVHm+qm
	M9mbufabqJ+uwaJYRG+qvsMwn2GWiQA1jLfdfl2rQs0xhdpoE61nxblooZ4qiuz+ZwCkfpQGSRY
	z5Z8HrhFp7kwxuPRb/FMjwEUEyepW25jVbL36BiJRqO8CAXcwq4w=
X-Google-Smtp-Source: AGHT+IEpXRya+N9pPoK3+WkBRBumYmLfT0lDpzNm8RXKdK0D6lvPwK33xt6Gw9AXBDLnETjkcQ9K2w==
X-Received: by 2002:a05:6e02:3182:b0:433:27c1:75c4 with SMTP id e9e14a558f8ab-433407dac54mr73359815ab.31.1762372995832;
        Wed, 05 Nov 2025 12:03:15 -0800 (PST)
Received: from m2max.wifi.delta.com ([99.196.133.153])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7469631cesm49632173.54.2025.11.05.12.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 12:03:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/futex: move futexv async data handling to struct io_futexv_data
Date: Wed,  5 Nov 2025 13:00:57 -0700
Message-ID: <20251105200226.261703-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105200226.261703-1-axboe@kernel.dk>
References: <20251105200226.261703-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than alloc an array of struct futex_vector for the futexv wait
handling, wrap it in a struct io_futexv_data struct, similar to what
the non-vectored futex wait handling does.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 4e022c76236d..bb3ae3e9c956 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -28,6 +28,10 @@ struct io_futex_data {
 	struct io_kiocb	*req;
 };
 
+struct io_futexv_data {
+	struct futex_vector	futexv[];
+};
+
 #define IO_FUTEX_ALLOC_CACHE_MAX	32
 
 bool io_futex_cache_init(struct io_ring_ctx *ctx)
@@ -62,14 +66,14 @@ static void io_futexv_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
 	struct io_kiocb *req = tw_req.req;
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
-	struct futex_vector *futexv = req->async_data;
+	struct io_futexv_data *ifd = req->async_data;
 
 	io_tw_lock(req->ctx, tw);
 
 	if (!iof->futexv_unqueued) {
 		int res;
 
-		res = futex_unqueue_multiple(futexv, iof->futex_nr);
+		res = futex_unqueue_multiple(ifd->futexv, iof->futex_nr);
 		if (res != -1)
 			io_req_set_res(req, res, 0);
 	}
@@ -169,7 +173,7 @@ static void io_futex_wakev_fn(struct wake_q_head *wake_q, struct futex_q *q)
 int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
-	struct futex_vector *futexv;
+	struct io_futexv_data *ifd;
 	int ret;
 
 	/* No flags or mask supported for waitv */
@@ -182,14 +186,15 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!iof->futex_nr || iof->futex_nr > FUTEX_WAITV_MAX)
 		return -EINVAL;
 
-	futexv = kcalloc(iof->futex_nr, sizeof(*futexv), GFP_KERNEL);
-	if (!futexv)
+	ifd = kzalloc(struct_size_t(struct io_futexv_data, futexv, iof->futex_nr),
+			GFP_KERNEL);
+	if (!ifd)
 		return -ENOMEM;
 
-	ret = futex_parse_waitv(futexv, iof->uaddr, iof->futex_nr,
+	ret = futex_parse_waitv(ifd->futexv, iof->uaddr, iof->futex_nr,
 				io_futex_wakev_fn, req);
 	if (ret) {
-		kfree(futexv);
+		kfree(ifd);
 		return ret;
 	}
 
@@ -198,7 +203,7 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	iof->futexv_owned = 0;
 	iof->futexv_unqueued = 0;
 	req->flags |= REQ_F_ASYNC_DATA;
-	req->async_data = futexv;
+	req->async_data = ifd;
 	return 0;
 }
 
@@ -218,13 +223,13 @@ static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
-	struct futex_vector *futexv = req->async_data;
+	struct io_futexv_data *ifd = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret, woken = -1;
 
 	io_ring_submit_lock(ctx, issue_flags);
 
-	ret = futex_wait_multiple_setup(futexv, iof->futex_nr, &woken);
+	ret = futex_wait_multiple_setup(ifd->futexv, iof->futex_nr, &woken);
 
 	/*
 	 * Error case, ret is < 0. Mark the request as failed.
-- 
2.51.0


