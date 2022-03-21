Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0CF4E334F
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 23:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiCUWv2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 18:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiCUWvV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 18:51:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C577659F
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:42:03 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a8so32748438ejc.8
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K4M+367/HVYYRBGlT23lC/G0BwGA5IHtJW6qOha9pBA=;
        b=B+4FJupozrN04ysvrBrxhWh9wu3+5TuKVcXXob6r3v0jSibhGsjwzESP4c1zVZRF/z
         V1p/JhOIC5z3Tubl5k30MsxSPL/nwDo0tN6FVSGYnHal1gcGuWtscCb8XqksYUaTVRrL
         VaFRgVY4kMixzj3qiEFcpJpzZzZUBrf2bWRD4lStJSDjNNB8/ULfBVb9KmuiO7t7c7C/
         LHVUWba0OatzzpvqLYMK7A7ZGuRAaWu40gGCCBDWBtqWbQ7aUPkdVX+ZniRax6IKsAk0
         l9/JhsEA8dhss+walvPnjtq9ucPP3nqGdlVoyw+bJsz3JzAMvl0LKYkHrkiDTb3mDj2J
         sfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K4M+367/HVYYRBGlT23lC/G0BwGA5IHtJW6qOha9pBA=;
        b=0ha24KGSjcxqkWVLJKRM/r9xHe3xNZFw9M08zb1pvW2CPBHXSMBKopkl5Tm3I8PZLw
         phfgxsPQCPexBIBunx7hCJOq21FcBfoUUWyq8ygRQsq2rAttHAcLezhI/90nLgw8Ty7/
         5+TljCBHvUba5oRqP/J3WNoxlM8Il9YbN+2I+IK+52spAWQC5Erpg0Bi1LqGPI+2+hxW
         BvnIzBWWUReSSkE/9SCbX+rDnQq187t+lqJsb1ZDwcFxrJbENjsUglNF29A2wFm1fJKV
         TPJiTJqTae9YQzJ8DcSHgRqxRZ/Q5C3r+ndZDRprnr+CNPBVixgrsFZLDyjkw0IveYFQ
         9mEQ==
X-Gm-Message-State: AOAM532HOUYtm+gx2kEybll0aSnZKCT+bB3QPt6PvA6d0eg2eQdGlhXB
        bTGHgw1z40LZjNZcwlQ28QjOpka3SNez7Q==
X-Google-Smtp-Source: ABdhPJw3QzWdzf3IGWmrFzS9K0URGUTaHXYcwwvJ8H012oO1M7QgKiD+VYba/9HYizGEwly9boSI0w==
X-Received: by 2002:a05:6402:4388:b0:419:4457:27a6 with SMTP id o8-20020a056402438800b00419445727a6mr6267298edc.80.1647900239969;
        Mon, 21 Mar 2022 15:03:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id qb10-20020a1709077e8a00b006dfedd50ce3sm2779658ejc.143.2022.03.21.15.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:03:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/6] io_uring: optimise io_free_batch_list
Date:   Mon, 21 Mar 2022 22:02:22 +0000
Message-Id: <0fb493f73f2009aea395c570c2932fecaa4e1244.1647897811.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647897811.git.asml.silence@gmail.com>
References: <cover.1647897811.git.asml.silence@gmail.com>
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

We do several req->flags checks in the fast path of
io_free_batch_list(). One explicit check of REQ_F_REFCOUNT, and two
other hidden in io_queue_next() and io_dismantle_req(). Moreover, there
is a io_req_put_rsrc_locked() call in between, so there is no hope
req->flags will be preserved in registers.

All those flags if not a slow path than definitely a slower path, so
put them all under a single flags mask check and save several mem
reloads and ifs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4539461ee7b3..36bcfcc23193 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -116,6 +116,9 @@
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
 				REQ_F_ASYNC_DATA)
 
+#define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
+				 IO_REQ_CLEAN_FLAGS)
+
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
 struct io_uring {
@@ -2641,15 +2644,20 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
-		if (unlikely(req->flags & REQ_F_REFCOUNT)) {
-			node = req->comp_list.next;
-			if (!req_ref_put_and_test(req))
-				continue;
+		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
+			if (req->flags & REQ_F_REFCOUNT) {
+				node = req->comp_list.next;
+				if (!req_ref_put_and_test(req))
+					continue;
+			}
+			io_queue_next(req);
+			if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
+				io_clean_op(req);
 		}
+		if (!(req->flags & REQ_F_FIXED_FILE))
+			io_put_file(req->file);
 
 		io_req_put_rsrc_locked(req, ctx);
-		io_queue_next(req);
-		io_dismantle_req(req);
 
 		if (req->task != task) {
 			if (task)
-- 
2.35.1

