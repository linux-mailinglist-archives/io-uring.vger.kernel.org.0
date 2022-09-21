Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507005BFCD7
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIULUs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIULUs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:48 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF996FA31
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:44 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id i203-20020a1c3bd4000000b003b3df9a5ecbso8842803wma.1
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=7SrEQCUZFJdvUZqJql9L8RzvaOosvdHtufDGMGa9UeI=;
        b=S48fZWCVUxi9xKrw+Nl5JKAPpHsjXBQ1+jmvL1VmldfxZIAW19DBwEKIcWMmBUofaS
         Xvum3HlobAQbKeEBcwJT7KNKuTunG/rRRJ0j/y6OTq2yn3H3L23LKsgsxUjt7vC1ZcjE
         eCBtqcwEC3kXymh0pKWIPRJ5JDMGxzr7x8vcE0SsAq3QVMeAIOBQp3rYOwXSj3Yj3T78
         pti64xvIw0S559Y9UfDK4TpcbaYb2aSw+jq6wq/sEkI9qV+t6q1vjnzcA51SNbZL7Qn2
         fKJwPFgN33wa22eWhyfxwdnLGpa/wNqf9/m/8jCoMCEXBHOl+ToAJ/V6f5S8gX2Ywloq
         UG1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7SrEQCUZFJdvUZqJql9L8RzvaOosvdHtufDGMGa9UeI=;
        b=dQVS6e7p0Ku7gTIowBSZ3fNwBeerPKNNBjTF7HUeg14h1tU/ePIKGxxhM2x3x5oZOP
         jAenrAYq829ZnWcerJGKNGAG5PiGd2HQozHVUNCNLR8vkPTwq6j5FmG5ahcfm/oWgPWi
         m97NwZqWE//Gh/wU/5/6lXODCH83zO31DkfAFx/AichOdG/RLzfwqH6Z+U9Ea/nBvGlv
         mRQwn7DlARsd3ibZuBi2BhLZi3kG33mJrW4LX6qpuaBWWwsFWMfH10kzRMf6C0bKSEHC
         q9sLO7VbKXstAXfniy4TYXDQi2aqWNx6iGJ61QeP2gXebjdrlo9Bw1WT9LpC6UJOyeFI
         IzxA==
X-Gm-Message-State: ACrzQf2y7AYVn64m9NrtiXzvdrGAeJdkUpuR6C0a/H4a3nU1Owro/rsd
        HQw/wM65aEUTNYXhS9mWjJsJ2z13Rrc=
X-Google-Smtp-Source: AMsMyM6mmIcXH3/TSCbiwD4CUZ/C0AjGS/0n9Uufd5u5/rV6+Crajf4f0uZJLkBIPQEBM52kE5PotQ==
X-Received: by 2002:a05:600c:2043:b0:3b3:c84c:ca33 with SMTP id p3-20020a05600c204300b003b3c84cca33mr5495455wmg.15.1663759242781;
        Wed, 21 Sep 2022 04:20:42 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/9] io_uring/rw: don't lose partial IO result on fail
Date:   Wed, 21 Sep 2022 12:17:47 +0100
Message-Id: <05e0879c226bcd53b441bf92868eadd4bf04e2fc.1663668091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663668091.git.asml.silence@gmail.com>
References: <cover.1663668091.git.asml.silence@gmail.com>
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

A partially done read/write may end up in io_req_complete_failed() and
loose the result, make sure we return the number of bytes processed.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/opdef.c | 6 ++++++
 io_uring/rw.c    | 8 ++++++++
 io_uring/rw.h    | 1 +
 3 files changed, 15 insertions(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c6e089900394..788393ec3ff4 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -69,6 +69,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_read,
 		.prep_async		= io_readv_prep_async,
 		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITEV] = {
 		.needs_file		= 1,
@@ -85,6 +86,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_write,
 		.prep_async		= io_writev_prep_async,
 		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -105,6 +107,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "READ_FIXED",
 		.prep			= io_prep_rw,
 		.issue			= io_read,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
@@ -119,6 +122,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "WRITE_FIXED",
 		.prep			= io_prep_rw,
 		.issue			= io_write,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -275,6 +279,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "READ",
 		.prep			= io_prep_rw,
 		.issue			= io_read,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_file		= 1,
@@ -289,6 +294,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "WRITE",
 		.prep			= io_prep_rw,
 		.issue			= io_write,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index b777c35378b9..8f4e6b3f2b3f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -954,6 +954,14 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 		io_cqring_wake(ctx);
 }
 
+void io_rw_fail(struct io_kiocb *req)
+{
+	int res;
+
+	res = io_fixup_rw_res(req, req->cqe.res);
+	io_req_set_res(req, res, req->cqe.flags);
+}
+
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 0204c3fcafa5..3b733f4b610a 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -21,3 +21,4 @@ int io_readv_prep_async(struct io_kiocb *req);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
 int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
+void io_rw_fail(struct io_kiocb *req);
-- 
2.37.2

