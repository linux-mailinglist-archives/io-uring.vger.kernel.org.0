Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC256D08C8
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjC3Oyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjC3Oyi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:38 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A01BA5D8;
        Thu, 30 Mar 2023 07:54:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so11974552wms.1;
        Thu, 30 Mar 2023 07:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWAczytuFz9lGZfCu/Rbuh88s55sTzs57HoEPIGs0GU=;
        b=ZPQgYFuWcz1SvJblTrxSJFLx5OAkM/KL/BYFd0RSfa/H2AiXu8SDOQ5j5v3iJprcop
         Jx9t48yuY9un4JFMIBZ0Tzqb/jVGOO6oTYOOE87IYBLtZrXfvYaxbD9Fa+ErOFN9ROHZ
         uEMnKIRmPXJoSZRA4y1uHnQeIGVXv7ebHVolEBgDmcM91gxa9mS4vxV+dLlkfDHiGEUq
         hrmrqXUi5RXmuK+b/ctz8UsjGEg9kZ6N18KJ9wFAb3LF5mxKTohvByLBmHIrGkRq3Oq7
         BDvCISHhLESl1mCXuFCwFrNwydXnxpXpXJZ5vvnRAl9xhNkSijs3wYq93FgJUOh+MifF
         ecaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWAczytuFz9lGZfCu/Rbuh88s55sTzs57HoEPIGs0GU=;
        b=zBUikyicM/zeIOYvvcF0FJG1rvDA7Xk2osdcEii+KEYCigA6MaeqrJ55SP3+R/sHuS
         JRgte4vX/mIgB4QkfZaoVwlpX2BhH7z9srWx9J0bIuoD7lkDZ/ItccSEkCA/twjw96hy
         Nx2nCOvchcjaoA2Bi2X6GRITHdNd9DsXk8UuhDXQmOaVJ+LdbMhpA5U26Dbev3I2PA0F
         Eo3na+FQgsM52MBQsQ2nRqtwzBrXMpsaJjLmlKhAoixN/dHhdBK5K01Y0FdFM2ELZeH4
         LDC57UooIJ3DvKlFzYtJj0zTs5rvpFFNuaaZJW2p11lg+OePSEok2g6YQOjOyOOBboiW
         9PvQ==
X-Gm-Message-State: AO0yUKXOSbJ1vZxlm6P6SCWtO+UsJeOQpk0t69Gm6YqaoZyy0h7MdHwA
        Rausc7zmykOLp+pRRrpM2z0YpAu/DBo=
X-Google-Smtp-Source: AK7set+zedwXs+fLdMumlxG3sBZ9gDN2RVPlR6v3s6LBi48heZcC1nvjcMspRQH/8cUFA6geqyC44w==
X-Received: by 2002:a1c:7702:0:b0:3ed:4f7d:f6ee with SMTP id t2-20020a1c7702000000b003ed4f7df6eemr18359942wmi.14.1680188075498;
        Thu, 30 Mar 2023 07:54:35 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] io_uring: don't put nodes under spinlocks
Date:   Thu, 30 Mar 2023 15:53:21 +0100
Message-Id: <dd62f1c79e84f034acefaafac2a37f78ed8c0275.1680187408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680187408.git.asml.silence@gmail.com>
References: <cover.1680187408.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_put_rsrc() doesn't need any locking, so move it out of
a spinlock section in __io_req_complete_post() and adjust helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 7 +++++--
 io_uring/rsrc.h     | 6 +++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 536940675c67..c944833099a6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -970,6 +970,7 @@ bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32
 static void __io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *rsrc_node = NULL;
 
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP))
@@ -990,7 +991,7 @@ static void __io_req_complete_post(struct io_kiocb *req)
 		}
 		io_put_kbuf_comp(req);
 		io_dismantle_req(req);
-		io_req_put_rsrc(req);
+		rsrc_node = req->rsrc_node;
 		/*
 		 * Selected buffer deallocation in io_clean_op() assumes that
 		 * we don't hold ->completion_lock. Clean them here to avoid
@@ -1001,6 +1002,8 @@ static void __io_req_complete_post(struct io_kiocb *req)
 		ctx->locked_free_nr++;
 	}
 	io_cq_unlock_post(ctx);
+
+	io_put_rsrc_node(rsrc_node);
 }
 
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
@@ -1117,7 +1120,7 @@ __cold void io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_req_put_rsrc(req);
+	io_put_rsrc_node(req->rsrc_node);
 	io_dismantle_req(req);
 	io_put_task_remote(req->task, 1);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 950535e2b9f4..8164777279ba 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -115,10 +115,10 @@ static inline void io_rsrc_put_node(struct io_rsrc_node *node, int nr)
 		io_rsrc_node_ref_zero(node);
 }
 
-static inline void io_req_put_rsrc(struct io_kiocb *req)
+static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 {
-	if (req->rsrc_node)
-		io_rsrc_put_node(req->rsrc_node, 1);
+	if (node)
+		io_rsrc_put_node(node, 1);
 }
 
 static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
-- 
2.39.1

