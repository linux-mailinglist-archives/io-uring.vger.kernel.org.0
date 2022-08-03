Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99E588B84
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 13:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiHCLrd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 07:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbiHCLrc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 07:47:32 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E353A6477
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 04:47:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b96so10797161edf.0
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 04:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Z29oR9kKGwNK2dm8R6KRc6GsMuj3A4rlzONIH6iD7Zo=;
        b=LMRzLIgo5WIX5dwaKjBdxDu2Ua01fSOtcuz/WYItsFPE+cvk5+cmggPfRAVYM8iD8r
         lqL3CVhFC6fDUQehxghHzFMhK9pSNNaxARFCMlGfxWNgEm9QsqW4XmFS80kyY+m/fJaD
         C2xAJ3LNsHv8CNqZODubE2RTW/FgGxaCc2jTL+C6wlnK/xvFxhCwLZnigkdR58xS4bzW
         8RiAyrof3xajB5tQi/aOrIGoMFxNzNEDIpmyFtLj8lTkSCWvF6wUR0i+cpb8d6gkIwQY
         neM/E/3OrTSCBZ9f9boPw7f6Mac/9rhZ2/6g7CIrwlzvqr84o5fxIwdeQENg1QcPdOVn
         F7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Z29oR9kKGwNK2dm8R6KRc6GsMuj3A4rlzONIH6iD7Zo=;
        b=ZZkt3fT5rBX8gc/NAH/XpLcc4EXrZV3SLec9L6Goxx31NXYuab0wjuLE6pHUsnd7+X
         pn0waoZmoYDUF0mJlohoj9HevzRko3pT4WwHeOWgcsBxL0iE18GiA/q+lBqMMcvDb7Fl
         mQAo0x3qGviWnW9Xxwf3swTq03mLTagfsRudEunDEt8+Y3NKDIOk8qllgOa074TVi6ez
         KODXNSln3oiE8A7gkA55UkMcijv5bT9ft3aJGX+xZmcrPbn2qwWmGy//u32Z+F0nIu3M
         9glXmc0So3lsvXEC5Cy/uII3gaV4bfl7rmfHSy466j1wCATNV1IhLFn5DB+wHFPEol7K
         OXow==
X-Gm-Message-State: AJIora9UxG/XkZlzpDzPjabV1T803xu8nh8Fx6iZmzVitBHDV7DBBpPW
        B4ttSL4pdzssj7JaXT//v2k=
X-Google-Smtp-Source: AGRyM1s3ydBFgm6cgLBnvlODqYyPATccnKODUzZ12Lk1PmoIeMuAHc9bOMTnPNf7DVPRgHDSg+C/5w==
X-Received: by 2002:a50:fd83:0:b0:43c:bca0:bdd1 with SMTP id o3-20020a50fd83000000b0043cbca0bdd1mr24959441edt.360.1659527250395;
        Wed, 03 Aug 2022 04:47:30 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id f14-20020a17090631ce00b006f3ef214daesm7188850ejf.20.2022.08.03.04.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 04:47:29 -0700 (PDT)
Message-ID: <48b58f2b-014c-cbc6-36c3-29be42040fa0@gmail.com>
Date:   Wed, 3 Aug 2022 12:40:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] io_uring: pass correct parameters to io_req_set_res
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <20220803110938.1564772-1-ming.lei@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220803110938.1564772-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/22 12:09, Ming Lei wrote:
> The two parameters of 'res' and 'cflags' are swapped, so fix it.
> Without this fix, 'ublk del' hangs forever.

Looks good, but the "Fixes" tag is not right

Fixes: de23077eda61f ("io_uring: set completion results upfront")


> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Fixes: 27a9d66fec77 ("io_uring: kill extra io_uring_types.h includes")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   io_uring/uring_cmd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 0a421ed51e7e..849d9708d612 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -46,7 +46,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
>   	if (ret < 0)
>   		req_set_fail(req);
>   
> -	io_req_set_res(req, 0, ret);
> +	io_req_set_res(req, ret, 0);
>   	if (req->ctx->flags & IORING_SETUP_CQE32)
>   		io_req_set_cqe32_extra(req, res2, 0);
>   	__io_req_complete(req, 0);

-- 
Pavel Begunkov
