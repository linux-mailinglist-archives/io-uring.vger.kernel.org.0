Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB3C241D9C
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 17:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgHKPw6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 11:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgHKPw6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 11:52:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5490EC06174A
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 08:52:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o5so6917982pgb.2
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 08:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nLUZBayYSK4L719BduYVhQbnotptEKyigz6M5kZff28=;
        b=tyTePX45D7Uk2OekEOcAeIEUyMKFBZGvVzKsS03IIURBuiMsQJILpNw9ZO0s6FmDB1
         JiFnUQfoEssvee8ysaQg5wPbwlBt0+Lt4A3uvjv5bYYBDrlNJj9qgEcWCEHZnCFmPqQT
         6h4SvEoTLfH73bUNSYsbZuw4SipqUhx70HL/RZjCTF1XSqSIMHqzRwd3juVUNtN8MIEe
         fFsk4W7tjt/REtCslBWBPo2UImc05OOntHJmi9dVMv5MKt15EQ+ZnauP+3zLRStkghke
         pFMb+UOU1gx5HI+9TlrHiYCt5fwWWtGnR5osObJZ1POjKKf8HflFIolTjHsIrUsqDrsL
         oZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nLUZBayYSK4L719BduYVhQbnotptEKyigz6M5kZff28=;
        b=TgUmSfO3T+cJ3TExdRVFuIV9Irmzk4m35zPI+dnal38f9W8BR2XdqHfmglgHGIAQGt
         mCvmnHHCUJQhJb9qMLKq6P71ps8TsrTT/1sbHBb/FrZHLuuutzTENOgboMngSUzjjzr8
         ew/GOalM1rvNJdSexmNpb9mOpRKn5JICBnaciIGwaqH7A0oOKysref7Y+0DpsVkGxcXz
         UhszbjkCLxmurCvMps/LZ+Qh199N6qIXNBscjLv5Jk4oxxQIz0ejKb7jRwy4yrX5DYMr
         jEamr+zZXiqrUrlv2fjr0SiOzdmZQ2cet5Nap/b5SmX0pOk31Chpt2+0KdXoGrzPikJw
         f2Jg==
X-Gm-Message-State: AOAM532VJzx4BsRi1n/n5wt+e+dTQ5TDa0yc24XXS7jFzD+dk++QZ//8
        cXeTpiKeScmFqLfJTvob9L+6BZwqB4w=
X-Google-Smtp-Source: ABdhPJzFuHYxK2rhZjCuYHAR1ZZbLXRshdH4CG1E6IHJANUShTvwEN05bhbmSSGTKAtbjH68rDa3Hg==
X-Received: by 2002:a62:7785:: with SMTP id s127mr6659759pfc.196.1597161177618;
        Tue, 11 Aug 2020 08:52:57 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x14sm7308720pfj.157.2020.08.11.08.52.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 08:52:57 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fail poll arm on queue proc failure
Message-ID: <6d9ed36f-c55a-9907-179d-3b1b82b56e90@kernel.dk>
Date:   Tue, 11 Aug 2020 09:52:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Check the ipt.error value, it must have been either cleared to zero or
set to another error than the default -EINVAL if we don't go through the
waitqueue proc addition. Just give up on poll at that point and return
failure, this will fallback to async work.

io_poll_add() doesn't suffer from this failure case, as it returns the
error value directly.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: syzbot+a730016dc0bdce4f6ff5@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 99582cf5106b..8a2afd8c33c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4883,7 +4883,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
-	if (ret) {
+	if (ret || ipt.error) {
 		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
 		kfree(apoll->double_poll);
-- 
Jens Axboe

