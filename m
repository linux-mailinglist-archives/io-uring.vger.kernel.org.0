Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C3755A918
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 12:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbiFYKxc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 06:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiFYKxb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 06:53:31 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA59F1CB20
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:29 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso3151072wma.2
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qJrhBFpF10IM4q4cMndXnFTorXE6d6zjBVBWHT87ASc=;
        b=SugC85Z7XfKmBdezmux2bq55mfuFIS51zeuvd1UcTpw7HwIJG3xH3tjw6lanySrcOW
         TWfsGCqlWpktI1iw0SSa2GNHCUKCm+fK5Z9LqbP316qtIsID/9mg5s320NtlBlou8O5y
         wS+H2ke2ezKO5qF5KRpQwdTo9BmwVwJZUQ4BtdC0XQCoowVn1AWBTHJqKBzadQ6G4Ft6
         Kh5C93cQ0V1DDrB3vXSON6+bKcoLmVJAiPs7XaYOp4xJbtLGoQWn2VFzETIkxD1jgiVP
         fzLsLJpHjp9YYzXmmazNKSiVbqe/MaxybxS/qZgj7kGwgWaA2bBaYWIDdqru4Jf/NLfY
         91Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qJrhBFpF10IM4q4cMndXnFTorXE6d6zjBVBWHT87ASc=;
        b=MR2bYQS7yZohgjVnpeaRK1JkRfaNY9cLZRablLo6yIoXgAmVhsKjXgw7TXJbLTquVf
         KIRA0+ZHziFgn12YSYthTaSznp9VLm6TOAY7e2vpL+SZBiqz3utu17Ug/o2QmW71hIVH
         9711Zo9sjbpW11lRZi3fkn36Jxj4iQcTwPyLxCTqyOy/L47bNoIj3xb4DesTq2ReYRsD
         B9fkXAzV3WbGj3w4mwRm8pQqwgLcQzSxXkO1h3ty9CzcOkuI4YdfL68s2liva9qaxNkL
         pRO6T2KQ4DVx6swgdIDnzQ9HUS2y3oY91Xt9JeD4NyZu7u3LljT6qlEeRR3VmIGy6G54
         Irww==
X-Gm-Message-State: AJIora9nryGAZIQwAfTNTIKdo+ZBty5442Mjz3vO1YoKms4zND1BWU1D
        qaCnwrm6ZDF9VMcos/QeJQlUS0W/LIRwfA==
X-Google-Smtp-Source: AGRyM1tpHk3Z5C01kbwwBdcuzkfOEtVic7+DBDJjeCBi+/qQiVApKILc+SdeC0Sre8P1nIas0ql6dA==
X-Received: by 2002:a1c:7903:0:b0:3a0:3936:b71f with SMTP id l3-20020a1c7903000000b003a03936b71fmr9007735wme.168.1656154408115;
        Sat, 25 Jun 2022 03:53:28 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b0039c5497deccsm15810144wms.1.2022.06.25.03.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 03:53:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/5] io_uring: don't check file ops of registered rings
Date:   Sat, 25 Jun 2022 11:53:01 +0100
Message-Id: <425cd64fd885b8e329a46c205ee811987691baaf.1656153286.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656153285.git.asml.silence@gmail.com>
References: <cover.1656153285.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Registered rings are per definitions io_uring files, so we don't need to
additionally verify them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f40526426db8..e1e8dcd17df3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3036,22 +3036,22 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (flags & IORING_ENTER_REGISTERED_RING) {
 		struct io_uring_task *tctx = current->io_uring;
 
-		if (!tctx || fd >= IO_RINGFD_REG_MAX)
+		if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
 			return -EINVAL;
 		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
 		f.file = tctx->registered_rings[fd];
 		f.flags = 0;
+		if (unlikely(!f.file))
+			return -EBADF;
 	} else {
 		f = fdget(fd);
+		if (unlikely(!f.file))
+			return -EBADF;
+		ret = -EOPNOTSUPP;
+		if (unlikely(!io_is_uring_fops(f.file)))
+			goto out_fput;
 	}
 
-	if (unlikely(!f.file))
-		return -EBADF;
-
-	ret = -EOPNOTSUPP;
-	if (unlikely(!io_is_uring_fops(f.file)))
-		goto out_fput;
-
 	ret = -ENXIO;
 	ctx = f.file->private_data;
 	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
-- 
2.36.1

