Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9159356AF05
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 01:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbiGGXdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 19:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbiGGXdA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 19:33:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DA21D339
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 16:33:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 5so9094008plk.9
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 16:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=OxCwpw5YZqk+e6xDy+BNGmmQ5BJ0BksV6JcWtUmlTQw=;
        b=ga+jnuUsPZrvWbKcE035xuM4lnAWLDGVVcZJJo/cl+l7MPsjsCqrckA3d9kLJIDZ+Q
         NV/a6B3c7DfW6KHLrB2k6+v0VnFaW9sRC5obTSQ9LqQBqKgtMliffeux0JWY4snLpPhQ
         PPJF+GbKE0oZTb/knl4lwTsA+NqzpB+krrgku8HB2xt8W2LjBmF5KXAPpxwqA8+AuTXC
         v8awGfBbA4FkLIPrJ+gAl0jwHdlLvcwvvm/dvh5Y5xCMN/U2HSscRitNL9N6m5H70IWE
         OAPwHDm7r2gVH/mbhpzo0f9VKgtuRD2LT6ceVaJjvhfCDbyOMBSNOSk3TsS4OO0s9+pX
         NLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OxCwpw5YZqk+e6xDy+BNGmmQ5BJ0BksV6JcWtUmlTQw=;
        b=17Xu4Fza0FTEfB5Nmu16QGlJR29VXfoZyPmGIWJzVKTAy5RptA/JXEeGT5T1txkbpv
         HsbM5iYJh6Zpl2ho6BhCFBAJaJWLWT5jEOqc3RjV1vULUB0vmfeNg0kec7uW0JtorhAq
         itPPwf8SK9E7tADPMjSbE65fF8BppB7Gc/O6dhiAp/s5JtPOqxT3uzixAB1mtdMudRZi
         GcNExYb6eLs5a/o5zTU74IgZdmYGjWeCbd+Az9mehOA0qAS1t3lMohCNJ/SoicbmBuuk
         viyyNRsqxmvWJyGSWKNRuIKZSzg7XEMYRIn6PDjjWR6sOOqBtQr2xNnn4R6M/LkCDaUl
         XD/Q==
X-Gm-Message-State: AJIora9N3lXQ+iUb4YiTPzMhjsLZioz0OcubrSzlHHn8+E35BnNDLDUs
        xX+9kyhyApE88aZQTNar+9ivmQ==
X-Google-Smtp-Source: AGRyM1s4csEPIjEHsi/WlBCkMZR5RKxbadf+imfXEv4I5JYcxTv2ZnmmAI8eF8zeoWiI+x6T0DNVIA==
X-Received: by 2002:a17:90b:292:b0:1ef:a490:3480 with SMTP id az18-20020a17090b029200b001efa4903480mr374416pjb.219.1657236779499;
        Thu, 07 Jul 2022 16:32:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bj28-20020a056a00319c00b0051bc36b7995sm27097218pfb.62.2022.07.07.16.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 16:32:59 -0700 (PDT)
Message-ID: <7b6bb01e-761e-4b72-e06a-566628bfdab3@kernel.dk>
Date:   Thu, 7 Jul 2022 17:32:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.19 1/1] io_uring: explicit sqe padding for ioctl
 commands
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <e6b95a05e970af79000435166185e85b196b2ba2.1657202417.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e6b95a05e970af79000435166185e85b196b2ba2.1657202417.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/22 8:00 AM, Pavel Begunkov wrote:
> 32 bit sqe->cmd_op is an union with 64 bit values. It's always a good
> idea to do padding explicitly. Also zero check it in prep, so it can be
> used in the future if needed without compatibility concerns.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c                 | 2 +-
>  include/uapi/linux/io_uring.h | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0d491ad15b66..3b5e798524e5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5066,7 +5066,7 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
>  {
>  	struct io_uring_cmd *ioucmd = &req->uring_cmd;
>  
> -	if (sqe->rw_flags)
> +	if (sqe->rw_flags | sqe->__pad1)

Applied, but this changed to a logical OR instead.

-- 
Jens Axboe

