Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE5E2E8881
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 21:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbhABUai (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 15:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbhABUah (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 15:30:37 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED84DC061573
        for <io-uring@vger.kernel.org>; Sat,  2 Jan 2021 12:29:56 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id w5so27025508wrm.11
        for <io-uring@vger.kernel.org>; Sat, 02 Jan 2021 12:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HTeUpg47z4fQ7d6q4iypfgsbYooqsiieX9FSZteka6M=;
        b=B4gFNaUUwb4eBuAQmnADcoWllm5XnH+HsPJ4MTPVNu52QHydxFGsZ14V0/hZzjTq//
         NdH6CkHGUs0HFSxn6/uw5Sl4o9FwvmdvepUVoNjDYz6Fk41ocEn1k1y70neYL87rlKMn
         j50S5Ywg0329gP4WNdrepur7Nc4lUZ4FZHb/Ro+QSg6A9qhPvwuqM2WeVklkXIiKD0gP
         P1s+ZZLNJIunS6GqcklxFbxoLD2W2LeKx5zNR38ZJf1jKAOq347iQVos8X5zspiMED5A
         XwIhWc6LC5gG2j9qSx1PB7liqd00LUaF5I2DoSjSKnS6vR0USkImiLcBDgoqFxhY14E5
         LZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HTeUpg47z4fQ7d6q4iypfgsbYooqsiieX9FSZteka6M=;
        b=NFVh/PBGAuqPoZXeDHKG/xubQ80q72VHEBdFtHWyUO8nnjcfbv556/cxRONiPNxd2N
         vxYEfhtoookaQOLTNdAnFV8QIg0kBQI7rSoDFF5WW6sEn1zCmJodgzmj8/Rw6tNwrPTX
         s5jATChqpdaI2nJWC5YhK573wiz7qRD2u5EXqLHR5tPYPSo7JjhEZ+6DLaJrwF8Dnlpd
         IH5+5Oq4ZMsWpqg9gd+ghjcEpb7M1K8ar3s+S+Z4KmMcZ78O7AIpqkp2vNSiJr7k2P5h
         Gs3Q6djt4wYBN/WSHBCDVjFJ0cPjgPuUarT4BbKtTI/MpBO4b1Aw9fjae8bbGjKDmxSl
         +scg==
X-Gm-Message-State: AOAM530Bmf7eP2JaQAltnf2+g3e5vbRvxoOSuAAgI5UlIHeOK7zRksCz
        PneCHBN3rdcZTPboA+BL/TK1i6xuq4o=
X-Google-Smtp-Source: ABdhPJyI3wjc3MGNUPNCEiOkLO+I99q+3krmFC3keMCrPzhmQKjPrxat6q+zB0BckQ+OmS4ndcksYw==
X-Received: by 2002:adf:80d0:: with SMTP id 74mr74493775wrl.110.1609619395428;
        Sat, 02 Jan 2021 12:29:55 -0800 (PST)
Received: from [192.168.8.179] ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id r2sm82596230wrn.83.2021.01.02.12.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Jan 2021 12:29:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <20201219191521.82029-1-marcelo827@gmail.com>
 <20201219191521.82029-3-marcelo827@gmail.com>
 <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have
 expired
Message-ID: <c0cde7df-f19f-92fd-e0f6-855396d126ab@gmail.com>
Date:   Sat, 2 Jan 2021 20:26:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/01/2021 19:54, Pavel Begunkov wrote:
> On 19/12/2020 19:15, Marcelo Diop-Gonzalez wrote:
>> Right now io_flush_timeouts() checks if the current number of events
>> is equal to ->timeout.target_seq, but this will miss some timeouts if
>> there have been more than 1 event added since the last time they were
>> flushed (possible in io_submit_flush_completions(), for example). Fix
>> it by recording the starting value of ->cached_cq_overflow -
>> ->cq_timeouts instead of the target value, so that we can safely
>> (without overflow problems) compare the number of events that have
>> happened with the number of events needed to trigger the timeout.

https://www.spinics.net/lists/kernel/msg3475160.html

The idea was to replace u32 cached_cq_tail with u64 while keeping
timeout offsets u32. Assuming that we won't ever hit ~2^62 inflight
requests, complete all requests falling into some large enough window
behind that u64 cached_cq_tail.

simplifying:

i64 d = target_off - ctx->u64_cq_tail
if (d <= 0 && d > -2^32)
	complete_it()

Not fond  of it, but at least worked at that time. You can try out
this approach if you want, but would be perfect if you would find
something more elegant :)

>>
>> Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
>> ---
>>  fs/io_uring.c | 30 +++++++++++++++++++++++-------
>>  1 file changed, 23 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index f394bf358022..f62de0cb5fc4 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -444,7 +444,7 @@ struct io_cancel {
>>  struct io_timeout {
>>  	struct file			*file;
>>  	u32				off;
>> -	u32				target_seq;
>> +	u32				start_seq;
>>  	struct list_head		list;
>>  	/* head of the link, used by linked timeouts only */
>>  	struct io_kiocb			*head;
>> @@ -1629,6 +1629,24 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
>>  	} while (!list_empty(&ctx->defer_list));
>>  }
>>  
>> +static inline u32 io_timeout_events_left(struct io_kiocb *req)
>> +{
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	u32 events;
>> +
>> +	/*
>> +	 * events -= req->timeout.start_seq and the comparison between
>> +	 * ->timeout.off and events will not overflow because each time
>> +	 * ->cq_timeouts is incremented, ->cached_cq_tail is incremented too.
>> +	 */
>> +
>> +	events = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
>> +	events -= req->timeout.start_seq;
> 
> It looks to me that events before the start_seq subtraction can have got wrapped
> around start_seq.
> 
> e.g.
> 1) you submit a timeout with off=0xff...ff (start_seq=0 for convenience)
> 
> 2) some time has passed, let @events = 0xff..ff - 1
> so the timeout still waits
> 
> 3) we commit 5 requests at once and call io_commit_cqring() only once for
> them, so we get @events == 0xff..ff - 1 + 5, i.e. 4
> 
> @events == 4 < off == 0xff...ff,
> so we didn't trigger out timeout even though should have
> 
>> +	if (req->timeout.off > events)
>> +		return req->timeout.off - events;
>> +	return 0;
>> +}
>> +
>>  static void io_flush_timeouts(struct io_ring_ctx *ctx)
>>  {
>>  	while (!list_empty(&ctx->timeout_list)) {
>> @@ -1637,8 +1655,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
>>  
>>  		if (io_is_timeout_noseq(req))
>>  			break;
>> -		if (req->timeout.target_seq != ctx->cached_cq_tail
>> -					- atomic_read(&ctx->cq_timeouts))
>> +		if (io_timeout_events_left(req) > 0)
>>  			break;
>>  
>>  		list_del_init(&req->timeout.list);
>> @@ -5785,7 +5802,6 @@ static int io_timeout(struct io_kiocb *req)
>>  	struct io_ring_ctx *ctx = req->ctx;
>>  	struct io_timeout_data *data = req->async_data;
>>  	struct list_head *entry;
>> -	u32 tail, off = req->timeout.off;
>>  
>>  	spin_lock_irq(&ctx->completion_lock);
>>  
>> @@ -5799,8 +5815,8 @@ static int io_timeout(struct io_kiocb *req)
>>  		goto add;
>>  	}
>>  
>> -	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
>> -	req->timeout.target_seq = tail + off;
>> +	req->timeout.start_seq = ctx->cached_cq_tail -
>> +		atomic_read(&ctx->cq_timeouts);
>>  
>>  	/*
>>  	 * Insertion sort, ensuring the first entry in the list is always
>> @@ -5813,7 +5829,7 @@ static int io_timeout(struct io_kiocb *req)
>>  		if (io_is_timeout_noseq(nxt))
>>  			continue;
>>  		/* nxt.seq is behind @tail, otherwise would've been completed */
>> -		if (off >= nxt->timeout.target_seq - tail)
>> +		if (req->timeout.off >= io_timeout_events_left(nxt))
>>  			break;
>>  	}
>>  add:
>>
> 

-- 
Pavel Begunkov
