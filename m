Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523E96D60F5
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbjDDMlB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbjDDMk5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D41D90;
        Tue,  4 Apr 2023 05:40:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ew6so129934757edb.7;
        Tue, 04 Apr 2023 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7NWdR6MPB6XAokVEPIwltF2umB3WBqKQ7V2xA8hlx+8=;
        b=A2IrdkosuU5qJYIAvW+WrYNBZB12BQQqpN7XLYVE2WDD3CO0lAjDS+craxmRF4yOr8
         VWgYmj6W6t6FVUYsBh2H+zX3+0PSiwwbio0FdfVaYa7wCbaFqxv9Kefl0oeY0DfR4Mkh
         2r9l7gIGgn2N1btGcwHKWbfYxpyJPrO+dLFu69PTsOnZwLZprRHk9atL/e3c167J61Gw
         NM2yzEY3Km9KctkaAA/EG5BJfMpU5L6uO9y2MSyNIMXAKBfUFYSd4iZtavI9ioeyunj2
         nYgOxitaCITguhG50Xf8SD83alXzdBbJmx2waWhFBGpZTPiWJNTmDWIRBtJABJ//oy4x
         ypug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7NWdR6MPB6XAokVEPIwltF2umB3WBqKQ7V2xA8hlx+8=;
        b=SFwvFDgng3m7R6e+hPyc+JeFlMEiRCPXiXAJY+rua//iu8u7ov7PR54yOsKZw2Bb5j
         SBdz8MGoIaBojCuBoUWPUUUVHVSXiVPBc5XwfXvKSsOUojnwYXgKy6I2SMebtJQmgYjy
         jSmEb5DP0Gc62DLVJeCeebw2UlkUBdAI1+U2dgB9oEYKbEkaFGmmmnNAlxUC1GUAxcXI
         pQkLho85XqWW8ejoe49kWFOyuPp5nSXgyINVN6ffgYr/9X2dyQOyhc1DBY/yyxUmY0xf
         B+aDmXTBg394P03SFnxOaS2q8wjpViBcCCeXh5HsW683c4IRG3dzClccqVU8rjMttPWq
         5VWg==
X-Gm-Message-State: AAQBX9fICUpX1kz/VehSRF0ZjBQ0lnuStQFuSYEIazHlxsQ6gY3ibOii
        VR5EcBHxpS2UXhEZAJ+KSpDUh5dAnkY=
X-Google-Smtp-Source: AKy350YNBdEjpip9I5hF2M873hJcOlIC4w64PAYfwZZj2usnjiI9JSSpLCg0m2SQL4NgBoh+5IzV+A==
X-Received: by 2002:a17:906:1786:b0:948:6e9c:273e with SMTP id t6-20020a170906178600b009486e9c273emr2242990eje.62.1680612052400;
        Tue, 04 Apr 2023 05:40:52 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/13] io_uring: don't put nodes under spinlocks
Date:   Tue,  4 Apr 2023 13:39:47 +0100
Message-Id: <d5b87a5f31270dade6805f7acafc4cc34b84b241.1680576071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680576071.git.asml.silence@gmail.com>
References: <cover.1680576071.git.asml.silence@gmail.com>
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
index a0b64831c455..596af20cddb4 100644
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

