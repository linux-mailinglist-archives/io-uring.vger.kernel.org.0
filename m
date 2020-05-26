Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9931E2922
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 19:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389243AbgEZRgK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 13:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389220AbgEZRfo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 13:35:44 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C5C03E96E;
        Tue, 26 May 2020 10:35:44 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l27so2607729ejc.1;
        Tue, 26 May 2020 10:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=44M/lrAxl1LLe2QftqBq8tLTI0t8rZO366uKD3inpLs=;
        b=uQnXDtLsn3G1i6JdSMW105s+/Y0LKw23IyaavSfNP84Wh+KOTLQeUqgwdFV2pTLybY
         wUMgMyIF0aJT+/D2g1PQkOhJMk+i7jF75QggLD7Opngyv/RmZkNlQk/MJ+hT8e+sRrgy
         cegTWVSZALylqmKNO4CSaLRR14b3dk+juXxnu8Lb7X7HnWF3y3GW0Gx/W+j51meIRzIA
         35sXa87OgxkJGVpVe4jco7QcexPi80An8CpMaEUrFsXNhmEN6BBUJTghSGlA3snU88ul
         +D+XHE4+rCvvhOnnzM+hFT7Zb0zdtojlNuF5w8Im0gNE5c503/5FZP9lqH/IZZNRsaUn
         0ykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=44M/lrAxl1LLe2QftqBq8tLTI0t8rZO366uKD3inpLs=;
        b=adUqMxkndWQhlWUFeEoEVlSkWJ7AJAwEzRb/7MsiTEVPBDDy4CStHzxfQqdV7y+rhp
         5S5P9ALI63tH4BF4hZgckVud4c/2PwIamz3Sd7ur6NNBpQC/87TAHS3oHplNyUD0J71P
         TQP02b4+7vaAJJIGQoSROg5Qz26nbQkPR+fhM9FluWNEs4LhemQAhKy4B07zViYPqnHE
         K5TWWi0Cj+imdPxR9o/v6NwpLMZjV3OY2n+O3uKQM4gvmm5/rwdYu/rIR/+n0fkdev1G
         Yf0Hdffc7F8Na8GvhsSm7FdcIhfLdPjD2GYBg3zCKtE9nifjmgSUsjyDZSPExRVvze2Q
         jwZg==
X-Gm-Message-State: AOAM530tjjdRPzCtGNxmZx3MD4Xif6xT24x8GjpeK66Ayxxb9YaoIap2
        y9bY5bUY+wxjXRT/Z9NRHak=
X-Google-Smtp-Source: ABdhPJwATgozz3vdxhmnjTNKYmFgR58E3eQTb1NwghWVfY/bNR+aD/m/h7c/+UJB+EEp6etj4JR3IA==
X-Received: by 2002:a17:906:4bc1:: with SMTP id x1mr2020248ejv.13.1590514542829;
        Tue, 26 May 2020 10:35:42 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id bz8sm391326ejc.94.2020.05.26.10.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 10:35:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] io_uring: fix flush req->refs underflow
Date:   Tue, 26 May 2020 20:34:02 +0300
Message-Id: <be790e01cf63bc0d04bc4577e15ef50ea2c3ac53.1590513806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1590513806.git.asml.silence@gmail.com>
References: <cover.1590513806.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_uring_cancel_files(), after refcount_sub_and_test() leaves 0
req->refs, it calls io_put_req(), which would also put a ref. Call
io_free_req() instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf75ac753b9d..42b5603ee410 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7534,7 +7534,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			 * all we had, then we're done with this request.
 			 */
 			if (refcount_sub_and_test(2, &cancel_req->refs)) {
-				io_put_req(cancel_req);
+				io_free_req(cancel_req);
 				finish_wait(&ctx->inflight_wait, &wait);
 				continue;
 			}
-- 
2.24.0

