Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3CB2F3BDB
	for <lists+io-uring@lfdr.de>; Tue, 12 Jan 2021 22:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406973AbhALVeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 16:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437051AbhALUv1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 15:51:27 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2C6C061786
        for <io-uring@vger.kernel.org>; Tue, 12 Jan 2021 12:50:47 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id w5so3896679wrm.11
        for <io-uring@vger.kernel.org>; Tue, 12 Jan 2021 12:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o8Rt2NYh+8Pjryxz87+pyURzbjPjBN6BAJ/ioHTH4VU=;
        b=kaNOH9S+r0t/I8eUExVwIfUAZn7Cns1neuHUDo9jgmmmk0LBjGHAyrVgWI7GmLHOCF
         MpmhIFytFvufuyJwlj5UF9uZUgcJLQ/Z9KMw+gpUjf4JzVgAyzu/vdB8Hq+ulMnfarMC
         gvZ23cMqTkOJVwSOGwp7tTIv/5mAKRil7Oh2sWKZcslgIOMj2wjCkQGMr5TlX6eUFDuV
         Tzow63WC7urUYO58sk3ggh/Od7oy66auLNo+2tQPZXos9pQiAm3FIJXHslIxahEdBXdb
         iHn1QLKzz5ShqmNYtt6QrZ9MAM040zxspsjXf3/ofO28yFTYQOlPLiukWA40W7HGlBa7
         rbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=o8Rt2NYh+8Pjryxz87+pyURzbjPjBN6BAJ/ioHTH4VU=;
        b=Mu83Jvg2bVlgITDCFaojRxixf90JBc6jono/ZSCf+EDRqCZ3HPfzkvapATKxo3/Ufl
         xpJUB7zKWThr2u98oSKz4vipp1iFm3WjuC02DSwCNxkAryuh1e8XYqtTz/P/tpsncT/r
         ZYFuzIrrgdegG8IVQuksWVW5P3xBG/Pagd+Qgbj34/zI1Hk2kXX5X4aErQnmnNj5Fokw
         cKsBt4dPpKb15KEP2qEVNS4pr2Uzt9XhSaeQU/JrTAUOX2+59iWZ0m2rxSTJ1X60sa22
         oJYGJFHDzYZeqGxFQBVbjQEpEZV81xPamwlbn5ZDi+rMBZo0184aLPz05evh7v+B4lBb
         7OfA==
X-Gm-Message-State: AOAM530dDffrpAVf5AVoP0bnZ3PPCLSS2H3Sg2XMatIVn4p16uSg/J9S
        jH7l4Jnj5bUuhMxtXLZ3LRa3v6QUY5elwA==
X-Google-Smtp-Source: ABdhPJxgjyClV2+DpCd6ejcfXGdwHV3RUWdrVJJJ0V6xoxBJEqnuRUG4InRWN2GGCM3CnKs4pCXGYg==
X-Received: by 2002:a5d:6a05:: with SMTP id m5mr646949wru.96.1610484645632;
        Tue, 12 Jan 2021 12:50:45 -0800 (PST)
Received: from [192.168.8.120] ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id q73sm5756713wme.44.2021.01.12.12.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 12:50:45 -0800 (PST)
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <20201219191521.82029-1-marcelo827@gmail.com>
 <20201219191521.82029-3-marcelo827@gmail.com>
 <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
 <c0cde7df-f19f-92fd-e0f6-855396d126ab@gmail.com>
 <20210108155726.GA8655@marcelo-debian.domain>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have
 expired
Message-ID: <257c0977-2546-adeb-5e04-6b41ced792c7@gmail.com>
Date:   Tue, 12 Jan 2021 20:47:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210108155726.GA8655@marcelo-debian.domain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/01/2021 15:57, Marcelo Diop-Gonzalez wrote:
> On Sat, Jan 02, 2021 at 08:26:26PM +0000, Pavel Begunkov wrote:
>> On 02/01/2021 19:54, Pavel Begunkov wrote:
>>> On 19/12/2020 19:15, Marcelo Diop-Gonzalez wrote:
>>>> Right now io_flush_timeouts() checks if the current number of events
>>>> is equal to ->timeout.target_seq, but this will miss some timeouts if
>>>> there have been more than 1 event added since the last time they were
>>>> flushed (possible in io_submit_flush_completions(), for example). Fix
>>>> it by recording the starting value of ->cached_cq_overflow -
>>>> ->cq_timeouts instead of the target value, so that we can safely
>>>> (without overflow problems) compare the number of events that have
>>>> happened with the number of events needed to trigger the timeout.
>>
>> https://www.spinics.net/lists/kernel/msg3475160.html
>>
>> The idea was to replace u32 cached_cq_tail with u64 while keeping
>> timeout offsets u32. Assuming that we won't ever hit ~2^62 inflight
>> requests, complete all requests falling into some large enough window
>> behind that u64 cached_cq_tail.
>>
>> simplifying:
>>
>> i64 d = target_off - ctx->u64_cq_tail
>> if (d <= 0 && d > -2^32)
>> 	complete_it()
>>
>> Not fond  of it, but at least worked at that time. You can try out
>> this approach if you want, but would be perfect if you would find
>> something more elegant :)
>>
> 
> What do you think about something like this? I think it's not totally
> correct because it relies on having ->completion_lock in io_timeout() so
> that ->cq_last_tm_flushed is updated, but in case of IORING_SETUP_IOPOLL,
> io_iopoll_complete() doesn't take that lock, and ->uring_lock will not
> be held if io_timeout() is called from io_wq_submit_work(), but maybe
> could still be worth it since that was already possibly a problem?
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index cb57e0360fcb..50984709879c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -353,6 +353,7 @@ struct io_ring_ctx {
>  		unsigned		cq_entries;
>  		unsigned		cq_mask;
>  		atomic_t		cq_timeouts;
> +		unsigned		cq_last_tm_flush;

It looks like that "last flush" is a good direction.
I think there can be problems at extremes like completing 2^32
requests at once, but should be ok in practice. Anyway better
than it's now.

What about the first patch about overflows and cq_timeouts? I
assume that problem is still there, isn't it?

See comments below, but if it passes liburing tests, please send
a patch.

>  		unsigned long		cq_check_overflow;
>  		struct wait_queue_head	cq_wait;
>  		struct fasync_struct	*cq_fasync;
> @@ -1633,19 +1634,26 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
>  
>  static void io_flush_timeouts(struct io_ring_ctx *ctx)
>  {
> +	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
> +

a nit,

if (list_empty()) return; + do {} while();

timeouts can be rare enough

>  	while (!list_empty(&ctx->timeout_list)) {
> +		u32 events_needed, events_got;
>  		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
>  						struct io_kiocb, timeout.list);
>  
>  		if (io_is_timeout_noseq(req))
>  			break;
> -		if (req->timeout.target_seq != ctx->cached_cq_tail
> -					- atomic_read(&ctx->cq_timeouts))
> +

extra new line

> +		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
> +		events_got = seq - ctx->cq_last_tm_flush;
> +		if (events_got < events_needed) 

probably <=

>  			break;

basically it checks that @target is in [last_flush, cur_seq],
it can use such a comment + a note about underflows and using
the modulus arithmetic, like with algebraic rings

>  
>  		list_del_init(&req->timeout.list);
>  		io_kill_timeout(req);
>  	}
> +
> +	ctx->cq_last_tm_flush = seq;
>  }
>  
>  static void io_commit_cqring(struct io_ring_ctx *ctx)
> 

-- 
Pavel Begunkov
