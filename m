Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559B24D38DF
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 19:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiCISeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 13:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiCISeH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 13:34:07 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AC2580C5
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 10:33:08 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id c23so3788284ioi.4
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 10:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tLG0fLRuy1Vrw8w/3zikJqXV43mdiEIVYoFzRXM5t7c=;
        b=ZzYe0uN9xM+4Fe/iOsJmsK8TAETqUKJYa34Crbntek8GPcVak/or7hq7kPpMgz624y
         1Hi45iipYVdrg0nmb+OILq/Fb5bj8cylCJSef/ZdN8PfYMRhqKkrEDJiJ/oKixMyBini
         GB7B0h73JANOR0G2n007k8SflLTLS+ulCtyDE/RD/ZVk3FD4hRrrOqACaEk5kaXfDtH+
         7ev3m9w904l6PDI+H05IkFBRCrRgU6UZ+EH008Cr+WeHETyDfqRZrEMa5vtfI5XGhE3f
         sPmMbdM++Z4WEux0db0NfWh3YEZjTOD08TQ9D7E3p5Fg42PNweS6ueGfYY3qjfL6yFwM
         OeVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tLG0fLRuy1Vrw8w/3zikJqXV43mdiEIVYoFzRXM5t7c=;
        b=eb4lshn80Y4ouSeN2aN7nkmwQyRVw6mSp0W37Yf/96HF9nTTDaTwD0FGf7N7vndIK5
         6Sb3kGag25rN2BsPxIi1UdQt+7keHXm+Lengy2mlj4vWWGFmwst9BvmBTmfdWzh/yfKl
         VMNKjMZQH9kMSJLlsF+a2x0YRXmGxDFM1orCY57cCHa/yrZrZSNmCtXfBUSEhGHasPTv
         U8TpJSrveo3HaQ+LmPmOrPhU0KxCzHXpais5AakcxUN6sDnPQFOSBOFdCfwlDeTR0x2k
         JfqjW/3ISNIm2SkZM+Uz02kD4K3Ukcg/bj963CbZIKZ+v2/nnOtWUor7JqQN2q/xaupt
         PXDA==
X-Gm-Message-State: AOAM5330r5Z9FpKUAiecxf7z8/Ad/qjWISfb/PcXGdeeQ3Go2sJBvusf
        fFoE4SXicuKsziSYwvgSRFGigyI4ZozEWFOR
X-Google-Smtp-Source: ABdhPJwrrGeAtee38Um6Ecs9bJZR9XrtYD+GX/IUsznDovDHT8YO1URjrRIgAdWk1JyHVwIYdI2gwg==
X-Received: by 2002:a5d:85d2:0:b0:5ed:a17c:a25c with SMTP id e18-20020a5d85d2000000b005eda17ca25cmr744201ios.85.1646850787626;
        Wed, 09 Mar 2022 10:33:07 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j9-20020a056e02154900b002c5f02e6eddsm1524094ilu.76.2022.03.09.10.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:33:06 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: use unlocked xarray helpers
Date:   Wed,  9 Mar 2022 11:32:59 -0700
Message-Id: <20220309183259.135541-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309183259.135541-1-axboe@kernel.dk>
References: <20220309183259.135541-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring provides its own locking for the xarray manipulations, so use
the helpers that bypass the xarray internal locking.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fa637e00062d..2f3aedbffd24 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1355,7 +1355,7 @@ static void io_kbuf_recycle(struct io_kiocb *req)
 		int ret;
 
 		/* if we fail, just leave buffer attached */
-		ret = xa_insert(&ctx->io_buffers, buf->bgid, buf, GFP_KERNEL);
+		ret = __xa_insert(&ctx->io_buffers, buf->bgid, buf, GFP_KERNEL);
 		if (unlikely(ret < 0))
 			return;
 	}
@@ -3330,7 +3330,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 			list_del(&kbuf->list);
 		} else {
 			kbuf = head;
-			xa_erase(&req->ctx->io_buffers, bgid);
+			__xa_erase(&req->ctx->io_buffers, bgid);
 		}
 		if (*len > kbuf->len)
 			*len = kbuf->len;
@@ -4594,7 +4594,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 		cond_resched();
 	}
 	i++;
-	xa_erase(&ctx->io_buffers, bgid);
+	__xa_erase(&ctx->io_buffers, bgid);
 
 	return i;
 }
@@ -4749,7 +4749,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = io_add_buffers(ctx, p, &head);
 	if (ret >= 0 && !list) {
-		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
+		ret = __xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
 		if (ret < 0)
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
 	}
-- 
2.34.1

