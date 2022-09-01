Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858D75A953E
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbiIAK6y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 06:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiIAK6s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 06:58:48 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F2612AF5
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 03:58:46 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id og21so33862515ejc.2
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 03:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Vn83U8meyqI41m3QWa3GDOUa/73ohejgP4MUSLhAQR8=;
        b=BGxsVXXcMDDMhpfi0CBwG7c6ZaRdU4GoiJzfgqvAEKpVSfPfIwJn/+cPVkYJ+98FtK
         9ciOKf4cNrChrAN1LU1y60GXWrPcrjT9TPFoziZrxaw+a82+h+F7sg5M/p6ZgyfIjlhf
         1vszsKW0hDY5DGnFH79qRCYQfTMz1JL1YwIF7U8t21o1qwz/kSluCd1aZceO7XMzD5ad
         vbHqqiVLQliu3fV/L4BmwH9SsDZDQkaTJKif/KPwSFRi1yUTi0VEGGdpPlQ7aI/SEk3F
         6SLS0jXwUYowqw/hLrGTzYhEtvybwwzDZQLQEHdR16FSGnYxbBSA2OiQZVtS+7OJXr8k
         20Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Vn83U8meyqI41m3QWa3GDOUa/73ohejgP4MUSLhAQR8=;
        b=cg6qnIt0+T+IF3fz8D5pEnTAVAYf84dKQPNJw2Kdl5GLVG9t6rhSwkBOz1D6SWJMOt
         fVR9r5WAhvwqVgV3zdOrN6v2mVxrY4qe6kZXjfiu8OH95mKKtx58TVLXJ4w/4shXBSuk
         0QZ2JSEaCDR6x2Us6MYjDU6z4fNpnzZ95raAOm19pPKWAYRiPpQSp/jtKJKWBdJRy0Ch
         ttnS0uaSFAA6NCiB8npj/A3K76TG9HvDqV3dhLFEZYatFfY/UOhve1syzgndZ0yym/nw
         uKEXMeY09wU5Kh3XQRS4nd9O3IEyJDetx2iW6ET1bpGbQAQ/PxEnlRjJCaEyVMdUa57D
         o38w==
X-Gm-Message-State: ACgBeo0FLwll7sBYYZqWImIbfBc1iUqbXZndPxB9sl1cupGbu4X9S9S5
        9sKa36RmnzGBVEZHLSrzaphUzvpPuMM=
X-Google-Smtp-Source: AA6agR5As5l8AbbrENvnHBL2vHPS7leF5k4gF1dEES1t8tBjfOO5b4wRS/89Tp/A0oYD7s2iH5xPtw==
X-Received: by 2002:a17:907:b03:b0:742:a5b2:374f with SMTP id h3-20020a1709070b0300b00742a5b2374fmr4898663ejl.396.1662029911198;
        Thu, 01 Sep 2022 03:58:31 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e81f])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709060ace00b0073d6d6e698bsm8277762ejf.187.2022.09.01.03.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:58:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 2/6] Revert "io_uring: add zc notification flush requests"
Date:   Thu,  1 Sep 2022 11:54:01 +0100
Message-Id: <8850334ca56e65b413cb34fd158db81d7b2865a3.1662027856.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662027856.git.asml.silence@gmail.com>
References: <cover.1662027856.git.asml.silence@gmail.com>
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

This reverts commit 492dddb4f6e3a5839c27d41ff1fecdbe6c3ab851.

Soon we won't have the very notion of notification flushing, so remove
notification flushing requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 -
 io_uring/rsrc.c               | 38 -----------------------------------
 2 files changed, 39 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9e0b5c8d92ce..18ae5caf1773 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -301,7 +301,6 @@ enum io_uring_op {
  */
 enum {
 	IORING_RSRC_UPDATE_FILES,
-	IORING_RSRC_UPDATE_NOTIF,
 };
 
 /*
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 71359a4d0bd4..048f7483fe8a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -15,7 +15,6 @@
 #include "io_uring.h"
 #include "openclose.h"
 #include "rsrc.h"
-#include "notif.h"
 
 struct io_rsrc_update {
 	struct file			*file;
@@ -741,41 +740,6 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-static int io_notif_update(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned len = up->nr_args;
-	unsigned idx_end, idx = up->offset;
-	int ret = 0;
-
-	io_ring_submit_lock(ctx, issue_flags);
-	if (unlikely(check_add_overflow(idx, len, &idx_end))) {
-		ret = -EOVERFLOW;
-		goto out;
-	}
-	if (unlikely(idx_end > ctx->nr_notif_slots)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	for (; idx < idx_end; idx++) {
-		struct io_notif_slot *slot = &ctx->notif_slots[idx];
-
-		if (!slot->notif)
-			continue;
-		if (up->arg)
-			slot->tag = up->arg;
-		io_notif_slot_flush_submit(slot, issue_flags);
-	}
-out:
-	io_ring_submit_unlock(ctx, issue_flags);
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_set_res(req, ret, 0);
-	return IOU_OK;
-}
-
 int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
@@ -783,8 +747,6 @@ int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 	switch (up->type) {
 	case IORING_RSRC_UPDATE_FILES:
 		return io_files_update(req, issue_flags);
-	case IORING_RSRC_UPDATE_NOTIF:
-		return io_notif_update(req, issue_flags);
 	}
 	return -EINVAL;
 }
-- 
2.37.2

