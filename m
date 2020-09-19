Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2B5270F00
	for <lists+io-uring@lfdr.de>; Sat, 19 Sep 2020 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgISP36 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Sep 2020 11:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgISP36 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Sep 2020 11:29:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1013DC0613CE
        for <io-uring@vger.kernel.org>; Sat, 19 Sep 2020 08:29:58 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a17so8463623wrn.6
        for <io-uring@vger.kernel.org>; Sat, 19 Sep 2020 08:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5X5nyZvXK3GEUdy/Y028eWa0ini8dKW39VOv2RN8wuM=;
        b=g3yGlPNEKF+iTAzOsbvf870Bc1RnGF/etpyXHJlWjVjy/v1VufHcLc4WDZVOiIesFv
         tkvCiLEZtAAw5oJ2PMX9gcWnGF3E94qQkF8VgPgM/vgVLDhbd4lCwStL5DoDXyBjwUD+
         u0u46pR6U8UaJ6P02ueKlPc4iG3FXuOmxdwOlB0Q/r1sj2hRUV1DSde+HSqMyc8MzrcT
         su/lbpxzJOyWONR20HAVG5EIJp96JVGCvyHHcsM2P0mPPKPp3UCniGpdZ/aKtnX+jr/+
         4zUk33Cf6nEG01VVwX7nFufuyIhrX2WNnigGFPZyWUy01OytLN3hme9k8PhGFSQ9TlpM
         URng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5X5nyZvXK3GEUdy/Y028eWa0ini8dKW39VOv2RN8wuM=;
        b=dtM8pFrucHKpxADh6W/nIpHTq9Uz45FW3hZSlKTuNuKCDhOyty17G1NrGeBddDJKez
         bv4Esv2jtEYxZquX/fAkSqW90Q2+UU6XxXz1MaFRnn/a23TGQT9GfYIBG+cYy7X36/KW
         +OJC2WqzDGZYhb94R5fPECSPGNesenyZG7zO5j/kNFX9ok9rc2s2Ajs8bxMcWR3tANB2
         AbTPDOPN9dTj9GJ5cN76z3CzRob4smH4KyXzA0k5UoSEMPL8V/ggVDAL7hrWJXP+e/pd
         wzv8vdDjl5wcTyzAoIjqVBIvyGQjucLC4YT2A00lxf2RjnXaFkzKMUKaP188PoKbwOf7
         imUQ==
X-Gm-Message-State: AOAM532HYIQFqVftNS6M+tkmdn9hFBydfQMZozvg86mnB0LDCA2OA04/
        Jqf2qgC/f9/YrQEdVTPumpnQ4DaTOcs=
X-Google-Smtp-Source: ABdhPJwxoT/7Q3RNbWBmi1eBLZqY5SvF0/8Hm1ttMHD5Sr1Bif66jbS8n/4kXACaGd4PvtEtykxYoA==
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr45180093wrj.92.1600529396468;
        Sat, 19 Sep 2020 08:29:56 -0700 (PDT)
Received: from [192.168.43.240] ([5.100.192.109])
        by smtp.gmail.com with ESMTPSA id h186sm11117428wmf.24.2020.09.19.08.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 08:29:55 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200914162555.1502094-1-axboe@kernel.dk>
 <20200914162555.1502094-2-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/5] io_uring: grab any needed state during defer prep
Message-ID: <77283ddd-77d9-41e1-31d2-2b9734ee2388@gmail.com>
Date:   Sat, 19 Sep 2020 18:27:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200914162555.1502094-2-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/09/2020 19:25, Jens Axboe wrote:
> Always grab work environment for deferred links. The assumption that we
> will be running it always from the task in question is false, as exiting
> tasks may mean that we're deferring this one to a thread helper. And at
> that point it's too late to grab the work environment.

That's a shame. Do you mean that's from lines like below?

int io_async_buf_func()
{
    ...
    if (!io_req_task_work_add()) {
        ...
        tsk = io_wq_get_task(req->ctx->io_wq);
        task_work_add(tsk, &req->task_work, 0);
    }
}

It looks like failing such requests would be a better option.
io_uring_flush() would want them killed for PF_EXITING processes anyway.

> 
> Fixes: debb85f496c9 ("io_uring: factor out grab_env() from defer_prep()")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 175fb647d099..be9d628e7854 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5449,6 +5449,8 @@ static int io_req_defer_prep(struct io_kiocb *req,
>  	if (unlikely(ret))
>  		return ret;
>  
> +	io_prep_async_work(req);
> +
>  	switch (req->opcode) {
>  	case IORING_OP_NOP:
>  		break;
> 

-- 
Pavel Begunkov
