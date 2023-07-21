Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866FC75CE2E
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjGUQSn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjGUQSM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:18:12 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F86F3C06
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:07 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7748ca56133so21204039f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956223; x=1690561023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyNahqPc1pwMUX1EtsLZ1EOWwyO2cqWRsqmVBpYW9+Y=;
        b=0aWP+E4GFdNzNflre1kamqe9PsnlmI/2nmygaFNWCPd+YY0Hm0To8JVrGDpwOmY/Jy
         MswOWnIV9AXXasYUcaiYtWjMfW0mmViPwZu1nVQExuJg+jQMUXeguYDwnd4YMhImYw5Z
         KtSmd0IOrMhZ/oxbtJ6r7m4EY3Zyo7laIfbJkmDmKE4HhK7QNOHpz16ToyOc/ua5FI60
         Q8PqqBUe1vFN3xwmGe/y0ZAOlhi8v8/RduhDD+CAibE231b7YNtFC83RzhHAXpa1dLwr
         XplSxoAjDSaoG8jpM7HN892Jvl2oSKfkBMw2WFNW3vLcaDGNMzf+oqwT1Dic1qUBZJyb
         wbWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956223; x=1690561023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yyNahqPc1pwMUX1EtsLZ1EOWwyO2cqWRsqmVBpYW9+Y=;
        b=hRhr0Xko8T1atvzssRRziNOGqeI0teeTI6NrwC7S6MwyDkaWT3RC8Ff4eHgQgXCp7w
         OipHutqki2cHRQUvKvISmseUTU5fUUunvmlTQQkkWkP+uA5x6wW2bfORtD3EZlxefh98
         uzalalzklA6wJQ1yJTERQI1Wzj+Z/8g2gaFaaeBYZZrJojMOHJR2bheSGHBXaq/iMK2e
         xcKrY6ykzm6T0djtryjPIy4poKQKFODGE+QwJFu54gN4O3sNMWdQqJxX32lANB1Cm+Cp
         48XOfgE1weuneM5D1ui2qGvuh81MWfBYdGnwi/VrUPdtNIDsR7J/dX+kChpDnSGEJF8H
         zUYg==
X-Gm-Message-State: ABy/qLb3FhnwaxNjCgOahkg5Hfc57GwOm7BvPhK3DR41J5c8Nl/ajccp
        42oUqQ8PEAAKVZKRiB9/IgkIGvtFhIBetAWozfs=
X-Google-Smtp-Source: APBJJlFal8EmDiwtuR8AOwBCrps/dQIMAByn1uNcUwe3Vb9BP9vhPAAXlDgWaXYBHjITsO62APenbA==
X-Received: by 2002:a05:6602:4809:b0:77a:ee79:652 with SMTP id ed9-20020a056602480900b0077aee790652mr2360554iob.1.1689956223422;
        Fri, 21 Jul 2023 09:17:03 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:17:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] fs: add IOCB flags related to passing back dio completions
Date:   Fri, 21 Jul 2023 10:16:47 -0600
Message-Id: <20230721161650.319414-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
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

Add IOCB_DIO_CALLER_COMP, which the issuer can set if it is able to
safely punt these completions to a safe context. If the dio handler is
aware of this flag, assign a callback handler in kiocb->dio_complete and
associated data io kiocb->private. The issuer will then call this
handler with that data from task context.

No functional changes in this patch.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6867512907d6..60e2b4ecfc4d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -338,6 +338,20 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+/*
+ * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
+ * iocb completion can be passed back to the owner for execution from a safe
+ * context rather than needing to be punted through a workqueue.If this If this
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

