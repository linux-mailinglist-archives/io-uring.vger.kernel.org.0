Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B186574F920
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjGKUdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjGKUdf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:33:35 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751281709
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:34 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-682a5465e9eso980080b3a.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689107613; x=1691699613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8G1ATQFuI41fkL8nxWaXO/6T7p7QjpNqJTfODI4BURk=;
        b=ruLMvlGVd99hIimX09o4jOpO7XRLli4f19K5s0UL/kg8kU/nXFBG5TEdysN/kw2pxK
         L4yLcMmsezywupoQo+SWOuZCBlKvHlZwCxZOMWQiRWGZpl7qGfD06s7KXFBJXrquzx2+
         3cno7S1zlf63a6WwoyH8p/bSYzt2/Ksw2ZHyF/D7pZyw8sPTpO+5iOTYSsfbEQtEzdF/
         ojN/5s5mAlbA8+DaMbIg71FzV1AiL5HnVyP5eNjCpBnXO5g0y9FqU2pzTZuxFkT60uJ9
         a2Nb3VcYgOqxaTFSaZWdh4Ki154Nipci5q740nlVZTKt6PCC0BGcp5xg9oT3eOG0U2lb
         eV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689107613; x=1691699613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8G1ATQFuI41fkL8nxWaXO/6T7p7QjpNqJTfODI4BURk=;
        b=fbXBYymXTlmb3jABVjCbjZvDZmITTtTtQBn+0Bni2TCh3IIGugJpV62+9I1WDDDynC
         WJjQyuu9mOZB2CTvtZwr4gt8O4s+Efjq3CNU2Gu1cbVzTHJ56twAAEQ6wyQLzttqwi8l
         NLv7OUWWrdwnq7G4c6siX2+luD4e6M+CNZfgml4G7520Mb2rkbxbwy7mRyLtbtsGP/VZ
         wZs6RVWopyLkkEDUFZ946U1Y+VleBkDfqlNFVzJWQRVtmzsQwBrlh0HfbfyzfEMdL8Xl
         0Cd2SRRm/w5/KxxjkNkmNp0nmbX95Rm6d7qtXh21/IcRAKguLXEccKW6agSBWYh7ex9k
         H+ww==
X-Gm-Message-State: ABy/qLYivtUmVgxtTEEmxdttQhEzmPgb9Utde/Og1qCFNWSMmFl41eDF
        4WhPBeBP+qf95vB6AvLJaUg9zxZdzBuVE4Yl0AU=
X-Google-Smtp-Source: APBJJlHzKXTNBJSugfp1HnJcJwK1C7ev1+Bvxj1jMKRytCnxsp6FqaxILGesdp1hHtLzGsNtRuKcPw==
X-Received: by 2002:a05:6a20:3ca7:b0:11a:efaa:eb88 with SMTP id b39-20020a056a203ca700b0011aefaaeb88mr21693558pzj.3.1689107613516;
        Tue, 11 Jul 2023 13:33:33 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fk13-20020a056a003a8d00b0067903510abbsm2108081pfb.163.2023.07.11.13.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:33:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] fs: add IOCB flags related to passing back dio completions
Date:   Tue, 11 Jul 2023 14:33:22 -0600
Message-Id: <20230711203325.208957-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230711203325.208957-1-axboe@kernel.dk>
References: <20230711203325.208957-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
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

