Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9974FE378
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355985AbiDLONG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238699AbiDLONA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:13:00 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA1B1CFFA
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:42 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id q20so12039203wmq.1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qWT2YJnKiJM86P5OCPSBlNCXYdLMBebqidYLzfaI37I=;
        b=im4sBEjD0WSG2Mu/GtN25Q21d7EJjDErTFdG8V4n13w3/3XvTVUgozIEfLvgYMzoyK
         Yjv0TUSloU6MXsZ2J1DH22dFi7hGFnyMLAJoa9Oz490MR+YreXi1OUOQruSi4ySnobLo
         EhOkW1V2qVnCBTZqloqaLsnsxviY8D5STq60OrKfQ7TLY80S/JXTEKNxJYDzbRbBaMMt
         vcIGkX7VA4FU3uu/OUM4IvgKM5ABMTqVknVQze3n0XKdd5fS7aSozR0JUr9EAQ09YTOb
         iZzfgBRRityMUmT4LI29hQ1kRFjmb39ekboQxCVA5x+0OatOEqe/kG6muu1N1OCYi0K8
         zwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWT2YJnKiJM86P5OCPSBlNCXYdLMBebqidYLzfaI37I=;
        b=L6nr6OPNXL46JHApRTjMzloXH3nhptUVnQYd7hcPVim/s1d3S2BpcIQlUOyslgnWO0
         Do9YTe+uGWxSwSM3T1Zdl82Mg/EW86osc1B4Z1UK0pxJT4IL6mMqWTv4/99FvZ4oPRxJ
         kA4O3RmjjcBSeUk2FX4TnqMoqf10P93+1e3Ke3adxrCqvJUZQ5Gbb/xp/7gohfqKrtgC
         9eAqRTkdeEHb448lFsRdnvCZRL3dirSpz62dHxmS4GoAg1qwpRrtWBEJecQwlp0QIkUr
         Jrg7qv9Mt8tL5HXkJKY0amSp1UHW6GAy8Mjd0rHRRVXe44L6mGOO3ZzvNqMlTOW/9V4S
         +1VA==
X-Gm-Message-State: AOAM531we3Rkp/7iQP2gobsbTvN2UwsnvdsJgEai/PEfzBtJD7HdQ7K7
        8xu3YSA0oxbrjMIiWdro535RzPcplQY=
X-Google-Smtp-Source: ABdhPJykGVzmO4Y8hP3Xm74HuEKolQaJkCOE56mSuuxB+v7TUowjMaYwCquAmeNED1py01DZz+cf4g==
X-Received: by 2002:a1c:e911:0:b0:38e:6c5d:40e5 with SMTP id q17-20020a1ce911000000b0038e6c5d40e5mr4285140wmc.116.1649772640977;
        Tue, 12 Apr 2022 07:10:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 8/9] io_uring: optimise submission left counting
Date:   Tue, 12 Apr 2022 15:09:50 +0100
Message-Id: <807f9a276b54ee8ff4e42e2b78721484f1c71743.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
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

Considering all inlining io_submit_sqe() is huge and usually ends up
calling some other functions.

We decrement @left in io_submit_sqes() just before calling
io_submit_sqe() and use it later after the call. Considering how huge
io_submit_sqe() is, there is not much hope @left will be treated
gracefully by compilers.

Decrement it after the call, not only it's easier on register spilling
and probably saves stack write/read, but also at least for x64 uses
CPU flags set by the dec instead of doing (read/write and tests).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 20eb73d9ae42..b349a3c52354 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7858,17 +7858,17 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 			io_req_add_to_cache(req, ctx);
 			break;
 		}
-		/* will complete beyond this point, count as submitted */
-		left--;
-		if (io_submit_sqe(ctx, req, sqe)) {
-			/*
-			 * Continue submitting even for sqe failure if the
-			 * ring was setup with IORING_SETUP_SUBMIT_ALL
-			 */
-			if (!(ctx->flags & IORING_SETUP_SUBMIT_ALL))
-				break;
+
+		/*
+		 * Continue submitting even for sqe failure if the
+		 * ring was setup with IORING_SETUP_SUBMIT_ALL
+		 */
+		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
+		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
+			left--;
+			break;
 		}
-	} while (left);
+	} while (--left);
 
 	if (unlikely(left)) {
 		ret -= left;
-- 
2.35.1

