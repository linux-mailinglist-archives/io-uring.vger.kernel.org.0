Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E247585CD
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 21:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjGRTta (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 15:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjGRTt3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 15:49:29 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFD7198E
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:28 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-346434c7793so4546635ab.0
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689709768; x=1692301768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8G1ATQFuI41fkL8nxWaXO/6T7p7QjpNqJTfODI4BURk=;
        b=XP/l3yrzhGQi73ZPF79j0ePKBJhrhE42B0Y3XeOBI4F9baq5gPci1E+ezJwv+N1YCf
         AIMDMtvCxkrIeB8dGXVXfDBVkKGzOc21yJcFagzhJs/fZ/Krh5lfLCOHPM6cqc6EV0jA
         Envh5K0DSur4yfM3I7nQKLq9xo+9FRDOeT+2yzkzO3BKXfODJcidg96iIv5pM6HOHzOF
         GrbkNxOB4paEieVgEGDRl69LUTZEHORwxi7KUs4SMRziBh5bVJXKFoJQmwcR9fEkEETJ
         RLbLmNZ8b+lW4gRnfF9HktSAseuMjxKe0Q+uc81umJCeJ4xUuFxHoDmK+HyaL8vBdYas
         K+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689709768; x=1692301768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8G1ATQFuI41fkL8nxWaXO/6T7p7QjpNqJTfODI4BURk=;
        b=HrP05qSCOVCBdjyHqgqtc2sGibVli0A2plws6XkZKsvhKXqJx1NWYaVC0XXwL7AeXz
         fmOXWoo0SlgDEtL0d9V/imFMmoHUj8aOIsE0yy1GS9mjPDeFBq9HiJxtSUHQ7KxCVH2i
         BgnrHjnDr0C9JRagD7UHodHUEwavXz7gVp/JG5x6sMUATUHYkBhFjsCcjLDGAdtOcbeB
         5L7/edDtC9+LOHJyKeGJKFpTvEK7PVEOJ4wmEj99LIEt2oMZZYY5SZ2MgbJFbaooK82G
         eFurJ6+lgyi94h96XOg0C2pehQgprTf9/HyGcTMIUrsg9w3YivATfKwo6MXy4rvENP5B
         4Pkw==
X-Gm-Message-State: ABy/qLZoDDMMn4CKg+bCvTFvATvIxH3QXfs9HJ4MirRn/bcUJ2XIyES9
        mjAMq3y5o3dW12RK0YZdz4y6f3EzQb0+k1gMkoc=
X-Google-Smtp-Source: APBJJlEP8wRzVlRKVqsnwy25QHqCmAoOA/YsapXt7iXLj1ZNWywK7ZLKdqSZys/f53PLIAPlKLjc2w==
X-Received: by 2002:a92:8e4f:0:b0:348:8418:8158 with SMTP id k15-20020a928e4f000000b0034884188158mr2400649ilh.1.1689709767836;
        Tue, 18 Jul 2023 12:49:27 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm897463ilg.62.2023.07.18.12.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 12:49:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] fs: add IOCB flags related to passing back dio completions
Date:   Tue, 18 Jul 2023 13:49:17 -0600
Message-Id: <20230718194920.1472184-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230718194920.1472184-1-axboe@kernel.dk>
References: <20230718194920.1472184-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Async dio completions generally happen from hard/soft IRQ context, which
means that users like iomap may need to defer some of the completion
handling to a workqueue. This is less efficient than having the original
issuer handle it, like we do for sync IO, and it adds latency to the
completions.

Add IOCB_DIO_DEFER, which the issuer can set if it is able to safely
punt these completions to a safe context. If the dio handler is aware
of this flag, assign a callback handler in kiocb->dio_complete and
associated data io kiocb->private. The issuer will then call this handler
with that data from task context.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6867512907d6..115382f66d79 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -338,6 +338,16 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+/*
+ * IOCB_DIO_DEFER can be set by the iocb owner, to indicate that the
+ * iocb completion can be passed back to the owner for execution from a safe
+ * context rather than needing to be punted through a workqueue. If this
+ * flag is set, the completion handling may set iocb->dio_complete to a
+ * handler, which the issuer will then call from task context to complete
+ * the processing of the iocb. iocb->private should then also be set to
+ * the argument being passed to this handler.
+ */
+#define IOCB_DIO_DEFER		(1 << 22)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
@@ -351,7 +361,8 @@ enum rw_hint {
 	{ IOCB_WRITE,		"WRITE" }, \
 	{ IOCB_WAITQ,		"WAITQ" }, \
 	{ IOCB_NOIO,		"NOIO" }, \
-	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }
+	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
+	{ IOCB_DIO_DEFER,	"DIO_DEFER" }
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -360,7 +371,22 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	u16			ki_ioprio; /* See linux/ioprio.h */
-	struct wait_page_queue	*ki_waitq; /* for async buffered IO */
+	union {
+		/*
+		 * Only used for async buffered reads, where it denotes the
+		 * page waitqueue associated with completing the read. Valid
+		 * IFF IOCB_WAITQ is set.
+		 */
+		struct wait_page_queue	*ki_waitq;
+		/*
+		 * Can be used for O_DIRECT IO, where the completion handling
+		 * is punted back to the issuer of the IO. May only be set
+		 * if IOCB_DIO_DEFER is set by the issuer, and the issuer must
+		 * then check for presence of this handler when ki_complete is
+		 * invoked.
+		 */
+		ssize_t (*dio_complete)(void *data);
+	};
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
-- 
2.40.1

