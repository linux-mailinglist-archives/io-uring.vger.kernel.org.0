Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C92759F0B
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 21:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjGSTyb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 15:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjGSTya (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 15:54:30 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C538B3
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 12:54:29 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-345d2b936c2so151605ab.0
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 12:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689796468; x=1690401268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8G1ATQFuI41fkL8nxWaXO/6T7p7QjpNqJTfODI4BURk=;
        b=zrDwjC1d0FFyHF4BZzGKrNTGsfN9BlDcgqYOtgjpIeUfI8cUJ2gWoJWcV2v5/PLiTu
         HeyoUydrQK56YU+zKI+YOR0ZH2b8tjRZfUCtpOrHth4YDgvMaZvG+4yacsCAOxtqOivn
         7BnToAzllX09eFjFXYh8ZhuOsPY5pg6h8b656mooeFRPrwJLe+76YIQs71YoAd7Pss7q
         OlRLGqCsox8ZlBSYH09RSut8BwtoVWBctVkMasOeGR3+IYGRmNmKRe9Bvc0W3ZBFopC9
         KNpv70BDCVWiaEUNYjAtAEgyxv6ZTXhQPXLOxuAH1Q+uHzBkYUFh6wmErTXD5xCloULh
         gTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796468; x=1690401268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8G1ATQFuI41fkL8nxWaXO/6T7p7QjpNqJTfODI4BURk=;
        b=FWrmS4ubJf+sYSQTkzy9dkL6LFdUIhdUccWVuKOvTSXJa8b94jYmdv2thSEBp4qzZJ
         CeFLy13mfzIzwQ9N8vKs7GJEqslohLW+qXtN4odT7Y67jHrCo0x0IUELnWTuqCEb2n4q
         5nxN9x4reebEeCaPnmokYJCzIV8lh8ObuOPcQtze7tuv4QZnSVYtnagdNdoD6jJvAWp4
         M8JB1jEkNyC6Vfu/PoojIzUBYqZ+vybrdJi5tLmv5aZhRhRfjtH0NfYhO3LkG0XoXiBT
         WshloiMdbDWrV3YrokHNl5dF7a14iwxfE0DD8TW2keyMVDqMe9TNjoVR1tyghwpI7tqG
         /RBw==
X-Gm-Message-State: ABy/qLYCWh20c24yonO3EOJSUrjbbUJ3rK4+RC8h3VlbW7FEQJoKyq93
        u9GXqE/hcSI6lz5qToGhuny9gAmp3ZRB2pFcU2Q=
X-Google-Smtp-Source: APBJJlF33Mp1ZkeKdSrYKVbcfXze+rZUfO0282dRzlMGTO0XNHw70QFDmxUMZpxKQSFviRi7haLNVg==
X-Received: by 2002:a92:c243:0:b0:346:1919:7cb1 with SMTP id k3-20020a92c243000000b0034619197cb1mr9293457ilo.2.1689796468044;
        Wed, 19 Jul 2023 12:54:28 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j21-20020a02a695000000b0042bb13cb80fsm1471893jam.120.2023.07.19.12.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 12:54:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] fs: add IOCB flags related to passing back dio completions
Date:   Wed, 19 Jul 2023 13:54:15 -0600
Message-Id: <20230719195417.1704513-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719195417.1704513-1-axboe@kernel.dk>
References: <20230719195417.1704513-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

