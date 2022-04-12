Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD344FE371
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241112AbiDLOMz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355270AbiDLOMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:12:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6C01CFD4
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:36 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c10so6793190wrb.1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gxpwZvbETDGC86R7nGeFnusd0H7CqHyZXEosnr91AuM=;
        b=ATuF7VFiWxfVPHsDm8kJvevWnN5k7Q+fRtWhHNlOvKPv0WKdaJ6CfT/nz1vz05zahG
         S0NELDf/tEb9vsJZMED33weWUX1zablYa3+YUrAq4qRN4L39Di5G8dCIE1KEpM4yeOmd
         FFSLt1jCyjM3wWYfKsHvXn10SzuDVBEALWaUwx6o/CJZ4s5QUJg0zrEQRh4USKpOzg8A
         EnQM8JOib2WmLZrvOKlgTA3dy9wB5A4QkM2f9JmtDnxOjkiGAoDEhdylZZ3qVL5Jf7K1
         bE0wNheO2h/fFPxUYzX+fQ1P2u7M7FGjc04xH7V13eXrck81JUcbHqQ3+2X65v++N7mT
         t2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gxpwZvbETDGC86R7nGeFnusd0H7CqHyZXEosnr91AuM=;
        b=AsjHhhLurHN+alywN8dJjFl/RVZN+bO3zq2qdaNAwXUTXfeCbpeQKD5uvsq0huewtR
         uF2ibYzKbfws0rLiBUl5eCUn7rApI/1VAH5OobfvaFlSZd5xSSHXk86iYNaervoIooWj
         DsMqJ/x+5B3VRz+di8MkPp8ITI588gjwcz5kFoUrCSSHn4SBWB6qTp9MHDBJgibi6zoM
         TS1/6qJDDWUqEIVvc8FHD6v+TTHGCyj1RnXNZlDi+bs7LkrkWy9T99UJIM6B3/Pkbslk
         AbSdXH++slKXsEEwOAuJ9ZGZjlsFPfkbNI47KEXRjKPG7FjC2f9d9yULc3qd7q61w8Jp
         FhAQ==
X-Gm-Message-State: AOAM533B8Fe4bb/jTiPb6wJhKUrxbFs+az7VOAcPwb3SE0fyfN8jK1e+
        6K9vFtseSB8ahKMqKlAQTHmqUEkuGoA=
X-Google-Smtp-Source: ABdhPJycmZqael3od2L/+5H4kpb1nIrEaP/P4q2iM7VRfZy5RNkzqdMULtMgmWpz4kWJTL0UFVibjw==
X-Received: by 2002:a5d:6350:0:b0:207:98d5:9bcf with SMTP id b16-20020a5d6350000000b0020798d59bcfmr16409231wrw.40.1649772635234;
        Tue, 12 Apr 2022 07:10:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/9] io_uring: memcpy CQE from req
Date:   Tue, 12 Apr 2022 15:09:44 +0100
Message-Id: <ee3f514ff28b1fe3347a8eca93a9d91647f2eaad.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
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

We can do CQE filling a bit more efficiently when req->cqe is fully
filled by memcpy()'ing it to the userspace instead of doing it field by
field. It's easier on register spilling, removes a couple of extra
loads/stores and write combines two u32 memory writes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce5d7ebc34aa..66dbd25bd3ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2062,6 +2062,28 @@ static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 	return io_cqring_event_overflow(ctx, user_data, res, cflags);
 }
 
+static inline bool __io_fill_cqe_req_filled(struct io_ring_ctx *ctx,
+					    struct io_kiocb *req)
+{
+	struct io_uring_cqe *cqe;
+
+	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
+				req->cqe.res, req->cqe.flags);
+
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	cqe = io_get_cqe(ctx);
+	if (likely(cqe)) {
+		memcpy(cqe, &req->cqe, sizeof(*cqe));
+		return true;
+	}
+	return io_cqring_event_overflow(ctx, req->cqe.user_data,
+					req->cqe.res, req->cqe.flags);
+}
+
 static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	trace_io_uring_complete(req->ctx, req, req->cqe.user_data, res, cflags);
@@ -2703,7 +2725,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 						    comp_list);
 
 			if (!(req->flags & REQ_F_CQE_SKIP))
-				__io_fill_cqe_req(req, req->cqe.res, req->cqe.flags);
+				__io_fill_cqe_req_filled(ctx, req);
 		}
 
 		io_commit_cqring(ctx);
-- 
2.35.1

