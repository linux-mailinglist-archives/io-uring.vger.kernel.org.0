Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7EB6D60FE
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbjDDMlH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbjDDMlA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:41:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A0ADC;
        Tue,  4 Apr 2023 05:40:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h8so130056381ede.8;
        Tue, 04 Apr 2023 05:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Cxnc6JJ4qGOse8EhEinOqNQd7wwXuaUvmBXkiroock=;
        b=gFUqc+zKGga9k0qzAdqlH1gM+8CtYlpy+pGMckAxAwFPuqueTJ86Ciw5ZRqgLgqU2l
         sJAQXjA8vS2mlG1UyQYjtuA91TI9s8OPE95zwTJ7jy7x/B17xFADrqup42Q7+jCN1YRJ
         FDBKPxaFtwNPt9/Llb8vouwQD8tchPYs7zK0dommYY3w8fRPjeA2NhDQ7wgoNGpZnqn+
         dF33eg4jfLs+Avp61orMDDdRwPyVx0htnPED3iN3Zxl4bU3MVsGBpZ1lvQRA2o5ao+Ly
         RcsGJIFsxP8iBp+I/TLQj2mja4v3csBKd+0JdQImLefKd0NdT6bo3xFGJMv+YGqoE5O/
         tHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Cxnc6JJ4qGOse8EhEinOqNQd7wwXuaUvmBXkiroock=;
        b=TIP5tfsgWtcPYzmQog6VZESsX7ckn0xKEj5wilmvaOpR47p+A9I9UgP8Mrw/h2u0Wg
         2riOq4jVrGQq/X3rEHDr417+zfCevCcZ047TmVYHjTeQRk18hMLqnXGz+S9B50x4Lwze
         754Ze+My6LWnzmdUYSHcUAfnINjB9KF8eWLCF4Ndpixwedg2MjTDw2kXJujf/okBPB8R
         40uTMOYsw23L773p1T9twlenkXQUaWN3CyHtzDpHSzlXbCXf7BBwhK8kfbZyROa4k9fa
         LGk9NF0I4GZ3BQcf3i/hJZQtFW54GsCa7tIjk7Z7XCnN9n+jOSgj1XH3havYqhBHx0JO
         9XoQ==
X-Gm-Message-State: AAQBX9fjHuGdYy0MkDfEG01s/nxb1V1AVJAnlXUNrYvWgh+Zw5+bbxA9
        xre0LO21O7K8tDlengKhl9qG0/hAal4=
X-Google-Smtp-Source: AKy350YYzm+GVFL3vQsbfEu6LFsQ68PoEQzGtfDtqcBT4Jn3OdQUuwCP6/jYVzozfXOqP2JwDswLyQ==
X-Received: by 2002:a17:906:3012:b0:92f:ccf3:f0ce with SMTP id 18-20020a170906301200b0092fccf3f0cemr2131169ejz.45.1680612056699;
        Tue, 04 Apr 2023 05:40:56 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/13] io_uring/rsrc: add lockdep sanity checks
Date:   Tue,  4 Apr 2023 13:39:55 +0100
Message-Id: <b50d5f156ac41450029796738c1dfd22a521df7a.1680576071.git.asml.silence@gmail.com>
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

We should hold ->uring_lock while putting nodes with io_put_rsrc_node(),
add a lockdep check for that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/rsrc.c     | 2 +-
 io_uring/rsrc.h     | 6 ++++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 419d6f42935f..da36fa1eeac9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1002,7 +1002,7 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 
 	if (rsrc_node) {
 		io_ring_submit_lock(ctx, issue_flags);
-		io_put_rsrc_node(rsrc_node);
+		io_put_rsrc_node(ctx, rsrc_node);
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
@@ -1123,7 +1123,7 @@ static __cold void io_free_req_tw(struct io_kiocb *req, struct io_tw_state *ts)
 
 	if (req->rsrc_node) {
 		io_tw_lock(ctx, ts);
-		io_put_rsrc_node(req->rsrc_node);
+		io_put_rsrc_node(ctx, req->rsrc_node);
 	}
 	io_dismantle_req(req);
 	io_put_task_remote(req->task, 1);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index cbf563fcb053..95edc5f73204 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -236,7 +236,7 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 
 		atomic_inc(&data_to_kill->refs);
 		/* put master ref */
-		io_put_rsrc_node(rsrc_node);
+		io_put_rsrc_node(ctx, rsrc_node);
 		ctx->rsrc_node = NULL;
 	}
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 3b9f4c57c47c..cf24c3fd701f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -119,8 +119,10 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
 
-static inline void io_put_rsrc_node(struct io_rsrc_node *node)
+static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (node && !--node->refs)
 		io_rsrc_node_ref_zero(node);
 }
@@ -128,7 +130,7 @@ static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 					  struct io_ring_ctx *ctx)
 {
-	io_put_rsrc_node(req->rsrc_node);
+	io_put_rsrc_node(ctx, req->rsrc_node);
 }
 
 static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx,
-- 
2.39.1

