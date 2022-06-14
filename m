Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814DA54B13D
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiFNMed (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244265AbiFNMeL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:34:11 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1752E4BB8F
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id a10so4563015wmj.5
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d4/MXjfOfkv5/D7WY7pe9UNNIj5LXSJkYJ36ARTYKgw=;
        b=dA4JL5MQqYQDxQ8LNUlsxRKdmWybGFh5ioirlz+CEBN+88glF4wWxUxFKA8DXOCO10
         uEJT/o+W26lKlDD2KWoN2yxqbYWjIEtSG0/zyvEZt+xnIAe07PW85sLFEkOOtLPLe3F9
         4xPGWKR+Z210XpBWoCA5tl2025iiUKOAeQZlaND85GGCmOdGJbudW26lktKhzmeVwxy+
         tJ4uGJOqs/BtXwdGxeJuDv1jH4UjCubm8q4zZySFzrqWL5Sb/X3ty11Szc90J51ztILq
         KeY05SGeYhmlO1zGmdVz3FTsZ4iwp8vXvHhIlpbFfNWgX7/bpc6Go624qCY5B5LKVvIp
         vPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d4/MXjfOfkv5/D7WY7pe9UNNIj5LXSJkYJ36ARTYKgw=;
        b=lMi9cxE5tSmuLoJV7mIMv7dbdTBJyQMmhJa3dZfhOS5cQzsav/b2iuq27c/YPHxSDd
         UZLQQkhZbkMJOTBuGRc1v6cB74W2yIPs1V3vNyG36ZnqKLsBZ2cERzeh11YJTXHpnk2m
         ZeHpK7TTSEVuhCMyDsj2i+LBuYxN1Nqw9t62PHrlG1vrMYUL+beCRjMu21dMF/I+1gNL
         vsVAbsZpOCAqmyOOPAzY1M1lnBwZsCq6swSDsY4A7N+aA5tkXBh6mpsbx7GfrUwI4WJx
         DdQiXzp5W25Ba9l+r05oTqwGBzXoKzZ8NPztw7a2sl6QIWO9MsL3ZikY/jT7lHSAFBjt
         QvcA==
X-Gm-Message-State: AOAM532Tfn7ZFzPYi2yKrYSsf97AVXriqmWE4kYpDXQegGiMmxSx8Y1B
        m/dc0UhdeHTq56QzKJaFE3pl5IGFPw7jMQ==
X-Google-Smtp-Source: ABdhPJwW+H/vzG/Kgi+vOG0+YQRvQeRpXKNvRnm61LMIExt/4Oc/VAHDNYFRcsGUDORY1fmuyCFhTA==
X-Received: by 2002:a05:600c:5021:b0:39c:6571:e0b0 with SMTP id n33-20020a05600c502100b0039c6571e0b0mr3887439wmr.177.1655209856403;
        Tue, 14 Jun 2022 05:30:56 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 17/25] io_uring: clean up io_try_cancel
Date:   Tue, 14 Jun 2022 13:29:55 +0100
Message-Id: <cba104fe32764135805425fbdf025a37dc871756.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

Get rid of an unnecessary extra goto in io_try_cancel() and simplify the
function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/cancel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 54a5e0a86b61..2f157aebd3a0 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -95,12 +95,12 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 
 	ret = io_poll_cancel(ctx, cd);
 	if (ret != -ENOENT)
-		goto out;
+		return ret;
+
 	spin_lock(&ctx->completion_lock);
 	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
 		ret = io_timeout_cancel(ctx, cd);
 	spin_unlock(&ctx->completion_lock);
-out:
 	return ret;
 }
 
-- 
2.36.1

