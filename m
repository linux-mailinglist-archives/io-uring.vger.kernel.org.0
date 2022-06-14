Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F2154B39A
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbiFNOiG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbiFNOiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:02 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7201A07B
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:59 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o8so11589460wro.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Mn1I3qJJuXoCLtaTkB3ey7V/NeeqbASVSbKJNj/gRM=;
        b=F+pm97aEKODJo6Ubmf53UxkCYgv/VcIfdqICviMGdlYJW9qM99sslm2ap4oqqOgGqp
         yHGARi3a9OGS1mMzO1PZXcMGQbQoEpgMNa+4eV5qz4yykNg4D5o/zChsb/26ck/oDbxa
         +1cnjnZyeps6eOEYk/xqOX//lSnAud3T147FINkUE+HycmQ4rR82cX5GQpJWNqLIm8lo
         4f03daRuhnTv4kFvdn5O2GVV8vkKmAcvbnhfMKDDBeAi6mMtR6pMzoWQIEgD7au9nXjF
         JHkbE8NoYjXw+q7NmS/7dJduqvFWAAQA1wkuIwUkneOBiUTQsRON3y605P7QBpzdglw/
         aBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Mn1I3qJJuXoCLtaTkB3ey7V/NeeqbASVSbKJNj/gRM=;
        b=f8Z02ja9RBJ4Jk/4DeAH+V3diFXi3BPRq3/Pux4faak9Y8kSRGK0HAk6yLTtb4zHqr
         nY/TasBAhbv5zrYt8CNyjcpTbMBALjiIOd63wijE+bO919c/nl8PKPOTBCY/JXBCG0vk
         tK9ZR6E621IP2WJFT5Gmr65Wk9sWXJ01ZNmXA6GLrU2mo4hJScA3NF5S7nRo2aH53S8S
         SBpoS1aGRmHZzn65p3tpBgo/QZuKTdJkk5VgchTBy90n8uFtrQPohVxAec7cQMyjqgif
         JJnCAW5wCoPc8uAB8lIJ6sFVt3wlzf3z/ujg4L3IOvJut0eVxDQQgwqIO9Dwo/JFrCjq
         0dRQ==
X-Gm-Message-State: AJIora8ArKIm/KTihumAFj3CsBK7o6UxzWhc6nZj8qt/Ism6bxMLKJPg
        XEDqCZ/TjrJeocSBi46lSr0+L/Q7Ik6Mpg==
X-Google-Smtp-Source: AGRyM1v3rBbAIZKXDHRI2jy97uiuzYTcsASNuSuQnQ9X0rDtPGnBBUz1XxxM0WZk2e4/sLnPKtHa8w==
X-Received: by 2002:a05:6000:1812:b0:210:2eb1:4606 with SMTP id m18-20020a056000181200b002102eb14606mr5410900wrh.593.1655217478812;
        Tue, 14 Jun 2022 07:37:58 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 17/25] io_uring: clean up io_try_cancel
Date:   Tue, 14 Jun 2022 15:37:07 +0100
Message-Id: <5b54a27b6b943a63dabde902ddaca7c6c812d036.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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
index 6f2888388a40..a253e2ad22eb 100644
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

