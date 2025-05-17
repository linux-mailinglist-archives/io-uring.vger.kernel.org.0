Return-Path: <io-uring+bounces-8035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 180C7ABAA0D
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAA107B2447
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 12:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF091E4BE;
	Sat, 17 May 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZCTSaBm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A08D1FE461
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484805; cv=none; b=PzJ7F9PBYgx2cWk5oh2V95uqE1WhAuefG2tnySpb69GdHRdEY3tTMqflF9ecW5yycj8rMhLaBlIP6cpaAsqhItpfhlhenw+Fz3PcI3+PsK5kZ1sdM9X9HxIjxxlAifZksGkymmUbNrY9W3KgKrlpXI/sCY53GVAtQBhwcSj1PFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484805; c=relaxed/simple;
	bh=wwqmwSHGuMcphWYOqFlqdQdKlhE6qxJwk0TKJYMhdVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcfcR8hIKXshSmmlOcD6vfnDz1zjwf4J143dSb86yj5fu+uqlYAj+aVjDpjo52zrIUUmS0j2m7bO2Qz4OCNaQExKzda9hIpUNeN5P9KIjK5rQdoEwyAGEZSoH3vCBz284FILEmusE2U0Cav+vGNePjegLOFk6hDBRi8bRlHHga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZCTSaBm; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60119cd50b6so2566027a12.0
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 05:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747484801; x=1748089601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6AIGrE6xwO9m8j8JLMYgQdlF5CUsNfsUToxiz7mcocU=;
        b=VZCTSaBm11hZyXBg8VHvkoCAWNJusnoSerbaM7dgZ/Tg1nN9Ehn+B4z+UWXlYVC3p6
         90hyMF3s7aoqarcpjCr9B+whbAZ0q2ndtDKds1kJY+KoVidv7/Cy8EPozD04VHYMPYY7
         iryII6m3nAvFf1djTCyw6so7+tRjt5Trnb//IiXaDuo524Atv8gsN7ynmU5s22vWkBAN
         MVV/7eLd6bpBrHv4IwaqHlygIbghttXcUvNPAa0piQBWYr+guqs1mUGpxGiDEx9Jfj2y
         OFaRnqH/xWwR7i1+IhAyjtLCzL2fIJAlBpYunGsyKDseQXqb2xwhEmcDLqexQKDgIJQy
         L+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747484801; x=1748089601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6AIGrE6xwO9m8j8JLMYgQdlF5CUsNfsUToxiz7mcocU=;
        b=gogzlL864GnVCSoS1ljj3DAe5jgABiFZliVVybw/Z7kpEL9bTFw7EST01k7kJyQJE/
         5VicgQ1k8AlEeNCTkPUm8GG4ESmsvYBEaMHjcCfmThrQCu1EQYFguvXw77+vdGjWPn5K
         TXG1TxZSFvvK383ywlKIfGfLGU2DS7csr8f0PJJOKukEH/iBJkc/2tGBg8Av4JKtX3Nd
         Ti0Uw6S7zN6un8tISlov23N9TDJFMzEqhUAyBaaIv8ogSM1+MytR1FnD5zjroyC2ac5t
         zePkAFTtq2Wd5NJZc8V9UVDxW73MeCSa3XpiK5yrXTENvgPxTpvmCYV6MeSXWrwDcTZ4
         SxTQ==
X-Gm-Message-State: AOJu0YxUI/A56g4oU252m5rm6yLHOU4cREDYRse52YxgFgAL4ylAzCd8
	Lg8wxYoijtcQOR2S6G1GF9VNgFTduxCavvJwt4NfQpcuNGazyMsZkEnYLPB20w==
