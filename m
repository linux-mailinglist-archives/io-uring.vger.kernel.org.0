Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292862B6A8D
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 17:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgKQQpQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 11:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbgKQQpQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 11:45:16 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB9DC0613CF
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 08:45:15 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p19so2411868wmg.0
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 08:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7/EWA3/6IEBeeqzOfjqQDaLSG9tubK6ClS8zAKPhxSg=;
        b=UocaX8ZjR3gHZXqEKaEw3ZPZSGdW+g6nP2UWnpGygzUNFGNPZl+mVbwZoQZFWBUIdU
         8LI/WrsMBILTnGA6Z4Q7OLpq1AqnGxRSW1sNWGEiA7eMxc867RrPn5seinI5WQUhGIe7
         mIZ0e7rj61+9uum1ISt6aMAC1auInAbgqjBm2ifLcsU6H4SI1Al1Zh13tExTgs5VkcSs
         MMBuGSrZ4S1rJO73MShSlM52Q8ZgoU82rJP/rteS0C/guIi9XpgNRY0nu5Mk+8FdMhjE
         Y3173UoMlzCxFPR4Ib9Vz1dobWmd2nOjL2UVeSh3Ymj9uSSVaJjA/fhAS7Ya2dNIHzrX
         nbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7/EWA3/6IEBeeqzOfjqQDaLSG9tubK6ClS8zAKPhxSg=;
        b=efywcqaRD3XbMFH+vikU6xG8PO2RjpyVsUJ5oh3NpQiOD5e4KLW3Lm6st1eVpmjnZ9
         yO9s8afKpOzdTmmGhnbzAWRYFctBEw0jPXPNt47E4ApERgUR7biPAeeuqiezv9QZZyyg
         fUIkC5PwtyboqbvgnNeneY7lizP6SRhqJLpDFSn1KZVbinp6QmFkb9fSYxFr+V2d8jr2
         sbqhiTBNDAi/vBRqLvSt5dQdhUhatEwYWRpzD9keIX2XBcbG0xSV2MG6/HcHMQVYftfm
         /zrCE1EYwxecOBoHW6E93ZH+DPRxPQOeOuEvbNZpjTGQso0nGrU9t27cTQLoFPAHKwyH
         qyHQ==
X-Gm-Message-State: AOAM530fPhIhCbRY7aJegl5y6l3gx4ZWkVVweDKWtNIcSjJevFns0wei
        Y4dzEbPRwvfX1dgSASp+RyQuJQ8Eqpd7VA==
X-Google-Smtp-Source: ABdhPJy3LOhKCrMPJCyXhjd6Y3yM50KID4UypbkmHFkg6QbH0gzVIlOlIdhqIQCTDo0pmXXgy3rr7Q==
X-Received: by 2002:a1c:df57:: with SMTP id w84mr523329wmg.105.1605631514549;
        Tue, 17 Nov 2020 08:45:14 -0800 (PST)
Received: from [192.168.1.33] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id t74sm4519871wmt.8.2020.11.17.08.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 08:45:13 -0800 (PST)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
 <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
 <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
 <36da9b39-241b-492f-62eb-3dacbbf78df3@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for
 registered files in IOPOLL mode
Message-ID: <472b9e1c-228f-f464-a5f6-ec35507754bb@gmail.com>
Date:   Tue, 17 Nov 2020 16:42:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <36da9b39-241b-492f-62eb-3dacbbf78df3@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/11/2020 16:21, Xiaoguang Wang wrote:
> hi,
> 
>> On 17/11/2020 06:17, Xiaoguang Wang wrote:
>>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>>> percpu_ref_put() for registered files, but it's hard to say they're very
>>> light-weight synchronization primitives. In one our x86 machine, I get below
>>> perf data(registered files enabled):
>>> Samples: 480K of event 'cycles', Event count (approx.): 298552867297
>>> Overhead  Comman  Shared Object     Symbol
>>>     0.45%  :53243  [kernel.vmlinux]  [k] io_file_get
>>
>> Do you have throughput/latency numbers? In my experience for polling for
>> such small overheads all CPU cycles you win earlier in the stack will be
>> just burned on polling, because it would still wait for the same fixed*
>> time for the next response by device. fixed* here means post-factum but
>> still mostly independent of how your host machine behaves.
>>
>> e.g. you kick io_uring at a moment K, at device responses at a moment
>> K+M. And regardless of what you do in io_uring, the event won't complete
>> earlier than after M.
> I'm not sure this assumption is correct for real device. IO requests can be
> completed in any time, seems that there isn't so-called fixed* time. Say
> we're submitting sqe-2 and sqe-1 has been issued to device, the sooner we finish
> submitting sqe-2, the sooner and better we start to poll sqe-2 and sqe-2 can be
> completed timely.

Definitely, that what I mean by "That's not the whole story". There are
even several patterns how polling in general is used

- trying to poll prior to completions to reduce latency
- poll as a mean to coalesce, reduce overhead on IRQ, etc.

that's why I asked for number to see whether you get anything from it :)

