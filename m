Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0130F4DDAFC
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 14:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbiCRNzM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbiCRNzL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 09:55:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDA619236C
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:51 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id p9so11807858wra.12
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3UYPmUHSwoAZ1+s52lpjiTbGYSdpcWT5gBjkmQjt3b4=;
        b=S6QB9Tv+WIzJagLAVOpV/S3PB8KgcgHe2BBQqc4iI6esb5fr/22/hZ8zfR660N1JfG
         nNVVPd5BBa8f4CbWrfmo+jpKtcCBzGYegT2zqGLvmbA7paCmf5mJoCITbcy+6Z7PPAQK
         q+ItStgTdvA2cO826keONep8Z0JmsAk63Ko+n1UUDgFmy2q/omrwU2jzsQZhXpeaaENF
         51HUO8aiJceFP2fQIBh2UcL+IHnYW1hPnU/Uqr0hQMD6+GyR+Qos2e7pBZrYByDmHo6C
         9zb+ofeHiw7aPvpF2rTT1AMcfTyM7BJdfGdTKifJYSWlRiJ1wJ/hHNjVZ9AgLnzX+8Jc
         fH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3UYPmUHSwoAZ1+s52lpjiTbGYSdpcWT5gBjkmQjt3b4=;
        b=XffW4IhG70uj4K83XlyCh9vnRUCMJIFeN+w4hJWD2o7RpD4fwuMUYb5iXbg/cDdSYp
         UINR8EEuVqyAQa0cmxhTp5CO8Ij7+15XBduw7ymF1gXH5znSWnCCP0CPsgMjzvOLaoVR
         dXtwWlfBZQGfAANtPgoMikeSaxvk3YlAbXbQanLvjFQ6K2lDNAZxx6iICvr+E+53ZCeH
         5BeLxdQtbFE1h/hJvGcbNM43f/h04ZOeo2UCU10P8l31CpBY01cT44bBIusJew/rktVl
         3xbn/Oj3s5gyaTUqeUPpAX4qUFV+yB11J2PDMFcUtttVAZy7rR2e8B/+JVxUf0qIJl4C
         UvRg==
X-Gm-Message-State: AOAM530UREQI1Svw8oEdNyOy41Xce1+IafiQZLzEa3T4KqY5lWgOQoCj
        /SZfvmYYfXOGDmFaXl98DSnQEfAn4vv1rQ==
X-Google-Smtp-Source: ABdhPJxzFTyZygEDOFX+NV9o1qNjpqw+sJfJf/S3mKm299VRYQRWuxO1rjBsAOradozoHgtUa+WViA==
X-Received: by 2002:adf:eec1:0:b0:1e3:1e0a:72f0 with SMTP id a1-20020adfeec1000000b001e31e0a72f0mr8310768wrp.524.1647611630110;
        Fri, 18 Mar 2022 06:53:50 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c1c0800b0038c8da4d9b8sm1290375wms.30.2022.03.18.06.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:53:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: remove raw fill_cqe from linked timeout
Date:   Fri, 18 Mar 2022 13:52:22 +0000
Message-Id: <83afab152563869d3f088ca7e47eb9b3f7308102.1647610155.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647610155.git.asml.silence@gmail.com>
References: <cover.1647610155.git.asml.silence@gmail.com>
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

We don't want io_fill_cqe_req() in disarming, so replace it with
io_req_tw_queue_complete() as usual. A minor problem here is that the
timeout CQE may came after completion of further linked requests, e.g.
when it's like

req1 -> linked_timeout -> req2

However, it shouldn't be much of a problem as it can happen even without
this patch when timeouts are racing with the main request completions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fff66f4d00c4..5f895ad910b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1166,8 +1166,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
-static void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags);
-
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -2070,12 +2068,6 @@ static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 	return __io_fill_cqe(req->ctx, req->user_data, res, cflags);
 }
 
-static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
-{
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(req, res, cflags);
-}
-
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
@@ -2307,9 +2299,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			/* leave REQ_F_CQE_SKIP to io_fill_cqe_req */
-			io_fill_cqe_req(link, -ECANCELED, 0);
-			io_put_req_deferred(link);
+			io_req_tw_queue_complete(link, -ECANCELED);
 			return true;
 		}
 	}
@@ -2357,9 +2347,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			/* leave REQ_F_CQE_SKIP to io_fill_cqe_req */
-			io_fill_cqe_req(link, -ECANCELED, 0);
-			io_put_req_deferred(link);
+			io_req_tw_queue_complete(link, -ECANCELED);
 			posted = true;
 		}
 	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
-- 
2.35.1

