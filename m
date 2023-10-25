Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D227D6F49
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 16:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344812AbjJYOKX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 10:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344839AbjJYOKV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 10:10:21 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACD61BB
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 07:10:14 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-53fc7c67a41so1993608a12.0
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 07:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698243013; x=1698847813; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HA1dLvcSANhTSHJ8x1QplzUNCONRyqVr7CIqVCT/Mvc=;
        b=c9nLLQD1NASKdJb3nX6hv7c5xy12YMKJuUN3Km9b/fFw5LiOZGaqVUWlP8iqWMinRn
         qx0kb3do9ISv4qqPE5muK2/fYwkKROQTnetwJ3CIuS4nEjF7cpfXOzOjsWqosDycvYiX
         hUCJFnlxLBm7yubx1RoLSR0f5Nrx1ZUY+1nuaDkS8gtBX3lZrddzBqfoZgQ7ZrHab+Nw
         MHjNHvnwpAVSXPuO7VJr0vQqA7EQRAklLRaDkBx7jf/zk/do/tmtMFo0Et/G1DU+nJkt
         /xkMahYEzf2OM8famEDcsPfQawCLKRvYZycNk6/kedfDaSnzOnwkz3UU9BEoaUH7RI9Y
         qArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698243013; x=1698847813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HA1dLvcSANhTSHJ8x1QplzUNCONRyqVr7CIqVCT/Mvc=;
        b=uVDjU81CLG3fG3CFLYDPSYXDYMpChXe7R+b9nIbFZ/4Ce8hOUrtMMzGTpqu4bpj9ob
         zJA7BouIX3j15buvn6HCWdZgbXi/8/yi8cSDeHq4gP2YrPGi/lPGcVf6bXo6QhcutJ3K
         /sdldxWKp0vIjH4RpNDlcdH5iWbTwCPZ7prej/bhgHVdUjyFHFcL9gxpQUAoukACEFEV
         mayaTnKU3KMlDp47S7+Z/Zcolb7d7aDh21/tAM7DovZwJje3efYxIeKG/YUHHYKmBuad
         RD5ZKsKh/Yjx8ZJs9dkrV62lkT5WmXIqJ9RJlYJrcJtEeg56nrhjtKM0RvMDTPe5iEwR
         IRtg==
X-Gm-Message-State: AOJu0Yx6nsBitvk+9Fm2dYCzVMGk81ja4+xyFXHApPYJxQLRjqu3L7+S
        FQxSv5siN4IU7nJgL0Uyp3mBAiMlRr4=
X-Google-Smtp-Source: AGHT+IFTBV/EOFBCD6EuAhSBX+nxn8h/FftwanUGnu7XFhOstKGZTDJIIAjveu7Ai7iDLUhPxuOlaQ==
X-Received: by 2002:a17:907:7f15:b0:9c5:7f5d:42dc with SMTP id qf21-20020a1709077f1500b009c57f5d42dcmr18044172ejc.33.1698243012986;
        Wed, 25 Oct 2023 07:10:12 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:cff2])
        by smtp.gmail.com with ESMTPSA id sd26-20020a170906ce3a00b009a5f1d15644sm9916846ejb.119.2023.10.25.07.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 07:10:12 -0700 (PDT)
Message-ID: <0a2d4d82-b54b-7643-4cbe-455fe3ea87df@gmail.com>
Date:   Wed, 25 Oct 2023 15:09:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fdinfo: park SQ thread while retrieving cpu/pid
To:     Jens Axboe <axboe@kernel.dk>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <64f28d0f-b2b9-4ff4-8e2f-efdf1c63d3d4@kernel.dk>
 <65368e95.170a0220.4fb79.0929SMTPIN_ADDED_BROKEN@mx.google.com>
 <23557993-424d-42a8-b832-2e59f164a577@kernel.dk>
 <103b6f05-831c-e875-478a-7e9f8187575e@gmail.com>
 <de2c75e1-8f0a-4dfe-81f2-fa2637096c6d@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <de2c75e1-8f0a-4dfe-81f2-fa2637096c6d@kernel.dk>
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

