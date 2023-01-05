Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E2465E399
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 04:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjAEDif (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 22:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjAEDh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 22:37:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A148CD9
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 19:37:55 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso730262pjp.4
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 19:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r1JpqbJ9++K/xzT47dMTEov/5+2eYul5oJHyAzUfPlI=;
        b=BHsuebGz7UeGzGoW+IgpyeSNW0q2RdIcdyQ1lia+mDfh5WQUzUcg8FBu5cGvL5bmVd
         h1MHDMLC2Bq/qIYjylAiEzm4JqV+i62MO4R1/zf0ccUhdL6YKFMCIrdjdhNEu1v5AEST
         zlkrBx6EmfW3RoHcj6qm3k7WqJQLxSVeHAh2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r1JpqbJ9++K/xzT47dMTEov/5+2eYul5oJHyAzUfPlI=;
        b=20lL2ZQ39RXYQeEeXv0phByTJBa9EL3U8HfFWOkNkW11nmb6PQYefqAPODpFjQ4XW1
         LxAgOvUUUeokZ/pQf6Ar3grsls8RKuT3zndYxMiCJY6/vUXiaeIp8eihjCJ71FYInFGz
         yhSuqGrCRPQv9KGnbVCgyTZiD0OC8aDKGio5XmmgJnaLiL/9gMGg44K9EfyTEv+s5sgh
         esuVZL25OBhYRRWfAFacOi/v7oDYUFtyG5BptdpTfZoFfgHflrPQxqmbkgwPOw+NRz42
         mVF7s+ZP1tne8Lf0y4DIYLRlko2rUIyI3jTVTBFW70AxNOKY9xYIKHgftshm9ZNSLDaq
         gOjA==
X-Gm-Message-State: AFqh2kosU+jd6BRfcOUy+QDj0HYHhqLiZQBxqcsgKpPbTQ84lIvlGA9J
        IHC2HqrFLgc8d6m+ZnXcFTC+mw==
X-Google-Smtp-Source: AMrXdXuZ+klPVs4aw4KC1gI9YsEim8vZPlGfK9UnseD5KlDls5SUP49aFkwWSHMo97GKojdho/07Tw==
X-Received: by 2002:a17:90a:f697:b0:226:1dbc:9f89 with SMTP id cl23-20020a17090af69700b002261dbc9f89mr27025085pjb.28.1672889874597;
        Wed, 04 Jan 2023 19:37:54 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o18-20020a17090ad25200b001fb1de10a4dsm280956pjw.33.2023.01.04.19.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 19:37:54 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] io_uring: Replace 0-length array with flexible array
Date:   Wed,  4 Jan 2023 19:37:48 -0800
Message-Id: <20230105033743.never.628-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1795; h=from:subject:message-id; bh=r+TSIVb2BAWhTrGlFufqT3ga06iplRy8uL8xmu6l8Nc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjtkYLP77BW3IAXqPW/RhqrA24FMPNCSI45CQs2IEd fy5cqKeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7ZGCwAKCRCJcvTf3G3AJqxND/ 4oGtR93uxHdilcizcL38yy4WDqC1zZkr1T3PXAepEgKMvcdsHqd9vzYPr2LgRHkCHsXo40ZPZR82Wz sUz0G6mP2tbZB85d990jEkkNQZE6Dc6OHj5I+dEsbm59Axce8iv0TpSEt8K8CZYg3VSuG/cQwyLKWa 4LLH3lIemP13XM3j4h035U+MPCF6jawWAw4chzz75/ulJIUSvDiS0ZxuAKPYZDTbbFsqkqMZzrAp6D azrxOyTr1c22SdkFTrF+0yqN4d245n9b8ueQlddoV5yPVaOQy1oDUXFlkgXJ2jvwNPa0phSgWastVe 6fjWF2k5OHzljQeBNtb8RqEf5Ud735dMTgPEU9o3lqQc8IkmGXyAsPi89wVk/eksoWrqcMP0s6XGcP hPrzB0Ixz2AW2bM2xyWPneebhaQlYnR3RO7xn83E8lbtKSTRRxcL0KhtD4Edoizki4soYMPUHFnvnG KC1035zSBZpj9w+SWeEGDgsSJlOria6hjC0f9gfypCRMvLRdVRRhy9amB+31qZ8a5fk9TtB4jbTjZY vqZu/+TYJuwU4zTLbR8YPtSipI4GKsxg7g/aN6FGlH7euKWsWi1JfGfraY+sAB6ZsrEqH/qCcAChe8 jmUNLNZCX8679hAFztKUsOc+IgPTku8pHV1XKvutWA5doN2Yq23jvjHDPujA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Zero-length arrays are deprecated[1]. Replace struct io_uring_buf_ring's
"bufs" with a flexible array member. (How is the size of this array
verified?) Detected with GCC 13, using -fstrict-flex-arrays=3:

In function 'io_ring_buffer_select',
    inlined from 'io_buffer_select' at io_uring/kbuf.c:183:10:
io_uring/kbuf.c:141:23: warning: array subscript 255 is outside the bounds of an interior zero-length array 'struct io_uring_buf[0]' [-Wzero-length-bounds]
  141 |                 buf = &br->bufs[head];
      |                       ^~~~~~~~~~~~~~~
In file included from include/linux/io_uring.h:7,
                 from io_uring/kbuf.c:10:
include/uapi/linux/io_uring.h: In function 'io_buffer_select':
include/uapi/linux/io_uring.h:628:41: note: while referencing 'bufs'
  628 |                 struct io_uring_buf     bufs[0];
      |                                         ^~~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: stable@vger.kernel.org
Cc: io-uring@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2780bce62faf..9d8861899cde 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -625,7 +625,7 @@ struct io_uring_buf_ring {
 			__u16	resv3;
 			__u16	tail;
 		};
-		struct io_uring_buf	bufs[0];
+		struct io_uring_buf	bufs[];
 	};
 };
 
-- 
2.34.1

