Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF1E62E492
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 19:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbiKQSlu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 13:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240652AbiKQSli (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 13:41:38 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0C786A69
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:41:37 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id n20so7476747ejh.0
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wp8GPOO7C6h23xODuK8m+CtaZZ/ccMsGI/AA52aX7cQ=;
        b=mvs6olpfc4i+cAFLmLpTAGuqFoJmV2TUiDxfHKaYxUB1pjX+89b0kUtMQV5CQ4vDAp
         CM0duPcy035TzMZW/QcZGPGN5UZW95c+6xkfpndbVmf4t7jIrB4LUI/7G/XqdwHgdSp9
         CIWwpFcbx2HgbJ/UU2aFryfFPnQ/TLbM3uj45dzlhbH/yvUtu8GsE/tWSD1jbfwQNxrD
         4EwsVPzrPa0QjQAXDyXtHu50hkjnwPxXSeU5cLnbtq449H/rlUV7GVB1H+Ox266VpfHX
         ZVdVjCdwxtGauYNmEdnNvPWEfGdN3USVaceFO/yIlK4hvP1PhubNZ8yLdwedKs2uLEXI
         3EEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wp8GPOO7C6h23xODuK8m+CtaZZ/ccMsGI/AA52aX7cQ=;
        b=Cv6EpX9EWg7tnlhy8P3iQjg+kOuFbN+IS4sdOVG9uqR7x7vys30+1S9sd5FcURnyaG
         WKHQ+2mZbNTvZp7ilpAvmH/7v58PbDVjhO6uO/Ao/KA9lxgRbePvpVwosNy8DxWj0nTp
         qft1NweSeWxyqYmQnOeoZ2p34kaXdyYevvhQam5URNx8aSguGAUX09MoI2vsC8DiwoT2
         xmQiq/e6lRm3aAKYDMyigCfuxjiVEKwKZ/YTWezgLeIEzjMfXGv7SirulLDiAZMRvikS
         dI4hJqqh0kndts8BtQ9EqyITlUwyZtcBEtB6uAhkyXosMuZFZIj2EmGONOAEzwxo7ohA
         ZIeg==
X-Gm-Message-State: ANoB5pktUX7SCWnNPzrPchzHe5rlFxJ+uXBdfZ60QVshckzMeQ4/PpDO
        y5mTUo1LmG6vcJXS91hEfi+4PyKS7Lg=
X-Google-Smtp-Source: AA0mqf4pGquLDLrcMoUtjRWcTThibGUSfAX9pHKe4xEqF0lSJg2prsPiWlydDlLcX0m6HVMs6pCbKA==
X-Received: by 2002:a17:906:6d8e:b0:7ad:a2e9:a48c with SMTP id h14-20020a1709066d8e00b007ada2e9a48cmr3219985ejt.77.1668710495568;
        Thu, 17 Nov 2022 10:41:35 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id n23-20020a05640204d700b0045c47b2a800sm840725edw.67.2022.11.17.10.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:41:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/1] io_uring: inline __io_req_complete_post()
Date:   Thu, 17 Nov 2022 18:41:06 +0000
Message-Id: <ef4c9059950a3da5cf68df00f977f1fd13bd9306.1668597569.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

There is only one user of __io_req_complete_post(), inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 +++--------
 io_uring/io_uring.h |  1 -
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 94329c1ce91d..2087ada65284 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -844,19 +844,14 @@ static void __io_req_complete_put(struct io_kiocb *req)
 	}
 }
 
-void __io_req_complete_post(struct io_kiocb *req)
-{
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(req->ctx, req);
-	__io_req_complete_put(req);
-}
-
 void io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_cq_lock(ctx);
-	__io_req_complete_post(req);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe_req(ctx, req);
+	__io_req_complete_put(req);
 	io_cq_unlock_post(ctx);
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0b0620e2bf4b..af3f82bd4017 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -32,7 +32,6 @@ int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
-void __io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
-- 
2.38.1

