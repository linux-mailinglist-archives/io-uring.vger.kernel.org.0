Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AD25EB170
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 21:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIZTk1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 15:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiIZTkX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 15:40:23 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F693A169
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 12:40:23 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id a2so4060852iln.13
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 12:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=j9FDUSegpM2My40Q0GYwrtXUht9x9W4KI4N0s+zvhdA=;
        b=HtAla7BIeUYXzMZDHVJttG0Yk3NxdOh2RPkjqtpQZpyshosbK33HTckXK7oWSC6tHh
         X2pVrDEFeUaR/yYNsn8l1kD8RWRODqqN6OZc1D1QJqjLvIRN69/eGJo4+EgJiNEbBTQG
         /CLbrHu/PVkFeyGoMeViterZDPdtHLUe9QeTSak3GFJj3MAcRPi5FzskAaN0SRhyeOgy
         2nAEyW6DTfxjLEs63lf2pLuzptOpRkvMGlC5BRnYRBHzLMIv2p9A520aD1OUyyKHwyGq
         h0mCJmvFYQBUKl5LW9VBieMRSZHRTA/lsxj06A9Ti/QE91Pr5ws/lJzM6E8qoV+k+T0e
         H/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=j9FDUSegpM2My40Q0GYwrtXUht9x9W4KI4N0s+zvhdA=;
        b=Itey0fvQSnhsAP5nehg1sfXc1jWxgnxgP65jTDE1m9TR+kYHQAL3dlWbJc6uknTE2I
         JbZZoEHa87o1BVHYQV3N/8zk0jNz0Wxs33P8hiAXKVVUsBpAT4924LER9AqpAKX9yZ0P
         AsDxppOPXgn17HvwOuf7HcbUxDvwCne9I4++0+lo9uvC19zw5xrc4Fqqr8OXgODWuXX3
         Im5z+81mw/ZQJlmycYWuMUnzZQGJXg2Oc2BJOC0Z9/6AtLqOXSml6XmUvyinzaBny0iR
         BUbIzmT+P4aBiO+dpDjyYSYZl97tNe3yWQN49bHDM0U9gafdlKMLIAsOxSnhAiGocsVw
         kkKw==
X-Gm-Message-State: ACrzQf3/XbYcJ2T6NRsy/C0jLwFsRdLvYLyANg3uWuTJ2Cl9fMJFMMRV
        vCoQs89Ju64X+ASyVvGxep+rwg==
X-Google-Smtp-Source: AMsMyM7gMtJKyCn1oFEo7CEeb8NWTK927lW1NwcBYUN+o05U0VJT8NVG/dOjAUzFDL94FA9ZXke5hw==
X-Received: by 2002:a05:6e02:12e2:b0:2f1:c14a:8a9c with SMTP id l2-20020a056e0212e200b002f1c14a8a9cmr11474915iln.267.1664221222113;
        Mon, 26 Sep 2022 12:40:22 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x22-20020a0566380cb600b00349d33a92a2sm7510777jad.140.2022.09.26.12.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 12:40:21 -0700 (PDT)
Message-ID: <4623be74-d877-9042-f876-09feba2f0587@kernel.dk>
Date:   Mon, 26 Sep 2022 13:40:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 1/3] io_uring: register single issuer task at creation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
References: <20220926170927.3309091-1-dylany@fb.com>
 <20220926170927.3309091-2-dylany@fb.com>
 <35d9be6b-89ca-f2a1-ce5f-53e72610db6e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <35d9be6b-89ca-f2a1-ce5f-53e72610db6e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 1:12 PM, Pavel Begunkov wrote:
> On 9/26/22 18:09, Dylan Yudaken wrote:
>> Instead of picking the task from the first submitter task, rather use the
>> creator task or in the case of disabled (IORING_SETUP_R_DISABLED) the
>> enabling task.
>>
>> This approach allows a lot of simplification of the logic here. This
>> removes init logic from the submission path, which can always be a bit
>> confusing, but also removes the need for locking to write (or read) the
>> submitter_task.
>>
>> Users that want to move a ring before submitting can create the ring
>> disabled and then enable it on the submitting task.
> 
> I think Dylan briefly mentioned before that it might be a good
> idea to task limit registration as well. I can't think of a use
> case at the moment but I agree we may find some in the future.
> 
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 242d896c00f3..60a471e43fd9 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3706,6 +3706,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>      if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
>          return -ENXIO;
>  
> +    if (ctx->submitter_task && ctx->submitter_task != current)
> +        return -EEXIST;
> +
>      if (ctx->restricted) {
>          if (opcode >= IORING_REGISTER_LAST)
>              return -EINVAL;

Yes, I don't see any reason why not to enforce this for registration
too. Don't think there's currently a need to do so, but it'd be easy
to miss once we do add that. Let's queue that up for 6.1?

-- 
Jens Axboe


