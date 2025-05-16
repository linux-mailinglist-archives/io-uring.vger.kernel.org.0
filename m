Return-Path: <io-uring+bounces-7997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F5A7ABA154
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF7B07B84A0
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13BB1E3DFD;
	Fri, 16 May 2025 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SWXgVt2q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A15214815
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747414528; cv=none; b=FfXGpSCd3MZsfZQQ5p5rWRhuQLdEzbcN2zVQ51HdTuRADMMAQ7puDHvhb74YCPoZeY0lhfHEzkm5t1ievtepDz2AUiQ7SsXHvKl1L+fjecG0/mjoQfMTotW7Q6rmlsFt+jurYwOjQIdXK7nPzpb23RsgjLPEQDc69ZjrZ5cXYDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747414528; c=relaxed/simple;
	bh=MPzt99qZwQDMT1q5zGKS0wr0iOvtdLU+mGHGdX/ZSxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxiV7aPUfrujiwz2emfx8YFRbbn8rWOuN0fp+UYMg0zBz6+cG/iN0TEXeN15N8raM+Gs5ecgIAqV7WTVCnm9Nd51KXRg5IjHoKZLLblZBGxfNa46qN4MvAciS3TPynZb/9ter9bwkSZgRlhRv5FRrBkKiQG6tDOe+0S2+iHLii0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SWXgVt2q; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3dc5a6c7212so1799505ab.0
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747414524; x=1748019324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1YJgicoRJI8ZFOiVPst6q8WsoR+xv39V+7tmh2Vm/yU=;
        b=SWXgVt2qjxsjjafkWwlpQjgrcWcBCLs2ZFGAvDbH1wVMHR1bSo2+wM3FV4PTRIZunv
         VkaSBqobtxQNxiiTSPACIeJG7PdULHsjFfTjh80ohFLHfWjMI1ZIMTqc9wXVoDZiPrMn
         sGggPzKopQNvdkmtyj+GcSwTtcJD45cxKwI5U1jLDpWonhEsFcvNIPYtDad5ET8dxZh5
         zy3mAz4B9opDhMuNoNvN3pc2q27fQionGJE+fxXvK6G/dmGBpZiHaKLMFBYyM/oZi8TY
         2PYeusbmoUJ52qQI/NketfqfMTfBNZy+qW/wlaDK1bBjxKW5ivhvKo5IOMthZkDS6C1I
         WLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747414524; x=1748019324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YJgicoRJI8ZFOiVPst6q8WsoR+xv39V+7tmh2Vm/yU=;
        b=AP3iAUUquHev1aFNQotNPSjh1DOl+/dOqdutx2OTdMKiWVp7VwljlEcEWhTM902yr7
         CbmBYsenXSw5d/87rJzVdhXE1tFlL+m4l2W5cdoLr9NgO97nvhxt3f3+I/IYvybRPy8O
         R9b6eCxIVIODVjgatKJagYQtHiurHQhjvEj3/ZbXHeQ+SQkwtztFCBgeA+SxAFPSgxTU
         S//9xjUAPYo0YtVKDL3BS6gdOVadRIoPmZFkeqnpw0QgayHVEfWkDl4KQCib7Nd0FOwM
         6SxRDSt8EcJRYdITA6r1EbWQQlyD5+yAbcwj+Dvoa1yIRtkUNxmYBZLkQkzhteKqr9cp
         mz0w==
X-Gm-Message-State: AOJu0YxlSN3EoBZWLvLU/CblNoo/SmNUDZJa9G9F46qIke7wfHxsFbFa
	nXCgoBTOjWUCAG3ShU0jfhXJ70w2bIAUYqbR8Ktru6ZRebIvrrg2o7aCo0Loy/0lX4qBZ5W56x+
	2WhIc
X-Gm-Gg: ASbGnctlpIBR3UCr3u+kZFLlJlem+HcyQtiqNo2OZGY+JVKgHqwfT6SjEzDRZRpiSWL
	Cv022IUcr/Uhx4795s/XmyCcT2oXA6uujUqMPbe9gM1Eg1IrysfzLchySXXWY82so7SvoE0vol/
	d2eYNHiIM37mmI1wVHx8hRrEYvwJqS49NmUGOYptkyDyWRp1ti9Cj0ZymvJDLDYPEC3fkOqG+QF
	Ao3DbjVRStrkt0Y9sqlllknsHLMBMGHPHcGG8/2dFIJfiLxvipgK3M+wdeoVdlqyKPZpNkfVHDh
	VsSVmXkDF64t/9CM20/doZPpVUPzGq+himOvaMd/WXjFtbAV+k38EBo=
X-Google-Smtp-Source: AGHT+IEiS+zhuiSAeIs4uauXGWPGYbsZsj7pS8i4DHipflOKVRmtl7HucPdj+/o/6YgKEiTCRz7h/w==
X-Received: by 2002:a05:6e02:2592:b0:3d4:2a4e:1272 with SMTP id e9e14a558f8ab-3db8435667amr52325465ab.19.1747414524477;
        Fri, 16 May 2025 09:55:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a87csm480344173.10.2025.05.16.09.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 09:55:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: open code io_req_cqe_overflow()
Date: Fri, 16 May 2025 10:55:10 -0600
Message-ID: <20250516165518.429979-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516165518.429979-1-axboe@kernel.dk>
References: <20250516165518.429979-1-axboe@kernel.dk>
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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a9b8d35349b..068e140b6bd8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -760,14 +760,6 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
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
@@ -1442,11 +1434,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
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


