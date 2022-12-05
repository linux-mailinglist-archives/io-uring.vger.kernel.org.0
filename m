Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2666421AA
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 03:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiLECpo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Dec 2022 21:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiLECpn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Dec 2022 21:45:43 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8D8FAD0
        for <io-uring@vger.kernel.org>; Sun,  4 Dec 2022 18:45:42 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w15so16617945wrl.9
        for <io-uring@vger.kernel.org>; Sun, 04 Dec 2022 18:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzK/zrdj76nrH7tgY872zfma02vZfGuAP6Fn/6zdEXI=;
        b=oOmj4JTziR/PMj48t6VbE0a0DdU09MevOPpA/h+1YcXecYmBtvaJClw9ZcawEsQ31P
         NgsnSPBA8eLVf8rNEYXHF0yHkAg0mENKk6R9CscvNtFuGmJipMlgET+awwCbcGli6y3V
         AX2j0e/n0SlA88QN3/v1ZucQOmRbvXAVtT5pjNp8vwelHcxRLKHHL43D8rPkfsB1ma5O
         Fc2ucV9qeIBpalUQEUHSfHxSi+9a4zls/01GO2rFTZ2ovxwrbISfgzRaLJn1nCsZMw3O
         SdYXaJkikwD8/eRKTLLbs3B0PkBB8H9+0y0J+7mMZqVsGAltuxETghSN8WGsdo8rRrem
         OebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BzK/zrdj76nrH7tgY872zfma02vZfGuAP6Fn/6zdEXI=;
        b=kPVDwG323ha6n4Bga5m9TyYbmH/wHabu8Qmp3SCzVxB78AZmPE1pTFtDUkHnKfPWji
         4i+XG5HlTOHZ3ULNN3Lctuya5hKP3CFABh7Lr6DVt6wh46wqxche5WOhys33BBKr/0BN
         vmjcRLOYP082zVzmPYbopzV+pjC918i5vJRR8lHNVnWfaBJJvTI67BM0xy71E2wpjtGK
         x2phE1Wukm2nUhaNfCW8R4P1ffo/GIpxhxPOsQ+jAGM7VHRLR+LAEpAbmFqFyYv4Uph8
         stThv9b3cRVH9PLUAlhNpsF3Iijx08frE5TAJsp6wo/oTZHvdHsSqDyWSt/hBKUuNCKw
         fqRg==
X-Gm-Message-State: ANoB5pmbtFFR997cEDXtZO0eYjuRqufl8B2cJdl7swkDVnI3fHfAI1cJ
        p8txCGMG1Hww7JNFdu8wh3yh6jIh5zA=
X-Google-Smtp-Source: AA0mqf4J9yL3VZ6+7xTsrrZSA1cYiV1LeVnp1hK7FAYm7eztuIW7J+PplUEI7Mcq0yhoBJhSwSwEtA==
X-Received: by 2002:a05:6000:1702:b0:241:ffc4:dd1c with SMTP id n2-20020a056000170200b00241ffc4dd1cmr31285372wrc.538.1670208340464;
        Sun, 04 Dec 2022 18:45:40 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c41d100b003cf71b1f66csm15281532wmh.0.2022.12.04.18.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 18:45:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/7] io_uring: force multishot CQEs into task context
Date:   Mon,  5 Dec 2022 02:44:28 +0000
Message-Id: <d3e0ff65a89b0605f1c9fdbaae39b8d55d5f0725.1670207706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670207706.git.asml.silence@gmail.com>
References: <cover.1670207706.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Multishot are posting CQEs outside of the normal request completion
path, which is usually done from within a task work handler. However, it
might be not the case when it's yet to be polled but has been punted to
io-wq. Make it abide ->task_complete and push it to the polling path
when executed by io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 90342dcb6b1d..f276f6dd5b09 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -67,6 +67,19 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
+static inline bool io_check_multishot(struct io_kiocb *req,
+				      unsigned int issue_flags)
+{
+	/*
+	 * When ->locked_cq is set we only allow to post CQEs from the original
+	 * task context. Usual request completions will be handled in other
+	 * generic paths but multipoll may decide to post extra cqes.
+	 */
+	return !(issue_flags & IO_URING_F_IOWQ) ||
+		!(issue_flags & IO_URING_F_MULTISHOT) ||
+		!req->ctx->task_complete;
+}
+
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -730,6 +743,9 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	if (!io_check_multishot(req, issue_flags))
+		return io_setup_async_msg(req, kmsg, issue_flags);
+
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -829,6 +845,9 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
+	if (!io_check_multishot(req, issue_flags))
+		return -EAGAIN;
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -1280,6 +1299,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
+	if (!io_check_multishot(req, issue_flags))
+		return -EAGAIN;
 retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
-- 
2.38.1

