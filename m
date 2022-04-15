Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AC550313D
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352606AbiDOVMC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350280AbiDOVL7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:59 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B615813E04
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bh17so17118972ejb.8
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=krzJsg9dTMkRXnUbxXEYzh74brLG9QhtuIf4fP4UhBg=;
        b=HKdc39WbK8lJ+wKJs4WUEKZvY7kAMvz5vMCaIAYn/J+sBiGRWf7fRuN4meoFqLxf28
         Qf++7R6n3/M1gaTpIykvRNsVulXZctFZILP9MXsozewvd/KZpbEHE1gL0BpAsBLfyMyk
         lTEbxjlq6O1YplBK3zqk5BMg7B4HYiYC2SAAuFTkyUGSosEMIiKG6bTrOeAIVORYuDut
         DxoWrxSNWPTHpvNMGkIeSkSE4x1/yaAZUA00dbHbENgOvaE9C9UzDt1jXVqoAJmRat4X
         svNCR8uqLu2aiACTqDnVcDqtrmtrvsO1fPE1s9b63MnRVoaDE/XJtceFk8kG06XWHzPk
         TAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=krzJsg9dTMkRXnUbxXEYzh74brLG9QhtuIf4fP4UhBg=;
        b=wbyL6DrXnw0NVUngUKVThoSELI7yW8+RAJWZ4NLt3Uv8QCv2qRzrqhTQAPjDPb5jv3
         zeP2heysVSVNiaR0YwdyaMJjE1hBCbRJMd9SMhHRUpTEe0i4r14RSu1pgHE7PuFcD3u5
         gjPxfP4KN06t183+lW36Gn5JZSpgzsNNew5aC5uiehHKdS74WGOZIVuhQm2PmTDXPTaI
         1vG7VEJlJsB+O5ezhMfsV2e/Ehtiq1AMPLYgvg8S62ovcVAM2UWYiTmUyxsvs57c8MbQ
         rMvEj8l/Sb8nHNUX9dMKAkOGwwZqF4HBKjhezg25dC/2QxblNc3eDJTYAUqsEHPWL5Eu
         piKA==
X-Gm-Message-State: AOAM5320hQYGNJ9eKK6zYSBluRWjZM4bvqrfVHUs0hnTD0Aymgz+UY0b
        NOyVsbQegL54hVsYuwlG7FLNnYNToxk=
X-Google-Smtp-Source: ABdhPJyp2hGkjNEW4DkwetMUuitwqYAYUDZDcm3g5y4LvHX/y00eiCHbChCLVZ1ak2DnExbw95cL+w==
X-Received: by 2002:a17:906:60c2:b0:6e7:681e:b4b7 with SMTP id f2-20020a17090660c200b006e7681eb4b7mr698346ejk.130.1650056967145;
        Fri, 15 Apr 2022 14:09:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 12/14] io_uring: refactor io_submit_sqe()
Date:   Fri, 15 Apr 2022 22:08:31 +0100
Message-Id: <03183199d1bf494b4a72eca16d792c8a5945acb4.1650056133.git.asml.silence@gmail.com>
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

Remove one extra if for non-linked path of io_submit_sqe().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9356e6ee8a97..0806ac554bcf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7745,7 +7745,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * submitted sync once the chain is complete. If none of those
 	 * conditions are true (normal request), then just queue it.
 	 */
-	if (link->head) {
+	if (unlikely(link->head)) {
 		ret = io_req_prep_async(req);
 		if (unlikely(ret))
 			return io_submit_fail_init(sqe, req, ret);
@@ -7759,17 +7759,22 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		/* last request of the link, flush it */
 		req = link->head;
 		link->head = NULL;
-	} else if (req->flags & IO_REQ_LINK_FLAGS) {
-		link->head = req;
-		link->last = req;
+		if (req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))
+			goto fallback;
+
+	} else if (unlikely(req->flags & (IO_REQ_LINK_FLAGS |
+					  REQ_F_FORCE_ASYNC | REQ_F_FAIL))) {
+		if (req->flags & IO_REQ_LINK_FLAGS) {
+			link->head = req;
+			link->last = req;
+		} else {
+fallback:
+			io_queue_sqe_fallback(req);
+		}
 		return 0;
 	}
 
-	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
-		io_queue_sqe(req);
-	else
-		io_queue_sqe_fallback(req);
-
+	io_queue_sqe(req);
 	return 0;
 }
 
-- 
2.35.2

