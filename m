Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486226D08D8
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbjC3OzX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbjC3OzA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:55:00 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4056FCC28;
        Thu, 30 Mar 2023 07:54:50 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h17so19368928wrt.8;
        Thu, 30 Mar 2023 07:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cs6esp50Jp8jC0Q9hhTRpI4nFHoCs+WBE2+fqKZb6bE=;
        b=lZAb3+CF9ww4EB25PAj0+FL6j458WyQZqxNaCRdNWNkCqzpefmh+epQzj26e3OrL8n
         TawKc4VhwlrLo35FK5XVNnUUfAZzzv4mIacNOrsSiYkn478r4ECEfAjWEG9hH5lnNh7X
         BkdLNArI1Xv6UnoeTi6296UPd++TUI5Ui/T93an238DKnTulXzRnQ9eMD/A9zK5xxU0y
         BV7BSq2FjbBKojJdqQ5mCUbaWV+np5V2VdduZBuDPk9HLHiqt4djiYChWGDy8BcrZKU2
         yE/Bq3prxOLlWMFVPZv/ZEH2jnZprFNE0fyHk08xrt3HwTz72C5Ep0TuaR1HuCM8VntC
         89VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cs6esp50Jp8jC0Q9hhTRpI4nFHoCs+WBE2+fqKZb6bE=;
        b=ZcaqVxvXKLPbyQsDCZJK4zwNVk0roXyeFmTiJlDmtM4z6ackJp+1v9pz9YLG8RMhIG
         IK4mn75pz7jlSZ2frc+k20z0iYd5W3jHGWxEula/R0uC1GeednuhwCph13dm/X7z5qaH
         L+qGhO0N/Q3bY5Fp1Df6obk1CqXb79fQ2oi2HYj527liwBuQWhn2mNchMJiMbI//4nNy
         SVdb1txe0bljhZ4GhjaXEdpoU9bymdid+yUitCUeNvVDdqzJ8C7VRbS1QbZVxkw5aZod
         6WY9CzkMM0jhDh7y63n/fSjTzEm8w8Mqxsg+uIVF5x04exBUBRyNh+ZxwDWESUuxw7bh
         ks3g==
X-Gm-Message-State: AAQBX9dCAVnBmuJ8/4lw6WeQhc0BjZayrlTUEW/y/2UlUE/Pu28Im8W1
        GmHK2YMPr21SAzooVdKN+oYDLA7uLGY=
X-Google-Smtp-Source: AKy350apMKT24Tk1edTb7V3CDWaTS7QzV3PIphwMloAC3NGDCOIeI+eUl3G7kPsD/NcJ9F+a5GpFbQ==
X-Received: by 2002:adf:f549:0:b0:2e5:ab4:22f0 with SMTP id j9-20020adff549000000b002e50ab422f0mr1582562wrp.60.1680188088366;
        Thu, 30 Mar 2023 07:54:48 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] io_uring/rsrc: add lockdep sanity checks
Date:   Thu, 30 Mar 2023 15:53:29 +0100
Message-Id: <d4c9d4791c934fb40e17c69529de78afe241cd6b.1680187408.git.asml.silence@gmail.com>
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

We should hold ->uring_lock while putting nodes with io_put_rsrc_node(),
add a lockdep check for that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/rsrc.c     | 2 +-
 io_uring/rsrc.h     | 6 ++++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index beedaf403284..a781b7243b97 100644
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
@@ -1123,7 +1123,7 @@ __cold void io_free_req_tw(struct io_kiocb *req, struct io_tw_state *ts)
 
 	if (req->rsrc_node) {
 		io_tw_lock(ctx, ts);
-		io_put_rsrc_node(req->rsrc_node);
+		io_put_rsrc_node(ctx, req->rsrc_node);
 	}
 	io_dismantle_req(req);
 	io_put_task_remote(req->task, 1);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 345631091d80..d4bca5e18434 100644
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
index d1555eaae81a..99f2df4eafa1 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -117,8 +117,10 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -126,7 +128,7 @@ static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 					  struct io_ring_ctx *ctx)
 {
-	io_put_rsrc_node(req->rsrc_node);
+	io_put_rsrc_node(ctx, req->rsrc_node);
 }
 
 static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx,
-- 
2.39.1

