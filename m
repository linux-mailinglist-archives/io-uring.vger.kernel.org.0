Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE95F63D94E
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiK3PXZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiK3PXY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:24 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAAB52171
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:23 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso1670075wmb.0
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ps+n+jwP2OtqvbExQEi1qZlpRpt6nwJt8sdxryK+02Q=;
        b=GZcylmtvFhBufnMa1VWcvEUz+2D0c3ato8lrhSaxw5+5M/6lClo5UVN8Otoj0iDVaS
         Y0t5E3KGwK1iuqA8vgNfBbb5b4AzJtfufmdC3cgN8oCLxugkYlCCUPYlkrijxdfTkqiu
         NB9A3g5BwLPouxO4IXjYvKKezB7cSS9+ohQu8BbYDYvqP+hnLc0cPVTsgmgGLy8F2w8j
         utuM07HFUaINTNsgmIL/SCIGaozUR4qXrRK/RICCaXYLkeK3VSApjHFfewPXuEx4bDzs
         ViC5blO2SVrt4dkiH3St0Cwc3/4qiwLuZ9u5j6SdIV9vuVr+V2qfWkdDRijZ+YKL81lF
         S9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ps+n+jwP2OtqvbExQEi1qZlpRpt6nwJt8sdxryK+02Q=;
        b=EaK7f0slNkx2rw0myt6kcDwaXZkwrNxNfXo+caOkRTiYP42OYjVj2M4rd0uVkYPktG
         9TWE7UnAD/UAlVsUg7c61I5HV2fgYzU1Dn2qMlFty/f9Ed8KoLvTbT72QqQ0GjLBBHN1
         x387gBuEMUnPXM8XfjQc0w0OVNfOjC5UHPnM+xjZUHass/V/n09hnhRGUW6TTztYpKDs
         KVE5FLlvYDNIjRT0Qu5t5LPh5Y4qMm9NjLEotKgtX912zi6vVWI6dHfE9p3dQZmXLtbw
         2eagWAw248skrnDCGpmA2qN8QI7BURO5w0MlT8x3n1t7yZ4r6VndtAKxBwDYsG9Y0rzO
         qibw==
X-Gm-Message-State: ANoB5pltoJHt9HeZZAdGpgJY+gVtrpYVYJZDUvibhp+iTKSzk0kkvwku
        z4HGS/jCzJj3gD5Bj03vreoU6kjkND8=
X-Google-Smtp-Source: AA0mqf5kH8EJW1iXMYDaRGhf7VtxcUk0wCx6sM5G7oo136RLl+7wMsP6ErVCdVVQzHMnySw0/RV9+w==
X-Received: by 2002:a05:600c:154e:b0:3c7:1422:d56a with SMTP id f14-20020a05600c154e00b003c71422d56amr16355689wmg.107.1669821802124;
        Wed, 30 Nov 2022 07:23:22 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/9] io_uring: kill io_poll_issue's PF_EXITING check
Date:   Wed, 30 Nov 2022 15:21:51 +0000
Message-Id: <2e9dc998dc07507c759a0c9cb5d2fbea0710d58c.1669821213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669821213.git.asml.silence@gmail.com>
References: <cover.1669821213.git.asml.silence@gmail.com>
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

We don't need to worry about checking PF_EXITING in io_poll_issue().
task works using the function should take care of it and never try to
resubmit / retry if the task is dying.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index adecdf65b130..15d285d8ce0f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1808,8 +1808,6 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 int io_poll_issue(struct io_kiocb *req, bool *locked)
 {
 	io_tw_lock(req->ctx, locked);
-	if (unlikely(req->task->flags & PF_EXITING))
-		return -EFAULT;
 	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT|
 				 IO_URING_F_COMPLETE_DEFER);
 }
-- 
2.38.1