On 10/25/23 14:44, Jens Axboe wrote:
> On 10/25/23 6:09 AM, Pavel Begunkov wrote:
>> On 10/23/23 16:27, Jens Axboe wrote:
>>> On 10/23/23 9:17 AM, Gabriel Krisman Bertazi wrote:
>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>
>>>>> We could race with SQ thread exit, and if we do, we'll hit a NULL pointer
>>>>> dereference. Park the SQPOLL thread while getting the task cpu and pid for
>>>>> fdinfo, this ensures we have a stable view of it.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=218032
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>>>> ---
>>>>>
>>>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>>>> index c53678875416..cd2a0c6b97c4 100644
>>>>> --- a/io_uring/fdinfo.c
>>>>> +++ b/io_uring/fdinfo.c
>>>>> @@ -53,7 +53,6 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
>>>>>    __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>>    {
>>>>>        struct io_ring_ctx *ctx = f->private_data;
>>>>> -    struct io_sq_data *sq = NULL;
>>>>>        struct io_overflow_cqe *ocqe;
>>>>>        struct io_rings *r = ctx->rings;
>>>>>        unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>>>>> @@ -64,6 +63,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>>        unsigned int cq_shift = 0;
>>>>>        unsigned int sq_shift = 0;
>>>>>        unsigned int sq_entries, cq_entries;
>>>>> +    int sq_pid = -1, sq_cpu = -1;
>>>>>        bool has_lock;
>>>>>        unsigned int i;
>>>>>    @@ -143,13 +143,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>>>>        has_lock = mutex_trylock(&ctx->uring_lock);
>>>>>          if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>>>>> -        sq = ctx->sq_data;
>>>>> -        if (!sq->thread)
>>>>> -            sq = NULL;
>>>>> +        struct io_sq_data *sq = ctx->sq_data;
>>>>> +
>>>>> +        io_sq_thread_park(sq);
>>>>> +        if (sq->thread) {
>>>>> +            sq_pid = task_pid_nr(sq->thread);
>>>>> +            sq_cpu = task_cpu(sq->thread);
>>>>> +        }
>>>>> +        io_sq_thread_unpark(sq);
>>>>
>>>> Jens,
>>>>
>>>> io_sq_thread_park will try to wake the sqpoll, which is, at least,
>>>> unnecessary. But I'm thinking we don't want to expose the ability to
>>>> schedule the sqpoll from procfs, which can be done by any unrelated
>>>> process.
>>>>
>>>> To solve the bug, it should be enough to synchronize directly on
>>>> sqd->lock, preventing sq->thread from going away inside the if leg.
>>>> Granted, it is might take longer if the sqpoll is busy, but reading
>>>> fdinfo is not supposed to be fast.  Alternatively, don't call
>>>> wake_process in this case?
>>>
>>> I did think about that but just went with the exported API. But you are
>>> right, it's a bit annoying that it'd also wake the thread, in case it
>>
>> Waking it up is not a problem but without parking sq thread won't drop
>> the lock until it's time to sleep, which might be pretty long leaving
>> the /proc read stuck on the lock uninterruptibly.
>>
>> Aside from parking vs lock, there is a lock inversion now:
>>
>> proc read                   | SQPOLL
>>                              |
>> try_lock(ring) // success   |
>>                              | woken up
>>                              | lock(sqd); // success
>> lock(sqd); // stuck         |
>>                              | try to submit requests
>>                              | -- lock(ring); // stuck
> 
> Yeah good point, forgot we nest these opposite of what you'd expect.
> Honestly I think the fix here is just to turn it into a trylock. Yes
> that'll miss some cases where we could've gotten the pid/cpu, but
> doesn't seem worth caring about.
> 
> IOW, fold in this incremental.

Should work, otherwise you probably can just park first.

Long term it'd be nice to make sqpoll to not hold sqd->lock during
submission + polling as it currently does. Park callers sleep on the
lock, but if we replace it with some struct completion the rest
should be easy enough.


> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index af1bdcc0703e..f04a43044d91 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -145,12 +145,13 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>   	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>   		struct io_sq_data *sq = ctx->sq_data;
>   
> -		mutex_lock(&sq->lock);
> -		if (sq->thread) {
> -			sq_pid = task_pid_nr(sq->thread);
> -			sq_cpu = task_cpu(sq->thread);
> +		if (mutex_trylock(&sq->lock)) {
> +			if (sq->thread) {
> +				sq_pid = task_pid_nr(sq->thread);
> +				sq_cpu = task_cpu(sq->thread);
> +			}
> +			mutex_unlock(&sq->lock);
>   		}
> -		mutex_unlock(&sq->lock);
>   	}
>   
>   	seq_printf(m, "SqThread:\t%d\n", sq_pid);
> 

-- 
Pavel Begunkov
