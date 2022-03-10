Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C4A4D4FD6
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiCJRAQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 12:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235121AbiCJRAP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 12:00:15 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953C8B6D17
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:59:14 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id w7so7185756ioj.5
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IBfLyo2h7ld8F+9vI+oiSTEe/8e+2sBoY2mfQci2R+8=;
        b=61rG6noQ+uv0e3ZIJABIk/LWzfuA/V+J/Odx7KzxzsvWeDmwSNW4vpsUkE4zBOwHoY
         X2KtIMl5DNmvJMok2zk8Wgq5jpP7ZSrEiwZ8WeyC7jDY3h/rMifvbwzAN9cxpSB8/T83
         kxUHq+i4aM//ynkLcxycxm3ul+YkjxTj4fkcFMJZCQIC+4cp2xvUThvb7B2jB1wTXGDK
         YLqRfyAqVjNOJ4OoXYnrXHyq9bBygwkvE5cyHSbySV6GEZd1SR7/MCheMUdxprHCLBiT
         1FH6k2WuqET7dRfppo0eLf15Wu4ASMlLyPYgfOgPCvcZ+sOMK4136N43ef/EsTz0ko+n
         Zo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IBfLyo2h7ld8F+9vI+oiSTEe/8e+2sBoY2mfQci2R+8=;
        b=ebV1PAoGH985+1qGfaQJL8UfYNcUVSCUaROYcd99aXBvrY1nKMwB8sJLnJiCpyz4Dj
         54JIaYZHAeeEQ3S5fNhMs2UD2igtXs4EUzdoBWsNc4wOAGEIwFUzkQZo9leDRsPJIHig
         u64hAXJFupMGX5ol11NqcuOTzSXdJYqKhNQ5hzl1Ly/NmbH9iQaz55/5rY1bOVEimdhY
         YatN57Mhb7LOVMcaBM/rBZiWdOi0lj+5Jn3nv0aOWII57lerKeXa8PWYJeNHjznt8iWt
         Ol1J8kMF7qRKOfz6mCHeEMau1cTB1iLMU0/2epRw9Y7yAdAGm/KgJk6RSEc1sYDehbIr
         EHJg==
X-Gm-Message-State: AOAM5300D6DgohSweUbwnQEcwOciyr0hyIp1mnXkxkTOfUqAa4/Okijx
        FmUApcrdRba1TRdF0JaoCqhBJB3KMqqBPkQW
X-Google-Smtp-Source: ABdhPJzvEgruxrbMODNA6It5spXX7iyxZ7Jksad58sM5viZuTcEHp/IZIK4EVV8cWe/Npl/WxqT7Eg==
X-Received: by 2002:a02:6a60:0:b0:315:4758:1be1 with SMTP id m32-20020a026a60000000b0031547581be1mr4798040jaf.316.1646931553695;
        Thu, 10 Mar 2022 08:59:13 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i8-20020a056e020ec800b002c7724b83cbsm86865ilk.55.2022.03.10.08.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:59:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: recycle provided buffers if request goes async
Date:   Thu, 10 Mar 2022 09:59:07 -0700
Message-Id: <20220310165907.180671-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310165907.180671-1-axboe@kernel.dk>
References: <20220310165907.180671-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we are using provided buffers, it's less than useful to have a buffer
selected and pinned if a request needs to go async or arms poll for
notification trigger on when we can process it.

Recycle the buffer in those events, so we don't pin it for the duration
of the request.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 584b36dcd0aa..3145c9cacee0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -269,6 +269,7 @@ struct io_buffer {
 	__u64 addr;
 	__u32 len;
 	__u16 bid;
+	__u16 bgid;
 };
 
 struct io_restriction {
@@ -1351,6 +1352,36 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 	return cflags;
 }
 
+static void io_kbuf_recycle(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer *head, *buf;
+
+	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	buf = req->kbuf;
+
+	head = xa_load(&ctx->io_buffers, buf->bgid);
+	if (head) {
+		list_add(&buf->list, &head->list);
+	} else {
+		int ret;
+
+		INIT_LIST_HEAD(&buf->list);
+
+		/* if we fail, just leave buffer attached */
+		ret = xa_insert(&ctx->io_buffers, buf->bgid, buf, GFP_KERNEL);
+		if (unlikely(ret < 0))
+			return;
+	}
+
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	req->kbuf = NULL;
+}
+
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
 	__must_hold(&req->ctx->timeout_lock)
@@ -4763,6 +4794,7 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 		buf->addr = addr;
 		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
+		buf->bgid = pbuf->bgid;
 		addr += pbuf->len;
 		bid++;
 		if (!*head) {
@@ -7395,8 +7427,12 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 		 * Queued up for async execution, worker will release
 		 * submit reference when the iocb is actually submitted.
 		 */
+		io_kbuf_recycle(req);
 		io_queue_async_work(req, NULL);
 		break;
+	case IO_APOLL_OK:
+		io_kbuf_recycle(req);
+		break;
 	}
 
 	if (linked_timeout)
-- 
2.35.1

