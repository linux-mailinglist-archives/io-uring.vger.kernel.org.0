Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC60554DE14
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiFPJWu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359481AbiFPJWt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C3411A10
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:47 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m24so1030919wrb.10
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BCuEENWz7BFINBG8zBMSUF8mtkwrlLjt3CzidM5Dw40=;
        b=VdouYoSc1tjxSY04emPi7DQXhRnPkD3YPEQ+Gwl4I7KKBW+W46G8cVzN9wpu4QP6Oa
         TRritE6UvqYEAidxLw2xIkQTwtyYpyyBkIGwAiExIK/SFTJ4Cy/ikJflLk/zhTUhAL2D
         yJchwGFwFe3LzRN+hYKo2fygzd0g13pt2ypeQq99ieTwvpyGThTh/Bm1BhahAXdgNeBs
         LeT68Lx9W+9ojnZCecruqA66lHK1fHITSf1atXwLzRjHeC0N9eC5IXj30nUJJAEHLbkZ
         nlN3o3+NpqgQleg3QkKb9NFwyEHejEUo5+4wVgv1RzixW5LB9YBrRRA0xYVIVtq1PvVD
         b8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BCuEENWz7BFINBG8zBMSUF8mtkwrlLjt3CzidM5Dw40=;
        b=cQ6BxIK1bWnOHPeWPP10pHxIG2/ATzlFaOcPVSVQq3gQ01PyimlQN/Hd1abmoWpoo0
         UYmbio7guamAu0Y+9DOxw0CrScF8fDCTyjk8eALc9Yn5DLwYOzRjigamJ1KWjhMYVauS
         ue6imAep0UwgMyDpgBYyC/BX4zmpHhWYRMrqs024YIfyJAKDHJkehd1xtDwOxhGozoVH
         yGQ91qAPGF+XZu7UYDxFD2C2LklohDYziTfxSdy/+tnv0eUMRo3QQG1OPXlVXhKsGPcv
         bsfTxjFrA6r/+6HX8XL6ng2Kcb8sUJE4pkbFSJ8aoAIjGVmsjaJlPkokoWPgZGGGrj3o
         jQzg==
X-Gm-Message-State: AJIora8NWADNu424zzoLXOwbNazQqkO0Rv9ppQm4Bne5JExj0jlS4OJ4
        lt+eSDEnptizWCZYN7k6XyeEA6aGhRIqvw==
X-Google-Smtp-Source: AGRyM1sD4pti1RXsrKBBSK2MOt7M1yGWkRMSfOU9b+okooa4hbDtlEiCUMj0kuPllqfK5v2GmcpWpA==
X-Received: by 2002:adf:ed45:0:b0:210:2f9c:f269 with SMTP id u5-20020adfed45000000b002102f9cf269mr3822602wro.470.1655371366073;
        Thu, 16 Jun 2022 02:22:46 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 03/16] io_uring: refactor io_req_task_complete()
Date:   Thu, 16 Jun 2022 10:21:59 +0100
Message-Id: <ae3148ac7eb5cce3e06895cde306e9e959d6f6ae.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

Clean up io_req_task_complete() and deduplicate io_put_kbuf() calls.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 02a70e7eb774..1bcd2a8ebd4c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1306,15 +1306,19 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
 	return ret;
 }
-inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
+
+void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	if (*locked) {
-		req->cqe.flags |= io_put_kbuf(req, 0);
+	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
+		unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
+
+		req->cqe.flags |= io_put_kbuf(req, issue_flags);
+	}
+
+	if (*locked)
 		io_req_add_compl_list(req);
-	} else {
-		req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
+	else
 		io_req_complete_post(req);
-	}
 }
 
 /*
-- 
2.36.1

