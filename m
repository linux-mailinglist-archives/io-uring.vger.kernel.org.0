Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C5569AFF4
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 16:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjBQP4m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Feb 2023 10:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjBQP4l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Feb 2023 10:56:41 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BA06F7C1
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:10 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id b66so111988iof.2
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676649369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJ8iarjaNKbxX0mbZBKtffuMN4fx+meND3InwUU04/A=;
        b=NqGg3TxjD792JhYBPZ8J3mb/EFpnzOzr+TejD7GiN6bratSS+psC42OmGSZ1GDskcf
         jvpUB7wVSoN8e6Ia7Xba3YXFS6PbqXWVIAX2uOHxfLXkRPmPr1FbVq1CQPYbNzxt0qKG
         CXcevYMqv8FqT1FnjJcFCi7PFmiqVhhtPlzx9z1shAP7cFZJ9RkkjbXWTanoyagp4yd8
         Lo1mAcha7R2V0mhsiA0w8KrUO2XJK/hENpGl8pZtN5nvkF3XRA36ZxZ5K/lPuLjUjRhp
         AsEJZAaHeC12CgDm2Gn1t60u8uVzqRoYHiXOZyiSxIxU50OubQERzxlK7AHdF0Jgss55
         Wb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676649369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJ8iarjaNKbxX0mbZBKtffuMN4fx+meND3InwUU04/A=;
        b=dsnDqupEnWXDyJDAwMSi+EDgAkQLiEO/xG6v50jbtLAc8S2tLpjkJOOUrzzBrPB90F
         KSvvm9FV3ZuBs3EZxREtEAPdtR6QzP7eVhaL0thlnGv3AjPt3GRkSJHZ9Jd4K17W61YC
         EcFXT2xnoO3sQ4WVzd39qHzDN5hHbUmIaBtcOhV+X1CGLnzC/BJwnqb5yAVQUAqZdsGD
         rWqDR3QbbxYtdUT4V+x4vELbb8p5bE8X5vN25YWYTOHLd234Aq7y3MXaWKuS1vmvB5hc
         eV/JuhmqKdEfOtPnTunKxXqBgFtb4tVZRZNuVg4q9NO31gNE7hqOvtYxQpBvYgAS+0Yg
         jiSw==
X-Gm-Message-State: AO0yUKVjoEFFpsj5+/wfg0d99vwvrh2cuXFg9+fX6vxMJZpAsQhBaT+4
        O7kSeVxINJ1qNrZQIGH/MjN0OTsv97AhWdO6
X-Google-Smtp-Source: AK7set8nRLQNjBEvhaXT68DlFIb8LJQAOyrTt8J4QYyCWp2V1zXBfZKIkWBLY4ouApw+Sov3qmzjBQ==
X-Received: by 2002:a05:6602:2a43:b0:746:190a:138f with SMTP id k3-20020a0566022a4300b00746190a138fmr1682690iov.2.1676649369680;
        Fri, 17 Feb 2023 07:56:09 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d22-20020a0566022d5600b007046e9e138esm1551156iow.22.2023.02.17.07.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 07:56:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: use local ctx cancelation state for io_req_local_work_add()
Date:   Fri, 17 Feb 2023 08:56:00 -0700
Message-Id: <20230217155600.157041-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230217155600.157041-1-axboe@kernel.dk>
References: <20230217155600.157041-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than look into the remote task state and multiple layers of
memory dereferencing, just use the local state instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0fcb532db1fc..792ab44393c2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1291,7 +1291,7 @@ static void io_req_local_work_add(struct io_kiocb *req)
 	/* needed for the following wake up */
 	smp_mb__after_atomic();
 
-	if (unlikely(atomic_read(&req->task->io_uring->in_cancel))) {
+	if (unlikely(test_bit(0, &ctx->in_cancel))) {
 		io_move_task_work_from_local(ctx);
 		goto put_ref;
 	}
-- 
2.39.1

