Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C8D328B29
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 19:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239303AbhCAS3d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 13:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbhCAS0j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 13:26:39 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712A7C061797
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 10:24:48 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d15so1961425wrv.5
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 10:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1elmTManS8EJhtqYAj2p48WpqAFInfdzdbKldXVjWIQ=;
        b=VxNymRE9z5uandSXgls99GjnKAjKyejeiP6lMFMb3f35xiT5/EOHajaESTp2ClbBFo
         LjLI2ngwx9ouiHtsZz3ZEz9tGRQPrPVaTZat8apZtCMQxmVaGIq0dtNN2MT5ucLx//RW
         VXmFGAD/iJh0kZVpI00iURZg1P0gc4tuAyBUPtz16joAuzPG+mbrLX6oMSG8unqckKb1
         l1xLB6iUX3zVCt8I1qhncXOahv9qvJBuoDfppS6cQ8HgYO58NxFrIgVz4jleSesdh9oe
         s8Om6rFaHdzLpXOEhNcOvPF7jTvGPGJ2x12+3czCsgMpDSeYBrH3VD/cqWjfv8feeN93
         jJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1elmTManS8EJhtqYAj2p48WpqAFInfdzdbKldXVjWIQ=;
        b=A0JZr96eNh2oeNYMtIqMQinI8uELbyDvfmy70GGxDjd25L6MemrQECiprM9gOIewaz
         dzgbRhMXaxaqb/eAvIgStCO531mGLdvykvrnSAfZjWJi7HRbB7hNLgstwqq2cD7ivMYK
         6o7fCfkskqpDmCawePTTiJM/xu7F9Rdznwq7eUTxqTQAXCCQ76CZB/kXLxmJKdxf0Yna
         sS/dlak15S0CAFXF+KL0DBU0OnLZxwpi6r3y0cQck+iHV4jPh+JuMWDhDgPExlbgVOGU
         q21iu8/kff9ax9f90qpkZrMCR8nSgJAd79Dtk+hogXS5HVgezX1lbg0UKNsp5PMDWPq/
         srpw==
X-Gm-Message-State: AOAM531Induk+h0b75CdFJizt1QAhkF1OjvkDepvp8HVXPHM9Qf0AOzG
        VZ5btZURdw1YE0dKvUMWdCT7LoZUkTBQxw==
X-Google-Smtp-Source: ABdhPJx4W08Lv3oFj8oWCtlOCtgsuPgMK5bj5UjI4Ta6B4kJWFRx9H10n0vQeIxELsuZwuV2E1h7LQ==
X-Received: by 2002:a5d:5149:: with SMTP id u9mr18659979wrt.348.1614623087291;
        Mon, 01 Mar 2021 10:24:47 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.35])
        by smtp.gmail.com with ESMTPSA id q25sm125146wmq.15.2021.03.01.10.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:24:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: choose right tctx->io_wq for try cancel
Date:   Mon,  1 Mar 2021 18:20:45 +0000
Message-Id: <095c880d18a0338dc5f57435c6f91ca3666d8b90.1614622683.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614622683.git.asml.silence@gmail.com>
References: <cover.1614622683.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we cancel SQPOLL, @task in io_uring_try_cancel_requests() will
differ from current. Use the right tctx from passed in @task, and don't
forget that it can be NULL when the io_uring ctx exits.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0c363529a836..34d0fd4a933b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8615,7 +8615,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct files_struct *files)
 {
 	struct io_task_cancel cancel = { .task = task, .files = files, };
-	struct io_uring_task *tctx = current->io_uring;
+	struct task_struct *tctx_task = task ?: current;
+	struct io_uring_task *tctx = tctx_task->io_uring;
 
 	while (1) {
 		enum io_wq_cancel cret;
-- 
2.24.0

