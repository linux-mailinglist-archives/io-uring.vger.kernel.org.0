Return-Path: <io-uring+bounces-8221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA876ACE29A
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 18:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 701B83A49B9
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 16:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E501F428F;
	Wed,  4 Jun 2025 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XCgr+1J5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B351F428C
	for <io-uring@vger.kernel.org>; Wed,  4 Jun 2025 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749056217; cv=none; b=amoa4rmKJUNYtnZAkEn0BI/6ScA88Uf81G8T0NCW5gpUTlHBR6voHHONeLjPdHoaISTOG3MXibedDuKpowC3/4CXfHJ4L2lAXzzDeX9983+rfXjiUofFiI2NMUP5Xr4vG45ZgrsLZJbeAdiA1XJxodi53P1JyJNvlq5xkOGiTgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749056217; c=relaxed/simple;
	bh=V5aJWEXPESsVChY3pFElpWHm2z8yFXqlpumQngHX/xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA0hcp8A30zHwUlnY/+ZI7rREEskFR2QBWCxWrNCfEGm+PLb7tbkVZH6NC9v6EKGJbybyYTeYqCwW+KFxUc1vESiww8/SOvY+KCCHezConHprgTyre+2K3D16D9d9iQN5XbW1NGdKsRrqTZsuz0Q/Pj0Wsb4an3hnQCqoWsOK0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XCgr+1J5; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-86d0c598433so143814239f.3
        for <io-uring@vger.kernel.org>; Wed, 04 Jun 2025 09:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749056213; x=1749661013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezhJUe8VryMscfL2f0E1UlhSBAKnfQTuAXmttGyJktg=;
        b=XCgr+1J5xQsrP8G8DyNBknD90/Rhyx+sfmGq35ZF0Yauw7dv65rd4c+8LJKAbkRSeJ
         A3fAVqn4XBzZjQSpC82iF+xsBFFyykmPXGGpneDPhcBnxglZhRBoprbQ8BWaolnu61O0
         Af0Wl7ELFmsoWewCyN99zoCSzMdwVisiGGqz2YnITHF0lv8PqXooLVQiGCxhzfaSNv2Q
         aJkEdFTyWqqEhiSYXgarKeCR0e5D9DKKoPq36Y8Hirj48XdqNXUA/5xd75BLJGKVeL2A
         X9ytgB+75QeWA5+y4QuvIeCEBmFdg5TWhmSP7JRdfjTtJkoOoAuseJQ1M9tou2XNdUZF
         eQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749056213; x=1749661013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ezhJUe8VryMscfL2f0E1UlhSBAKnfQTuAXmttGyJktg=;
        b=P637/xAsWSbh++7a/dLBAymD17O0+X9j9fZL42TsLh/MuhNDcjpp2DuhDHocG0PTmr
         n8/F+CPlAvIPP6FMIjNsv5+3dC8pXgH/n7NN3PrUiCgm3c8Yxhu+Ioil9jfLeuc46Uot
         tML+BuXfbOebvq6RMCoAqFDYk2qoxO12Lg+GoBwEYd96W96KNPOHQyBk/yK+3WwxBiOh
         dQsQovQaWvmx7J/JgCSVbX2RSJghDcEb2CF3PVSjih1/SbQpcdu0I+lL6ZCGIcJOB5Ce
         hfsBklH1wHWjAWlTTJ+b1ZeGmUZCvQI3pJs9XUQgN3cgyNaX9ZjGRajayquSUKDUBZmh
         8jjQ==
X-Gm-Message-State: AOJu0Yy7h7SDNahd160F+wo34uwFUoguErZGZ+bpjFG7U3TY/IOrq/or
	20hxrhuBpi5Q+pUqRFPSajeBHeH7Kx50apSSlTH9jKfMdprL9JOZDFpyN7tcBUO/r3QuUJkA9zl
	tx5MH
X-Gm-Gg: ASbGncsga5ZwoHJcalKqW8+l425ODs64py0YhlLDSmJ2PhLHCI4nbFSXU6AiG7EaYIP
	IGeky3/Yq1LqHlrWqrR+3/iB+oBwJ52EmPGx1B/J3cx9TqJVTMJhWbHi8NImG7GRTd6qoeXAfRT
	6XGD72M2xzaFWT/6Ir1R7dV7WdJUSFFQW2+OPLizbhqh9D21zX6zV04+FGYiqLejzQvl6xmK4Wf
	ELcYt2xP6dwaoEpPnXZeDXmCSY4wxyLworyuwB7V8DFf7leKq2JtZbVNB2YL6shoN5DfLEJ35Jo
	Fq/u4Js9QN8aWLYoCIOAglcY7k3mghZ/ZzHXcklqiY9WpNuSgpSlCu0L4mL7ggx5nA==
X-Google-Smtp-Source: AGHT+IFxP/EDSWEpU9rZalO5zyIfvYEYpfHamF2rSkJqymgbuiXTd8Kq0/v9LAljxXvSl0VSSK3fBQ==
X-Received: by 2002:a05:6602:6cc4:b0:86d:5f:cfb0 with SMTP id ca18e2360f4ac-8731c3b2f16mr470107839f.0.1749056213532;
        Wed, 04 Jun 2025 09:56:53 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7e3c18dsm2751391173.69.2025.06.04.09.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 09:56:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: rtm@csail.mit.edu,
	asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/futex: mark wait requests as inflight
Date: Wed,  4 Jun 2025 10:53:35 -0600
Message-ID: <20250604165647.293646-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250604165647.293646-1-axboe@kernel.dk>
References: <20250604165647.293646-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Inflight marking is used so that do_exit() -> io_uring_files_cancel()
will find requests with files that reference an io_uring instance,
so they can get appropriately canceled before the files go away.
However, it's also called before the mm goes away.

Mark futex/futexv wait requests as being inflight, so that
io_uring_files_cancel() will prune them. This ensures that the mm stays
alive, which is important as an exiting mm will also free the futex
private hash buckets. An io_uring futex request with FUTEX2_PRIVATE
set relies on those being alive until the request has completed. A
recent commit added these futex private hashes, which get killed when
the mm goes away.

Fixes: 80367ad01d93 ("futex: Add basic infrastructure for local task local hash")
Link: https://lore.kernel.org/io-uring/38053.1749045482@localhost/
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c    | 4 ++++
 io_uring/io_uring.c | 7 ++++++-
 io_uring/io_uring.h | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 5a3991b0d1a7..692462d50c8c 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -145,6 +145,8 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
 		return -EINVAL;
 
+	/* Mark as inflight, so file exit cancelation will find it */
+	io_req_track_inflight(req);
 	return 0;
 }
 
@@ -190,6 +192,8 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	/* Mark as inflight, so file exit cancelation will find it */
+	io_req_track_inflight(req);
 	iof->futexv_owned = 0;
 	iof->futexv_unqueued = 0;
 	req->flags |= REQ_F_ASYNC_DATA;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c7a9cecf528e..cf759c172083 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -408,7 +408,12 @@ static void io_clean_op(struct io_kiocb *req)
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
-static inline void io_req_track_inflight(struct io_kiocb *req)
+/*
+ * Mark the request as inflight, so that file cancelation will find it.
+ * Can be used if the file is an io_uring instance, or if the request itself
+ * relies on ->mm being alive for the duration of the request.
+ */
+inline void io_req_track_inflight(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0ea7a435d1de..d59c12277d58 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -83,6 +83,7 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
+void io_req_track_inflight(struct io_kiocb *req);
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
-- 
2.49.0


