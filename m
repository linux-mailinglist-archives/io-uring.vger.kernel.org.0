Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F7154DE16
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359793AbiFPJWw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376655AbiFPJWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:50 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D143813F8F
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:49 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i81-20020a1c3b54000000b0039c76434147so2500284wma.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xtoDyDvNXPTaclwDuSrBJ25RRT45S7N/gTULdXm19LA=;
        b=PZHLxxb96ZZSjv9zS9xYoL2jHEbnmGHauRivawSzqNRAZFKvp6BUol0xZz+lQc4HLg
         0aiy2bYHX7wHBQ9nBLIjeULxGqryfTFA3hu5voUe4DGhN1wNvKBQsXW8qRfci5yVLTE/
         7whO7Y4p2zBmo8+JgM/kNqw2cSMLTJ1yZufeVIjD62wz2pQUEN3A49pRbswd/6YQhHK2
         q63BvejoRjeLEDUxrmq1Ex/OISR0W8bR2TtA5auv0OnTqum1eTMcQ4JxkaogFQEB+Iug
         rT3vYxf2it4k3RWuJ+0nPx4SDBgOKL496AlYtna963vnDrvoisLsBOvJGt+Cs8OXfJ+l
         rzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xtoDyDvNXPTaclwDuSrBJ25RRT45S7N/gTULdXm19LA=;
        b=VOFDAgCUtWt1l70t5vqYh5+2+y2h8/PElY1gBh80+LRZkLmBdeMkHCTRQ/e8Qj8aYW
         TMg1KJNGo/ogovchuW3hpHDRfDJHYkOGE5Acdakh8lgltw6bIl06Lw45SPjSaEsvkh3U
         O3YjHLYvN/TctS1/1gAjhLHZw5VMH0ZJv2VYZdx2Zm3csLaDEs4PUtGL3McVuEV03Yms
         Pvgzh+CiDKfwHxmqRGpuWr3QGZtlMefI80KzXse2zVohX/2YCAKoyoiRgJy5+NRYQIcB
         nTgvZzQ23KX1KJ3Xl/7SzWi6dDCac1JX4TK684Sdy4FZ0cn/eaSycGSQbTmpMQglA/i8
         X0iw==
X-Gm-Message-State: AJIora9Lys6fziA6M91hbC2QP7eIZsyVGYS1mPO3TQJZ0pvS14ZMIQid
        KSs9YGZv9LQPeMFY/fTDXOoKEpEMtGgYhg==
X-Google-Smtp-Source: AGRyM1sUE0TRlFkQNVACxK/gvFWwFzyx1ANrJhilWlWHKEJ/I8T8hH1OqoeHUT58iFRmTEsdTsPDSg==
X-Received: by 2002:a7b:c4d4:0:b0:39c:5bb7:2210 with SMTP id g20-20020a7bc4d4000000b0039c5bb72210mr3867363wmk.99.1655371368197;
        Thu, 16 Jun 2022 02:22:48 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Hao Xu <howeyxu@tencent.com>
Subject: [PATCH for-next v3 05/16] io_uring: poll: remove unnecessary req->ref set
Date:   Thu, 16 Jun 2022 10:22:01 +0100
Message-Id: <ec6fee45705890bdb968b0c175519242753c0215.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

We now don't need to set req->refcount for poll requests since the
reworked poll code ensures no request release race.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0df5eca93b16..73584c4e3e9b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -683,7 +683,6 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
 		return -EINVAL;
 
-	io_req_set_refcount(req);
 	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
-- 
2.36.1

