Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5A970B297
	for <lists+io-uring@lfdr.de>; Mon, 22 May 2023 02:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjEVApa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 May 2023 20:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjEVApa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 May 2023 20:45:30 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E00DC
        for <io-uring@vger.kernel.org>; Sun, 21 May 2023 17:45:28 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f42769a0c1so54576545e9.2
        for <io-uring@vger.kernel.org>; Sun, 21 May 2023 17:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684716327; x=1687308327;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q7qqshNgBRTsaBY9NJy3o9d/G8k3e5zBEPDZSN6Rg5E=;
        b=WtLdn4uUgOstT6Nou4AM+W089y2CA1kW9MmiG5KgcPRXIF9vGfVV8sCJ2abOfnFG9i
         xT6xumFxUdZb+ERp0I+wCx4akfV9iL5lvLBiqLjVrCLIaa+fhxwVHc615rg1nyFCQfhG
         rih2IiHVSXuRbFxguG8lDImU2D0Z4kyp1sSLZHX+h2T50F2JwKQdxjCJnCZjKn0nNHNj
         TZT102xcKTBrk6lLdG34SrxwVyOsmDmtvLzXnMOPqURLLeZxJvFSj8UAjRk3MB20YkxM
         IHjJTxEyRArVy922UYW/VFTGIs3VEJgyvLGgRCKx8+NYaob3w/mnNnre61c963DF5IJB
         Py3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684716327; x=1687308327;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q7qqshNgBRTsaBY9NJy3o9d/G8k3e5zBEPDZSN6Rg5E=;
        b=RAjj+0hOPzx1iCY8B7WrHPOw2bnopP3W04dflufYM5qszWYOylBdi404r4CpHz/yBP
         J13xZEnL7q6J9vAhJawHrz9SO8ILUux08WagQnuZA9r92HgrqPAPv99jGUAi2c2QoFX6
         rYVzg5e+qhom2TP9bv67d49TOXNVQm8N8cjerr8w7J79DMCEpGqOaNQaMVaF/4uKDSSY
         TYTgCVCBF5XPXIO66Cf9xUx47sZ+JdDJRT8Sas+6xitz/61e9dpc4tD6bw/GWTJNXEJr
         9dBGCmqfZQj2DsuyYjGoGmuIo2TDalpAcaZ1RRI6u0VbYK72uoo9O4VUXfTppk743yHB
         Q9mQ==
X-Gm-Message-State: AC+VfDyNaB0RQHKtg9VgjtGfVPlbyVKRJv/CKrPM++DEPp/d3St87cOG
        xBtvGS9iMg3eTeIHRdADcPo=
X-Google-Smtp-Source: ACHHUZ7SJyr8KJL2PYnz2qLCVk/CtFAJmQdDBJLWgmP9wRYXRoymhegMk6Dh3xVkutR1kLvpBgM0+g==
X-Received: by 2002:adf:f5d2:0:b0:306:2db9:cc26 with SMTP id k18-20020adff5d2000000b003062db9cc26mr6619982wrp.25.1684716326435;
        Sun, 21 May 2023 17:45:26 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.235.13])
        by smtp.gmail.com with ESMTPSA id f21-20020a1c6a15000000b003f601a31ca2sm3902401wmc.33.2023.05.21.17.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 May 2023 17:45:26 -0700 (PDT)
Message-ID: <4ec09942-2855-8be4-3f51-d1fedea8d2f3@gmail.com>
Date:   Mon, 22 May 2023 01:40:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/1] io_uring: more graceful request alloc OOM
To:     yang lan <lanyang0908@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
 <CAAehj2nmnN98ZYzcFMR0DsKXqEM7L8DH8SM4NusPqzoHu_VNPw@mail.gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAAehj2nmnN98ZYzcFMR0DsKXqEM7L8DH8SM4NusPqzoHu_VNPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/23 10:38, yang lan wrote:
> Hi,
> 
> Thanks for your response.
> 
> But I applied this patch to LTS kernel 5.10.180, it can still trigger this bug.
> 
> --- io_uring/io_uring.c.back    2023-05-20 17:11:25.870550438 +0800
> +++ io_uring/io_uring.c 2023-05-20 16:35:24.265846283 +0800
> @@ -1970,7 +1970,7 @@
> static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
>          __must_hold(&ctx->uring_lock)
>   {
>          struct io_submit_state *state = &ctx->submit_state;
> -       gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
> +       gfp_t gfp = GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY;
>          int ret, i;
> 
>          BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
> 
> The io_uring.c.back is the original file.
> Do I apply this patch wrong?

The patch looks fine. I run a self-written test before
sending with 6.4, worked as expected. I need to run the syz
test, maybe it shifted to another spot, e.g. in provided
buffers.

-- 
Pavel Begunkov
