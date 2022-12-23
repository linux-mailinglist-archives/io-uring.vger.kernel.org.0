Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2C165510E
	for <lists+io-uring@lfdr.de>; Fri, 23 Dec 2022 14:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbiLWNm5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Dec 2022 08:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiLWNm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Dec 2022 08:42:56 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224FF379FB
        for <io-uring@vger.kernel.org>; Fri, 23 Dec 2022 05:42:55 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r18so3333048pgr.12
        for <io-uring@vger.kernel.org>; Fri, 23 Dec 2022 05:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqH11oxwcAtHp0fSh0+KV/J9fhDRJbn1QFrRLAIa+lg=;
        b=V8kTSCGWVM/FmG2kjN0bUh6UZ4jQSyYtOmHrtNVwpzZHewkg/H3aMCgQTbQfYu1rD2
         /lc7/syrP/gXsaPPqkndy2o09iFIJKI00jdGK/h0ecA0ArzN/jI9hK18/mWxiCW4aP6b
         t94YsPzIs0z4BX2XcUCRr6mfvALfsS6MxkocdOxZM/cN0ln4NCVQjLh8E0OR7sFml93F
         aSe6Yll9J7qgTqncG4CFUc10FyyJccwNiQBHkNpXCNVEqEk4z5Ta+C2aEfX+gEm4fVBr
         jy/Dai23wmsnYVEXD8iC2Zf/6g4JWrRD1y6Ug737gCkZXxAxnaOZXNBEvOxru2i/huTa
         /Nrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jqH11oxwcAtHp0fSh0+KV/J9fhDRJbn1QFrRLAIa+lg=;
        b=OcO7mFk5mHXgxM7EbEYrPnBEtL7VfTXTs7MZboa2rNbMqxXaH44NvscaVJc62DYjFX
         IuLIVKa8bSpKqUvqQ0s7k7qAu3Bq59AlqFRl90gFg6eShiJSpfYQRDA3Ye3nWBEUg6yP
         mgH1eJQOKsJzppxE4DLhwURTD5FWXifVJhX3Rqu40Cn22yqnqnul2slGDyI9gY5gwBZy
         FiBbEUAvGJahTVy1+nMo3Cobot/eDuDGsPZnmwku0/OdNYj0cfDQbPdyXYoEKMaImJKj
         rz3m9C/orwZgSC6sUCwJydqad9sZrphvpYpyDOZHy7y3VqGfhHH2DrKCcWzuK/WHw1+T
         Am0w==
X-Gm-Message-State: AFqh2ko6J2AZ8fyUzZ4VvnCBZttW0HJG4Ta5lELBGKJ/4Pyqx4v4noa1
        zoJLFufqYD2oGFw8Kmgt9EMb/lzNhn+4V8VK
X-Google-Smtp-Source: AMrXdXsfp1Nx3aclaTccj9jGWsibzpb4KjL7TIW57G0mDBsm0YrNtxXqvkJhXsr0aEy9QSyD2H5DTQ==
X-Received: by 2002:a05:6a00:781:b0:57f:d5d1:41d0 with SMTP id g1-20020a056a00078100b0057fd5d141d0mr2412091pfu.3.1671802974163;
        Fri, 23 Dec 2022 05:42:54 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f186-20020a6251c3000000b0056c3a0dc65fsm2578702pfb.71.2022.12.23.05.42.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 05:42:52 -0800 (PST)
Message-ID: <42da41ad-fe5d-561d-57f2-d747382e3ce6@kernel.dk>
Date:   Fri, 23 Dec 2022 06:42:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: check for valid register opcode earlier
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

We only check the register opcode value inside the restricted ring
section, move it into the main io_uring_register() function instead
and check it up front.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Should not really matter in practice, but doing backports of changes
meant I hit test/sync-cancel.t waiting until interrupted on an older
kernel. The reason is it arms a poll request and then cancels, but
because we only check for validity later, we end up attempting to
quiesce the ring (as the opcode is unknown). This won't work on that
test case, as it knowingly arms a request for cancelation that doesn't
trigger on its own.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ac5d39eeb3d1..58ac13b69dc8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4020,8 +4020,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -EEXIST;
 
 	if (ctx->restricted) {
-		if (opcode >= IORING_REGISTER_LAST)
-			return -EINVAL;
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
@@ -4177,6 +4175,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	long ret = -EBADF;
 	struct fd f;
 
+	if (opcode >= IORING_REGISTER_LAST)
+		return -EINVAL;
+
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;

-- 
Jens Axboe

