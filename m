Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719F54E7276
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 12:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357465AbiCYLzG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 07:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiCYLzA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 07:55:00 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B48AE51
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id p15so14845639ejc.7
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u6NfcQdJZf2tqyQ5ldUQO5ltdCX+yq+Ey+5+Vmvwf7c=;
        b=JIc61DSkdcmUDG4lbkamnncShigVTm5EmFY0bLQEX7fszGtPqbvHMKizTcOh5RHxx8
         IIQJuTe3aOigvdSRJvmG2X/FTv1VblY+7chKrOxTN8v/D8txY2qLeCLljlg3wRRZn9ZJ
         5e+Mztn8E7vBeuQJy0i1tGb9AUnKGaVefGFNiuGSz4UPq2f6C7bJ6H1djY2OSFnsUqqJ
         ch5hPYe+k9cWK3drPIoIlTGR3qtW07brLUrn/KF4AOqQvzyt7K+GEBlkG5cBXB431s0Q
         iKbZdelFo3dnGWMvO973ntk1mVqr329Dqp/mIvoDOyfW+AzEAsWN/lAf+wB8HiPdjxk9
         saeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6NfcQdJZf2tqyQ5ldUQO5ltdCX+yq+Ey+5+Vmvwf7c=;
        b=tJA0y9nBtPfs2rKydQUw0tS3kBSMe12AQjHzbTMyK6xdgLq6cmFvgTdFzGteY/yMP/
         jeffssGKIE3LeoXJ7slkhND69VOfTJLk6fSyQHgP7V59oyc78L25Ild8MSRh2I9zJRcH
         22JLTYoS39i4mwZr6U+yXD1ISmI03pVJfiF1SmcXq92Ewd7oIYFEgnWULFf0Vp7k4vDA
         DTZcUP9K9fJTIt3lIK5vfcTfPWZ1dxvsvU6tNE7Q2fgh1YGLM7Qz0vGni/73YfZMn0ft
         KiV3SqzLKYoNzCabCOkxU/flTavJZhVbTE33HtM5TOZOQIeLY2fCHT+ZxKf5OTcePtxg
         xq2g==
X-Gm-Message-State: AOAM533F3sE2PdAnn1YoTWBh0x80QEQhQ+dEC1eEpjWSWBiQQuQrf6qt
        UGBy08JeF4PMsjRcKAd9iGsiUiIRPobC3A==
X-Google-Smtp-Source: ABdhPJy/19XPCF1Ar3WCoL9Fbmwn/Pp/+1X1glZqwQxonEQpkR4IskRT8mN6pnVCwjw8Kpme4tikQw==
X-Received: by 2002:a17:907:8a1c:b0:6df:ecd6:b6ea with SMTP id sc28-20020a1709078a1c00b006dfecd6b6eamr11123363ejc.530.1648209204790;
        Fri, 25 Mar 2022 04:53:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7db84000000b004136c2c357csm2706777edt.70.2022.03.25.04.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 04:53:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/5] io_uring: partially uninline io_put_task()
Date:   Fri, 25 Mar 2022 11:52:15 +0000
Message-Id: <dec213db0e0b8605132da81e0a0be687a4d140cb.1648209006.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648209006.git.asml.silence@gmail.com>
References: <cover.1648209006.git.asml.silence@gmail.com>
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

In most cases io_put_task() is called from the submitter task and go
through a higly optimised fast path, which has to be inlined. The other
branch though is bulkier and we don't care about it as much because it
implies atomics and other heavy calls. Extract it into a helper, which
is expected not to be inlined.

[before] size ./fs/io_uring.o
   text    data     bss     dec     hex filename
  89328   13646       8  102982   19246 ./fs/io_uring.o
[after] size ./fs/io_uring.o
   text    data     bss     dec     hex filename
  89096   13646       8  102750   1915e ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e6f334ba520..b868c7c85a94 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2000,19 +2000,23 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-/* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task, int nr)
+static void __io_put_task(struct task_struct *task, int nr)
 {
 	struct io_uring_task *tctx = task->io_uring;
 
-	if (likely(task == current)) {
-		tctx->cached_refs += nr;
-	} else {
-		percpu_counter_sub(&tctx->inflight, nr);
-		if (unlikely(atomic_read(&tctx->in_idle)))
-			wake_up(&tctx->wait);
-		put_task_struct_many(task, nr);
-	}
+	percpu_counter_sub(&tctx->inflight, nr);
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		wake_up(&tctx->wait);
+	put_task_struct_many(task, nr);
+}
+
+/* must to be called somewhat shortly after putting a request */
+static inline void io_put_task(struct task_struct *task, int nr)
+{
+	if (likely(task == current))
+		task->io_uring->cached_refs += nr;
+	else
+		__io_put_task(task, nr);
 }
 
 static void io_task_refs_refill(struct io_uring_task *tctx)
-- 
2.35.1

