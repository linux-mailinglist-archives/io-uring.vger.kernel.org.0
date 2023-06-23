Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037FD73B616
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjFWLYu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjFWLYp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:45 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99341213C
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:44 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-988b75d8b28so56974866b.3
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519483; x=1690111483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z0z++lc82JOEdePiP0bM/cvCnEew7S7/z0AveFJp59E=;
        b=SMBR64+uLdVjkuc/X7vRJ8Plb4K6z5cEJiHFR7dVReyWzTPEfNORKowHYwibkGVSqR
         kaUfIAy+9N8Wb0YZx4SWMu2ALexH1Er70VX6DGeoJGsw5OXgawt02Sy3x91HjqqLH+TY
         e0/Ylx2sXCyoN/jbmY6dSDLdznVeNZ+KXyW/7qOSfD/OzZl/GwqTqehG5Q0aanI0j4pP
         SiqD8zWN00hhDs7lxQ8Fboa5ZB2FuF3y6JgpIk/8hMr4FHZ5IZsKpq5sLYIXbMD6l3AF
         xKG/VVg2t2fXTP8YG/+iqyomY5UcgC4uTthFP0i6KtElZ+lrwv4ImVQxClHwVUjoA2pw
         OkTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519483; x=1690111483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z0z++lc82JOEdePiP0bM/cvCnEew7S7/z0AveFJp59E=;
        b=cPD9FUreZKjyv8DDHRZ1AU8RPdE91KA02BcyX1BIXkXnZWqz2dR0TxnpcEHbIBez3n
         L68G/snoKzxtvnVBhmKULeIfa913UXMnoppjh3MouU/jh2LUmiog03bl5qQpIf0NE4WV
         Z+nxepCqQ6zXdRBoBaz21Kr/BOxFXMbtJunEDfiLQsffbUdgHs3fIa0qfq9R+g2alBE2
         58ILGyX9YeFLXEdy63VTmT/ptosTHSxo0ZW40pg5FT4fTNrPopR2WmRs+emjWOi1i9fS
         lVbhimjfyKG2/DqElc4kx92an9MLdFNi7Re+dxrnLaCkEIlGzt4Z2C81J9AF3PWl3s29
         Fgmg==
X-Gm-Message-State: AC+VfDyvZgymL8B8foTUSfKircweYuAbVHG5i43bYx4StYvtRGZA1iIe
        0rydKvTJ6LWVRykdIbgwaLA6Zt5137o=
X-Google-Smtp-Source: ACHHUZ7loyAMB6cZr+hgWaREpKy2atE9FS/EThHwHXM+Ir2+NSiMp6nqeXzu7lI8fSbF13o2MBx23A==
X-Received: by 2002:a17:907:c0a:b0:96f:d345:d0f7 with SMTP id ga10-20020a1709070c0a00b0096fd345d0f7mr18583984ejc.62.1687519482729;
        Fri, 23 Jun 2023 04:24:42 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 11/11] io_uring: merge conditional unlock flush helpers
Date:   Fri, 23 Jun 2023 12:23:31 +0100
Message-Id: <bbed60734cbec2e833d9c7bdcf9741aada5d8aab.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
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

There is no reason not to use __io_cq_unlock_post_flush for intermediate
aux CQE flushing, all ->task_complete should apply there, i.e. if set it
should be the submitter task. Combine them, get rid of of
__io_cq_unlock_post() and rename the left function.

This place was also taking a couple percents of CPU according to
profiles for max throughput net benchmarks due to multishot recv
flooding it with completions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 70fffed83e95..1b53a2ab0a27 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -637,18 +637,7 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 	spin_lock(&ctx->completion_lock);
 }
 
-/* keep it inlined for io_submit_flush_completions() */
 static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
-{
-	io_commit_cqring(ctx);
-	if (!ctx->task_complete)
-		spin_unlock(&ctx->completion_lock);
-
-	io_commit_cqring_flush(ctx);
-	io_cqring_wake(ctx);
-}
-
-static void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
 
@@ -1568,7 +1557,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			}
 		}
 	}
-	__io_cq_unlock_post_flush(ctx);
+	__io_cq_unlock_post(ctx);
 
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
-- 
2.40.0

