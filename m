Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5814A787BB3
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243960AbjHXWzn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244025AbjHXWzc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:32 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB651FC7
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:24 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-99bf1f632b8so35645066b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917723; x=1693522523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWUAJWGai+zIRk9xtvb8L4N1KU3DAFreaKDKoivVNNU=;
        b=btNGfqOVCCzNcZwXnupcouLsdIkJvt+0UPTCqGEh/MQ7bskJj7h5IPXPa/k2IZGTES
         3HR2C2sb5QmYxiE29jrjmTIop4D6GmOMV32ckQeHHb2TSZ/k42BFCqOjydF1qQfnw1Vr
         FvXEZbxMAW3npBu4JrVYEpqb5gW72MEEqoVpn8HpGBoHgSRgjoLZj8uegseKb8BHg6l+
         235TNnoCQKJ11vXsd0uXe3XTQ737ga66cIKbH+ObTO1pB1v2ic7BN6gdFAWyiavRjXC1
         P44XQRb7K2YyHkitdTADUACVhVUnLqeAmK42atVqZ1d8AR6AxRVeSOvQf+EmhRtYmWDY
         ZjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917723; x=1693522523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWUAJWGai+zIRk9xtvb8L4N1KU3DAFreaKDKoivVNNU=;
        b=GYGecxcxjKImrIl1KpXeUTqddG678h5cPWAeGDuqUZ7AdQ4L/uPGpqK8P1rr2yUO50
         ZreLzY988Uj179r8vv+kx9l1H+UQVPgyR4JoFgIdE3P7jsY+EbVU/mEhsns0nw7ifvsk
         54qmAWL6pciOH3tFXTmaNB9YxECJ7e/BvGzZO6vfxs6IlugqzDjd1GLkjTWNnR8E8nqL
         pYIo3H/eeIC7v6rfROuRjZg5VvvZgZyVs6BF1n+W28gGZDuRVlQejDttq5VagDwf69gM
         J2u0m8MO3ybkIk5u0JUp63+pADkCLreTQfuGw6Ei6aAjF+a8RO7My/fLAuQp13IwUZR0
         BoSQ==
X-Gm-Message-State: AOJu0YwGC2JSwOJzjLAHKBsDjVhWNRUSQLwFSlSYgGdUOUFpEz6FwYP8
        QiINXkxNggOZtac38YOw+mQIrJ2lNEU=
X-Google-Smtp-Source: AGHT+IEHNSH6N2d7VMr9KcbODujE42TOKx3FHGdm0i88RdQ+SKwIdR56ewfbvwBmwTQqzFOH2iQN0A==
X-Received: by 2002:a17:906:2011:b0:99c:56d1:7c71 with SMTP id 17-20020a170906201100b0099c56d17c71mr13242744ejo.26.1692917723132;
        Thu, 24 Aug 2023 15:55:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 06/15] io_uring: reorder cqring_flush and wakeups
Date:   Thu, 24 Aug 2023 23:53:28 +0100
Message-ID: <ed32dcfeec47e6c97bd6b18c152ddce5b218403f.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Unlike in the past, io_commit_cqring_flush() doesn't do anything that
may need io_cqring_wake() to be issued after, all requests it completes
will go via task_work. Do io_commit_cqring_flush() after
io_cqring_wake() to clean up __io_cq_unlock_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 +++-----------
 io_uring/rw.c       |  2 +-
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cfc2dc8c4b2f..7c1ef5b6628d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -629,19 +629,11 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
-
-	if (ctx->task_complete) {
-		/*
-		 * ->task_complete implies that only current might be waiting
-		 * for CQEs, and obviously, we currently don't. No one is
-		 * waiting, wakeups are futile, skip them.
-		 */
-		io_commit_cqring_flush(ctx);
-	} else {
+	if (!ctx->task_complete) {
 		spin_unlock(&ctx->completion_lock);
-		io_commit_cqring_flush(ctx);
 		io_cqring_wake(ctx);
 	}
+	io_commit_cqring_flush(ctx);
 }
 
 static void io_cq_unlock_post(struct io_ring_ctx *ctx)
@@ -649,8 +641,8 @@ static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-	io_commit_cqring_flush(ctx);
 	io_cqring_wake(ctx);
+	io_commit_cqring_flush(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9b51afdae505..20140d3505f1 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -985,9 +985,9 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
-	io_commit_cqring_flush(ctx);
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_wake(ctx);
+	io_commit_cqring_flush(ctx);
 }
 
 void io_rw_fail(struct io_kiocb *req)
-- 
2.41.0

