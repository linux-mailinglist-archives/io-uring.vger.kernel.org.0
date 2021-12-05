Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DCB468BF2
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhLEPqz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 10:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbhLEPqz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 10:46:55 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5874C061714
        for <io-uring@vger.kernel.org>; Sun,  5 Dec 2021 07:43:27 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id t5so32783456edd.0
        for <io-uring@vger.kernel.org>; Sun, 05 Dec 2021 07:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nE4OnvyxbPoZdr9CNYHZXMoiwMEEjVek+a5e6uOPpi0=;
        b=R8DCEbEAy+yAs2ipyBVBZf6JF2ABJJk0burVt3v7Q7XpvlWFPCSaTLfr8rPVtqw808
         EMbKDgaHk371kIeQqsuQJn5D0Hk29tBnz/SY1mcH0Bt0Zf7q81OiwqB9AbUrcSQ+vU6M
         17aQrREAvZDjZ0J4DXWJ0zVS0uFIZsvcfXRLbNUzK51e7+01mS4uZ4Ht9t08f8ZimxMn
         R6g88fNccE5D5SqrZIYPfYn1Dcck0VfxWM7d1BlBQiCqB1BzW0lPJJJgKoGmnEhxTyrb
         Pam6MMiqSvv6pvIAItnEgWoseAtLpuQcgpC30+jhDFzjsKLVK8FCLP0yzgH92wxCanuQ
         6cyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nE4OnvyxbPoZdr9CNYHZXMoiwMEEjVek+a5e6uOPpi0=;
        b=RTvbv2di/tEsFLeLjCtjw+q1ftKDXffVGSp81LziPJYAkqVK8m5HuxnvxHRlR6oM9i
         z9UEvYGidgBvFMG9BbVltgt81PZq2a+ee5gPxQhUBtbbMTK8mZMNxvgC9JtuAR0WI0zt
         mOerGRkFG/I2Nj4h9yvIsSAmFQ4i+8HoTLXdeRCO2CXr+J2sSnGDLzpm8rYKprbvnVQ1
         n38R8trbShf2J/8tu5L2+OxuQ6dKFtvpA7N/SCMLZP2VkKq912R/bIEaxzXJ+T+YSTyh
         iVjtA4IYZcWIW3OShYQsuvkVS41cmRDieO/FSQ78J3kWvEQmMg1EHvtG+LuPP27P4DBL
         /bVw==
X-Gm-Message-State: AOAM531jsmXWTG4q45yedVqytQgX5dQDraZqqTyf5bT3ptnVxqD6qgpe
        vOFWJIHVtvXuZ0dbBmFE1WqeGsRpeIY=
X-Google-Smtp-Source: ABdhPJx+nv3BCt0lHsxMg2i7MfQZEkA/6NtsOdKrOc73VqDyirttxU5nuFYpB4TLLJkNeoCwwKQPpA==
X-Received: by 2002:a05:6402:50c6:: with SMTP id h6mr44259902edb.228.1638719006523;
        Sun, 05 Dec 2021 07:43:26 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.50])
        by smtp.gmail.com with ESMTPSA id sh30sm5476455ejc.117.2021.12.05.07.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Dec 2021 07:43:26 -0800 (PST)
Message-ID: <6a785450-dfd6-74ac-f604-a92324853fc0@gmail.com>
Date:   Sun, 5 Dec 2021 15:42:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 0/6] task work optimization
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
 <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
 <a3515db3-2c22-fa32-746e-3210d84386e9@gmail.com>
 <8e22c1fa-faf0-4708-2101-86fd0d34ef86@linux.alibaba.com>
 <50cd05fb-243c-9b24-108f-15a1554ed7bc@gmail.com>
 <0b2067e3-6d18-3ada-9647-c519176d6a9e@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0b2067e3-6d18-3ada-9647-c519176d6a9e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/5/21 15:02, Hao Xu wrote:
