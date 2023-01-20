Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D483675FFF
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 23:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjATWNW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 17:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjATWNO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 17:13:14 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E929E126E5
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 14:12:52 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b17so6518079pld.7
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 14:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJ/ZYAejmsuy9NlBD0RKS+QYNnPj5RYNWx9hYBN0Vq4=;
        b=ukw3zmekzqlySaSOIkL8ADqnCtSlRYmtadyArvdL2FHtwSUK2ZWWjMescA4fMPcd3c
         2x2nXEvlo/UTjLMYFW3yDeMpt+sPsvn58wwTicXg0+o+V9fLBEd+jROisQdsMSxiQo5I
         I4bQEtwCdoNOZMmfYbJvHmJDx7nXIrJECgR+gY+tepPCqUGjRsu0nS0tuPU2cvFyd2jP
         s8/pVdbyY9beJKnDBqvCyKoUMFiJV4nzG9y/8b4PQARNl29wVcETzN+4SDBvbkPBMhFl
         kYM16KGqG7cX8AHwz+ZhcTVdDTfGRjP+drn4alpj0brtrmvPEvnvxpwQ+giUnSa83g4P
         bI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PJ/ZYAejmsuy9NlBD0RKS+QYNnPj5RYNWx9hYBN0Vq4=;
        b=h6jYOQYnmxVlnzc2wrSb7DxLlYbkD4+ADrtmE4V4p5unNfx0g2QMbFjb9KYai9jwyt
         SycbfCf11biZbrj2GJFQQxHEBeAZEA+cGHwrVdccrdmLEHM2bXzCPpqdt20ZE3unOFCj
         AKieFeK5f5Jc642bfXTqkXMP07Ii12tsYrYKtJezoPaFN3hk7xmhOlfTVTjbG1xVTuD9
         TZIy+9T9Qu90TZzqbSEG0aD7myTkzl8L2xIYzOjJT9NIWgfom9A5ZLrM0832dPlmujfr
         Rtm4TRG/I2KVG1SQKfiBknf7WtOIfqnnmxH0MjGHNQL2OANB9mdF2G81Dm1q4Ji2gKx2
         dj3w==
X-Gm-Message-State: AFqh2kprli+htNxDmiiBjOTXloOWcFo7A53AUHkNz9Cv+gVtFWiN9my6
        FjaqXTgSkntFL4RRU8yIB4fcy3hfxkp60sH0
X-Google-Smtp-Source: AMrXdXsx43sSKGhNW1duSOOIka1gRYBe2ZbsNdmPz4kw6JbpuuESLHy8mAY1tu/yzH4HVNu1WKxAfQ==
X-Received: by 2002:a17:902:8f85:b0:193:2a8c:28c7 with SMTP id z5-20020a1709028f8500b001932a8c28c7mr4034294plo.5.1674252771847;
        Fri, 20 Jan 2023 14:12:51 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902b94500b001949ae8c275sm9525616pls.141.2023.01.20.14.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 14:12:51 -0800 (PST)
Message-ID: <8997c26b-c498-166d-d130-2caca08a3abb@kernel.dk>
Date:   Fri, 20 Jan 2023 15:12:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: don't reissue in case of poll race on
 multishot request
Cc:     Olivier Langlois <olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit fixed a poll race that can occur, but it's only
applicable for multishot requests. For a multishot request, we can safely
ignore a spurious wakeup, as we never leave the waitqueue to begin with.

A blunt reissue of a multishot armed request can cause us to leak a
buffer, if they are ring provided. While this seems like a bug in itself,
it's not really defined behavior to reissue a multishot request directly.
It's less efficient to do so as well, and not required to rearm anything
like it is for singleshot poll requests.
 
Cc: stable@vger.kernel.org
Fixes: 6e5aedb9324a ("io_uring/poll: attempt request issue after racy poll wakeup")
Reported-and-tested-by: Olivier Langlois <olivier@trillion01.com>
Link: https://github.com/axboe/liburing/issues/778
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 32e5fc8365e6..2ac1366adbd7 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -283,8 +283,12 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 			 * to the waitqueue, so if we get nothing back, we
 			 * should be safe and attempt a reissue.
 			 */
-			if (unlikely(!req->cqe.res))
+			if (unlikely(!req->cqe.res)) {
+				/* Multishot armed need not reissue */
+				if (!(req->apoll_events & EPOLLONESHOT))
+					continue;
 				return IOU_POLL_REISSUE;
+			}
 		}
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;

-- 
Jens Axboe

