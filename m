Return-Path: <io-uring+bounces-6281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A68ACA29B28
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 21:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 923123A40F1
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 20:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62000213240;
	Wed,  5 Feb 2025 20:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="waGbaed6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BA41FFC61
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 20:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738787212; cv=none; b=DN2hDg/DApJjsBpdWIX3RDbNeWngQP5FpCKbbxGDOFnJbeVAlEck65Xx5ZRn3prS5MFUlkroj4WhQqRZ2cqKVdXkis5wKarHBkUImJZFndlc6ipOtWABgnW1aBkiftD64h+me4LH+vachs0JLWDHoIlygS7PpNaDyXIbq7ndDoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738787212; c=relaxed/simple;
	bh=VSh/qgctDDo70xZToc2xt44ObMTteCk44UQDOLdRMfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKPxiOYkjaAUPhXPUQ3SBMJ8IVeXeYOBvNr1cxAxB1akNfDdfI4oawB8TNAc8aUBcqqvpwyWnmBTQFl/u+zxQIJDC3pg8oDS2WYYy3fAlpNQKOQe3Slc27ub5FGZ0FuQtl4zN98G8n3Mu+nNm+LIIaY+wF9S9e3ZLku2QQqI164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=waGbaed6; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844df397754so7043939f.2
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 12:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738787209; x=1739392009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9w38RAf5sLwFs/ZAYF5KaZ561nlRfCQe/pBXsxlr91I=;
        b=waGbaed6qFDGkoMp+3IJW94Z0tcKhSm1nCGvgNS8ulTWgEl+emt1HicdG6i8mkr1XB
         pnISdGM4n7W/sSRbeIpE2ynbVz9c3UM3YKkT85dWsLGh7WeEGBfW5Epdwlfnq0mIstK5
         oodtYRN1gN6TwokuDswsNjQEMvrUsE/yCcH7XNQi9FCgtc6Z/35Dwwhn+gd0oBDDzD8C
         ITFySSDD6mHNxEjSrrLrE+g5nCJLthlfhBBDb3MDwUXM5uLNFpU7NqDnlm6PcqODim7H
         YX8IJBfWuzsVlj2jAe/AHF48Ktnx3HtMSBTUKwRGtcOOqgoUiAuZ21jJOL+iHt95xjao
         zmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738787209; x=1739392009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9w38RAf5sLwFs/ZAYF5KaZ561nlRfCQe/pBXsxlr91I=;
        b=V4zQqWkh0mQlRATMEXCp4QHal+7ddYglNzAR9roa1HJZ73jkLj0QJf1EtnnZdgyuMm
         QPNQ7mgY8QjKAWgBwMJxO0BRDkLyIt3ejtIN0O+120buVKsWHcwT71s4U4nYA6K8f0/G
         af6l+fivxWUVDxfle/EIsgIN/Zd1lKbYfpi4M6yTGsk4N1DC1Q+RuDQR/IAicw+O0V9f
         bbn9vUQNADQFgmsWaS5z5NV4qL+5XBfqQqcACF/XLFXPpTIIGeHrWCuNgAu0eIpiQVfF
         8mjfNUWiCZ5IQR00WCljdPLet+3u+vetox1xRzp/3Db6AqCItzzlQPkn1gzHVbkoKRgl
         yagQ==
X-Gm-Message-State: AOJu0YxKB7YxbIPnPooFUuvAsE2ph9irpBTtpJd7HGsHsGFqCT0Pdgk2
	oEpaqueSbATAa3PeV4nnAkHvU6i2KEpFHdD+5o0gXiW3RrffKHe+oYfVTnCS68ndISJ/og1wQsE
	g
X-Gm-Gg: ASbGncs0UHekV1aPd8o7/+8SuuHblQPD68bzVkjAxpggpH72jwn4n82yyW56evlLehe
	WCBNJE6NYlquWRwvgRjnPkDq9VozoJhDYfcoEUrD8FjxekUOjMW4OHWfZ8IJa8jTC7yu3k2p4RI
	kUsy//hx8QWDYJNnmBaK7NLne6FYCrsO/IzTTKPjjLtWtrPJ1ZVb9Ed0Ry35ho8NWK5XoXptsLx
	QKkn0Bw9KRVzqeHsjwPOVVveYmJA2df70u3N3o0b3nt2Uhn5PYOd+UBGYzNI4O/Eq7Ybx6nTaoq
	R0m5Frsm7LPA5UUelw4=
X-Google-Smtp-Source: AGHT+IGmuMVnewpmLgLianVG4flO1vjA12na7iPrShrn9Yjp97PhsDXU2y2Ms3mXHJqxVfoAkBeOgw==
X-Received: by 2002:a05:6602:750e:b0:843:ec8d:be00 with SMTP id ca18e2360f4ac-854ea5188ccmr438213139f.13.1738787209453;
        Wed, 05 Feb 2025 12:26:49 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ed51sm3352071173.23.2025.02.05.12.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 12:26:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring/cancel: add generic cancel helper
Date: Wed,  5 Feb 2025 13:26:11 -0700
Message-ID: <20250205202641.646812-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250205202641.646812-1-axboe@kernel.dk>
References: <20250205202641.646812-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Any opcode that is cancelable ends up defining its own cancel helper
for finding and canceling a specific request. Add a generic helper that
can be used for this purpose.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c | 21 +++++++++++++++++++++
 io_uring/cancel.h |  4 ++++
 2 files changed, 25 insertions(+)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 0565dc0d7611..4ff3771131c2 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -361,3 +361,24 @@ bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 
 	return found;
 }
+
+int io_cancel_remove(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+		     unsigned int issue_flags, struct hlist_head *list,
+		     bool (*cancel)(struct io_kiocb *))
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	int nr = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	hlist_for_each_entry_safe(req, tmp, list, hash_node) {
+		if (!io_cancel_req_match(req, cd))
+			continue;
+		if (cancel(req))
+			nr++;
+		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
+			break;
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+	return nr ?: -ENOENT;
+}
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 80734a0a2b26..43e9bb74e9d1 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -28,6 +28,10 @@ bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  struct hlist_head *list, bool cancel_all,
 			  bool (*cancel)(struct io_kiocb *));
 
+int io_cancel_remove(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+		     unsigned int issue_flags, struct hlist_head *list,
+		     bool (*cancel)(struct io_kiocb *));
+
 static inline bool io_cancel_match_sequence(struct io_kiocb *req, int sequence)
 {
 	if (req->cancel_seq_set && sequence == req->work.cancel_seq)
-- 
2.47.2