X-Gm-Gg: ASbGncsKG8baGW5H8kcEc5g3usLlxlpgZkm3EDmEyVnezOLYv6zJ8VlwTvRi/bUHNDb
	Z1MofdP6fm2gUEHmpXQBbrGmK6QRYSsdrVt3kxmI/G4pWQjki6dmldye+GWQehA+6bWx1jiJlAO
	udi/QAK/EGjLRx3hQhbF9oi1LHaoKPVCuBBi4MSGpdMChHbPlxi984U6R5k37NQFBQPVcBWQmRq
	6vAZEnOlgemRE1eqxPe83yLpecZkFQNam5Tb2N6on0qRF+caWRy8X+FT/oqsmvUe4q0VuWEkLcR
	4UWq6Af+Os8ZU6P0bpPsEW+Qr4+EIP6nvUqI0iPbQAbJkzhkYA1UFlIROxe5ZfjnSDBmeQKY4w=
	=
X-Google-Smtp-Source: AGHT+IERuSJZmvPNDScGimqOwSpS/fOCUpGrn3miS3FWph8Lf1L8CfZKUJIKs/XeqG/Xc2eBmn+onA==
X-Received: by 2002:a05:6402:3546:b0:601:a35e:6dd1 with SMTP id 4fb4d7f45d1cf-601a35e7008mr1268283a12.21.1747484801215;
        Sat, 17 May 2025 05:26:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e6884sm2876604a12.46.2025.05.17.05.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 05:26:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 5/7] io_uring: separate lock for protecting overflow list
Date: Sat, 17 May 2025 13:27:41 +0100
Message-ID: <396cf940ec7788299dd0dc278416295ea94ae277.1747483784.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747483784.git.asml.silence@gmail.com>
References: <cover.1747483784.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce ->overflow_lock to protect all overflow ctx fields. With that
the caller is allowed but not always required to hold the completion
lock while overflowing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 32 ++++++++++++--------------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 00dbd7cd0e7d..e11ab9d19877 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -370,6 +370,7 @@ struct io_ring_ctx {
 	spinlock_t		completion_lock;
 
 	struct list_head	cq_overflow_list;
+	spinlock_t		overflow_lock;
 
 	struct hlist_head	waitid_list;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a2a4e1319033..86b39a01a136 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -350,6 +350,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	init_waitqueue_head(&ctx->poll_wq);
 	spin_lock_init(&ctx->completion_lock);
+	spin_lock_init(&ctx->overflow_lock);
 	raw_spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
@@ -624,6 +625,8 @@ static bool io_flush_overflow_list(struct io_ring_ctx *ctx, bool dying)
 	if (ctx->flags & IORING_SETUP_CQE32)
 		cqe_size <<= 1;
 
+	guard(spinlock)(&ctx->overflow_lock);
+
 	while (!list_empty(&ctx->cq_overflow_list)) {
 		struct io_uring_cqe *cqe;
 		struct io_overflow_cqe *ocqe;
@@ -733,8 +736,6 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
 	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
 
-	lockdep_assert_held(&ctx->completion_lock);
-
 	if (is_cqe32)
 		ocq_size += sizeof(struct io_uring_cqe);
 
@@ -750,6 +751,9 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	}
 
 	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
+
+	guard(spinlock)(&ctx->overflow_lock);
+
 	if (!ocqe) {
 		struct io_rings *r = ctx->rings;
 
@@ -849,11 +853,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 	lockdep_assert_held(&ctx->uring_lock);
 	lockdep_assert(ctx->lockless_cq);
 
-	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
-		spin_lock(&ctx->completion_lock);
+	if (!io_fill_cqe_aux(ctx, user_data, res, cflags))
 		io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-		spin_unlock(&ctx->completion_lock);
-	}
+
 	ctx->submit_state.cq_flush = true;
 }
 
@@ -1442,20 +1444,10 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		 */
 		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			if (ctx->lockless_cq) {
-				spin_lock(&ctx->completion_lock);
-				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-							req->cqe.res, req->cqe.flags,
-							req->big_cqe.extra1,
-							req->big_cqe.extra2);
-				spin_unlock(&ctx->completion_lock);
-			} else {
-				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-							req->cqe.res, req->cqe.flags,
-							req->big_cqe.extra1,
-							req->big_cqe.extra2);
-			}
-
+			io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+						req->cqe.res, req->cqe.flags,
+						req->big_cqe.extra1,
+						req->big_cqe.extra2);
 			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
-- 
2.49.0


