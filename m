Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1656DD91D
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjDKLNT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjDKLNK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:10 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B9C4C25
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ga37so19679055ejc.0
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkTrgzgZfs7fwzj4aO6pWf6R6g23XUkgLev3HUA9yrU=;
        b=OkfWp+tsaH+944pWjpg+uC7cd+5oaShOnKYZX8Cw5QXix7kjB4XWtsRgkipeE4ebwP
         QVgvnj1ObauX6UCXYrT1Dgieh+LTuhrgrKA06r10UsfMmm9fPj1wmpkxom4MA7XFwKWJ
         VCrfAQe0r1aww8vaxbwuGKjA0QatPY5ojtn+zx/+7XkLfnp5QBpcOzCge1753spy59BM
         T6agBFGWMT+mRCFzKXl3IvJoCnQ979zJ+UUxhUFotgApfww33fqhF2D9bzzCDiwjAi62
         BB8AjpFUT/nuLzshWa2UIBsNT8LsY2YxdsjbG2rJ1WA11jWJLtSa6ptf6Q+NOECiwByM
         MJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dkTrgzgZfs7fwzj4aO6pWf6R6g23XUkgLev3HUA9yrU=;
        b=nRY/SAsTMBrzss9Xil3tLyznQavcOu5YujugOkU2irakMgy6XykcKOlSIVc8lVjemv
         0UsvwWrMbl4Cc/WQTn7JGydclzJJ7PUOiPwLp6kPeIyttFriIAJys8K3notwlW9Ynvmz
         ZZr4rFv1bIFhHa9JVgNfvj2SK+2ncWhbshva9HDPUxXYmxLGO2aLvLtqht0PNeOXg0Yk
         ea3v28ASF+RXvT/Cf6DXXfVunqAWjSBJTcO6eE6rTi18NyZ0oun+F4hRIsfkfgI3wWTA
         bI17obsU81TgsJSl9hU8MBeVFh0dn199fRSPphU9DnRGzvylc0zNtWTxx+CH7ZKLcJVU
         jPxw==
X-Gm-Message-State: AAQBX9dAliy9jQL5+Xz0TKFb77jRlkiKyovSkmE7zyNZpilDr1f1mHXl
        RfG1rx24yaHC9MgbU0w6yhZSsfViuNs=
X-Google-Smtp-Source: AKy350YTbXQsFMtAR71uD37DjlL3tuojweNC+1NlSjn4lQ3IAzO7yTLHYcZtfmAA6qPqkNhL+3tpVw==
X-Received: by 2002:a17:907:9714:b0:932:853c:c958 with SMTP id jg20-20020a170907971400b00932853cc958mr11899154ejc.25.1681211570877;
        Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 8/8] io_uring/rsrc: extract SCM file put helper
Date:   Tue, 11 Apr 2023 12:06:08 +0100
Message-Id: <58cc7bffc2ee96bec8c2b89274a51febcbfa5556.1681210788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681210788.git.asml.silence@gmail.com>
References: <cover.1681210788.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SCM file accounting is a slow path and is only used for UNIX files.
Extract a helper out of io_rsrc_file_put() that does the SCM
unaccounting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f2c660ffea74..11058e20bdcc 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -832,20 +832,14 @@ int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file)
 	return 0;
 }
 
-static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
+static __cold void io_rsrc_file_scm_put(struct io_ring_ctx *ctx, struct file *file)
 {
-	struct file *file = prsrc->file;
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
 	struct sk_buff_head list, *head = &sock->sk_receive_queue;
 	struct sk_buff *skb;
 	int i;
 
-	if (!io_file_need_scm(file)) {
-		fput(file);
-		return;
-	}
-
 	__skb_queue_head_init(&list);
 
 	/*
@@ -895,11 +889,19 @@ static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 			__skb_queue_tail(head, skb);
 		spin_unlock_irq(&head->lock);
 	}
-#else
-	fput(file);
 #endif
 }
 
+static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
+{
+	struct file *file = prsrc->file;
+
+	if (likely(!io_file_need_scm(file)))
+		fput(file);
+	else
+		io_rsrc_file_scm_put(ctx, file);
+}
+
 int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			  unsigned nr_args, u64 __user *tags)
 {
-- 
2.40.0

