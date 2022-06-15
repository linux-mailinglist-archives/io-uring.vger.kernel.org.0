Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C7154C5FC
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244130AbiFOKXv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348796AbiFOKXl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:23:41 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7E3BC7
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:40 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h5so14780168wrb.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n/UhF3usf3aLjzjUsAalj8CixVGntP0n2zgwZ310CQM=;
        b=Lr+CUAHfnW80Q+uGLcbCjkRipVUCnhpO83nU7jXWgl9bWR7PwZ00icpucqHi7qVsXI
         l+GNtqN+ztfjW4Yswhi3+1rlt6/6FHldqIqt+H8UhL36EaH7nzSff6c6JpOgGXEgTSPg
         GPR568eMlV7eYRyGplNhdjckWYuOMzmYLrCqP+1hFO6hPBanuh1VV1wAut62mU0SIITE
         SZZ83QBNoiqLNt1yXP5uAv5x5Wefgdm4/xUfxYASqCKRZRqolH0m+EfBX5tuyZzFoXS+
         WBdguBzvH75TZ4oP2dUgYVkOEPl5X3PV7RoA6UXWACYhlpzvqigLWFy4pIW5DkVRIRqD
         rd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n/UhF3usf3aLjzjUsAalj8CixVGntP0n2zgwZ310CQM=;
        b=Ywqdtj99pXw1xQJapDh8ggOmQRwfEof4bNnEkNcPpji/oWqzXMTxcQX1sRfVUUcWws
         maRY2cfTCJhLX3oth8Nom8hCUNLAh8ZhqOQcr94GwbuN2hmtJAJlmuiUwHbgzKa9hlNa
         hZzxJhbwWLFC7j1FRZpwf+PZ2DEKbBVmFncTv0CMJykySFelRNqd3gA9om9jFCabvNec
         HAj16M5ZpYbFsEF3/U5SHq95ScQ3yMxGXPTbjp6jU5t/cm3STLzBNYAX9Wk7j2ChJZn9
         7DCxZnIWT8Yb4ZGQLpXg9g355z9svE6xD8ulsCHAnMgId2IRz+GaRdsTzCtkcFWYCMa2
         Uo8Q==
X-Gm-Message-State: AJIora8/v9zqHgUBzQknweCr7oj82BcL0liYArXtMpeDDp1dDNOIT/hw
        8RUYhN4hdzjQvjJ8jy6/dDxKzcJ79XNlIw==
X-Google-Smtp-Source: AGRyM1tNIFUauGBaLmLocmh1EUD2+TDv5Yo4StF4jaJ9q+JKK/JTNwCQGgBtwJmeuw6MPm2w5iLOjw==
X-Received: by 2002:a5d:4708:0:b0:215:d1fa:1b9e with SMTP id y8-20020a5d4708000000b00215d1fa1b9emr9378277wrq.202.1655288618592;
        Wed, 15 Jun 2022 03:23:38 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p124-20020a1c2982000000b0039c7dbafa7asm1964984wmp.19.2022.06.15.03.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:23:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 6/6] io_uring: make io_fill_cqe_aux to honour CQE32
Date:   Wed, 15 Jun 2022 11:23:07 +0100
Message-Id: <64fae669fae1b7083aa15d0cd807f692b0880b9a.1655287457.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655287457.git.asml.silence@gmail.com>
References: <cover.1655287457.git.asml.silence@gmail.com>
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

Don't let io_fill_cqe_aux() post 16B cqes for CQE32 rings, neither the
kernel nor the userspace expect this to happen.

Fixes: 76c68fbf1a1f9 ("io_uring: enable CQE32")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 792e9c95d217..5d479428d8e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2518,6 +2518,11 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
+
+		if (ctx->flags & IORING_SETUP_CQE32) {
+			WRITE_ONCE(cqe->big_cqe[0], 0);
+			WRITE_ONCE(cqe->big_cqe[1], 0);
+		}
 		return true;
 	}
 	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-- 
2.36.1

