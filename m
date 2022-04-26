Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637FB510719
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351442AbiDZShC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244326AbiDZShA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:37:00 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4179488BD
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:33:52 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m13so7784802iob.4
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w/w8ixqCTT7o3TYDJRtX8B2T9wVZR1Q1LY31dBYZsjU=;
        b=liKoPijn+go0bUcTdixn+hNfm4IawHOp4LQjfmHXuCWntTGtzmVJI6libR2KyiXGuv
         5u5BpSa2hmXNoFdiTfaw8bY6AsM1Z0zoberittIqxXrUVfn9jhPKOJyB8UqKS/WXHUjR
         UUKJsmiMc6IHjR1oGPM2rlK+G0DL9t162xwFm1DTpsN+ID68XniDbmoyc/Po+DdIlAa9
         ENWGyd3LirXcHgFIKVfvzTw8QCqh8+Hd627nP0zd6OBOV4PNoQsJ+lLRmLxq4NaiqvcC
         7AWir/HrLzgawfpiNU4FXgjdoE5tz85KrsfNVtH9YAsoTDK23fFDR96Zxwo6gj81duXL
         7rww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w/w8ixqCTT7o3TYDJRtX8B2T9wVZR1Q1LY31dBYZsjU=;
        b=dbMwp7+vwTr2bitkau1jhIaZLfY4dgkdoRY/MhnpyJUHcAzuer0rGapKS/Vy/O5mi5
         +Lj/W/vt5tcE2VtPiP+ZpIT1skXn7XNchQBnasVXecvh+UaqhjA9f1gypLHyBQFHQ5wh
         0/9lOBdCft29CTvyMj326pQtBtdptSb+upXVRwPAshuMBhuR5FtnBBLd8XWdvqwSCvFH
         X13P2Hc4cv5fq0IQMdf5TXsYMtj88M8n8INIi8vHGNKDTB0xqUG3MxNwkEl8sQJkdi9f
         sT/MzhAkwOzgV1oGMqdIzsIDmXdNQixE0twOPjS5O6+4KZg2hsTlYCAgBuUnfJku3NMG
         cvXA==
X-Gm-Message-State: AOAM531ZXxjQi70CfJuu1uNz30Nb1VUrXRYn6/xYm9VpaIfhrDLxqhkb
        kgxxhHbPxZwkMIN0uvaKQpmSOAN3uhcNTQ==
X-Google-Smtp-Source: ABdhPJx3CT4QtqFSOn/9v485GsaTUNXiLNw7orE4yaDG4L8711n2ptD+nGGoklpG2rMxj77r5/TisA==
X-Received: by 2002:a02:2b21:0:b0:32a:fede:c3aa with SMTP id h33-20020a022b21000000b0032afedec3aamr3093322jaa.53.1650998031825;
        Tue, 26 Apr 2022 11:33:51 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o7-20020a92d387000000b002cbec1ecc60sm8227524ilo.86.2022.04.26.11.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:33:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: add IOSQE2_POLL_FIRST flag
Date:   Tue, 26 Apr 2022 12:33:42 -0600
Message-Id: <20220426183343.150273-4-axboe@kernel.dk>
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

For some operations, the application fully expects that no data or space
is available, and that the request will be punted to our poll handler
after the initial transfer attempt. For this case, it's a potentially big
waste of time to first attempt the operation, only to get -EAGAIN and
need to arm poll.

Add IOSQE2_POLL_FIRST for this case, allowing the application to request
that the handler checks poll first before attempting the operation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 |  5 ++++-
 include/uapi/linux/io_uring.h | 11 +++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 06afe4db5a9a..eb5f77bde98d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -111,7 +111,7 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
 			IOSQE_FLAGS2)
 
-#define SQE_VALID_FLAGS2	0
+#define SQE_VALID_FLAGS2	(IOSQE2_POLL_FIRST)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
@@ -792,6 +792,7 @@ enum {
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
 	REQ_F_FLAGS2_BIT	= IOSQE_FLAGS2_BIT,
+	REQ_F_POLL_FIRST_BIT	= IOSQE_FLAGS2_BIT + 1,
 
 	/* first bits are taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 9,
@@ -837,6 +838,8 @@ enum {
 	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
 	/* IOSQE_FLAGS2 */
 	REQ_F_FLAGS2		= BIT(REQ_F_FLAGS2_BIT),
+	/* IOSQE2_POLL_FIRST */
+	REQ_F_POLL_FIRST	= BIT(REQ_F_POLL_FIRST_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 622f6e27a444..fe5d8cae7e7d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -66,6 +66,7 @@ struct io_uring_sqe {
 	__u64	__pad2[2];
 };
 
+/* sqe->flags */
 enum {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
@@ -77,6 +78,11 @@ enum {
 	IOSQE_FLAGS2_BIT,
 };
 
+/* sqe->flags2, if IOSQE_FLAGS2 is set in sqe->flags */
+enum {
+	IOSQE2_POLL_FIRST_BIT,
+};
+
 /*
  * sqe->flags
  */
@@ -97,6 +103,11 @@ enum {
 /* flags2 is valid and set */
 #define IOSQE_FLAGS2		(1U << IOSQE_FLAGS2_BIT)
 
+/*
+ * sqe->flags2
+ */
+#define IOSQE2_POLL_FIRST	(1U << IOSQE2_POLL_FIRST_BIT)
+
 /*
  * io_uring_setup() flags
  */
-- 
2.35.1

