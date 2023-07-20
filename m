Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A1175B645
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 20:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjGTSNZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 14:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjGTSNY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 14:13:24 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB45FC
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:23 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-345d2b936c2so1189935ab.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876802; x=1690481602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HmtTYMUzX/gcmI/rcwUW5tKXEH+MB6XY0myuWWxnltA=;
        b=TtTnh3nOJsWhUQESiS/FdDhWMNHmejaFgXrPFWlYvd6yTCAia2mamY37n36yDYp3j+
         IeV5CSyHNb6G7GRmuPgRn+mj/NElj3ufZYICp8wLgErFN5wEpXv94F4Xv2RqT12/3k6A
         Ps6WuR84Yki74moAFBoJYdiS7aJFQzWBgAyouYP72gRA1uzaPLhnb9SuSWuSizi6U40F
         xdXSJRE6o/dlrwmzFWkMB/tk52ZhumqRg3v3g6wGI6YyOkutH5gqEEl3SCcnYvahPcLL
         cBV2a/V0OzTjOyusEYhuH3iFyZ7osj9/KL5y2+7FXqivBqsbEXS9MxFnUzYiqAVorrs1
         LRzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876802; x=1690481602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HmtTYMUzX/gcmI/rcwUW5tKXEH+MB6XY0myuWWxnltA=;
        b=Hlo/sx7FLtIdVZmeO2u8gOL0sJQCfm+cBY1NAZnsb6yJ6Bu5oPMt9B7DfnIz80crCV
         u2aoScqqGQT735lqTlofEd+t1Z71PwLZKSHzhz3zHSgUScVptq+X5RX8mIwKOhF96N/n
         VFKqB8LNpfpJfLnGSz3ZLqKDCmXPDyBAm64bvHYTmZ3NsfoUSqacKHCj6JDaqwFWM/vR
         dljYtnVvu42CmwKLisy+L4uzZeNTCWm1+rn1pqufAc5xnmxEyNPlzZJrjjUBrcTfbD00
         rkp2bYWspL5UDuEsUkUi4S6BvnrX1RQqL05Bk3sqtt1NJqT99xubhGYXa2BBqBY0Unc6
         eBhA==
X-Gm-Message-State: ABy/qLY06H1AceG5bOEh2dqC5U0VENthv9FIraNLPVbM7zObE9iXpmvf
        Z7ZARbQ2/MXLjb6D2MXFVpva1IhQVcNB4vKTR64=
X-Google-Smtp-Source: APBJJlFouanhb4sgzuIro+mo0I/bEw0edbEnho2DR1D4kosEOE48J+ytS48l5Qf9uyCbXX2iGR+/VA==
X-Received: by 2002:a05:6e02:17c8:b0:346:4eb9:9081 with SMTP id z8-20020a056e0217c800b003464eb99081mr12451833ilu.3.1689876802463;
        Thu, 20 Jul 2023 11:13:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] fs: add IOCB flags related to passing back dio completions
Date:   Thu, 20 Jul 2023 12:13:08 -0600
Message-Id: <20230720181310.71589-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720181310.71589-1-axboe@kernel.dk>
References: <20230720181310.71589-1-axboe@kernel.dk>
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
 include/linux/fs.h | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6867512907d6..2c589418a078 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -338,6 +338,20 @@ enum rw_hint {
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
+ * the argument being passed to this handler. Note that while this provides
+ * a task context for the dio_complete() callback, it should only be used
+ * on the completion side for non-IO generating completions. It's fine to
+ * call blocking functions from this callback, but they should not wait for
+ * unrelated IO (like cache flushing, new IO generation, etc).
+ */
+#define IOCB_DIO_DEFER		(1 << 22)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
@@ -351,7 +365,8 @@ enum rw_hint {
 	{ IOCB_WRITE,		"WRITE" }, \
 	{ IOCB_WAITQ,		"WAITQ" }, \
 	{ IOCB_NOIO,		"NOIO" }, \
-	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }
+	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
+	{ IOCB_DIO_DEFER,	"DIO_DEFER" }
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -360,7 +375,22 @@ struct kiocb {
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

