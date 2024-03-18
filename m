Return-Path: <io-uring+bounces-1127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBEC487F2E3
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CF25B22085
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7075A4C7;
	Mon, 18 Mar 2024 22:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COw/2wNr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0AF5B1EE;
	Mon, 18 Mar 2024 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799350; cv=none; b=R1GbibO6plblFxowFpvmLa3nJYnyJyAkpcz6ZELmowuTFooNc8BsOOoo9xBiJB8a/6gvQpZ+Y/PMY/oR/pHBhkN3vtA7FO5A8ReWra6VQwrMERq9srLMcAAsInHm9HxProUPsUZJgtLsPO6rb3dvut8ky6VrF06+ssaSGfUSdpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799350; c=relaxed/simple;
	bh=hfys4+yftUF/Eg+JX7tAPxBW3SY311Y0Eg1rWS0rdiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XS1k5BbflT4xXoSOL8GeRGMIbNpSryMgqIh6OEUFc1l1dtiAxKGkphhOsa5SsyIPzYEJA05lO0Y3WQL4O8/vqoAwhfRWsccm5tANqN5SLGEJFTRqD/VCgsbZI6wBuIPC7Fmqivy2Em/SPZwd+aljJdVNasNe1c4hUBUNdnMPWlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=COw/2wNr; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4140aadfe2eso15002775e9.1;
        Mon, 18 Mar 2024 15:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799346; x=1711404146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9xszpFpC2h6c5zr4j/9+f30Fztzglf7ofzCjanzBI4=;
        b=COw/2wNr477/PPoU56s+BOaiP4+7UYUU/lPoYTv7VhV5MyzNMa6n5zBfWmMh95jNB3
         I0hXaD8iC3/Zeo7Z4XGcPBhmg/YacdEZNYUIO1IRvd0fueoGQK2sP4LAQ8Thb4DCnj9K
         90oT16ULPVMAn3+sm439LSpESK/T4eTaN7slyk5uxvyJFErAShDWUMEf/zs/Hu5PQ5r3
         ANczJoeAhVBfjKFMJhRP1io31vngnS9PZpBSRlbWtyvXs3E2GapwnkUEqYF0/dZ2dglP
         6aH5Huq+MBinXqCWO7G1ROWnb+QQ5H8F1DPH9yaF+oqFKwezLR99o6mNiTSKGfT/LfEK
         8tRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799346; x=1711404146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9xszpFpC2h6c5zr4j/9+f30Fztzglf7ofzCjanzBI4=;
        b=wv+S/N6IWoBuveQpoK5BQ1SzCCDuC3nRIW5WUE5VvA0LouhsdKqDGby2sLI/zy/NRT
         Sh04TwpH+YFNqg8UoVbbpanDQvb7+uFTLpUFZr69GbF8I4bzrsoQ/yfNe16+RXhL7ttF
         oqDAkNGHst6q+F8vKgJAf3z+qSm0TdFKXxwJHl4vUr7RQnriybkJvhZPH10/QZtMmqzw
         bpPklVDZgnhJ+Kxq/FCJSC6sbZZ9NQ1YO+jmuLUsM3+jH/bMRUJnpfAGATX5SGKsQVYl
         G6yY/kINTd1eGsIlTpShP+8G1OUPYltFid8z4UoxTlPRlWu6Z90yRfSvkTAJlNV9W2QX
         UQbA==
X-Gm-Message-State: AOJu0Yzy962stLkOZxTNaY4ANPUb2j3T/c3RXEhwaSkg7F411cprg07V
	STxg5tGX6MOLXZZJUcMFPoqFvpq9h+PH3qGUMIaqvIz/XhZtI6KoVgytgIEY
X-Google-Smtp-Source: AGHT+IHyu+4co3oMLwzRvcdftxQwFCQ6jGwEcrCYjg4gnVrW7bX1akvxWlYEFdnVAn/FqcLeh5L23Q==
X-Received: by 2002:a05:6000:2c4:b0:33e:c8a1:148b with SMTP id o4-20020a05600002c400b0033ec8a1148bmr12050383wry.42.1710799346617;
        Mon, 18 Mar 2024 15:02:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 13/13] io_uring: clean up io_lockdep_assert_cq_locked
Date: Mon, 18 Mar 2024 22:00:35 +0000
Message-ID: <bbf33c429c9f6d7207a8fe66d1a5866ec2c99850.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move CONFIG_PROVE_LOCKING checks inside of io_lockdep_assert_cq_locked()
and kill the else branch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f694e7e6fb25..bae8c1e937c1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -119,9 +119,9 @@ enum {
 void io_eventfd_ops(struct rcu_head *rcu);
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
-#if defined(CONFIG_PROVE_LOCKING)
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
+#if defined(CONFIG_PROVE_LOCKING)
 	lockdep_assert(in_task());
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
@@ -140,12 +140,8 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 		else
 			lockdep_assert(current == ctx->submitter_task);
 	}
-}
-#else
-static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
-{
-}
 #endif
+}
 
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
-- 
2.44.0


