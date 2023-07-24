Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518D87602C5
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 00:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjGXWzY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 18:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjGXWzX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 18:55:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6954D100
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:22 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bbadf9ed37so1478815ad.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239321; x=1690844121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4m73hDbmfHkB6vBAc3X7AmWd4GXS2D47NYfUBsYjTeE=;
        b=VG7ninWMl0JZlPdtIdNJcgkEXQh8MU+lBObbQkV5neVUmOxeTsurIAurlrNjadlfEk
         DbgsRETI6qP4mK3+D6R6o7o+SsqRLBHSuqTmTKPD18i6b/MNyPETV3U+eenLXgF7ot9d
         bviEE8LIdTNW+55BzbCtmr4SdSJmLpeCtdWBuA7RKR+K6glPgb7W5iE1csdiKxcQVqON
         O1Aelyg5+JUb5Yz3qcWbAqMoHKehauwOhIamUhoUOFI09lapOejJkVANZvSOrL60CYlj
         mOs713G+KiVtz022nbct3jHESv7OWvwynKBqfPuzycunxnsQdS2mFLpirHxtZKCx+SNn
         dVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239321; x=1690844121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4m73hDbmfHkB6vBAc3X7AmWd4GXS2D47NYfUBsYjTeE=;
        b=HFU729/QCTGXmuXLwBQd2SIGio7b+LtjZzhEwx6ETSogaFen5Ia0d9ZfLm74kGOGA6
         o7elN3KKfHCsTahXgizi622ETBJml7wKAgu3kUp7r5UZsG3zn9ICD1wi1xKWUBM3nvwF
         XXfSMFuhNwJfNCjXiLXwJtmrh2H9oRnmEY4dnEwjHCrQExEIc4y6Tue+z5E258b6LX+J
         nffTJK3c2zCTsNnhuCZy1s64U0A44F7XNNWIJM6aWL9cpXN5BBmA+ilOjvKU0+13wkI2
         8w9V/t6FeCRK3xSj4b6ZzRyA+EZ0/7Vn7Zx8M7Et/W6UitYpl1aDGdr36fXIP92czD6I
         Sbgg==
X-Gm-Message-State: ABy/qLZQi8Bt44eGOUzPzGAgMrNnqC/UOFoB9LSN/WRBKvKzrQvI4wqV
        xsvCgFd5hkG4gXHUql6MCH2gTt5CTO6qDM3bDjs=
X-Google-Smtp-Source: APBJJlGVStg2IqBph0zTI/BetjM8/WiT7C7LPmmDKrWD9iKfcw4MKCaPlznHf9Vaj0ssvFl3I+fUsg==
X-Received: by 2002:a17:902:d4c6:b0:1b8:85c4:48f5 with SMTP id o6-20020a170902d4c600b001b885c448f5mr15164004plg.2.1690239321659;
        Mon, 24 Jul 2023 15:55:21 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] fs: add IOCB flags related to passing back dio completions
Date:   Mon, 24 Jul 2023 16:55:09 -0600
Message-Id: <20230724225511.599870-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
References: <20230724225511.599870-1-axboe@kernel.dk>
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

Add IOCB_DIO_CALLER_COMP, which the issuer can set if it is able to
safely punt these completions to a safe context. If the dio handler is
aware of this flag, assign a callback handler in kiocb->dio_complete and
associated data io kiocb->private. The issuer will then call this
handler with that data from task context.

No functional changes in this patch.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6867512907d6..1e6dbe309d52 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -338,6 +338,20 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+/*
+ * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
+ * iocb completion can be passed back to the owner for execution from a safe
+ * context rather than needing to be punted through a workqueue. If this
+ * flag is set, the bio completion handling may set iocb->dio_complete to a
+ * handler function and iocb->private to context information for that handler.
+ * The issuer should call the handler with that context information from task
+ * context to complete the processing of the iocb. Note that while this
+ * provides a task context for the dio_complete() callback, it should only be
+ * used on the completion side for non-IO generating completions. It's fine to
+ * call blocking functions from this callback, but they should not wait for
+ * unrelated IO (like cache flushing, new IO generation, etc).
+ */
+#define IOCB_DIO_CALLER_COMP	(1 << 22)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
@@ -351,7 +365,8 @@ enum rw_hint {
 	{ IOCB_WRITE,		"WRITE" }, \
 	{ IOCB_WAITQ,		"WAITQ" }, \
 	{ IOCB_NOIO,		"NOIO" }, \
-	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }
+	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
+	{ IOCB_DIO_CALLER_COMP,	"CALLER_COMP" }
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -360,7 +375,23 @@ struct kiocb {
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
+		 * if IOCB_DIO_CALLER_COMP is set by the issuer, and the issuer
+		 * must then check for presence of this handler when ki_complete
+		 * is invoked. The data passed in to this handler must be
+		 * assigned to ->private when dio_complete is assigned.
+		 */
+		ssize_t (*dio_complete)(void *data);
+	};
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
-- 
2.40.1