> 在 2021/12/3 下午10:21, Pavel Begunkov 写道:
>> On 12/3/21 07:30, Hao Xu wrote:
>>> 在 2021/12/3 上午10:01, Pavel Begunkov 写道:
>>>> On 12/3/21 01:39, Pavel Begunkov wrote:
>>>>> On 11/26/21 10:07, Hao Xu wrote:
>>>>>> v4->v5
>>>>>> - change the implementation of merge_wq_list
>>>>>>
>> [...]
>>>> But testing with liburing tests I'm getting the stuff below,
>>>> e.g. cq-overflow hits it every time. Double checked that
>>>> I took [RESEND] version of 6/6.
>>>>
>>>> [   30.360370] BUG: scheduling while atomic: cq-overflow/2082/0x00000000
>>>> [   30.360520] Call Trace:
>>>> [   30.360523]  <TASK>
>>>> [   30.360527]  dump_stack_lvl+0x4c/0x63
>>>> [   30.360536]  dump_stack+0x10/0x12
>>>> [   30.360540]  __schedule_bug.cold+0x50/0x5e
>>>> [   30.360545]  __schedule+0x754/0x900
>>>> [   30.360551]  ? __io_cqring_overflow_flush+0xb6/0x200
>>>> [   30.360558]  schedule+0x55/0xd0
>>>> [   30.360563]  schedule_timeout+0xf8/0x140
>>>> [   30.360567]  ? prepare_to_wait_exclusive+0x58/0xa0
>>>> [   30.360573]  __x64_sys_io_uring_enter+0x69c/0x8e0
>>>> [   30.360578]  ? io_rsrc_buf_put+0x30/0x30
>>>> [   30.360582]  do_syscall_64+0x3b/0x80
>>>> [   30.360588]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>> [   30.360592] RIP: 0033:0x7f9f9680118d
>>>> [   30.360618]  </TASK>
>>>> [   30.362295] BUG: scheduling while atomic: cq-overflow/2082/0x7ffffffe
>>>> [   30.362396] Call Trace:
>>>> [   30.362397]  <TASK>
>>>> [   30.362399]  dump_stack_lvl+0x4c/0x63
>>>> [   30.362406]  dump_stack+0x10/0x12
>>>> [   30.362409]  __schedule_bug.cold+0x50/0x5e
>>>> [   30.362413]  __schedule+0x754/0x900
>>>> [   30.362419]  schedule+0x55/0xd0
>>>> [   30.362423]  schedule_timeout+0xf8/0x140
>>>> [   30.362427]  ? prepare_to_wait_exclusive+0x58/0xa0
>>>> [   30.362431]  __x64_sys_io_uring_enter+0x69c/0x8e0
>>>> [   30.362437]  ? io_rsrc_buf_put+0x30/0x30
>>>> [   30.362440]  do_syscall_64+0x3b/0x80
>>>> [   30.362445]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>> [   30.362449] RIP: 0033:0x7f9f9680118d
>>>> [   30.362470]  </TASK>
>>>> <repeated>
>>>>
>>> cannot repro this, all the liburing tests work well on my side..
>>
>> One problem is when on the first iteration tctx_task_work doen't
>> have anything in prior_task_list, it goes to handle_tw_list(),
>> which sets up @ctx but leaves @locked=false (say there is
>> contention). And then on the second iteration it goes to
>> handle_prior_tw_list() with non-NULL @ctx and @locked=false,
>> and tries to unlock not locked spin.
>>
>> Not sure that's the exactly the problem from traces, but at
>> least a quick hack resetting the ctx at the beginning of
>> handle_prior_tw_list() heals it.
> Good catch, thanks.
>>
>> note: apart from the quick fix the diff below includes
>> a couple of lines to force it to go through the new path.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 66d119ac4424..3868123eef87 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2272,6 +2272,9 @@ static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
>>   static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
>>                                   bool *locked)
>>   {
>> +       ctx_flush_and_put(*ctx, locked);
>> +       *ctx = NULL;
>> +
>>          do {
>>                  struct io_wq_work_node *next = node->next;
>>                  struct io_kiocb *req = container_of(node, struct io_kiocb,
>> @@ -2283,7 +2286,8 @@ static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ct
>>                          ctx_flush_and_put(*ctx, locked);
>>                          *ctx = req->ctx;
>>                          /* if not contended, grab and improve batching */
>> -                       *locked = mutex_trylock(&(*ctx)->uring_lock);
>> +                       *locked = false;
>> +                       // *locked = mutex_trylock(&(*ctx)->uring_lock);
> I believe this one is your debug code which I shouldn't take, should I?

Right, just for debug, helped to catch the issue. FWIW, it doesn't seem
ctx_flush_and_put() is a good solution but was good enough to verify
my assumptions.

>>                          percpu_ref_get(&(*ctx)->refs);
>>                          if (unlikely(!*locked))
>>                                  spin_lock(&(*ctx)->completion_lock);
>> @@ -2840,7 +2844,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
>>                  return;
>>          req->result = res;
>>          req->io_task_work.func = io_req_task_complete;
>> -       io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
>> +       io_req_task_work_add(req, true);
>>   }
>>
>>
>>
> 

-- 
Pavel Begunkov
