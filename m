Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2B152C48C
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 22:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbiERUir (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 16:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242589AbiERUiq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 16:38:46 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B39024AC72
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 13:38:44 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q203so3671852iod.0
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 13:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=N44U/jr4Owm/OHvRAXUxrJ9n49ZgNjSJh7dW2j7jn7I=;
        b=WQbljtnh064yMQIRmTK9tASNrVaiCv6r9DG7Ue9y3rPyJRhAmbxnYYEGk/moU7XCJk
         +/ud4zu78zzCLVv6b3pCtDjE3A/zc/Uo5qZisHWAHoe3Tp0cjdppENS+UgOK8JgcWEvB
         S3WA2gU+JL4/HnS5QhhgerJTgqqJBVX120YQ8dkz68fNTkGig1Hh8pXuWpc4iAFlJnVX
         q4Ep+0UxTma2t1Xf1ZLnbC2tDvyw84mUeaPK6Ivvy23bbjRR3A4Esl4G5F5BlazwxE40
         CUWVYvO71UwkmnXkJQC4AgcyFtP138AFC7WgguHXQFRvr5zYYCqb2l4UxcM3MHoCdwWG
         S2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=N44U/jr4Owm/OHvRAXUxrJ9n49ZgNjSJh7dW2j7jn7I=;
        b=Yo3A5stEKPeH2nbYqV/GhZtQDaVGFCG/e5qS5/NuRZ3g+WycnV9fjUDJbw+mhcLbq6
         8zXEmLbqh6sL6l4nV2f6xwglrlBRFaw9kaS1OMjyfyYA5d8Shk+OxJZ7tCxGhC30Oe6r
         gV7ht7M2FA6X4H3e8a9u/f2aspOmSBNEFQxkdOuZoGLJdVxYqas9Z7yNSpZSfEF3BnXe
         E/MSYqms8gN2PRFZ0Lw2NXUNmYBIit+8m/gC69TEb1YbwIXSn4bSZrWWjstgGPd89LUG
         b/TObJS49Grv43A04ep5M5mLcxSl04LCz4058EWnwzbwSa0oATnkU9g7AZ1VjAvmJ2No
         sGMQ==
X-Gm-Message-State: AOAM532h8PAR8hVU9CI063WUzMVamGaBlTDy9rLnqElVigkv7/2n3Lr5
        7nSVKjDmRZQ/VUytNnpNNZpBID6Jgk8KOg==
X-Google-Smtp-Source: ABdhPJw9XcQgy61xW08DirwsaiA4NAxjVZf5l0qBZV0g9qZRHZnAOvC+w6xUxWfPfGDh6/LW1DZlYg==
X-Received: by 2002:a05:6638:3e0a:b0:32e:2b28:a8f9 with SMTP id co10-20020a0566383e0a00b0032e2b28a8f9mr779150jab.254.1652906323196;
        Wed, 18 May 2022 13:38:43 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i9-20020a926d09000000b002cfbe1981f1sm771558ilc.84.2022.05.18.13.38.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 13:38:42 -0700 (PDT)
Message-ID: <6d49f50d-52ca-a12e-8f7e-99db5b97ff9f@kernel.dk>
Date:   Wed, 18 May 2022 14:38:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: initialize io_buffer_list head when shared ring is
 unregistered
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use ->buf_pages != 0 to tell if this is a shared buffer ring or a
classic provided buffer group. If we unregister the shared ring and
then attempt to use it, buf_pages is zero yet the classic list head
isn't properly initialized. This causes io_buffer_select() to think
that we have classic buffers available, but then we crash when we try
and get one from the list.

Just initialize the list if we unregister a shared buffer ring, leaving
it in a sane state for either re-registration or for attempting to use
it.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a210a2c0429d..23d68f8dfc66 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -12200,6 +12200,9 @@ static int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (bl->bgid >= BGID_ARRAY) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
 		kfree(bl);
+	} else {
+		/* make sure it's seen as empty */
+		INIT_LIST_HEAD(&bl->buf_list);
 	}
 	return 0;
 }

-- 
Jens Axboe

