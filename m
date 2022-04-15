Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FADC5030A6
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352774AbiDOVMH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352224AbiDOVMA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:12:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F341AF1D
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:30 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v15so11048986edb.12
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/P9lPa526Y7saC7FO+K0V15ewpqEWruCUaC4rkymQ30=;
        b=OncBBEygcJet//JlvFDEUXTd2insvqDbrAus7SOjImQU24IkZCMZwXr10lyz3OIptj
         kRFvk5WyWIchEarC6U7AmDfSeL1AlvHTXKlncCQQbgp5K4RmTR45lfMmYtN1/jWmZujO
         2pE4MUsJiavOaTPrfioKIp4wyzsuM2svaLyVHjOgMRBVXB8JnRE1ga9CAoLLhZvZDt3+
         367yNQ+5dzMvxtTKRvOopXT892FrCPGj/gYBOAkze/RmOB3vlW1ZdrtD+8ThwvA0bLfa
         s20c26ihPRRDyJhfvMFCKvTUEU9BuQLrnqFBkIm39xtKTbzttUSaBGDM2cCrI58UvuPZ
         Vgzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/P9lPa526Y7saC7FO+K0V15ewpqEWruCUaC4rkymQ30=;
        b=pzZhMhTBT512eT5Ph0RjdoH/BDCvh2OneEz87A3ceON1gl8rR9RbU9CEa+oPdm9/VG
         M35AzloT4M7UblVovQBndSKj1XxzRgunuUofAyliBVYCmzP0LQh2VbdmdaIhI0D0C1dl
         TOcLcVAGbnD7AP3eQXq0KreSfnUd3FJhdKV5sc9BzAoZE9+bYMRirHaX91UOgaEcNOaD
         H7RgJG/kHXRFgiYfDXDGJcio6uq67qZxB/Lj5D8JbEusWU9O1BQiRlKb/AG4wtPYHylN
         5Ot4KyCEUWHr4jxeK3AONorez3rkfkPzXTIve/PHVyh5bNNHX/99LGaXLp/pYHEeA8WF
         WJBw==
X-Gm-Message-State: AOAM532dvRd0/hhTJ3++aDE3MUwmjWQI3ChIQgiRkdTh7PP498yuyGx0
        QrNjM01fwSYsqGOtvRtHdVhdFERO4pw=
X-Google-Smtp-Source: ABdhPJwNLzehxD3Hruv87r1VmVN45PZZY22LWjiH7vYss3JqWKfyD2oanpV/9sJwfTzb5Qpm6Nku7g==
X-Received: by 2002:aa7:d494:0:b0:41d:704f:7718 with SMTP id b20-20020aa7d494000000b0041d704f7718mr997151edr.147.1650056969212;
        Fri, 15 Apr 2022 14:09:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 13/14] io_uring: inline io_req_complete_fail_submit()
Date:   Fri, 15 Apr 2022 22:08:32 +0100
Message-Id: <fe5851af01dcd39fc84b71b8539c7cbe4658fb6d.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_req_complete_fail_submit(), there is only one caller and the
name doesn't tell us much.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0806ac554bcf..a828ac740fb6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2227,17 +2227,6 @@ static void io_req_complete_failed(struct io_kiocb *req, s32 res)
 	io_req_complete_post(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
 }
 
-static void io_req_complete_fail_submit(struct io_kiocb *req)
-{
-	/*
-	 * We don't submit, fail them all, for that replace hardlinks with
-	 * normal links. Extra REQ_F_LINK is tolerated.
-	 */
-	req->flags &= ~REQ_F_HARDLINK;
-	req->flags |= REQ_F_LINK;
-	io_req_complete_failed(req, req->cqe.res);
-}
-
 /*
  * Don't initialise the fields below on every allocation, but do that in
  * advance and keep them valid across allocations.
@@ -7544,8 +7533,14 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 static void io_queue_sqe_fallback(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	if (req->flags & REQ_F_FAIL) {
-		io_req_complete_fail_submit(req);
+	if (unlikely(req->flags & REQ_F_FAIL)) {
+		/*
+		 * We don't submit, fail them all, for that replace hardlinks
+		 * with normal links. Extra REQ_F_LINK is tolerated.
+		 */
+		req->flags &= ~REQ_F_HARDLINK;
+		req->flags |= REQ_F_LINK;
+		io_req_complete_failed(req, req->cqe.res);
 	} else if (unlikely(req->ctx->drain_active)) {
 		io_drain_req(req);
 	} else {
-- 
2.35.2

