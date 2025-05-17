Return-Path: <io-uring+bounces-8025-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10527ABA9E3
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 13:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04CAA189DEF9
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 11:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76071F63C1;
	Sat, 17 May 2025 11:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CTm7j3LL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14F91F4191
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 11:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747482588; cv=none; b=rlQ+DSHReL0eeMfm+9AG2U2LNvBH4JErWlf5TiGUGOdyBc6bLVMXFir0qLFusGqHH8FIm1ofKZjp9zH6e/aLYN12i2CHOGJhjQFN5I7wKxLOFondiVfERk9m8Skv+1sB/j4pGtCuHURCK489syoe/ddmJievCe6i1snLZuP/Gj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747482588; c=relaxed/simple;
	bh=B4miw11E8+F4hDn6gaweVOClQS/ePUurXZ630838n4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/l/RUq6m6fUXoN3z4sJZGItLRMIm2RCYscvRYquLHrY3OVhoY+aHp6E/BzceH90Qg4WZ1JEybj7y6fpoQwNVY6rylo/wvVxjlyLyX2TcidCgISv286QsJo+u2P9at5mD+mSub1yMtZBBsOhlN0lQzbjXauhCB+v35V0tRWZ86U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CTm7j3LL; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3da8e1259dfso21976565ab.3
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 04:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747482584; x=1748087384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HJx6aGlrUMdBwX/fJ0o1D0Yp1uA0HSU1NzqN7BUEbpI=;
        b=CTm7j3LL1rROvozRQLtqblCUlSl5MTXVuJB+pI0+mOnj/WbE2PNPndtemuL8Ck78T7
         2S+H2IBug+7kU/tzY2RMpE7MyqwQo5D01P4fWs8a8LnFm4VbNfyQ9qmHq5LM77G+qn2q
         mcnECLO4guhVxTbUb9kEU8/q6Ol/zks/dlekpPGprpbraV1IrOQR9LrVe6VC0nOKHC93
         aifZlBs5O64c+u76+W2bAbZaIvR7Ah92zVNgtFWlr8QrWAMsUGLS3fHJGUxLuJxV2EZD
         ZIaKMM5SwJIoHN0tL6VI+vh+bVKuIZr5nRWS7TtSvei+plE7ULHM4u5m0vAGo0KVFjjr
         nPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747482584; x=1748087384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HJx6aGlrUMdBwX/fJ0o1D0Yp1uA0HSU1NzqN7BUEbpI=;
        b=mjFPikdR6cm3rWyDuHPKXnQwexhjUWN0gjP6GiMyrCcL/KMY+BFH5nrQEFhiZXrXue
         y2XaSJvdgbNdwag3wwHw4dW1lX8bUT24jJp9bIQLGxuizV+/CmaWuXDnFfXNdXZ6z1Ri
         zukTqUrcxMbtzWbXpv+EqHy3IUU9Xr7AY1ePjm0bhAmM7WwdTdP0EsgR+0GMA/mw+QFG
         i3w4bGXwObyAfK0vPRkBAIwsSoADD4WihrYfazqrelnqJlhKp6bLTTnSQaiGlkviq1wD
         2//y1VmZQ0yG9VbLx1qc3Xou1SJepiRjvXzTBs9Sdjib0V9TZnFBpdaIEqT8OOm9e0oP
         EVqA==
X-Gm-Message-State: AOJu0YzI4ZCzlHgtHWox72bIC/qectGSrnG6+7x1HwR4fJg0WtN9EFIB
	cy89Y5m7MeyL2BkjGzgZNBaqfpCa8kWH6Xh52nCv6xju9sqlUGPLVz80tezsSlRfMdbYQgCe6RE
	HO6JH
X-Gm-Gg: ASbGncu/2hoCoCifO6F1vyg7tvITAzkTYPIS4k/8/tWtzjYBOrZDrbSFBTTqHzV1P3N
	DiyMC/ld6nueGGg4xy8MXWWWbh/Nt+TktLx2y4PIOj9TsvPj/8+C17dou/rv9xTeemUnKhR98kH
	lqSboYXRsU4LLO8IvhKZKhRKHfo3tidt9L9w5vVAWjvDA8U4DavHxJQNJqJa8HYbjv9QwSVjx9H
	2QV4IjxEPiKT+ZoTvWzT6tw/0NPmhETKRlgL87a2mDQlSVkbtUsGdsDFe807KWSulzr4hL/G5/N
	xzXnZRcKFaZRk0v0vTtTxWJCkB5IDmO+lZE9dGzhVDLLD/jgHjpYguoC0pLRvSkmoaY=
X-Google-Smtp-Source: AGHT+IGtYbzUWu1BMTmd8JOe/0FfkHJNOojidnA7dJXqCaZV53raYz4buNehUSs7xbVAYU83OzhiiQ==
X-Received: by 2002:a05:6e02:2199:b0:3d0:1fc4:edf0 with SMTP id e9e14a558f8ab-3db857a6ee7mr62445685ab.15.1747482583938;
        Sat, 17 May 2025 04:49:43 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1a8bsm874354173.47.2025.05.17.04.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 04:49:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: open code io_req_cqe_overflow()
Date: Sat, 17 May 2025 05:42:11 -0600
Message-ID: <20250517114938.533378-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250517114938.533378-1-axboe@kernel.dk>
References: <20250517114938.533378-1-axboe@kernel.dk>
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


