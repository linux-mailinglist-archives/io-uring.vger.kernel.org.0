Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3597F510716
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiDZShB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351543AbiDZSg7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:36:59 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B7C483AA
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:33:51 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id p62so21391153iod.0
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TULgS34lSS9NU+veEe6QiBG7RwS5U5xfn+73j/IGoPo=;
        b=svb0ncezy0FIZGs0w2+VY5TqBFHSS7P8tkHLlD9TJhBFPbnxuHet7M20grHfv1Asao
         mnykXtmxLVhA6Z6V0qZdL9QNUEPlbfdgTxwvghnjSV8KiUBRgiWbENZBYIo9mxUd8MPL
         Raa9wFD9MZWCBAOTmZRGM34wL2GapDGoYSN9gq/hiopr2U/5ed2XM6yTopcFt2hbXnZa
         1PSdAtXr6Hx6WhY18yWwggA5xU+00hBTzBYg62WqHBHhHWDdnQKjXIPOw+bKKA+VgNt/
         FypjAyaMF6zezYw0qIMzf9m3Q/VRrxGWgeoaMLknpBfDGQEBkkzniBGHdHQcNlj9av8b
         j5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TULgS34lSS9NU+veEe6QiBG7RwS5U5xfn+73j/IGoPo=;
        b=d4lSkvvtbRZdbtYny8oFvteVYdD3ShbEK38Wri+xuGT7j90v72pnrfST6I26CgGzNb
         44WZM5scn7QBssRkufxYkbqiu4znjfwLvJEsFdXt28DIRYztdYuVOfcXi99kfQfds3AA
         TPnuDBxkcQKFBc4pewBFlwvMytHD7P4MfR4yasMpylUwYAX/SHkFELqL0GZ5Lg+pZyyG
         EFJVRZcOeIkpqLm2kGWyQ6WcFQ+8qaSNgUS0h83KNSPNTi23+RqPFaXD5XSUolMmXSMS
         07wi3eaC3myv97BJnmjuIe/Ynvu7tJ03hqgwrefCZkix5yw0jGp3GqhRvZdaPhRs9W/I
         bLkg==
X-Gm-Message-State: AOAM531g9fHBzNXqGAN/nGz7ea5+hGFAhbx/nGvhPTub2o/XvqiBHmPE
        pqB4tAtu0BqAllXGKA/CynnN8gDQpEqg0A==
X-Google-Smtp-Source: ABdhPJwNjO42HNOpaaKUikGhaMtVBFoAoTajSIixSNaYYH/QLCgPGedwhXXKd+R6dVxXLabOKlD3jg==
X-Received: by 2002:a6b:7e03:0:b0:654:9a7e:e382 with SMTP id i3-20020a6b7e03000000b006549a7ee382mr10008357iom.126.1650998030971;
        Tue, 26 Apr 2022 11:33:50 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o7-20020a92d387000000b002cbec1ecc60sm8227524ilo.86.2022.04.26.11.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:33:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: add flags2 variable
Date:   Tue, 26 Apr 2022 12:33:41 -0600
Message-Id: <20220426183343.150273-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426183343.150273-1-axboe@kernel.dk>
References: <20220426183343.150273-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Most opcodes don't support using the ioprio field, it's really only
something that read/write to storage media supports. Overlay a flags2
variable with ioprio, so we can grow our flags space.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 40 ++++++++++++++++++++++++-----------
 include/uapi/linux/io_uring.h |  8 ++++++-
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 29153958ea78..06afe4db5a9a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -108,7 +108,10 @@
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
-			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
+			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
+			IOSQE_FLAGS2)
+
+#define SQE_VALID_FLAGS2	0
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
@@ -788,9 +791,10 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
+	REQ_F_FLAGS2_BIT	= IOSQE_FLAGS2_BIT,
 
-	/* first byte is taken by user flags, shift it to not overlap */
-	REQ_F_FAIL_BIT		= 8,
+	/* first bits are taken by user flags, shift it to not overlap */
+	REQ_F_FAIL_BIT		= 9,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
@@ -831,6 +835,8 @@ enum {
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
+	/* IOSQE_FLAGS2 */
+	REQ_F_FLAGS2		= BIT(REQ_F_FLAGS2_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
@@ -3280,15 +3286,16 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 
-	ioprio = READ_ONCE(sqe->ioprio);
-	if (ioprio) {
-		ret = ioprio_check_cap(ioprio);
-		if (ret)
-			return ret;
+	kiocb->ki_ioprio = get_current_ioprio();
+	if (!(req->flags & REQ_F_FLAGS2)) {
+		ioprio = READ_ONCE(sqe->ioprio);
+		if (ioprio) {
+			ret = ioprio_check_cap(ioprio);
+			if (ret)
+				return ret;
 
-		kiocb->ki_ioprio = ioprio;
-	} else {
-		kiocb->ki_ioprio = get_current_ioprio();
+			kiocb->ki_ioprio = ioprio;
+		}
 	}
 
 	req->imu = NULL;
@@ -7779,6 +7786,14 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 				return -EOPNOTSUPP;
 			io_init_req_drain(req);
 		}
+		if (sqe_flags & IOSQE_FLAGS2) {
+			unsigned int sqe_flags2;
+
+			sqe_flags2 = READ_ONCE(sqe->flags2);
+			if (sqe_flags2 & ~SQE_VALID_FLAGS2)
+				return -EINVAL;
+			req->flags |= sqe_flags | (sqe_flags2 << 8U);
+		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
 		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
@@ -7794,7 +7809,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
-	if (!io_op_defs[opcode].ioprio && sqe->ioprio)
+	if (!io_op_defs[opcode].ioprio && sqe->ioprio &&
+	    !(req->flags & REQ_F_FLAGS2))
 		return -EINVAL;
 	if (!io_op_defs[opcode].iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fad63564678a..622f6e27a444 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -17,7 +17,10 @@
 struct io_uring_sqe {
 	__u8	opcode;		/* type of operation for this sqe */
 	__u8	flags;		/* IOSQE_ flags */
-	__u16	ioprio;		/* ioprio for the request */
+	union {
+		__u16	ioprio;	/* ioprio for the request */
+		__u16	flags2;	/* extra flags */
+	};
 	__s32	fd;		/* file descriptor to do IO on */
 	union {
 		__u64	off;	/* offset into file */
@@ -71,6 +74,7 @@ enum {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_FLAGS2_BIT,
 };
 
 /*
@@ -90,6 +94,8 @@ enum {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/* flags2 is valid and set */
+#define IOSQE_FLAGS2		(1U << IOSQE_FLAGS2_BIT)
 
 /*
  * io_uring_setup() flags
-- 
2.35.1