> 
>>
>> That's not the whole story, but as you penalising non-IOPOLL and complicate
>> it, I just want to confirm that you really get any extra performance from it.
>> Moreover, your drop (0.45%->0.25%) is just 0.20%, and it's comparable with
>> the rest of the function (left 0.25%), that's just a dozen of instructions.
> I agree that this improvement is minor, and will penalise non-IOPOLL a bit, so I'm
> very ok that we drop this patchset.
> 
> Here I'd like to have some explanations why I submitted such patch set.
> I found in some our arm machine, whose computing power is not that strong,
> io_uring(sqpoll and iopoll enabled) even couldn't achieve the capacity of
> nvme ssd(but spdk can), so I tried to reduce extral overhead in IOPOLL mode.
> Indeed there're are many factors which will influence io performance, not just
> io_uring framework, such as block-layer merge operations, various io statistics, etc.
> 
> Sometimes I even think whether there should be a light io_uring mainly foucs
> on iopoll mode, in which it works like in one kernel task context, then we may get
> rid of many atomic operations, memory-barrier, etc. I wonder whether we can
> provide a high performance io stack based on io_uring, which will stand shoulder
> to shoulder with spdk.
> 
> As for the throughput/latency numbers for this patch set, I tried to have
> some tests in a real nvme ssd, but don't get a steady resule, sometimes it
> shows minor improvements, sometimes it does not. My nvme ssd spec says 4k
> rand read iops is 880k, maybe needs a higher nvme ssd to test...

Did you tune your host machine for consistency? Pinning threads, fixing in
place CPU clocks, set priorities, etc. How minor your improvements are?
I don't ask to disclose actual numbers, but there is a huge difference in
getting 0.0000001% throughput vs a visible 1%.

> 
> Regards,
> Xiaoguang Wang
> 
>>
>>>
>>> Currently I don't find any good and generic solution for this issue, but
>>> in IOPOLL mode, given that we can always ensure get/put registered files
>>> under uring_lock, we can use a simple and plain u64 counter to synchronize
>>> with registered files update operations in __io_sqe_files_update().
>>>
>>> With this patch, perf data show shows:
>>> Samples: 480K of event 'cycles', Event count (approx.): 298811248406
>>> Overhead  Comma  Shared Object     Symbol
>>>     0.25%  :4182  [kernel.vmlinux]  [k] io_file_get
>>>
>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 40 ++++++++++++++++++++++++++++++++++------
>>>   1 file changed, 34 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 219609c38e48..0fa48ea50ff9 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -201,6 +201,11 @@ struct fixed_file_table {
>>>     struct fixed_file_ref_node {
>>>       struct percpu_ref        refs;
>>> +    /*
>>> +     * Track the number of reqs that reference this node, currently it's
>>> +     * only used in IOPOLL mode.
>>> +     */
>>> +    u64                count;
>>>       struct list_head        node;
>>>       struct list_head        file_list;
>>>       struct fixed_file_data        *file_data;
>>> @@ -1926,10 +1931,17 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
>>>   static inline void io_put_file(struct io_kiocb *req, struct file *file,
>>>                 bool fixed)
>>>   {
>>> -    if (fixed)
>>> -        percpu_ref_put(&req->ref_node->refs);
>>> -    else
>>> +    if (fixed) {
>>> +        /* See same comments in io_file_get(). */
>>> +        if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>>> +            if (!--req->ref_node->count)
>>> +                percpu_ref_kill(&req->ref_node->refs);
>>> +        } else {
>>> +            percpu_ref_put(&req->ref_node->refs);
>>> +        }
>>> +    } else {
>>>           fput(file);
>>> +    }
>>>   }
>>>     static void io_dismantle_req(struct io_kiocb *req)
>>> @@ -6344,8 +6356,16 @@ static struct file *io_file_get(struct io_submit_state *state,
>>>           fd = array_index_nospec(fd, ctx->nr_user_files);
>>>           file = io_file_from_index(ctx, fd);
>>>           if (file) {
>>> +            /*
>>> +             * IOPOLL mode can always ensure get/put registered files under uring_lock,
>>> +             * so we can use a simple plain u64 counter to synchronize with registered
>>> +             * files update operations in __io_sqe_files_update.
>>> +             */
>>>               req->ref_node = ctx->file_data->node;
>>> -            percpu_ref_get(&req->ref_node->refs);
>>> +            if (ctx->flags & IORING_SETUP_IOPOLL)
>>> +                req->ref_node->count++;
>>> +            else
>>> +                percpu_ref_get(&req->ref_node->refs);
>>>           }
>>>       } else {
>>>           trace_io_uring_file_get(ctx, fd);
>>> @@ -7215,7 +7235,12 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>>>           ref_node = list_first_entry(&data->ref_list,
>>>                   struct fixed_file_ref_node, node);
>>>       spin_unlock(&data->lock);
>>> -    if (ref_node)
>>> +    /*
>>> +     * If count is not zero, that means we're in IOPOLL mode, and there are
>>> +     * still reqs that reference this ref_node, let the final req do the
>>> +     * percpu_ref_kill job.
>>> +     */
>>> +    if (ref_node && (!--ref_node->count))
>>>           percpu_ref_kill(&ref_node->refs);
>>>         percpu_ref_kill(&data->refs);
>>> @@ -7625,6 +7650,7 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
>>>       INIT_LIST_HEAD(&ref_node->node);
>>>       INIT_LIST_HEAD(&ref_node->file_list);
>>>       ref_node->file_data = ctx->file_data;
>>> +    ref_node->count = 1;
>>>       return ref_node;
>>>   }
>>>   @@ -7877,7 +7903,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>>>       }
>>>         if (needs_switch) {
>>> -        percpu_ref_kill(&data->node->refs);
>>> +        /* See same comments in io_sqe_files_unregister(). */
>>> +        if (!--data->node->count)
>>> +            percpu_ref_kill(&data->node->refs);
>>>           spin_lock(&data->lock);
>>>           list_add(&ref_node->node, &data->ref_list);
>>>           data->node = ref_node;
>>>
>>

-- 
Pavel Begunkov
