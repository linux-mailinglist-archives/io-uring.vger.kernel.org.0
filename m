Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FBE342348
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhCSR1E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhCSR0x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:53 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDCFC06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:53 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id 61so9869304wrm.12
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ojuizKBUD63d/EMdMYwotEsTLmGT0Y0Xjg5j99nqIbA=;
        b=jhA5P4pC+A6Bz+U2+tSVPL4ZFm8Abpns9wdljK8tzOAMb7Pb8lPW///mn4hlwIcNb6
         I04f1Hs2yY7C3r+wqXhXFXw9tbRAir9YsvhwKB5jcLhJzUmvvbUWbKQuG3G9RLG1OsSn
         Njdm0wHPspJeUe0vJKVbnfCLVe95QfcmO0XvrdyhDh63mtxlBlRLNByUSAhyG41Fqs47
         nnuGadbphMC8mzx2GOobjHEZEHwZtMfG9lI4MsJHcHZTuafn318IDyRvp+osSXi/9jJm
         8Kp8EmyMmP2h0xLoFLlO03HnzSy7Dr58Llu5W8/Cr5X5IrWkq3xehZpR52PR0QyRvEj4
         o0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojuizKBUD63d/EMdMYwotEsTLmGT0Y0Xjg5j99nqIbA=;
        b=E4M5wmH17apnV418M9LlZ1vFRpmaJRH8H02v4zZUaQae+QryxR1GvRQ5wrI1AHeHjl
         0A87+mvVbBNdJp7+aIheBilGg557xkAx7TgwTP9rFIwS65jOs0NYRS+1S8IoIOj6CVhD
         p9vzLWmgNeOmX7cL8XBYu5cLslBu8X7AjAd68zEOq3T8ZTwdSbBHBJpyKL37CDE3mB1a
         Tf9+KXSWxrbre1U4rsrVK+xYwN7Lp9ldvrtA28HJU23R+mM6ynPPJ2ng3yOM5a1ZDcKO
         mwllAP1ka+mehLvTtQnNJPmDyVEZgGf/c54cSCpqyQ58CtuSGTDo43RiHGTeMmFdbPuG
         +i7w==
X-Gm-Message-State: AOAM5318Qzr/W3H3jpTxMS5ZzA9MX4Atn0czCUKcQzUo3FTvgtla4Unx
        UZtbd1mh0UzpM77dVGw+Js15OAhjoGLqUw==
X-Google-Smtp-Source: ABdhPJwJTchT6ixQ6Mk5s+Zb5OIQzj6FvTJRarQm/Qxi1HxGY697cAkqzs65ABQs6sbEbkOLPfpSPw==
X-Received: by 2002:adf:c101:: with SMTP id r1mr5766579wre.38.1616174811975;
        Fri, 19 Mar 2021 10:26:51 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/16] io_uring: optimise io_uring_enter()
Date:   Fri, 19 Mar 2021 17:22:30 +0000
Message-Id: <6c391e07e5c2de877d256a288ff751c8d892a751.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add unlikely annotations, because my compiler pretty much mispredicts
every first check, and apart jumping around in the fast path, it also
generates extra instructions, like in advance setting ret value.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ef8809b851f..439f95111b18 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9138,31 +9138,31 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		size_t, argsz)
 {
 	struct io_ring_ctx *ctx;
-	long ret = -EBADF;
 	int submitted = 0;
 	struct fd f;
+	long ret;
 
 	io_run_task_work();
 
-	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
-			IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG))
+	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
+			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
 		return -EINVAL;
 
 	f = fdget(fd);
-	if (!f.file)
+	if (unlikely(!f.file))
 		return -EBADF;
 
 	ret = -EOPNOTSUPP;
-	if (f.file->f_op != &io_uring_fops)
+	if (unlikely(f.file->f_op != &io_uring_fops))
 		goto out_fput;
 
 	ret = -ENXIO;
 	ctx = f.file->private_data;
-	if (!percpu_ref_tryget(&ctx->refs))
+	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
 		goto out_fput;
 
 	ret = -EBADFD;
-	if (ctx->flags & IORING_SETUP_R_DISABLED)
+	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
 		goto out;
 
 	/*
-- 
2.24.0

