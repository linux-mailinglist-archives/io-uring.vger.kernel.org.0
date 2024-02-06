Return-Path: <io-uring+bounces-544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D5384BAED
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BCEEB22F38
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE9D1AB7E2;
	Tue,  6 Feb 2024 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OrkvPyBX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA64134CF1
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236857; cv=none; b=tbxdGBka/DHjSkI2wnIY1vK85gS66qP9lwVl88iET+x2cA4nep8oxsQa1i/Rz1FIgAvjD36sYl9hBKFIdxeeq1PlyMi3hkzFWt2Znmi6K7KkToEPb5Sb33MtWIl/pL+k6FW61R/e3ROVA/gIQdVrfALspYQJAsUCpUBtCUGsTMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236857; c=relaxed/simple;
	bh=/uHETyTBZ5h7qZwyyhN1Chur+FqysGNL2prClNI50i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvhwI2wbjy3F1Agmqn6ITJahRmQ+4+dEF/EdNj4hydEq7AWh6l3mO5M/Ys7QhW65WzEaWBTQ0vni0OzCVEsjo0V3u/zMWG7gDHjpc8SwhqHlq8XICJXKjz9p9wQ3fxDOAa7b9K3WrF1b8uku1F1vfKBCOPcWCjJPpFyKr5+VoRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OrkvPyBX; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c3d923f7cbso16620539f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236854; x=1707841654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0G9AMUuGqGEDC6zSd+LcpTCMkoymgzlo3crEie7Dr0=;
        b=OrkvPyBXXJ1qfrBVYEshgLv4wiHebH57J1HnXumXuCwrkXs2NGq7EHuNwZZ6vDYWPR
         8I9A9n8TjjcA95M9nvecxcYugDWS3Cmxh5DEps2BxW24RZRtdfGGLjLHaTjuDIDX4k2j
         OZnTnRmcJZ31DqXMQp8JmWevfouiusJzjmouQd7Z9bI7yiW3YP9JxEbMf+0qt/+TAOnJ
         TQtCXqiQkGwPqh9PMSRWATJvGiLcTF6/Q+PtnrSReTsaUZBp16Hqi0vNCJUWzowRm8tx
         4LyZCXrWc2f8Ym29CllbCmbzaXBqxOPatZOIbPlxsEqImvndZiLHq06dcCQ9jGVF5Yyq
         //+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236854; x=1707841654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0G9AMUuGqGEDC6zSd+LcpTCMkoymgzlo3crEie7Dr0=;
        b=buiiotaJRIA3KMx6+KwJqWYhoEToH/yEDTRfhksWUzzYzAtNpXyPed5WApf+rQYDmh
         vp5pUYJ5QxDCKPoEdP5hWM+1+lRe2BqjDYILyDQVS0PiJTJ4QjzuGPbCTeuND2CJLSx3
         awGI9s6k5e+BD6h6SMPYFKCPXGdQkHDt+jGZNqRfQuv07ik0ZMUTj5BPnZhuiQ5IT3IF
         yqi8t6mFdNyyAk4BJr8RdinOBrHx7UbaRr+KiNSs6BUuIVuiUKY0ceIP8RExPkG2sSS4
         F5J9xjcUDdF5dTWJ1zRQKT3um76QoK83PPdDI5MCVYasTNFtazpANa4m9q1jmvJnhaeJ
         QdHA==
X-Gm-Message-State: AOJu0YyEP+IUHvuxCofvPxbHdrDFsBdDz+MYsJvnU0wpaxHbg6p1/A8q
	HlzZv7ZbCvNWdxFN/X6JTJfMtyBpu92wvTJVPShekh5339eHETOvAHLuFnAbTeZHqySXzgexIgW
	9aY0=
X-Google-Smtp-Source: AGHT+IEQNVU0P/YlEuTbp5ja6SAZzOSTEw4UZSIHRIaxIHf5ygr2pNAFKuVwuE7AKftgghAWyvVy9w==
X-Received: by 2002:a5d:938a:0:b0:7c3:f631:a18f with SMTP id c10-20020a5d938a000000b007c3f631a18fmr1205470iol.1.1707236854176;
        Tue, 06 Feb 2024 08:27:34 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/10] io_uring: remove 'loops' argument from trace_io_uring_task_work_run()
Date: Tue,  6 Feb 2024 09:24:37 -0700
Message-ID: <20240206162726.644202-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We no longer loop in task_work handling, hence delete the argument from
the tracepoint as it's always 1 and hence not very informative.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/trace/events/io_uring.h | 10 +++-------
 io_uring/io_uring.c             |  2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 3d7704a52b73..6bb4aaba9e9c 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -602,29 +602,25 @@ TRACE_EVENT(io_uring_cqe_overflow,
  *
  * @tctx:		pointer to a io_uring_task
  * @count:		how many functions it ran
- * @loops:		how many loops it ran
  *
  */
 TRACE_EVENT(io_uring_task_work_run,
 
-	TP_PROTO(void *tctx, unsigned int count, unsigned int loops),
+	TP_PROTO(void *tctx, unsigned int count),
 
-	TP_ARGS(tctx, count, loops),
+	TP_ARGS(tctx, count),
 
 	TP_STRUCT__entry (
 		__field(  void *,		tctx		)
 		__field(  unsigned int,		count		)
-		__field(  unsigned int,		loops		)
 	),
 
 	TP_fast_assign(
 		__entry->tctx		= tctx;
 		__entry->count		= count;
-		__entry->loops		= loops;
 	),
 
-	TP_printk("tctx %p, count %u, loops %u",
-		 __entry->tctx, __entry->count, __entry->loops)
+	TP_printk("tctx %p, count %u", __entry->tctx, __entry->count)
 );
 
 TRACE_EVENT(io_uring_short_write,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ae5b38355864..ced15a13fcbb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1274,7 +1274,7 @@ void tctx_task_work(struct callback_head *cb)
 	if (unlikely(atomic_read(&tctx->in_cancel)))
 		io_uring_drop_tctx_refs(current);
 
-	trace_io_uring_task_work_run(tctx, count, 1);
+	trace_io_uring_task_work_run(tctx, count);
 }
 
 static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
-- 
2.43.0


