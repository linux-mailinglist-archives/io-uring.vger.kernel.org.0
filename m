Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAAE5B1CBB
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiIHMWs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiIHMWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:44 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357B8F6BB5
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:38 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t5so24017111edc.11
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=7+lV5qXCTNTjtoJhM9U/RPmNJbFpVO0bVaWeqGA3UqQ=;
        b=d1J9LYuiN2YnseNjl5OHkPCXb0u0LSJtAZD0Qs1xri80g1+yDudTYGWZ9pRN2M4p4j
         PgRH4Leg90Xz9sZ6/nq7oJY1aFjcMeKqo7M3npPsMc/lVas+Rr8q2waXUiXUAMdydC9b
         WmUh5zqCNp2NNBpEkB7FiDUPdslIdLrRRvSSmU5xcPhXWIL+CbPHc0bfYhzOUfLWisEG
         dHY1/7LDtTab0kThJxBOy0tiHnG0xfEsUnvOGpqpjjOXPYN/zxbnIwWm0H2Zd8FUZo/o
         OFD721R+5BZ8NsbMByQo8bgPLkEhRatQ9CK8yz/X/DahsFTcXjPaHxtQdVuzztnQlqff
         AEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7+lV5qXCTNTjtoJhM9U/RPmNJbFpVO0bVaWeqGA3UqQ=;
        b=rGg3pmv7aC8VnOJwk2rWRl8vreoPNGATfsvQmaR6pheSDbwGKwj+GLYQVaJNE8KEal
         gS+wxzxymI0elNUs6oKnaryVi8m4iDQCB481QWSFBDvkRrYO8Qnj+gZZl2FkwjiOTpyD
         rn57o+gAfaJIN8Aetyaqo3BGk10C/N6b1kM7202PtuuxwRfvofW+KBwfNVcx1F49ZfL7
         19Ogira9inUvFFdj6sye6vT+4lKlxg8zk2PkGNf6PduAfxNQYqrqz8+w6yiMmGy/+lFj
         CCC/b68lST3e/dXYjmW+UE6VdKPF+1WSsl9KkMZPFt1uEf+muX0ur6XU4sMZYNHeefnN
         L5ig==
X-Gm-Message-State: ACgBeo1/ZGIiHBWBTQk9jgM3G0g7AxRwYOlsEFavbeIGBNCwjI6J5iJE
        O6Ra5IEty5Y+IKtm+/bU87mtMqtAMCk=
X-Google-Smtp-Source: AA6agR7gJWdDLcbo10UQfxn+dWnHGPDwZCk6xtGEuVUE5OxWpcDgXE+Cd1mtVqldfoWFfZqR3DnN8A==
X-Received: by 2002:a05:6402:2693:b0:450:a807:6c91 with SMTP id w19-20020a056402269300b00450a8076c91mr2277168edd.33.1662639756013;
        Thu, 08 Sep 2022 05:22:36 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/8] io_uring: use io_cq_lock consistently
Date:   Thu,  8 Sep 2022 13:20:28 +0100
Message-Id: <91699b9a00a07128f7ca66136bdbbfc67a64659e.1662639236.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662639236.git.asml.silence@gmail.com>
References: <cover.1662639236.git.asml.silence@gmail.com>
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

There is one place when we forgot to change hand coded spin locking with
io_cq_lock(), change it to be more consistent. Note, the unlock part is
already __io_cq_unlock_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 339bc19a708a..b5245c5d102c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1327,7 +1327,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
 
-	spin_lock(&ctx->completion_lock);
+	io_cq_lock(ctx);
 	wq_list_for_each(node, prev, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
-- 
2.37.2

