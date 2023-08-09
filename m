Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E927D775ED5
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjHIMYY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 08:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjHIMYY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 08:24:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633D21FC2
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 05:24:23 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4fe2d152f62so11214265e87.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 05:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691583861; x=1692188661;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jKKY7S39yez1G4yc4hbJOFdF2MqGYBVdxjfyuQgipiM=;
        b=AOSerd6xyCywFZoRp8K1idOmBnqkAutz8C1cz7ToAOyiCTOmWQHQlJLR9j5DJy5D0o
         eCfkU8Mj1/S15yTRn4zpM5Mybb6UGcanAKkjnMENwgWe12Ikalyt8tg93hsKtrK+erOa
         5vl7dVRINsZxPoz9ve6e+xuUlEkWko9RSUxEdwtj5NBJMMSSKV5wJuWZOf/lb2gOJcNk
         TBexHeart8NjvTPsO8Oud+pMHBurJijtlaPt1vSjqv6q3jPGQy9r1JJn/CAh6b6mZwnW
         /WrxFkpWVyEjPGk+knbSFOcvIR3cJtRj7eQRdQJuj7WDksMdY/6tdcxHoQzIO2dxhv9e
         1qTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691583861; x=1692188661;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKKY7S39yez1G4yc4hbJOFdF2MqGYBVdxjfyuQgipiM=;
        b=UZcGop8pr/TevewX+aRMf9kYyX1fNWRBXHZ3ez0hovwVPZP3Uc7hxNv2dIQu6zg91V
         /ctVo02XioHAi6ypSGaLP5j3mWbKOgIIAcGjQInqkbljlLIbBrK6wbNtc5prsX0hOFWi
         +gzyefeGbamPV+Yql/DXHh2cetJqnF3wWzxkX7diXRfdbRibBx2vkqp7NgNCRvBAOXoy
         dWMEWpr/iCA+Rv8knz3d0tjuA+Jqm5Rc312DTDhF7T4V/Bhnd/XKn2s/Or6JxmSDKlIa
         IGYH0cgyW/u24JqCYTxIxmrLiopRIJzlu+YgbWY5/BP72alhZVVor+hpm3F4qNlvocx8
         a+rg==
X-Gm-Message-State: AOJu0Yzk9vq9dmkwFN5ctAoY8WxiNf+EgtZL7qYlkHkwFlTiV+THExeM
        hSjRPJu5GSSHm7W1zfZrvibL8R42zdE=
X-Google-Smtp-Source: AGHT+IH3NWyc53e5qiuuauh1s4H5APQPEaRqSyzzWNGHxkG+7G2YTYRJXtWyxXojwQcm/IIVAjRuZw==
X-Received: by 2002:ac2:4158:0:b0:4f4:dbcc:54da with SMTP id c24-20020ac24158000000b004f4dbcc54damr1427834lfi.27.1691583861062;
        Wed, 09 Aug 2023 05:24:21 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-78.dab.02.net. [82.132.230.78])
        by smtp.gmail.com with ESMTPSA id b13-20020a05600c11cd00b003fe1a96845bsm1860058wmi.2.2023.08.09.05.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 05:24:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix false positive KASAN warnings
Date:   Wed,  9 Aug 2023 13:22:16 +0100
Message-ID: <c6fbf7a82a341e66a0007c76eefd9d57f2d3ba51.1691541473.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_local_work_add() peeks into the work list, which can be executed
in the meanwhile. It's completely fine without KASAN as we're in an RCU
read section and it's SLAB_TYPESAFE_BY_RCU. With KASAN though it may
trigger a false positive warning because internal io_uring caches are
sanitised.

Remove sanitisation from the io_uring request cache for now.

Cc: stable@vger.kernel.org
Fixes: 8751d15426a31 ("io_uring: reduce scheduling due to tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 -
 io_uring/io_uring.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0eed797ef270..fb70ae436db6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -245,7 +245,6 @@ static inline void req_fail_link_node(struct io_kiocb *req, int res)
 static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
 	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
-	kasan_poison_object_data(req_cachep, req);
 }
 
 static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d3606d30cf6f..12769bad5cee 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -354,7 +354,6 @@ static inline struct io_kiocb *io_extract_req(struct io_ring_ctx *ctx)
 	struct io_kiocb *req;
 
 	req = container_of(ctx->submit_state.free_list.next, struct io_kiocb, comp_list);
-	kasan_unpoison_object_data(req_cachep, req);
 	wq_stack_extract(&ctx->submit_state.free_list);
 	return req;
 }
-- 
2.41.0

