Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D979251AE7
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgHYOeC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 10:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgHYOd7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 10:33:59 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67ABC061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 07:33:57 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i10so7078896iow.3
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 07:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YgFgfzphgvms2dZS2+jVYy7+WnhILKweffObRGIKOSk=;
        b=H9wa6TvBuytvflGfuBvt2Znf4t1iTnperOKwpMxpJOmcfOKSOqkeGKv87kaqS7hsb0
         LPvxPGbB0Q5rzMSVPCTqz9bDttZYM/KJ4BSmDTa9q3bIIgGamd07r+8O06McXZ67roRh
         nbG9UX/ntkOKTQ9EXdUdSvc9m6zbCCZmofz/zdGgl0a1Jpc7WH2aKA2js/w/rIVWZKFp
         B2+LiEcNbDZZWuLxwjjVxJLb56ka6zpaGAhSSbR9NlFtB0TeQHXz3Pk1ykWoBR4ai8Mk
         P7fjMYx34ruIQdiSwYHXvgrB8D8XP7zPL8HKVFmeqdDLr8H6qC+vzo5LIVgotYht18N5
         iLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YgFgfzphgvms2dZS2+jVYy7+WnhILKweffObRGIKOSk=;
        b=LGGFQ0cp70MQ5Wf/27wnzHwBQV0/xWUKM3tVPdlCApvtB38LQEsb2ztHgL8qLRuKaA
         wYTsjtBmp7P5rZHRIVeY4ECWhVrsvUlaLU52jxaGv6Ua+3RR/boNnnDMfUoCanD+CRXt
         g9BEt0HparJjgZEsTAWhJwN/4Ub3nKwGh/cRs6fsSoypRc4k0qsd4SqWlGpogx1InVYn
         BwzgoXk0/CPPfZuaNEZgBYQSu3WcH+J+wAc62vn+cZIfLE43v3ABnElSVEaWCNZFDuFS
         h2GWndpQa6fac8pPDVibCwMrtADbi3lAYx4lGT8Xh7ucxB6ZzsTsEMS2Xe3UbCO4dV8d
         GOyA==
X-Gm-Message-State: AOAM530rGT68p2qo5oIGknGgQnPra5Q4VfgX9WhHR+qnZ/QnHE99p63k
        WegxC5dOlBWvgDuiop0q/YOLVTVW2E/BuggH
X-Google-Smtp-Source: ABdhPJwkhX3v7MONRujtwuew4oVEQhfi/7hgsCPpTaBXMe8LqFm8DSjbBgwF9ZAmU9BW6B4ifrDCMQ==
X-Received: by 2002:a5d:954f:: with SMTP id a15mr9387362ios.53.1598366036662;
        Tue, 25 Aug 2020 07:33:56 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c4sm8459609ioi.44.2020.08.25.07.33.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 07:33:55 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix unbalanced sqo_mm accounting
Message-ID: <4e68f238-8814-f73f-df7c-8dae9fd6de00@kernel.dk>
Date:   Tue, 25 Aug 2020 08:33:54 -0600
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

We do the initial accounting of locked_vm and pinned_vm before we have
setup ctx->sqo_mm, which means we can end up having not accounted the
memory at setup time, but still decrement it when we exit.

Setup ctx->sqo_mm earlier in io_uring_create(), before we do the first
accounting it of.

Fixes: f74441e6311a ("io_uring: account locked memory before potential error case")
Reported-by: Niklas Schnelle <schnelle@linux.ibm.com>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e030b33fa53e..384df86dfc69 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7447,9 +7447,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 {
 	int ret;
 
-	mmgrab(current->mm);
-	ctx->sqo_mm = current->mm;
-
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN))
@@ -7494,10 +7491,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	return 0;
 err:
 	io_finish_async(ctx);
-	if (ctx->sqo_mm) {
-		mmdrop(ctx->sqo_mm);
-		ctx->sqo_mm = NULL;
-	}
 	return ret;
 }
 
@@ -8547,6 +8540,9 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 
+	mmgrab(current->mm);
+	ctx->sqo_mm = current->mm;
+
 	/*
 	 * Account memory _before_ installing the file descriptor. Once
 	 * the descriptor is installed, it can get closed at any time. Also

-- 
Jens Axboe

