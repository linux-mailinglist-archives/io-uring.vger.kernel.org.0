Return-Path: <io-uring+bounces-8012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD71ABA47E
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 22:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1102DA2609A
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221A827877B;
	Fri, 16 May 2025 20:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z6Z+ZhDr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD2A22CBC7
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 20:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747426217; cv=none; b=I5YQVhnJXTnkP6VGlEFRse3vFjbIjfgyBlfxsE5TQoG+AFRF1SSn+dMxfNkZH154kcgc5b7JiWJCubeXtV7Kc18WFEqgLifCt8UNxIV+19nBtWb91BTZZ913HOS/92Gb+HL7NH04CMzJhMejQ3HjPSt8RmGzT4oUUzoxRxL3dQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747426217; c=relaxed/simple;
	bh=B4miw11E8+F4hDn6gaweVOClQS/ePUurXZ630838n4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7uJiKdlqRT/4OEWM56BfRM6VZwXrjulbEp/GHUvuD4DUStkLRCVGJ6AJVMSCY0UYxZfgwXWiKdj9OhnSEHHZ1/ES2fADieuELonAOFIhTl98/f07P7NGFLGO2Knr8+quhMKuc9R/WnJ6q/A9THAOXhYG0m3P40gtHQeC/NtBr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z6Z+ZhDr; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-8647e143f28so174490439f.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 13:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747426213; x=1748031013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HJx6aGlrUMdBwX/fJ0o1D0Yp1uA0HSU1NzqN7BUEbpI=;
        b=Z6Z+ZhDrRdqRiqlthS8hao8BOynh4phjbfsrTy59Hq1pB4FGhZUvE/g4/PuX57uTsv
         UaiCO6qJ6DMbsrZWvwHMw+UBDCI3IFGPUTjYGRfnV3d5h6uXCtpZTnmaIq64aSirFURF
         ioie5T6ucXTc5GYkspNKQeACjIu8vdcOVnQ4OpftI52eJ/1Hk+ew7dJc00YlmESjCx0N
         KZq6Td6xt9nzggLGaaQ7xFhZG+ZZrQPz4Db5R/yTg3WQyc00OPzO2IQ6VBQAzOqbzWF+
         AS/VLEO8Tj6maKr3qQeeiyUqenAbgtCQGGMwqxWzQiJQeSX1SAnQ105tW3DfhYuml0uX
         lkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747426213; x=1748031013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HJx6aGlrUMdBwX/fJ0o1D0Yp1uA0HSU1NzqN7BUEbpI=;
        b=dfAzNb6uSsLOlJZ2AfQNEmcvuK1q0e/CcRhP0d7Mp+qGzFxPrB5AS2kv3WNiy0vria
         99ViP9Ey6sYCUeSEwt/DcHAvYstd0g69L4iKKBFtrLJFqqQzqHfKml2vMBEvaAs9HFdw
         XtruvEu7r3/RYGbXIagG99WA5ykQieeFRHMMuIZdv+xoarN6uasgY5PSVpGVvw0f2MGu
         tVCV7aUzIgvoODvBwUe1tSYnOHiNBbscZJVJVo5wXv0/j5oDQqS/4YiYxz7q71EfxpDz
         atxj1Zu6rjd9UlmbKLjroKKZpUu52f+p+0gOf/scm0+Tn87uKqEk2KKgUCZyvXaNF/3U
         Fm/g==
X-Gm-Message-State: AOJu0YyghUB51TqXCUzse0u6dTbYynXzW1v1M9yDHFDl2xUZTNVLY7Jx
	nEbo61GPfxSu+CVctSROqp/WYct5LL3WEYOSg5b0nKc86EZgkm2n+c9y8haUxuWSZMn43FdphuC
	DheQt
X-Gm-Gg: ASbGncvQ38AmyMoNzBmyNPKYFODQ1uKbbpqiUmYzpI10c2I8hQqa29C6ichhA1L/MGn
	EmvfVXVxr/Nae01L8maVLrXF1G1nKNQ3j7PhG8nrAzMao0Qfh5zsZ9PAAeOdgt3IpO2TTUk0MAE
	JjHt5gOUbye7GxtDQA34UdX2JyJf7UUCrH/QqBzShE0LIs1HCEF8jTD15CSw8ysX/4eeunK+AUK
	7CziG5HMpFz/kjMPm+46rE75a+rQGtvuiW+yUlCda/YC9kBMF+76x6BAscEj/CWHvfUJoVh5K1V
	P7Fjq6wZM6Ms9JQwiXBRa/do5iyMJeJ+iXdAp0j2YepIXRjff/zBRkEe
X-Google-Smtp-Source: AGHT+IFYccz7Sy+e/C4H137i2Y4BBYWJVaAygo9AKM30BDxToCJ3mbQyUPYKZ2RtDaUVvL9jSUie9A==
X-Received: by 2002:a05:6602:370b:b0:867:46b2:f8e9 with SMTP id ca18e2360f4ac-86a231b0bfcmr823843739f.6.1747426213007;
        Fri, 16 May 2025 13:10:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea4b5sm541805173.136.2025.05.16.13.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 13:10:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: open code io_req_cqe_overflow()
Date: Fri, 16 May 2025 14:05:06 -0600
Message-ID: <20250516201007.482667-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516201007.482667-1-axboe@kernel.dk>
References: <20250516201007.482667-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

A preparation patch, just open code io_req_cqe_overflow().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 43c285cd2294..e4d6e572eabc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -739,14 +739,6 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static void io_req_cqe_overflow(struct io_kiocb *req)
-{
-	io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags,
-				req->big_cqe.extra1, req->big_cqe.extra2);
-	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
-}
-
 /*
  * writes to the cq entry need to come after reading head; the
  * control dependency is enough as we're using WRITE_ONCE to
@@ -1435,11 +1427,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
-				io_req_cqe_overflow(req);
+				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+							req->cqe.res, req->cqe.flags,
+							req->big_cqe.extra1,
+							req->big_cqe.extra2);
 				spin_unlock(&ctx->completion_lock);
 			} else {
-				io_req_cqe_overflow(req);
+				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+							req->cqe.res, req->cqe.flags,
+							req->big_cqe.extra1,
+							req->big_cqe.extra2);
 			}
+
+			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
 	__io_cq_unlock_post(ctx);
-- 
2.49.0


