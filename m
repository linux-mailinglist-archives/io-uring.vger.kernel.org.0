Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5247C771314
	for <lists+io-uring@lfdr.de>; Sun,  6 Aug 2023 02:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjHFA3Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Aug 2023 20:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjHFA3Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Aug 2023 20:29:24 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C05C210B
        for <io-uring@vger.kernel.org>; Sat,  5 Aug 2023 17:29:22 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5643140aa5fso397617a12.0
        for <io-uring@vger.kernel.org>; Sat, 05 Aug 2023 17:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691281762; x=1691886562;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zk/LVE8qLApcsnTCJ6XYpj75RjWCWj32/TIL3dUI3P8=;
        b=EyciKoeZSFZ0Keo4EnRZWwd/r3pSPD1NAsWHNiFSaU+hGf+20jJWT02QZhyUWcXH/R
         eq7EV7bMot3Esl9eWE1narxvdIS1Y+MvXPZJSTqUX4RjXcMKmnfawL1dsk2yyW2gyc5j
         e0CCUvibdwQWjPP45GMobGvRXwujm2M9qfzFkt9xHYscfdCe+XLpKVr5eyL7XnUWf/FF
         Ft1Md4CobsORKqtFkDh7yJ9tz4mqfKRhR3BDdx/WFVsj11gW5UFBnx7mReSc1a1Y7vO3
         Tt9ztZztjCYWKCsGbVhHEk6gbN3j7eJModQrQvtCBh0ptEMRBP0OThxKTcMM+Vpp/kqR
         sOpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691281762; x=1691886562;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zk/LVE8qLApcsnTCJ6XYpj75RjWCWj32/TIL3dUI3P8=;
        b=dOidV8BPB/sO51sKPHMUU9vp1o9IYzvrwcvaJw4CtPBBJ4cw5GP/FiN8H8IyjV0Fwv
         DLlu8hdqMps/v2XlAiGZU/1M4v7wwvip+dtCsl5XxNyb/d4vMbZtCE/mVKQo6zoM7twc
         8zaP9q1jb2AZSWvnQbxFkeN6stOY6IhMNfTt3QbMyvOPeT6gHGd0FVQUOdr2lW4/Eh1V
         vscyWvV4w+jAGBQ0z9Agw0xhY56srcC4+WRrhXCHeuQMfODqPXi8YNovkbR4EfCcIm8U
         eyAC1QVW+vT4z9nh2HINksYC8QQSCunOW2cq1z+fIM4eBLbsLLjQGB9tUC2ZmVuPtBHb
         msMw==
X-Gm-Message-State: ABy/qLYbcDMhJ2QHi6FRV7cQfmjegW//8eozHXzgK0IAaT9+CGvoPO+d
        exfUpSTqdeDxAKFH2NEXMu7ADA==
X-Google-Smtp-Source: APBJJlGCtrBpTFP2QsvSuH1K5Un/i/BxeNqk7JsUnTzMqflzatRKXx7vxr79aqoYgH/QB9Q2RGqx3w==
X-Received: by 2002:a05:6a20:3d1e:b0:137:514a:982d with SMTP id y30-20020a056a203d1e00b00137514a982dmr30033138pzi.6.1691281761752;
        Sat, 05 Aug 2023 17:29:21 -0700 (PDT)
Received: from [172.20.1.218] (071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id j13-20020aa78d0d000000b006829b27f252sm3730072pfe.93.2023.08.05.17.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Aug 2023 17:29:21 -0700 (PDT)
Message-ID: <41b5f092-5422-e461-b9bf-3a5a04c0b9e2@kernel.dk>
Date:   Sat, 5 Aug 2023 18:29:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v2 2/2] io_uring: correct check for O_TMPFILE
Content-Language: en-US
To:     Aleksa Sarai <cyphar@cyphar.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com>
 <20230806-resolve_cached-o_tmpfile-v2-2-058bff24fb16@cyphar.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230806-resolve_cached-o_tmpfile-v2-2-058bff24fb16@cyphar.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/5/23 4:48?PM, Aleksa Sarai wrote:
> O_TMPFILE is actually __O_TMPFILE|O_DIRECTORY. This means that the old
> check for whether RESOLVE_CACHED can be used would incorrectly think
> that O_DIRECTORY could not be used with RESOLVE_CACHED.
> 
> Cc: stable@vger.kernel.org # v5.12+
> Fixes: 3a81fd02045c ("io_uring: enable LOOKUP_CACHED path resolution for filename lookups")
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> ---
>  io_uring/openclose.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> index 10ca57f5bd24..a029c230119f 100644
> --- a/io_uring/openclose.c
> +++ b/io_uring/openclose.c
> @@ -35,9 +35,9 @@ static bool io_openat_force_async(struct io_open *open)
>  {
>  	/*
>  	 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
> -	 * it'll always -EAGAIN
> +	 * it'll always -EAGAIN.

Please don't make this change, it just detracts from the actual change.
And if we are making changes in there, why not change O_TMPFILE as well
since this is what the change is about?

-- 
Jens Axboe

