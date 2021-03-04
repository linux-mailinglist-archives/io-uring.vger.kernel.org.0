Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B51832D9C7
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhCDS5X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhCDS5J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:09 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BB9C06175F
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:28 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id 7so28858005wrz.0
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xgu01T0H18N+r3B1fYX0zg3olFEUDIjKtyxJfrnYvJg=;
        b=HldqZBMa9yu63NcbWvja04QF0eUyeU0xlOzBro/KXPMw4QVfrUIacWlmMYDzydjM25
         EOODxDhklyWtj1AlV6zKEodbgnFZueIs13klevvI2Tz1cQDp+nNyXF7s+FMn8XWZAf8h
         7lnR2iJLCzZwVpnV6LNNVOKbN6u7tSgYGI2Wlqat/6Gmlt7P7Upf2aIJgRp1pBd84NJr
         3Wb4rL2LlrLzU92vdyuX0WOPqMRPcsmMOHORGvv/G4uM/Myxg3e/+XYEoGcxWXcq8Rja
         upxcT9yzlEvQAe+23yerMwtqSnh/HksLiBBt99HHeToGjBgre/SvH3+R4d4r/eVVyvF6
         RD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xgu01T0H18N+r3B1fYX0zg3olFEUDIjKtyxJfrnYvJg=;
        b=SS58cgDVlkzZLxqvZA53E7yckZy9tZ/uQ/CpN/eb5kyn2bOUUjrVJzhARKO378HTfh
         lzdqMJsdR8ViSGmmqxs9K1o7JGslHTFwp/RA837Yq4O3/WZHlsP2L8PftkdAqQKFuBAW
         r9YJtlKu/N0rZvExZo+Qdc4Pmut8taWfxL7eZKXdC2fxH3aDcu7rwj17Q/xpj0zRWFrg
         wUIJcXx14bC2/F4CtRsgDKXJtWZuejLwvhOGBncVymgEVzBHKcJb1t8TdTf1hbqj30zg
         SKkDCOHPDL+WWT5xkNGL1MI9h3OKVlT+xXp9AgT8gJdLTKzQowaw3wBB+By+ml8n1VBY
         bYow==
X-Gm-Message-State: AOAM530Cn+UrN+8X6WgcaIqBnhYPK11QOHWnJ5P6PBQPz3wcN9mACErs
        d4wTP+19nlelxoR/k7JBdoe1zir8PAYiQw==
X-Google-Smtp-Source: ABdhPJwPEspgT/KGBBRt2JKIY55NcPqbZ2ghyhIuxoqidFcd3ItkGY2GPFbDAJXgTr+h/PFeOW2SFg==
X-Received: by 2002:a05:6000:188b:: with SMTP id a11mr5352684wri.151.1614884187779;
        Thu, 04 Mar 2021 10:56:27 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/11] io_uring: optimise io_uring_enter()
Date:   Thu,  4 Mar 2021 18:52:16 +0000
Message-Id: <e5d74e4b9b25cd510c9bc85040f7ba144a8220dc.1614883423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
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
index 36d0bc506be4..9175ab937e34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9001,31 +9001,31 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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

