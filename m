Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B90466CB13
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbjAPRKR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbjAPRJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:09:31 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7782CFD8
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:02 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h16so28049536wrz.12
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1T3jBXVzgA/G4SO0KjENeLs4stjTxYEUqvYDC5sW2Hk=;
        b=eY0W7g0S78Uz9jv7mRveVrmKSGy2GX1iN6ABYxdAuEl9m7+UIYGB6aQQ4Vc+hG9t0S
         bpa7uSKzpthBaeWIibnhY84KO/Pm3s0045Y7aAkZ1WrOd13bGCMU2LstVRSd9CDazXdk
         tH6k1AE7Vov/dcMs1AaRq8KWkw4+BBp8hgJAqEx7eMbusjW0NOhW8DD6+cvYqOZEExBq
         hIkXdy6HVG9Zpc/SZV/sURN4r/dN6FqSbc5zYvlG862q2EBSoHM5QPqnptJQNp+7Uqmx
         LEfw3FSlhJwHNeBHeYM2ghKuFK2vz7YfbSun3loPKfO9shYExncmFvzAnWr8euuF6X8S
         h8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1T3jBXVzgA/G4SO0KjENeLs4stjTxYEUqvYDC5sW2Hk=;
        b=GziCNk4IbrO1oacA4OLvkQBxtWgfsoAVQeakcjoSdhbZ5ixNCfMKWqwjlprCY0/qBh
         DqpJDCguYZd4ZuxjpKt3nLIlFHckK1SlcRJqWCAtfJGLP+xDRp3HC3FblSvt1r92uJrt
         kUi6NKyEsciXa4618lFT1OvUQO+hHDOygdoL8AcD2Pf0ClfEEdQAwHH/DF6RHQRupEhJ
         c4Ux5RINbWei8i7V/TWqiyth2bQkXpt3gMAburrB+xwb39h80HEc3q5+wiDxElwTvHOh
         xdcrAmjqUnSAVL7XQ2mAig7gci9TaHxJO4vLRdskA2VB6GfBn3YF1wE/R0EnrWfWi7lR
         g0Jw==
X-Gm-Message-State: AFqh2kpputBxMNQ6GL9NAtVL9s7hRYo6pa+bAFY0QGH/n3a2EH4ExlN1
        qtxS6cVp5P4CSukHriYb/+PR6SWSI4Y=
X-Google-Smtp-Source: AMrXdXt6xute1sGHKSufEBJ4M7G78ZLEvceOYsVc2gTjouudBlLthMpxI417xi7hcbWrrgQZ2OC9dg==
X-Received: by 2002:a05:6000:71d:b0:2bb:f4bf:e758 with SMTP id bs29-20020a056000071d00b002bbf4bfe758mr137731wrb.48.1673887800404;
        Mon, 16 Jan 2023 08:50:00 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d62c7000000b002bbeda3809csm20872372wrv.11.2023.01.16.08.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:50:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/5] io_uring: return back links tw run optimisation
Date:   Mon, 16 Jan 2023 16:48:57 +0000
Message-Id: <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673887636.git.asml.silence@gmail.com>
References: <cover.1673887636.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_submit_flush_completions() may queue new requests for tw execution,
especially true for linked requests. Recheck the tw list for emptiness
after flushing completions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 718f56baecbd..5570422dc2fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1344,8 +1344,11 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 
 	if (!llist_empty(&ctx->work_llist))
 		goto again;
-	if (*locked)
+	if (*locked) {
 		io_submit_flush_completions(ctx);
+		if (!llist_empty(&ctx->work_llist))
+			goto again;
+	}
 	trace_io_uring_local_work_run(ctx, ret, loops);
 	return ret;
 }
-- 
2.38.1

