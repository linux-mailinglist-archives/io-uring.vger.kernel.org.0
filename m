Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF1F2249D9
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 10:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgGRIdW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 04:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgGRIdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 04:33:22 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AF0C0619D2
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 01:33:22 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so15245849ljj.10
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 01:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=P41I8jkEYXXtp+u/LOp9eji2BQhb82sQn3mAp0a6kEc=;
        b=fI868TO9kiaWtV2JluCG3DhbLpy93YF5H1+Ws4OuxwBW/kGjMz21d3GbmWHdddv9lc
         Zby5O57KA8f/zlQRsYXS8jO02Xz9Tsa7j/+VcQPDoBRI/3OIx+RR7uYEP5nEDDkISsGM
         I/5hLD1B0jP1UWaGRwGKiBD4IzYYqpB72/1O9llQ60qq1bB3xHWRAYGc+LGVYQDUfz/2
         iWhrYlg5pq7kJAA04ukZx0jqly3ElzW3+hmMYY1VI4DkR3/g1r4p80b20gz/IhxXX5en
         u0QidmfWbt50Gky58WUKknTmQnG+ylZCdfhZOtKTpg7ce16LGoING5TatJ08DxUWVMip
         yrsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P41I8jkEYXXtp+u/LOp9eji2BQhb82sQn3mAp0a6kEc=;
        b=M+1kCoK4B4KJr9bYRgAOCpck/Ao9ZDF8NQ9Et9ozvPAMc9jFXMr5ohs3WYLrkqFHdh
         tfRSwtGXTTTJZCjvbbmavn51gQj/nKdGXup1M0Q/kfB5rZUPiXCIg3mmNhHKF3qKgHX/
         CoOlq+wY3i1o1kWTnlDzZTsgalLq+qlScd/jdQ4nv8Oxahp2V+lLvwwrYjDGp7NPMK69
         0Km8p2+jSru0N9qXFxnmSqcaWcOqHEEyXdIhVIOTR6k+Y4t3DbUUngkx40TuoPweI2fw
         UTXwbK6ENgm+Kvpd9/ufE8JmVa8rWzrdfH/kC+ANcAkTt+s3vWdHgQ4CF1sGUaEAhvzi
         TDAA==
X-Gm-Message-State: AOAM530JmdPHXMFgJjJdyLdCwtGf9tBrQja7Ei23dwBjzo5oHjR55BqG
        AaYUr/KWxTuGg4x5KmcGqAA=
X-Google-Smtp-Source: ABdhPJznolsUA0E4ctgF/757drBANVDEIEwJHk3KIxHSVwtH/F/cdd7rDHp9JaPtClY+Hf3+5dXb+g==
X-Received: by 2002:a2e:9042:: with SMTP id n2mr5691187ljg.208.1595061200523;
        Sat, 18 Jul 2020 01:33:20 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id e16sm2089451ljn.12.2020.07.18.01.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 01:33:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: return locked and pinned page accounting
Date:   Sat, 18 Jul 2020 11:31:21 +0300
Message-Id: <bb87556b53af8b3dbfc79eae8ee0a90acd328ed7.1595017706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595017706.git.asml.silence@gmail.com>
References: <cover.1595017706.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Locked and pinned memory accounting in io_{,un}account_mem() depends on
having ->sqo_mm, which is NULL after a recent change for non SQPOLL'ed
io_ring. That disables the accounting.

Return ->sqo_mm initialisation back, and do __io_sq_thread_acquire_mm()
based on IORING_SETUP_SQPOLL flag.

Fixes: 8eb06d7e8dd85 ("io_uring: fix missing ->mm on exit")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e535152fefab..57e1f26b6a6b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -980,7 +980,8 @@ static void io_sq_thread_drop_mm(void)
 static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
 	if (!current->mm) {
-		if (unlikely(!ctx->sqo_mm || !mmget_not_zero(ctx->sqo_mm)))
+		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
+			     !mmget_not_zero(ctx->sqo_mm)))
 			return -EFAULT;
 		kthread_use_mm(ctx->sqo_mm);
 	}
@@ -7244,10 +7245,10 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 {
 	int ret;
 
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		mmgrab(current->mm);
-		ctx->sqo_mm = current->mm;
+	mmgrab(current->mm);
+	ctx->sqo_mm = current->mm;
 
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN))
 			goto err;
-- 
2.24.0

