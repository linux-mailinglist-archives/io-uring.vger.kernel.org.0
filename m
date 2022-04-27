Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80578510E5C
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 04:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356991AbiD0B5p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 21:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiD0B5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 21:57:44 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7B5106DDC
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:54:35 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s137so324006pgs.5
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i1aB7baOTOtfguv73/RGQy7V3neLA9jkIvAZ8OCKIZs=;
        b=masP8Eu0L4/C5H52X5JqAfxqWUigpQx2w2/YWbQwl6jVR3scmI5xFEZupqOc8uiLzm
         9ceJNSLLVNG20DUBCQPG184xPM6bPVyTginBPhIPR8IYBSHpSfJjS8gxM2cWUK1RoKak
         cUU3c4LYXeJ/4ApWQrfF77GgJaeikuvtlhDRyspk1B3bp+re6Pqty3y+xK4nuDdcibAY
         3SrSF4NMdUMwGChioM8bj6UAFbef/L2rT3qFkBGGlWaCBtH2WYMjkYCO1jpZYL6Bmupv
         ShIJOZ/UPSxDBdOvnvNCbkIc58t6KQCycykhC+WLy9AtCHlmzzdqw+fXYpxOrtiPn9hg
         NxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i1aB7baOTOtfguv73/RGQy7V3neLA9jkIvAZ8OCKIZs=;
        b=PT7kby60daYZPsZZ3DMK6NYArKAQ8//NFZUzCVkYc6Z/6LglV3HohJw1rtFeG4W3d0
         xN92cUbKCSpZXrubuwKmTwCxXAcdSNytD2BpoXturhdhHCGgROP59unioY4vlS/6m9Vs
         pMqc0j1H896SmpOVCeWJgjkoDR1MC31GyKI5fYZPtmX0nGpemDxIXmZaCXUk3o41jtA4
         Jvy/sgBQ4IFPMTIdtOYtOf5pp/cGnGdh7sELvIrEPuWeevTcajwaYclGw6xjHcMWs8Sg
         YHsepir9/8x/E61EqXI2zmETktVCtESJDbcLP7QaNdRVHFmNUVv++a6f+Bbe4Q6wOx52
         7jrQ==
X-Gm-Message-State: AOAM5326Ntj0eknEec9nvnV9EcRUoXk/UtszVrdH39WXYxo80cpzrIcq
        JRq2yEfmWklO++jgvx9mt7bTP0Av7Z8vr/0b
X-Google-Smtp-Source: ABdhPJzi2SEaoejHkYDtxXzJP423C4j7jIQ2XdrUh5ONWcQV/tZt8uwPRrmVt92cHUOpN2gzlB54Gw==
X-Received: by 2002:a63:2a8b:0:b0:3ab:971a:4058 with SMTP id q133-20020a632a8b000000b003ab971a4058mr3992025pgq.223.1651024473672;
        Tue, 26 Apr 2022 18:54:33 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p185-20020a62d0c2000000b0050d1f7c515esm13194998pfg.219.2022.04.26.18.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:54:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: add POLL_FIRST support for send/sendmsg and recv/recvmsg
Date:   Tue, 26 Apr 2022 19:54:28 -0600
Message-Id: <20220427015428.322496-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427015428.322496-1-axboe@kernel.dk>
References: <20220427015428.322496-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If IORING_RECVSEND_POLL_FIRST is set for recv/recvmsg or send/sendmsg,
then we arm poll first rather than attempt a receive or send upfront.
This can be useful if we expect there to be no data (or space) available
for the request, as we can then avoid wasting time on the initial
issue attempt.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 27 +++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h | 10 ++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39325e469738..a14bd5f55028 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -637,6 +637,7 @@ struct io_sr_msg {
 	int				bgid;
 	size_t				len;
 	size_t				done_io;
+	unsigned int			flags;
 };
 
 struct io_open {
@@ -5269,11 +5270,14 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 
-	if (unlikely(sqe->addr2 || sqe->file_index))
+	if (unlikely(sqe->file_index))
 		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	sr->flags = READ_ONCE(sqe->addr2);
+	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
+		return -EINVAL;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
@@ -5308,6 +5312,10 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
+		return io_setup_async_msg(req, kmsg);
+
 	flags = req->sr_msg.msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
@@ -5350,6 +5358,10 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	int min_ret = 0;
 	int ret;
 
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -5502,11 +5514,14 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 
-	if (unlikely(sqe->addr2 || sqe->file_index))
+	if (unlikely(sqe->file_index))
 		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	sr->flags = READ_ONCE(sqe->addr2);
+	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
+		return -EINVAL;
 	sr->bgid = READ_ONCE(sqe->buf_group);
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
@@ -5543,6 +5558,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
+		return io_setup_async_msg(req, kmsg);
+
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		kbuf = io_recv_buffer_select(req, issue_flags);
 		if (IS_ERR(kbuf))
@@ -5600,6 +5619,10 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fad63564678a..51f972ecaba0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -213,6 +213,16 @@ enum {
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 
+/*
+ * send/sendmsg and recv/recvmsg flags (sqe->addr2)
+ *
+ * IORING_RECVSEND_POLL_FIRST	If set, instead of first attempting to send
+ *				or receive and arm poll if that yields an
+ *				-EAGAIN result, arm poll upfront and skip
+ *				the initial transfer attempt.
+ */
+#define IORING_RECVSEND_POLL_FIRST	(1U << 1)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.35.1

