Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB94D38DE
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 19:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbiCISeL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 13:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiCISeH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 13:34:07 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96D4106C99
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 10:33:07 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id w7so3783335ioj.5
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 10:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9UL+1QChGDROE3nKTlLlx2p8YtbeUHRSmJ+tdgV0npE=;
        b=iCRb5zwntjAUPij+leyfE1TgxVC48k1Vljs6MLHxx0RapBEYJK7ydRoeIE2TmCDj+P
         FnfotE8BFXW2y5E8FxITr6g5o4+JEE0b4H1u/SRC/1PpbbAKFUjT41kRKL9dgcS0QiIU
         h+Djx1ggN+/LtlWO+ydCOV5t4LFuR3OkvCmM61bNTnpQCG619Jvuu9TYv1GPKIo0rLVt
         PGuas+4uZVQAIz+qUJ1sGdtSD5TOswLbHfDQcpNO81XxTAozPTRWXlNnykTu6iE7LJKP
         lWh2Jc2SnOvtsQyhyOMQ6Ze/m/z95XcdWwODnYHBsXVdd6OJ5XWJBRDaTqzq1GzVHeB7
         zldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9UL+1QChGDROE3nKTlLlx2p8YtbeUHRSmJ+tdgV0npE=;
        b=PmJWMfoYvMWI3FbmDQiB4yX7G2gzQWiREn4SVuEMoz515FdhYlTCfd1k1URLcqLIJg
         DIbUtDseqISgl2x0G6UN261PfNj9j90cYkwyVVqJQKrbrF4/D2KJde63P2dySc5SERFR
         6svFQvzkgFjIZ4QNWI7Qt/VjZeqKIsgaQfodEZIRHnWXzEwrc3xdefYX+/wke6eEAdfI
         ldvxMnWI965APjuhPzVVoO5R/D+1naRDMUdGwimGas1fDs2t/T/3YfdJbSzqd1G5pmTF
         yawR5q4kG4wmsf4rst+GV1iqk5ze2j2Kpu49MsFn5+FXWEa2Uw/ulWDaRnVlLN2OuNnA
         qVQw==
X-Gm-Message-State: AOAM531nfTF9t08hdRV5QJit5jbS/sk9JVit/DX2pLga1Qej6AuHFpH9
        25/0sf5iFl7mTOq8dYZvuNZN5RkNfVRhFKMr
X-Google-Smtp-Source: ABdhPJy/wgYlnGKSFVSx8htjpWKa89KhZM1AVA4NofoSICZ9O0f5GBXOF43ovvVI68snqqh7dhruLg==
X-Received: by 2002:a02:7013:0:b0:317:b68a:e4d2 with SMTP id f19-20020a027013000000b00317b68ae4d2mr747477jac.8.1646850786308;
        Wed, 09 Mar 2022 10:33:06 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j9-20020a056e02154900b002c5f02e6eddsm1524094ilu.76.2022.03.09.10.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:33:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: recycle provided buffers if request goes async
Date:   Wed,  9 Mar 2022 11:32:58 -0700
Message-Id: <20220309183259.135541-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309183259.135541-1-axboe@kernel.dk>
References: <20220309183259.135541-1-axboe@kernel.dk>
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
 fs/io_uring.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aca76e731c70..fa637e00062d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -268,6 +268,7 @@ struct io_buffer {
 	__u64 addr;
 	__u32 len;
 	__u16 bid;
+	__u16 bgid;
 };
 
 struct io_restriction {
@@ -1335,6 +1336,34 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
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
@@ -4690,6 +4719,7 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 		buf->addr = addr;
 		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
+		buf->bgid = pbuf->bgid;
 		addr += pbuf->len;
 		bid++;
 		if (!*head) {
@@ -7203,6 +7233,8 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 {
 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
 
+	io_kbuf_recycle(req);
+
 	switch (io_arm_poll_handler(req)) {
 	case IO_APOLL_READY:
 		io_req_task_queue(req);
-- 
2.34.1

