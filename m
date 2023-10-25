Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7977D6AE1
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 14:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjJYMK5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 08:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbjJYMK4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 08:10:56 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657E912A
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 05:10:53 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9c41e95efcbso809595466b.3
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 05:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698235852; x=1698840652; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qI297aZslGadPYQ87OYdgubY0cTujXsqylI3DFo6uzY=;
        b=iPbm++9pJxRfQVDQo19rDszJ4+D67WWIaPM4mGsKwqrZ+2ws+kyfR6PzmVh6sdJ3DJ
         SJJNzAexHFMesl/C4FLspV8IGHSU7DjTQthL6ps0Qz6Kawo3fRrHzWMsW/JDXE/rTm3j
         MHWu7qnPLrbeF7w//hzh/F28yFvB8ukq88T8w5TsoC6oG7U2OHIOv0l66StlEC4D2V72
         boc2dTwbJT6gQ1yQztknRbOEBNMvtBMjU5vXT9J/8E1y2wl+5FXW68DoaxecaVlWMiYr
         E58ta7I7v4ZGyogXtt4WeODg5rtnUegVbBJEzc3K0faqGXXK2MBAN1HPRgJkRaK/HGv+
         VN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698235852; x=1698840652;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qI297aZslGadPYQ87OYdgubY0cTujXsqylI3DFo6uzY=;
        b=ByR3Gs8FinIjBzvblhoG/UWJjcIiw7XGnRZzAnWGhVvOt0E86xx1R2hG5tUIb8aQiK
         +cxL4NhSR4dPC68tW/FCILJz2KrqvGICFgdLLVCDiOirvm2UxkGk+DC8yqXjgT1YTr/h
         iG+A5u6L8BZr+b/5WEba/xKan+VkdUyRDwHBXw14KH5lKlV6pQRBoRag/oSyYOQUbTqz
         KO8BJTO/QaOzFZQGRbqqTwKoskAusJ5Pjv/K6B/2TZF8U+h2deHNYrCb/yNWmCdjEqMT
         wcJz/wrO1qUjP7INLemzWu6U//rQMq99X+onhC+A8JRlI3ts2xMbBScRd4DVKx94iaRJ
         wybA==
X-Gm-Message-State: AOJu0YwTEwXfwWVHd7/r5UzzbOA2R05q0bdM0PLZUIYcbyMeY38tcdL5
        TSTCF63u0a9iN/Gr42uvBJfoP40jo6c=
X-Google-Smtp-Source: AGHT+IEbMk8chJ1J8kRe/GKLxnUgnX026fVZghJEPfHru2MAS5xlkslljao+archjuOGBQoNK9UdBg==
X-Received: by 2002:a17:907:9808:b0:9bd:f4b8:b0bd with SMTP id ji8-20020a170907980800b009bdf4b8b0bdmr11281018ejc.6.1698235851568;
        Wed, 25 Oct 2023 05:10:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:cff2])
        by smtp.gmail.com with ESMTPSA id t6-20020a1709067c0600b009b97521b58bsm9936541ejo.39.2023.10.25.05.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 05:10:51 -0700 (PDT)
Message-ID: <103b6f05-831c-e875-478a-7e9f8187575e@gmail.com>
Date:   Wed, 25 Oct 2023 13:09:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fdinfo: park SQ thread while retrieving cpu/pid
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <64f28d0f-b2b9-4ff4-8e2f-efdf1c63d3d4@kernel.dk>
 <65368e95.170a0220.4fb79.0929SMTPIN_ADDED_BROKEN@mx.google.com>
 <23557993-424d-42a8-b832-2e59f164a577@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <23557993-424d-42a8-b832-2e59f164a577@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/23/23 16:27, Jens Axboe wrote:
> On 10/23/23 9:17 AM, Gabriel Krisman Bertazi wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> We could race with SQ thread exit, and if we do, we'll hit a NULL pointer
>>> dereference. Park the SQPOLL thread while getting the task cpu and pid for
>>> fdinfo, this ensures we have a stable view of it.
>>>
>>> Cc: stable@vger.kernel.org
>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=218032
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>> index c53678875416..cd2a0c6b97c4 100644
>>> --- a/io_uring/fdinfo.c
>>> +++ b/io_uring/fdinfo.c
>>> @@ -53,7 +53,6 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
>>>   __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>   {
>>>   	struct io_ring_ctx *ctx = f->private_data;
>>> -	struct io_sq_data *sq = NULL;
>>>   	struct io_overflow_cqe *ocqe;
>>>   	struct io_rings *r = ctx->rings;
>>>   	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>>> @@ -64,6 +63,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>   	unsigned int cq_shift = 0;
>>>   	unsigned int sq_shift = 0;
>>>   	unsigned int sq_entries, cq_entries;
>>> +	int sq_pid = -1, sq_cpu = -1;
>>>   	bool has_lock;
>>>   	unsigned int i;
>>>   
>>> @@ -143,13 +143,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>   	has_lock = mutex_trylock(&ctx->uring_lock);
>>>   
>>>   	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>>> -		sq = ctx->sq_data;
>>> -		if (!sq->thread)
>>> -			sq = NULL;
>>> +		struct io_sq_data *sq = ctx->sq_data;
>>> +
>>> +		io_sq_thread_park(sq);
>>> +		if (sq->thread) {
>>> +			sq_pid = task_pid_nr(sq->thread);
>>> +			sq_cpu = task_cpu(sq->thread);
>>> +		}
>>> +		io_sq_thread_unpark(sq);
>>
>> Jens,
>>
>> io_sq_thread_park will try to wake the sqpoll, which is, at least,
>> unnecessary. But I'm thinking we don't want to expose the ability to
>> schedule the sqpoll from procfs, which can be done by any unrelated
>> process.
>>
>> To solve the bug, it should be enough to synchronize directly on
>> sqd->lock, preventing sq->thread from going away inside the if leg.
>> Granted, it is might take longer if the sqpoll is busy, but reading
>> fdinfo is not supposed to be fast.  Alternatively, don't call
>> wake_process in this case?
> 
> I did think about that but just went with the exported API. But you are
> right, it's a bit annoying that it'd also wake the thread, in case it

Waking it up is not a problem but without parking sq thread won't drop
the lock until it's time to sleep, which might be pretty long leaving
the /proc read stuck on the lock uninterruptibly.

Aside from parking vs lock, there is a lock inversion now:

proc read                   | SQPOLL
                             |
try_lock(ring) // success   |
                             | woken up
                             | lock(sqd); // success
lock(sqd); // stuck         |
                             | try to submit requests
                             | -- lock(ring); // stuck


> was idle. Probably mostly cosmetic, but we may as well just stick with
> grabbing the sqd mutex. I'll send a v2.


-- 
Pavel Begunkov
