Return-Path: <io-uring+bounces-953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2F587D049
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B68FD1F22563
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9B23D982;
	Fri, 15 Mar 2024 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+K/5dvd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC1F3D396;
	Fri, 15 Mar 2024 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516674; cv=none; b=pYCidgnUvJO5YQS/5PrhZfgc65d74HnjCLJHIIjgyN4SWg/VAhSvSG6yF/YY+9ousyXltsYSptkUQc6GQF2/xUIUoD1a2OrJxKp34rgzfAsyvTckOOdykvhIp66hlxm6hjDSkOyL0SMnQTfIyynBTAlPgTliFAhhB4cidZ/5ELQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516674; c=relaxed/simple;
	bh=oftQEKh345/gTaOfwh9tZhbjwTcfq5CN3JVoPDNxuMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0duRztsmOlx41F0JKe13uI/LMMLh+lovdXxl+tr2xF5/kRp+fObJthfC9BMdF5tPzsM5hXpxXJeTfOiGkXrLwNGhvykn1l86+poccSnKugCLQOdfg+Bd7Pyala+4U0TllyR84zNW82soWspBDqqYbxvbrz/nXrKzVbidHW0zrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+K/5dvd; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-33e1d327595so1463936f8f.2;
        Fri, 15 Mar 2024 08:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516670; x=1711121470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Lql2IHeg3l+zlV9/JRjb/JI8yw+EcE5DCy9istQ0cI=;
        b=Q+K/5dvdwd7+rlbeJldswHUq2CYOfb9Nt5LJZvk4OAcgq64hRTaPWPvcdA9F1xO+JK
         cA1OTM6TJC7ZgajgLtslBcXgn7gMyd4wgdv5bqcVzvlyxqowW0K8XqbBBK44s8or3zLg
         P/tuV80xHDFKQIfMEHhFgQlYH3yHkIDlbdRl5E+E08oWhdVgOW18Sr7qmZUj8IB8g/qA
         gfGo5k5+MGGCgXTL9cDROIN1jbgogojr8ABfLohsVtKHEXRv4zuLA61UfnKvTC9Uxkgc
         hYUfuAQbECdsvgeKWvkwDH/uLlwWmPrubV7/B7eBQmwOh2Dnv7sXhAw1T9goZZ78YUFh
         0qlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516670; x=1711121470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Lql2IHeg3l+zlV9/JRjb/JI8yw+EcE5DCy9istQ0cI=;
        b=n/9gwrfWm1PcHDWs331mNslK9mDsa+jUNygl/ArsNteTptFVAjoh+twxKEy6diaOjC
         lXutHX/2eO0Bues7qAvvK3DikT95myDF2YLmdhjPVJUY+iB35vtuQ6Otp1Oecv2XYhle
         klXDmuybCyRme4UrgRt9IEO1RDLA2pUdlAxcvDW1BaqH+AYMBMajuRwotF8mHyDvPFur
         2NCGnifQb838EDn/mA7hOFhw+jeljVFBJEk3mbb6/o6k1AnKQW9Zj0AW4egTSbCqLCNZ
         MNIglZuzpm8Ed4W6p2wfvAU17QOrDz4U+s33TSHmcmmLqdO0uekeIJxG8ll7DggPsnY4
         chjA==
X-Gm-Message-State: AOJu0YxxHamDz3FpZt81PSs0UId1gskCB9VSEvEq1DyDVytsw0Xlm2JT
	y9UGYpJyEY6GogikNFxBTDxMhZbW1ToOXZgAjCjs3cvF58KxOA+2ZTrWfLdV
X-Google-Smtp-Source: AGHT+IFNyaqBSE9MwjIzQU87Q7dsGeCH05fauXIAogeW3Q0L/1Cvh4D/iCk2oyVNfpZmuHVL64dxpw==
X-Received: by 2002:adf:f60f:0:b0:33d:2180:30e8 with SMTP id t15-20020adff60f000000b0033d218030e8mr2839231wrp.25.1710516670298;
        Fri, 15 Mar 2024 08:31:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 01/11] io_uring: fix poll_remove stalled req completion
Date: Fri, 15 Mar 2024 15:29:51 +0000
Message-ID: <c446740bc16858f8a2a8dcdce899812f21d15f23.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Taking the ctx lock is not enough to use the deferred request completion
infrastructure, it'll get queued into the list but no one would expect
it there, so it will sit there until next io_submit_flush_completions().
It's hard to care about the cancellation path, so complete it via tw.

Fixes: ef7dfac51d8ed ("io_uring/poll: serialize poll linked timer start with poll removal")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 5f779139cae1..6db1dcb2c797 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -996,7 +996,6 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
-	struct io_tw_state ts = { .locked = true };
 
 	io_ring_submit_lock(ctx, issue_flags);
 	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table, &bucket);
@@ -1045,7 +1044,8 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 	req_set_fail(preq);
 	io_req_set_res(preq, -ECANCELED, 0);
-	io_req_task_complete(preq, &ts);
+	preq->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(preq);
 out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	if (ret < 0) {
-- 
2.43.0


