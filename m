Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7676032D9CE
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhCDS5z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbhCDS5r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:47 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BDDC061763
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:32 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v15so28853162wrx.4
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mR48xWHpDX7ltzGgcEAv78XVKr35NFmXYNVn5nCqtnM=;
        b=HZdsmtzCkQW+wAYTNOmdoLXBH1tI1njXufOp4NRZFhrnIpdBBG9Cid7Q4LvXRU9bXR
         DtjloNVaQ5LycPs8Mhlt/mX2fJDRQAUMy80IJO4soKaXg+z+cPiwXTDRm2XK2DFhBSOe
         y3GcR2BTHT0xLgzDWGWXeUc5r0185h3ST0blts37dvGgePAc8orykaMwj6X3KnwL5CVG
         vZQUPDx7IHgYE4q9mTslb9HPVZd3SglZCaflQyHde8/vGp510jh6LggsB5uvNDQduuOp
         NSRM0dPywtsnKWNVHNXzTBwOUg0XR1GBitr0UaJzTrm4XHAnU66GrF4BokWxPMruNWBe
         Rjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mR48xWHpDX7ltzGgcEAv78XVKr35NFmXYNVn5nCqtnM=;
        b=DPdBEug+r8ZHsHlUGS+phqcj71yS2vt++4m+LF/KJsQWRuwkuDwzmDkqOiyiB880xi
         0DBMwG+z3QwAwbCHgLEXK5t3Zz4dj/edkDHu4RABLeiDMj19JV9vaTCyDtAahAz6y5+x
         9vuAEgUZcimhMZQLPxnd7LIl7FAU6apQt9E4EVnkCsufJvk4LOU16vJ0Ib9HOigDGw7A
         0QGWkOcKfXTNtdczpn9Cw1b7BkugrYJVpYiRuwdqwIhPL4ehZpL2Mma9cteO0w1DI+1/
         HlZ4MX40dRUEucCdVO5EOfAqK3kyd4MXWSseYAIVnum4HpJq5VQtDPvI36YARTM4zHU0
         n/6w==
X-Gm-Message-State: AOAM531BQ5HwIVh1yr4BRo02b6LTu8R9PTHkWy214V2dEPbyd1jlfWEa
        DqxwtutcJTeLuS2U+jXNkFASwDz0vuEBeg==
X-Google-Smtp-Source: ABdhPJyg5mtv1r/U9QJV/YHZLeD6Cih1FZcmU73GlTwEY4rGPJL+S5wku94ynE5AMmCQDkBCbZWxzg==
X-Received: by 2002:adf:a1ce:: with SMTP id v14mr5645722wrv.228.1614884191601;
        Thu, 04 Mar 2021 10:56:31 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/11] io_uring: abolish old io_put_file()
Date:   Thu,  4 Mar 2021 18:52:20 +0000
Message-Id: <aa6ea85fc2cd105c3de8ea69559ae953d6df01ca.1614883424.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_put_file() doesn't do a good job at generating a good code. Inline
it, so we can check REQ_F_FIXED_FILE first, prioritising FIXED_FILE case
over requests without files, and saving a memory load in that case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4ebdf1f759f..94b080c3cc65 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1661,10 +1661,9 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 	return state->reqs[state->free_reqs];
 }
 
-static inline void io_put_file(struct io_kiocb *req, struct file *file,
-			  bool fixed)
+static inline void io_put_file(struct file *file)
 {
-	if (!fixed)
+	if (file)
 		fput(file);
 }
 
@@ -1672,8 +1671,8 @@ static void io_dismantle_req(struct io_kiocb *req)
 {
 	unsigned int flags = req->flags;
 
-	if (req->file)
-		io_put_file(req, req->file, (flags & REQ_F_FIXED_FILE));
+	if (!(flags & REQ_F_FIXED_FILE))
+		io_put_file(req->file);
 	if (flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
 		     REQ_F_INFLIGHT)) {
 		io_clean_op(req);
@@ -3572,7 +3571,8 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 	if (sp->len)
 		ret = do_tee(in, out, sp->len, flags);
 
-	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+		io_put_file(in);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (ret != sp->len)
@@ -3608,7 +3608,8 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	if (sp->len)
 		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
 
-	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+		io_put_file(in);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (ret != sp->len)
@@ -5852,8 +5853,8 @@ static void io_clean_op(struct io_kiocb *req)
 			}
 		case IORING_OP_SPLICE:
 		case IORING_OP_TEE:
-			io_put_file(req, req->splice.file_in,
-				    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
+			if (!(req->splice.flags & SPLICE_F_FD_IN_FIXED))
+				io_put_file(req->splice.file_in);
 			break;
 		case IORING_OP_OPENAT:
 		case IORING_OP_OPENAT2:
-- 
2.24.0

