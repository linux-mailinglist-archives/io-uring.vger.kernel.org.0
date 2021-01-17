Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832012F903A
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 03:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbhAQCgW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 21:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbhAQCgV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 21:36:21 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EABC061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 18:35:41 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id c124so10571729wma.5
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 18:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HIHYRFRkJ2jdQOgHOFXatxF0sr/LFm/PK4t6o3avkOI=;
        b=rB/xRJIYwOA8z5B9s+f3mH6BDUWdCQSS+ZK8XrvSoou2ff02v4DnY/e6n31QNpgEgI
         vie23I4quPC4DPikLNPomL3hk3eo4jCJhXWUqb9Eg9tjnWkRQpW3WfOCMr+S87owpUWC
         FrvwiG0QNohH3NZXsPNMXQWN7DqsqhZVEEvkxAG3vCP+GEwx0CqZ+cijk6Jlw/Cj8PcN
         hxQBD2pbBRHASQmE/K5wVyo0mp4QZ+oYnz9qVzsqMm9s3d0q36NPTxh/PHR5nQw2dHve
         AcICwW65AJNuC+Hd4GVwi2uYVWYTtsbZKKDnP+mE5/JyTqVYb45CHY/1YEsr+a7yCvX9
         zUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HIHYRFRkJ2jdQOgHOFXatxF0sr/LFm/PK4t6o3avkOI=;
        b=B9guTzM1Fx3hMsMun4yaE6Q9qKOSbXuVQQZj7rEXCHPxRozJQF2iI5EQUEE/B/YVxN
         OfVrKAQ8BfPS+YCujnQufY40X8ca6E7nyi/kWQHUJP6Js9AhLmWLiwr23tUKzDEF0T0G
         9vVhByb6Jc++5AgPr//lDL7mqJqm2xDgl+7pe5DCP9exaPUkIgikdLIRdGebqcJTlmnX
         BuOB6T80XiXTM4WG20pC4ootG6aGIbJ3QLtIz9o4TMGMfpEaCc7S2p4yA5BHMRQU1WJl
         Zqgcr2dYEMxAEiv9Md6WpPV8VCnlu0v7YL1OhIcIoMiA8Wma8eBDfNSCZ/djo+sGPgdG
         YBUA==
X-Gm-Message-State: AOAM5338a88dENBedVaO6JQfJzyF80WV80Km9IuEJOzoB+5mfaaZDk8g
        9esW+6KZE1TrpJ0K+aPokcAOF+EM0Lc=
X-Google-Smtp-Source: ABdhPJxpSXLBc/cZSEs2Tz4lzNlbTWNVFE12BlccjREB+c2yTJhxwV4C1juviQJycs1J4CZxMR+xKQ==
X-Received: by 2002:a1c:2945:: with SMTP id p66mr8821728wmp.110.1610850939751;
        Sat, 16 Jan 2021 18:35:39 -0800 (PST)
Received: from [192.168.8.130] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id f7sm6495993wmg.43.2021.01.16.18.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 18:35:39 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix skipping disabling sqo on exec
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <3148c408259dd9f2e12a1877cbe8ca9c29325c5a.1610840103.git.asml.silence@gmail.com>
 <90886010-75ca-4468-0fff-61d330ed795a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <fc6a712b-2b2d-75d3-b505-d9bb0edc276b@gmail.com>
Date:   Sun, 17 Jan 2021 02:32:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <90886010-75ca-4468-0fff-61d330ed795a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/01/2021 02:13, Jens Axboe wrote:
> On 1/16/21 4:37 PM, Pavel Begunkov wrote:
>> If there are no requests at the time __io_uring_task_cancel() is called,
>> tctx_inflight() returns zero and and it terminates not getting a chance
>> to go through __io_uring_files_cancel() and do
>> io_disable_sqo_submit(). And we absolutely want them disabled by the
>> time cancellation ends.
>>
>> Also a fix potential false positive warning because of ctx->sq_data
>> check before io_disable_sqo_submit().
>>
>> Reported-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> To not grow diffstat now will be cleaned for-next
>>
>>  fs/io_uring.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index d494c4269fc5..0d50845f1f3f 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8937,10 +8937,12 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
>>  {
>>  	struct task_struct *task = current;
>>  
>> -	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
>> +	if (ctx->flags & IORING_SETUP_SQPOLL) {
>>  		/* for SQPOLL only sqo_task has task notes */
>>  		WARN_ON_ONCE(ctx->sqo_task != current);
>>  		io_disable_sqo_submit(ctx);
>> +	}
>> +	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
>>  		task = ctx->sq_data->thread;
>>  		atomic_inc(&task->io_uring->in_idle);
>>  		io_sq_thread_park(ctx->sq_data);
> 
> Maybe just nest that inside?
> 
> 	if (ctx->flags & IORING_SETUP_SQPOLL) {
>   		/* for SQPOLL only sqo_task has task notes */
>   		WARN_ON_ONCE(ctx->sqo_task != current);
>   		io_disable_sqo_submit(ctx);
> 		if (ctx->sq_data) {
> 			...
> 		}
> 	}
> 
> That'd look a bit cleaner imho.

second thought, it can't even happen because if not set we failed
during creation, and it has its own disable hooks.
sent v2 without that part

-- 
Pavel Begunkov
