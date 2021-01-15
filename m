Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71712F7E97
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 15:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbhAOOtc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 09:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730766AbhAOOtc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 09:49:32 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A482FC061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 06:48:51 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a9so6083848wrt.5
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 06:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ipnxT2UzjNferxURU/AR0+0OjE/cSUU7lAdIrKFooiY=;
        b=rxXKFm/pLBuqgino5du4dlaaVBT64Ifv5lWC4vDdksn1gZVwku/AVpeNcm01jLNJbf
         D3nGICnaErkC1FV4DvGm128/EtWNa7P8jTQTlAZV+OOHmoTZ+8pCtYDJIvEpDaU0ehki
         4H0M17VrTu1X+xqi+0P623zpE84PAn680lYYByLt2BxarCulKrBX5LnIO4lqZgcQ+RA0
         xUWAnBw6Z0/dQFrzPvFCx2GljF2ulqNygmWHY8DqI/Y3s7U9KTHckIQh0F7dUTf+J47n
         x7nMDr1xk36X0MBGndvfi1kqp3DftHtAqA5ND+d8DoIyP2R83EkD+iY5rBN+AwiIp3ke
         YZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ipnxT2UzjNferxURU/AR0+0OjE/cSUU7lAdIrKFooiY=;
        b=o3cVpeFPhceYdfj0oEpZ4UIecK9xD72fnezrxsMuRUfpO1Y7V8kT42sC3IHMlWl+CZ
         iVwYkrMCmwn5L+5Oct6/c8ESAmVv2cZLk41CU7hQzkdCrq/LrnZ2fyd6I9LHOTkd6jmx
         1VzzOIsRCGc3q5u1h459LlLVHxdWLNIBeFrTmApmSusmCbsThTbkFJPckqOqSjOMzXYE
         wW/quH+5lDQPcWbgWt2h+zFAYMQmih9t+yd/4aNmVcjnbx1YXz2rx4OypSc+eUUavoUG
         6CobGClcHm+fY72EsSuPxWgyBl0I/yLYUD0P78DHvXH3GAYvkV65c/vRx9F2xUZEcVqP
         5uMg==
X-Gm-Message-State: AOAM5309uBxqRTFlXHfvTRGAiN4/0xa0S3vnlhrBcwEvDLdXjGZ8NytI
        jiMx9IaQe9nh9ABlxSNEPV3HlfnLnL3DWg==
X-Google-Smtp-Source: ABdhPJxisZ/hTvJMXK4QLnRmG/AQ0yNaMvlh7cAQOTNweP/oEiK8JZb8/okVQrSCCtPDeKhD48JTOg==
X-Received: by 2002:a5d:4987:: with SMTP id r7mr13800602wrq.352.1610722130043;
        Fri, 15 Jan 2021 06:48:50 -0800 (PST)
Received: from [192.168.8.123] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id b3sm9254424wrn.70.2021.01.15.06.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 06:48:49 -0800 (PST)
Subject: Re: [PATCH v3 1/1] io_uring: flush timeouts that should already have
 expired
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <20210114155007.13330-1-marcelo827@gmail.com>
 <20210114155007.13330-2-marcelo827@gmail.com>
 <72e12671-c148-e24a-c055-713922d5bfe9@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <37284e88-7e0e-99e5-83b6-76a467ee2b04@gmail.com>
Date:   Fri, 15 Jan 2021 14:45:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <72e12671-c148-e24a-c055-713922d5bfe9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/01/2021 21:40, Pavel Begunkov wrote:
> On 14/01/2021 15:50, Marcelo Diop-Gonzalez wrote:
>> Right now io_flush_timeouts() checks if the current number of events
>> is equal to ->timeout.target_seq, but this will miss some timeouts if
>> there have been more than 1 event added since the last time they were
>> flushed (possible in io_submit_flush_completions(), for example). Fix
>> it by recording the last sequence at which timeouts were flushed so
>> that the number of events seen can be compared to the number of events
>> needed without overflow.
> 
> Looks good, but there is a little change I'll ask you to make (see
> below). In a meanwhile I'll test it, so the patch on the fast track.
Tested, works good for me.

Apart from the small change I described before
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
>>
>> Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
>> ---
>>  fs/io_uring.c | 29 +++++++++++++++++++++++++----
>>  1 file changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 372be9caf340..71d8fa0733ad 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -354,6 +354,7 @@ struct io_ring_ctx {
>>  		unsigned		cq_entries;
>>  		unsigned		cq_mask;
>>  		atomic_t		cq_timeouts;
>> +		unsigned		cq_last_tm_flush;
>>  		unsigned long		cq_check_overflow;
>>  		struct wait_queue_head	cq_wait;
>>  		struct fasync_struct	*cq_fasync;
>> @@ -1639,19 +1640,36 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
>>  
>>  static void io_flush_timeouts(struct io_ring_ctx *ctx)
>>  {
>> -	while (!list_empty(&ctx->timeout_list)) {
>> +	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
> 
> This assignment should go after list_empty() -- because of the atomic part
> my compiler can't reshuffle them itself.
> 
>> +
>> +	if (list_empty(&ctx->timeout_list))
>> +		return;
> [...]
>>  static void io_commit_cqring(struct io_ring_ctx *ctx)
>> @@ -5837,6 +5855,9 @@ static int io_timeout(struct io_kiocb *req)
>>  	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
>>  	req->timeout.target_seq = tail + off;
>>  
>> +	/* Update the last seq here in case io_flush_timeouts() hasn't */
>> +	ctx->cq_last_tm_flush = tail;
> 
> Have to note that it's ok to do because we don't mix submissions and
> completions, so io_timeout should never fall under same completion_lock
> section as cq commit,
> 
> but otherwise some future locked version of io_timeout would be cutting
> off a part of the current flush window (i.e. this [last, cur] thing).
> 

-- 
Pavel Begunkov
